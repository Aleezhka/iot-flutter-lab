import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  ProfileLoaded({required this.name, required this.email});
}

class ProfileError extends ProfileState {}

class ProfileCubit extends Cubit<ProfileState> {
  final IStorageRepository repo;

  ProfileCubit(this.repo) : super(ProfileLoading());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final email = await repo.getLoggedInUserId();
      if (email != null) {
        final data = await repo.getUser(email);
        emit(
          ProfileLoaded(
            name: data?['name'] ?? 'Невідомий',
            email: email,
          ),
        );
      } else {
        emit(ProfileError());
      }
    } catch (e) {
      emit(ProfileError());
    }
  }
}
