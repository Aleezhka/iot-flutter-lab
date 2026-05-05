import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/models/machine_model.dart';

abstract class MachineState {}

class MachineInitial extends MachineState {}

class MachineLoading extends MachineState {}

class MachineLoaded extends MachineState {
  final List<MachineModel> machines;
  MachineLoaded(this.machines);
}

class MachineError extends MachineState {
  final String message;
  MachineError(this.message);
}

class MachineCubit extends Cubit<MachineState> {
  final IStorageRepository repo;

  MachineCubit(this.repo) : super(MachineInitial());

  Future<void> loadMachines() async {
    emit(MachineLoading());
    try {
      final machines = await repo.getMachines();
      emit(MachineLoaded(machines));
    } catch (e) {
      emit(MachineError('Помилка завантаження: $e'));
    }
  }

  Future<void> addMachine(MachineModel machine) async {
    if (state is MachineLoaded) {
      final currentMachines = (state as MachineLoaded).machines;
      final updatedList = List<MachineModel>.from(currentMachines)
        ..add(machine);

      emit(MachineLoaded(updatedList));

      await repo.saveMachines(updatedList);
    }
  }
}
