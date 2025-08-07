import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Base skeleton widget with shimmer effect
class SkeletonWidget extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonWidget({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Skeleton for persona card in selection screen
class PersonaCardSkeleton extends StatelessWidget {
  const PersonaCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          // Image skeleton
          Expanded(
            child: SkeletonWidget(
              width: double.infinity,
              height: double.infinity,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          // Info section skeleton
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Name skeleton
                    SkeletonWidget(
                      width: 80,
                      height: 24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 8),
                    // Age skeleton
                    SkeletonWidget(
                      width: 30,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description skeleton
                SkeletonWidget(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                SkeletonWidget(
                  width: 200,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for chat message bubble
class MessageBubbleSkeleton extends StatelessWidget {
  final bool isFromUser;

  const MessageBubbleSkeleton({
    Key? key,
    required this.isFromUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isFromUser ? 80 : 16,
          right: isFromUser ? 16 : 80,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment:
              isFromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            SkeletonWidget(
              width: 200,
              height: 60,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    isFromUser ? const Radius.circular(16) : Radius.zero,
                bottomRight:
                    isFromUser ? Radius.zero : const Radius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for chat list item
class ChatListItemSkeleton extends StatelessWidget {
  const ChatListItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar skeleton
          SkeletonWidget(
            width: 56,
            height: 56,
            borderRadius: BorderRadius.circular(28),
          ),
          const SizedBox(width: 12),
          // Content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name skeleton
                    SkeletonWidget(
                      width: 100,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Time skeleton
                    SkeletonWidget(
                      width: 40,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Message skeleton
                SkeletonWidget(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for profile screen
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar skeleton
          Center(
            child: SkeletonWidget(
              width: 120,
              height: 120,
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          const SizedBox(height: 16),
          // Name skeleton
          Center(
            child: SkeletonWidget(
              width: 150,
              height: 28,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          // Email skeleton
          Center(
            child: SkeletonWidget(
              width: 200,
              height: 20,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 32),
          // Stats skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatSkeleton(),
              _buildStatSkeleton(),
              _buildStatSkeleton(),
            ],
          ),
          const SizedBox(height: 32),
          // Settings skeleton
          ...List.generate(4, (index) => _buildSettingItemSkeleton()),
        ],
      ),
    );
  }

  Widget _buildStatSkeleton() {
    return Column(
      children: [
        SkeletonWidget(
          width: 40,
          height: 32,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        SkeletonWidget(
          width: 60,
          height: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildSettingItemSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SkeletonWidget(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonWidget(
                  width: 120,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                SkeletonWidget(
                  width: 200,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for matched personas screen
class MatchedPersonaSkeleton extends StatelessWidget {
  const MatchedPersonaSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar skeleton
          SkeletonWidget(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.circular(30),
          ),
          const SizedBox(width: 16),
          // Content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name skeleton
                SkeletonWidget(
                  width: 120,
                  height: 24,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                // Relationship score skeleton
                Row(
                  children: [
                    SkeletonWidget(
                      width: 24,
                      height: 24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    const SizedBox(width: 8),
                    SkeletonWidget(
                      width: 80,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Arrow skeleton
          SkeletonWidget(
            width: 24,
            height: 24,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }
}

/// Loading state with multiple skeleton items
class SkeletonListView extends StatelessWidget {
  final Widget Function() itemBuilder;
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const SkeletonListView({
    Key? key,
    required this.itemBuilder,
    this.itemCount = 5,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(),
    );
  }
}
