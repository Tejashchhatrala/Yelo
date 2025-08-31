import 'package:YELO/src/core/routes/app_router.dart';
import 'package:YELO/src/home/views/user_home_view/comment_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:YELO/src/core/extensions/extensions.dart';
import 'package:YELO/src/core/theme/app_styles.dart';
import 'package:YELO/src/home/models/opportunity_model.dart';
import 'package:YELO/src/home/providers/bookmark_provider.dart';
import 'package:YELO/src/home/providers/comment_provider.dart';
import 'package:YELO/src/home/providers/like_provider.dart';

class OpportunityCard extends ConsumerWidget {
  final Opportunity opportunity;

  const OpportunityCard({
    Key? key,
    required this.opportunity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref.watch(isLikedProvider(opportunity.id));
    final isBookmarked = ref.watch(isBookmarkedProvider(opportunity.id));
    final comments = ref.watch(commentProvider(opportunity.id));

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            child: CachedNetworkImage(
              imageUrl: opportunity.imageUrl,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opportunity.title,
                  style: AppStyles.text18PxBold,
                ),
                10.verticalSpace,
                Text(
                  opportunity.description,
                  style: AppStyles.text14PxRegular,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${opportunity.timestamp.day}/${opportunity.timestamp.month}/${opportunity.timestamp.year}',
                      style: AppStyles.text12PxRegular.midGrey,
                    ),
                    Row(
                      children: [
                        isLiked.when(
                          data: (liked) => IconButton(
                            icon: Icon(
                              liked ? Icons.favorite : Icons.favorite_border,
                              color: liked ? Colors.red : null,
                            ),
                            onPressed: () async {
                              await ref
                                  .read(likeProvider)
                                  .toggleLike(opportunity.id);
                              ref.refresh(isLikedProvider(opportunity.id));
                            },
                          ),
                          loading: () => const IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: null,
                          ),
                          error: (error, stackTrace) => const IconButton(
                            icon: Icon(Icons.error),
                            onPressed: null,
                          ),
                        ),
                        isBookmarked.when(
                          data: (bookmarked) => IconButton(
                            icon: Icon(
                              bookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),
                            onPressed: () async {
                              await ref
                                  .read(bookmarkProvider)
                                  .toggleBookmark(opportunity.id);
                              ref.refresh(
                                  isBookmarkedProvider(opportunity.id));
                            },
                          ),
                          loading: () => const IconButton(
                            icon: Icon(Icons.bookmark_border),
                            onPressed: null,
                          ),
                          error: (error, stackTrace) => const IconButton(
                            icon: Icon(Icons.error),
                            onPressed: null,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment_outlined),
                          onPressed: () {
                            context.router.pushWidget(
                                CommentView(opportunityId: opportunity.id));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                10.verticalSpace,
                comments.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Text('No comments yet.');
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...data.take(3).map((comment) => Text(
                              '${comment.authorId}: ${comment.text}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                        if (data.length > 3)
                          TextButton(
                            onPressed: () {
                              context.router.pushWidget(
                                  CommentView(opportunityId: opportunity.id));
                            },
                            child: const Text('View all comments'),
                          ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) =>
                      const Text('Could not load comments.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
