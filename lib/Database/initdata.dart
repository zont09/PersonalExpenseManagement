import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/BudgetDetail.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Model/Reminder.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/Model/SavingDetail.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Screen/Budget/BudgetScreen.dart';

class Initdata {

  static Future<void> addCurrency() async {
    DatabaseHelper db = DatabaseHelper();
    Currency cur1 = Currency(name: "VND", value: 1);
    Currency cur2 = Currency(name: "USD", value: 25000);
    Currency cur3 = Currency(name: "BTC", value: 1400000000);
    await db.insertCurrency(cur1);
    await db.insertCurrency(cur2);
    int id = await db.insertCurrency(cur3);
    print("Add currency successful $id");
  }

  static Future<void> addRepeatOption() async {
    DatabaseHelper db = DatabaseHelper();
    RepeatOption rep0 = RepeatOption(option_name: "Không");
    RepeatOption rep1 = RepeatOption(option_name: "Ngày");
    RepeatOption rep2 = RepeatOption(option_name: "Tuần");
    RepeatOption rep3 = RepeatOption(option_name: "Tháng");
    RepeatOption rep4 = RepeatOption(option_name: "Năm");
    await db.insertRepeatOption(rep0);
    await db.insertRepeatOption(rep1);
    await db.insertRepeatOption(rep2);
    await db.insertRepeatOption(rep3);
    int id = await db.insertRepeatOption(rep4);
    print("Add RepeatOption successful $id");
  }

  static Future<void> addCategory() async {
    DatabaseHelper db = DatabaseHelper();
    Category cat1 = Category(name: "Ăn uống", type: 0);
    Category cat2 = Category(name: "Du lịch", type: 0);
    Category cat3 = Category(name: "Mua sắm", type: 0);
    Category cat4 = Category(name: "Tiền lương", type: 1);
    Category cat5 = Category(name: "Trợ cấp", type: 1);
    Category cat6 = Category(name: "Cướp", type: 1);
    await db.insertCategory(cat1);
    await db.insertCategory(cat2);
    await db.insertCategory(cat3);
    await db.insertCategory(cat4);
    await db.insertCategory(cat5);
    int id = await db.insertCategory(cat6);
    print("Add Category successful $id");
  }

  static Future<void> addBudget() async {
    DatabaseHelper db = DatabaseHelper();
    Budget bud1 = Budget(date: "2024-09-01");
    Budget bud2 = Budget(date: "2024-08-01");
    Budget bud3 = Budget(date: "2024-07-01");
    await db.insertBudget(bud1);
    await db.insertBudget(bud2);
    int id = await db.insertBudget(bud3);
    print("Add Budget successful $id");
  }

  static Future<void> addBudgetDetail() async {
    DatabaseHelper db = DatabaseHelper();
    Budget bud1 = Budget(id: 1,date: "2024-09-01");
    Budget bud2 = Budget(id: 2,date: "2024-08-01");
    Budget bud3 = Budget(id: 3,date: "2024-07-01");
    Category cat1 = Category(id: 1,name: "Ăn uống", type: 0);
    Category cat2 = Category(id: 2,name: "Du lịch", type: 0);
    Category cat3 = Category(id: 3,name: "Mua sắm", type: 0);
    Category cat4 = Category(id: 4,name: "Tiền lương", type: 1);
    Category cat5 = Category(id: 5,name: "Trợ cấp", type: 1);
    Category cat6 = Category(id: 6,name: "Cướp", type: 1);
    BudgetDetail bde1 = BudgetDetail(id_budget: bud1, amount: 5000000, category: cat1);
    BudgetDetail bde2 = BudgetDetail(id_budget: bud1, amount: 2000000, category: cat2);
    BudgetDetail bde3 = BudgetDetail(id_budget: bud1, amount: 3000000, category: cat3);
    BudgetDetail bde4 = BudgetDetail(id_budget: bud2, amount: 2000000, category: cat1);
    BudgetDetail bde5 = BudgetDetail(id_budget: bud2, amount: 5000000, category: cat2);
    BudgetDetail bde6 = BudgetDetail(id_budget: bud2, amount: 3000000, category: cat3);
    await db.insertBudgetDetail(bde1);
    await db.insertBudgetDetail(bde2);
    await db.insertBudgetDetail(bde3);
    await db.insertBudgetDetail(bde4);
    await db.insertBudgetDetail(bde5);
    int id = await db.insertBudgetDetail(bde6);
    print("Add BudgetDetail successful $id");
  }

  static Future<void> addSaving() async {
    DatabaseHelper db = DatabaseHelper();
    Saving sav1 = Saving(name: "Mua xe", target_amount: 3000000000, target_date: "2025-09-30", current_amount: 0, is_finished: 0);
    Saving sav2 = Saving(name: "Mua nhà", target_amount: 7200000000, target_date: "2027-09-30", current_amount: 0, is_finished: 0);
    Saving sav3 = Saving(name: "Mua PC", target_amount: 50000000, target_date: "2025-02-30", current_amount: 50000, is_finished: 0);
    await db.insertSaving(sav1);
    await db.insertSaving(sav2);
    int id = await db.insertSaving(sav3);
    print("Add Saving successful $id");
  }

  static Future<void> addSavingDetail() async {
    DatabaseHelper db = DatabaseHelper();
    Saving sav1 = Saving(id: 1,name: "Mua xe", target_amount: 3000000000, target_date: "2025-09-30", current_amount: 200000, is_finished: 0);
    Saving sav2 = Saving(id: 2,name: "Mua nhà", target_amount: 7200000000, target_date: "2027-09-30", current_amount: 700000, is_finished: 0);
    Saving sav3 = Saving(id: 3,name: "Mua PC", target_amount: 50000000, target_date: "2025-02-30", current_amount: 50000, is_finished: 0);
    Currency cur1 = Currency(id: 1,name: "VND", value: 1);
    Currency cur2 = Currency(id: 2,name: "USD", value: 25000);
    Currency cur3 = Currency(id: 3,name: "BTC", value: 1400000000);
    Wallet wal1 = Wallet(id: 1,name: "Tiền mặt", amount: 2000000, currency: cur1, note: "Ví này giữ tiền mặt");
    Wallet wal2 = Wallet(id: 2,name: "Vietcombank", amount: 50000000, currency: cur1, note: "Ví này giữ tiền ở ngần hàng VCB");
    Wallet wal3 = Wallet(id: 3,name: "BIDV", amount: 20, currency: cur3, note: "Ví này giữ tiền điện tử");
    SavingDetail sde1 = SavingDetail(id_saving: sav1, amount: 200000, wallet: wal1, note: "Khong");
    SavingDetail sde2 = SavingDetail(id_saving: sav2, amount: 700000, wallet: wal2, note: "Khong");
    SavingDetail sde3 = SavingDetail(id_saving: sav3, amount: 50000, wallet: wal1, note: "Khong");
    await db.insertSavingDetail(sde1);
    await db.insertSavingDetail(sde2);
    int id = await db.insertSavingDetail(sde3);
    print("Add SavingDetail successful $id");
  }

  static Future<void> addReminder() async {
    DatabaseHelper db = DatabaseHelper();
    RepeatOption rep1 = RepeatOption(id: 1,option_name: "Ngày");
    RepeatOption rep2 = RepeatOption(id: 2,option_name: "Tuần");
    RepeatOption rep3 = RepeatOption(id: 3,option_name: "Tháng");
    RepeatOption rep4 = RepeatOption(id: 4,option_name: "Năm");
    Reminder rem1 = Reminder(date: "2024-09-22", description: "🙂Sinh nhat ban than", repeat_option: rep4);
    Reminder rem2 = Reminder(date: "2024-09-10", description: "Tien dien + nuoc", repeat_option: rep3);
    Reminder rem3 = Reminder(date: "2024-09-7", description: "Di hoc mon Java", repeat_option: rep2);
    await db.insertReminder(rem1);
    await db.insertReminder(rem2);
    int id = await db.insertReminder(rem3);
    print("Add Reminder successful $id");
  }

  static Future<void> addWallet() async {
    DatabaseHelper db = DatabaseHelper();
    Currency cur1 = Currency(id: 1,name: "VND", value: 1);
    Currency cur2 = Currency(id: 2,name: "USD", value: 25000);
    Currency cur3 = Currency(id: 3,name: "BTC", value: 1400000000);
    Wallet wal1 = Wallet(name: "Tiền mặt", amount: 2000000, currency: cur1, note: "Ví này giữ tiền mặt");
    Wallet wal2 = Wallet(name: "Vietcombank", amount: 50000000, currency: cur1, note: "Ví này giữ tiền ở ngần hàng VCB");
    Wallet wal3 = Wallet(name: "BIDV", amount: 20, currency: cur3, note: "Ví này giữ tiền điện tử");
    await db.insertWallet(wal1);
    await db.insertWallet(wal2);
    int id = await db.insertWallet(wal3);
    print("Add Wallet successful $id");
  }

  static Future<void> addTransaction() async {
    DatabaseHelper db = DatabaseHelper();
    Currency cur1 = Currency(id: 1,name: "VND", value: 1);
    Currency cur2 = Currency(id: 2,name: "USD", value: 25000);
    Currency cur3 = Currency(id: 3,name: "BTC", value: 1400000000);
    Wallet wal1 = Wallet(id: 1,name: "Tiền mặt", amount: 2000000, currency: cur1, note: "Ví này giữ tiền mặt");
    Wallet wal2 = Wallet(id: 2,name: "Vietcombank", amount: 50000000, currency: cur1, note: "Ví này giữ tiền ở ngần hàng VCB");
    Wallet wal3 = Wallet(id: 3,name: "BIDV", amount: 20, currency: cur3, note: "Ví này giữ tiền điện tử");
    Category cat1 = Category(id: 1,name: "Ăn uống", type: 0);
    Category cat2 = Category(id: 2,name: "Du lịch", type: 0);
    Category cat3 = Category(id: 3,name: "Mua sắm", type: 0);
    Category cat4 = Category(id: 4,name: "Tiền lương", type: 1);
    Category cat5 = Category(id: 5,name: "Trợ cấp", type: 1);
    Category cat6 = Category(id: 6,name: "Cướp", type: 1);
    RepeatOption rep0 = RepeatOption(id: 1,option_name: "Không");
    RepeatOption rep1 = RepeatOption(id: 2,option_name: "Ngày");
    RepeatOption rep2 = RepeatOption(id: 3,option_name: "Tuần");
    RepeatOption rep3 = RepeatOption(id: 4,option_name: "Tháng");
    RepeatOption rep4 = RepeatOption(id: 5,option_name: "Năm");
    TransactionModel tra1 = TransactionModel(date: "2024-09-5", amount: 30000, wallet: wal1, category: cat1, note: "Ăn trưa", description: "", repeat_option: rep0);
    TransactionModel tra2 = TransactionModel(date: "2024-09-5", amount: 40000, wallet: wal1, category: cat1, note: "Ăn tối", description: "", repeat_option: rep0);
    TransactionModel tra3 = TransactionModel(date: "2024-09-4", amount: 582000, wallet: wal2, category: cat3, note: "Mua đồ dùng trong trọ", description: "- Chổi 50k \n- Gối 99k\n- Nệm 400k", repeat_option: rep0);
    TransactionModel tra4 = TransactionModel(date: "2024-09-4", amount: 1200000, wallet: wal2, category: cat3, note: "Đóng tiền nhà", description: "", repeat_option: rep3);
    TransactionModel tra5 = TransactionModel(date: "2024-09-2", amount: 3000000, wallet: wal2, category: cat2, note: "Đi du lịch cùng gia đình", description: "", repeat_option: rep0);
    TransactionModel tra6 = TransactionModel(date: "2024-09-2", amount: 500000, wallet: wal2, category: cat5, note: "Thưởng ngày lễ", description: "", repeat_option: rep0);
    TransactionModel tra7 = TransactionModel(date: "2024-08-31", amount: 5000000, wallet: wal1, category: cat4, note: "Lúa về ^^", description: "", repeat_option: rep0);
    TransactionModel tra8 = TransactionModel(date: "2024-08-4", amount: 200000, wallet: wal1, category: cat6, note: "Nhặt được của bác hàng xóm", description: "", repeat_option: rep0);
    await db.insertTransaction(tra1);
    await db.insertTransaction(tra2);
    await db.insertTransaction(tra3);
    await db.insertTransaction(tra4);
    await db.insertTransaction(tra5);
    await db.insertTransaction(tra6);
    await db.insertTransaction(tra7);
    int id = await db.insertTransaction(tra8);
    print("Add Transaction successful $id");
  }

  static Future<void> addParameter() async {
    DatabaseHelper db = DatabaseHelper();
    Currency cur1 = Currency(id: 1,name: "VND", value: 1);
    Currency cur2 = Currency(id: 2,name: "USD", value: 25000);
    Currency cur3 = Currency(id: 3,name: "BTC", value: 1400000000);
    Parameter par = Parameter(currency: cur1);
    int id = await db.insertParameter(par);
    print("Add Parameter successful $id");
  }

}