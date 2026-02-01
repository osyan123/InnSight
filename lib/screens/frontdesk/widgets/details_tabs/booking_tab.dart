import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/room.dart';

class BookingTab extends StatefulWidget {
  const BookingTab({super.key, required this.room});
  final Room room;

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  DateTime? checkIn;
  DateTime? checkOut;

  final DateFormat _fmt = DateFormat("dd/MM/yyyy hh:mm a");

  Future<void> _pickCheckIn() async {
    final picked = await _pickDateTime(context, initial: checkIn ?? DateTime.now());
    if (picked == null) return;

    setState(() {
      checkIn = picked;
      checkOut ??= picked.add(const Duration(days: 1));
    });
  }

  Future<void> _pickCheckOut() async {
    final base = checkIn ?? DateTime.now();
    final picked = await _pickDateTime(
      context,
      initial: checkOut ?? base.add(const Duration(days: 1)),
    );
    if (picked == null) return;

    setState(() => checkOut = picked);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // --- Date/Time ---
        _label(context, "Check-in Date & Time"),
        _dateTimeField(
          valueText: checkIn == null ? "" : _fmt.format(checkIn!),
          onCalendarTap: _pickCheckIn,
        ),
        const SizedBox(height: 12),

        _label(context, "Check-out Date"),
        _dateTimeField(
          valueText: checkOut == null ? "" : _fmt.format(checkOut!),
          onCalendarTap: _pickCheckOut,
        ),
        const SizedBox(height: 6),
        Text(
          "Default: 12:00 PM next day",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
        ),

        const SizedBox(height: 14),
        const Divider(height: 24),

        // --- Room Rate ---
        _label(context, "Room Rate (per night)"),
        TextFormField(
          initialValue: "120",
          keyboardType: TextInputType.number,
          decoration: _deco(
            prefix: _pesoPrefix(),
          ).copyWith(prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0)),
        ),

        const SizedBox(height: 16),
        const Divider(height: 24),

        // --- Extra Person ---
        Text(
          "Extra Person",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _miniLabel(context, "Number"),
                  TextFormField(
                    initialValue: "0",
                    keyboardType: TextInputType.number,
                    decoration: _deco(hint: "0"),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _miniLabel(context, "Charge Each"),
                  TextFormField(
                    initialValue: "20",
                    keyboardType: TextInputType.number,
                    decoration: _deco(
                      prefix: _pesoPrefix(),
                    ).copyWith(prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0)),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        const Divider(height: 24),

        // --- Extra Bed ---
        Text(
          "Extra Bed",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _miniLabel(context, "Number"),
                  TextFormField(
                    initialValue: "0",
                    keyboardType: TextInputType.number,
                    decoration: _deco(hint: "0"),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _miniLabel(context, "Charge Each"),
                  TextFormField(
                    initialValue: "15",
                    keyboardType: TextInputType.number,
                    decoration: _deco(
                      prefix: _pesoPrefix(),
                    ).copyWith(prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0)),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        const Divider(height: 24),

        // --- Payment Method ---
        _label(context, "Payment Method"),
        DropdownButtonFormField<String>(
          value: "Online",
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          decoration: _deco(),
          items: const [
            DropdownMenuItem(value: "Online", child: Text("Online")),
            DropdownMenuItem(value: "Cash", child: Text("Cash")),
            DropdownMenuItem(value: "Card", child: Text("Card")),
          ],
          onChanged: (_) {},
        ),

        const SizedBox(height: 14),

        // --- Booking Status ---
        _label(context, "Booking Status"),
        DropdownButtonFormField<String>(
          value: "Checked-in",
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          decoration: _deco(),
          items: const [
            DropdownMenuItem(value: "Pending", child: Text("Pending")),
            DropdownMenuItem(value: "Reserved", child: Text("Reserved")),
            DropdownMenuItem(value: "Checked-in", child: Text("Checked-in")),
            DropdownMenuItem(value: "Checked-out", child: Text("Checked-out")),
          ],
          onChanged: (_) {},
        ),

        const SizedBox(height: 12),

        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.black12),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Quick Check-in (Now)"),
        ),
      ],
    );
  }

  // ===== UI helpers =====

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

  Widget _miniLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
        ),
      );

  Widget _pesoPrefix() => const Padding(
        padding: EdgeInsets.only(left: 12, right: 10),
        child: Text(
          "₱",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      );

  Widget _dateTimeField({
    required String valueText,
    required VoidCallback onCalendarTap,
  }) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: valueText),
      decoration: _deco(
        suffix: IconButton(
          onPressed: onCalendarTap,
          icon: const Icon(Icons.calendar_today_outlined, color: Colors.black54, size: 18),
          tooltip: "Pick date & time",
        ),
      ),
      onTap: onCalendarTap,
    );
  }

  InputDecoration _deco({String? hint, Widget? prefix, Widget? suffix}) => InputDecoration(
        hintText: hint,
        prefixIcon: prefix == null ? null : prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      );
}

/// Date + Time picker (built-in, null-safe, Dart 3 compatible)
Future<DateTime?> _pickDateTime(BuildContext context, {required DateTime initial}) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.black,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
        ),
        child: child!,
      );
    },
  );

  if (date == null) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.black,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
        ),
        child: child!,
      );
    },
  );

  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
