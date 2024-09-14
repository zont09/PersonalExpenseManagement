import 'dart:io';
import 'dart:convert';

import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/BudgetDetail.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Model/Reminder.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/Model/SavingDetail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  final String _databaseName = 'PEM.db';
  final String _currencyTable = 'Currency';
  final String _walletTable = 'Wallet';
  final String _reminderTable = 'Reminder';
  final String _repeatOptionTable = 'RepeatOption';
  final String _parameterTable = 'Parameter';
  final String _transactionTable = 'TransactionTB';
  final String _budgetTable = 'Budget';
  final String _budgetDetailTable = 'BudgetDetail';
  final String _savingTable = 'Saving';
  final String _savingDetailTable = 'SavingDetail';
  final String _categoryTable = 'Category';


  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<void> deleteDatabasee() async {
    String path = join(await getDatabasesPath(), _databaseName);
    await deleteDatabase(path); // Xóa tệp cơ sở dữ liệu
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> _getDatabasePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    if (!await Directory(directory.path).exists()) {
      await Directory(directory.path).create(recursive: true);
    }
    return path;
  }

  Future<Database> _initDatabase() async {
    String path = await _getDatabasePath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_currencyTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        value REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_repeatOptionTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        option_name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_categoryTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE $_walletTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount REAL,
        currency INTEGER,
        note TEXT,
        FOREIGN KEY (currency) REFERENCES $_currencyTable (id) ON DELETE SET NULL ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $_reminderTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        description TEXT,
        repeat_option INTEGER,
        FOREIGN KEY (repeat_option) REFERENCES $_repeatOptionTable (id) ON DELETE SET NULL ON UPDATE CASCADE
      )
    ''');



    await db.execute('''
      CREATE TABLE $_transactionTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        amount REAL,
        wallet INTEGER,
        category INTEGER,
        note TEXT,
        description TEXT,
        repeat_option INTEGER,
        FOREIGN KEY (wallet) REFERENCES $_walletTable (id) ON DELETE SET NULL ON UPDATE CASCADE,
        FOREIGN KEY (category) REFERENCES $_categoryTable (id) ON DELETE SET NULL ON UPDATE CASCADE,
        FOREIGN KEY (repeat_option) REFERENCES $_repeatOptionTable (id) ON DELETE SET NULL ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $_budgetTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT
        )
    ''');

    await db.execute('''
      CREATE TABLE $_budgetDetailTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_budget INTEGER,
        category INTEGER,
        amount REAL,
        FOREIGN KEY (category) REFERENCES $_categoryTable (id) ON DELETE SET NULL ON UPDATE CASCADE,
        FOREIGN KEY (id_budget) REFERENCES $_budgetTable (id) ON DELETE SET NULL ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $_savingTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        target_amount REAL,
        target_date TEXT,
        current_amount REAL,
        is_finished INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE $_savingDetailTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_saving INTEGER,
        amount REAL,
        wallet INTEGER,
        note TEXT,
        FOREIGN KEY (id_saving) REFERENCES $_savingTable (id) ON DELETE SET NULL ON UPDATE CASCADE,
        FOREIGN KEY (wallet) REFERENCES $_walletTable (id) ON DELETE SET NULL ON UPDATE CASCADE
      )
    ''');



    await db.execute('''
      CREATE TABLE $_parameterTable (
        currency INTEGER,
        FOREIGN KEY (currency) REFERENCES $_currencyTable (id) ON DELETE SET NULL ON UPDATE CASCADE
      )
    ''');
  }

  //---------CURRENCY---------

  Future<int> insertCurrency(Currency Cur) async {
    final db = await database;
    return await db.insert(_currencyTable, Cur.toMap());
  }

  Future<List<Currency>> getCurrencys() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_currencyTable);
    return List.generate(maps.length, (i) {
      return Currency.fromMap(maps[i]);
    });
  }

  Future<int> updateCurrency(Currency Cur) async {
    final db = await database;
    return await db.update(
      _currencyTable,
      Cur.toMap(),
      where: 'id = ?',
      whereArgs: [Cur.id],
    );
  }

  Future<int> deleteCurrency(int id) async {
    final db = await database;
    return await db.delete(
      _currencyTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------WALLET---------

  Future<int> insertWallet(Wallet Wat) async {
    final db = await database;
    return await db.insert(_walletTable, Wat.toMap());
  }

  Future<List<Wallet>> getWallet() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT z.id as Wid, z.name as WName, z.amount, z.currency, z.note, q.id as CId, q.name as CName, q.value 
      FROM $_walletTable z 
      INNER JOIN $_currencyTable q ON z.currency = q.id
    ''');

    return List.generate(maps.length, (i) {
      // Tạo đối tượng Lop từ kết quả truy vấn
      final currency = Currency(
        id: maps[i]['CId'],
        name: maps[i]['CName'],
        value: maps[i]['value'],
      );

      // Tạo đối tượng HocSinh từ kết quả truy vấn
      return Wallet(
        id: maps[i]['Wid'],
        name: maps[i]['WName'],
        amount: maps[i]['amount'],
        currency: currency,
        note: maps[i]['note']
      );
    });
  }

  Future<int> updateWallet(Wallet Wat) async {
    final db = await database;
    return await db.update(
      _walletTable,
      Wat.toMap(),
      where: 'id = ?',
      whereArgs: [Wat.id],
    );
  }

  // Future<int> deleteWallet(int id) async {
  //   final db = await database;
  //   return await db.delete(
  //     _walletTable,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  //---------REPEATOPTION---------

  Future<int> insertRepeatOption(RepeatOption Rep) async {
    final db = await database;
    return await db.insert(_repeatOptionTable, Rep.toMap());
  }

  Future<List<RepeatOption>> getRepeatOptions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_repeatOptionTable);
    return List.generate(maps.length, (i) {
      return RepeatOption.fromMap(maps[i]);
    });
  }

  Future<int> updateRepeatOption(RepeatOption Rep) async {
    final db = await database;
    return await db.update(
      _repeatOptionTable,
      Rep.toMap(),
      where: 'id = ?',
      whereArgs: [Rep.id],
    );
  }

  Future<int> deleteRepeatOption(int id) async {
    final db = await database;
    return await db.delete(
      _repeatOptionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------REMINDER---------

  Future<int> insertReminder(Reminder Rem) async {
    final db = await database;
    return await db.insert(_reminderTable, Rem.toMap());
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT z.id as Zid, z.date, z.description, z.repeat_option, q.id as Qid, q.option_name as QName
      FROM $_reminderTable z 
      INNER JOIN $_repeatOptionTable q ON z.repeat_option = q.id
    ''');

    return List.generate(maps.length, (i) {
      final repeat_option = RepeatOption(
        id: maps[i]['Qid'],
        option_name: maps[i]['QName'],
      );

      return Reminder(
          id: maps[i]['Zid'],
          date: maps[i]['date'],
          description: maps[i]['description'],
          repeat_option: repeat_option
      );
    });
  }

  Future<int> updateReminder(Reminder Rem) async {
    final db = await database;
    return await db.update(
      _reminderTable,
      Rem.toMap(),
      where: 'id = ?',
      whereArgs: [Rem.id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(
      _reminderTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------TRANSACTION---------

  Future<int> insertTransaction(TransactionModel Tra) async {
    final db = await database;
    return await db.insert(_transactionTable, Tra.toMap());
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT z.id as Zid, z.wallet, z.category, z.note as ZNote, z.repeat_option, z.amount as ZAmount, z.description, z.date,
            q.id as Qid, q.option_name as QName,
            w.id as Wid, w.name as WName, w.note as WNote, w.amount as WAmount, w.currency,
            e.id as Eid, e.name as EName, e.type,
            r.id as Rid, r.name as RName, r.value
      FROM $_transactionTable z
      INNER JOIN $_repeatOptionTable q ON z.repeat_option = q.id
      INNER JOIN $_walletTable w ON z.wallet = w.id
      INNER JOIN $_categoryTable e ON z.category = e.id
      INNER JOIN $_currencyTable r ON w.currency = r.id
    ''');
    return List.generate(maps.length, (i) {
      final repeat_option = RepeatOption(
        id: maps[i]['Qid'] as int?,
        option_name: maps[i]['QName'],
      );

      final currency = Currency(name: maps[i]['RName'], value: maps[i]['value']);

      final wallet = Wallet(
        id: maps[i]['Wid'],
        name: maps[i]['WName'],
        amount: maps[i]['WAmount'],
        currency: currency,
        note: maps[i]['WNote'],
      );

      final category = Category(
          id: maps[i]['Eid'],
          name: maps[i]['EName'],
          type: maps[i]['type']
      );

      return TransactionModel(
          id: maps[i]['Zid'],
          date: maps[i]['date'],
          amount: maps[i]['ZAmount'],
          wallet: wallet,
          category: category,
          note: maps[i]['ZNote'],
          description: maps[i]['description'],
          repeat_option: repeat_option,
      );
    });
  }

  Future<int> updateTransaction(TransactionModel tra) async {
    final db = await database;
    return await db.update(
      _transactionTable,
      tra.toMap(),
      where: 'id = ?',
      whereArgs: [tra.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      _transactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------BUDGET---------

  Future<int> insertBudget(Budget Bud) async {
    final db = await database;
    return await db.insert(_budgetTable, Bud.toMap());
  }

  Future<List<Budget>> getBudgets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_budgetTable);
    return List.generate(maps.length, (i) {
      return Budget.fromMap(maps[i]);
    });
  }

  Future<int> updateBudget(Budget Bud) async {
    final db = await database;
    return await db.update(
      _budgetTable,
      Bud.toMap(),
      where: 'id = ?',
      whereArgs: [Bud.id],
    );
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;
    return await db.delete(
      _budgetTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------BUDGET_DETAIL---------

  Future<int> insertBudgetDetail(BudgetDetail BDe) async {
    final db = await database;
    return await db.insert(_budgetDetailTable, BDe.toMap());
  }

  Future<List<BudgetDetail>> getBudgetDetail() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT z.id as Zid, z.id_budget, z.category, z.amount,
            q.id as Qid, q.date,
            w.id as Wid, w.name, w.type
      FROM $_budgetDetailTable z 
      INNER JOIN $_budgetTable q ON z.id_budget = q.id
      INNER JOIN $_categoryTable w ON z.category = w.id
    ''');

    return List.generate(maps.length, (i) {
      final category = Category(
        id: maps[i]['Wid'],
        name: maps[i]['name'],
        type: maps[i]['type'],
      );
      final budget = Budget(
        id: maps[i]['Qid'],
        date: maps[i]['date']
      );
      return BudgetDetail(
        id: maps[i]['Zid'],
        amount: maps[i]['amount'],
        category: category,
        id_budget: budget
      );
    });
  }

  Future<int> updateBudgetDetail(BudgetDetail BDe) async {
    final db = await database;
    return await db.update(
      _budgetDetailTable,
      BDe.toMap(),
      where: 'id = ?',
      whereArgs: [BDe.id],
    );
  }

  Future<int> deleteBudgetDetail(int id) async {
    final db = await database;
    return await db.delete(
      _budgetDetailTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------SAVING---------

  Future<int> insertSaving(Saving Sav) async {
    final db = await database;
    return await db.insert(_savingTable, Sav.toMap());
  }

  Future<List<Saving>> getSaving() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_savingTable);
    return List.generate(maps.length, (i) {
      return Saving.fromMap(maps[i]);
    });
  }

  Future<int> updateSaving(Saving Sav) async {
    final db = await database;
    return await db.update(
      _savingTable,
      Sav.toMap(),
      where: 'id = ?',
      whereArgs: [Sav.id],
    );
  }

  Future<int> deleteSaving(int id) async {
    final db = await database;
    return await db.delete(
      _savingTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------SAVING_DETAIL---------

  Future<int> insertSavingDetail(SavingDetail SDe) async {
    final db = await database;
    return await db.insert(_savingDetailTable, SDe.toMap());
  }

  Future<List<SavingDetail>> getSavingDetails() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT z.id as Zid, z.id_saving, z.wallet, z.amount as ZAmount, z.note as ZNote,
            q.id as Qid, q.name as QName, q.target_amount, q.target_date, q.current_amount, q.is_finished,
            w.id as Wid, w.name as WName, w.amount as WAmount, w.currency, w.note as WNote,
            e.id as Eid, e.name as EName, e.value
      FROM $_savingDetailTable z 
      INNER JOIN $_savingTable q ON z.id_saving = q.id
      INNER JOIN $_walletTable w ON z.wallet = w.id
      INNER JOIN $_currencyTable e ON w.currency = e.id
    ''');

    return List.generate(maps.length, (i) {
      final currency = Currency(
          id: maps[i]['Eid'],
          name: maps[i]['EName'],
          value: maps[i]['value']
      );

      final saving = Saving(
          id: maps[i]['Qid'],
          name: maps[i]['QName'],
          target_amount: maps[i]['target_amount'],
          target_date: maps[i]['target_date'],
          current_amount: maps[i]['current_amount'],
          is_finished: maps[i]['is_finished']
      );

      final wallet = Wallet(
        id: maps[i]['Wid'],
        name: maps[i]['WName'],
        amount: maps[i]['WAmount'],
        currency: currency,
        note: maps[i]['WNote']
      );

      return SavingDetail(
          id: maps[i]['Zid'],
          id_saving: saving,
          amount: maps[i]['ZAmount'],
          wallet: wallet,
          note: maps[i]['ZNote']
      );
    });
  }

  Future<int> updateSavingDetail(SavingDetail SDe) async {
    final db = await database;
    return await db.update(
      _savingDetailTable,
      SDe.toMap(),
      where: 'id = ?',
      whereArgs: [SDe.id],
    );
  }

  Future<int> deleteSavingDetail(int id) async {
    final db = await database;
    return await db.delete(
      _savingDetailTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------CATEGORY---------

  Future<int> insertCategory(Category Cat) async {
    final db = await database;
    return await db.insert(_categoryTable, Cat.toMap());
  }

  Future<List<Category>> getCategorys() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_categoryTable);
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> updateCategory(Category Cat) async {
    final db = await database;
    return await db.update(
      _categoryTable,
      Cat.toMap(),
      where: 'id = ?',
      whereArgs: [Cat.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      _categoryTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //---------PARAMETER---------

  Future<int> insertParameter(Parameter Par) async {
    final db = await database;
    return await db.insert(_parameterTable, Par.toMap());
  }

  Future<List<Parameter>> getParameters() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT z.currency,
            q.id, q.name, q.value
      FROM $_parameterTable z 
      INNER JOIN $_currencyTable q ON z.currency = q.id
    ''');

    return List.generate(maps.length, (i) {
      final currency = Currency(
          id: maps[i]['id'],
          name: maps[i]['name'],
          value: maps[i]['value']
      );

      return Parameter(
          currency: currency
      );
    });
  }

  Future<int> updateParameter(Parameter Par) async {
    final db = await database;
    return await db.update(
      _parameterTable,
      Par.toMap(),
      where: 'currency = ?',
      whereArgs: [Par.currency],
    );
  }

  Future<int> deleteParameter(int id) async {
    final db = await database;
    return await db.delete(
      _parameterTable,
      where: 'currency = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllParameters() async {
    final db = await database;
    return await db.delete(_parameterTable);
  }

}