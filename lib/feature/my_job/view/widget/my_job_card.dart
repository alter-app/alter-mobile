import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/feature/my_job/model/my_job_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

enum ApplyStatus {
  submitted("SUBMITTED", "지원함"),
  accepted("ACCEPTED", "합격"),
  cancelled("CANCELLED", "취소됨"),
  expired("EXPIRED", "만료됨"),
  deleted("DELETED", "삭제됨");

  final String code;
  final String displayName;

  const ApplyStatus(this.code, this.displayName);

  static ApplyStatus fromString(String value) {
    for (var status in ApplyStatus.values) {
      if (status.code == value) {
        return status;
      }
    }
    return ApplyStatus.expired;
  }
}

class MyJobCard extends ConsumerWidget {
  final Application application;
  const MyJobCard({super.key, required this.application});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 132,
        color: AppColor.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(width: 100, height: 100, color: AppColor.gray[20]),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.posting.workspace.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColor.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/clock.svg"),
                      const Gap(4),
                      Text(
                        "${application.postingSchedule.startTime.substring(0, 5)} ~ ${application.postingSchedule.endTime.substring(0, 5)}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColor.gray,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/calendar.svg"),
                      const Gap(4),
                      Text(
                        application.postingSchedule.workingDays
                            .map((e) => Formatter.formatDay(e))
                            .join(", "),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColor.gray,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${Formatter.formatPaymentType(application.posting.paymentType)} ",
                            ),
                            TextSpan(
                              text:
                                  "${Formatter.formatNumberWithComma(application.posting.payAmount)} ",
                              style: const TextStyle(
                                color: AppColor.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: "원"),
                          ],
                        ),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColor.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      applyStatusBadge(application.status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container applyStatusBadge(String status) {
    final applyStatus = ApplyStatus.fromString(status);
    final color = switch (applyStatus) {
      ApplyStatus.submitted || ApplyStatus.accepted => AppColor.primary,
      ApplyStatus.cancelled ||
      ApplyStatus.expired ||
      ApplyStatus.deleted => AppColor.warning,
    };

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            offset: const Offset(1, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Text(
        applyStatus.displayName,
        style: TextStyle(
          fontSize: 14, // 텍스트 크기 줄임
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
