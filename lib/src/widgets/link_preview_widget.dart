import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreviewWidget extends StatelessWidget {
  const LinkPreviewWidget({super.key, required this.linkPreview});

  final LinkPreview linkPreview;

  @override
  Widget build(BuildContext context) {
    if (linkPreview.state != LinkPreviewStateEnum.fetched) {
      return const SizedBox.shrink();
    }
    Uri? parsedUrl;
    try {
      parsedUrl = Uri.parse(linkPreview.url);
    } on FormatException {}

    return GestureDetector(
      onTap: () {
        if (parsedUrl == null) {
          return;
        }
        launchUrl(
          Uri.parse(linkPreview.url),
          mode: LaunchMode.externalApplication,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[800],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                height: 80,
                width: 64,
                child: linkPreview.imageUrls != null &&
                        linkPreview.imageUrls!.isNotEmpty
                    ? Image(
                        image: Image.network(linkPreview.imageUrls![0]).image,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      )
                    : const Icon(Icons.link),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (linkPreview.title != null)
                      Text(
                        linkPreview.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 0.9,
                      ),
                    if (linkPreview.subtitle != null)
                      Column(children: [
                        const SizedBox(height: 4),
                        Text(
                          linkPreview.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 0.8,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ]),
                    if (parsedUrl != null)
                      Column(children: [
                        const SizedBox(height: 4),
                        Text(
                          parsedUrl.host,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 0.7,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
