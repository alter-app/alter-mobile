import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/feature/home/view/widget/job_dropdown_widget.dart';
import 'package:alter/feature/home/view/widget/pay_dropdown.dart';
import 'package:alter/feature/home/view/widget/schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class PostingCreatePage extends StatefulWidget {
  const PostingCreatePage({super.key});

  @override
  State<PostingCreatePage> createState() => _PostingCreatePageState();
}

class _PostingCreatePageState extends State<PostingCreatePage> {
  final List<Widget> _scheduleWidgets = [];
  int _scheduleCounter = 0;
  final int _minWage = 10300;

  // ScheduleWidget을 리스트에 추가하는 함수
  void _addScheduleWidget() {
    setState(() {
      _scheduleCounter++;
      final ValueKey currentKey = ValueKey('schedule_$_scheduleCounter');
      _scheduleWidgets.add(
        ScheduleWidget(
          scheduleKey: currentKey, // 각 위젯에 고유 키 부여
          onDelete: (key) {
            _removeScheduleWidget(key);
          },
        ),
      );
    });
  }

  // ScheduleWidget을 리스트에서 제거하는 함수
  void _removeScheduleWidget(Key keyToRemove) {
    setState(() {
      _scheduleWidgets.removeWhere((widget) => widget.key == keyToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.gray[10],
      appBar: AppBar(
        title: Text("공고 작성", style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(2),
                    // 공고 제목
                    Container(
                      color: AppColor.white,
                      height: 132,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      child: Column(
                        children: [
                          makeHeadLine(
                            context,
                            title: "공고 제목",
                            helperText: "17자 이상 작성시 제목이 잘려요!",
                          ),
                          const Gap(16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "공고가 잘 드러나도록 제목을 작성해봐요.",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(2),
                    // 업직종
                    Container(
                      color: AppColor.white,
                      height: 244,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      child: Column(
                        children: [
                          makeHeadLine(
                            context,
                            title: "업직종",
                            helperText: "업직종은 3개까지 선택 가능합니다",
                          ),
                          const Gap(16),
                          const JobSelectDropdown(),
                          const Gap(8),
                          const JobSelectDropdown(),
                          const Gap(8),
                          const JobSelectDropdown(),
                        ],
                      ),
                    ),
                    const Gap(2),
                    Container(
                      color: AppColor.white,
                      height: 134,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      child: Column(
                        children: [
                          makeHeadLine(context, title: "상호명"),
                          const Gap(16),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(hintText: "상호 이름"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(2),
                    Container(
                      color: AppColor.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      child: makeHeadLine(context, title: "근무일정"),
                    ),
                    // 일정
                    ..._scheduleWidgets,
                    // 일정 추가 버튼
                    Container(
                      color: AppColor.white,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: GestureDetector(
                        onTap: () => _addScheduleWidget(),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: AppColor.gray[20]!,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/plus_in_circle.svg",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(2),
                    Container(
                      color: AppColor.white,
                      height: 301,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          makeHeadLine(
                            context,
                            title: "급여",
                            helperText: "급여는 시급으로 자동 변환됩니다.",
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              const SizedBox(width: 92, child: PayDropdown()),
                              const Gap(4),
                              const Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "금액 직접 입력",
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(4),
                              Text(
                                "원",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: AppColor.text,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Gap(4),
                          Row(
                            children: [
                              const Gap(4),
                              Text(
                                "최저임금 ${Formatter.formatNumberWithComma(_minWage)}원 기준",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: AppColor.warning,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Gap(24),
                          Row(
                            children: [
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "휴게시간 제외한 근무시간을 기입 해 주세요.",
                                  ),
                                ),
                              ),
                              const Gap(6),
                              Text(
                                "시간",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: AppColor.text,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Gap(30),
                          Container(
                            width: 250,
                            height: 34,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: AppColor.gray[20]!,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Gap(4),
                                Text(
                                  "책정시급",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.gray,
                                  ),
                                ),
                                const Gap(16),
                                Text(
                                  Formatter.formatNumberWithComma(999999999),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: AppColor.text),
                                ),
                                const Gap(16),
                                Text(
                                  "원",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    color: AppColor.text,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 버튼
            Container(
              height: 64,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "다음",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row makeHeadLine(
    BuildContext context, {
    required String title,
    String? helperText,
  }) {
    return Row(
      children: [
        const Gap(4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColor.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          helperText ?? "",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: AppColor.gray[40]),
        ),
      ],
    );
  }
}
