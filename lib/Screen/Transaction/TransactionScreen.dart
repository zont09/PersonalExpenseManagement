import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense_management/Components/dropdown.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Database/initdata.dart';
import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/BudgetDetail.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Model/Reminder.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/Model/SavingDetail.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  DatabaseHelper dbHelper = DatabaseHelper();
  void addCurrency() async {
    await Initdata.addParameter();
    List<Parameter> listCur = await dbHelper.getParameters();
    for (Parameter cur in listCur) {
      print('Item: ${cur.currency.name}');
    }
  }
  void deleteDB() async {
    await dbHelper.deleteDatabasee();
    print("Delete database successful");
  }
  @override
  Widget build(BuildContext context)  {
    final maxW = MediaQuery.of(context).size.width;
    final maxH = MediaQuery.of(context).size.height;
    return  Container(
      height: maxH,
      width: maxW,
      // color: Colors.amber,
      child: Column(
        children: [
          Container(
            height: 0.1 * maxH,
            // color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 96,),
                Column (
                  children: [
                    Text("Số dư"),
                    Text("22.092.004", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.XanhDuong),),
                    DropdownMenuW(items: <String>["Tien mat", "VCB", "MB", "VIP", "Viecombankneee"], height: 0.04 * maxH, width: 0.25 * maxW)
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => {
                          addCurrency()
                        },
                        icon: Icon(Icons.search, size: 30,),
                    ),
                    IconButton(
                      onPressed: () => {
                        deleteDB()
                      },
                      icon: Icon(Icons.more_vert, size: 32),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
