import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pill_city/pill_city.dart';
import 'package:pill_city_flutter/src/widgets/media_widget.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('${activePage + 1}/${widget.media.length}'),
      ),
      body: SafeArea(
        child: PageView.builder(
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
              child: MediaWidget(media: widget.media[pagePosition]),
            );
          },
        ),
      ),
    );
  }
}
