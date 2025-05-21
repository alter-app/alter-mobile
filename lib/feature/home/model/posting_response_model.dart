import 'package:freezed_annotation/freezed_annotation.dart';

part 'posting_response_model.freezed.dart';
part 'posting_response_model.g.dart';

@freezed
abstract class PostingResponse with _$PostingResponse {
  const factory PostingResponse({
    required PageInfo page,
    required List<Posting> data,
  }) = _PostingResponse;

  factory PostingResponse.fromJson(Map<String, dynamic> json) =>
      _$PostingResponseFromJson(json);
}

@freezed
abstract class PageInfo with _$PageInfo {
  const factory PageInfo({
    required String? cursor,
    required int pageSize,
    required int totalCount,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}

@freezed
abstract class Posting with _$Posting {
  const factory Posting({
    required int id,
    required String title,
    required int payAmount,
    required String paymentType,
    required DateTime createdAt,
    required List<Keyword> keywords,
    required List<Schedule> schedules,
  }) = _Posting;

  factory Posting.fromJson(Map<String, dynamic> json) =>
      _$PostingFromJson(json);
}

@freezed
abstract class PostingDetail with _$PostingDetail {
  const factory PostingDetail({
    required int id,
    required int workspace,
    required String title,
    required String description,
    required int payAmount,
    required String paymentType,
    required DateTime createdAt,
    required List<Keyword> keywords,
    required List<Schedule> schedules,
  }) = _PostingDetail;

  factory PostingDetail.fromJson(Map<String, dynamic> json) =>
      _$PostingDetailFromJson(json);
}

@freezed
abstract class Keyword with _$Keyword {
  const factory Keyword({required int id, required String name}) = _Keyword;

  factory Keyword.fromJson(Map<String, dynamic> json) =>
      _$KeywordFromJson(json);
}

@freezed
abstract class Schedule with _$Schedule {
  const factory Schedule({
    required List<String> workingDays,
    required String startTime,
    required String endTime,
    required int positionsNeeded,
    required int position,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
