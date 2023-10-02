import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vpma_test_phase/constants/constants.dart';
import 'package:vpma_test_phase/screens/components/slanding_clipper.dart';
import 'package:vpma_test_phase/screens/onboarding/screen_two.dart';

import '../../controller/controller.dart';

class OnboardingScreenOne extends StatelessWidget {
  final PlayerController controller;
  OnboardingScreenOne({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    //it will helps to return the size of the screen
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  width: size.width,
                  height: size.height * 0.6,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/gen_2.png'),
                ),
                ClipPath(
                  clipper: SlandingClipper(),
                  child: Container(
                    height: size.height * 0.4,
                    color: Color.fromARGB(255, 61, 95, 63),
                  ),
                )
              ],
            ),
            Positioned(
              top: size.height * 0.65,
              child: Container(
                width: size.width,
                padding: const EdgeInsets.all(appPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Song List',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: white,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    const Text(
                      'The Virtual Music application \nyou can add unlimited songs in this application.',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: appPadding / 4),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        border: Border.all(color: black, width: 2),
                        shape: BoxShape.circle,
                        color: Colors.green),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: appPadding / 4),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        border: Border.all(color: black, width: 2),
                        shape: BoxShape.circle,
                        color: white),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: appPadding / 4),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        border: Border.all(color: black, width: 2),
                        shape: BoxShape.circle,
                        color: white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: appPadding * 2),
              child: Align(
                alignment:
                    Alignment.bottomRight, // Align to the bottom-right corner
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => print('Skip'),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: appPadding),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OnboardingScreenTwo(controller: controller),
                            ),
                          );
                        },
                        backgroundColor: white,
                        child: const Icon(
                          Icons.navigate_next_rounded,
                          color: Color.fromARGB(255, 54, 143, 113),
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
