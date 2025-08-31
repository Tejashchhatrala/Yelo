import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:YELO/main.dart';
import 'package:YELO/src/core/extensions/extensions.dart';
import 'package:YELO/src/core/routes/app_router.dart';
import 'package:YELO/src/core/theme/app_styles.dart';
import 'package:YELO/src/core/theme/theme.dart';

class AppView extends StatelessWidget {
  AppView({Key? key}) : super(key: key);
  final _router = getIt<AppRouter>();
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: AppColors.whiteColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          builder: (_, __) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: _router.delegate(),
            routeInformationParser: _router.defaultRouteParser(),
            title: 'YELO',
            theme: ThemeData(
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                centerTitle: true,
                titleTextStyle: AppStyles.text20PxSemiBold.softBlack,
              ),
              // useMaterial3: true,
              colorSchemeSeed: AppColors.primaryColor,
            ),
            builder: (context, child) => child!,
          ),
        ),
      ),
    );
  }
}
