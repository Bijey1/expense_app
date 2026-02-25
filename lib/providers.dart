import 'package:flutter/material.dart';
import 'models.dart';

class ExpenseLogic with ChangeNotifier {
  List<Expense> _expense = [];
  List<Category> _category = [];
  List<Tag> _tag = [];

  List<Expense> get expense => _expense;
  List<Category> get category => _category;
  List<Tag> get tag => _tag;
  //Getter so that the main _expense will not be modified and is safe

  void addExpense(
    String payee,
    double amount,
    String? notes,
    Category cat,
    Tag tag,
  ) {
    _expense.add(Expense.finalExpense(payee, amount, notes, cat, tag));
    notifyListeners();

    print(_expense);
  }

  void removeExpense(final expId) {
    if (_expense.isNotEmpty) {
      _expense.removeWhere((indExp) => indExp.id == expId);
      notifyListeners();
      //Map every List until I find the same id that the user wants to delete
    }
  }

  void addCategory(String name) {
    _category.add(
      Category.finalTag(name), //returns a category object with name and id
    );
    notifyListeners();
  }

  void removeCategory(final inputId) {
    _category.removeWhere((object) => object.id == inputId);
    notifyListeners();
  }

  void addTag(String name) {
    _tag.add(Tag.finalTag(name));
    notifyListeners();
  }

  void removeTag(final tagId) {
    _tag.removeWhere((object) => object.id == tagId);
    notifyListeners();
  }
}
