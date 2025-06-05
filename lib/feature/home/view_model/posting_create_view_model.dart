import 'package:alter/common/util/extension.dart';
import 'package:alter/common/util/logger.dart';
import 'package:alter/common/widget/day_selector.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/home/model/posting_request_model.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/model/schedule_data_model.dart';
import 'package:alter/feature/home/repository/posting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'posting_create_view_model.freezed.dart';

@freezed
abstract class PostingCreateState with _$PostingCreateState {
  const factory PostingCreateState({
    required int workspaceId, // 추후 기업 관련 상태에서 가져올 예정
    String? title,
    @Default([]) List<Keyword> keywords,
    @Default([]) List<int> selectedKeywords,
    String? description, // 아직 미구현
    @Default([]) List<ScheduleData> schedules,
    int? payAmount,
    @Default("HOURLY") String paymentType,
    // 페이지 상태
    @Default(1) int scheduleCount,
    String? errorMessage,
    @Default(false) bool isPostingSuccess,
  }) = _PostingCreateState;
}

final postingCreateViewModelProvider =
    NotifierProvider<PostingCreateViewModel, PostingCreateState>(
      () => PostingCreateViewModel(),
    );

class PostingCreateViewModel extends Notifier<PostingCreateState> {
  PostingRepository get _postRepository => ref.watch(postingRepositoryProvider);

  String? get _accessToken {
    final loginState = ref.watch(loginViewModelProvider);
    return loginState.token?.accessToken;
  }

  @override
  PostingCreateState build() {
    return const PostingCreateState(workspaceId: 1, description: "임시");
  }

  Future<void> getKeyword() async {
    final token = _accessToken;
    if (token == null || token.isEmpty) {
      return;
    }

    final result = await _postRepository.getKeywords(token);
    switch (result) {
      case Success(data: final data):
        state = state.copyWith(keywords: data);
      default:
        // 예외?
        break;
    }
  }

  // 공고 등록
  Future<void> createPosting() async {
    state = state.copyWith(errorMessage: null, isPostingSuccess: false);

    final token = _accessToken;
    if (token == null || token.isEmpty) {
      return;
    }
    if (!_validatePostingData()) {
      // 입력값에 누락이 있는 경우
      return;
    }

    final schedules =
        state.schedules.map((schedule) {
          return Schedule(
            workingDays:
                schedule.selectedDays
                    .map((day) {
                      return day.code;
                    })
                    .toSet()
                    .toSortedWeekdays(),
            startTime: schedule.startTime,
            endTime: schedule.endTime,
            position: "0",
            positionsNeeded: 0,
          );
        }).toList();

    final result = await _postRepository.createPosting(
      token,
      PostingRequest(
        workspaceId: state.workspaceId,
        title: state.title!,
        description: "",
        payAmount: state.payAmount!,
        paymentType: state.paymentType,
        keywords: state.selectedKeywords,
        schedules: schedules,
      ),
    );

    switch (result) {
      case Success():
        state = state.copyWith(isPostingSuccess: true);
      case Failure(error: final error):
        String errorMessage = error.toString().substring(11);
        state = state.copyWith(errorMessage: errorMessage);
    }
  }

  void clear() {
    state = state.copyWith(
      title: null,
      selectedKeywords: [],
      payAmount: null,
      paymentType: "HOURLY",
      scheduleCount: 1,
      schedules: [],
      errorMessage: null,
      isPostingSuccess: false,
    );
  }

  // 스케줄 추가
  void addSchedule() {
    final count = state.scheduleCount;
    final newSchedule = ScheduleData(id: count, selectedDays: {});
    state = state.copyWith(
      schedules: [...state.schedules, newSchedule],
      scheduleCount: count + 1,
    );
  }

  // 스케줄 제거
  void removeSchedule(int scheduleId) {
    final updatedSchedules =
        state.schedules.where((s) => s.id != scheduleId).toList();
    state = state.copyWith(schedules: updatedSchedules);
  }

  // 특정 스케줄의 요일 업데이트
  void updateScheduleDays(int scheduleId, Set<Day> selectedDays) {
    final updatedSchedules =
        state.schedules.map((schedule) {
          if (schedule.id == scheduleId) {
            return schedule.copyWith(selectedDays: selectedDays);
          }
          return schedule;
        }).toList();
    state = state.copyWith(schedules: updatedSchedules);
    Log.i(state.toString());
  }

  // 특정 스케줄의 요일 협의 가능 여부 업데이트
  void updateScheduleDayNegotiable(int scheduleId, bool isNegotiable) {
    final updatedSchedules =
        state.schedules.map((schedule) {
          if (schedule.id == scheduleId) {
            return schedule.copyWith(isDayNegotiable: isNegotiable);
          }
          return schedule;
        }).toList();
    state = state.copyWith(schedules: updatedSchedules);
  }

  // 특정 스케줄의 시작 시간 업데이트
  void updateScheduleStartTime(int scheduleId, String startTime) {
    final updatedSchedules =
        state.schedules.map((schedule) {
          if (schedule.id == scheduleId) {
            return schedule.copyWith(startTime: startTime);
          }
          return schedule;
        }).toList();
    state = state.copyWith(schedules: updatedSchedules);
  }

  // 특정 스케줄의 종료 시간 업데이트
  void updateScheduleEndTime(int scheduleId, String endTime) {
    final updatedSchedules =
        state.schedules.map((schedule) {
          if (schedule.id == scheduleId) {
            return schedule.copyWith(endTime: endTime);
          }
          return schedule;
        }).toList();
    state = state.copyWith(schedules: updatedSchedules);
  }

  // 특정 스케줄의 시간 협의 가능 여부 업데이트
  void updateScheduleTimeNegotiable(int scheduleId, bool isNegotiable) {
    final updatedSchedules =
        state.schedules.map((schedule) {
          if (schedule.id == scheduleId) {
            return schedule.copyWith(isTimeNegotiable: isNegotiable);
          }
          return schedule;
        }).toList();
    state = state.copyWith(schedules: updatedSchedules);
  }

  bool _validatePostingData() {
    if (state.title == null || state.title!.isEmpty) {
      state = state.copyWith(errorMessage: "제목은 필수입니다.");
      return false;
    }
    if (state.description == null || state.description!.isEmpty) {
      state = state.copyWith(errorMessage: "내용은 필수입니다.");
      return false;
    }
    if (state.payAmount == null || state.payAmount! <= 0) {
      state = state.copyWith(errorMessage: "유효한 급여를 입력해야 합니다.");
      return false;
    }
    if (state.paymentType.isEmpty) {
      state = state.copyWith(errorMessage: "지급 방식은 필수입니다.");
      return false;
    }
    if (state.selectedKeywords.isEmpty) {
      state = state.copyWith(errorMessage: "키워드는 최소 하나 이상 선택해야 합니다.");
      return false;
    }
    if (state.schedules.isEmpty) {
      state = state.copyWith(errorMessage: "근무 일정은 최소 하나 이상 추가해야 합니다.");
      return false;
    }
    return true;
  }

  void updateTitle(String? title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void updatePayAmount(int? amount) {
    state = state.copyWith(payAmount: amount);
  }

  void updatePaymentType(String type) {
    state = state.copyWith(paymentType: type);
  }

  void updateselectedKeywords(List<int?> selectedKeywords) {
    final newList = selectedKeywords.whereType<int>().toList();
    state = state.copyWith(selectedKeywords: newList);
  }
}
