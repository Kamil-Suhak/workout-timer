import 'package:flutter/material.dart';
import '../controllers/workout_timer_controller.dart';
import '../core/theme/app_palette.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_theme_type.dart';
import '../core/theme/app_typography.dart';

class SettingsSheet extends StatelessWidget {
  final WorkoutTimerController controller;

  const SettingsSheet({super.key, required this.controller});

  static Future<void> show(
    BuildContext context,
    WorkoutTimerController controller,
  ) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      builder: (context) => SettingsSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final theme = AppTheme.buildTheme(controller.themeType);
        final palette = AppPalette.ofType(controller.themeType);
        final settings = controller.settings;
        final isRunning = controller.state.isRunning;

        return Theme(
          data: theme,
          child: Container(
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(color: palette.border),
                left: BorderSide(color: palette.border),
                right: BorderSide(color: palette.border),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Padding(
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
                            color: palette.border,
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
                              color: palette.textTertiary,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20,
                              color: palette.textSecondary,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 1: Visual Theme Selector
                      Text(
                        'APPEARANCE & THEME',
                        style: AppTypography.cardCaption.copyWith(
                          color: palette.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _ThemeOptionCard(
                              key: const ValueKey('theme_carbon'),
                              name: 'Carbon Dark',
                              isSelected:
                                  controller.themeType == AppThemeType.carbon,
                              previewBg: const Color(0xFF0D0E11),
                              previewAccent: const Color(0xFFFF5222),
                              palette: palette,
                              onTap: () =>
                                  controller.setTheme(AppThemeType.carbon),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ThemeOptionCard(
                              key: const ValueKey('theme_pastel_rose'),
                              name: 'Pastel Rose',
                              isSelected:
                                  controller.themeType ==
                                  AppThemeType.pastelRose,
                              previewBg: const Color(0xFFFAF4F5),
                              previewAccent: const Color(0xFFD9777F),
                              palette: palette,
                              onTap: () =>
                                  controller.setTheme(AppThemeType.pastelRose),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Section 3: Rounds & Total Sets
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.surfaceElevated,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: palette.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Sets',
                                  style: AppTypography.cardTitle.copyWith(
                                    color: palette.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Number of alternating cycles',
                                  style: AppTypography.cardCaption.copyWith(
                                    color: palette.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _SmallIconButton(
                                  icon: Icons.remove,
                                  palette: palette,
                                  onPressed:
                                      !isRunning && settings.totalSets > 1
                                      ? () => controller.adjustTotalSets(-1)
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0,
                                  ),
                                  child: Text(
                                    '${settings.totalSets}',
                                    style: AppTypography.timerMedium.copyWith(
                                      fontSize: 22,
                                      color: palette.textPrimary,
                                    ),
                                  ),
                                ),
                                _SmallIconButton(
                                  icon: Icons.add,
                                  palette: palette,
                                  onPressed:
                                      !isRunning && settings.totalSets < 99
                                      ? () => controller.adjustTotalSets(1)
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Section 4: Preparation Countdown
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.surfaceElevated,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: palette.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Preparation Timer',
                                  style: AppTypography.cardTitle.copyWith(
                                    color: palette.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Countdown before set 1 begins',
                                  style: AppTypography.cardCaption.copyWith(
                                    color: palette.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                            DropdownButton<int>(
                              value: settings.prepareDuration.inSeconds,
                              dropdownColor: palette.surfaceElevated,
                              underline: const SizedBox.shrink(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: palette.textSecondary,
                              ),
                              style: AppTypography.buttonText.copyWith(
                                color: palette.textPrimary,
                              ),
                              onChanged: isRunning
                                  ? null
                                  : (seconds) {
                                      if (seconds != null) {
                                        controller.setPrepareDuration(
                                          Duration(seconds: seconds),
                                        );
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

                      // Section 5: Sound and Haptics Toggles
                      Material(
                        color: palette.surfaceElevated,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: palette.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            children: [
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Sound Cues',
                                  style: AppTypography.cardTitle.copyWith(
                                    color: palette.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  'Pings and transition chimes',
                                  style: AppTypography.cardCaption.copyWith(
                                    color: palette.textTertiary,
                                  ),
                                ),
                                value: settings.soundEnabled,
                                activeTrackColor: palette.actionPrimary,
                                onChanged: (_) => controller.toggleSound(),
                              ),
                              Divider(height: 1, color: palette.borderSubtle),
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Haptic Feedback',
                                  style: AppTypography.cardTitle.copyWith(
                                    color: palette.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  'Tactile vibration on transitions',
                                  style: AppTypography.cardCaption.copyWith(
                                    color: palette.textTertiary,
                                  ),
                                ),
                                value: settings.vibrationEnabled,
                                activeTrackColor: palette.actionPrimary,
                                onChanged: (_) => controller.toggleVibration(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final Color previewBg;
  final Color previewAccent;
  final AppPalette palette;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    super.key,
    required this.name,
    required this.isSelected,
    required this.previewBg,
    required this.previewAccent,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? palette.surfaceElevated : palette.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? palette.actionPrimary : palette.border,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: previewBg,
                  border: Border.all(color: palette.border, width: 1),
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: previewAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: palette.actionPrimary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final AppPalette palette;
  final VoidCallback? onPressed;

  const _SmallIconButton({
    required this.icon,
    required this.palette,
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
            color: palette.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: palette.border),
          ),
          child: Icon(
            icon,
            size: 16,
            color: onPressed != null
                ? palette.textPrimary
                : palette.textTertiary,
          ),
        ),
      ),
    );
  }
}
