import 'package:flutter/material.dart';

import 'widgets/grid_canvas.dart';
import 'widgets/right_sidebar.dart';
import 'widgets/toolbar.dart';

class FloorPlanEditorScreen extends StatefulWidget {
  const FloorPlanEditorScreen({super.key});

  @override
  State<FloorPlanEditorScreen> createState() => _FloorPlanEditorScreenState();
}

class _FloorPlanEditorScreenState extends State<FloorPlanEditorScreen> {
  final List<String> _floors = const ['Floor 1', 'Floor 2', 'Floor 3'];
  String _selectedFloor = 'Floor 1';

  // Toolbar state
  EditorTool _activeTool = EditorTool.select;

  // Sidebar state
  bool _roomTypesChecked = true;
  bool _addNewTypeChecked = false;
  bool _liveMode = false;

  // Placeholder counts
  final int _totalRooms = 0;
  final int _roomTypesCount = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // Top header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hotel Floor Plan Editor',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Design and manage your hotel layout',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _FloorChip(
                    value: _selectedFloor,
                    items: _floors,
                    onChanged: (v) => setState(() => _selectedFloor = v),
                  ),
                ],
              ),
            ),

            // Toolbar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: EditorToolbar(
                      floors: _floors,
                      selectedFloor: _selectedFloor,
                      activeTool: _activeTool,
                      onFloorChanged: (v) => setState(() => _selectedFloor = v),
                      onToolChanged: (tool) =>
                          setState(() => _activeTool = tool),
                      onAddFloor: () {},
                      onAddRoom: () {},
                      onDelete: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Total Rooms: $_totalRooms',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),

            // Main content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isCompact = constraints.maxWidth < 980;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Canvas
                        Expanded(
                          child: GridCanvas(
                            key: ValueKey(
                              'grid_${_selectedFloor}_${_activeTool.name}',
                            ),
                            placeholderEnabled: true,
                            placeholderText:
                                "Click 'Add Room' to place rooms on the floor plan",
                          ),
                        ),

                        const SizedBox(width: 18),

                        // Right sidebar (fixed width, stable)
                        SizedBox(
                          width: isCompact ? 290 : 320,
                          child: RightSidebar(
                            roomTypesCount: _roomTypesCount,
                            roomTypesChecked: _roomTypesChecked,
                            addNewTypeChecked: _addNewTypeChecked,
                            liveMode: _liveMode,
                            onRoomTypesChecked: (v) =>
                                setState(() => _roomTypesChecked = v),
                            onAddNewTypeChecked: (v) =>
                                setState(() => _addNewTypeChecked = v),
                            onAddType: () {},
                            onLiveModeChanged: (v) =>
                                setState(() => _liveMode = v),
                            onSave: () {},
                            onLoad: () {},
                            onExport: () {},
                            onImport: () {},
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

class _FloorChip extends StatelessWidget {
  const _FloorChip({
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
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
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
                  child: Row(
                    children: [
                      const Icon(Icons.layers_outlined, size: 16),
                      const SizedBox(width: 6),
                      Text(f),
                    ],
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
