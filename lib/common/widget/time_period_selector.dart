import 'package:alter/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TimePeriodSelector extends StatefulWidget {
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final void Function(TimeOfDay?) onStartTimeChanged;
  final void Function(TimeOfDay?) onEndTimeChanged;

  const TimePeriodSelector({
    super.key,
    this.initialStartTime,
    this.initialEndTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  @override
  State<TimePeriodSelector> createState() => _TimePeriodSelectorState();
}

class _TimePeriodSelectorState extends State<TimePeriodSelector> {
  // ValueNotifier를 사용하여 시간 상태를 관리
  late ValueNotifier<TimeOfDay?> _startTimeNotifier;
  late ValueNotifier<TimeOfDay?> _endTimeNotifier;

  // 표시 형식 (오전/오후 HH:MM)
  final DateFormat _displayFormat = DateFormat('hh:mm', 'ko_KR');

  // 30분 단위 시간 목록
  final List<TimeOfDay> _allTimeOptions = [];
  final List<String> _allTimeDisplayOptions = [];

  @override
  void initState() {
    super.initState();
    _startTimeNotifier = ValueNotifier(widget.initialStartTime);
    _endTimeNotifier = ValueNotifier(widget.initialEndTime);

    // ValueNotifier의 값이 변경될 때마다 부모 위젯으로 콜백
    _startTimeNotifier.addListener(() {
      widget.onStartTimeChanged(_startTimeNotifier.value);
    });
    _endTimeNotifier.addListener(() {
      widget.onEndTimeChanged(_endTimeNotifier.value);
    });

    _generateTimeOptions();
  }

  @override
  void dispose() {
    _startTimeNotifier.dispose();
    _endTimeNotifier.dispose();
    super.dispose();
  }

  // 30분 단위 시간 목록 생성
  void _generateTimeOptions() {
    for (int h = 0; h < 24; h++) {
      for (int m = 0; m < 60; m += 30) {
        final time = TimeOfDay(hour: h, minute: m);
        _allTimeOptions.add(time);
        _allTimeDisplayOptions.add(
          _displayFormat.format(DateTime(2000, 1, 1, time.hour, time.minute)),
        );
      }
    }
  }

  // 커스텀 시간 선택 바텀 모달
  Future<void> _showCustomTimePicker(
    BuildContext context,
    TimeOfDay? initialTime,
    ValueNotifier<TimeOfDay?> timeNotifier,
  ) async {
    // 현재 선택된 시간을 찾아 초기 스크롤 위치 설정
    int initialScrollIndex = 0;
    if (initialTime != null) {
      // 정확히 일치하는 TimeOfDay를 찾아 인덱스 반환
      initialScrollIndex = _allTimeOptions.indexWhere(
        (option) =>
            option.hour == initialTime.hour &&
            option.minute == initialTime.minute,
      );
      if (initialScrollIndex == -1) initialScrollIndex = 0; // 찾지 못하면 맨 위로
    }

    final selectedTime = await showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: false, // 높이 고정
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: AppColor.white,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 50%
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColor.gray[20],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "시간 선택",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(height: 24, thickness: 1, color: AppColor.gray[20]),
              Expanded(
                child: ListView.builder(
                  // 초기 스크롤 위치 보정 (ListTile 높이가 약 48이므로)
                  controller: ScrollController(
                    initialScrollOffset: initialScrollIndex * 48.0,
                  ),
                  itemCount: _allTimeOptions.length,
                  itemBuilder: (context, index) {
                    final time = _allTimeOptions[index];
                    final timeDisplay = _allTimeDisplayOptions[index];
                    final bool isSelected =
                        (initialTime != null &&
                            time.hour == initialTime.hour &&
                            time.minute == initialTime.minute);

                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            timeDisplay,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              color:
                                  isSelected ? AppColor.primary : AppColor.text,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          trailing:
                              isSelected
                                  ? const Icon(
                                    Icons.check,
                                    color: AppColor.primary,
                                  )
                                  : null,
                          onTap: () {
                            Navigator.pop(context, time); // 선택된 시간 반환
                          },
                        ),
                        if (index < _allTimeOptions.length - 1)
                          Divider(
                            height: 0,
                            thickness: 0.5,
                            indent: 16,
                            endIndent: 16,
                            color: AppColor.gray[20],
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedTime != null) {
      timeNotifier.value = selectedTime; // ValueNotifier 업데이트
    }
  }

  Widget _buildTimeBox({
    required BuildContext context,
    required String label,
    required ValueNotifier<TimeOfDay?> timeNotifier,
  }) {
    return Expanded(
      // ValueListenableBuilder를 사용하여 timeNotifier의 변경을 감지하고 해당 부분만 리빌드
      child: ValueListenableBuilder<TimeOfDay?>(
        valueListenable: timeNotifier,
        builder: (context, time, child) {
          return InkWell(
            onTap: () => _showCustomTimePicker(context, time, timeNotifier),
            borderRadius: BorderRadius.circular(
              12,
            ), // Container의 borderRadius와 일치
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColor.gray[10], // 스크린샷의 배경색
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    time != null ? time.format(context) : label,
                    style: TextStyle(
                      color: time != null ? AppColor.text : AppColor.gray[50],
                      fontSize: 16,
                      fontWeight:
                          time != null
                              ? FontWeight.normal
                              : FontWeight.w500, // 스크린샷과 유사하게
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/chevron-down.svg",
                    width: 20, // 아이콘 크기 조절
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColor.gray[50]!,
                      BlendMode.srcIn,
                    ), // 아이콘 색상 조절
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTimeBox(
          context: context,
          label: '선택',
          timeNotifier: _startTimeNotifier,
        ),
        const SizedBox(width: 12),
        _buildTimeBox(
          context: context,
          label: '선택',
          timeNotifier: _endTimeNotifier,
        ),
      ],
    );
  }
}
