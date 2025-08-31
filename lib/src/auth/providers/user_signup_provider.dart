import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:YELO/src/auth/data_source/auth_remote_source.dart';
import 'package:YELO/src/core/errors/app_error.dart';
import 'package:YELO/src/core/state/app_state.dart';

class UserSignupProvider extends StateNotifier<AppState<User?>> {
  UserSignupProvider(this._remoteSource) : super(const AppState.initial());

  final AuthRemoteSource _remoteSource;

  Future signup({
    required String name,
    required String email,
    required String password,
    required String location,
  }) async {
    state = const AppState.loading();
    final response = await _remoteSource.signupUser(
        name: name, email: email, password: password, location: location);
    state = response.fold(
      (error) => error.when(
          serverError: (message) => AppState.error(message: message),
          noInternet: () => const AppState.noInternet()),
      (response) => AppState.success(data: response),
    );
  }
}

final userSignupProvider =
    StateNotifierProvider.autoDispose<UserSignupProvider, AppState<User?>>(
        (ref) => UserSignupProvider(ref.read(authRemoteSourceProvider)));
