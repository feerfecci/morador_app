// ignore_for_file: non_constant_identifier_names

import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDatePicker extends StatefulWidget {
  static String dataSelected = '';
  final List? dataReservada;
  final List? lista = [];
  final DateTimePickerType type;
  final bool aniversario;
  final hintText;
  MyDatePicker(
      {lista,
      required dataSelected,
      this.type = DateTimePickerType.dateTime,
      this.dataReservada,
      this.aniversario = false,
      this.hintText = 'Clique aqui para selecionar uma data',
      super.key});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  List data_reservada = [];

  @override
  void initState() {
    if (widget.dataReservada != null) {
      data_reservada = widget.dataReservada!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var enabled = widget.lista == null
    //     ? true
    //     : widget.lista!.isEmpty
    //         ? false
    //         : true;
    var size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(
        dataTableTheme: DataTableThemeData(
          decoration: BoxDecoration(color: Colors.red),
        ),
        colorScheme: ColorScheme.light(
          onBackground: Theme.of(context)
              .bottomNavigationBarTheme
              .unselectedItemColor!, // fundo relógio
          primary: Theme.of(context).colorScheme.primary, //borda campo
          // onTertiary: Colors.yellow,
          // onPrimaryContainer: Colors.red,
          // tertiary: Colors.red,
          // secondary: Colors.red,
          // scrim: Colors.red,
          // onSecondary: Colors.red,
          // outline: Colors.red,
          // inversePrimary: Colors.red,

          surface: Theme.of(context).canvasColor, // fundo card hora
          // Theme.of(context).colorScheme.primary, // header background color
          onPrimary: Theme.of(context)
              .textTheme
              .bodyLarge!
              .color!, // header text color
          onSurface:
              Theme.of(context).textTheme.bodyLarge!.color!, // body text color
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, // button text color
          ),
        ),
      ),
      child: DateTimePicker(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: !widget.aniversario ? size.width * 0.02 : 0,
            top: size.height * 0.045,
          ),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: MyDatePicker.dataSelected != '0000-00-00' &&
                  MyDatePicker.dataSelected != ''
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(MyDatePicker.dataSelected))
                  .toString()
              : widget.aniversario
                  ? 'Data Nascimento'
                  : widget.hintText,
          hintStyle: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        type: widget.type,

        selectableDayPredicate: (DateTime dateTime) {
          if (data_reservada.isNotEmpty) {
            for (var i = 0; i <= data_reservada.length - 1; i++) {
              String dataRes = data_reservada[i];
              if ('${dateTime.year}-${dateTime.month}-${dateTime.day}' ==
                  '${DateTime.parse(dataRes).year}-${DateTime.parse(dataRes).month}-${DateTime.parse(dataRes).day} 00:00:00.000') {
                return false;
              }
            }
          } else {
            return true;
          }

          return true;
        },
        initialDate: DateTime.now(),
        dateMask: widget.type == DateTimePickerType.date
            ? 'dd/MM/yyyy'
            : 'dd/MM/yyyy HH:mm:ss',

        firstDate: !widget.aniversario ? DateTime.now() : DateTime(1850),
        lastDate: !widget.aniversario ? DateTime(2100) : DateTime.now(),
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        textAlign: TextAlign.center,
        cancelText: 'Cancelar',
        confirmText: 'Selecionar',
        dateLabelText: 'Date Time',
        locale: Locale('pt', 'BR'),
        use24HourFormat: true,
        calendarTitle: 'Selecione uma data e hora',
        onChanged: (val) {
          setState(() {
            MyDatePicker.dataSelected = val;
          });
        },
        // enabled: enabled,
        // validator: (val) {
        //   setState(() => _valueToValidate2 = val ?? '');
        //   return null;
        // },
        // onSaved: (val) => setState(() => _valueSaved2 = val ?? ''),
      ),
    );
  }
}
