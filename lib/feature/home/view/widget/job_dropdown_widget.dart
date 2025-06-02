import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/view_model/posting_create_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        // 상단 모서리를 둥글게
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      backgroundColor: Colors.white, // 바텀시트 배경색
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 50%
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 드래그 핸들 (선택 사항)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColor.gray[30],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "업직종을 선택하세요",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                height: 24,
                thickness: 1,
                color: AppColor.gray[20],
              ), // 구분선
              Expanded(
                child: ListView.builder(
                  itemCount: widget.jobOptions.length,
                  itemBuilder: (context, index) {
                    final job = widget.jobOptions[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
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
                          trailing:
                              _selectedJob == job
                                  ? const Icon(
                                    Icons.check,
                                    color: AppColor.primary,
                                  )
                                  : null,
                          onTap: () {
                            setState(() {
                              _selectedJob = job; // 상태 업데이트
                            });
                            widget.onSelectionChanged(job.id);
                            Navigator.pop(context); // 바텀시트 닫기
                          },
                        ),
                        if (index <
                            widget.jobOptions.length - 1) // 마지막 항목 제외하고 구분선 추가
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
  }
}
