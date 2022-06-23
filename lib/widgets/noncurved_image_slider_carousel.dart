import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NonCurvedImageSliderCarousel extends StatefulWidget {
  final imageArray;

  const NonCurvedImageSliderCarousel({Key? key, required this.imageArray})
      : super(key: key);
  @override
  State<NonCurvedImageSliderCarousel> createState() =>
      _NonCurvedImageSliderCarouselState();
}

class _NonCurvedImageSliderCarouselState
    extends State<NonCurvedImageSliderCarousel> {
  int activeIndex = 0;
  // final ImagesInCarousel = [
  //   'images/cat.jpg',
  //   'images/catt.jpg',
  //   'images/cattt.jpg',
  // ];

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  height: 400,
                  onPageChanged: (index, reason) =>
                      setState(() => activeIndex = index),
                ),
                itemBuilder: (context, index, realIndex) {
                  // final ImageInCarousel = widget.imageArray[index];
                  // return buildImage(ImageInCarousel, index);
                  return Image.network(widget.imageArray[index]);
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
                SizedBox(height: 360),
                buildIndicator(),
              ],
            ),
          ],
        ))
      ],
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
