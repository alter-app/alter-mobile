import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'posting_request_model.freezed.dart';
part 'posting_request_model.g.dart';

@freezed
abstract class PostingRequest with _$PostingRequest {
  const factory PostingRequest({
    required int workspaceId,
    required String title,
    required String description,
    required int payAmount,
    required String paymentType, // e.g., "HOURLY", "DAILY", etc.
    required List<int> keywords, // keyword ID list
    required List<Schedule> schedules,
  }) = _PostingRequest;

  factory PostingRequest.fromJson(Map<String, dynamic> json) =>
      _$PostingRequestFromJson(json);
}
