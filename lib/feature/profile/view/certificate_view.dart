// lib/feature/profile/view/certificate_view.dart

import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/%08formater/birth_input_formatter.dart'; // 오타: %08formater -> formatter
import 'package:alter/feature/profile/model/profile_request_model.dart';
import 'package:alter/feature/profile/model/profile_response_model.dart'; // CertificateResponse 대신 Certificate 모델 사용 확인
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:alter/feature/profile/view_model/certificate_view_model.dart';

class CertificateView extends ConsumerStatefulWidget {
  const CertificateView({super.key});

  @override
  ConsumerState<CertificateView> createState() => _CertificateViewState();
}

class _CertificateViewState extends ConsumerState<CertificateView> {
  // SingleTickerProviderStateMixin 제거 - AnimatedCrossFade는 필요 없음
  bool _isAddFormVisible = false;
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _publisherNameController =
      TextEditingController();
  final TextEditingController _certificateSerialNumberController =
      TextEditingController();
  final TextEditingController _addIssuedAtController = TextEditingController();
  final TextEditingController _addExpiredAtController = TextEditingController();

  // 자격증 ID 타입이 String에서 int로 변경된 것을 확인
  int? _expandedCertificateId;

  // @override
  // void initState() { // AnimatedCrossFade 사용으로 인해 AnimationController 필요 없으므로 제거
  //   super.initState();
  //   // _animationController 및 _slideAnimation 초기화 로직 제거
  //   _addIssuedAtController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   _addExpiredAtController.text = DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 365)));
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _publisherNameController.dispose();
    _certificateSerialNumberController.dispose();
    _addIssuedAtController.dispose();
    _addExpiredAtController.dispose();
    // _animationController.dispose(); // 제거
    super.dispose();
  }

  void _resetAddForm() {
    _nameController.clear();
    _publisherNameController.clear();
    _certificateSerialNumberController.clear();
    _addIssuedAtController.clear(); // 초기값으로 설정하지 않고 단순히 클리어
    _addExpiredAtController.clear(); // 초기값으로 설정하지 않고 단순히 클리어
    // _isAddFormVisible 상태가 변경되면 setState() 없이도 UI가 업데이트 됩니다.
  }

  DateTime? _parseDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }
    try {
      return DateFormat('yyyy-MM-dd').parseStrict(dateString);
    } catch (e) {
      // logger.e('날짜 파싱 오류: $e, 입력값: $dateString'); // logger 없으면 주석 처리
      return null;
    }
  }

  void _showSnackbar(BuildContext context, bool success, String action) {
    if (context.mounted) {
      final message = success ? '자격증 $action에 성공했습니다.' : '자격증 $action에 실패했습니다.';
      // 배경색을 제거하여 기본 스낵바 스타일을 따르도록 했습니다.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncCertificates = ref.watch(certificateViewModelProvider);
    final certificateViewModel = ref.read(
      certificateViewModelProvider.notifier,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColor.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(8),
                Text('자격증', style: Theme.of(context).textTheme.displayMedium),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isAddFormVisible = !_isAddFormVisible;
                      if (!_isAddFormVisible) {
                        _resetAddForm(); // 추가 폼이 닫힐 때만 초기화
                      }
                      // 추가 폼이 열리거나 닫힐 때 확장된 항목 닫기
                      _expandedCertificateId = null;
                    });
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColor.text),
                  child: Text(
                    _isAddFormVisible ? '취소' : '추가',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          // AnimatedCrossFade를 사용하여 추가 폼 표시/숨김
          AnimatedCrossFade(
            firstChild: _buildAddCertificateForm(context, certificateViewModel),
            secondChild: const SizedBox.shrink(),
            crossFadeState:
                _isAddFormVisible
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOut,
          ),
          const Gap(2),
          // 기존 자격증 목록
          asyncCertificates.when(
            data: (certificates) {
              if (certificates.isEmpty && !_isAddFormVisible) {
                return Container(
                  color: AppColor.white,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/x-circle.svg',
                          width: 80,
                          height: 80,
                        ),
                        const Gap(16),
                        Text(
                          '등록된 자격증이 없습니다.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (certificates.isEmpty && _isAddFormVisible) {
                return const SizedBox.shrink();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: certificates.length,
                  itemBuilder: (context, index) {
                    final certificate = certificates[index];
                    final bool isExpanded =
                        _expandedCertificateId == certificate.id;

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedCertificateId =
                                  isExpanded ? null : certificate.id;
                              // 자격증 항목이 확장될 때 추가 폼이 열려있다면 닫기
                              if (_isAddFormVisible) {
                                _isAddFormVisible = false;
                                _resetAddForm(); // 폼 닫힘과 함께 필드 초기화
                              }
                            });
                          },
                          child: Container(
                            color: AppColor.white,
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        certificate.certificateName,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge!.copyWith(
                                          color: AppColor.text,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        certificate.publisherName,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color: AppColor.gray,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '발급일 :  ${DateFormat('yyyy년  M월  d일').format(certificate.issuedAt)}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.copyWith(
                                          color: AppColor.gray,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (certificate.expiresAt !=
                                          null) // 만료일이 있을 경우만 표시
                                        Text(
                                          '만료일 :  ${DateFormat('yyyy년  M월  d일').format(certificate.expiresAt!)}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.copyWith(
                                            color: AppColor.gray,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: isExpanded ? 2 : 0, // 180도 회전
                                  child: SvgPicture.asset(
                                    "assets/icons/chevron-down.svg",
                                    width: 20,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                      AppColor.gray[50]!,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirmed =
                                        await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text('자격증 삭제'),
                                                content: Text(
                                                  '${certificate.certificateName}을(를) 삭제하시겠습니까?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.of(
                                                          context,
                                                        ).pop(false),
                                                    child: Text(
                                                      '취소',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color:
                                                                AppColor.gray,
                                                          ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.of(
                                                          context,
                                                        ).pop(true),
                                                    child: Text(
                                                      '삭제',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color:
                                                                AppColor
                                                                    .warning,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        ) ??
                                        false;

                                    if (confirmed) {
                                      final success = await certificateViewModel
                                          .deleteCertificate(certificate.id);
                                      _showSnackbar(context, success, '삭제');
                                      if (success) {
                                        setState(() {
                                          _expandedCertificateId =
                                              null; // 삭제 시 확장된 항목 닫기
                                        });
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: _buildEditCertificateForm(
                            context,
                            certificateViewModel,
                            certificate,
                          ),
                          secondChild: const SizedBox.shrink(),
                          crossFadeState:
                              isExpanded
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 1000),
                          sizeCurve: Curves.easeInOut,
                        ),
                      ],
                    );
                  },
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stackTrace) => Center(child: Text('자격증 로드 오류: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCertificateForm(
    BuildContext context,
    CertificateViewModel viewModel,
  ) {
    return Container(
      color: AppColor.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _addFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '자격증 이름',
                ), // hintText 대신 labelText 사용
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? '자격증 이름을 입력해주세요.'
                            : null,
              ),
              const Gap(4),
              TextFormField(
                controller: _publisherNameController,
                decoration: const InputDecoration(labelText: '발급처'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? '발급처를 입력해주세요.' : null,
              ),
              const Gap(4),
              TextFormField(
                controller: _certificateSerialNumberController,
                decoration: const InputDecoration(labelText: '자격증 일련번호'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? '자격증 일련번호를 입력해주세요.'
                            : null,
                keyboardType: TextInputType.text,
              ),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "발급일",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColor.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(4),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextFormField(
                      controller: _addIssuedAtController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        BirthDayFormatter(),
                      ],
                      decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '발급일을 입력해주세요.';
                        }
                        if (_parseDateString(value) == null) {
                          return '유효한 날짜(YYYY-MM-DD)를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "만료일",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColor.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(4),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextFormField(
                      controller: _addExpiredAtController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        BirthDayFormatter(),
                      ],
                      decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            _parseDateString(value) == null) {
                          return '유효한 날짜(YYYY-MM-DD)를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const Gap(16),
              ElevatedButton(
                onPressed: () async {
                  if (_addFormKey.currentState!.validate()) {
                    final issuedAt = _parseDateString(
                      _addIssuedAtController.text,
                    );
                    final expiredAt = _parseDateString(
                      _addExpiredAtController.text,
                    );

                    if (issuedAt == null) {
                      _showSnackbar(context, false, '발급일 입력');
                      return;
                    }

                    final success = await viewModel.addCertificate(
                      CertificateRequest(
                        type: "CERTIFICATE",
                        certificateName: _nameController.text,
                        certificateId: _certificateSerialNumberController.text,
                        publisherName: _publisherNameController.text,
                        issuedAt: issuedAt,
                        expiresAt: expiredAt,
                      ),
                    );
                    _showSnackbar(context, success, '등록');
                    if (success) {
                      setState(() {
                        _isAddFormVisible = false;
                      });
                      _resetAddForm();
                    }
                  }
                },
                child: const Text('등록하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditCertificateForm(
    BuildContext context,
    CertificateViewModel viewModel,
    Certificate certificate,
  ) {
    final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(
      text: certificate.certificateName,
    );
    final TextEditingController publisherNameController = TextEditingController(
      text: certificate.publisherName,
    );
    final TextEditingController certificateSerialNumberController =
        TextEditingController(text: certificate.certificateId);
    final TextEditingController issuedAtController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(certificate.issuedAt),
    );
    final TextEditingController expiresAtController = TextEditingController(
      text:
          certificate.expiresAt != null
              ? DateFormat('yyyy-MM-dd').format(certificate.expiresAt!)
              : '',
    );

    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Form(
        key: editFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(height: 1, thickness: 1),
            const Gap(16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: '자격증 이름'),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? '자격증 이름을 입력해주세요.' : null,
            ),
            const Gap(4),
            TextFormField(
              controller: publisherNameController,
              decoration: const InputDecoration(hintText: '발급처'),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? '발급처를 입력해주세요.' : null,
            ),
            const Gap(4),
            TextFormField(
              controller: certificateSerialNumberController,
              decoration: const InputDecoration(hintText: '자격증 일련번호'),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? '자격증 일련번호를 입력해주세요.'
                          : null,
              keyboardType: TextInputType.text,
            ),
            const Gap(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "발급일",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColor.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(4),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextFormField(
                    controller: issuedAtController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      BirthDayFormatter(),
                    ],
                    decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '발급일을 입력해주세요.';
                      }
                      if (_parseDateString(value) == null) {
                        return '유효한 날짜(YYYY-MM-DD)를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const Gap(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "만료일",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColor.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(4),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextFormField(
                    controller: expiresAtController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      BirthDayFormatter(),
                    ],
                    decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          _parseDateString(value) == null) {
                        return '유효한 날짜(YYYY-MM-DD)를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: () async {
                if (editFormKey.currentState!.validate()) {
                  final issuedAt = _parseDateString(issuedAtController.text);
                  final expiresAt = _parseDateString(expiresAtController.text);

                  if (issuedAt == null) {
                    _showSnackbar(context, false, '발급일 입력');
                    return;
                  }

                  final success = await viewModel.updateCertificate(
                    CertificateRequest(
                      type: certificate.type,
                      certificateName: nameController.text,
                      certificateId: certificateSerialNumberController.text,
                      publisherName: publisherNameController.text,
                      issuedAt: issuedAt,
                      expiresAt: expiresAt,
                    ),
                    certificate.id,
                  );
                  _showSnackbar(context, success, '수정');
                  if (success) {
                    setState(() {
                      _expandedCertificateId = null;
                    });
                  }
                }
              },
              child: const Text('수정하기'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _expandedCertificateId = null;
                });
              },
              child: const Text('취소'),
            ),
          ],
        ),
      ),
    );
  }
}
