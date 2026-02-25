import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/nonHomeAppBar.dart';
import '../providers.dart';

class TagScreen extends StatelessWidget {
  const TagScreen({super.key});

  @override
  Widget build(BuildContext widgetContext) {
    return Scaffold(
      appBar: NonHomeAppBar(widgetContext, "Tags"),
      body: Consumer<ExpenseLogic>(
        builder: (context, provider, child) {
          print("Rebuilding, tag: ${provider.tag.length}");
          if (provider.tag.isEmpty) {
            return Center(child: Text("No Tag Added"));
          }

          return ListView.builder(
            itemCount: provider.tag.length,
            itemBuilder: (context, index) {
              final tag = provider.tag[index];
              return ListTile(
                title: Text(tag.name),
                trailing: InkWell(
                  onTap: () => context.read<ExpenseLogic>().removeTag(tag.id),

                  child: Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => dialog(widgetContext),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> dialog(BuildContext contexts) {
    final TextEditingController categoryController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: contexts,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              //color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          //backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          title: Text("Add Tag"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: "Enter Tag Name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.solid),
                      ),
                    ),
                    validator: (value) {
                      final tagDuplicate = context.read<ExpenseLogic>().tag;
                      //Accesses the PROVIDER instance without listening to notifyListeners()
                      if (value == null ||
                          value.isEmpty ||
                          tagDuplicate.any((object) => object.name == value)) {
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
                  contexts.read<ExpenseLogic>().addTag(categoryController.text);
                  Navigator.pop(context);
                  //Passed the input Value to the addCategory in the provider class
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
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
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),

              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
