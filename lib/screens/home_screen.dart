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
  late Future<List<MachineModel>> _machinesFuture;

  @override
  void initState() {
    super.initState();
    _machinesFuture = widget.storage.getMachines();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MqttProvider>().connect();
    });
  }

  void _refreshData() {
    setState(() {
      _machinesFuture = widget.storage.getMachines();
    });
  }

  void _saveMachineLocally(MachineModel m) async {
    final currentMachines = await _machinesFuture;
    currentMachines.add(m);
    await widget.storage.saveMachines(currentMachines);
    _refreshData();
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
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
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
                'Офлайн. Показано збережені дані',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<MachineModel>>(
              future: _machinesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Помилка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Немає верстатів у цеху'));
                }

                final machines = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: () async => _refreshData(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: machines.length,
                    itemBuilder: (ctx, i) => MachineCard(
                      id: machines[i].id,
                      title: machines[i].title,
                      status: machines[i].status,
                      isEmergency: machines[i].isEmergency,
                      onEdit: () {},
                      onDelete: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => MachineFormDialog(onSave: _saveMachineLocally),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
