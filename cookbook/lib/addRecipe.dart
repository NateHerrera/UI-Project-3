import 'package:cookbook/main.dart';
import 'package:flutter/material.dart';

class AddRecipePage extends StatefulWidget {
    const AddRecipePage({super.key});

    @override
    State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _ingredientsController = TextEditingController();
    final TextEditingController _instructionsController = TextEditingController();
    final List<String> _ingredients = [];

    void _addIngredient() {
        final text = _ingredientsController.text.trim();
        if (text.isEmpty) {
            return;
        }
        setState(() {
            _ingredients.add(text);
            _ingredientsController.clear();
        });
    }

    void _removeIngredientAt(int index) {
        setState(() {
            _ingredients.removeAt(index);
        });
    }

    void _addRecipe(BuildContext context) {
        final String nameText = _nameController.text.trim();
        final String instructionsText = _instructionsController.text.trim();

        if ((nameText.isEmpty) || (_ingredients.isEmpty) || (instructionsText.isEmpty) ) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recipe is not Complete')));
            return;
        }

        Recipe newRecipe = Recipe(
            name: nameText,
            ingredients: _ingredients.toList(),
            instructions: instructionsText);
        
        setState(() {
            recipes.add(newRecipe);
            _nameController.clear();
            _ingredientsController.clear();
            _ingredients.clear();
            _instructionsController.clear();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recipe Successfully Added')));
        });
    }

    @override
    void dispose() {
        _nameController.dispose();
        _ingredientsController.dispose();
        _instructionsController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Add Recipe')),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(25, 12, 25, 20),
                child: Column(
                    children: [
                        Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 12),
                                itemCount: 4 + _ingredients.length,
                                itemBuilder: (context, index) {
                                    final int len = _ingredients.length;

                                    if (index == 0) {
                                        return recipeNameSection();
                                    }

                                    if (index == 1) {
                                        return recipeIngredientSection();
                                    }

                                    if (index >= 2 && index < 2 + len) {
                                        final ing = _ingredients[index - 2];
                                        return recipeIngredientsDeleteSection(ing, index);
                                    }

                                    if (index == 2 + len) {
                                        return recipeInstructionsSection();
                                    }

                                    return addRecipeSection(context);
                                },
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    Container recipeNameSection() {
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Recipe Name',
                    hintText: 'Enter a new recipe name',
                ),
            ),
        );
    }

    Container recipeIngredientSection() {
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
                children: [
                    Expanded(
                        child: TextField(
                            controller: _ingredientsController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Ingredient',
                                hintText: 'e.g. 1 cup flour',
                            ),
                            onSubmitted: (_) => _addIngredient(),
                        ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: _addIngredient,
                        child: const Icon(Icons.add),
                    ),
                ],
            ),
        );
    }

    ListTile recipeIngredientsDeleteSection(String ing, int index) {
        return ListTile(
            title: Text(ing),
            trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _removeIngredientAt(index - 2),
            ),
        );
    }

    Container recipeInstructionsSection() {
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: TextField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Instructions',
                    hintText: 'Enter step-by-step instructions',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 8,
            ),
        );
    }

    Padding addRecipeSection(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ElevatedButton(
                onPressed: () => _addRecipe(context),
                child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
                    child: Text('Add New Recipe', style: TextStyle(fontSize: 16)),
                ),
            ),
        );
    }
}