import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:YELO/src/core/extensions/extensions.dart';
import 'package:YELO/src/core/theme/app_colors.dart';
import 'package:YELO/src/core/widgets/widgets.dart';
import 'package:YELO/src/home/providers/opportunity_provider.dart';
import 'package:YELO/src/home/widgets/opportunity_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage(name: 'HomeRouter')
class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunities = ref.watch(opportunityProvider);
    return ScaffoldWrapper(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.push(const AddOpportunityRoute()),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            title: Text(
              'YELO',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            floating: true,
            pinned: true,
          ),
          opportunities.when(
            data: (data) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return OpportunityCard(opportunity: data[index]);
                  },
                  childCount: data.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => SliverFillRemaining(
              child: Center(
                child: Text('An error occurred: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
