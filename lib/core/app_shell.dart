// 하단 내비게이션 바를 포함하는 Scaffold 위젯
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child; // ShellRoute의 child (현재 활성화된 자식 라우트의 페이지)

  @override
  Widget build(BuildContext context) {
    // 현재 경로를 기반으로 선택된 탭을 결정합니다.
    final String location =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/home')) {
      currentIndex = 0;
    } else if (location.startsWith('/my-job')) {
      currentIndex = 1;
    } else if (location.startsWith('/chat')) {
      currentIndex = 2;
    } else if (location.startsWith('/profile')) {
      currentIndex = 3;
    }
    return Scaffold(
      body: child, // ShellRoute의 자식 라우트가 여기에 표시됩니다.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // 탭을 눌렀을 때 해당 경로로 이동합니다.
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.go('/my-job');
          } else if (index == 2) {
            context.go('/chat');
          } else if (index == 3) {
            context.go('/profile');
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: '내 알바',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }
}
