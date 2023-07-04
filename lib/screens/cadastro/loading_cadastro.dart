import 'package:flutter/material.dart';

import '../../widgets/my_box_shadow.dart';
import '../../widgets/shimmer.dart';

class LoadingCadastro extends StatefulWidget {
  const LoadingCadastro({super.key});

  @override
  State<LoadingCadastro> createState() => _LoadingMoradCadastro();
}

class _LoadingMoradCadastro extends State<LoadingCadastro> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MyBoxShadow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget(
                height: size.height * 0.03,
                width: size.width * 0.5,
              ),
              ShimmerWidget(
                height: size.height * 0.03,
                width: size.width * 0.2,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget(
                  height: size.height * 0.03,
                  width: size.width * 0.4,
                ),
                ShimmerWidget(
                  height: size.height * 0.03,
                  width: size.width * 0.3,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget(
                height: size.height * 0.03,
                width: size.width * 0.4,
              ),
              ShimmerWidget(
                height: size.height * 0.03,
                width: size.width * 0.3,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: ShimmerWidget(
                  height: size.height * 0.03,
                  width: size.width * 0.6,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerWidget(
                height: size.height * 0.03,
                width: size.width * 0.5,
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              ShimmerWidget(
                height: size.height * 0.03,
                width: size.width * 0.075,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: ShimmerWidget(
              circular: 30,
              height: size.height * 0.06,
              width: size.width * 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
