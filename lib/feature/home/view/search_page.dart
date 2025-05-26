import 'dart:async';

import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/logger.dart';
import 'package:alter/feature/home/view/posting_card.dart';
import 'package:alter/feature/home/view_model/posting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _throttleTimer;

  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 데이터 초기화
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(postingListViewModelProvider.notifier).initialize(),
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // 스크롤이 끝에서 300px 전에 도달하면 다음 페이지 로드
    if (_throttleTimer?.isActive ?? false) return;
    _throttleTimer = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        ref.read(postingListViewModelProvider.notifier).fetchNext();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postingListViewModelProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 검색 필드 컨테이너 (기존 디자인 유지)
              Container(
                color: AppColor.white,
                height: 97,
                child: Center(
                  child: TextFormField(
                    onTap: () {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.gray[10],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1.0,
                          color: AppColor.gray[20]!,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        size: 24,
                        color: AppColor.gray[20],
                      ),
                    ),
                  ),
                ),
              ),

              // 주소 표시 컨테이너 (기존 디자인 유지)
              Container(
                height: 66,
                alignment: Alignment.centerLeft,
                child: Text(
                  "서울 구로구 경인로 445",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(height: 1.42),
                ),
              ),

              // 메인 리스트 영역 - AsyncValue로 처리
              Expanded(
                child: RefreshIndicator(
                  color: AppColor.primary,
                  backgroundColor: AppColor.white,
                  strokeWidth: 2.5,
                  displacement: 50.0,
                  onRefresh:
                      () =>
                          ref
                              .read(postingListViewModelProvider.notifier)
                              .refresh(),
                  child: state.postings.when(
                    // 데이터가 있을 때
                    data: (postings) {
                      if (postings.isEmpty) {
                        return const Center(
                          child: Text(
                            "등록된 게시물이 없습니다",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: postings.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          // 실제 데이터 아이템
                          if (index < postings.length) {
                            final posting = postings[index];
                            return JobPostCard(posting: posting);
                          }
                          // 무한 스크롤 로딩 인디케이터
                          else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                        separatorBuilder:
                            (context, index) => Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColor.gray[10],
                            ),
                      );
                    },

                    // 초기 로딩 중일 때
                    loading:
                        () => const Center(child: CircularProgressIndicator()),

                    // 에러가 발생했을 때
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
                                              postingListViewModelProvider
                                                  .notifier,
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
