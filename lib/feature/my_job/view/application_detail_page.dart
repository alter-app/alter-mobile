import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/formatter.dart';
import 'package:alter/feature/my_job/model/my_job_response_model.dart';
import 'package:alter/feature/my_job/view/widget/my_job_card.dart';
import 'package:alter/feature/my_job/view_model/my_job_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationDetailPage extends ConsumerWidget {
  final int applicationId;

  const ApplicationDetailPage({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myJobListState = ref.watch(myJobListViewModelProvider);

    ref.listen<AsyncValue<List<Application>>>(
      myJobListViewModelProvider.select((state) => state.applications),
      (previous, next) {
        next.whenOrNull(
          data: (applications) {
            final currentApplication = applications.firstWhere(
              (app) => app.id == applicationId,
            );

            if (currentApplication.status == "CANCELLED") {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('지원이 성공적으로 취소되었습니다.')),
                );
                Navigator.pop(context);
              }
            }
          },
          error: (error, stackTrace) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('지원 취소 실패: ${error.toString()}')),
              );
            }
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColor.gray[10],
      appBar: AppBar(
        title: Text('지원 상세 정보', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: myJobListState.applications.when(
          data: (applications) {
            final application = applications.firstWhere(
              (app) => app.id == applicationId,
            );
            final applyStatus = ApplyStatus.fromString(application.status);
            final isCancellable =
                application.status != ApplyStatus.cancelled.code &&
                application.status != ApplyStatus.deleted.code;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailCard(
                          context: context,
                          title: '지원 개요',
                          children: [
                            _buildDetailRow(
                              context,
                              '공고 제목',
                              application.posting.title,
                            ),
                            _buildDetailRow(
                              context,
                              '지원 상태',
                              applyStatus.displayName,
                            ),
                            _buildDetailRow(
                              context,
                              '지원 설명',
                              application.description,
                            ),
                          ],
                        ),
                        _buildDetailCard(
                          context: context,
                          title: '근무지 정보',
                          children: [
                            _buildDetailRow(
                              context,
                              '상호명',
                              application.posting.workspace.name,
                            ),
                            _buildDetailRow(
                              context,
                              '주소',
                              application.posting.workspace.fullAddress,
                            ),
                          ],
                        ),
                        _buildDetailCard(
                          context: context,
                          title: '근무 정보',
                          children: [
                            _buildDetailRow(
                              context,
                              '급여',
                              "${Formatter.formatPaymentType(application.posting.paymentType)} ${Formatter.formatNumberWithComma(application.posting.payAmount)} 원",
                            ),
                            _buildDetailRow(
                              context,
                              '근무 요일',
                              application.postingSchedule.workingDays
                                  .map((e) => Formatter.formatDay(e))
                                  .join(", "),
                            ),
                            _buildDetailRow(
                              context,
                              '근무 시간',
                              "${application.postingSchedule.startTime.substring(0, 5)} ~ ${application.postingSchedule.endTime.substring(0, 5)}",
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
                  child: ElevatedButton(
                    onPressed:
                        isCancellable
                            ? () async {
                              final bool? confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text("지원 취소 확인"),
                                      content: const Text(
                                        "정말로 이 지원을 취소하시겠습니까?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: Text(
                                            "아니요",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge!.copyWith(
                                              color: AppColor.gray,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.warning,
                                            foregroundColor: AppColor.white,
                                          ),
                                          child: Text(
                                            "취소합니다",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge!.copyWith(
                                              color: AppColor.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              );

                              // 2. 사용자가 '예'를 눌렀을 경우에만 취소 로직 실행
                              if (confirm == true) {
                                // ViewModel의 cancelApplication 메서드 호출
                                // 이 호출이 완료되면, myJobListViewModelProvider의 상태가 업데이트되고
                                // 현재 화면에 있는 application 객체(상세 정보)와 MyJobPage의 목록이 동시에 업데이트됩니다.
                                await ref
                                    .read(myJobListViewModelProvider.notifier)
                                    .cancelApplication(applicationId);
                              }
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.warning,
                    ),
                    child: Center(
                      child: Text(
                        "지원 취소",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                      "정보를 불러오는데 실패했습니다.",
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
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed:
                          () =>
                              ref
                                  .read(myJobListViewModelProvider.notifier)
                                  .refresh(),
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
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0),
      padding: const EdgeInsets.all(16.0),
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: AppColor.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(height: 16, thickness: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
