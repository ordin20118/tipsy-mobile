import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class StarRating extends StatefulWidget {
//   @override
//   _StarRatingState createState() => _StarRatingState();
// }
//
// class _StarRatingState extends State<StarRating> {
//
//   int rate = 0;
//   final StarRatingController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(5, (index) {
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               // 별 아이콘을 터치한 위치까지 rate 값을 업데이트
//               rate = index + 1;
//             });
//           },
//           child: Icon(
//             size: 40,
//             index < rate ? Icons.star : Icons.star,
//             color: index < rate ? Colors.amber : Colors.grey,
//           ),
//         );
//       }),
//     );
//   }
// }


class StarRating extends StatelessWidget {

  //int rate = 0;
  final StarRatingController controller;
  StarRating({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            controller.rate.value = index + 1;
          },
          child: Obx(() => Icon(
            size: 40,
            index < controller.rate.value ? Icons.star : Icons.star,
            color: index < controller.rate.value ? Colors.amber : Colors.grey,
          )),
        );
      }),
    );
  }
}

class StarRatingController extends GetxController {
  RxInt rate = 0.obs;
}