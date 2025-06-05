import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class JobSelectDropdown extends ConsumerStatefulWidget {
  final ValueChanged<int?> onSelectionChanged;
  final List<Keyword> jobOptions;
  const JobSelectDropdown({
    super.key,
    required this.onSelectionChanged,
    required this.jobOptions,
  });

  @override
  ConsumerState<JobSelectDropdown> createState() => _JobSelectDropdownState();
}

class _JobSelectDropdownState extends ConsumerState<JobSelectDropdown> {
  Keyword? _selectedJob;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showJobSelectionBottomSheet(context);
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: AppColor.gray[20]!),
        ),
        child: Row(
          children: [
            Text(
              _selectedJob != null ? _selectedJob!.name : "선택안함",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColor.text,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SvgPicture.asset("assets/icons/chevron-down.svg"),
          ],
        ),
      ),
    );
  }

  void _showJobSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드가 올라올 때 바텀시트가 밀려 올라가도록
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      backgroundColor: AppColor.white, // 바텀시트 배경색
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 50%
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "업직종을 선택하세요",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.text,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.jobOptions.length,
                  itemBuilder: (context, index) {
                    final job = widget.jobOptions[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedJob = job; // 상태 업데이트
                            });
                            widget.onSelectionChanged(job.id);
                            context.pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                const Gap(4),
                                Text(
                                  job.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(
                                    color:
                                        _selectedJob == job
                                            ? AppColor.primary
                                            : AppColor.text,
                                    fontWeight:
                                        _selectedJob == job
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                                const Spacer(),
                                if (_selectedJob == job)
                                  const Icon(
                                    Icons.check,
                                    color: AppColor.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (index <
                            widget.jobOptions.length - 1) // 마지막 항목 제외하고 구분선 추가
                          Divider(
                            height: 0,
                            thickness: 0.5,
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
  }
}
