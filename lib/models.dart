class Expense {
  String id; //Date now plus payee name
  String payee;
  double amount;
  String? notes;
  final date;
  Category category;
  Tag tag;

  factory Expense.finalExpense(
    String payee,
    double amount,
    String? notes,
    Category category, //categoryID
    Tag tag, //Tag ID
  ) {
    String date = DateTime.now().toString();
    return Expense._Expense(
      id: payee + date,
      payee: payee,
      amount: amount,
      notes: notes,
      date: date,
      category: category,
      tag: tag,
    );
  }

  Expense._Expense({
    required this.id,
    required this.payee,
    required this.amount,
    this.notes,
    required this.date,
    required this.category,
    required this.tag,
  });
}

class Category {
  String name;
  final id; //Date now plus category name

  factory Category.finalTag(String categoryName) {
    String date = DateTime.now().toString();
    return Category._Category(name: categoryName, id: categoryName + date);
  }

  Category._Category({required this.name, required this.id});
}

class Tag {
  String name;
  String id; //Date now plus Tag name

  factory Tag.finalTag(String tagName) {
    String date = DateTime.now().toString();
    return Tag._Tag(name: tagName, id: tagName + date);
  }

  Tag._Tag({required this.name, required this.id});
}
