import 'package:flutter/material.dart';
import '../models/room.dart';
import 'details_tabs/guest_tab.dart';
import 'details_tabs/booking_tab.dart';
import 'details_tabs/status_tab.dart';

class DetailsPane extends StatelessWidget {
  const DetailsPane({
    super.key,
    required this.room,
    required this.onClose,
    required this.onSave,
  });

  final Room? room;
  final VoidCallback onClose;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: room == null
          ? Center(
              child: Text(
                "Select a room to view details",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
            )
          : _RoomDetails(room: room!, onClose: onClose, onSave: onSave),
    );
  }
}

class _RoomDetails extends StatelessWidget {
  const _RoomDetails({
    required this.room,
    required this.onClose,
    required this.onSave,
  });

  final Room room;
  final VoidCallback onClose;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: IconTheme(
        // ✅ Makes ALL icons inside this pane default to black
        data: const IconThemeData(color: Colors.black),
        child: DefaultTextStyle(
          // ✅ Makes ALL text inside this pane default to black
          style:
              theme.textTheme.bodyMedium?.copyWith(color: Colors.black) ??
              const TextStyle(color: Colors.black),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Room ${room.number}",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            room.type,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close, color: Colors.black),
                      tooltip: "Close",
                    ),
                  ],
                ),
              ),

              // Tabs wrapper (pill background)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,

                  // ✅ Tab label colors (text)
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,

                  // ✅ Optional: makes indicator visible but still clean
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  tabs: const [
                    Tab(
                      icon: Icon(Icons.person_outline, color: Colors.black),
                      text: "Guest",
                    ),
                    Tab(
                      icon: Icon(
                        Icons.event_note_outlined,
                        color: Colors.black,
                      ),
                      text: "Booking",
                    ),
                    Tab(
                      icon: Icon(Icons.settings_outlined, color: Colors.black),
                      text: "Status",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: TabBarView(
                  children: [
                    GuestTab(room: room),
                    BookingTab(room: room),
                    StatusTab(room: room),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,

                  // ✅ Save Changes button (BLACK)
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
