import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../style.dart';
import '../widgets/nonHomeAppBar.dart';
import '../providers.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    styles color = styles(context: context);
    return Scaffold(
      appBar: NonHomeAppBar(context, "Categories"),
      body: Consumer<ExpenseLogic>(
        builder: (context, provider, child) {
          print("Rebuilding, categories: ${provider.category.length}");
          if (provider.category.isEmpty) {
            return Center(child: Text("No Category Added"));
          }

          return ListView.builder(
            itemCount: provider.category.length,
            itemBuilder: (context, index) {
              final category = provider.category[index];
              return ListTile(
                title: Text(category.name),
                trailing: InkWell(
                  onTap: () {
                    if (provider.expense.any(
                      (obj) => obj.category.id == category.id,
                    )) {
                      //If id is already been used in expense

                      dialog(context, type: "simple");
                    } else {
                      context.read<ExpenseLogic>().removeCategory(category.id);
                    }
                  },

                  child: Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => dialog(context, type: "alert"),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> dialog(BuildContext contexts, {required String type}) {
    return showDialog(
      context: contexts,
      builder: (context) {
        if (type == "alert") {
          final TextEditingController categoryController =
              TextEditingController();
          final formKey = GlobalKey<FormState>();
          return AlertDialog(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                //color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadiusGeometry.circular(20),
            ),
            //backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            title: Text("Add Category"),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        labelText: "Enter Category Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.solid),
                        ),
                      ),
                      validator: (value) {
                        final duplicate = context.read<ExpenseLogic>();
                        //Accesses the PROVIDER instance without listening to notifyListeners()
                        if (value == null ||
                            value.isEmpty ||
                            duplicate.category.any(
                              (object) => object.name == value,
                            )) {
                          return "Error";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            actions: [
              OutlinedButton(
                onPressed: () {
                  //if yes
                  if (formKey.currentState!.validate()) {
                    contexts.read<ExpenseLogic>().addCategory(
                      categoryController.text,
                    );
                    Navigator.pop(context);
                    //Passed the input Value to the addCategory in the provider class
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),

                child: Text("Add", style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton(
                onPressed: () {
                  //if no
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),

                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        } else if (type == "simple") {
          return AlertDialog(
            constraints: BoxConstraints(maxHeight: 250, maxWidth: 250),
            title: Text("Error!"),
            content: Center(
              child: Text(
                "Category is Already Being Used. Change the Category of your Expense First Before Deleting",
                style: TextStyle(letterSpacing: 2),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Okay"),
              ),
            ],
          );
        } else {
          return SimpleDialog();
        }
      },
    );
  }
}
