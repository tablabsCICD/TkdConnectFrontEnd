import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerDialog{
  late DateTime _selectedDate;

  String selectedDate = "";
  String? dateTime;
  DateTime _currentDate = DateTime.now();


  Future<String> pickDateDialog(context) async{
    DateTime? _datePicker = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
    );
    if (_datePicker != null && _datePicker != _currentDate) {
      DateTime? date;
      if (_datePicker.isBefore(DateTime.now())) {
        date = _datePicker;
        selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      } else {
        date = _datePicker;
        selectedDate = DateFormat("yyyy-MM-dd").format(_datePicker);           //resFromDateCnt;
      }
    }
    return selectedDate;


  }

  Future<String> pickDateAfterDialog(context,String fromDate) async{

    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(fromDate);
    DateTime? _datePicker = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
    );
    if (_datePicker != null && _datePicker != _currentDate) {
      DateTime? date;
      if (_datePicker.isAfter(tempDate)) {
        date = _datePicker;
        selectedDate = DateFormat("yyyy-MM-dd").format(_datePicker);
      } else {
        date = _datePicker;
        selectedDate = DateFormat("yyyy-MM-dd").format(tempDate.add(const Duration(days: 5)));           //resFromDateCnt;
      }
    }
    return selectedDate;


  }

  Future<String> pickBeforeDateDialog(context) async{
    DateTime? _datePicker = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
    );
    if (_datePicker != null && _datePicker != _currentDate) {
      // selectedDate = DateFormat("yyyy-MM-dd").format(_datePicker);           //resFromDateCnt;
      DateTime? date;
      if (_datePicker.isBefore(DateTime.now())) {
        date = _datePicker;
        selectedDate = DateFormat("yyyy-MM-dd").format(_datePicker);
      } else {
        date = _datePicker;
        selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());           //resFromDateCnt;
      }
    }

    return selectedDate;

  }




}