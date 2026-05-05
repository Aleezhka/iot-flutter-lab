import 'package:flutter/material.dart';
import 'package:workshop_app/models/machine_model.dart';

class MachineFormDialog extends StatefulWidget {
  const MachineFormDialog({
    required this.onSave,
    this.machine,
    this.newId,
    super.key,
  });

  final MachineModel? machine;
  final String? newId;
  final void Function(MachineModel) onSave;

  @override
  State<MachineFormDialog> createState() => _MachineFormDialogState();
}

class _MachineFormDialogState extends State<MachineFormDialog> {
  late final TextEditingController _titleCtrl;
  late String _status;
  late bool _isEmergency;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.machine?.title);
    _status = widget.machine?.status == 'Inactive' ? 'Inactive' : 'Active';
    _isEmergency = widget.machine?.isEmergency ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.machine != null ? 'Редагувати' : 'Додати машину'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Назва'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Статус'),
            items: const [
              DropdownMenuItem(value: 'Active', child: Text('Активний')),
              DropdownMenuItem(value: 'Inactive', child: Text('Неактивний')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _status = val);
            },
          ),
          SwitchListTile(
            title: const Text('Аварія?'),
            value: _isEmergency,
            onChanged: (val) => setState(() => _isEmergency = val),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        TextButton(
          onPressed: () {
            final newMachine = MachineModel(
              id: widget.machine?.id ?? widget.newId ?? '1',
              title: _titleCtrl.text.isEmpty ? 'Без назви' : _titleCtrl.text,
              status: _status,
              isEmergency: _isEmergency,
            );
            widget.onSave(newMachine);
            Navigator.pop(context);
          },
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
