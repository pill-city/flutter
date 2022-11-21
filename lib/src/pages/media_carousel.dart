import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/utils/default_network_image_fetch_strategy.dart';

class MediaCarousel extends StatefulWidget {
  const MediaCarousel(
      {super.key, required this.media, required this.initialPage});

  final BuiltList<MediaUrlV2> media;
  final int initialPage;

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late PageController _pageController;

  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    activePage = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${activePage + 1}/${widget.media.length}'),
        ),
        body: PageView.builder(
          itemCount: widget.media.length,
          pageSnapping: true,
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              activePage = page;
            });
          },
          itemBuilder: (context, pagePosition) {
            return InteractiveViewer(
              child: Image(
                image: NetworkImageWithRetry(
                  widget.media[pagePosition].originalUrl,
                  fetchStrategy: defaultNetworkImageFetchStrategy,
                ),
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
