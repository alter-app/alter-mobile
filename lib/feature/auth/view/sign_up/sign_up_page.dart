import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController phoneAuthCodeTextController = TextEditingController();
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
                    "휴대폰 번호를 인증해 주세요!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(10),
                  Text(
                    "알터 회원가입을 위한 인증 번호를\n휴대폰 문자로 발송 해 드려요!",
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
                                  controller: phoneTextController,
                                  decoration: const InputDecoration(
                                    hintText: "전화번호 11자리",
                                  ),
                                ),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("인증번호 발송"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextFormField(
                            controller: phoneAuthCodeTextController,
                            decoration: const InputDecoration(
                              hintText: "인증번호 입력",
                            ),
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
                    context.go('/sign-up/info');
                  },
                  child: const Text("인증 확인"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
