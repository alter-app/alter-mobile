import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Day {
  monday("MONDAY", "월"),
  tuesday("TUESDAY", "화"),
  wednesday("WEDNESDAY", "수"),
  thursday("THURSDAY", "목"),
  friday("FRIDAY", "금"),
  saturday("SATURDAY", "토"),
  sunday("SUNDAY", "일");

  final String code;
  final String displayName;

  const Day(this.code, this.displayName);
}

class DaySelector extends ConsumerStatefulWidget {
  final Set<Day> selectedDays;
  final ValueChanged<Set<Day>> onSelectionChanged;
  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends ConsumerState<DaySelector> {
  final Set<Day> _currentSelectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children:
          Day.values.map((day) {
            final bool isSelected = _currentSelectedDays.contains(day);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _currentSelectedDays.remove(day);
                  } else {
                    _currentSelectedDays.add(day);
                  }
                  widget.onSelectionChanged(_currentSelectedDays);
                  // Log.i(
                  //   'Selected Days: ${_currentSelectedDays.map((d) => d.displayName).join(', ')}',
                  // );
                });
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected ? AppColor.primary : null,
                  border: Border.all(
                    color: isSelected ? AppColor.primary : AppColor.gray[20]!,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    day.displayName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isSelected ? AppColor.white : AppColor.gray[40],
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
