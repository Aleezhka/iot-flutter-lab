import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/models/machine_model.dart';

class SecureStorageRepo implements IStorageRepository {
  const SecureStorageRepo({required this.storage});
  
  final FlutterSecureStorage storage;

  @override
  Future<bool> saveUser(Map<String, String> userData) async {
    final email = userData['email'];
    if (email == null) return false;
    await storage.write(key: 'user_$email', value: jsonEncode(userData));
    return true;
  }

  @override
  Future<Map<String, String>?> getUser(String email) async {
    final jsonStr = await storage.read(key: 'user_$email');
    if (jsonStr == null) return null;
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v.toString()));
  }

  @override
  Future<void> setLoggedInUserId(String? email) async {
    if (email == null) {
      await storage.delete(key: 'logged_in_user');
    } else {
      await storage.write(key: 'logged_in_user', value: email);
    }
  }

  @override
  Future<String?> getLoggedInUserId() async {
    return storage.read(key: 'logged_in_user');
  }

  @override
  Future<List<MachineModel>> getMachines() async {
    final jsonStr = await storage.read(key: 'machines_data');
    if (jsonStr == null) return [];
    final decoded = jsonDecode(jsonStr) as List<dynamic>;
    return decoded
        .map((e) => MachineModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveMachines(List<MachineModel> machines) async {
    final mappedList = machines.map((m) => m.toJson()).toList();
    await storage.write(key: 'machines_data', value: jsonEncode(mappedList));
  }
}
