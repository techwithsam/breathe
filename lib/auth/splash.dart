import 'package:breathe/auth/register.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final List<String> imgList = [
    "assets/spl.jpg",
    "assets/spl.jpg",
    "assets/spl.jpg",
    "assets/spl.jpg",
  ];

  final List<String> msgList = [
    "DUMMY TEXT ONE FROM BREATHE",
    "DUMMY TEXT TWO FROM BREATHE",
    "DUMMY TEXT THREE FROM BREATHE",
    "DUMMY TEXT FOUR FROM BREATHE",
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            items: imgList
                .map(
                  (item) => Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(item), fit: BoxFit.cover),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
              enableInfiniteScroll: true,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        msgList[_currentIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < imgList.length; i++)
                            (i == _currentIndex
                                ? circleBar(true)
                                : circleBar(false)),
                        ],
                      ),
                      Visibility(
                        visible: _currentIndex == 3 ? true : false,
                        child: const SizedBox(height: 22),
                      ),
                      Visibility(
                        visible: _currentIndex == 3 ? true : false,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            onPressed: () {
                               Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            padding: const EdgeInsets.only(top: 16, bottom: 20),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: isActive ? 8 : 6,
      width: isActive ? 8 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.black.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
