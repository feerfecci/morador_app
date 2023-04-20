import 'package:flutter/material.dart';

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
      height: size.height * 0.1,
      width: size.width * 0.98,
      decoration: BoxDecoration(
        color: colorFundo,
        borderRadius: BorderRadius.circular(29.5),
      ),
      alignment: Alignment.center,
      child: Text(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        'SOS',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
    // );
  }
}
