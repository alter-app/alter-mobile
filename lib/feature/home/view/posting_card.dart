import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class JobPostCard extends StatelessWidget {
  final Posting posting;

  const JobPostCard({super.key, required this.posting});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColor.white,
          height: 288,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: InkWell(
              onTap: () => context.push('/postings/${posting.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "상호야! 너 이름 적고가!",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColor.gray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          posting.title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: AppColor.text,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Gap(25),
                      const Icon(Icons.bookmark_outline),
                    ],
                  ),
                  const Gap(4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${Formatter.formatPaymentType(posting.paymentType)} ",
                        ),
                        TextSpan(
                          text:
                              "${Formatter.formatNumberWithComma(posting.payAmount)} ",
                          style: const TextStyle(
                            color: AppColor.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "원 · 업무내용 · ${Formatter.formatRelativeTime(posting.createdAt)}",
                        ),
                      ],
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColor.gray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColor.gray[40],
                            size: 14,
                          ),
                          const Gap(3),
                          Text(
                            "${posting.schedules.first.startTime.substring(0, 5)} ~ ${posting.schedules.first.endTime.substring(0, 5)}",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: AppColor.gray),
                          ),
                          const Gap(16),
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColor.gray[40],
                            size: 14,
                          ),
                          const Gap(3),
                          Text(
                            posting.schedules.first.workingDays
                                .map((e) => Formatter.formatDay(e))
                                .join(", "),
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: AppColor.gray),
                          ),
                        ],
                      ),
                      Container(
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
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thumb_up_alt_outlined,
                              color: Colors.green,
                              size: 12, // 아이콘 크기 줄임
                            ),
                            SizedBox(width: 4),
                            Text(
                              "999+",
                              style: TextStyle(
                                fontSize: 14, // 텍스트 크기 줄임
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(color: AppColor.gray, height: 142),
                      ),
                      const Gap(4),
                      Flexible(
                        flex: 1,
                        child: Container(color: AppColor.gray, height: 142),
                      ),
                      const Gap(4),
                      Flexible(
                        flex: 1,
                        child: Container(color: AppColor.gray, height: 142),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[10]),
      ],
    );
  }
}
