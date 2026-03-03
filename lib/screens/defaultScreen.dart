import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import 'addExpense.dart';
import '../main.dart';
import 'tagScreen.dart';
import 'categoryScreen.dart';
import '../style.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    styles color = styles(context: context);
    return Consumer<ExpenseLogic>(
      builder: (context, provider, child) {
        final expenseData = provider.expense;
        if (expenseData.isEmpty) {
          return Center(child: Text("No Expense Added"));
        }

        return ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(10),
          itemCount: expenseData.length,
          itemBuilder: (context, index) {
            final expenseDataIndiv = expenseData[index];

            return Padding(
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
                    title: Text(expenseDataIndiv.payee),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category: ${(expenseDataIndiv.category.name)}"),

                        Text(
                          "Amount to Pay: \$${(expenseDataIndiv.amount).toString()}",
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            provider.addToEditExpense(expenseDataIndiv);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddExpense(),
                              ),
                            ); //edit tab
                          },

                          child: Icon(
                            Icons.edit,
                            color: const Color.fromARGB(255, 233, 233, 9),
                          ),
                        ),
                        SizedBox(width: 9),

                        InkWell(
                          onTap: () {
                            provider.removeExpense(expenseDataIndiv.id);
                          },

                          child: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
