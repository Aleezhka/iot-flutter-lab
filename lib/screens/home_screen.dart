import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/domain/providers/connectivity_provider.dart';
import 'package:workshop_app/domain/providers/mqtt_provider.dart';
import 'package:workshop_app/models/machine_model.dart';
import 'package:workshop_app/widgets/machine_card.dart';
import 'package:workshop_app/widgets/machine_form_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.storage, super.key});
  final IStorageRepository storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MachineModel> _machines = [];

  @override
  void initState() {
    super.initState();
    _loadMachines();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MqttProvider>().connect();
    });
  }

  Future<void> _loadMachines() async {
    final loaded = await widget.storage.getMachines();
    setState(() => _machines = loaded);
  }

  void _saveMachine(MachineModel m) {
    setState(() {
      final i = _machines.indexWhere((e) => e.id == m.id);
      if (i >= 0) {
        _machines[i] = m;
      } else {
        _machines.add(m);
      }
    });
    widget.storage.saveMachines(_machines);
  }

  void _deleteMachine(String id) {
    setState(() => _machines.removeWhere((m) => m.id == id));
    widget.storage.saveMachines(_machines);
  }

  String _getNextId() {
    if (_machines.isEmpty) return '1';
    final maxId = _machines
        .map((m) => int.tryParse(m.id) ?? 0)
        .reduce((max, current) => current > max ? current : max);
    return (maxId + 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    final cols = MediaQuery.of(context).size.width > 600 ? 3 : 2;
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WORKSHOP HUB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!isOnline)
            Container(
              width: double.infinity,
              color: Colors.redAccent,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Немає з\'єднання з Інтернетом',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _machines.length,
              itemBuilder: (ctx, i) => MachineCard(
                id: _machines[i].id,
                title: _machines[i].title,
                status: _machines[i].status,
                isEmergency: _machines[i].isEmergency,
                onEdit: () => showDialog<void>(
                  context: context,
                  builder: (_) => MachineFormDialog(
                    machine: _machines[i],
                    onSave: _saveMachine,
                  ),
                ),
                onDelete: () => _deleteMachine(_machines[i].id),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => MachineFormDialog(
            onSave: _saveMachine,
            newId: _getNextId(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
