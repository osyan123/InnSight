import 'package:flutter/material.dart';
import '../models/room.dart';
import 'legend.dart';
import 'room_card.dart';

class FloorPlanPane extends StatelessWidget {
  const FloorPlanPane({
    super.key,
    required this.selectedFloor,
    required this.floors,
    required this.onFloorChanged,
    required this.rooms,
    required this.selectedRoomNumber,
    required this.onRoomSelected,
  });

  final String selectedFloor;
  final List<String> floors;
  final ValueChanged<String> onFloorChanged;

  final List<Room> rooms;
  final String? selectedRoomNumber;
  final ValueChanged<Room> onRoomSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Floor",
                          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedFloor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        items: floors
                            .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                            .toList(),
                        onChanged: (v) => onFloorChanged(v ?? selectedFloor),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const RoomStatusLegend(),
              ],
            ),
            const SizedBox(height: 14),
            Text(selectedFloor, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6E7EA)),
                ),
                padding: const EdgeInsets.all(12),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final crossAxisCount = c.maxWidth >= 900 ? 3 : (c.maxWidth >= 640 ? 3 : 2);

                    return GridView.builder(
                      itemCount: rooms.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.25,
                      ),
                      itemBuilder: (_, i) {
                        final room = rooms[i];
                        return RoomCard(
                          room: room,
                          selected: room.number == selectedRoomNumber,
                          onTap: () => onRoomSelected(room),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
