class Tip {
  final String title;
  final String subtitle;
  final String iconName;
  final int colorValue;

  Tip({
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.colorValue,
  });

  factory Tip.fromMap(Map<String, dynamic> map) {
    return Tip(
      title: map['title'],
      subtitle: map['subtitle'] ?? '',
      iconName: map['icon_name'] ?? 'help',
      colorValue: map['color_value'] ?? 0xFFFFFFFF,
    );
  }
}
