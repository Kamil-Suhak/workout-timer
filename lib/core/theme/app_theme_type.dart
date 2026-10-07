enum AppThemeType {
  carbon(
    displayName: 'Carbon Dark',
    description: 'Matte obsidian and athletic vermilion',
  ),
  pastelRose(
    displayName: 'Pastel Rose',
    description: 'Soft dusty rose and soothing muted sage',
  );

  final String displayName;
  final String description;

  const AppThemeType({
    required this.displayName,
    required this.description,
  });
}
