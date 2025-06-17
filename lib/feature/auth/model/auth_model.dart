import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  signupRequired,
  tokenExpired,
  fail,
}

enum SocialDomain {
  kakao("KAKAO"),
  apple("APPLE");

  final String name;

  const SocialDomain(this.name);
}

enum Role { guest, user, manager }

@freezed
abstract class UserPermissions with _$UserPermissions {
  const factory UserPermissions({
    required Role role,
    // 추가적인 권한을 설정을 할 수 있음
    @Default(false) bool canWritePosting,
  }) = _UserPermissions;

  factory UserPermissions.fromRole(Role role) {
    switch (role) {
      case Role.guest:
        return const UserPermissions(role: Role.guest, canWritePosting: false);
      case Role.user:
        return const UserPermissions(role: Role.user, canWritePosting: false);
      case Role.manager:
        return const UserPermissions(role: Role.manager, canWritePosting: true);
    }
  }
}
