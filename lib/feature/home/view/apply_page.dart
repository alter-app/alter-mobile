import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/common/util/logger.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/view/posting_page.dart';
import 'package:alter/feature/home/view_model/posting_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ApplyPage extends ConsumerStatefulWidget {
  final int postId;
  const ApplyPage({super.key, required this.postId});

  @override
  ConsumerState<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends ConsumerState<ApplyPage> {
  final TextEditingController _selfIntroductionController =
      TextEditingController();
  String? _selfIntroductionErrorText;
  bool _isInitialSelectionDone = false;

  @override
  void dispose() {
    _selfIntroductionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(
      postingDetailViewModelProvider(widget.postId).notifier,
    );
    final state = ref.watch(postingDetailViewModelProvider(widget.postId));

    return Scaffold(
      backgroundColor: AppColor.gray[10],
      appBar: AppBar(
        title: Text("지원하기", style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: state.posting.when(
          data: (posting) {
            final schedules = posting.schedules;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_isInitialSelectionDone) {
                vm.updateSelectedSchdule(schedules.first.id);
                _isInitialSelectionDone = true;
              }
            });
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          //height: 228,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          color: AppColor.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "공고 정보",
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(color: AppColor.text),
                              ),
                              const Gap(12),
                              Text(
                                posting.workspace.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.text,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                posting.workspace.fullAddress,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.text,
                                ),
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  // 급여 종류
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 0.5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColor.gray[20]!,
                                        width: 1,
                                      ),
                                      color: AppColor.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${Formatter.formatPaymentType(posting.paymentType)} ",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  // 급여
                                  Text(
                                    "${Formatter.formatNumberWithComma(posting.payAmount)} 원",
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
                              Text(
                                "공고 상세",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.text,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                posting.description,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(2),
                        // 근무 리스트
                        Column(
                          children:
                              schedules
                                  .map(
                                    (schedule) => Column(
                                      children: [
                                        ScheduleSelector(
                                          postId: widget.postId,
                                          schedule: schedule,
                                        ),
                                        const Gap(2),
                                      ],
                                    ),
                                  )
                                  .toList(),
                        ),
                        // 자기 소개
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: AppColor.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "자기 소개",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Gap(24),
                              TextField(
                                controller: _selfIntroductionController,
                                maxLines: 4,
                                maxLength: 200,
                                decoration: InputDecoration(
                                  errorText: _selfIntroductionErrorText,
                                ),
                                onChanged:
                                    (value) => setState(() {
                                      _selfIntroductionErrorText = null;
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 72,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                  child: ElevatedButton(
                    onPressed:
                        state.selectedScheduleId == null
                            ? null
                            : () async {
                              if (_selfIntroductionController.text
                                  .trim()
                                  .isEmpty) {
                                setState(() {
                                  _selfIntroductionErrorText = "자기소개를 입력해주세요.";
                                });
                              }
                              if (_selfIntroductionController.text.length <
                                  15) {
                                setState(() {
                                  _selfIntroductionErrorText = "15자 이상 작성해주세요";
                                });
                              }
                              final result = await ref
                                  .read(
                                    postingDetailViewModelProvider(
                                      widget.postId,
                                    ).notifier,
                                  )
                                  .applyJob(
                                    state.selectedScheduleId!,
                                    _selfIntroductionController.text,
                                  );
                              if (result && context.mounted) {
                                context.pop();
                              }
                            },
                    child: Center(
                      child: Text(
                        "제출",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          error:
              (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('오류가 발생했습니다: $error'),
                    ElevatedButton(
                      onPressed:
                          () =>
                              ref
                                  .read(
                                    postingDetailViewModelProvider(
                                      widget.postId,
                                    ).notifier,
                                  )
                                  .fetchData(),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class ScheduleSelector extends ConsumerWidget {
  const ScheduleSelector({
    super.key,
    required this.postId,
    required this.schedule,
  });
  final int postId;
  final Schedule schedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"];

    final int? selectedId =
        ref.watch(postingDetailViewModelProvider(postId)).selectedScheduleId;
    final bool isSelected = selectedId == schedule.id; // 현재 스케줄이 선택되었는지 확인

    return GestureDetector(
      onTap: () {
        Log.d("selectedId: $selectedId  this: ${schedule.id}");
        ref
            .watch(postingDetailViewModelProvider(postId).notifier)
            .updateSelectedSchdule(schedule.id);
      },
      child: Container(
        height: 90,
        color: AppColor.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 19, 36, 19),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColor.primary : AppColor.gray[20]!,
                    width: isSelected ? 6 : 1,
                  ),
                ),
              ),
            ),
            const Gap(4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...daysOfWeek.map((day) {
                        final isActive = schedule.workingDays
                            .map((e) => Formatter.formatDay(e))
                            .contains(day);
                        return Padding(
                          padding: const EdgeInsets.only(right: 19.9),
                          child: Text(
                            day,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: isActive ? AppColor.text : AppColor.gray,
                              fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w500,
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
                      Text(
                        "${schedule.startTime.substring(0, 5)}  ~  ${schedule.endTime.substring(0, 5)}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColor.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        "(${Formatter.calculateWorkHours(schedule.startTime, schedule.endTime)})",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
          ],
        ),
      ),
    );
  }
}
