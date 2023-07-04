import 'package:flutter/material.dart';

import '../../widgets/my_box_shadow.dart';
import '../../widgets/shimmer.dart';

class LoadingCorresp extends StatefulWidget {
  const LoadingCorresp({super.key});

  @override
  State<LoadingCorresp> createState() => _LoadingCorrespState();
}

class _LoadingCorrespState extends State<LoadingCorresp> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MyBoxShadow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: ShimmerWidget(
              height: size.height * 0.03,
              width: size.width * 0.7,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerWidget(
                height: size.height * 0.03,
                width: size.width * 0.6,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: ShimmerWidget(
              height: size.height * 0.03,
              width: size.width * 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
