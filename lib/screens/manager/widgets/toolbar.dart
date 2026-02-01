import 'package:flutter/material.dart';

enum EditorTool { select, addRoom, delete }

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({
    super.key,
    required this.floors,
    required this.selectedFloor,
    required this.activeTool,
    required this.onFloorChanged,
    required this.onToolChanged,
    required this.onAddFloor,
    required this.onAddRoom,
    required this.onDelete,
  });

  final List<String> floors;
  final String selectedFloor;
  final EditorTool activeTool;

  final ValueChanged<String> onFloorChanged;
  final ValueChanged<EditorTool> onToolChanged;

  final VoidCallback onAddFloor;
  final VoidCallback onAddRoom;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Floor:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF374151),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 8),
            _FloorDropdown(
              value: selectedFloor,
              items: floors,
              onChanged: onFloorChanged,
            ),
          ],
        ),

        _GhostButton(
          icon: Icons.add,
          label: 'Add Floor',
          onPressed: onAddFloor,
        ),

        _ToolButton(
          icon: Icons.near_me_outlined,
          label: 'Select',
          selected: activeTool == EditorTool.select,
          onPressed: () => onToolChanged(EditorTool.select),
        ),

        _GhostButton(
          icon: Icons.add_box_outlined,
          label: 'Add Room',
          onPressed: () {
            onToolChanged(EditorTool.addRoom);
            onAddRoom();
          },
        ),

        _GhostButton(
          icon: Icons.delete_outline,
          label: 'Delete',
          onPressed: () {
            onToolChanged(EditorTool.delete);
            onDelete();
          },
        ),
      ],
    );
  }
}

class _FloorDropdown extends StatelessWidget {
  const _FloorDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.expand_more, size: 18),
          items: items
              .map(
                (f) => DropdownMenuItem<String>(
                  value: f,
                  child: Text(
                    f,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(label),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          foregroundColor: const Color(0xFF111827),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          backgroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color bg = selected ? const Color(0xFF111827) : Colors.white;
    final Color fg = selected ? Colors.white : const Color(0xFF111827);
    final Color border = selected ? const Color(0xFF111827) : const Color(0xFFE5E7EB);

    return SizedBox(
      height: 34,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 18, color: fg),
        label: Text(label, style: TextStyle(color: fg)),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          side: BorderSide(color: border),
          backgroundColor: bg,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
