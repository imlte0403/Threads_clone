import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../constants/text_style.dart';
import '../../widgets/post_components.dart';
import 'search_viewmodel.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.systemBackground(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ScreenHeader(),
            const _SearchField(),
            Gaps.v20,
            Expanded(
              child: ref.watch(searchViewModelProvider).when(
                    data: (posts) {
                      if (posts.isEmpty) {
                        return const Center(
                          child: Text('No posts found.'),
                        );
                      }
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostComponent(
                            post: post,
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stackTrace) => Center(
                      child: Text(
                        'Could not load posts: $error',
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.size16),
      child: Text('Search', style: AppTextStyles.screenTitle(context)),
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
      child: CupertinoSearchTextField(
        placeholder: 'Search posts',
        style: AppTextStyles.commonText(context),
        onChanged: (value) {
          ref.read(searchViewModelProvider.notifier).searchPosts(value);
        },
        decoration: BoxDecoration(
          color: AppColors.secondarySystemBackground(context),
          borderRadius: BorderRadius.circular(Sizes.size10),
        ),
      ),
    );
  }
}

