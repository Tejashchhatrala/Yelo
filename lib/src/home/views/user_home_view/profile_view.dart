import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:YELO/src/auth/providers/logout_provider.dart';
import 'package:YELO/src/core/assets/assets.gen.dart';
import 'package:YELO/src/core/extensions/context_extension.dart';
import 'package:YELO/src/core/extensions/extensions.dart';
import 'package:YELO/src/core/routes/app_router.dart';
import 'package:YELO/src/core/state/app_state.dart';
import 'package:YELO/src/core/theme/app_colors.dart';
import 'package:YELO/src/core/theme/app_styles.dart';
import 'package:YELO/src/core/widgets/widgets.dart';
import 'package:YELO/src/home/providers/get_user_info_provider.dart';
import 'package:YELO/src/home/providers/user_interactions_provider.dart';
import 'package:YELO/src/home/widgets/opportunity_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage(name: 'ProfileRouter')
class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key, required this.onAppoinment}) : super(key: key);
  final VoidCallback onAppoinment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoNotifiderProvider);

    ref.listen<AppState>(logoutStateNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        success: (data) {
          context.router.replaceAll([const SplashRoute()]);
          ref.invalidate(getUserInfoNotifiderProvider);
        },
        error: (message) {
          context.showSnackbar(message: message);
        },
      );
    });

    return DefaultTabController(
      length: 2,
      child: ScaffoldWrapper(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text('Profile', style: AppStyles.text16PxSemiBold.white),
          elevation: 0,
          actions: [
            if (userInfo.asData?.value.role == 'admin')
              IconButton(
                icon: const Icon(Icons.dashboard),
                onPressed: () => context.router.push(const AdminDashboardRoute()),
              ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  ref.read(logoutStateNotifierProvider.notifier).logout(),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Liked'),
              Tab(text: 'Bookmarked'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .2,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
              ),
              child: userInfo.maybeWhen(
                orElse: Container.new,
                error: (message) => Text(message),
                success: (data) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientCircle(
                        child: CacheImageViewer(
                          imageUrl: '',
                          error: (context, url, error) =>
                              Assets.images.userAvatar.image(fit: BoxFit.cover),
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        data.name,
                        style: AppStyles.text14PxSemiBold.white,
                      ),
                      4.verticalSpace,
                      Text(
                        data.email,
                        style: AppStyles.text10PxMedium.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOpportunitiesList(likedOpportunitiesProvider),
                  _buildOpportunitiesList(bookmarkedOpportunitiesProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunitiesList(StreamProvider<List<dynamic>> provider) {
    return Consumer(
      builder: (context, ref, _) {
        final opportunities = ref.watch(provider);
        return opportunities.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('No opportunities yet.'));
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return OpportunityCard(opportunity: data[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('An error occurred: $error')),
        );
      },
    );
  }
}
