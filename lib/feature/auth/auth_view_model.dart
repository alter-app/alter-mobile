import 'package:alter/common/util/logger.dart';
import 'package:alter/feature/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(ref.watch(authRepositoryProvider));
});

class AuthState {
  final bool isLoggedIn;
  final String? error;

  AuthState({required this.isLoggedIn, this.error});

  AuthState copyWith({bool? isLoggedIn, bool? isLoading, String? error}) {
    return AuthState(isLoggedIn: isLoggedIn ?? this.isLoggedIn, error: error);
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(AuthState(isLoggedIn: false)) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _repository.getAccessToken();
    Log.d("accessToken: $token");
    state = state.copyWith(isLoggedIn: token != null);
  }

  Future<void> loginWithKakao() async {
    state = state.copyWith(isLoading: true, error: null);
    final success = await _repository.loginWithKakao();
    state = state.copyWith(
      isLoggedIn: success,
      isLoading: false,
      error: success ? null : 'Kakao login failed',
    );
  }
}
