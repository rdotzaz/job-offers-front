import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseSwitchPageEvent {}

enum PageName { main, newOffer, about }

class MainPageSwitchEvent extends BaseSwitchPageEvent {}

class NewOfferPageSwitchEvent extends BaseSwitchPageEvent {}

class AboutPageSwitchEvent extends BaseSwitchPageEvent {}

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
    on<AboutPageSwitchEvent>((event, emit) {
      if (state == PageName.about) return;
      emit(PageName.about);
    });
  }
}
