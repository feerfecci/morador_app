import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../consts/consts.dart';

class MyDatePicker extends StatefulWidget {
  static String dataSelected = '';
  final List? lista = null;
  MyDatePicker({lista, required dataSelected, super.key});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  @override
  Widget build(BuildContext context) {
    var enabled = widget.lista == null
        ? true
        : widget.lista!.isEmpty
            ? false
            : true;
    var size = MediaQuery.of(context).size;
    return DateTimePicker(
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.only(left: size.width * 0.02, top: size.height * 0.05),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        hintText: 'Clique aqui para selecionar uma data',
        hintStyle: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
      type: DateTimePickerType.dateTime,
      selectableDayPredicate: (DateTime dateTime) {
        if (dateTime == DateTime(2023, 8, 12)) {
          return false;
        }
        return true;
      },
      initialDate: DateTime.now(),
      dateMask: 'dd/MM/yyyy - HH:mm',
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      style: TextStyle(
        fontSize: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
      textAlign: TextAlign.center,
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
      dateLabelText: 'Date Time',
      locale: Locale('pt', 'BR'),

      use24HourFormat: true,
      calendarTitle: 'Selecione uma data e hora',
      onChanged: (val) {
        //print(val);
        setState(() {
          MyDatePicker.dataSelected = val;
        });
      },
      enabled: enabled,
      // validator: (val) {
      //   setState(() => _valueToValidate2 = val ?? '');
      //   return null;
      // },
      // onSaved: (val) => setState(() => _valueSaved2 = val ?? ''),
    );
  }
}
