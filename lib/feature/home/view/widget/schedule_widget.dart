import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/logger.dart';
import 'package:alter/common/widget/day_selector.dart';
import 'package:alter/common/widget/time_period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ScheduleWidget extends StatefulWidget {
  @override
  final Key scheduleKey;
  final ValueChanged<Key> onDelete;
  const ScheduleWidget({required this.scheduleKey, required this.onDelete})
    : super(key: scheduleKey);

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  bool isDayChecked = false;
  bool isTimeChecked = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    final String scheduleNumber =
        (widget.scheduleKey as ValueKey).value.toString().split('_').last;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(top: BorderSide(width: 2, color: AppColor.gray[10]!)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "일정 $scheduleNumber",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColor.gray,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Log.d("x 버튼 클릭 ${widget.scheduleKey}");
                  widget.onDelete(widget.scheduleKey);
                },
                child: SvgPicture.asset("assets/icons/x-circle.svg"),
              ),
            ],
          ),
          const Gap(32),
          Row(
            children: [
              Text(
                "근무요일",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColor.gray,
                ),
              ),
              const Spacer(),
              const DaySelector(),
            ],
          ),
          const Gap(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "요일 협의가능",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.gray,
                ),
              ),
              Checkbox(
                value: isDayChecked,
                onChanged: (value) {
                  setState(() {
                    isDayChecked = value!;
                  });
                },
              ),
            ],
          ),
          const Gap(36),
          Row(
            children: [
              Text(
                "근무시간",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColor.gray,
                ),
              ),
              const Gap(36),
              Expanded(
                child: TimePeriodSelector(
                  initialEndTime: const TimeOfDay(hour: 9, minute: 0),
                  initialStartTime: const TimeOfDay(hour: 18, minute: 0),
                  onStartTimeChanged:
                      (time) => setState(() {
                        _startTime = time;
                      }),
                  onEndTimeChanged:
                      (time) => setState(() {
                        _endTime = time;
                      }),
                ),
              ),
            ],
          ),
          const Gap(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "시간 협의가능",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.gray,
                ),
              ),
              Checkbox(
                value: isTimeChecked,
                onChanged: (value) {
                  setState(() {
                    isTimeChecked = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
