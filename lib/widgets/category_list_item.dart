import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pubgm_info/screens/category_info.dart';
import 'package:pubgm_info/screens/category_internal_list_screen.dart';

class CategoryListTile extends StatelessWidget {
  final List category;
  final String categoryTitle;
  final List wCategory;
  final List oCategory;
  final List vCategory;
  final int index;

  CategoryListTile(this.category, this.categoryTitle, this.wCategory,
      this.oCategory, this.vCategory, this.index);

  String get categoryName {
    switch (categoryTitle) {
      case "weapon":
        return "Weapons";
      case "uc":
        return "UC";
      case "skin":
        return "Skins";
      case "vehical":
        return "Vehicles";
      case "more":
        return "More";
      case "winner":
        return "Winners";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    if ([0, 1, 2].contains(index)) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        if ([3, 4, 5].contains(index)) {
          switch (index) {
            case 3:
              Navigator.of(context).pushNamed(CategoryInternal.routeName,
                  arguments: [wCategory, category, categoryName]);
              break;
            case 4:
              Navigator.of(context).pushNamed(CategoryInternal.routeName,
                  arguments: [oCategory, category, categoryName]);
              break;
            case 5:
              Navigator.of(context).pushNamed(CategoryInternal.routeName,
                  arguments: [vCategory, category, categoryName]);
              break;
          }
        } else {
          Navigator.of(context).pushNamed(CategoryInfo.routeName,
              arguments: [category, categoryName, null]);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            child: Text(
              categoryName,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.cyan[300],
                  Colors.lightBlue[800],
                ])),
          ),
        ),
      ),
    );
  }
}
