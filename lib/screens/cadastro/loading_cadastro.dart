import 'package:flutter/material.dart';

import '../../consts/consts_widget.dart';
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
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
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
              ConstsWidget.buildPadding001(
                context,
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
            ],
          ),
        );
      },
    );
  }
}
