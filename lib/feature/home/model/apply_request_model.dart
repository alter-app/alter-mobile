import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_request_model.freezed.dart';
part 'apply_request_model.g.dart';

@freezed
abstract class ApplyRequest with _$ApplyRequest {
  const factory ApplyRequest({
    required int postingScheduleId,
    required String description,
  }) = _ApplyRequest;

  factory ApplyRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyRequestFromJson(json);
}
