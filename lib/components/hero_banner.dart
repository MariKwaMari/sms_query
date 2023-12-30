import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return CarouselSlider(
      items: [
        Image.network(
          'https://images.pexels.com/photos/128867/coins-currency-investment-insurance-128867.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1r', // Replace with your banner image URL
          fit: BoxFit.cover,
          height: screenHeight * 0.25, // Occupies a quarter of the screen height
        ),
        Image.network(
          'https://images.pexels.com/photos/210600/pexels-photo-210600.jpeg?auto=compress&cs=tinysrgb&w=600', // Replace with your banner image URL
          fit: BoxFit.cover,
          height: screenHeight * 0.25, // Occupies a quarter of the screen height
        ),
        // Add more images as needed
      ],
      options: CarouselOptions(
        height: screenHeight * 0.25, // Adjust the height to your desired size
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
      ),
    );
  }
}
