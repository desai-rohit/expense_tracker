import 'dart:io';

import 'package:expense_tracker/model/expense_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//table notes
const String TABLE_NAME = "expense";
const String COLUMN_ID = "id";
const String COLUMN_EXPENSE = "expense";
const String COLUMN_EXPENSE_CATEGORY = "expense_category";
const String COLUMN_DATE = "date";
const String COLUMN_NOTE = "note";

class DbHelper {
  //singleton
  DbHelper._();

  static final DbHelper getInstance = DbHelper._();

  Database? myDb;

  Future<Database> getDB() async {
    return myDb ?? await openDb();
  }

  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbpath = join(appDir.path, "noteDB.db");

    return await openDatabase(dbpath, onCreate: (db, version) {
      db.execute(
          "create table $TABLE_NAME ($COLUMN_ID integer primary key autoincrement, $COLUMN_EXPENSE INTEGER,$COLUMN_EXPENSE_CATEGORY text,$COLUMN_DATE text,$COLUMN_NOTE text)");
    }, version: 1);
  }

  //all quries

//insert data
  Future<bool> addExpanse(ExpenseModel noteModel) async {
    var db = await getDB();

    int rowsEffedted = await db.insert(TABLE_NAME, noteModel.toMap());

    return rowsEffedted > 0;
  }

// read data
  Future<List<ExpenseModel>> getAllExpanse() async {
    var db = await getDB();

    List<Map<String, dynamic>> mData = (await db.query(TABLE_NAME));
    return mData.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  //get today expanse
  Future<List<ExpenseModel>> getTodayExpanse() async {
    var date = DateTime.parse(DateTime.now().toString());
    var formattedDate = "${date.year}-${date.month}-${date.day}";

    var db = await getDB();
    List<Map<String, dynamic>> mData = (await db
        .rawQuery('SELECT * FROM $TABLE_NAME WHERE date = ?', [formattedDate]));
    return mData.map((e) => ExpenseModel.fromMap(e)).toList();
  }

//get month expanse
  Future<List<ExpenseModel>> getMonthExpanse() async {
    final String currentMonth =
        DateTime.now().toIso8601String().substring(0, 7);
   

    var db = await getDB();
    List<Map<String, dynamic>> mData = (await db.rawQuery(
        'SELECT * FROM $TABLE_NAME WHERE $COLUMN_DATE LIKE ? ',
        ['$currentMonth%']));
    return mData.map((e) => ExpenseModel.fromMap(e)).toList();
  }

// update data
  Future<bool> updateExpanse(ExpenseModel noteModel) async {
    var db = await getDB();
    int rowsEffedted = await db.update(TABLE_NAME, noteModel.toMap(),
        where: "$COLUMN_ID = ${noteModel.id}");
    return rowsEffedted > 0;
  }

// dalete data
  Future<bool> deleteExpanse({required int sNo}) async {
    var db = await getDB();

    int rowsEffedted = await db.delete(TABLE_NAME, where: "$COLUMN_ID = $sNo");
    return rowsEffedted > 0;
  }
}
