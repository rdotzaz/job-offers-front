import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oferty_pracy/controller/home/filter_bloc.dart';
import 'package:oferty_pracy/model/offer.dart';
import 'package:oferty_pracy/utils/server_wrapper.dart';

class HomeController {
  final ServerWrapper _serverWrapper = ServerWrapper();
  final FilterBloc _filterBloc = FilterBloc();

  FilterBloc getFilterBloc() => _filterBloc;

  Future<List<Offer>> fetchOffers() async {
    final state = _filterBloc.state;
    return await _serverWrapper.postOffers(
        state.cityFilters.toList(), state.positionFilters.toList());
  }

  Future<List<String>> fetchCityFilters() async {
    return await _serverWrapper.getCities();
  }

  Future<List<String>> fetchPositionFilters() async {
    return await _serverWrapper.getPositions();
  }

  Future<void> removeOffer(BuildContext context, Offer offer) async {
    await _serverWrapper.removeOffer(offer);
    context.read<FilterBloc>().add(RefreshFilter());
  }
}
