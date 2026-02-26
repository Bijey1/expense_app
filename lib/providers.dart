import 'package:flutter/material.dart';
import 'models.dart';

class ExpenseLogic with ChangeNotifier {
  List<Expense> _expense = [];
  List<Category> _category = [];
  List<Tag> _tag = [];
  Expense? _editExpense;
  bool _editMode = false;

  List<Expense> get expense => _expense;
  List<Category> get category => _category;
  List<Tag> get tag => _tag;
  Expense? get editExpense => _editExpense;
  bool get editMode => _editMode;
  //Getter so that the main _expense will not be modified and is safe

  void addExpense(
    String payee,
    double amount,
    String? notes,
    Category cat,
    Tag tag,
  ) {
    if (!editMode) {
      _expense.add(Expense.finalExpense(payee, amount, notes, cat, tag));
      notifyListeners();
    }

    print(_expense);
  }

  void removeExpense(final expId) {
    _expense.removeWhere((indExp) => indExp.id == expId);
    notifyListeners();
    //Map every List
    //
    //until I find the same id that the user wants to delete
  }

  void addToEditExpense(Expense expense) {
    _editMode = true;
    _editExpense = expense; //add to a temporary Expense List
    notifyListeners();
  }

  void replaceExpense(
    String id,
    String payees,
    double amount,
    String? notes,
    Category cat,
    Tag tag,
  ) {
    // final dateNow = DateTime.now();
    final indexToReplace = _expense.indexWhere(
      (object) => object.id == id,
    ); //find the same id of i want to replace
    _expense[indexToReplace] = Expense.finalExpense(
      payees,
      amount,
      notes,
      cat,
      tag,
    );
    _editMode = false;
    _editExpense = null;
    notifyListeners();
    //replaces it
  }

  void clearEditMode() {
    _editMode = false;
    _editExpense = null;
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
