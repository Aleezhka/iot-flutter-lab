import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/models/machine_model.dart';

class ApiStorageRepo implements IStorageRepository {
  ApiStorageRepo({required this.localRepo, required this.dio});

  final IStorageRepository localRepo;
  final Dio dio;

  final String baseUrl = 'https://69fa2dcdc509a40d3aa40766.mockapi.io';

  @override
  Future<bool> saveUser(Map<String, String> userData) =>
      localRepo.saveUser(userData);

  @override
  Future<Map<String, String>?> getUser(String email) =>
      localRepo.getUser(email);

  @override
  Future<void> setLoggedInUserId(String? email) =>
      localRepo.setLoggedInUserId(email);

  @override
  Future<String?> getLoggedInUserId() => localRepo.getLoggedInUserId();

  @override
  Future<List<MachineModel>> getMachines() async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();

      final response = await dio.get<dynamic>(
        '$baseUrl/machines',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

      final data = response.data as List<dynamic>;
      final machines = data
          .map((e) => MachineModel.fromJson(e as Map<String, dynamic>))
          .toList();

      await localRepo.saveMachines(machines);
      return machines;
    } catch (e) {
      return localRepo.getMachines();
    }
  }

  @override
  Future<void> saveMachines(List<MachineModel> machines) async {
    await localRepo.saveMachines(machines);
  }
}
