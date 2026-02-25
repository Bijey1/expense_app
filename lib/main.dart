import 'package:expense_app/screens/addExpense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers.dart';
import 'screens/homeScreen.dart';
import 'screens/addExpense.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => ExpenseLogic(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "home",
      routes: {
        "home": (context) => HomeScreen(),
        "addExpense": (context) => AddExpense(),
      },

      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.greenAccent),
      home: HomeScreen(),
    );
  }
}
