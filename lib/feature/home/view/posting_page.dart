import 'package:alter/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gap/gap.dart';

class JobPostPage extends StatelessWidget {
  static const _daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"];
  const JobPostPage({super.key});
  // TODO: 상단에 근무 위치 내용이랑 화살표 조금 두꺼워진 것 같아요 전철 뱃지, 시급 뱃지 여백이 조금 다른 것 같아서요
  // 아이콘 업데이트
  @override
  Widget build(BuildContext context) {
    final selectedDays = ["월", "화", "목"];
    return Scaffold(
      backgroundColor: AppColor.gray[10],
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(color: AppColor.gray[20], height: 200),
              Column(
                children: [
                  // 공고 제목
                  Container(
                    color: AppColor.white,
                    height: 125,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "상호야! 너 이름 적고가!",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: AppColor.gray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const BadgeWidget(
                              innerText: "12시간 전",
                              textColor: AppColor.secondary,
                            ),
                          ],
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            "공고이름 최대글자수를 쭉쭉써내려가봅니다ㄱㄱㄱㄱㄱㄴㄴㄴㄴㄴㄴㄴㄷㄷㄷㄷㄷ",
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(
                              color: AppColor.text,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const Gap(8),
                        const Row(
                          children: [
                            BadgeWidget(innerText: "카페"),
                            Gap(8),
                            BadgeWidget(innerText: "음식점"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  // 근무 정보
                  Container(
                    color: AppColor.white,
                    height: 172,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "근무 정보",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: AppColor.gray[40],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.primary,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                "시급",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Gap(8),
                            Text(
                              "10,300원",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(
                                color: AppColor.gray,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(10),
                            Text(
                              "요일",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: AppColor.gray),
                            ),
                            const Gap(40),
                            ..._daysOfWeek.map((day) {
                              final isActive = selectedDays.contains(day);
                              return Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: Text(
                                  day,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    color:
                                        isActive
                                            ? AppColor.text
                                            : AppColor.gray,
                                    fontWeight:
                                        isActive
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                  ),
                                ),
                              );
                            }),
                            const Spacer(),
                            const BadgeWidget(innerText: "협의가능"),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            const Gap(10),
                            Text(
                              "시간",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: AppColor.gray),
                            ),
                            const Gap(40),
                            Text(
                              "09:00 ~ 18:00",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: AppColor.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              "(9시간)",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: AppColor.gray[40],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const BadgeWidget(innerText: "협의가능"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  // 근무 위치
                  Container(
                    color: AppColor.white,
                    height: 352,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "근무 위치",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: AppColor.gray[40],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "경기 무슨시 무슨구 무슨동 무슨로00번길 00 글자수 최대로.ㄱㄱㄱㄱㄱㄴㄴㄴㄴ ",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: AppColor.text,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const Gap(6),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF293F91),
                              ),
                              child: Center(
                                child: Text(
                                  "1",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    color: AppColor.gray[10],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(6),
                            Container(
                              height: 22,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFF1CF69),
                              ),
                              child: Center(
                                child: Text(
                                  "수인 분당선",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    color: AppColor.gray[10],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(6),
                            Text(
                              "무슨역 몇번 출구",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: AppColor.gray,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        //지도
                        Container(
                          color: AppColor.gray,
                          height: 201,
                          // child: const NaverMap(
                          //   options: NaverMapViewOptions(
                          //     initialCameraPosition: NCameraPosition(
                          //       target: NLatLng(37.5665, 126.9780), // 서울 시청 좌표
                          //       zoom: 14,
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  // 상세 내용
                  Container(
                    color: AppColor.white,
                    height: 285,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "상세 내용",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: AppColor.gray[40],
                            fontWeight: FontWeight.w700,
                            height: 1.42,
                          ),
                        ),
                        const Gap(24),
                        // 상세 이미지
                        Container(color: AppColor.gray, height: 201),
                      ],
                    ),
                  ),
                  const Gap(8),
                  // 가계 평판
                  Container(
                    color: AppColor.white,
                    height: 196,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "가계 평판",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: AppColor.gray[40],
                            fontWeight: FontWeight.w700,
                            height: 1.42,
                          ),
                        ),
                        const Gap(18),
                        Text(
                          "복합적",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: AppColor.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Row(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final String innerText;
  final Color? textColor;

  const BadgeWidget({super.key, required this.innerText, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
      decoration: BoxDecoration(
        color: AppColor.gray[10],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        innerText,
        style: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: textColor ?? AppColor.gray),
      ),
    );
  }
}
