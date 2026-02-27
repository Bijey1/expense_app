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

  Map<String, dynamic> toJson() {
    //Turns an objct into a json Format
    return {
      "id": id,
      "payee": payee,
      "amount": amount,
      "notes": notes,
      "date": date,
      "category": category.id, //category ID only stored
      "tag": tag.id, //Tag ID only stored
    };
  }

  factory Expense.fromJson(Map<String, dynamic> jsonFormat) {
    //Turns an object to JSON format back into an OBJECT
    return Expense._Expense(
      id: jsonFormat['id'],
      payee: jsonFormat['payee'],
      amount: jsonFormat['amount'],
      notes: jsonFormat['notes'],
      date: jsonFormat['date'],
      category: jsonFormat['category'],
      tag: jsonFormat['tag'],
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

  factory Category.finalCategory(String categoryName) {
    String date = DateTime.now().toString();
    return Category._Category(name: categoryName, id: categoryName + date);
  }

  Map<String, dynamic> toJson() {
    //Turns a Category object into a JSON format
    return {'name': name, 'id': id};
  }

  factory Category.fromJson(Map<String, dynamic> jsonForm) {
    //Turns a JSON format back into a Category OBJECT
    return Category._Category(name: jsonForm["name"], id: jsonForm['id']);
  }

  Category._Category({required this.name, required this.id});
}

class Tag {
  String name;
  final id; //Date now plus Tag name

  factory Tag.finalTag(String tagName) {
    String date = DateTime.now().toString();
    return Tag._Tag(name: tagName, id: tagName + date);
  }

  Map<String, dynamic> toJson() {
    //Turns a Category object into a JSON format
    return {'name': name, 'id': id};
  }

  factory Tag.fromJson(Map<String, dynamic> jsonForm) {
    //Turns a JSON format back into a Category OBJECT
    return Tag._Tag(name: jsonForm["name"], id: jsonForm['id']);
  }

  Tag._Tag({required this.name, required this.id});
}
