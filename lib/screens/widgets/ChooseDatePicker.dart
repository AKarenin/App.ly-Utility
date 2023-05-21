import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schoolappfinal/util/DateTimeUtil.dart';
import 'package:schoolappfinal/util/PageUtil.dart';

import '../../model/Period.dart';
import '../pages/main/SelectPeriodPage.dart';

class ChooseDatePicker extends StatefulWidget {
  void Function(DateTime dateTime) onChangeDateTime;
  DateTime? initialDate;

  ChooseDatePicker({required this.onChangeDateTime, this.initialDate});

  @override
  State<ChooseDatePicker> createState() => _ChooseDatePickerState();
}

class _ChooseDatePickerState extends State<ChooseDatePicker> {
  late TextEditingController dateTimeController;
  late DateTime selectedDateTime;
  late DateTime monday;
  late DateTime friday;

  @override
  void initState() {
    super.initState();

    final result = DateTimeUtil().getMondayAndFriday(DateTime.now());
    monday = result[0];
    friday = result[1];

    if (widget.initialDate != null) {
      selectedDateTime = widget.initialDate!;
    } else {
      selectedDateTime = monday;
    }

    dateTimeController = TextEditingController(
        text: DateFormat('yyyy/MM/dd').format(selectedDateTime));
  }

  @override
  Widget build(BuildContext context) {
    return newVersion();
  }

  Widget newVersion() {
    //GestureDetector, InkWell(effect, mouse shape)
    return TextField(
      controller: dateTimeController,
      decoration: InputDecoration(
        labelText: "DateTime",
        labelStyle: const TextStyle(color: Color(0xFF002F6D)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xFF002F6D),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xFF002F6D),
          ),
        ),
        suffixIcon: IconButton(
            onPressed: () async {
              DateTime? dateTime = await showDatePicker(
                context: context,
                initialDate: selectedDateTime,
                firstDate: monday,
                lastDate: friday,
              );

              if (dateTime != null) {
                selectedDateTime = dateTime;
                dateTimeController.text =
                    DateFormat('yyyy/MM/dd').format(dateTime);
                widget.onChangeDateTime(selectedDateTime);
              }
            },
            icon: const Icon(LineIcons.calendar)),
      ),
    );
  }
}
