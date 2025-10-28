import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CookbookLayout(),
    );
  }
}

class CookbookLayout extends StatelessWidget {
  const CookbookLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // left side
          Container(
            width: 220,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: cookBookButton,
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(),
                    padding: const EdgeInsets.all(25),
                  ),
                  icon: const Icon(Icons.menu_book, color: Colors.black),
                  label: const Text(
                    'Cook Book',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: addRecipe,
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(),
                    padding: const EdgeInsets.all(25),
                  ),
                  icon: const Icon(Icons.add_box, color: Colors.black),
                  label: const Text(
                    'Add Recipes',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: shoppingList,
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(),
                    padding: const EdgeInsets.all(25),
                  ),
                  icon: const Icon(Icons.shopping_cart, color: Colors.black),
                  label: const Text(
                    'Shopping List',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ]
            )
          ),
          Expanded(
            // right side
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void cookBookButton() {
  print("Cook Book");
}

void addRecipe() {
  print("Add Recipe");
}

void shoppingList() {
  print("Shopping List");
}