import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/show_more_link_previews_widget.dart';

import 'link_preview_widget.dart';

class LinkPreviewsWidget extends StatelessWidget {
  const LinkPreviewsWidget({
    super.key,
    required this.linkPreviews,
    required this.maxLinkPreviews,
  });

  final BuiltList<LinkPreview> linkPreviews;
  final int maxLinkPreviews;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    var fetchedLinkPreviews = linkPreviews
        .where((p) => p.state == LinkPreviewStateEnum.fetched)
        .toList();
    var renderedLinkPreviews =
        fetchedLinkPreviews.take(maxLinkPreviews).toList();
    for (var i = 0; i < renderedLinkPreviews.length; i++) {
      final linkPreview = renderedLinkPreviews[i];
      children.add(
        LinkPreviewWidget(linkPreview: linkPreview),
      );
      if (i != renderedLinkPreviews.length - 1) {
        children.add(const SizedBox(height: 8));
      }
    }
    if (fetchedLinkPreviews.length > maxLinkPreviews) {
      var hiddenLinkPreviews = fetchedLinkPreviews.reversed
          .take(fetchedLinkPreviews.length - maxLinkPreviews)
          .toList();

      children.add(const SizedBox(height: 8));
      children.add(ShowMoreLinkPreviewsWidget(
          linkPreviews: BuiltList.from(hiddenLinkPreviews)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
