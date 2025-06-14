import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/profile/view/scrap_view.dart';
import 'package:alter/feature/profile/view_model/my_scrap_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onTabChanged(); // 초기 탭 데이터 로드
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0: // '스크랩 리스트' 탭
          ref.read(myScrapListViewModelProvider.notifier).fetchInitialScraps();
          break;
        case 1: // '자격 관리' 탭
          // 기존 자격 관리 로딩 로직 유지 또는 추가
          // ref.read(certificateViewModelProvider.notifier).fetchCertificates();
          break;
      }
    }
  }

  @override
  void dispose() {
    // _tabController.removeListener(_onTabChanged); // 리스너 제거
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(loginViewModelProvider).profile;
    return Scaffold(
      backgroundColor: AppColor.gray[10],
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          const Gap(8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColor.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: SvgPicture.asset(
                    'assets/icons/userIcon.svg',
                    width: 80,
                    height: 80,
                  ),
                ),
                const Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile?.name ?? "이름",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const Gap(4),
                    Text(
                      userProfile?.nickname ?? "닉네임",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.gray,
                      ),
                    ),
                    Text(
                      "가입일자 : ${DateFormat('yyyy년 M월 d일').format(userProfile!.createdAt)}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.gray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [const Tab(text: "스크랩"), const Tab(text: "자격증")],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [const ScrapListView(), const Text('자격')],
            ),
          ),
        ],
      ),
    );
  }
}
