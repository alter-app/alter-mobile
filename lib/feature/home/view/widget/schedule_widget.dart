import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/logger.dart';
import 'package:alter/common/widget/day_selector.dart';
import 'package:alter/common/widget/time_period_selector.dart';
import 'package:alter/feature/home/model/schedule_data_model.dart';
import 'package:alter/feature/home/view_model/posting_create_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ScheduleWidget extends ConsumerWidget {
  final ScheduleData schedule; // ViewModel에서 전달받을 Schedule 객체
  final ValueChanged<int> onDelete; // id로 삭제 요청

  const ScheduleWidget({
    required this.schedule,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postingCreateViewModel = ref.read(
      postingCreateViewModelProvider.notifier,
    );
    final bool isDayNegotiable = schedule.isDayNegotiable;
    final bool isTimeNegotiable = schedule.isTimeNegotiable;

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
                "일정 ${schedule.id}",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColor.gray,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Log.d("x 버튼 클릭 ${schedule.id}");
                  onDelete(schedule.id);
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
              DaySelector(
                selectedDays: schedule.selectedDays,
                onSelectionChanged: (selectedDays) {
                  postingCreateViewModel.updateScheduleDays(
                    schedule.id,
                    selectedDays,
                  );
                },
              ),
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
                value: isDayNegotiable,
                onChanged: (value) {
                  if (value != null) {
                    postingCreateViewModel.updateScheduleDayNegotiable(
                      schedule.id,
                      value,
                    );
                  }
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
                  onStartTimeChanged:
                      (time) => postingCreateViewModel.updateScheduleStartTime(
                        schedule.id,
                        time,
                      ),
                  onEndTimeChanged:
                      (time) => postingCreateViewModel.updateScheduleEndTime(
                        schedule.id,
                        time,
                      ),
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
                value: isTimeNegotiable,
                onChanged: (value) {
                  if (value != null) {
                    postingCreateViewModel.updateScheduleTimeNegotiable(
                      schedule.id,
                      value,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
