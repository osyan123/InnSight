import 'package:flutter/material.dart';

class RoomStatusLegend extends StatelessWidget {
  const RoomStatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: const [
        _LegendItem(color: Color(0xFF22C55E), label: "Vacant"),
        _LegendItem(color: Color(0xFF3B82F6), label: "Occupied"),
        _LegendItem(color: Color(0xFFF59E0B), label: "Reserved"),
        _LegendItem(color: Color(0xFFEF4444), label: "Maintenance"),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
