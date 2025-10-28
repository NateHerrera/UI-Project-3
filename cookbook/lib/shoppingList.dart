import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
    const ShoppingListPage({super.key});

    @override
    State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
    final List<dynamic> _items = [];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Shopping Cart')),
            body: Center(
                child: 
                    Text('Your cart is empty'),
                ),
        );
    }
}
