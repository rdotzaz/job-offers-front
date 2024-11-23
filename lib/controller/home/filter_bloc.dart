import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseFilterEvent {}

class FilterState {
  Set<String> cityFilters = {};
  Set<String> positionFilters = {};

  FilterState(this.cityFilters, this.positionFilters);
}

enum FilterType { city, position }

class ToggleFilter extends BaseFilterEvent {
  final FilterType filterType;
  final String filterName;

  ToggleFilter(this.filterType, this.filterName);
}

class FilterBloc extends Bloc<BaseFilterEvent, FilterState> {
  FilterBloc() : super(FilterState({}, {})) {
    on<ToggleFilter>((event, emit) {
      final filterType = event.filterType;
      final filterName = event.filterName;

      var filterSet = filterType == FilterType.city
          ? state.cityFilters
          : state.positionFilters;

      if (filterSet.contains(filterName)) {
        filterSet.remove(filterName);
      } else {
        filterSet.add(filterName);
      }

      final newState = filterType == FilterType.city
          ? FilterState(filterSet, state.positionFilters)
          : FilterState(state.cityFilters, filterSet);
      emit(newState);
    });
  }
}
