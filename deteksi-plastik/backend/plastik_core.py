"""
plastik_core.py
Fungsi inti proyek Klasifikasi Jenis Sampah Plastik (CNN).
Dipakai bersama oleh notebook Colab dan app.py supaya preprocessing
saat training dan saat uji kamera PERSIS sama.
"""
import os
import cv2
import numpy as np

# ---------------- Konfigurasi preprocessing ----------------
IMG_SIZE = 224
USE_BLUR = False           # pertahankan detail tekstur plastik
USE_CLAHE = False          # hindari mengubah distribusi warna pretrained
CLAHE_CLIP = 2.0
CLAHE_TILE = (8, 8)
IMG_EXT = (".jpg", ".jpeg", ".png", ".bmp", ".webp")


def load_image_rgb(path):
    """Baca gambar (aman untuk path unicode) dan kembalikan array RGB uint8, atau None jika rusak."""
    try:
        data = np.fromfile(path, dtype=np.uint8)
        img = cv2.imdecode(data, cv2.IMREAD_COLOR)
    except Exception:
        return None
    if img is None:
        return None
    return cv2.cvtColor(img, cv2.COLOR_BGR2RGB)


def letterbox(img, size=IMG_SIZE):
    """Resize ke size x size dengan mempertahankan rasio aspek; sisa area diisi replikasi piksel tepi."""
    h, w = img.shape[:2]
    s = size / max(h, w)
    nh, nw = max(1, int(round(h * s))), max(1, int(round(w * s)))
    interp = cv2.INTER_AREA if s < 1 else cv2.INTER_LINEAR
    r = cv2.resize(img, (nw, nh), interpolation=interp)
    top = (size - nh) // 2
    bottom = size - nh - top
    left = (size - nw) // 2
    right = size - nw - left
    return cv2.copyMakeBorder(r, top, bottom, left, right, cv2.BORDER_REPLICATE)


def preprocess_rgb(img, size=IMG_SIZE, blur=None, clahe=None):
    """Pipeline preprocessing: letterbox -> Gaussian blur -> CLAHE(L di LAB). Output uint8 RGB size x size."""
    blur = USE_BLUR if blur is None else blur
    clahe = USE_CLAHE if clahe is None else clahe
    x = letterbox(img, size)
    if blur:
        x = cv2.GaussianBlur(x, (3, 3), 0)
    if clahe:
        lab = cv2.cvtColor(x, cv2.COLOR_RGB2LAB)
        l, a, b = cv2.split(lab)
        cl = cv2.createCLAHE(clipLimit=CLAHE_CLIP, tileGridSize=CLAHE_TILE)
        l = cl.apply(l)
        x = cv2.cvtColor(cv2.merge([l, a, b]), cv2.COLOR_LAB2RGB)
    return x


def dhash_bits(img_rgb, hash_size=8):
    """Difference hash 64-bit (array 0/1) untuk deteksi gambar mirip."""
    g = cv2.cvtColor(img_rgb, cv2.COLOR_RGB2GRAY)
    g = cv2.resize(g, (hash_size + 1, hash_size), interpolation=cv2.INTER_AREA)
    return (g[:, 1:] > g[:, :-1]).astype(np.uint8).flatten()


# ---------------- Layer kustom (preprocess VGG16) ----------------
try:
    import tensorflow as tf

    @tf.keras.utils.register_keras_serializable(package="plastik")
    class VGGPreprocess(tf.keras.layers.Layer):
        """RGB 0-255 -> BGR dikurangi mean ImageNet (setara vgg16.preprocess_input)."""

        def call(self, x):
            x = x[..., ::-1]
            return x - tf.constant([103.939, 116.779, 123.68], dtype=x.dtype)

        def compute_output_shape(self, input_shape):
            return input_shape
except ImportError:  # TensorFlow belum terpasang (mis. hanya memakai fungsi preprocessing)
    pass


# ---------------- Antarmuka uji kamera (Gradio) ----------------
def build_demo(model, class_names, min_conf=0.50):
    """Aplikasi kamera/unggah: klasifikasi otomatis tanpa memilih label sebenarnya."""
    import gradio as gr

    def classify(image):
        if image is None:
            return {}, "Ambil foto atau unggah satu objek plastik untuk mulai."
        # Gradio type=numpy memberi RGB; preprocessing sama persis dengan training.
        x = preprocess_rgb(image)[None].astype("float32")
        p = model.predict(x, verbose=0)[0]
        order = np.argsort(p)[::-1]
        pred = class_names[int(order[0])]
        conf = float(p[order[0]])
        status = f"## Prediksi otomatis: **{pred}**\nKeyakinan model: **{conf * 100:.1f}%**"
        if conf < min_conf:
            status += "\n\nKeyakinan rendah. Coba foto lebih dekat, fokus, dan dengan pencahayaan yang baik."
        return {class_names[i]: float(p[i]) for i in order[:min(3, len(class_names))]}, status

    with gr.Blocks(title="Klasifikasi Jenis Plastik") as demo:
        gr.Markdown("# Scan jenis plastik\nAmbil foto dengan kamera atau unggah gambar. Prediksi muncul otomatis; tidak perlu memasukkan jenis plastik.")
        with gr.Row():
            img = gr.Image(sources=["webcam", "upload"], type="numpy", label="Foto satu objek plastik")
            with gr.Column():
                status = gr.Markdown("Ambil foto atau unggah gambar untuk mulai.")
                out = gr.Label(num_top_classes=min(3, len(class_names)), label="Prediksi teratas")
        img.change(classify, inputs=img, outputs=[out, status])
    return demo

