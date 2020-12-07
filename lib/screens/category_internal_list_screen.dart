import 'package:flutter/material.dart';
import 'package:pubgm_info/screens/category_info.dart';

class CategoryInternal extends StatelessWidget {
  static const routeName = "/category-internal";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as List;
    final category = args[0];
    final passCategory = args[1];
    final categoryName = args[2];
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
                Navigator.of(context).pushNamed(CategoryInfo.routeName,
                    arguments: [
                      passCategory,
                      category[index]["wname"],
                      categoryName
                    ]);
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
                      child: Image.network(
                        category[index]["wimage"],
                        width: 230,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        category[index]["wname"],
                        style: TextStyle(fontSize: 14),
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
