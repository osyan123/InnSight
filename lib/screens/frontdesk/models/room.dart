enum RoomStatus { vacant, occupied, reserved, maintenance }

class Room {
  final String number;
  final String type; // Standard / Deluxe / Suite
  RoomStatus status;
  String? guestName;

  Room({
    required this.number,
    required this.type,
    required this.status,
    this.guestName,
  });
}

String statusLabel(RoomStatus s) {
  switch (s) {
    case RoomStatus.vacant:
      return "Vacant";
    case RoomStatus.occupied:
      return "Occupied";
    case RoomStatus.reserved:
      return "Reserved";
    case RoomStatus.maintenance:
      return "Maintenance";
  }
}
