import 'package:flutter/material.dart';

import '../consts.dart';

class SosBar extends StatefulWidget {
  const SosBar({super.key});

  @override
  State<SosBar> createState() => _SosBarState();
}

class _SosBarState extends State<SosBar> with SingleTickerProviderStateMixin {
  // late AnimationController _animationController;
  // late dynamic _curve;
  // late Animation _animation;

  @override
  void initState() {
    // _animationController =
    //     AnimationController(vsync: this, duration: Duration(seconds: 1));
    // _curve = CurvedAnimation(
    //     parent: _animationController, curve: Curves.bounceInOut);
    // _animation = Tween(begin: 0.0, end: 250.0).animate(_curve)
    //   ..addListener(() {
    //     setState(() {});
    //   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color colorFundo = Colors.red;
    var size = MediaQuery.of(context).size;
    return Container(
      // padding: EdgeInsets.only(top: 10),
      height: size.height * 0.13,
      width: size.width * 0.98,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).shadowColor,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(5, 5))
        ],
        color: colorFundo,
        borderRadius: BorderRadius.circular(Consts.borderButton),
      ),
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildEmergencyCalls(context, 'Samu', 0,
              icon: Icons.emergency_outlined),
          buildEmergencyCalls(context, 'Polícia', 1,
              icon: Icons.local_police_outlined),
          buildEmergencyCalls(context, 'Samu', 2,
              icon: Icons.emergency_outlined),
          buildEmergencyCalls(context, 'Polícia', 3,
              icon: Icons.local_police_outlined),
        ],
      ),
    );
    // );
  }
}

Widget buildEmergencyCalls(BuildContext context, String title, int orden,
    {required IconData icon}) {
  var size = MediaQuery.of(context).size;
  double? circleSize = size.height * 0.07;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          print(orden);
        },
        child: Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          width: circleSize,
          height: circleSize,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.black,
            size: size.height * 0.06,
          ),
        ),
      ),
      Text(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ],
  );
}
