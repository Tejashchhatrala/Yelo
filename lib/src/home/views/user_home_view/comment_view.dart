import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:YELO/src/core/extensions/extensions.dart';
import 'package:YELO/src/core/widgets/widgets.dart';
import 'package:YELO/src/home/providers/comment_provider.dart';

@RoutePage()
class CommentView extends HookConsumerWidget {
  final String opportunityId;

  const CommentView({
    Key? key,
    required this.opportunityId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(commentProvider(opportunityId));
    final commentController = useTextEditingController();

    return ScaffoldWrapper(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: comments.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final comment = data[index];
                    return ListTile(
                      title: Text(comment.authorId),
                      subtitle: Text(comment.text),
                      trailing: Text(
                        '${comment.timestamp.day}/${comment.timestamp.month}/${comment.timestamp.year}',
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('An error occurred: $error')),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    title: 'Add a comment...',
                    controller: commentController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      ref
                          .read(addCommentProvider)
                          .addComment(opportunityId, commentController.text);
                      commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
