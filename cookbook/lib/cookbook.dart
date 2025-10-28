import 'package:flutter/material.dart';

class CookbookPage extends StatefulWidget {
    const CookbookPage({super.key});

    @override
    State<CookbookPage> createState() => _CookbookPageState();
}

class _CookbookPageState extends State<CookbookPage> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text("Cookbook"),),
            body: Center(
                child: 
                    Text('Cookbook is empty'),
                ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {},
                tooltip: 'Add item',
                child: const Icon(Icons.add_shopping_cart),
            ),
        );
    }
}