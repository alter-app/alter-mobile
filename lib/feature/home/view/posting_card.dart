import 'package:alter/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class JobPostCard extends StatelessWidget {
  const JobPostCard({super.key});

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
                        "공고이름 최대글자수를 쭉쭉써내려가봅니다ㄱㄱㄱㄱㄱㄴㄴㄴㄴㄴㄴㄴㄷㄷㄷㄷㄷ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                  const TextSpan(
                    children: [
                      TextSpan(text: "시급 "),
                      TextSpan(
                        text: "10,030 ",
                        style: TextStyle(
                          color: AppColor.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "원 · 업무내용 · 1일전"),
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
                          "12:00 ~ 18:00",
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
                          "월, 수, 토, 일",
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
        Divider(height: 1, thickness: 1, color: Colors.grey[10]),
      ],
    );
  }
}
