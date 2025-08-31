import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:YELO/src/auth/providers/phone_auth_provider.dart';
import 'package:YELO/src/core/extensions/context_extension.dart';
import 'package:YELO/src/core/extensions/extensions.dart';
import 'package:YELO/src/auth/view/user_auth_view/otp_view.dart';
import 'package:YELO/src/core/state/app_state.dart';
import 'package:YELO/src/core/theme/app_styles.dart';
import 'package:YELO/src/core/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class PhoneLoginView extends HookConsumerWidget {
  const PhoneLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _phoneController = useTextEditingController();

    ref.listen(phoneAuthProvider, (previous, next) {
      final state = next as AppState;
      state.maybeWhen(
        orElse: () => null,
        success: (data) {
          context.showSnackbar(message: 'OTP sent successfully');
          context.router.pushWidget(const OtpView());
        },
        error: (message) => context.showSnackbar(message: message),
      );
    });

    return ScaffoldWrapper(
      appBar: AppBar(
        title: const Text('Login with Phone'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              'Enter your phone number',
              style: AppStyles.text24PxBold,
            ),
            80.verticalSpace,
            CustomTextField(
              title: 'Phone Number',
              controller: _phoneController,
              textInputType: TextInputType.phone,
            ),
            30.verticalSpace,
            Align(
              child: CustomButton(
                onPressed: () {
                  ref
                      .read(phoneAuthProvider.notifier)
                      .verifyPhoneNumber(_phoneController.text);
                },
                title: 'Send OTP',
                loading: ref.watch(phoneAuthProvider).maybeWhen(
                      orElse: () => false,
                      loading: () => true,
                    ),
              ),
            ),
          ],
        ).px(20),
      ),
    );
  }
}
