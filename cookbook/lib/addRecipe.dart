import 'package:flutter/material.dart';

class AddRecipePage extends StatefulWidget {
    const AddRecipePage({super.key});

    @override
    State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text("Add Recipe"),),
            body: Center(
                child: 
                    Text('Add Recipe'),
                ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {},
                tooltip: 'Add Recipe',
                child: const Icon(Icons.add_shopping_cart),
            ),
        );
    }
}