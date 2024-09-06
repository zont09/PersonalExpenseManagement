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
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_event.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  DatabaseHelper dbHelper = DatabaseHelper();
  Future<List<Wallet>>? listWallet;
  DateTime dateTransaction = DateTime.now();
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // await Initdata.addCurrency();
    // await Initdata.addWallet();
    listWallet = dbHelper.getWallet();
  }

  Future<void> _selectDate(BuildContext context, String? locale,) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: dateTransaction ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
      locale: localeObj,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: 12, ), // Center text
              titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
            ),
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: child,
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        dateTransaction = selected;
      });
    }
  }

  void addSampleData() async {
    await Initdata.addAllSampleData();
  }

  void deleteDB() async {
    await dbHelper.deleteDatabasee();
    print("Delete database successful");
  }

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;
    final maxH = MediaQuery.of(context).size.height;
    return FutureBuilder<List<Wallet>>(
      future: listWallet,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Error: ${snapshot.error}")); // Error handling
        } else if (snapshot.hasData) {
          final wallets = snapshot.data!;

          // Using for loop to print wallet names
          for (Wallet cur in wallets) {
            print('Item: ${cur.name}');
          }

          return BlocProvider(
            create: (context) => WalletBloc(wallets),
            child: Container(
              height: maxH,
              width: maxW,
              child: Column(
                children: [
                  Container(
                    height: 0.1 * maxH,
                    color: AppColors.Nen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 96,
                        ),
                        Column(
                          children: [
                            Text("Số dư"),
                            BlocBuilder<WalletBloc, WalletState>(
                              builder: (context, state) {
                                if (state is WalletSelectedState)
                                  return Text(
                                    GlobalFunction.formatCurrency(
                                            state.selectedWallet.amount) +
                                        " " +
                                        state.selectedWallet.currency.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.XanhDuong),
                                  );
                                else
                                  return Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.XanhDuong),
                                  );
                              },
                            ),
                            DropdownWG(
                                wallets: wallets, maxH: maxH, maxW: maxW),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => {
                                // addSampleData()
                              },
                              icon: Icon(
                                Icons.search,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () => {
                                // deleteDB()
                              },
                              icon: Icon(Icons.more_vert, size: 32),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 0.05 * maxH,
                    color: AppColors.Nen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => {
                            setState(() {
                              int mon = dateTransaction.month;
                              int yea = dateTransaction.year;
                              mon = mon - 1;
                              if(mon < 1) {
                                mon = 12;
                                yea = yea - 1;
                              }
                              dateTransaction = DateTime(yea, mon);
                            })
                          },
                          icon:const Icon(
                            Icons.keyboard_arrow_left,
                            size: 30,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                          ),
                          onPressed: () => {
                            _selectDate(context, 'vi')
                          },
                          child: Text(
                            "Thg ${dateTransaction.month} ${dateTransaction.year}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            setState(() {
                              int mon = dateTransaction.month;
                              int yea = dateTransaction.year;
                              mon = mon + 1;
                              if(mon > 12) {
                                mon = 1;
                                yea = yea + 1;
                              }
                              dateTransaction = DateTime(yea, mon);
                            })
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_right,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  height: 30,
                                  color: AppColors.Nen,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  height: 60,
                                  color: AppColors.Nen,
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text('Ăn uống', style: TextStyle(fontSize: 16 , color: Color(0xff787878),)),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 30,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("Ăn tối bún bò huế", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,),
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("Tiền mặt", style: TextStyle(fontSize: 16 , color: Color(0xff787878)),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1, // Third column takes 1/4 of the available width
                                          child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  '+50.000.000 VND',
                                                  style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.XanhLaDam),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text("Failed"));
        }
      },
    );
  }
}

class DropdownWG extends StatelessWidget {
  const DropdownWG({
    super.key,
    required this.wallets,
    required this.maxH,
    required this.maxW,
  });

  final List<Wallet> wallets;
  final double maxH;
  final double maxW;

  @override
  Widget build(BuildContext context) {
    return DropdownMenuW(
      wallets: wallets,
      height: 0.04 * maxH,
      width: 0.25 * maxW,
      onChanged: (int selectedWalletId) {
        // Dispatch the wallet change event
        context.read<WalletBloc>().add(SelectWalletEvent(selectedWalletId));
      },
    );
  }
}
