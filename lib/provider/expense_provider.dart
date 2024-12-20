import 'package:expense_tracker/db/db_helper.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/static/expenseList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpanseProvider extends ChangeNotifier {
  ExpanseProvider() {
    dbref = DbHelper.getInstance;
    getTodayExpanse();
    getBudget();
    totalExpanse();
  }

//
  bool todayMonthAllCheck = false;
  String TMA = "";

// text controller
  TextEditingController datePickerController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController addBudgetController = TextEditingController();

  DbHelper? dbref;

//expense list
  List<ExpenseModel> _expanse = [];
  List<ExpenseModel> get expanse => _expanse;
  //
  List allExpanse = [];

// date picker
  Future<void> selectDate(context) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
         final dateFormatTrimmed = DateFormat('yyyy-M-d').format(date!);

datePickerController.text = dateFormatTrimmed.toString();
   // datePickerController.text = date.toString().split(" ")[0];
      notifyListeners();
  }

  //dropdownmenu
  String dropdownValue = list.first;

  void dropDownMenuList(value) {
    dropdownValue = value;
    notifyListeners();
  }

//add expense
  void addExpanse(context) async {
    var mExpense = expenseController.text;
    var mDate = datePickerController.text;
    var mNote = noteController.text;
    if (mExpense.isNotEmpty && mDate.isNotEmpty && mNote.isNotEmpty) {
      await dbref!.addExpanse(ExpenseModel(
          expense: int.parse(mExpense),
          expenseCategory: dropdownValue,
          date: mDate,
          note: mNote));
      getTodayExpanse();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction added successfully")));
          expenseController.clear();
          datePickerController.clear();
          noteController.clear();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")));
    }
  }

//get all expense
  void getAllExpanse() async {
    TMA = "All Expanse";
    todayMonthAllCheck = false;
    _expanse = await dbref!.getAllExpanse();
    totalExpanse();
    notifyListeners();
  }

//get today expense
  void getTodayExpanse() async {
    TMA = "Toady Expanse";
    todayMonthAllCheck = false;
    _expanse = await dbref!.getTodayExpanse();
    totalExpanse();
    notifyListeners();
  }

//add budget
  void addBudget(context) async {
    if (addBudgetController.text.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt(
          "budget", int.parse(addBudgetController.text.replaceAll(",", "")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please Enter Budget")));
    }
  }

//budget & totalexpense
  int? budget = 0;
  int total = 0;
  // get budget
  void getBudget() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('budget') == null) {
      budget = 0;
    } else {
      budget = prefs.getInt('budget');
    }
    notifyListeners();
  }

// get month expense
  void getMonthExpanse() async {
    TMA = "This Month Expanse";
    todayMonthAllCheck = true;
    _expanse = await dbref!.getMonthExpanse();
    totalExpanse();
    notifyListeners();
  }

//get total expanse
  void totalExpanse() {
    List todayTotalList = [];
    for (var i = 0; i < expanse.length; i++) {
      todayTotalList.add(expanse[i].expense);
    }
    if (todayTotalList.isNotEmpty) {
      total = todayTotalList.reduce((value, element) => value + element);
    } else {
      total = 0;
    }
    notifyListeners();
    
  }
}
