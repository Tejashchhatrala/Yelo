import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:YELO/src/auth/providers/phone_auth_provider.dart';
import 'package:YELO/src/core/extensions/context_extension.dart';
import 'package:YELO/src/core/extensions/extensions.dart';
import 'package:YELO/src/core/routes/app_router.dart';
import 'package:YELO/src/core/state/app_state.dart';
import 'package:YELO/src/core/theme/app_styles.dart';
import 'package:YELO/src/core/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class OtpView extends HookConsumerWidget {
  const OtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _otpController = useTextEditingController();

    ref.listen(phoneAuthProvider, (previous, next) {
      final state = next as AppState;
      state.maybeWhen(
        orElse: () => null,
        success: (data) {
          context.showSnackbar(message: 'Login successful');
          context.router.replaceAll([const DashboardRouter()]);
        },
        error: (message) => context.showSnackbar(message: message),
      );
    });

    return ScaffoldWrapper(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              'Enter the OTP sent to your phone',
              style: AppStyles.text24PxBold,
            ),
            80.verticalSpace,
            CustomTextField(
              title: 'OTP',
              controller: _otpController,
              textInputType: TextInputType.number,
            ),
            30.verticalSpace,
            Align(
              child: CustomButton(
                onPressed: () {
                  ref
                      .read(phoneAuthProvider.notifier)
                      .signInWithOtp(_otpController.text);
                },
                title: 'Verify OTP',
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
