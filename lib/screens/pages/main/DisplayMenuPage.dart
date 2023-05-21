import 'package:flutter/material.dart';
import 'package:schoolappfinal/dbs/FoodTypeRepository.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';

import '../../../model/Food.dart';
import '../../../model/FoodType.dart';
import 'CravePage.dart';

class DisplayMenuPage extends StatefulWidget {
  FoodType foodType;

  DisplayMenuPage(this.foodType);

  @override
  State<DisplayMenuPage> createState() => _DisplayMenuPageState();
}

class _DisplayMenuPageState extends State<DisplayMenuPage> {
  final foodNameController = TextEditingController();

  final costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            "${widget.foodType.type}",
            style: TextStyle(
              color: Color(0xFF002F6D),
              fontSize: 50,
              fontWeight: FontWeight.w500,
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${widget.foodType.foodList.where((e) => e.isAvailable).length} of ${widget.foodType.foodList.length} available"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 1,
                    height: 1,
                  ),
                ),
                for (Food food in widget.foodType.foodList) ...[
                  if (food.isAvailable) ...[
                    InkWell(
                      onTap: () {
                        toggleAvailable(food);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${food.name}"),
                          Text("${food.cost}"),
                        ],
                      ),
                    )
                  ] else ...[
                    InkWell(
                      onTap: () {
                        toggleAvailable(food);

                      },
                      child: Text(
                        "${food.name}",
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    )
                  ],
                ],
                if (FirebaseAuthUtil.isAdmin(context)) ...[
                  Column(
                    children: [
                      TextField(
                        controller: foodNameController,
                      ),
                      TextField(
                        controller: costController,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            widget.foodType.foodList.add(Food(
                                foodNameController.text,
                                true,
                                int.tryParse(costController.text)!));
                            FoodTypeRepository.update(widget.foodType);
                            setState(() {});
                          },
                          child: Text("Add")),
                    ],
                  )
                ],
              ],
            ),
          )
        ],
      ),
    );
  }

  void toggleAvailable(Food food) {

    if (FirebaseAuthUtil.isAdmin(context)) {
      food.isAvailable = !food.isAvailable;
      FoodTypeRepository.update(widget.foodType);
      setState(() {

      });
    }
  }
}
