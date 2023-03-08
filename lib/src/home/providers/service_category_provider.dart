import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharelu/src/core/state/app_state.dart';
import 'package:gharelu/src/home/data_source/service_data_source.dart';
import 'package:gharelu/src/home/models/service_model.dart';

class ServiceCategoryState extends StateNotifier<AppState<List<ServiceModel>>> {
  ServiceCategoryState(this._remoteSource)
      : super(const AppState<List<ServiceModel>>.initial());
  final ServiceRemoteSource _remoteSource;

  Future<void> getServices(
      {String? categoryId, bool merchantOnly = false}) async {
    state = const AppState.loading();
    final response = await _remoteSource.getServices(
        id: categoryId, merchantOnly: merchantOnly);
    state = response.fold(
        (error) => error.when(
            serverError: (message) => AppState.error(message: message),
            noInternet: () => const AppState.noInternet()),
        (response) => AppState.success(data: response));
    log(state.toString());
  }
}

final serviceCategoryStateProvider =
    StateNotifierProvider<ServiceCategoryState, AppState<List<ServiceModel>>>(
        (ref) {
  return ServiceCategoryState(ref.read(serviceRemoteSourceProvider));
});
