import 'package:flutter/material.dart';
import 'models/room.dart';
import 'widgets/details_pane.dart';
import 'widgets/floor_plan_pane.dart';
import 'widgets/header_bar.dart';
import 'widgets/daily_sales_dialog.dart';

class FrontDeskDashboard extends StatefulWidget {
  const FrontDeskDashboard({super.key});

  @override
  State<FrontDeskDashboard> createState() => _FrontDeskDashboardState();
}

class _FrontDeskDashboardState extends State<FrontDeskDashboard> {
  final List<String> floors = const ['Floor 1', 'Floor 2', 'Floor 3'];
  String selectedFloor = 'Floor 1';

  Room? selectedRoom;

  late final Map<String, List<Room>> floorRooms = {
    'Floor 1': [
      Room(
        number: '101',
        type: 'Standard',
        status: RoomStatus.occupied,
        guestName: 'John Smith',
      ),
      Room(number: '102', type: 'Standard', status: RoomStatus.vacant),
      Room(
        number: '103',
        type: 'Deluxe',
        status: RoomStatus.occupied,
        guestName: 'Sarah Johnson',
      ),
      Room(
        number: '104',
        type: 'Standard',
        status: RoomStatus.occupied,
        guestName: 'Michael Chen',
      ),
      Room(number: '105', type: 'Standard', status: RoomStatus.maintenance),
      Room(number: '106', type: 'Suite', status: RoomStatus.vacant),
    ],
    'Floor 2': [],
    'Floor 3': [],
  };

  @override
  Widget build(BuildContext context) {
    final rooms = floorRooms[selectedFloor] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            FrontDeskHeaderBar(
              onDailySales: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.45),
                  builder: (_) => DailySalesDialog(
                    editableTotalLodgingSales: true,
                    initialTotalLodgingSales: 0.0,

                    // ✅ updated parameter names
                    initialAdditionalCharges: 0.0,
                    initialDeductionsDiscounts: 0.0,
                    initialCashOnHand: 0.0,

                    onCloseSalesForToday:
                        ({
                          required double totalLodgingSales,
                          required double additionalCharges,
                          required double deductionsDiscounts,
                          required double netTotalSales,
                          required double cashOnHand,
                        }) async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Sales closed. Net: ₱${netTotalSales.toStringAsFixed(2)}",
                              ),
                            ),
                          );
                        },
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 1100;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 7,
                                child: FloorPlanPane(
                                  selectedFloor: selectedFloor,
                                  floors: floors,
                                  onFloorChanged: (v) => setState(() {
                                    selectedFloor = v;
                                    selectedRoom = null;
                                  }),
                                  rooms: rooms,
                                  selectedRoomNumber: selectedRoom?.number,
                                  onRoomSelected: (room) =>
                                      setState(() => selectedRoom = room),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 3,
                                child: DetailsPane(
                                  room: selectedRoom,
                                  onClose: () =>
                                      setState(() => selectedRoom = null),
                                  onSave: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Changes saved (demo).'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: FloorPlanPane(
                                  selectedFloor: selectedFloor,
                                  floors: floors,
                                  onFloorChanged: (v) => setState(() {
                                    selectedFloor = v;
                                    selectedRoom = null;
                                  }),
                                  rooms: rooms,
                                  selectedRoomNumber: selectedRoom?.number,
                                  onRoomSelected: (room) =>
                                      setState(() => selectedRoom = room),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 420,
                                child: DetailsPane(
                                  room: selectedRoom,
                                  onClose: () =>
                                      setState(() => selectedRoom = null),
                                  onSave: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Changes saved (demo).'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
