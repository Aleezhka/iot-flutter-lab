import 'package:flutter/material.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.storage, super.key});
  final IStorageRepository storage;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = await widget.storage.getLoggedInUserId();
    if (email != null) {
      final data = await widget.storage.getUser(email);
      setState(() {
        _userData = data;
      });
    }
  }

  Future<void> _logout() async {
    await widget.storage.setLoggedInUserId(null);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _userData?['name'] ?? 'Завантаження...';
    final email = _userData?['email'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('ПРОФІЛЬ')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              title: const Text('Робітник'),
              subtitle: Text(name),
            ),
            ListTile(
              title: const Text('Пошта'),
              subtitle: Text(email),
            ),
            const Spacer(),
            WorkshopButton(
              label: 'Вийти',
              color: Colors.redAccent,
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
