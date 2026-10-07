import 'package:flutter/material.dart';
import '../core/theme/app_palette.dart';

enum WorkoutPhase {
  idle,
  prepare,
  work,
  rest,
  completed;

  String get displayName {
    switch (this) {
      case WorkoutPhase.idle:
        return 'READY';
      case WorkoutPhase.prepare:
        return 'PREPARE';
      case WorkoutPhase.work:
        return 'WORK';
      case WorkoutPhase.rest:
        return 'REST';
      case WorkoutPhase.completed:
        return 'FINISHED';
    }
  }

  Color accentColorFor(AppPalette palette) {
    switch (this) {
      case WorkoutPhase.idle:
        return palette.textSecondary;
      case WorkoutPhase.prepare:
        return palette.prepare;
      case WorkoutPhase.work:
        return palette.work;
      case WorkoutPhase.rest:
        return palette.rest;
      case WorkoutPhase.completed:
        return palette.complete;
    }
  }

  Color subtleColorFor(AppPalette palette) {
    switch (this) {
      case WorkoutPhase.idle:
        return palette.surfaceElevated;
      case WorkoutPhase.prepare:
        return palette.prepareSubtle;
      case WorkoutPhase.work:
        return palette.workSubtle;
      case WorkoutPhase.rest:
        return palette.restSubtle;
      case WorkoutPhase.completed:
        return palette.completeSubtle;
    }
  }

  Color get accentColor => accentColorFor(AppPalette.carbon);
  Color get subtleColor => subtleColorFor(AppPalette.carbon);

  bool get isInterval => this == WorkoutPhase.work || this == WorkoutPhase.rest;
}
