import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import 'addExpense.dart';
import '../main.dart';
import 'tagScreen.dart';
import 'categoryScreen.dart';
import '../style.dart';

class CategorySort extends StatelessWidget {
  const CategorySort({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ExpenseLogic>().sortExpense();
    styles color = styles(context: context);
    int indexAdd = 1;

    return Consumer<ExpenseLogic>(
      builder: (context, provider, child) {
        final expenseData = provider.sortedExpense.entries.toList();
        if (expenseData.isEmpty) {
          return Center(child: Text("No hihihii Added"));
        }

        return ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(10),
          itemCount: expenseData.length,
          itemBuilder: (context, index) {
            String sortedKey = expenseData[index].key;
            final sortedValue = expenseData[index].value;

            //Check if a category is used at least once by an Expense

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Text(
                    sortedKey,
                    style: TextStyle(
                      color: color.primaryC,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...sortedValue //Its like a mini loop that checks all avaliable items in a list
                    .map(
                      (object) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Card(
                          color: Colors.white,
                          elevation: 4,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.primaryC,
                                ),

                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: color.onPrimaryC,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(object.payee),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Category: ${(object.category.name)}"),

                                  Text(
                                    "Amount to Pay: \$${(object.amount).toString()}",
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      provider.addToEditExpense(object);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddExpense(),
                                        ),
                                      ); //edit tab
                                    },

                                    child: Icon(
                                      Icons.edit,
                                      color: const Color.fromARGB(
                                        255,
                                        233,
                                        233,
                                        9,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 9),

                                  InkWell(
                                    onTap: () {
                                      provider.removeExpense(object.id);
                                    },

                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            );
          },
        );
      },
    );
    ;
  }
}
