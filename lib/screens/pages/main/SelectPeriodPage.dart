import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../model/Period.dart';
import '../../../util/PageUtil.dart';


class SelectPeriodPage extends StatefulWidget {
  List<Period> initialPeriodList;
  void Function(Period period) onChangePeriod;
  SelectPeriodPage(this.initialPeriodList,{required this.onChangePeriod});

  @override
  State<SelectPeriodPage> createState() => _SelectPeriodPageState();
}

class _SelectPeriodPageState extends State<SelectPeriodPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Period"),
      ),
      body: ListView(
        children: widget.initialPeriodList
            .map((period) => ListTile(
                  leading: Text("Period ${period.index}"),
                  title: Text(
                      "${period.startTime.format(context)} - ${period.endTime.format(context)}"),
                  onTap: (){
                    PageUtil.pop(context);
                    widget.onChangePeriod(period);
                  },
                ))
            .toList(),
      ),
    );
  }
}
