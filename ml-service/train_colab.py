"""
Script Training Google Colab: Deep Sorting (IPB University Kelompok 7)
Arsitektur: MobileNetV2 Transfer Learning
Target: Klasifikasi 7 Kelas Sampah Plastik (PET, HDPE, PVC, LDPE, PP, PS, Other)
"""

import os
import numpy as np
import tensorflow as tf
from tensorflow.keras import layers, models, callbacks
from sklearn.utils.class_weight import compute_class_weight
from sklearn.metrics import classification_report, confusion_matrix

# 1. Konfigurasi Hyperparameter
IMG_SIZE = (224, 224)
BATCH_SIZE = 32
EPOCHS_WARMUP = 15
EPOCHS_FINETUNE = 25
NUM_CLASSES = 7
CLASSES = ["HDPE", "LDPE", "PET", "PP", "PS", "PVC", "Other"]

# 2. Muat Dataset dari Folder Colab (misal: /content/dataset/)
DATASET_DIR = "/content/dataset"

train_ds = tf.keras.utils.image_dataset_from_directory(
    DATASET_DIR,
    validation_split=0.2,
    subset="training",
    seed=42,
    image_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_names=CLASSES,
    label_mode="categorical",
)

val_ds = tf.keras.utils.image_dataset_from_directory(
    DATASET_DIR,
    validation_split=0.2,
    subset="validation",
    seed=42,
    image_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_names=CLASSES,
    label_mode="categorical",
)

# 3. Hitung Class Weights untuk Mengatasi Kelas Minoritas (PS: 96, Other: 186)
# Ekstrak label asli dari dataset latih
train_labels = []
for _, labels in train_ds.unbatch():
    train_labels.append(np.argmax(labels.numpy()))
train_labels = np.array(train_labels)

class_weights_arr = compute_class_weight(
    class_weight="balanced",
    classes=np.unique(train_labels),
    y=train_labels,
)
class_weights_dict = dict(enumerate(class_weights_arr))
print("Computed Class Weights:", {CLASSES[k]: round(v, 2) for k, v in class_weights_dict.items()})

# 4. Pipeline Data Augmentation
data_augmentation = tf.keras.Sequential([
    layers.RandomFlip("horizontal"),
    layers.RandomRotation(0.15),
    layers.RandomZoom(0.15),
    layers.RandomTranslation(0.1, 0.1),
], name="augmentation_pipeline")

# Optimasi Prefetching
AUTOTUNE = tf.data.AUTOTUNE
train_ds = train_ds.prefetch(buffer_size=AUTOTUNE)
val_ds = val_ds.prefetch(buffer_size=AUTOTUNE)

# 5. Bangun Arsitektur Transfer Learning (MobileNetV2)
def build_mobilenet_model():
    inputs = tf.keras.Input(shape=(224, 224, 3))
    x = data_augmentation(inputs)
    # Preprocessing spesifik MobileNetV2: skalar [-1, 1]
    x = tf.keras.applications.mobilenet_v2.preprocess_input(x)

    base_model = tf.keras.applications.MobileNetV2(
        input_shape=(224, 224, 3),
        include_top=False,
        weights="imagenet",
    )
    base_model.trainable = False  # Bekukan bobot awal

    x = base_model(x, training=False)
    x = layers.GlobalAveragePooling2D(name="gap")(x)
    x = layers.BatchNormalization()(x)
    x = layers.Dropout(0.35)(x)
    x = layers.Dense(128, activation="relu")(x)
    x = layers.Dropout(0.2)(x)
    outputs = layers.Dense(NUM_CLASSES, activation="softmax", name="predictions")(x)

    model = tf.keras.Model(inputs, outputs, name="DeepSorting_MobileNetV2")
    return model, base_model

model, base_model = build_mobilenet_model()

# 6. Kompilasi & Fase 1: Warm-up Head Classifier
model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3),
    loss="categorical_crossentropy",
    metrics=["accuracy", tf.keras.metrics.CategoricalAccuracy(name="macro_acc")],
)

checkpoint_cb = callbacks.ModelCheckpoint(
    "best_mobilenet_warmup.keras", save_best_only=True, monitor="val_loss"
)

print("\n--- Mulai Fase 1: Feature Extraction (Top Layers Only) ---")
history_phase1 = model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=EPOCHS_WARMUP,
    class_weight=class_weights_dict,
    callbacks=[checkpoint_cb],
)

# 7. Fase 2: Fine-Tuning (Unfreeze Top Convolutional Layers)
base_model.trainable = True
# Bekukan hanya 100 layer pertama, fine-tune layer sisanya
for layer in base_model.layers[:100]:
    layer.trainable = False

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-5),  # LR kecil untuk fine-tuning
    loss="categorical_crossentropy",
    metrics=["accuracy"],
)

early_stop_cb = callbacks.EarlyStopping(
    monitor="val_loss", patience=8, restore_best_weights=True
)
reduce_lr_cb = callbacks.ReduceLROnPlateau(
    monitor="val_loss", factor=0.5, patience=4, min_lr=1e-7
)
save_final_cb = callbacks.ModelCheckpoint(
    "deep_sorting_mobilenetv2.keras", save_best_only=True, monitor="val_loss"
)

print("\n--- Mulai Fase 2: Fine-Tuning ---")
history_phase2 = model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=EPOCHS_FINETUNE,
    class_weight=class_weights_dict,
    callbacks=[early_stop_cb, reduce_lr_cb, save_final_cb],
)

# 8. Evaluasi Final & Macro-F1
print("\n--- Evaluasi Model ---")
y_true = []
y_pred = []
for images, labels in val_ds:
    preds = model.predict(images, verbose=0)
    y_true.extend(np.argmax(labels.numpy(), axis=1))
    y_pred.extend(np.argmax(preds, axis=1))

print("\nLaporan Klasifikasi (Macro-F1, Precision, Recall):")
print(classification_report(y_true, y_pred, target_names=CLASSES))

# 9. Simpan Model Siap Deploy
OUTPUT_MODEL_PATH = "deep_sorting_mobilenetv2.keras"
model.save(OUTPUT_MODEL_PATH)
print(f"Model berhasil diekspor ke: {OUTPUT_MODEL_PATH}")
