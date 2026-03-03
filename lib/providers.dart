import 'dart:convert';

import 'package:flutter/material.dart';
import 'models.dart';

import 'package:localstorage/localstorage.dart';

import 'dart:async';

class ExpenseLogic with ChangeNotifier {
  List<Expense> _expense = [];
  List<Category> _category = [];
  List<Tag> _tag = [];
  Expense? _editExpense;

  Map<String, List<Expense>> _sortedExpense = {};
  bool _editMode = false;

  List<Expense> get expense => _expense;
  List<Category> get category => _category;
  List<Tag> get tag => _tag;
  Expense? get editExpense => _editExpense; //when edit mode
  bool get editMode => _editMode;

  Map<String, List<Expense>> get sortedExpense => _sortedExpense;
  //Getter so that the main _expense will not be modified and is safe

  final LocalStorage localStorage = LocalStorage('expenseApp');

  ExpenseLogic() {
    //Runs on load of the app
    init();
  }

  // LocalStorage Functions
  void init() async {
    await onLoad();
  }

  Future<void> onLoad() async {
    await localStorage.ready;
    await loadCategoryFromLocal();
    await loadTagFromLocal();
    await loadExpenseFromLocal();
    notifyListeners();
  }

  Category findCat(String id) {
    //Finds the same id in the category list
    return _category.firstWhere((obj) => id == obj.id);
  }

  Tag findTag(String id) {
    //Finds the same id in the tag list
    return _tag.firstWhere((obj) => id == obj.id);
  }

  Future<void> loadExpenseFromLocal() async {
    await localStorage.ready;
    final expenseLocal = localStorage.getItem('expense');

    if (expenseLocal != null && expenseLocal.isNotEmpty) {
      List expenseJson = jsonDecode(expenseLocal);

      _expense = expenseJson.map((indivObj) {
        indivObj['category'] = findCat(indivObj['category']);
        indivObj['tag'] = findTag(indivObj['tag']);
        return Expense.fromJson(indivObj);
      }).toList();
    }
  }

  Future<void> loadCategoryFromLocal() async {
    await localStorage.ready;

    //Check first if getItem is null
    final categoryLocal = localStorage.getItem("cats");
    if (categoryLocal != null && categoryLocal.isNotEmpty) {
      List categoryJson = jsonDecode(categoryLocal);
      //Turns the jsonFormat String(List<Map<String,dynamic>>) into a jsonFormat Map<String,dynamic>

      _category =
          categoryJson //Transforms the jsonFormat back into an object
              .map(
                (indivCat) => Category.fromJson(indivCat),
              ) //every element is pass to the .fromJson()
              .toList(); // Turns the Object into a List<Expense>
    }
  }

  Future<void> loadTagFromLocal() async {
    await localStorage.ready;

    final tagLocal = localStorage.getItem("tag");

    if (tagLocal != null && tagLocal.isNotEmpty) {
      List tagJson = jsonDecode(tagLocal);
      //Turns the jsonFormat String(List<Map<String,dynamic>>) into a jsonFormat Map<String,dynamic>

      _tag =
          tagJson //Transforms the jsonFormat back into an object
              .map(
                (indivCat) => Tag.fromJson(indivCat),
              ) //every element is pass to the .fromJson()
              .toList(); // Turns the Object into a List<Expense>
    }
  }

  Future<void> saveCategoryToLocal() async {
    await localStorage.ready;
    //Turns a category object into a JSON String format
    //Json Encode turns the Map<String,dynamic> into a String Json
    String jsonFormat = jsonEncode(
      _category.map((indivObj) => indivObj.toJson()).toList(),
    );
    await localStorage.setItem('cats', jsonFormat);
  }

  Future<void> saveTagToLocal() async {
    await localStorage.ready;
    //Turns a Tag object into a JSON String format
    //Json Encode turns the Map<String,dynamic> into a String Json
    String jsonFormat = jsonEncode(
      _tag.map((indivObj) => indivObj.toJson()).toList(),
    );
    await localStorage.setItem('tag', jsonFormat);
  }

  Future<void> saveExpenseToLocal() async {
    await localStorage.ready;
    //Turns a Expense object into a JSON String format
    //Json Encode turns the Map<String,dynamic> into a String Json
    String jsonFormat = jsonEncode(
      _expense.map((indivObj) => indivObj.toJson()).toList(),
    );
    await localStorage.setItem('expense', jsonFormat);
  }

  void addExpense(
    String payee,
    double amount,
    String? notes,
    Category cat,
    Tag tag,
  ) async {
    _expense.add(Expense.finalExpense(payee, amount, notes, cat, tag));
    notifyListeners();
    await saveExpenseToLocal();

    print(_expense);
  }

  void removeExpense(final expId) async {
    _expense.removeWhere((indExp) => indExp.id == expId);
    notifyListeners();
    //Map every List
    //until I find the same id that the user wants to delete
    await saveExpenseToLocal();
  }

  void addToEditExpense(Expense expense) {
    _editMode = true;
    _editExpense = expense; //add to a temporary Expense List
    notifyListeners();
    //await saveExpenseToLocal();
  }

  void replaceExpense(
    String id,
    String payees,
    double amount,
    String? notes,
    Category cat,
    Tag tag,
  ) async {
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
    await saveExpenseToLocal();
    //replaces it
  }

  void clearEditMode() {
    _editMode = false;
    _editExpense = null;
  }

  //For Categories
  void addCategory(String name) async {
    _category.add(
      Category.finalCategory(name), //returns a category object with name and id
    );

    notifyListeners();
    await saveCategoryToLocal();
  }

  void removeCategory(final inputId) async {
    _category.removeWhere((object) => object.id == inputId);
    notifyListeners();
    await saveCategoryToLocal();
  }

  //For Tags
  void addTag(String name) async {
    _tag.add(Tag.finalTag(name));
    notifyListeners();
    await saveTagToLocal();
  }

  void removeTag(final tagId) async {
    _tag.removeWhere((object) => object.id == tagId);
    notifyListeners();
    await saveTagToLocal();
  }

  //Sort Expense
  void sortExpense() {
    //_sortedExpense
    _sortedExpense.clear();

    for (var singleExpense in _expense) {
      _sortedExpense.putIfAbsent(
        singleExpense.category.name,
        () => <Expense>[],
      );

      _sortedExpense[singleExpense.category.name]!.add(singleExpense);
    }

    print(_sortedExpense);

    notifyListeners();
  }
}
