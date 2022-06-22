import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSliderCarousel extends StatefulWidget {
  final imageArray;

  const ImageSliderCarousel({Key? key, required this.imageArray})
      : super(key: key);
  @override
  State<ImageSliderCarousel> createState() => _ImageSliderCarouselState();
}

class _ImageSliderCarouselState extends State<ImageSliderCarousel> {
  int activeIndex = 0;
  // final ImagesInCarousel = [
  //   'images/cat.jpg',
  //   'images/catt.jpg',
  //   'images/cattt.jpg',
  // ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                  itemCount: widget.imageArray.length,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    height: 200,
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index),
                  ),
                  itemBuilder: (context, index, realIndex) {
                    // final ImageInCarousel = widget.imageArray[index];
                    return Image.network(widget.imageArray[index]);
                    // return buildImage(ImageInCarousel, index);
                  },
                ),
              ],
            ),
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 170),
                  buildIndicator(),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget buildImage(String catImage, intIndex) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.grey,
      child: Image.asset(catImage, fit: BoxFit.cover),
    );
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: widget.imageArray.length,
      effect: JumpingDotEffect(
        dotWidth: 14,
        dotHeight: 14,
        activeDotColor: Colors.pink,
        dotColor: Colors.white,
      ),
    );
  }
}
