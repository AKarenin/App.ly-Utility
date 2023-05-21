import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolappfinal/constants/MyColors.dart';
import 'package:schoolappfinal/dbs/FoodTypeRepository.dart';
import 'package:schoolappfinal/screens/pages/main/DisplayMenuPage.dart';
import 'package:schoolappfinal/screens/widgets/ChooseDatePicker.dart';
import 'package:schoolappfinal/util/DateTimeUtil.dart';
import 'package:schoolappfinal/util/PageUtil.dart';

import '../../../model/Food.dart';
import '../../../model/FoodType.dart';

class CravePage extends StatefulWidget {

  CravePage({Key? key}) : super(key: key) ;

  @override
  State<CravePage> createState() => _CravePageState();
}

class _CravePageState extends State<CravePage> {
  late DateTime selectedDateTime;

  List<FoodType> searchedFoodTypeList = [];

  PlaceType selectedPlaceType= PlaceType.CAFE;

  @override
  void initState() {
    super.initState();
    selectDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Crave",
              style: TextStyle(
                color: Color(0xFF002F6D),
                fontSize: 50,
                fontWeight: FontWeight.w500,
              ),
            ),
            ChooseDatePicker(
              initialDate: selectedDateTime,
              onChangeDateTime: (DateTime dateTime) {
                selectDateTime(dateTime: dateTime);
              },
            ),
            TabBar(
              onTap: (index){
                if(index==0) {
                  selectedPlaceType = PlaceType.CAFE;
                }
                else {
                  selectedPlaceType = PlaceType.CAFETERIA;
                }
                selectDateTime(dateTime: selectedDateTime);
              },
              tabs: [
                Tab(
                    child: Text("CAFE",
                        style: TextStyle(color: Color(0xFF002F6D)))),
                Tab(
                    child: Text("CAFETERIA",
                        style: TextStyle(color: Color(0xFF002F6D)))),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: searchedFoodTypeList.length,
                            itemBuilder: (c, i) {
                              FoodType foodType = searchedFoodTypeList[i];
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        MyColors.purpleColor,
                                        MyColors.lightPurpleColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      PageUtil.push(
                                          context, DisplayMenuPage(foodType));
                                    },
                                    leading: Icon(IconData(foodType.icon,
                                        fontFamily: 'MaterialIcons')),
                                    title: Text(
                                      "${foodType.type}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: Icon(Icons.arrow_right_sharp,
                                        color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: searchedFoodTypeList.length,
                            itemBuilder: (c, i) {
                              FoodType foodType = searchedFoodTypeList[i];
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        MyColors.purpleColor,
                                        MyColors.lightPurpleColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      PageUtil.push(
                                          context, DisplayMenuPage(foodType));
                                    },
                                    leading: Icon(IconData(foodType.icon,
                                        fontFamily: 'MaterialIcons')),
                                    title: Text(
                                      "${foodType.type}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: Icon(Icons.arrow_right_sharp,
                                        color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ])),
    );
  }

  void selectDateTime({DateTime? dateTime}) {
    selectedDateTime =
        dateTime ?? DateTimeUtil().getMondayAndFriday(DateTime.now())[0];
    final defaultCafeteriaFoodTypeList = [
      FoodType(PlaceType.CAFETERIA.name, "International", 0xe366, [],
          selectedDateTime),
      FoodType(
        PlaceType.CAFETERIA.name,
        "Korean",
        0xe2aa,
        [],
        selectedDateTime,
      ),
      FoodType(
        PlaceType.CAFETERIA.name,
        "Salad Bar",
        0xe390,
        [],
        selectedDateTime,
      ),
      FoodType(
        PlaceType.CAFETERIA.name,
        "Grill",
        0xe392,
        [],
        selectedDateTime,
      ),
      FoodType(
        PlaceType.CAFETERIA.name,
        "Grab'n Go",
        0xe25a,
        [],
        selectedDateTime,
      ),
      FoodType(
        PlaceType.CAFETERIA.name,
        "Beverages",
        0xe391,
        [],
        selectedDateTime,
      ),
    ];
    final defaultCafeFoodTypeList = [
      FoodType(
        PlaceType.CAFE.name,
        "Snacks",
        0xe112,
        [],
        selectedDateTime,
      ),
      FoodType(
        PlaceType.CAFE.name,
        "Beverages",
        0xe391,
        [],
        selectedDateTime,
      ),
    ];

    (() async {
      searchedFoodTypeList = await FoodTypeRepository.getList(
        FoodTypeRepository.where(
          'availableDate',
          isEqualTo: DateUtils.dateOnly(selectedDateTime).toIso8601String(),
        ).where('place',isEqualTo: selectedPlaceType.name),
      );

      bool exist = searchedFoodTypeList.isNotEmpty;
      if (!exist) {
        searchedFoodTypeList = [];
        if(selectedPlaceType == PlaceType.CAFE) {
          for (FoodType foodType in defaultCafeFoodTypeList) {
            await FoodTypeRepository.create(foodType);
            searchedFoodTypeList.add(foodType);
          }
        }
        else {
          for (FoodType foodType in defaultCafeteriaFoodTypeList) {
            await FoodTypeRepository.create(foodType);
            searchedFoodTypeList.add(foodType);
          }
        }
      }

      searchedFoodTypeList.sort((a,b){
        return a.icon-b.icon;
      });
      forceUpdate();
    })();
  }

  void forceUpdate() {
    try{
      setState((){});
    }
    catch(e){ }
  }
}
