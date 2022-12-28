import 'package:built_collection/built_collection.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/pages/media_carousel.dart';
import 'package:pill_city_flutter/src/widgets/media_widget.dart';

class MediaCollageCell extends StatelessWidget {
  const MediaCollageCell(
      {super.key, required this.mediaList, required this.index});

  final BuiltList<MediaUrlV2> mediaList;

  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => MediaCarousel(
              media: mediaList,
              initialPage: index,
            ),
          ),
        );
      },
      child: SizedBox.expand(
        child: MediaWidget(
          media: mediaList[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MediaCollageColumn extends StatelessWidget {
  const MediaCollageColumn({super.key, required this.cells});

  final List<MediaCollageCell> cells;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (var i = 0; i < cells.length; i++) {
      final cell = cells[i];
      children.add(Flexible(child: cell));
      if (i < cells.length - 1) {
        children.add(const SizedBox(height: 4));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class MediaCollageRow extends StatelessWidget {
  const MediaCollageRow({super.key, required this.items});

  final List<Either<MediaCollageCell, MediaCollageColumn>> items;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      children.add(Flexible(child: item.isLeft ? item.left : item.right));
      if (i < items.length - 1) {
        children.add(const SizedBox(width: 4));
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class MediaCollageContainer extends StatelessWidget {
  const MediaCollageContainer({super.key, required this.item});

  final Either<MediaCollageCell, MediaCollageRow> item;

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
