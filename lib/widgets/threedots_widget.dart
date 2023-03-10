import 'package:flutter/material.dart';
import 'package:gaiia_chat/resources/colors.dart';

class ThreeDots extends StatefulWidget {
  const ThreeDots({super.key});

  @override
  State<ThreeDots> createState() => _ThreeDotsState();
}

class _ThreeDotsState extends State<ThreeDots> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  int currentIndex = 0;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          currentIndex++;
          if (currentIndex == 3) {
            currentIndex = 0;
          }
          animationController!.reset();
          animationController!.forward();
        }
      });
    animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          // children: [
          //   Text(
          //     'GAIIA thinks',
          //     style: TextStyle(
          //       color: black.withOpacity(0.3),
          //     ),
          //   ),
          //   const SizedBox(width: 10,),
          //   ...List.generate(3, (index) {
          //     return Opacity(
          //       opacity: currentIndex == index ? 1.0 : 0.2,
          //       child: const Text(
          //         '.',
          //         textScaleFactor: 5,
          //       ),
          //     );
          //   })
          // ],
          children: List.generate(
            3,
            (index) {
              return Opacity(
                opacity: currentIndex == index ? 1.0 : 0.2,
                child: const Text(
                  '.',
                  textScaleFactor: 5,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
