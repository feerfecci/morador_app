import 'package:flutter/material.dart';

import '../../widgets/header.dart';
import 'hart.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final Tween<Offset> _offSet = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: buildHeaderPage(
        context,
        titulo: 'titulo',
        subTitulo: 'subTitulo',
        widget: Column(
          children: [
            AnimatedList(
              shrinkWrap: true,
              key: _listKey,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(_offSet),
                  child: ListTile(
                    title: Text('sfdgsdfgdsfgdsfg'),
                    subtitle: Text('rshdfgsdfgsdfghtk'),
                    trailing: Heart(),
                  ),
                );
              },
              initialItemCount: 10,
            ),
          ],
        ),
      ),
    );
  }
}
