import 'dart:ui';

import 'package:cookbook/main.dart';
import 'package:flutter/material.dart';

int _totalSelectedRecipes = 0;

class ShoppingListPage extends StatefulWidget {
    const ShoppingListPage({super.key});

    @override
    State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {

    Map<String,int> aggregateIngredients(List<Recipe> recipes) {
        final Map<String,int> counts = {};
        for (final r in recipes) {
            for (final raw in r.ingredients) {
                final key = _normalizeIngredient(raw);
                counts[key] = (counts[key] ?? 0) + 1;
            }
        }
        return counts;
    }

    String _normalizeIngredient(String s) {
        return s.trim().toLowerCase().replaceAll(RegExp(r'[.,]'), '');
    }

    void _addRecipeToCart(Recipe recipe) {
        final existingIndex = recipes.indexWhere((r) => r.name == recipe.name);
        
        if (existingIndex == -1) {
            return;
        }

        setState(() {
            recipes[existingIndex].quantity += 1;
            _totalSelectedRecipes += 1;
        });
        // Notify other pages
        recipesNotifier.value = List<Recipe>.from(recipes);
    }

    void _removeRecipeFromCart(Recipe recipe) {
        final existingIndex = recipes.indexWhere((r) => r.name == recipe.name);

        if (existingIndex == -1) {
            return;
        }

        setState(() {
            // recipes[existingIndex].quantity = clampDouble(recipes[existingIndex].quantity.toDouble(), 0, double.maxFinite).toInt();
            recipes[existingIndex].quantity -= 1;
            _totalSelectedRecipes -= 1;
        });
        recipesNotifier.value = List<Recipe>.from(recipes);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Shopping Cart')),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(25, 12, 25, 20),
                child: Column(
                    children: [
                        ValueListenableBuilder<List<Recipe>>( 
                            valueListenable: recipesNotifier,
                            builder: (context, recipesValue, _) {
                                if (recipesValue.isEmpty) {
                                    return const Center(child: Text('Your cart is empty. Add more recipes to begin.'));
                                }

                                return Expanded(
                                    child: ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        itemCount: recipesValue.length + 1,
                                        itemBuilder: (context, index) {
                                            final int len = recipesValue.length;

                                            if (index < len) {
                                                final recipe = recipesValue[index];
                                                return savedRecipeSection(recipe);
                                            }

                                            return neededIngredientsSection(recipesValue);
                                        },
                                    ),
                                );
                            },
                        )
                    ],
                )
            ),
        );
    }

    Card savedRecipeSection(Recipe recipe) {
        return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                    children: [
                        Expanded(flex: 2,child: Text(recipe.name, 
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    IconButton(
                                        icon: const Icon(Icons.remove, size: 20),
                                        style: IconButton.styleFrom(
                                            shape: const CircleBorder(),
                                            padding: const EdgeInsets.all(8),
                                        ),
                                        onPressed: () => _removeRecipeFromCart(recipe),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                            "${recipe.quantity}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                    ),
                                    IconButton(
                                        icon: const Icon(Icons.add, size: 20),
                                        style: IconButton.styleFrom(
                                            shape: const CircleBorder(),
                                            padding: const EdgeInsets.all(8),
                                        ),
                                        onPressed: () => _addRecipeToCart(recipe),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    Column neededIngredientsSection(List<Recipe> currentRecipes) {
        final needed = aggregateIngredients(currentRecipes);
        if (needed.isEmpty) {
            return Column();
        }

        final entries = needed.entries.toList();

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(10, 50, 0, 12),
                    child: Text(
                        "Ingredients Needed",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                ),
                Card(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: entries.map((e) {
                                return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Padding(
                                        padding: EdgeInsets.only(top: 6.0),
                                        child: Text('•', style: TextStyle(fontSize: 20)),
                                    ),
                                    title: Text(e.key),
                                    trailing: e.value > 1 ? Text('x${e.value}', style: const TextStyle(fontWeight: FontWeight.bold)) : null,
                                );
                            }).toList(),
                        ),
                    ),
                ),
            ],
        );
    }
}

