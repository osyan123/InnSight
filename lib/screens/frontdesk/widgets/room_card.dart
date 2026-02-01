import 'package:flutter/material.dart';
import '../models/room.dart';
import '../theme/room_colors.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({
    super.key,
    required this.room,
    required this.selected,
    required this.onTap,
  });

  final Room room;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = roomColors(widget.room.status);

    final borderColor = widget.selected ? Colors.black87 : colors.border;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
        0.0,
        hovered ? -2.0 : 0.0,
        0.0,
      ),

        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: widget.selected ? 2.5 : 1.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(hovered ? 20 : 10),
              blurRadius: hovered ? 14 : 10,
              offset: Offset(0, hovered ? 6 : 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.room.number,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(widget.room.type, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 6),
                Text(
                  statusLabel(widget.room.status),
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (widget.room.status == RoomStatus.occupied && widget.room.guestName != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    widget.room.guestName!,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
