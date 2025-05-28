import 'package:alter/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class PayDropdown extends StatefulWidget {
  const PayDropdown({super.key});

  @override
  State<PayDropdown> createState() => _PayDropdownState();
}

class _PayDropdownState extends State<PayDropdown> {
  String _selectedJob = "기준";
  final List<String> _paytype = ["시급", "일급", "주급", "월급"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPaytypeBottomSheet(context);
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.gray[10],
        ),
        child: Row(
          children: [
            Text(
              _selectedJob,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColor.gray[40],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(22),
            SvgPicture.asset("assets/icons/chevron-down.svg"),
          ],
        ),
      ),
    );
  }

  void _showPaytypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드가 올라올 때 바텀시트가 밀려 올라가도록
      shape: const RoundedRectangleBorder(
        // 상단 모서리를 둥글게
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
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
                  itemCount: _paytype.length,
                  itemBuilder: (context, index) {
                    final job = _paytype[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            job,
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
                            //widget.onJobSelected(job); // 부모 위젯으로 선택 값 전달
                            Navigator.pop(context); // 바텀시트 닫기
                          },
                        ),
                        if (index < _paytype.length - 1) // 마지막 항목 제외하고 구분선 추가
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
