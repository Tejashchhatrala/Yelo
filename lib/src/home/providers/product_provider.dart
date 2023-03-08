import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharelu/src/core/state/app_state.dart';
import 'package:gharelu/src/home/data_source/service_data_source.dart';
import 'package:gharelu/src/home/models/product_model.dart';

class ProductState extends StateNotifier<AppState<List<ProductModel>>> {
  ProductState(this._remoteSource) : super(const AppState<List<ProductModel>>.initial());

  final ServiceRemoteSource _remoteSource;

  Future<void> getProducts({
    String? categoryId,
    String? productId,
    bool merchantOnly = false,
  }) async {
    state = const AppState.loading();
    final response = await _remoteSource.getProducts(
      categoryId: categoryId,
      productId: productId,
      merchantOnly: merchantOnly,
    );
    state = response.fold((error) => error.when(serverError: (message) => AppState.error(message: message), noInternet: () => const AppState.noInternet()), (response) => AppState.success(data: response));
    print(state);
  }
}

final productStateProvider = StateNotifierProvider<ProductState, AppState<List<ProductModel>>>((ref) => ProductState(ref.read(serviceRemoteSourceProvider)));
