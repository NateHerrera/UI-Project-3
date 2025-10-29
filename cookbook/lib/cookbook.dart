import 'package:cookbook/main.dart';
import 'package:flutter/material.dart';

class CookbookPage extends StatefulWidget {
    const CookbookPage({super.key});

    @override
    State<CookbookPage> createState() => _CookbookPageState();
}

class _CookbookPageState extends State<CookbookPage> {

    // TODO
    @override
    void initState() {
        print("object");
        super.initState();
        _logRecipes();
    }

    void _logRecipes() {
        if (recipes.isNotEmpty) {
            for (Recipe recipe in recipes) {
                print("Recipe Name: ${recipe.name}");
                print("Ingredients: \n${recipe.ingredients}");
                print("Instructions: ${recipe.instructions}");
                print("\n");
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text("Cookbook"),),
            body: Center(
                child: 
                    Text('Cookbook is empty'),
                ),
        );
    }
}