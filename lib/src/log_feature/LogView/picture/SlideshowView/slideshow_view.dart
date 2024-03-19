import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:log_it/src/log_feature/log.dart';
import 'package:log_it/src/log_feature/photo.dart';
import 'package:path_provider/path_provider.dart';

class Slideshow extends StatefulWidget {
  final Log log;
  final Future<List<Photo>> futurePhotos;
  const Slideshow({
    super.key,
    required this.log,
    required this.futurePhotos,
  });

  @override
  State<Slideshow> createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  late List<Photo> photos;
  late Directory dir;
  Future<Directory> futureDirectory = getApplicationDocumentsDirectory();
  final CarouselController carouselController = CarouselController();
  bool autoPlay = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FutureBuilder(
            future: Future.wait([futureDirectory, widget.futurePhotos]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              dir = snapshot.data![0] as Directory;
              photos = snapshot.data![1] as List<Photo>;
              return CarouselSlider(
                items: [
                  for (final p in photos)
                    Image.file(
                      File('${dir.path}/${widget.log.dbName}/${p.data}'),
                    )
                ],
                carouselController: carouselController,
                options: CarouselOptions(
                  height: 300,
                  aspectRatio: 400 / 300,
                  autoPlay: autoPlay,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
              );
            }),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  carouselController.previousPage();
                },
                child: const Icon(Icons.skip_previous),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    autoPlay = !autoPlay;
                  });
                },
                child: autoPlay
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
              ElevatedButton(
                onPressed: () {
                  carouselController.nextPage();
                },
                child: const Icon(Icons.skip_next),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
