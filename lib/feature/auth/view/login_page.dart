import 'package:alter/common/util/logger.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/auth/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:alter/feature/auth/model/auth_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (previous, next) async {
      switch (next.status) {
        case LoginStatus.success:
          context.go("/");
          break;
        case LoginStatus.signupRequired:
          Log.i("State: SignupRequired");
          ref
              .read(signUpViewModelProvider.notifier)
              .initializeWithSignupData(next.signupData!);
          context.push('/sign-up');
          break;
        case LoginStatus.tokenExpired:
          Log.i("State: TokenExpired");
          // TODO : 토스트 UI 개선
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.message!)));
          break;
        case LoginStatus.fail:
          Log.i("State: Login Fail");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.message!)));
          break;
        case LoginStatus.initial:
          Log.i("State: Login Initial");
          break;
        case LoginStatus.loading:
          Log.i("State: Login Loading");
          break;
      }
    });

    final isLoading = authState.status == LoginStatus.loading;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/logo_with_text.svg'),
                const Gap(10),
                SizedBox(
                  width: 355,
                  child: TabBar(
                    controller: _tabController,
                    tabs: [const Tab(text: "알바생"), const Tab(text: "사장님")],
                  ),
                ),
                const Gap(16),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // 알바생 로그인 뷰
                      Column(
                        children: [
                          // 카카오 로그인
                          GestureDetector(
                            onTap:
                                isLoading
                                    ? null
                                    : () {
                                      ref
                                          .read(loginViewModelProvider.notifier)
                                          .login(SocialDomain.kakao);
                                    },
                            child: SvgPicture.asset(
                              'assets/images/kakao_login.svg',
                              height: 56,
                            ),
                          ),
                          const Gap(12),
                          // 애플 로그인
                          GestureDetector(
                            onTap:
                                isLoading
                                    ? null
                                    : () {
                                      ref
                                          .read(loginViewModelProvider.notifier)
                                          .login(SocialDomain.apple);
                                    },
                            child: SvgPicture.asset(
                              "assets/images/apple_login_black.svg",
                              height: 56,
                            ),
                          ),
                        ],
                      ),
                      // 사장님 로그인 뷰
                      Column(
                        children: [
                          // 카카오 로그인
                          GestureDetector(
                            onTap:
                                isLoading
                                    ? null
                                    : () {
                                      ref
                                          .read(loginViewModelProvider.notifier)
                                          .managerLogin(SocialDomain.kakao);
                                    },
                            child: SvgPicture.asset(
                              'assets/images/kakao_login.svg',
                              height: 56,
                            ),
                          ),
                          const Gap(8),
                          // 애플 로그인
                          GestureDetector(
                            onTap:
                                isLoading
                                    ? null
                                    : () {
                                      ref
                                          .read(loginViewModelProvider.notifier)
                                          .managerLogin(SocialDomain.apple);
                                    },
                            child: SvgPicture.asset(
                              "assets/images/apple_login_black.svg",
                              height: 56,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 카카오 로그인
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
