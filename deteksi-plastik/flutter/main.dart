import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Klasifikasi Jenis Plastik',
        theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
        home: const HomePage(),
      );
}

const Map<String, String> kInfo = {
  'PET': 'Botol air mineral dan minuman (kode daur ulang 1)',
  'HDPE': 'Botol sampo, deterjen, susu (kode 2)',
  'PVC': 'Pipa, kabel, kemasan keras (kode 3)',
  'LDPE': 'Kantong kresek, plastik pembungkus (kode 4)',
  'PP': 'Tutup botol, wadah makanan, sedotan (kode 5)',
  'PS': 'Styrofoam, wadah makanan sekali pakai (kode 6)',
  'Other': 'Kategori lain pada dataset (kode 7)',
};

class Pred {
  final String label;
  final double confidence;
  Pred(this.label, this.confidence);
}

class Result {
  final String prediction;
  final double confidence;
  final bool lowConfidence;
  final List<Pred> top3;
  Result(this.prediction, this.confidence, this.lowConfidence, this.top3);

  factory Result.fromJson(Map<String, dynamic> j) => Result(
        j['prediction'] as String,
        (j['confidence'] as num).toDouble(),
        j['low_confidence'] as bool,
        (j['top3'] as List)
            .map((e) => Pred(e['label'] as String, (e['confidence'] as num).toDouble()))
            .toList(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _picker = ImagePicker();
  final _urlCtrl = TextEditingController(text: 'http://10.0.2.2:8000');
  File? _image;
  Result? _result;
  bool _loading = false;
  String? _error;

  Future<void> _pick(ImageSource src) async {
    final x = await _picker.pickImage(source: src, maxWidth: 1280, imageQuality: 85);
    if (x == null) return;
    setState(() {
      _image = File(x.path);
      _result = null;
      _error = null;
      _loading = true;
    });
    try {
      final req = http.MultipartRequest('POST', Uri.parse('${_urlCtrl.text.trim()}/classify'))
        ..files.add(await http.MultipartFile.fromPath('file', x.path));
      final streamed = await req.send().timeout(const Duration(seconds: 60));
      final res = await http.Response.fromStream(streamed);
      if (res.statusCode != 200) {
        throw Exception('Server ${res.statusCode}: ${res.body}');
      }
      setState(() => _result = Result.fromJson(jsonDecode(res.body) as Map<String, dynamic>));
    } catch (e) {
      setState(() => _error = 'Gagal: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('Klasifikasi Jenis Plastik')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _urlCtrl,
            decoration: const InputDecoration(
                labelText: 'Alamat server', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _loading ? null : () => _pick(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Kamera'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _loading ? null : () => _pick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galeri'),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          const Text(
            'Tip: foto satu objek plastik dari dekat, fokus, dengan pencahayaan baik.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          if (_loading) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          if (_image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_image!, height: 280, fit: BoxFit.contain),
            ),
          const SizedBox(height: 12),
          if (r != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.prediction, style: Theme.of(context).textTheme.headlineMedium),
                    Text('Keyakinan model: ${(r.confidence * 100).toStringAsFixed(1)}%'),
                    if (r.lowConfidence)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Keyakinan rendah. Coba foto lebih dekat, fokus, dan terang.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    if (kInfo[r.prediction] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(kInfo[r.prediction]!),
                      ),
                    const Divider(height: 24),
                    for (final p in r.top3)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(children: [
                          SizedBox(width: 56, child: Text(p.label)),
                          Expanded(
                            child: LinearProgressIndicator(value: p.confidence, minHeight: 8),
                          ),
                          SizedBox(
                            width: 56,
                            child: Text('${(p.confidence * 100).toStringAsFixed(1)}%',
                                textAlign: TextAlign.right),
                          ),
                        ]),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
