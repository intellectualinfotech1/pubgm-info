import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pubgm_info/screens/item_info.dart';

class CategoryInfo extends StatelessWidget {
  static const routeName = "/category-info";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as List;
    List category = args[0];
    final categoryName = args[1];
    final parentCategory = args[2];
    final newCategory =
        category.where((element) => element["wcategory"] == categoryName);
    if (parentCategory == "Weapons" ||
        parentCategory == "Vehicles" ||
        parentCategory == "Skins") {
      category = newCategory.toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.79,
        child: GridView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ItemInfo.routeName,
                    arguments: [category[index]["name"], category]);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Hero(
                        tag: category[index]["name"],
                        child: Image.network(
                          category[index]["imgurl"],
                          width: 230,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        category[index]["name"],
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              maxCrossAxisExtent: 230,
              childAspectRatio: 0.7),
          itemCount: category.length,
          padding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
