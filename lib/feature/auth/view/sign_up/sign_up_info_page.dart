import 'package:alter/common/util/%08formater/birth_input_formatter.dart';
import 'package:alter/common/util/%08formater/phone_text_formatter.dart';
import 'package:alter/common/util/validator.dart';
import 'package:alter/common/widget/radio_button.dart';
import 'package:alter/feature/auth/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignUpInfoPage extends ConsumerStatefulWidget {
  const SignUpInfoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpInfoPageState();
}

class _SignUpInfoPageState extends ConsumerState<SignUpInfoPage> {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController birthDayTextController = TextEditingController();
  bool isNameValid = false;
  bool isPhoneValid = false;
  bool isBirthDayValid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 텍스트 필드 검사
    nameTextController.addListener(() {
      setState(() {
        isNameValid = nameTextController.text.isNotEmpty;
      });
    });
    phoneTextController.addListener(
      () => setState(() {
        isPhoneValid = Validator.validatePhoneNumber(phoneTextController.text);
      }),
    );
    birthDayTextController.addListener(
      () => setState(() {
        isBirthDayValid = Validator.validateBirthDay(
          birthDayTextController.text,
        );
      }),
    );

    // 초기값 입력
    final signUpState = ref.watch(signUpViewModelProvider);
    nameTextController.text = signUpState.name ?? "";
    phoneTextController.text = signUpState.contact ?? "";
    birthDayTextController.text = signUpState.birthday ?? "";
  }

  @override
  void dispose() {
    nameTextController.dispose();
    phoneTextController.dispose();
    birthDayTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "회원님의 정보를 알려주세요!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(10),
                  Text(
                    "알터가 회원님이 동의 해 주신 내용을 바탕으로 작성했어요.\n틀리거나 빈 정보가 있다면 알려주시겠어요?",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(36),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 56,
                              child: TextFormField(
                                controller: nameTextController,
                                decoration: const InputDecoration(
                                  hintText: "이름을 입력해 주세요.",
                                ),
                              ),
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 56,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final signUpState = ref.watch(
                                    signUpViewModelProvider,
                                  );
                                  final selectedGender = signUpState.gender;
                                  final radioItems =
                                      Gender.values.map((gender) {
                                        return RadioModel(
                                          isSelected:
                                              selectedGender == gender.code,
                                          buttonText: gender.displayName,
                                          value: gender.code,
                                        );
                                      }).toList();

                                  return CustomRadio(
                                    radioItems: radioItems,
                                    onSelected: (value) {
                                      final selectedGender = Gender.values
                                          .firstWhere(
                                            (gender) => gender.code == value,
                                          );
                                      ref
                                          .read(
                                            signUpViewModelProvider.notifier,
                                          )
                                          .updateField(
                                            gender: selectedGender.code,
                                          );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: TextFormField(
                          controller: phoneTextController,
                          readOnly: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            PhoneNumberFormatter(),
                          ],
                          decoration: const InputDecoration(
                            hintText: "010-1234-5678",
                            counterText: "",
                          ),
                          maxLength: 13,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const Gap(8),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: TextFormField(
                          controller: birthDayTextController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            BirthDayFormatter(),
                          ],
                          decoration: const InputDecoration(
                            hintText: "1991-01-01 ",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      isNameValid && isPhoneValid && isBirthDayValid
                          ? () {
                            ref
                                .read(signUpViewModelProvider.notifier)
                                .updateField(
                                  name: nameTextController.text.trim(),
                                  contact: phoneTextController.text.trim(),
                                  birthday: birthDayTextController.text.trim(),
                                );
                            context.go('/sign-up/last');
                          }
                          : null,
                  child: const Text(
                    "다 했어요!",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
