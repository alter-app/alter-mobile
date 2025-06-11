import 'package:alter/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

enum PayType {
  hourly("HOURLY", "시급"),
  daily("DAILY", "일급"),
  weekly("WEEKLY", "주급"),
  monthly("MONTHLY", "월급");

  final String code;
  final String displayName;

  const PayType(this.code, this.displayName);
}

class PayTypeSelector extends StatefulWidget {
  final void Function(PayType) onPayTypeChanged;
  const PayTypeSelector({super.key, required this.onPayTypeChanged});

  @override
  State<PayTypeSelector> createState() => _PayTypeSelectorState();
}

class _PayTypeSelectorState extends State<PayTypeSelector> {
  PayType selectedPayType = PayType.hourly;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          PayType.values
              .map(
                (pay) => Container(
                  padding: const EdgeInsets.only(right: 24),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPayType = pay;
                      });
                      widget.onPayTypeChanged(pay);
                    },
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  selectedPayType == pay
                                      ? AppColor.primary
                                      : AppColor.gray[20]!,
                              width: selectedPayType == pay ? 6 : 1,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          pay.displayName,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: AppColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
