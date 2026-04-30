import 'package:workshop_app/models/machine_model.dart';

abstract interface class IStorageRepository {
  Future<bool> saveUser(Map<String, String> userData);
  Future<Map<String, String>?> getUser(String email);
  Future<void> setLoggedInUserId(String? email);
  Future<String?> getLoggedInUserId();
  Future<List<MachineModel>> getMachines();
  Future<void> saveMachines(List<MachineModel> machines);
}
