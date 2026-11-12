import 'package:flutter/material.dart';
import 'config/app_constants.dart';
import 'config/app_theme.dart';
import 'screens/main_shell.dart';
import 'state/app_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeepSortingApp());
}

class DeepSortingApp extends StatefulWidget {
  final AppController? controller;

  const DeepSortingApp({super.key, this.controller});

  @override
  State<DeepSortingApp> createState() => _DeepSortingAppState();
}

class _DeepSortingAppState extends State<DeepSortingApp> {
  late final AppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? AppController();
    _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.buildTheme(
            isLightLab: _controller.settings.isLightLabTheme,
          ),
          home: MainShell(controller: _controller),
        );
      },
    );
  }
}
