import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/common/util/logger.dart';
import 'package:alter/core/env.dart';
import 'package:alter/feature/home/view_model/posting_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class JobPostPage extends ConsumerStatefulWidget {
  final int postId;
  const JobPostPage({super.key, required this.postId});

  @override
  ConsumerState<JobPostPage> createState() => _JobPostPageState();
}

class _JobPostPageState extends ConsumerState<JobPostPage> {
  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 데이터 fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(postingDetailViewModelProvider(widget.postId).notifier)
          .fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    const daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"];
    final state = ref.watch(postingDetailViewModelProvider(widget.postId));

    return Scaffold(
      backgroundColor: AppColor.gray[10],
      appBar: AppBar(
        title: Text("채용 정보", style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: state.posting.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('오류가 발생했습니다: $error'),
                    ElevatedButton(
                      onPressed:
                          () =>
                              ref
                                  .read(
                                    postingDetailViewModelProvider(
                                      widget.postId,
                                    ).notifier,
                                  )
                                  .fetchData(),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
          data: (posting) {
            final keywords = posting.keywords;
            final schedules = posting.schedules;
            final iconImage = const NOverlayImage.fromAssetImage(
              "assets/icons/location.png",
            );
            final marker = NMarker(
              size: const Size(48, 48),
              id: 'marker_${widget.postId}',
              position: NLatLng(
                posting.workspace.latitude,
                posting.workspace.longitude,
              ),
              icon: iconImage,
            );
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(color: AppColor.gray[20], height: 200),
                        Column(
                          children: [
                            // 공고 제목
                            Container(
                              color: AppColor.white,
                              height: 125,
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                18,
                                20,
                                16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        posting.workspace.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color: AppColor.gray,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      BadgeWidget(
                                        innerText: Formatter.formatRelativeTime(
                                          posting.createdAt,
                                        ),
                                        textColor: AppColor.secondary,
                                      ),
                                    ],
                                  ),
                                  const Gap(8),
                                  // 제목
                                  Expanded(
                                    child: Text(
                                      posting.title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium!.copyWith(
                                        color: AppColor.text,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const Gap(8),
                                  // 키워드
                                  Row(
                                    children:
                                        keywords
                                            .map(
                                              (keyword) => Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                child: BadgeWidget(
                                                  innerText: keyword.name,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            // 근무 정보
                            Container(
                              color: AppColor.white,
                              height: 172,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "근무 정보",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color: AppColor.gray[40],
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      // 급여 종류
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 0.5,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColor.gray[20]!,
                                            width: 1,
                                          ),
                                          color: AppColor.primary,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          "${Formatter.formatPaymentType(posting.paymentType)} ",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.copyWith(
                                            color: AppColor.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Gap(8),
                                      // 급여
                                      Text(
                                        "${Formatter.formatNumberWithComma(posting.payAmount)} 원",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge!.copyWith(
                                          color: AppColor.gray,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Gap(10),
                                      Text(
                                        "요일",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColor.gray),
                                      ),
                                      const Gap(40),
                                      ...daysOfWeek.map((day) {
                                        final isActive = schedules
                                            .first
                                            .workingDays
                                            .map((e) => Formatter.formatDay(e))
                                            .contains(day);
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 18,
                                          ),
                                          child: Text(
                                            day,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium!.copyWith(
                                              color:
                                                  isActive
                                                      ? AppColor.text
                                                      : AppColor.gray,
                                              fontWeight:
                                                  isActive
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }),
                                      const Spacer(),
                                      const BadgeWidget(innerText: "협의가능"),
                                    ],
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      const Gap(10),
                                      Text(
                                        "시간",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColor.gray),
                                      ),
                                      const Gap(40),
                                      Text(
                                        "${schedules.first.startTime.substring(0, 5)}  ~  ${schedules.first.endTime.substring(0, 5)}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color: AppColor.text,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        "(${Formatter.calculateWorkHours(schedules.first.startTime, schedules.first.endTime)})",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color: AppColor.gray[40],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      const BadgeWidget(innerText: "협의가능"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            // 근무 위치
                            Container(
                              color: AppColor.white,
                              height: 352,
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                16,
                                20,
                                20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "근무 위치",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color: AppColor.gray[40],
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      Text(
                                        posting.workspace.fullAddress,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge!.copyWith(
                                          color: AppColor.text,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const Gap(8),
                                      GestureDetector(
                                        onTap:
                                            () => _copyToClipboard(
                                              posting.workspace.fullAddress,
                                            ),
                                        child: SvgPicture.asset(
                                          width: 16,
                                          height: 16,
                                          "assets/icons/copy.svg",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF293F91),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "1",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium!.copyWith(
                                              color: AppColor.gray[10],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(6),
                                      Container(
                                        height: 22,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 0.5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: const Color(0xFFF1CF69),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "수인분당선",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium!.copyWith(
                                              color: AppColor.gray[10],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(6),
                                      Text(
                                        "무슨역 몇번 출구",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color: AppColor.gray,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  //지도
                                  GestureDetector(
                                    onTap: () {
                                      Log.d("지도 터치");
                                      _launchNaverMapSearch(
                                        posting.workspace.name,
                                      );
                                    },
                                    child: Container(
                                      color: AppColor.gray,
                                      height: 201,
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: NaverMap(
                                          key: ValueKey(
                                            'naver_map_${widget.postId}',
                                          ),
                                          options: NaverMapViewOptions(
                                            rotationGesturesEnable: false,
                                            scrollGesturesEnable: false,
                                            tiltGesturesEnable: false,
                                            zoomGesturesEnable: false,
                                            stopGesturesEnable: false,
                                            initialCameraPosition:
                                                NCameraPosition(
                                                  target: NLatLng(
                                                    posting.workspace.latitude,
                                                    posting.workspace.longitude,
                                                  ), // 서울 시청 좌표
                                                  zoom: 16,
                                                ),
                                          ),
                                          onMapReady: (controller) {
                                            controller.addOverlay(marker);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            // 상세 내용
                            Container(
                              color: AppColor.white,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "상세 내용",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color: AppColor.gray[40],
                                      fontWeight: FontWeight.w700,
                                      height: 1.42,
                                    ),
                                  ),
                                  const Gap(24),
                                  // 상세 이미지
                                  Container(
                                    width: double.infinity,
                                    constraints: const BoxConstraints(
                                      minHeight: 150,
                                    ),
                                    child: Text(
                                      posting.description,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color: AppColor.text,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            // 가계 평판
                            Container(
                              color: AppColor.white,
                              height: 196,
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                20,
                                20,
                                10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "가계 평판",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color: AppColor.gray[40],
                                      fontWeight: FontWeight.w700,
                                      height: 1.42,
                                    ),
                                  ),
                                  const Gap(18),
                                  Text(
                                    "복합적",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.copyWith(
                                      color: AppColor.text,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Row(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 72,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          ref
                              .read(
                                postingDetailViewModelProvider(
                                  widget.postId,
                                ).notifier,
                              )
                              .toggleScrap();
                        },
                        child: SvgPicture.asset(
                          state.isScrapped
                              ? "assets/icons/bookmark_filled.svg"
                              : "assets/icons/bookmark_outlined.svg",
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // apply 뒤에는 스케쥴 아이디
                            context.push('/postings/${posting.id}/apply');
                          },
                          child: Center(
                            child: Text(
                              "지원하기",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchNaverMapSearch(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('검색할 매장 이름이 없습니다.')));
      return;
    }

    final String encodedQuery = Uri.encodeComponent(query);
    final String naverMapScheme =
        'nmap://search?query=$encodedQuery&appname=${Env.appName}';
    final Uri url = Uri.parse(naverMapScheme);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // 네이버 지도 앱이 설치되어 있지 않을 경우 모바일 웹으로 대체
      Log.d('네이버 지도 앱을 열 수 없습니다. 앱이 설치되어 있는지 확인해주세요.');
      final Uri webUrl = Uri.parse(
        'https://m.map.naver.com/search2/search.naver?query=$encodedQuery',
      );
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('네이버 지도 앱 또는 웹 페이지를 열 수 없습니다.')),
          );
        }
      }
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));

    // 사용자에게 복사 완료를 알리는 스낵바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('클립보드에 복사되었습니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final String innerText;
  final Color? textColor;

  const BadgeWidget({super.key, required this.innerText, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
      decoration: BoxDecoration(
        color: AppColor.gray[10],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        innerText,
        style: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: textColor ?? AppColor.gray),
      ),
    );
  }
}
