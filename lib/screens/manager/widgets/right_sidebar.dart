// lib/screens/manager/widgets/right_sidebar.dart
import 'package:flutter/material.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({
    super.key,
    required this.roomTypesCount,
    required this.roomTypesChecked,
    required this.addNewTypeChecked,
    required this.liveMode,
    required this.onRoomTypesChecked,
    required this.onAddNewTypeChecked,
    required this.onAddType,
    required this.onLiveModeChanged,
    required this.onSave,
    required this.onLoad,
    required this.onExport,
    required this.onImport,
  });

  final int roomTypesCount;
  final bool roomTypesChecked;
  final bool addNewTypeChecked;
  final bool liveMode;

  final ValueChanged<bool> onRoomTypesChecked;
  final ValueChanged<bool> onAddNewTypeChecked;
  final VoidCallback onAddType;
  final ValueChanged<bool> onLiveModeChanged;

  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onExport;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Card(
          title: 'Room Type Management',
          child: Column(
            children: [
              _CheckboxRow(
                value: roomTypesChecked,
                onChanged: onRoomTypesChecked,
                label: 'Room Types',
                trailing: _Badge(count: roomTypesCount),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _CheckboxRow(
                      value: addNewTypeChecked,
                      onChanged: onAddNewTypeChecked,
                      label: 'Add New Type',
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      onPressed: onAddType,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF111827),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _Card(
          title: 'Live Mode',
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Live Mode',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Switch(
                value: liveMode,
                onChanged: onLiveModeChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _Card(
          title: 'Floor Plan Actions',
          child: Column(
            children: [
              _ActionRow(
                icon: Icons.save_outlined,
                label: 'Save Floor Plan',
                buttonText: 'Save',
                onPressed: onSave,
              ),
              const SizedBox(height: 10),
              _ActionRow(
                icon: Icons.folder_open_outlined,
                label: 'Load Floor Plan',
                buttonText: 'Load',
                onPressed: onLoad,
              ),
              const SizedBox(height: 10),
              _ActionRow(
                icon: Icons.file_download_outlined,
                label: 'Export Floor Plan',
                buttonText: 'Export',
                onPressed: onExport,
              ),
              const SizedBox(height: 10),
              _ActionRow(
                icon: Icons.file_upload_outlined,
                label: 'Import Floor Plan',
                buttonText: 'Import',
                onPressed: onImport,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _CheckboxRow extends StatelessWidget {
  const _CheckboxRow({
    required this.value,
    required this.onChanged,
    required this.label,
    this.trailing,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Color(0xFF111827),
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.buttonText,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (_) {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF111827)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 34,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              foregroundColor: const Color(0xFF111827),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
              backgroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }
}
