// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:uber_eats/Features_Layouts/groceries_items_screen.dart';
import 'package:uber_eats/Pages/groceries_1.dart';
import 'package:uber_eats/dash_screen.dart';

class groceries_search_screen extends StatefulWidget {
  const groceries_search_screen({super.key});

  @override
  State<groceries_search_screen> createState() =>
      _groceries_search_screenState();
}

class _groceries_search_screenState extends State<groceries_search_screen> {
  final Map<String, String> categoryData = {
    'fruitsAndVegetables': 'Fresh Fruits and Vegetables',
    'cookingAndOils': 'Edible Oils and Ghee',
    'meatAndFish': 'Meat and Seafood',
    'bakeryAndSnacks': 'Biscuits and Munchies',
    'beverages': 'Cool Drinks and Juices',
  };
  List<String> filteredCategories = [];
  bool issearching = false;

  @override
  Widget build(BuildContext context) {
    List<String> displayCategories = filteredCategories.isEmpty
        ? []
        : filteredCategories;
   

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.indigo,
              elevation: 5,
              collapsedHeight: 120,
              shadowColor: Colors.grey,
              expandedHeight: 120,
              floating: true,
              pinned: true,
              flexibleSpace: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyHomePage()));
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            autofocus: true,
                            onChanged: onSearchTextChanged,
                            decoration: const InputDecoration(
                                hintText: 'Search Categories',
                                prefixIcon:  Icon(Icons.search),
                                border: InputBorder.none
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ];
        },
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemCount: displayCategories.length,
          itemBuilder: (context, index) {
            final categoryKey = displayCategories[index];
            final categoryName = categoryData[categoryKey]!;
            final categoryImage = 'assets/images_groceries/$categoryKey.png';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          groceries_items_screen(category: categoryKey),
                    ),
                  );
                },
                child: CategoryCard(
                  categoryName: categoryName,
                  categoryImage: categoryImage,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void onSearchTextChanged(String text) {
    filteredCategories = categoryData.keys
        .where((category) =>
            categoryData[category]!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    setState(() {});
  }
}
