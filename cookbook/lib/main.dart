import 'package:cookbook/addRecipe.dart';
import 'package:cookbook/cookbook.dart';
import 'package:cookbook/shoppingList.dart';
import 'package:flutter/material.dart';

IconData dayThemeIcon = Icons.light_mode_sharp;
IconData nightThemeIcon = Icons.dark_mode_sharp;

Color offBlack = Color.fromARGB(255, 34, 34, 59);
Color offWhite =  Color.fromARGB(255, 242, 233, 228);

class PageWidget {
    final int index;
    final Widget page;
    final String navText;
    final IconData navIcon;

    PageWidget({required this.index, required this.page, required this.navText, required this.navIcon}); 
}

class Recipe {
    final String name;
    final List<String> instructions;
    final List<String> ingredients;

    Recipe({required this.name, required this.instructions, required this.ingredients});
}

void main() {
    runApp(const MainApp());
}

class MainApp extends StatefulWidget {
    const MainApp({super.key});

    @override
    State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
    // Theme toggling is handled at the MainApp level
    // Theme toggle button rebuilds main app state.
    ThemeMode _themeMode = ThemeMode.light;
    IconData _themeIcon = dayThemeIcon;

    void toggleTheme() {
        setState(() {
            if (_themeMode == ThemeMode.light) {
                _themeMode = ThemeMode.dark;
                _themeIcon = nightThemeIcon;
            } else {
                _themeMode = ThemeMode.light;
                _themeIcon = dayThemeIcon;
            }
        });
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cookbook',
            theme: ThemeData(colorSchemeSeed: offWhite),
            darkTheme: ThemeData(brightness: Brightness.dark, colorSchemeSeed: offBlack),
            themeMode: _themeMode,
            home: CookbookScaffold(toggleTheme: toggleTheme, themeIcon: _themeIcon),
        );
    }
}

class CookbookScaffold extends StatefulWidget {
    final VoidCallback toggleTheme;
    final IconData themeIcon;

    const CookbookScaffold({super.key, required this.toggleTheme, required this.themeIcon});

    @override
    State<CookbookScaffold> createState() => _CookbookScaffoldState();
}

class _CookbookScaffoldState extends State<CookbookScaffold> {   
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
            floatingActionButton: SizedBox(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                    onPressed: widget.toggleTheme,
                    tooltip: "Toggle Theme Mode",
                    child: Icon(widget.themeIcon),
                ),
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
          ),
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