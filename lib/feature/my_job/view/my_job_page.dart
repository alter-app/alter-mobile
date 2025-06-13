import 'dart:async';

import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/feature/my_job/model/my_job_response_model.dart';
import 'package:alter/feature/my_job/view/widget/my_job_card.dart';
import 'package:alter/feature/my_job/view_model/my_job_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MyJobPage extends ConsumerStatefulWidget {
  const MyJobPage({super.key});

  @override
  ConsumerState<MyJobPage> createState() => _MyJobPageState();
}

class _MyJobPageState extends ConsumerState<MyJobPage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _throttleTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(myJobListViewModelProvider.notifier).initialize(),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 스크롤 컨트롤러가 현재 위젯 트리의 스크롤 뷰에 연결되어 있는지 확인
    if (!_scrollController.hasClients) {
      return;
    }

    // 스크롤이 끝에서 300px 전에 도달하면 다음 페이지 로드
    if (_throttleTimer?.isActive ?? false) return;
    _throttleTimer = Timer(const Duration(milliseconds: 300), () {
      if (!_scrollController.hasClients) {
        _throttleTimer?.cancel(); // 컨트롤러가 없으면 타이머도 취소
        return;
      }
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        ref.read(myJobListViewModelProvider.notifier).fetchNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myJobListViewModelProvider);

    return Scaffold(
      backgroundColor: AppColor.gray[10],
      appBar: AppBar(
        title: Text("내 알바", style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/create-posting");
        },
        backgroundColor: AppColor.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: SvgPicture.asset('assets/icons/edit.svg', width: 36, height: 36),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Gap(2),
            Expanded(
              child: RefreshIndicator(
                color: AppColor.primary,
                onRefresh:
                    () =>
                        ref.read(myJobListViewModelProvider.notifier).refresh(),
                child: state.applications.when(
                  data: (applications) {
                    if (applications.isEmpty) {
                      return const Center(child: Text("지원한 아르바이트가 없어요."));
                    }
                    return ListView.separated(
                      itemCount: applications.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        // 실제 데이터 아이템
                        if (index < applications.length) {
                          final application = applications[index];
                          return MyJobCard(application: application);
                        }
                        // 무한 스크롤 로딩 인디케이터
                        else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                      separatorBuilder: (context, index) => const Gap(2),
                    );
                  },
                  error:
                      (error, stackTrace) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "에러가 발생했습니다",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed:
                                  () =>
                                      ref
                                          .read(
                                            myJobListViewModelProvider.notifier,
                                          )
                                          .initialize(),
                              icon: const Icon(Icons.refresh),
                              label: const Text("다시 시도"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
