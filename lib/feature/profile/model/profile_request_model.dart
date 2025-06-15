import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_request_model.freezed.dart';
part 'profile_request_model.g.dart';

@freezed
abstract class CertificateRequest with _$CertificateRequest {
  const factory CertificateRequest({
    required String type,
    required String certificateName,
    required String certificateId,
    required String publisherName,
    required DateTime issuedAt,
    DateTime? expiresAt,
  }) = _CertificateRequest;

  factory CertificateRequest.fromJson(Map<String, dynamic> json) =>
      _$CertificateRequestFromJson(json);
}
