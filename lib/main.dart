import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'controllers/workout_timer_controller.dart';
import 'screens/timer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const WorkoutTimerApp());
}

class WorkoutTimerApp extends StatefulWidget {
  final WorkoutTimerController? controller;

  const WorkoutTimerApp({super.key, this.controller});

  @override
  State<WorkoutTimerApp> createState() => _WorkoutTimerAppState();
}

class _WorkoutTimerAppState extends State<WorkoutTimerApp> {
  late final WorkoutTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WorkoutTimerController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return MaterialApp(
          title: AppConstants.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.buildTheme(_controller.themeType),
          home: TimerScreen(controller: _controller),
        );
      },
    );
  }
}
