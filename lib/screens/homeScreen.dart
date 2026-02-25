import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers.dart';
import 'addExpense.dart';
import '../main.dart';
import 'tagScreen.dart';
import 'categoryScreen.dart';
import '../style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    styles color = styles(context: context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color.onPrimaryC),
        centerTitle: true,
        title: Text(
          "Expense Tracking App",
          style: TextStyle(color: color.onPrimaryC),
        ),
        backgroundColor: color.primaryC,
      ),
      drawer: Drawer(
        surfaceTintColor: color.onPrimaryC,
        backgroundColor: color.primaryC,

        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,

                children: [
                  Icon(Icons.settings, size: 80, color: color.onPrimaryC),
                  Text(
                    "Settings",
                    style: TextStyle(
                      color: color.onPrimaryC,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "Expense Tracker App",
                    style: TextStyle(color: color.onPrimaryC, fontSize: 13),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category"),
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryScreen()),
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TagScreen()),
              ),
              leading: Icon(Icons.tag),
              title: Text("Tag"),
              textColor: Colors.white,
              iconColor: Colors.white,
            ),
          ],
        ),
      ),

      body: Consumer<ExpenseLogic>(
        builder: (context, provider, child) {
          final expenseData = provider.expense;
          if (expenseData.isEmpty) {
            return Center(child: Text("No Expense Added"));
          }

          return ListView.builder(
            itemCount: expenseData.length,
            itemBuilder: (context, index) {
              final expenseDataIndiv = expenseData[index];
              return ListTile(
                title: Text(expenseDataIndiv.payee),
                trailing: InkWell(
                  onTap: () {
                    provider.removeExpense(expenseDataIndiv.id);
                  },

                  child: Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Dialog
          dialog(context, "Add Expense?");
        },

        child: Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> dialog(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          title: Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                //if yes
                Navigator.pop(context);
                Navigator.pushNamed(context, "addExpense");
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),

              child: Text("Yes", style: TextStyle(color: Colors.white)),
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

              child: Text("No", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
