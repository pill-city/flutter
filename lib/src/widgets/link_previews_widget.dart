import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pill_city/pill_city.dart';

import 'link_preview_widget.dart';

const maxLinkPreviews = 1;

class LinkPreviewsWidget extends StatelessWidget {
  const LinkPreviewsWidget({super.key, required this.linkPreviews});

  final BuiltList<LinkPreview> linkPreviews;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    var fetchedLinkPreviews =
        linkPreviews.where((p) => p.state == LinkPreviewStateEnum.fetched);
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
      children.add(const SizedBox(height: 8));
      children.add(
        Text(
          AppLocalizations.of(context)!.and_more_link_previews(
              fetchedLinkPreviews.length - maxLinkPreviews),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }

    return Column(children: children);
  }
}
