import 'package:alter/feature/auth/model/auth_model.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPermissionsProvider = Provider<UserPermissions>((ref) {
  final loginState = ref.watch(loginViewModelProvider);

  // 사용자의 역할에 따라 적절한 권한 객체 반환
  switch (loginState.role) {
    case Role.guest:
      return const UserPermissions(role: Role.guest, canWritePosting: false);
    case Role.user:
      return const UserPermissions(role: Role.user, canWritePosting: false);
    case Role.manager:
      return const UserPermissions(role: Role.manager, canWritePosting: true);
  }
});
