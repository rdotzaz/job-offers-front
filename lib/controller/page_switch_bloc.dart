import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseSwitchPageEvent {}

enum PageName { main, newOffer, login }

class MainPageSwitchEvent extends BaseSwitchPageEvent {}

class NewOfferPageSwitchEvent extends BaseSwitchPageEvent {}

class LoginPageSwitchEvent extends BaseSwitchPageEvent {}

class PageSwitchBloc extends Bloc<BaseSwitchPageEvent, PageName> {
  PageSwitchBloc() : super(PageName.main) {
    on<MainPageSwitchEvent>((event, emit) {
      if (state == PageName.main) return;
      emit(PageName.main);
    });
    on<NewOfferPageSwitchEvent>((event, emit) {
      if (state == PageName.newOffer) return;
      emit(PageName.newOffer);
    });
    on<LoginPageSwitchEvent>((event, emit) {
      if (state == PageName.login) return;
      emit(PageName.login);
    });
  }
}
