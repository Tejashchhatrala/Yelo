import 'package:YELO/src/admin/providers/admin_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:YELO/src/home/models/opportunity_model.dart';

@RoutePage()
class AdminDashboardView extends ConsumerWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingOpportunities = ref.watch(pendingOpportunitiesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending Opportunities'),
              Tab(text: 'Flagged Comments'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            pendingOpportunities.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text('No pending opportunities.'));
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final opportunity = data[index];
                    return ListTile(
                      title: Text(opportunity.title),
                      subtitle: Text(opportunity.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              ref
                                  .read(adminProvider)
                                  .approveOpportunity(opportunity.id);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              ref
                                  .read(adminProvider)
                                  .rejectOpportunity(opportunity.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('An error occurred: $error')),
            ),
            const Center(child: Text('Flagged comments will be shown here.')),
          ],
        ),
      ),
    );
  }
}
