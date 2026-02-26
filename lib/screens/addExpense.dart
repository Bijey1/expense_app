import 'package:expense_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import '../models.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController payeeController = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController notes = TextEditingController();

  Tag? tagSelected;
  Category? categorySelected;

  @override
  void initState() {
    super.initState();
    final providerObject = context.read<ExpenseLogic>();
    categorySelected = providerObject.category.isNotEmpty
        ? providerObject.category[0]
        : null;
    tagSelected = providerObject.tag.isNotEmpty ? providerObject.tag[0] : null;

    if (providerObject.editMode) {
      categorySelected = providerObject.editExpense!.category;
      tagSelected = providerObject.editExpense!.tag;
      amount.text = (providerObject.editExpense!.amount).toString();
      payeeController.text = providerObject.editExpense!.payee;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerObject = context.read<ExpenseLogic>();
    final _formKeys = GlobalKey<FormState>();

    final primaryC = Theme.of(context).colorScheme.primary;
    final onPrimaryC = Theme.of(context).colorScheme.onPrimary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            providerObject.clearEditMode();
          },
          icon: Icon(Icons.arrow_back),
        ),

        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          !providerObject.editMode ? "Add Expense" : "Edit Expense",
          style: TextStyle(color: onPrimaryC),
        ),
        backgroundColor: primaryC,
      ),

      body: SingleChildScrollView(
        //use this to make the widgets scrollable
        //And to also fix the bottom overflowed error when keyboard pops out
        child: Form(
          key: _formKeys,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 40),
            child: Column(
              spacing: 30,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Error";
                    }
                  },

                  controller: payeeController,
                  decoration: InputDecoration(
                    labelText: "Enter Payee Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid),
                    ),
                  ),
                ),

                TextFormField(
                  controller: notes,

                  decoration: InputDecoration(
                    hintText: "(Optional)",

                    labelText: "Enter Note",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid),
                    ),
                  ),
                ),

                TextFormField(
                  controller: amount,

                  keyboardType: TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return "Error";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Enter Amount",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid),
                    ),
                  ),
                ),

                //Category
                DropdownButtonFormField(
                  initialValue: categorySelected,
                  decoration: InputDecoration(
                    labelText: "Select Category",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Error";
                    }
                    print(value.name);
                  },
                  items: providerObject.category.map((object) {
                    return DropdownMenuItem(
                      value: object,
                      child: Text(object.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categorySelected = value!;
                    });
                    //When you choose a different item, UI refreshes
                  },
                ),

                DropdownButtonFormField(
                  initialValue: tagSelected,
                  validator: (value) {
                    if (value == null) {
                      return "Error";
                    }
                    //print(value.name);
                  },
                  decoration: InputDecoration(
                    labelText: "Select a Tag",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid),
                    ),
                  ),

                  items: providerObject.tag.map((object) {
                    return DropdownMenuItem(
                      value: object,
                      child: Text(object.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    //print("Tag is ${value?.name}");
                    setState(() {
                      tagSelected = value;
                    });
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    //Validated
                    if (_formKeys.currentState!.validate()) {
                      if (!providerObject.editMode) {
                        //normal adding
                        context.read<ExpenseLogic>().addExpense(
                          payeeController.text,
                          double.parse(amount.text),
                          notes.text,
                          categorySelected!,
                          tagSelected!,
                        );
                      } else {
                        context.read<ExpenseLogic>().replaceExpense(
                          providerObject.editExpense!.id,
                          payeeController.text,
                          double.parse(amount.text),
                          notes.text,
                          categorySelected!,
                          tagSelected!,
                        );
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            contentPadding: EdgeInsetsGeometry.all(50),

                            title: Text(
                              !providerObject.editMode
                                  ? "Expense Added!"
                                  : "Expense Editted!",
                            ),
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, "home");
                                },
                                child: Text("Okay"),
                              ),
                            ],
                          );
                        },
                      );
                      print("Success");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryC),
                    foregroundColor: MaterialStateProperty.all(onPrimaryC),
                  ),
                  child: Text(
                    !providerObject.editMode ? "Add Expense" : "Edit Expense",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    payeeController.clear();
    amount.clear();
    notes!.clear();
    super.dispose();
  }
}
