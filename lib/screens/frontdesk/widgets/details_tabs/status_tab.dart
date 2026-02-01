import 'package:flutter/material.dart';
import '../../models/room.dart';

class StatusTab extends StatelessWidget {
  const StatusTab({super.key, required this.room});
  final Room room;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _label(context, "Room Status"),
        DropdownButtonFormField<String>(
          value: statusLabel(room.status),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          decoration: _deco(),
          items: const [
            DropdownMenuItem(value: "Vacant", child: Text("Vacant")),
            DropdownMenuItem(value: "Occupied", child: Text("Occupied")),
            DropdownMenuItem(value: "Reserved", child: Text("Reserved")),
            DropdownMenuItem(value: "Maintenance", child: Text("Maintenance")),
          ],
          onChanged: (_) {},
        ),

        const SizedBox(height: 16),
        const Divider(height: 24),

        Text(
          "Quick Actions",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
        ),
        const SizedBox(height: 12),

        // ✅ FIXED-SIZE 2x2 BUTTON GRID
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.2, // controls button width/height ratio
          children: const [
            _QuickActionButton(label: "Set Occupied"),
            _QuickActionButton(label: "Set Reserved"),
            _QuickActionButton(label: "Set Vacant"),
            _QuickActionButton(label: "Maintenance"),
          ],
        ),
      ],
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
        ),
      );

  InputDecoration _deco({String? hint}) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      );
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text(label),
    );
  }
}
