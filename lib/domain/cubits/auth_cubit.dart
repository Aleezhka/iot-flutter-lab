import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final IStorageRepository storage;

  AuthCubit(this.storage) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await storage.setLoggedInUserId(email);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (_) {
      emit(AuthError('Невірний логін або пароль'));
    } catch (e) {
      emit(AuthError('Помилка: $e'));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(AuthInitial());
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final email = userCredential.user?.email ?? googleUser.email;

      await storage.saveUser(
        {'name': googleUser.displayName ?? 'Google User', 'email': email},
      );
      await storage.setLoggedInUserId(email);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError('Помилка входу через Google: $e'));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await storage.saveUser({'name': name, 'email': email});
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Помилка реєстрації'));
    } catch (e) {
      emit(AuthError('Помилка: $e'));
    }
  }
}
