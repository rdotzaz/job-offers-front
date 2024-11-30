import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseSubmitButtonEvent {}

enum SubmitButtonState { notClicked, success, failed }

class SuccessEvent extends BaseSubmitButtonEvent {}

class NotClickedEvent extends BaseSubmitButtonEvent {}

class FailedEvent extends BaseSubmitButtonEvent {}

class SubmitButtonBloc extends Bloc<BaseSubmitButtonEvent, SubmitButtonState> {
  SubmitButtonBloc() : super(SubmitButtonState.notClicked) {
    on<SuccessEvent>((event, emit) {
      if (state == SubmitButtonState.success) return;
      emit(SubmitButtonState.success);
    });
    on<NotClickedEvent>((event, emit) {
      if (state == SubmitButtonState.notClicked) return;
      emit(SubmitButtonState.notClicked);
    });
    on<FailedEvent>((event, emit) {
      if (state == SubmitButtonState.failed) return;
      emit(SubmitButtonState.failed);
    });
  }
}
