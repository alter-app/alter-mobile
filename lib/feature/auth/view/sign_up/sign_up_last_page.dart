import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/auth/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignUpLastPage extends ConsumerStatefulWidget {
  const SignUpLastPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpLastPageState();
}

class _SignUpLastPageState extends ConsumerState<SignUpLastPage> {
  late final TextEditingController nicknameTextController;

  @override
  void initState() {
    super.initState();
    nicknameTextController = TextEditingController();
    nicknameTextController.addListener(() {
      final currentText = nicknameTextController.text;
      if (currentText != ref.read(signUpViewModelProvider).nickname) {
        ref.read(signUpViewModelProvider.notifier).resetNickname();
      }
    });
  }

  @override
  void dispose() {
    nicknameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpViewModelProvider);
    final isInputValid =
        nicknameTextController.text.isNotEmpty &&
        nicknameTextController.text.length >= 2 &&
        nicknameTextController.text.length <= 32;

    ref.listen(loginViewModelProvider, (previous, next) {
      if (next is LoginSuccess) {
        final currentPath = GoRouter.of(context).state.path;
        if (currentPath == "/sign-up/last") {
          context.go("/home");
        }
      }
    });

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
                    "이제 마지막이에요!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(10),
                  Text(
                    "회원님이 알터에서 불릴 닉네임을 알려주세요.\n그리고 필수 정보 제공에 동의 해 주시면 완료에요.",
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
                            flex: 3,
                            child: SizedBox(
                              height: 78,
                              child: TextFormField(
                                controller: nicknameTextController,
                                decoration: InputDecoration(
                                  hintText: "닉네임을 입력해 주세요.",
                                  counterText: "",
                                  errorText: signUpState.errorMessage,
                                  helperText: signUpState.successMessage,
                                ),
                                maxLength: 32,
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed:
                                    isInputValid
                                        ? () {
                                          final nickname =
                                              nicknameTextController.text;
                                          ref
                                              .read(
                                                signUpViewModelProvider
                                                    .notifier,
                                              )
                                              .checkNickname(nickname);
                                        }
                                        : null,
                                child: const Text("중복확인"),
                              ),
                            ),
                          ),
                        ],
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
                      signUpState.isNicknameDuplicated == false
                          ? () async {
                            await ref
                                .read(signUpViewModelProvider.notifier)
                                .signUp();
                            final loginState = ref.read(loginViewModelProvider);
                            if (loginState is LoginSuccess) {
                              if (context.mounted) {
                                context.go('/home');
                              }
                            }
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
