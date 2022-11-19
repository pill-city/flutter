import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/post_media_image.dart';

class PostMediaCollageCell extends StatelessWidget {
  const PostMediaCollageCell({super.key, required this.postMedia});

  final MediaUrlV2 postMedia;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: PostMediaImage(postMedia: postMedia),
      ),
    );
  }
}

class PostMediaCollageColumn extends StatelessWidget {
  const PostMediaCollageColumn({super.key, required this.cells});

  final List<PostMediaCollageCell> cells;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (var i = 0; i < cells.length; i++) {
      final cell = cells[i];
      children.add(Flexible(flex: 24, child: cell));
      if (i < cells.length - 1) {
        children.add(const Expanded(flex: 1, child: SizedBox()));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class PostMediaCollageRow extends StatelessWidget {
  const PostMediaCollageRow({super.key, required this.items});

  final List<Either<PostMediaCollageCell, PostMediaCollageColumn>> items;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      children
          .add(Flexible(flex: 24, child: item.isLeft ? item.left : item.right));
      if (i < items.length - 1) {
        children.add(const Expanded(flex: 1, child: SizedBox()));
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class PostMediaCollageContainer extends StatelessWidget {
  const PostMediaCollageContainer({super.key, required this.item});

  final Either<PostMediaCollageCell, PostMediaCollageRow> item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: item.isLeft ? item.left : item.right,
      ),
    );
  }
}
