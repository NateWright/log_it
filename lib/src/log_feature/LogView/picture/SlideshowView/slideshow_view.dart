import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Slideshow extends StatefulWidget {
  const Slideshow({super.key});

  @override
  State<Slideshow> createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  final CarouselController carouselController = CarouselController();
  bool autoPlay = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider(
          items: [
            Image.network('https://picsum.photos/400/300'),
            Image.network('https://picsum.photos/400/300'),
            Image.network('https://picsum.photos/400/300'),
          ],
          carouselController: carouselController,
          options: CarouselOptions(
            height: 300,
            aspectRatio: 400 / 300,
            autoPlay: autoPlay,
            autoPlayInterval: const Duration(seconds: 3),
          ),
        ),
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
