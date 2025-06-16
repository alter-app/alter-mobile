import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/profile/view_model/my_scrap_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ScrapListView extends ConsumerWidget {
  const ScrapListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrapListAsync =
        ref.watch(myScrapListViewModelProvider).scrappedPostings;

    return scrapListAsync.when(
      data: (scraps) {
        if (scraps.isEmpty) {
          return const Center(child: Text('스크랩한 공고가 없습니다.'));
        }
        return ListView.builder(
          itemCount: scraps.length,
          itemBuilder: (context, index) {
            final scrap = scraps[index];
            return ScrapCard(scrap: scrap);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('데이터 로드 오류: $e')),
    );
  }
}

class ScrapCard extends ConsumerWidget {
  final Scrap scrap;

  const ScrapCard({super.key, required this.scrap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          color: AppColor.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: InkWell(
              onTap: () => context.push('/postings/${scrap.posting.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scrap.posting.businessName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColor.gray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          scrap.posting.title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: AppColor.text,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${Formatter.formatPaymentType(scrap.posting.paymentType)} ",
                        ),
                        TextSpan(
                          text:
                              "${Formatter.formatNumberWithComma(scrap.posting.payAmount)} ",
                          style: const TextStyle(
                            color: AppColor.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "원 · ${Formatter.formatRelativeTime(scrap.createdAt)}",
                        ),
                      ],
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColor.gray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Gap(2),
      ],
    );
  }
}
