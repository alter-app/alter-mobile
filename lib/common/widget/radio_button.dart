import 'package:alter/common/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum Gender {
  male('GENDER_MALE', '남'),
  female('GENDER_FEMALE', '여');

  final String code;
  final String displayName;

  const Gender(this.code, this.displayName);
}

class CustomRadio extends StatefulWidget {
  final List<RadioModel> radioItems;
  final ValueChanged<String>? onSelected;
  const CustomRadio({super.key, required this.radioItems, this.onSelected});

  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.gray[10],
      ),
      child: Row(
        children: List.generate(widget.radioItems.length, (index) {
          final item = widget.radioItems[index];
          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  for (var element in widget.radioItems) {
                    element.isSelected = false;
                  }
                  item.isSelected = true;
                });
                widget.onSelected?.call(item.value);
              },
              child: RadioItem(
                item: item,
                isFirst: index == 0,
                isLast: index == widget.radioItems.length - 1,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel item;
  final bool isFirst;
  final bool isLast;
  const RadioItem({
    super.key,
    required this.item,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: item.isSelected ? AppColor.primary : AppColor.gray[10],
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(8) : Radius.zero,
          bottomLeft: isFirst ? const Radius.circular(8) : Radius.zero,
          topRight: isLast ? const Radius.circular(8) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(8) : Radius.zero,
        ),
      ),
      child: Center(
        child: Text(
          item.buttonText,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            color: item.isSelected ? AppColor.white : AppColor.text,
          ),
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String value;

  RadioModel({
    required this.isSelected,
    required this.buttonText,
    required this.value,
  });
}
