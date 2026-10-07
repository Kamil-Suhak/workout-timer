import 'package:flutter/material.dart';
import '../controllers/workout_timer_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/workout_preset.dart';

class SettingsSheet extends StatelessWidget {
  final WorkoutTimerController controller;

  const SettingsSheet({
    super.key,
    required this.controller,
  });

  static Future<void> show(BuildContext context, WorkoutTimerController controller) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppColors.border),
      ),
      builder: (context) => SettingsSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final settings = controller.settings;
        final isRunning = controller.state.isRunning;

        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sheet Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WORKOUT SETTINGS',
                    style: AppTypography.cardCaption.copyWith(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Section 1: Presets
              Text(
                'PRESETS',
                style: AppTypography.cardCaption.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: WorkoutPreset.defaultPresets.map((preset) {
                    final isSelected = settings.workDuration == preset.settings.workDuration &&
                        settings.restDuration == preset.settings.restDuration &&
                        settings.totalSets == preset.settings.totalSets;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(preset.name),
                        selected: isSelected,
                        onSelected: isRunning
                            ? null
                            : (_) {
                                controller.applyPreset(preset);
                              },
                        backgroundColor: AppColors.surfaceElevated,
                        selectedColor: AppColors.actionPrimary,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.actionPrimaryText : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.actionPrimary : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Section 2: Rounds & Total Sets
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Sets',
                          style: AppTypography.cardTitle,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Number of alternating cycles',
                          style: AppTypography.cardCaption,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _SmallIconButton(
                          icon: Icons.remove,
                          onPressed: !isRunning && settings.totalSets > 1
                              ? () => controller.adjustTotalSets(-1)
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text(
                            '${settings.totalSets}',
                            style: AppTypography.timerMedium.copyWith(fontSize: 22),
                          ),
                        ),
                        _SmallIconButton(
                          icon: Icons.add,
                          onPressed: !isRunning && settings.totalSets < 99
                              ? () => controller.adjustTotalSets(1)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 3: Preparation Countdown
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preparation Timer',
                          style: AppTypography.cardTitle,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Countdown before set 1 begins',
                          style: AppTypography.cardCaption,
                        ),
                      ],
                    ),
                    DropdownButton<int>(
                      value: settings.prepareDuration.inSeconds,
                      dropdownColor: AppColors.surfaceElevated,
                      underline: const SizedBox.shrink(),
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      style: AppTypography.buttonText.copyWith(color: AppColors.textPrimary),
                      onChanged: isRunning
                          ? null
                          : (seconds) {
                              if (seconds != null) {
                                controller.setPrepareDuration(Duration(seconds: seconds));
                              }
                            },
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Off')),
                        DropdownMenuItem(value: 3, child: Text('3s')),
                        DropdownMenuItem(value: 5, child: Text('5s')),
                        DropdownMenuItem(value: 10, child: Text('10s')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 4: Sound and Haptics Toggles
              Material(
                color: AppColors.surfaceElevated,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Sound Cues', style: AppTypography.cardTitle),
                        subtitle: const Text('Pings and transition chimes', style: AppTypography.cardCaption),
                        value: settings.soundEnabled,
                        activeTrackColor: AppColors.actionPrimary,
                        onChanged: (_) => controller.toggleSound(),
                      ),
                      const Divider(height: 1),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Haptic Feedback', style: AppTypography.cardTitle),
                        subtitle: const Text('Tactile vibration on transitions', style: AppTypography.cardCaption),
                        value: settings.vibrationEnabled,
                        activeTrackColor: AppColors.actionPrimary,
                        onChanged: (_) => controller.toggleVibration(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _SmallIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            icon,
            size: 16,
            color: onPressed != null ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
