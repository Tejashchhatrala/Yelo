import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:YELO/src/core/providers/firbease_provider.dart';
import 'package:YELO/src/core/state/app_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final phoneAuthProvider =
    StateNotifierProvider<PhoneAuthProvider, AppState<String>>((ref) {
  return PhoneAuthProvider(ref.read(firebaseAuthProvider));
});

class PhoneAuthProvider extends StateNotifier<AppState<String>> {
  final FirebaseAuth _auth;

  PhoneAuthProvider(this._auth) : super(const AppState.initial());

  String? _verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    state = const AppState.loading();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          state = const AppState.success('User signed in successfully');
        },
        verificationFailed: (FirebaseAuthException e) {
          state = AppState.error(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          state = const AppState.success('OTP sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      state = AppState.error(e.toString());
    }
  }

  Future<void> signInWithOtp(String smsCode) async {
    state = const AppState.loading();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      state = const AppState.success('User signed in successfully');
    } catch (e) {
      state = AppState.error(e.toString());
    }
  }
}
