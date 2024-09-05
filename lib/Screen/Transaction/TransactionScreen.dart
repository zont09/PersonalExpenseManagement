import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense_management/Components/dropdown.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Currency.dart';
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
    // Currency cur1 = Currency(name: "VND", value: 1);
    // Currency cur2 = Currency(name: "USD", value: 25000);
    // await dbHelper.insertCurrency(cur1);
    // await dbHelper.insertCurrency(cur2);
    List<Currency> listCur = await dbHelper.getCurrencys();
    Wallet wal1 = Wallet(name: "Tien mat", amount: 20000000, currency: listCur.first, note: "Khong");
    Wallet wal2 = Wallet(name: "VCB", amount: 12050000, currency: listCur.first, note: "TKNH");
    Wallet wal3 = Wallet(name: "BIDV", amount: 550000, currency: listCur.last, note: "TKNH");
    int id = await dbHelper.insertWallet(wal1);
    id = await dbHelper.insertWallet(wal2);
    id = await dbHelper.insertWallet(wal3);
    List<Wallet> listWallet = await dbHelper.getWallet();
    print("ID: " + id.toString());
    for (Wallet wallet in listWallet) {
      print('Wallet: ${wallet.id} - ${wallet.name} - ${wallet.amount} - ${wallet.currency.id} - ${wallet.note}');
      await dbHelper.deleteWallet(wallet.id ?? 0);
    }

  }
  void deleteDB() async {
    await dbHelper.deleteDatabasee();
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
