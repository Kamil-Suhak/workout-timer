import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

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

  Color get accentColor {
    switch (this) {
      case WorkoutPhase.idle:
        return AppColors.textSecondary;
      case WorkoutPhase.prepare:
        return AppColors.prepare;
      case WorkoutPhase.work:
        return AppColors.work;
      case WorkoutPhase.rest:
        return AppColors.rest;
      case WorkoutPhase.completed:
        return AppColors.complete;
    }
  }

  Color get subtleColor {
    switch (this) {
      case WorkoutPhase.idle:
        return AppColors.surfaceElevated;
      case WorkoutPhase.prepare:
        return AppColors.prepareSubtle;
      case WorkoutPhase.work:
        return AppColors.workSubtle;
      case WorkoutPhase.rest:
        return AppColors.restSubtle;
      case WorkoutPhase.completed:
        return AppColors.completeSubtle;
    }
  }

  bool get isInterval => this == WorkoutPhase.work || this == WorkoutPhase.rest;
}
