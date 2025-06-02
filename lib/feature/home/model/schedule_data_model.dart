import 'package:alter/common/widget/day_selector.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_data_model.freezed.dart';
part 'schedule_data_model.g.dart';

@freezed
abstract class ScheduleData with _$ScheduleData {
  const factory ScheduleData({
    required int id,
    required Set<Day> selectedDays,
    @Default(false) bool isDayNegotiable,
    @Default("09:00") String startTime,
    @Default("18:00") String endTime,
    @Default(false) bool isTimeNegotiable,
  }) = _ScheduleData;

  factory ScheduleData.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDataFromJson(json);
}
