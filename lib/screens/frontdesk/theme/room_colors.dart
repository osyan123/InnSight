import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomColors {
  final Color bg;
  final Color border;
  const RoomColors({required this.bg, required this.border});
}

RoomColors roomColors(RoomStatus status) {
  switch (status) {
    case RoomStatus.vacant:
      return const RoomColors(bg: Color(0xFFDFF7E6), border: Color(0xFF22C55E));
    case RoomStatus.occupied:
      return const RoomColors(bg: Color(0xFFDCEBFF), border: Color(0xFF3B82F6));
    case RoomStatus.reserved:
      return const RoomColors(bg: Color(0xFFFFF3C4), border: Color(0xFFF59E0B));
    case RoomStatus.maintenance:
      return const RoomColors(bg: Color(0xFFFFD9D9), border: Color(0xFFEF4444));
  }
}
