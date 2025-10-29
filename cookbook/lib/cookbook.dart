import 'package:cookbook/main.dart';
import 'package:flutter/material.dart';

class CookbookPage extends StatefulWidget {
  const CookbookPage({super.key});

  @override
  State<CookbookPage> createState() => _CookbookPageState();
}

class _CookbookPageState extends State<CookbookPage> {

  void _deleteRecipeAt(int index) {
    setState(() {
      recipes.removeAt(index);
      // Notify other pages
      recipesNotifier.value = List<Recipe>.from(recipes);
    });
  }

  void _viewRecipe(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetailPage(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cook Book')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 12, 25, 20),
        child: ValueListenableBuilder<List<Recipe>>(
          valueListenable: recipesNotifier,
          builder: (context, recipesValue, _) {
            if (recipesValue.isEmpty) {
              return const Center(child: Text('Cookbook is empty'));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: recipesValue.length,
              itemBuilder: (context, index) {
                final recipe = recipesValue[index];
                return recipeListItem(recipe, index, context);
              },
            );
          },
        ),
      ),
    );
  }

  Container recipeListItem(Recipe recipe, int index, BuildContext context) {
    final int ingredientCount = recipe.ingredients.length;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _viewRecipe(context, recipe),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        title: Text(
          recipe.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "$ingredientCount ingredients",
          style: const TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deleteRecipeAt(index),
        ),
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 12, 25, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ingredientsSection(),
              const SizedBox(height: 20),
              instructionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Column ingredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ingredients",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        for (String ing in recipe.ingredients)
          Text("• $ing", style: const TextStyle(fontSize: 15)),
      ],
    );
  }

  Column instructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Instructions",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        Text(recipe.instructions, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
