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

  Card recipeListItem(Recipe recipe, int index, BuildContext context) {
    final int ingredientCount = recipe.ingredients.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12), 
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          recipe.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "$ingredientCount ingredients",
          style: const TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => _deleteRecipeAt(index),
        ),
        onTap: () => _viewRecipe(context, recipe),
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
