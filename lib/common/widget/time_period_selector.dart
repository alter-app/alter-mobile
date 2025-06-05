import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TimePeriodSelector extends StatefulWidget {
  final void Function(String) onStartTimeChanged;
  final void Function(String) onEndTimeChanged;

  const TimePeriodSelector({
    super.key,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  @override
  State<TimePeriodSelector> createState() => _TimePeriodSelectorState();
}

class _TimePeriodSelectorState extends State<TimePeriodSelector> {
  final ValueNotifier<TimeOfDay> _startTimeNotifier = ValueNotifier(
    const TimeOfDay(hour: 9, minute: 0),
  );
  final ValueNotifier<TimeOfDay> _endTimeNotifier = ValueNotifier(
    const TimeOfDay(hour: 18, minute: 0),
  );

  final DateFormat _displayFormat = DateFormat('a hh:mm', 'ko_KR');

  final List<TimeOfDay> _allTimeOptions = [];
  final List<String> _allTimeDisplayOptions = [];

  // 피커 아이템 높이 (대략적인 값)
  static const double _pickerItemHeight = 48.0;

  @override
  void initState() {
    super.initState();
    _startTimeNotifier.addListener(() {
      widget.onStartTimeChanged(_formatTimeOfDay(_startTimeNotifier.value));
    });
    _endTimeNotifier.addListener(() {
      widget.onEndTimeChanged(_formatTimeOfDay(_endTimeNotifier.value));
    });

    _generateTimeOptions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onStartTimeChanged(_formatTimeOfDay(_startTimeNotifier.value));
      widget.onEndTimeChanged(_formatTimeOfDay(_endTimeNotifier.value));
    });
  }

  @override
  void dispose() {
    _startTimeNotifier.dispose();
    _endTimeNotifier.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

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

  // TimePicker UI (스크롤 휠)
  Widget _buildTimePickerWheel({
    required BuildContext context,
    required List<TimeOfDay> options,
    required List<String> displayOptions,
    required TimeOfDay? selectedTime,
    required ValueChanged<TimeOfDay> onTimeChanged,
    required FixedExtentScrollController
    scrollController, // FixedExtentScrollController 사용
  }) {
    return ListWheelScrollView.useDelegate(
      controller: scrollController,
      itemExtent: _pickerItemHeight, // 각 항목의 높이
      perspective: 0.005, // 3D 효과 (선택 사항)
      magnification: 1.2, // 중앙 아이템 확대 (선택 사항)
      diameterRatio: 1.2, // 휠의 지름 비율 (선택 사항)
      physics: const FixedExtentScrollPhysics(), // 항목에 스냅되도록 설정
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final time = options[index];
          final timeDisplay = displayOptions[index];
          final bool isSelected =
              (selectedTime != null &&
                  time.hour == selectedTime.hour &&
                  time.minute == selectedTime.minute);

          return Center(
            child: Text(
              timeDisplay,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: isSelected ? AppColor.primary : AppColor.text,
                fontSize: isSelected ? 20 : 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
        childCount: options.length,
      ),
      onSelectedItemChanged: (index) {
        // 스크롤이 멈추고 중앙 항목이 변경될 때 호출됩니다.
        onTimeChanged(options[index]);
      },
    );
  }

  Future<void> _showTimeRangePicker(BuildContext context) async {
    // 모달을 띄울 때 현재 ViewModel의 값을 초기값으로 설정
    TimeOfDay tempSelectedStartTime = _startTimeNotifier.value;
    TimeOfDay tempSelectedEndTime = _endTimeNotifier.value;

    // 초기 스크롤 위치 계산
    int initialStartIndex = _allTimeOptions.indexWhere(
      (option) =>
          option.hour == tempSelectedStartTime.hour &&
          option.minute == tempSelectedStartTime.minute,
    );
    if (initialStartIndex == -1) initialStartIndex = 0; // 그래도 없으면 맨 위로

    int initialEndIndex = _allTimeOptions.indexWhere(
      (option) =>
          option.hour == tempSelectedEndTime.hour &&
          option.minute == tempSelectedEndTime.minute,
    );
    if (initialEndIndex == -1) initialEndIndex = 0; // 그래도 없으면 맨 위로

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      backgroundColor: AppColor.white,
      builder: (BuildContext context) {
        // 모달 내부에서 사용할 ScrollController
        final FixedExtentScrollController startScrollController =
            FixedExtentScrollController(initialItem: initialStartIndex);
        final FixedExtentScrollController endScrollController =
            FixedExtentScrollController(initialItem: initialEndIndex);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "근무 시간 선택",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.text,
                    ),
                  ),
                  Divider(height: 24, thickness: 1, color: AppColor.gray[20]),
                  Expanded(
                    child: Row(
                      children: [
                        // 시작 시간 스크롤 휠
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "시작 시간",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.text,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _buildTimePickerWheel(
                                  context: context,
                                  options: _allTimeOptions,
                                  displayOptions: _allTimeDisplayOptions,
                                  selectedTime: tempSelectedStartTime,
                                  onTimeChanged: (newTime) {
                                    modalSetState(() {
                                      tempSelectedStartTime = newTime;
                                    });
                                  },
                                  scrollController: startScrollController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          width: 24,
                          thickness: 1,
                          color: AppColor.gray[20],
                        ),
                        // 종료 시간 스크롤 휠
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "종료 시간",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.text,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _buildTimePickerWheel(
                                  context: context,
                                  options: _allTimeOptions,
                                  displayOptions: _allTimeDisplayOptions,
                                  selectedTime: tempSelectedEndTime,
                                  onTimeChanged: (newTime) {
                                    modalSetState(() {
                                      tempSelectedEndTime = newTime;
                                    });
                                  },
                                  scrollController: endScrollController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, {
                        'start': tempSelectedStartTime,
                        'end': tempSelectedEndTime,
                      });
                    },

                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '선택 완료',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        _startTimeNotifier.value = result['start'];
        _endTimeNotifier.value = result['end'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showTimeRangePicker(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColor.gray[10],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<TimeOfDay?>(
              valueListenable: _startTimeNotifier,
              builder: (context, startTime, child) {
                return Text(
                  startTime != null
                      ? _displayFormat.format(
                        DateTime(2000, 1, 1, startTime.hour, startTime.minute),
                      )
                      : '시작 시간',
                  style: TextStyle(
                    color:
                        startTime != null ? AppColor.text : AppColor.gray[50],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            Text(
              '~',
              style: TextStyle(
                color: AppColor.gray[50],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            ValueListenableBuilder<TimeOfDay?>(
              valueListenable: _endTimeNotifier,
              builder: (context, endTime, child) {
                return Text(
                  endTime != null
                      ? _displayFormat.format(
                        DateTime(2000, 1, 1, endTime.hour, endTime.minute),
                      )
                      : '종료 시간',
                  style: TextStyle(
                    color: endTime != null ? AppColor.text : AppColor.gray[50],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            SvgPicture.asset(
              "assets/icons/chevron-down.svg",
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                AppColor.gray[50]!,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
