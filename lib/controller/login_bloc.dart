import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oferty_pracy/utils/hive_adapter.dart';

abstract class BaseLoginEvent {}

class LoggedInEvent extends BaseLoginEvent {
  final String apiKey;

  LoggedInEvent({required this.apiKey});
}

class NotLoggedInEvent extends BaseLoginEvent {}

class LoginBloc extends Bloc<BaseLoginEvent, bool> {
  LoginBloc() : super(false) {
    on<LoggedInEvent>((event, emit) {
      HiveDatabaseAdapter.putApiKey(event.apiKey);
      emit(true);
    });
    on<NotLoggedInEvent>((event, emit) {
      HiveDatabaseAdapter.logout();
      emit(false);
    });
  }
}
