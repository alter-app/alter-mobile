import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/phone_text_formatter.dart';
import 'package:alter/common/util/validator.dart';
import 'package:alter/feature/auth/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  late final TextEditingController phoneTextController;
  late final TextEditingController phoneAuthCodeTextController;
  bool isPhoneValid = false;
  bool isAuthCodeValid = false;

  @override
  void initState() {
    super.initState();
    phoneTextController = TextEditingController();
    phoneAuthCodeTextController = TextEditingController();

    phoneTextController.addListener(
      () => setState(() {
        isPhoneValid = Validator.validatePhoneNumber(phoneTextController.text);
        if (!isPhoneValid) {
          phoneAuthCodeTextController.clear();
        }
      }),
    );
    phoneAuthCodeTextController.addListener(validateAuthCode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final signUpState = ref.watch(signUpViewModelProvider);
    phoneTextController.text = signUpState.contact ?? "";
  }

  @override
  void dispose() {
    phoneTextController.dispose();
    phoneAuthCodeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpViewModelProvider);

    ref.listen(signUpViewModelProvider, (previous, next) {
      if (next.isPhoneAuthSuccess) {
        final currentPath = GoRouter.of(context).state.path;
        if (currentPath == "/sign-up") {
          context.go("/sign-up/info");
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
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 64,
                              child: TextFormField(
                                controller: phoneTextController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  PhoneNumberFormatter(), // 하이픈 포맷팅
                                ],
                                decoration: InputDecoration(
                                  hintText: "전화번호 11자리",
                                  counterText: "",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          phoneTextController.text.isEmpty
                                              ? AppColor.gray[10]!
                                              : (isPhoneValid
                                                  ? AppColor.gray[10]!
                                                  : AppColor.warning),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 13, // 13자리 제한
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
                                    isPhoneValid
                                        ? () {
                                          ref
                                              .read(
                                                signUpViewModelProvider
                                                    .notifier,
                                              )
                                              .updateField(
                                                contact:
                                                    phoneTextController.text
                                                        .trim(),
                                              );
                                          ref
                                              .read(
                                                signUpViewModelProvider
                                                    .notifier,
                                              )
                                              .verifyPhoneNumber();
                                        }
                                        : null,
                                child: Text(
                                  "인증번호 발송",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        opacity:
                            signUpState.isPhoneAuthSent && isPhoneValid
                                ? 1.0
                                : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: AnimatedSlide(
                          offset:
                              signUpState.isPhoneAuthSent && isPhoneValid
                                  ? Offset.zero
                                  : const Offset(0, 0.2),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: TextFormField(
                              controller: phoneAuthCodeTextController,
                              decoration: InputDecoration(
                                hintText: "인증번호 입력",
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        phoneAuthCodeTextController.text.isEmpty
                                            ? AppColor.gray[10]!
                                            : (isPhoneValid
                                                ? AppColor.gray[10]!
                                                : AppColor.warning),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 6, // 6자리 제한
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "인증번호를 입력해 주세요.";
                                }
                                if (value.length != 6) {
                                  return "인증번호는 6자리여야 합니다.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      if (signUpState.errorMessage != null) ...[
                        const Gap(8),
                        Text(
                          signUpState.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "인증 확인이 안눌린다면 번호를 다시 확인 해 주세요.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColor.gray,
                    ),
                  ),
                  const Gap(4),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          (isAuthCodeValid && isPhoneValid)
                              ? () {
                                final vm = ref.read(
                                  signUpViewModelProvider.notifier,
                                );
                                vm.updateField(
                                  errorMessage: null,
                                  code: phoneAuthCodeTextController.text.trim(),
                                );
                                vm.signInWithCode();
                                //context.push('/sign-up/info');
                              }
                              : null,
                      child: Text(
                        "인증 확인",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validatePhoneNumber() {
    final phone = phoneTextController.text.trim();
    final phoneRegex = RegExp(r'^010-[0-9]{4}-[0-9]{4}$');

    setState(() {
      isPhoneValid = phoneRegex.hasMatch(phone);
    });
  }

  void validateAuthCode() {
    final code = phoneAuthCodeTextController.text.trim();

    setState(() {
      isAuthCodeValid = code.length == 6 && int.tryParse(code) != null;
    });
  }
}
