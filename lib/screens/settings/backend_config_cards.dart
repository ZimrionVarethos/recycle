import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/app_settings.dart';
import '../../state/app_controller.dart';
import '../../widgets/common/brutal_button.dart';
import '../../widgets/common/brutal_card.dart';

class BackendConfigCards extends StatefulWidget {
  final AppController controller;

  const BackendConfigCards({super.key, required this.controller});

  @override
  State<BackendConfigCards> createState() => _BackendConfigCardsState();
}

class _BackendConfigCardsState extends State<BackendConfigCards> {
  late final TextEditingController _pythonUrlCtrl;
  late final TextEditingController _supaUrlCtrl;
  late final TextEditingController _supaKeyCtrl;
  bool _obscureKey = true;
  bool _testingPython = false;
  bool _testingSupa = false;
  String? _pythonStatusMsg;
  bool? _pythonHealthy;
  String? _supaStatusMsg;
  bool? _supaHealthy;

  @override
  void initState() {
    super.initState();
    final s = widget.controller.settings;
    _pythonUrlCtrl = TextEditingController(text: s.pythonApiUrl);
    _supaUrlCtrl = TextEditingController(text: s.supabaseUrl);
    _supaKeyCtrl = TextEditingController(text: s.supabaseAnonKey);
  }

  @override
  void dispose() {
    _pythonUrlCtrl.dispose();
    _supaUrlCtrl.dispose();
    _supaKeyCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveUrls() async {
    final current = widget.controller.settings;
    await widget.controller.updateSettings(
      current.copyWith(
        pythonApiUrl: _pythonUrlCtrl.text.trim(),
        supabaseUrl: _supaUrlCtrl.text.trim(),
        supabaseAnonKey: _supaKeyCtrl.text.trim(),
      ),
    );
  }

  Future<void> _testPython() async {
    await _saveUrls();
    setState(() => _testingPython = true);
    final res = await widget.controller.testMlBackendHealth();
    if (!mounted) return;
    setState(() {
      _testingPython = false;
      _pythonHealthy = res.isHealthy;
      _pythonStatusMsg = res.message;
    });
  }

  Future<void> _testSupabase() async {
    await _saveUrls();
    setState(() => _testingSupa = true);
    final res = await widget.controller.testSupabaseConnection();
    if (!mounted) return;
    setState(() {
      _testingSupa = false;
      _supaHealthy = res.success;
      _supaStatusMsg = res.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.controller.settings;
    return Column(
      children: [
        BrutalCard(
          backgroundColor: AppColors.whitePure,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENDPOINT PYTHON FASTAPI (NANTI HOSTING)',
                style: AppTheme.mono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greenMid,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Jika backend Python sudah di-host (Railway, Cloud Run, VPS, atau http://10.0.2.2:8000 di emulator), ubah mode di atas ke Python FastAPI & tempel URL di sini.',
                style: AppTheme.ubuntu(
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _pythonUrlCtrl,
                decoration: const InputDecoration(
                  labelText: 'Python API Base URL',
                  hintText: 'https://deep-sorting-api.up.railway.app',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              if (_pythonStatusMsg != null) ...[
                const SizedBox(height: 8),
                _statusBanner(_pythonStatusMsg!, _pythonHealthy ?? false),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: BrutalButton(
                      label: _testingPython ? 'Mengecek...' : 'Simpan & Tes /health',
                      icon: Icons.bolt_rounded,
                      variant: s.backendMode == BackendMode.pythonFastApi
                          ? BrutalButtonVariant.mint
                          : BrutalButtonVariant.white,
                      onPressed: _testingPython ? null : _testPython,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BrutalCard(
          backgroundColor: AppColors.whitePure,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SUPABASE DUMMY BACKEND (LOG & RIWAYAT)',
                style: AppTheme.mono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greenMid,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _supaUrlCtrl,
                decoration: const InputDecoration(
                  labelText: 'Supabase Project URL',
                  hintText: 'https://xxxx.supabase.co',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _supaKeyCtrl,
                obscureText: _obscureKey,
                decoration: InputDecoration(
                  labelText: 'Supabase Anon Key',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureKey ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    ),
                    onPressed: () => setState(() => _obscureKey = !_obscureKey),
                  ),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Simpan Log Anonim ke Supabase',
                  style: AppTheme.ubuntu(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackInk,
                  ),
                ),
                subtitle: Text(
                  'Foto TIDAK dikirim (hanya label, confidence & skor softmax).',
                  style: AppTheme.ubuntu(
                    fontSize: 11,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                value: s.saveLogsToSupabase,
                onChanged: (v) => widget.controller.updateSettings(
                  s.copyWith(saveLogsToSupabase: v),
                ),
              ),
              if (_supaStatusMsg != null) ...[
                _statusBanner(_supaStatusMsg!, _supaHealthy ?? false),
                const SizedBox(height: 10),
              ],
              SizedBox(
                width: double.infinity,
                child: BrutalButton(
                  label: _testingSupa ? 'Menguji...' : 'Simpan & Tes Supabase',
                  icon: Icons.storage_rounded,
                  variant: BrutalButtonVariant.mint,
                  onPressed: _testingSupa ? null : _testSupabase,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBanner(String text, bool ok) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ok ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ok ? AppColors.greenMid : AppColors.errorRed,
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: AppTheme.mono(
          fontSize: 11,
          color: ok ? AppColors.blackInk : AppColors.errorRed,
        ),
      ),
    );
  }
}
