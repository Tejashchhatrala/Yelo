import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gharelu/src/auth/models/custom_user_model.dart';
import 'package:gharelu/src/core/enum/order_type.dart';
import 'package:gharelu/src/home/models/product_model.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory BookingModel({
    required int createdAt,
    required String date,
    required String id,
    required String productId,
    required String productName,
    required int quantity,
    required String serviceId,
    required int subTotal,
    required String time,
    required int totalPrice,
    required int updatedAt,
    required String userId,
    required String merchantId,
    ProductModel? product,
    CustomUserModel? user,
    CustomUserModel? merchantUser,
    required int bookedDate,
    String? roomId,
    @Default(OrderType.Pending) OrderType orderType,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
