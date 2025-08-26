import 'package:freezed_annotation/freezed_annotation.dart';

part 'field.freezed.dart';

@freezed
abstract class Field with _$Field {
  const factory Field({
    required String value,
    @Default('') String errorMessage,
    @Default('') String warningMessage,
    @Default(false) bool isValid,
    @Default(false) bool isTouched,
    @Default(false) bool obscureText,
  }) = _Field;
}