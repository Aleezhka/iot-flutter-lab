import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/models/machine_model.dart';

class SharedPrefsRepository implements IStorageRepository {
  const SharedPrefsRepository({required SharedPreferences prefs})
      : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Future<bool> saveUser(Map<String, String> userData) async {
    final email = userData['email'];
    if (email == null) return false;
    final jsonString = jsonEncode(userData);
    return _prefs.setString('user_$email', jsonString);
  }

  @override
  Future<Map<String, String>?> getUser(String email) async {
    final jsonString = _prefs.getString('user_$email');
    if (jsonString == null) return null;
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  @override
  Future<void> setLoggedInUserId(String? email) async {
    if (email == null) {
      await _prefs.remove('logged_in_user');
    } else {
      await _prefs.setString('logged_in_user', email);
    }
  }

  @override
  Future<String?> getLoggedInUserId() async {
    return _prefs.getString('logged_in_user');
  }

  @override
  Future<List<MachineModel>> getMachines() async {
    final jsonString = _prefs.getString('machines_data');
    if (jsonString == null) return [];
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((e) => MachineModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveMachines(List<MachineModel> machines) async {
    final mappedList = machines.map((m) => m.toJson()).toList();
    final jsonString = jsonEncode(mappedList);
    await _prefs.setString('machines_data', jsonString);
  }
}
