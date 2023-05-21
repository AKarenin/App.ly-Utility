import 'package:flutter/material.dart';
import 'package:schoolappfinal/constants/MyColors.dart';
import 'package:schoolappfinal/constants/MyFonts.dart';

class CravePage2 extends StatefulWidget {
  _CravePage2State createState() => _CravePage2State();
}

class _CravePage2State extends State<CravePage2> {
  List<Map<String, dynamic>> categories = [
    {'title': 'International', 'icon': Icons.language},
    {'title': 'Korean', 'icon': Icons.food_bank},
    {'title': 'Salad Burger', 'icon': Icons.local_dining},
    {'title': 'Grill', 'icon': Icons.local_fire_department},
    {'title': 'Grab \'n Go', 'icon': Icons.fastfood},
    {'title': 'Beverages', 'icon': Icons.local_drink},
  ];

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:
              const Text('Crave SFS', style: MyFonts.headline),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: MyFonts.bodyText1,
            tabs: [
              Tab(text: 'Crave Cafe'),
              Tab(text: 'Cafeteria'),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/modern_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            children: [
              const Center(
                  child: Text('Cafe Menu',
                      style: MyFonts.headline)),
              GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CategoryItem(
                    title: categories[index]['title'],
                    icon: categories[index]['icon'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  CategoryItem({
    required this.title,
    required this.icon,
  });

  void _selectCategory(BuildContext context) {
// Navigate to the selected category page
  }

  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectCategory(context),
        borderRadius: BorderRadius.circular(20),
        splashColor: MyColors.accentColor.withOpacity(0.4),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.primaryColor.withOpacity(0.8),
                MyColors.primaryColor.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: title,
                child:
                    Icon(icon, size: 48, color: MyColors.accentColor),
              ),
              const SizedBox(height: 10),
              Text(title, style: MyFonts.headline),
            ],
          ),
        ),
      ),
    );
  }
}
