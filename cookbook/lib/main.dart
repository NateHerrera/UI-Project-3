import 'package:cookbook/addRecipe.dart';
import 'package:cookbook/cookbook.dart';
import 'package:cookbook/shoppingList.dart';
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
            title: 'Cookbook',
            home: CookbookScaffold(),
        );
    }
}

class CookbookScaffold extends StatefulWidget {
    const CookbookScaffold({super.key});

    @override
    State<CookbookScaffold> createState() => _CookbookScaffold();
}

class PageWidget {
    final int index;
    final Widget page;
    final String navText;
    final IconData navIcon;

    PageWidget({required this.index, required this.page, required this.navText, required this.navIcon}); 
}

class _CookbookScaffold extends State<CookbookScaffold> {
    int _index = 0;

    List<PageWidget> pages = [
        PageWidget(index: 0, page: CookbookPage(), navText: "Cook Book", navIcon: Icons.menu_book),
        PageWidget(index: 1, page: AddRecipePage(), navText: "Add Recipe", navIcon: Icons.add_box),
        PageWidget(index: 2, page: ShoppingListPage(), navText: "Shopping List", navIcon: Icons.shopping_cart),
    ];

    void select(int i) {
        setState(() {
          _index = i;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Row(
                children: [
                    // Left Side
                    sideNavigationBar(),
                    // Right Side
                    mainBody(),
                ],
            ),
        );
    }

    Expanded mainBody() {
        return Expanded(
            child: IndexedStack(index: _index, children: pages.map((p) => p.page).toList())
        );
    }

  Container sideNavigationBar() {
    return Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              navigationButton(pages[0]),
              navigationButton(pages[1]),
              navigationButton(pages[2]),
            ]
          )
        );
  }

    OutlinedButton navigationButton(PageWidget page) {
        return OutlinedButton.icon(
            onPressed:() {
                select(page.index);
            },
            style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                shape: RoundedRectangleBorder(),
                padding: const EdgeInsets.all(25),
            ),
            icon: Icon(page.navIcon, color: Colors.black),
            label: Text(
                page.navText,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
        );
    }
}