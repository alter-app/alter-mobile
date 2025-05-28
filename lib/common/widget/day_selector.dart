import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/logger.dart';
import 'package:flutter/material.dart';

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

class DaySelector extends StatefulWidget {
  const DaySelector({super.key});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  final Set<Day> _selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children:
          Day.values.map((day) {
            final bool isSelected = _selectedDays.contains(day);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(day);
                  } else {
                    _selectedDays.add(day);
                  }
                  Log.i(
                    'Selected Days: ${_selectedDays.map((d) => d.displayName).join(', ')}',
                  );
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
