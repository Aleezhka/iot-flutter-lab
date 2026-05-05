import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/domain/cubits/profile_cubit.dart';
import 'package:workshop_app/widgets/workshop_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Вихід'),
        content: const Text('Ви впевнені, що хочете вийти з акаунту?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      await context.read<IStorageRepository>().setLoggedInUserId(null);

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadProfile();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('ПРОФІЛЬ')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              );
            } else if (state is ProfileLoaded) {
              return Column(
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
                    subtitle: Text(state.name),
                  ),
                  ListTile(
                    title: const Text('Пошта'),
                    subtitle: Text(state.email),
                  ),
                  const Spacer(),
                  WorkshopButton(
                    label: 'Вийти',
                    color: Colors.redAccent,
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ],
              );
            }
            return const Center(child: Text('Помилка завантаження профілю'));
          },
        ),
      ),
    );
  }
}
