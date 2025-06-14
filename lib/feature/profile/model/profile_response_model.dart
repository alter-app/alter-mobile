import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_response_model.freezed.dart';
part 'profile_response_model.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int id,
    required String name,
    required String nickname,
    required DateTime createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
abstract class Certificate with _$Certificate {
  const factory Certificate({
    required int id,
    required String type,
    required String certificateName,
    required String publisherName,
    required DateTime issuedAt,
    int? certificateRecordId,
    DateTime? expiredAt,
    DateTime? updatedAt,
  }) = _Certificate;

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);
}
