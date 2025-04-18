import 'package:alter/common/widget/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignUpInfoPage extends StatefulWidget {
  const SignUpInfoPage({super.key});

  @override
  State<SignUpInfoPage> createState() => _SignUpInfoPageState();
}

class _SignUpInfoPageState extends State<SignUpInfoPage> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController birthDayTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 50,
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
                              child: CustomRadio(
                                radioItems: [
                                  RadioModel(buttonText: "남", isSelected: true),
                                  RadioModel(
                                    buttonText: "여",
                                    isSelected: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextFormField(
                            controller: phoneTextController,
                            decoration: const InputDecoration(hintText: "휴대번호"),
                          ),
                        ),
                        const Gap(12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextFormField(
                            controller: birthDayTextController,
                            decoration: const InputDecoration(hintText: "생년월일"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //context.go('/sign-up/info');
                  },
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
