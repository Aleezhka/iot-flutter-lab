import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_app/domain/cubits/machine_cubit.dart';
import 'package:workshop_app/domain/providers/connectivity_provider.dart';
import 'package:workshop_app/domain/providers/mqtt_provider.dart';
import 'package:workshop_app/widgets/machine_card.dart';
import 'package:workshop_app/widgets/machine_form_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MachineCubit>().loadMachines();
      context.read<MqttProvider>().connect();
    });

    final cols = MediaQuery.of(context).size.width > 600 ? 3 : 2;
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WORKSHOP HUB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MachineCubit>().loadMachines(),
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
              child: const Text('Офлайн режим', textAlign: TextAlign.center),
            ),
          Expanded(
            child: BlocBuilder<MachineCubit, MachineState>(
              builder: (context, state) {
                if (state is MachineLoading) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),);
                } else if (state is MachineError) {
                  return Center(child: Text(state.message));
                } else if (state is MachineLoaded) {
                  final machines = state.machines;
                  if (machines.isEmpty) {
                    return const Center(child: Text('Немає верстатів'));
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<MachineCubit>().loadMachines(),
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
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => MachineFormDialog(
            onSave: (m) => context.read<MachineCubit>().addMachine(m),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
