import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../consts/consts.dart';
import '../../../consts/consts_widget.dart';
import '../../../widgets/my_box_shadow.dart';
import '../../../widgets/page_vazia.dart';

class ListarFunc extends StatefulWidget {
  const ListarFunc({super.key});

  @override
  State<ListarFunc> createState() => _ListarFuncState();
}

class _ListarFuncState extends State<ListarFunc> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return const Placeholder();
  }
}
