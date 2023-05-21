
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:schoolappfinal/util/PageUtil.dart';

import '../../model/Period.dart';
import '../pages/main/SelectPeriodPage.dart';

class ChoosePeriodWidget extends StatefulWidget {
  Period selectedPeriod;
  List<Period> initialPeriodList;
  void Function(Period period) onChangePeriod;
  ChoosePeriodWidget(this.selectedPeriod,this.initialPeriodList, {required this.onChangePeriod});

  @override
  State<ChoosePeriodWidget> createState() => _ChoosePeriodWidgetState();
}

class _ChoosePeriodWidgetState extends State<ChoosePeriodWidget> {
  // String periodString = "Choose a Period";

  late TextEditingController periodController;

  @override
  void initState() {
    super.initState();
    periodController = TextEditingController(text: "Period ${widget.selectedPeriod.index}");
  }

  @override
  Widget build(BuildContext context) {
    return newVersion();
  }

  // Widget oldVersion(){
  //   return Container(
  //     child: ListTile(
  //       title: Text(periodString),
  //       trailing: Icon(Icons.arrow_drop_down),
  //       onTap: () {
  //         PageUtil.push(context, SelectPeriodPage(widget.initialPeriodList, onChangePeriod:(period){
  //           periodString = "Period ${period.index} ${period.startTime.format(context)} - ${period.endTime.format(context)}";
  //           setState((){});
  //           widget.onChangePeriod(period);
  //         }));
  //       },
  //     ),
  //     color: Colors.green,
  //   );
  // }

  Widget newVersion() {
    //GestureDetector, InkWell(effect, mouse shape)
    return TextField(
      controller: periodController,
      decoration: InputDecoration(
        labelText: "Period",
        labelStyle: TextStyle(color: Color(0xFF002F6D)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xFF002F6D),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xFF002F6D),
          ),
        ),
        suffixIcon: IconButton(onPressed: () {
          PageUtil.push(context, SelectPeriodPage(widget.initialPeriodList, onChangePeriod:(period){
            periodController.text = "Period ${period.index} ${period.startTime.format(context)} - ${period.endTime.format(context)}";
            setState((){});
            widget.onChangePeriod(period);
          })); },
        icon: Icon(LineIcons.calendar)),
      ),
    );
  }

}
