import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/common/util/%08formater/number_with_comma_formatter.dart';
import 'package:alter/common/util/logger.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/view/widget/job_dropdown_widget.dart';
import 'package:alter/feature/home/view/widget/paytype_selector.dart';
import 'package:alter/feature/home/view/widget/schedule_widget.dart';
import 'package:alter/feature/home/view_model/posting_create_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PostingCreatePage extends ConsumerStatefulWidget {
  const PostingCreatePage({super.key});

  @override
  ConsumerState<PostingCreatePage> createState() => _PostingCreatePageState();
}

class _PostingCreatePageState extends ConsumerState<PostingCreatePage> {
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();
  final int _minWage = 10300;
  int calculateToHouly = 0;

  final List<int?> _selectedKeywordIds = List.filled(3, null);
  String? _titleErrorText;
  String? _keywordsErrorText;
  String? _scheduleErrorText;
  String? _payAmountErrorText;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _payAmountController = TextEditingController();
  final TextEditingController _worktimeController = TextEditingController();

  @override
  void initState() {
    // 추후 사업자 정보를 별도의 view model에서 호출할 예정
    _companyNameController.text = "우리 매장 이름";
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async =>
          await ref.read(postingCreateViewModelProvider.notifier).getKeyword(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _payAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postingCreateState = ref.watch(postingCreateViewModelProvider);
    final postingCreateViewModel = ref.read(
      postingCreateViewModelProvider.notifier,
    );
    ref.listen<PostingCreateState>(postingCreateViewModelProvider, (
      previousState,
      newState,
    ) {
      // newState는 API 호출 후 업데이트된 최신 상태입니다.
      if (newState.isPostingSuccess && context.mounted) {
        _clearFormAndAnimatedList();
        context.pop(); // 성공 시 화면 닫기
      }
    });

    final List<Keyword> allKeywords = postingCreateState.keywords;

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
                      height: _titleErrorText == null ? 132 : 158,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          makeHeadLine(
                            context,
                            title: "공고 제목",
                            helperText: "17자 이상 작성시 제목이 잘려요!",
                          ),
                          const Gap(16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: "공고가 잘 드러나도록 제목을 작성해봐요.",
                              ),
                              onChanged: (value) {
                                postingCreateViewModel.updateTitle(value);
                                setState(() {
                                  _titleErrorText = null;
                                });
                              },
                            ),
                          ),
                          const Gap(4),
                          if (_titleErrorText != null)
                            Row(
                              children: [
                                const Gap(4),
                                Text(
                                  _titleErrorText!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color: AppColor.warning,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const Gap(2),
                    // 업직종
                    Container(
                      color: AppColor.white,
                      //height: 244,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        children: [
                          makeHeadLine(
                            context,
                            title: "업직종",
                            helperText: "업직종은 3개까지 선택 가능합니다",
                          ),
                          const Gap(16),
                          JobSelectDropdown(
                            jobOptions: allKeywords,
                            onSelectionChanged: (value) {
                              _selectedKeywordIds[0] = value;
                              postingCreateViewModel.updateselectedKeywords(
                                _selectedKeywordIds,
                              );
                              setState(() {
                                _keywordsErrorText = null;
                              });
                            },
                          ),
                          const Gap(8),
                          JobSelectDropdown(
                            jobOptions: allKeywords,
                            onSelectionChanged: (value) {
                              _selectedKeywordIds[1] = value;
                              postingCreateViewModel.updateselectedKeywords(
                                _selectedKeywordIds,
                              );
                              setState(() {
                                _keywordsErrorText = null;
                              });
                            },
                          ),
                          const Gap(8),
                          JobSelectDropdown(
                            jobOptions: allKeywords,
                            onSelectionChanged: (value) {
                              _selectedKeywordIds[2] = value;
                              postingCreateViewModel.updateselectedKeywords(
                                _selectedKeywordIds,
                              );
                              setState(() {
                                _keywordsErrorText = null;
                              });
                            },
                          ),
                          const Gap(4),
                          if (_keywordsErrorText != null)
                            Row(
                              children: [
                                const Gap(4),
                                Text(
                                  _keywordsErrorText!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color: AppColor.warning,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
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
                          Expanded(
                            child: TextField(
                              controller: _companyNameController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: "상호 이름",
                              ),
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
                    AnimatedList(
                      key: _animatedListKey,
                      shrinkWrap: true, // 내부 콘텐츠에 맞춰 크기 조절
                      physics:
                          const NeverScrollableScrollPhysics(), // 부모 SingleChildScrollView가 스크롤 처리
                      initialItemCount: postingCreateState.schedules.length,
                      itemBuilder: (context, index, animation) {
                        final schedule = postingCreateState.schedules[index];
                        return SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1.0, // 위로 커지고 작아지는 애니메이션
                          child: FadeTransition(
                            opacity: animation,
                            child: ScheduleWidget(
                              schedule:
                                  schedule, // ViewModel에서 가져온 Schedule 객체 전달
                              onDelete: (id) {
                                final removedIndex = postingCreateState
                                    .schedules
                                    .indexWhere((s) => s.id == id);
                                if (removedIndex != -1) {
                                  _animatedListKey.currentState?.removeItem(
                                    removedIndex,
                                    (context, animation) => SizeTransition(
                                      // 삭제 애니메이션
                                      sizeFactor: animation,
                                      axisAlignment: -1.0,
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: ScheduleWidget(
                                          schedule: schedule, // 삭제될 위젯 내용
                                          onDelete:
                                              (_) {}, // 애니메이션 중에는 다시 삭제 호출 방지
                                        ),
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 300),
                                  );
                                  postingCreateViewModel.removeSchedule(
                                    id,
                                  ); // ViewModel에서 데이터 삭제
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    // 일정 추가 버튼
                    Container(
                      color: AppColor.white,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              postingCreateViewModel.addSchedule();
                              // AnimatedList에 새 아이템 추가 애니메이션
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _animatedListKey.currentState?.insertItem(
                                  postingCreateState.schedules.length,
                                  duration: const Duration(milliseconds: 200),
                                );
                              });
                              setState(() {
                                _scheduleErrorText = null;
                              });
                            },
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
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
                          const Gap(4),
                          if (_scheduleErrorText != null)
                            Row(
                              children: [
                                const Gap(4),
                                Text(
                                  _scheduleErrorText!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color: AppColor.warning,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const Gap(2),
                    // 급여
                    Container(
                      color: AppColor.white,
                      //height: 350,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          makeHeadLine(
                            context,
                            title: "급여",
                            helperText: "급여는 시급으로 자동 변환됩니다.",
                          ),
                          const Gap(24),
                          PayTypeSelector(
                            onPayTypeChanged: (pay) {
                              postingCreateViewModel.updatePaymentType(
                                pay.code,
                              );
                            },
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextField(
                                    controller: _payAmountController,
                                    maxLength: 11,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      NumberWithCommaFormatter(),
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: "금액 직접 입력",
                                      counterText: "",
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        return;
                                      } else {
                                        final number =
                                            value.split(',').join("").trim();
                                        postingCreateViewModel.updatePayAmount(
                                          int.tryParse(number),
                                        );
                                      }
                                      setState(() {
                                        _payAmountErrorText = null;
                                      });
                                      if (postingCreateState.paymentType !=
                                          "HOURLY") {
                                        _calculateToHourly();
                                      }
                                    },
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
                                _payAmountErrorText != null
                                    ? _payAmountErrorText!
                                    : "최저임금 ${Formatter.formatNumberWithComma(_minWage)}원 기준",
                                style:
                                    _payAmountErrorText != null
                                        ? Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.copyWith(
                                          color: AppColor.warning,
                                          fontWeight: FontWeight.w500,
                                        )
                                        : Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color: AppColor.text,
                                          fontWeight: FontWeight.w500,
                                        ),
                              ),
                            ],
                          ),
                          if (postingCreateState.paymentType != "HOURLY")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Gap(24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 48,
                                        child: TextField(
                                          controller: _worktimeController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: const InputDecoration(
                                            hintText:
                                                "휴게시간 제외한 근무시간을 기입 해 주세요.",
                                          ),
                                          onChanged:
                                              (_) => _calculateToHourly(),
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                        Formatter.formatNumberWithComma(
                                          calculateToHouly,
                                        ),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 버튼
            Container(
              width: double.infinity,
              height: 72,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: ElevatedButton(
                onPressed: () async {
                  bool isValid = true;
                  // 제목 유효성 검사
                  if (_titleController.text.trim().isEmpty) {
                    setState(() {
                      _titleErrorText = "제목을 입력해주세요.";
                    });
                    isValid = false;
                  }
                  // 키워드 유효성 검사
                  final keywords =
                      _selectedKeywordIds.whereType<int>().toList();
                  if (keywords.isEmpty) {
                    setState(() {
                      _keywordsErrorText = "업직종을 하나 이상을 선택해주세요.";
                    });
                    isValid = false;
                  }
                  // 일정 유효성 검사
                  if (postingCreateState.schedules.isEmpty) {
                    setState(() {
                      _scheduleErrorText = "적어도 하나의 일정을 등록해주세요.";
                    });
                    isValid = false;
                  }
                  // 급여 유효성 검사
                  final payAmountText =
                      _payAmountController.text.split(',').join("").trim();
                  final parsedPayAmount = int.tryParse(payAmountText);
                  if (payAmountText.isEmpty) {
                    setState(() {
                      _payAmountErrorText = "급여를 입력해주세요.";
                    });
                    isValid = false;
                  } else if (parsedPayAmount == null) {
                    setState(() {
                      _payAmountErrorText = "유효한 값을 입력해주세요.";
                    });
                    isValid = false;
                  } else if (parsedPayAmount < _minWage) {
                    setState(() {
                      _payAmountErrorText = "급여가 최저시급을 만족하지 못합니다.";
                    });
                    isValid = false;
                  }
                  Log.d("isValid: $isValid");
                  if (isValid) {
                    await postingCreateViewModel.createPosting();
                  }
                },
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

  void _clearFormAndAnimatedList() {
    final currentSchedules = ref.read(postingCreateViewModelProvider).schedules;

    // ViewModel의 상태를 먼저 초기화
    ref.read(postingCreateViewModelProvider.notifier).clear();

    // AnimatedList의 모든 아이템을 제거 애니메이션과 함께 지움
    if (_animatedListKey.currentState != null) {
      for (int i = currentSchedules.length - 1; i >= 0; i--) {
        _animatedListKey.currentState!.removeItem(
          i, // 역순으로 제거해야 인덱스 문제가 발생하지 않음
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: FadeTransition(
              opacity: animation,
              child: ScheduleWidget(
                schedule: currentSchedules[i], // 제거될 위젯 내용
                onDelete: (_) {}, // 애니메이션 중에는 다시 삭제 호출 방지
              ),
            ),
          ),
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  void _calculateToHourly() {
    final wage =
        int.tryParse(_payAmountController.text.split(',').join("").trim()) ?? 0;

    final worktime = int.tryParse(_worktimeController.text) ?? 1;
    //Log.d("wage: $wage, worktime: $worktime");
    setState(() {
      calculateToHouly = wage ~/ worktime;
    });
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
