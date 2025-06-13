import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_job_response_model.freezed.dart';
part 'my_job_response_model.g.dart';

@freezed
abstract class ApplyResponse with _$ApplyResponse {
  const factory ApplyResponse({
    required Page page,
    required List<Application> data,
  }) = _ApplyResponse;

  factory ApplyResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplyResponseFromJson(json);
}

@freezed
abstract class ApplyStatusUpdateRequest with _$ApplyStatusUpdateRequest {
  const factory ApplyStatusUpdateRequest({required String status}) =
      _ApplyStatusUpdateRequest;

  factory ApplyStatusUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyStatusUpdateRequestFromJson(json);
}

@freezed
abstract class Page with _$Page {
  const factory Page({
    required int page,
    required int pageSize,
    required int totalCount,
    required int totalPage,
  }) = _Page;

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}

@freezed
abstract class Application with _$Application {
  const factory Application({
    required int id,
    required ApplySchedule postingSchedule,
    required PostingData posting,
    required String description,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Application;

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);
}

@freezed
abstract class PostingData with _$PostingData {
  const factory PostingData({
    required int id,
    required WorkSpaceDetail workspace,
    required String title,
    required String description,
    required String paymentType,
    required int payAmount,
  }) = _PostingData;

  factory PostingData.fromJson(Map<String, dynamic> json) =>
      _$PostingDataFromJson(json);
}

@freezed
abstract class ApplySchedule with _$ApplySchedule {
  const factory ApplySchedule({
    int? id,
    required List<String> workingDays,
    required String startTime,
    required String endTime,
    required String position,
  }) = _ApplySchedule;

  factory ApplySchedule.fromJson(Map<String, dynamic> json) =>
      _$ApplyScheduleFromJson(json);
}
