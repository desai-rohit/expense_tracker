import 'dart:convert';

ExpenseModel expenseModelFromMap(String str) => ExpenseModel.fromMap(json.decode(str));

String expenseModelToMap(ExpenseModel data) => json.encode(data.toMap());

class ExpenseModel {
    int? id;
    int expense;
    String expenseCategory;
    String date;
    String note;

    ExpenseModel({
         this.id,
        required this.expense,
        required this.expenseCategory,
        required this.date,
        required this.note,
    });

    factory ExpenseModel.fromMap(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"],
        expense: json["expense"],
        expenseCategory: json["expense_category"],
        date: json["date"],
        note: json["note"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "expense": expense,
        "expense_category": expenseCategory,
        "date": date,
        "note": note,
    };
}
