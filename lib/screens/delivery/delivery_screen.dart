import 'package:flutter/material.dart';

import '../../consts.dart';
import '../../widgets/header.dart';
import '../../widgets/my_box_shadow.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.red,
        ),
        body: buildHeaderPage(
          context,
          titulo: 'Delivery',
          subTitulo: 'Confira seus Deliveries',
          widget: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return MyBoxShadow(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consts.buildTextTitle('Ifood'),
                  Consts.buildTextSubTitle('Retirada - 26/04/2023'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ],
              ));
            },
          ),
        ));
  }
}
