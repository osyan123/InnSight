import 'package:flutter/material.dart';
import '../../models/room.dart';

class GuestTab extends StatelessWidget {
  const GuestTab({super.key, required this.room});
  final Room room;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _label(context, "Guest Name"),
        TextFormField(
          initialValue: room.guestName ?? "",
          decoration: _deco(hint: "Enter guest name"),
        ),
        const SizedBox(height: 12),
        _label(context, "Contact Number"),
        TextFormField(decoration: _deco(hint: "+63...")),
        const SizedBox(height: 12),
        _label(context, "ID Reference"),
        TextFormField(decoration: _deco(hint: "DL/Passport Number")),
        const SizedBox(height: 12),
        _label(context, "Number of Guests"),
        TextFormField(initialValue: "1", decoration: _deco(hint: "1")),
      ],
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
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
