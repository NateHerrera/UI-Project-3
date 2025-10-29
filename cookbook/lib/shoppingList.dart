import 'dart:ui';

import 'package:cookbook/main.dart';
import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
    const ShoppingListPage({super.key});

    @override
    State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {

    Map<String,int> aggregateIngredients(List<Recipe> recipes) {
        final Map<String,int> counts = {};
        for (final _recipe in recipes) {

            if (_recipe.quantity <= 0) continue; // only count selected recipes in the cart

            for (final ingredient in _recipe.ingredients) {
                final key = _normalizeIngredientString(ingredient);
                counts[key] = (counts[key] ?? 0) + _recipe.quantity;
            }
        }
        return counts;
    }

    String _normalizeIngredientString(String s) {
        return s.trim().toLowerCase();
    }

    void _addRecipeToCart(Recipe recipe) {
        final existingIndex = recipes.indexWhere((r) => r.name == recipe.name);
        
        if (existingIndex == -1) {
            return;
        }

        setState(() {
            recipes[existingIndex].quantity += 1;
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
            // Clamp quantity
            final current = recipes[existingIndex].quantity;
            if (current > 0) {
                recipes[existingIndex].quantity = current - 1;
            } else {
                recipes[existingIndex].quantity = 0;
            }
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
        final int totalSelected = currentRecipes.fold<int>(0, (sum, r) => sum + r.quantity);
        if (totalSelected <= 0) return Column();

        final needed = aggregateIngredients(currentRecipes);
        if (needed.isEmpty) return Column();

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
                    margin: const EdgeInsets.fromLTRB(10, 0, 100, 15),
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
                                return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                        children: [
                                            const Text('•', style: TextStyle(fontSize: 20)),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: Text(
                                                    e.key,
                                                    style: const TextStyle(fontSize: 16),
                                                ),
                                            ),
                                            if (e.value > 0)
                                                Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context).colorScheme.primaryContainer,
                                                        borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Text(
                                                        'x${e.value}',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                        ),
                                                    ),
                                                ),
                                        ],
                                    ),
                                );
                            }).toList(),
                        ),
                    ),
                ),
            ],
        );
    }
}

