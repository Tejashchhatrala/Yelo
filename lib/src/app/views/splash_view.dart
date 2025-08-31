import 'package:YELO/src/core/providers/location_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:YELO/src/app/provider/auth_status_provider.dart';
import 'package:YELO/src/auth/models/custom_user_model.dart';
import 'package:YELO/src/core/routes/app_router.dart';
import 'package:YELO/src/core/state/app_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class SplashView extends HookConsumerWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _checkOnboardingStatus(context, ref);
      return null;
    }, []);

    ref.listen<AppState<CustomUserModel>>(authStatusNotifierProvider,
        (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        success: (data) {
          ref.read(authChangeProvider);
          context.router.replaceAll([const DashboardRouter()]);
        },
        error: (message) async {
          context.router.push(const LoginChoiceRoute());
        },
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _checkOnboardingStatus(
      BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!onboardingCompleted) {
      context.router.replaceAll([const OnboardingRoute()]);
    } else {
      await ref.read(locationProvider.notifier).determinePosition();
      // If onboarding is completed, the auth listener will handle navigation.
    }
  }
}
