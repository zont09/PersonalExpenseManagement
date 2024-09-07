import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Future<List<dynamic>>? _combinedFuture;
  DateTime dateTransaction = DateTime.now();
  String searchText = "";
  TextEditingController _textFieldController = TextEditingController();
  late int countDebug = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // await Initdata.addCurrency();
    // await Initdata.addWallet();
    _combinedFuture =
        Future.wait([dbHelper.getWallet(), dbHelper.getTransactions(), dbHelper.getParameters(), dbHelper.getCategorys()]);
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
              bodyLarge: TextStyle(
                fontSize: 12,
              ), // Center text
              titleLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhập ghi chú muốn tìm kiếm'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Nhập vào đây"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: Text('Xác nhận'),
              onPressed: () {
                setState(() {
                  searchText = _textFieldController.text;
                });
                print("Giá trị nhập: ${_textFieldController.text}");
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _openBottomSheet(BuildContext context, Map<String, bool> checkboxValues, Function(Map<String, bool>) onUpdateCheckboxValues) {
    bool isAllChecked = true;
    for (var entry in checkboxValues.entries) {
      if(!entry.value) {
        isAllChecked = false;
        break;
      }
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giao dịch thu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...checkboxValues.keys.map((key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: checkboxValues[key],
                      onChanged: (bool? value) {
                        setState(() {
                          checkboxValues[key] = value!;
                          if (key == 'Tất cả') {
                            isAllChecked = value;
                            checkboxValues.updateAll((key, value) => isAllChecked);
                          } else {
                            isAllChecked = checkboxValues.values.every((element) => element == true);
                            checkboxValues['Tất cả'] = isAllChecked;
                          }
                          print("Key: ${key}\n Value:${value}");
                          onUpdateCheckboxValues(checkboxValues);
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;
    final maxH = MediaQuery.of(context).size.height;
    return FutureBuilder<List<dynamic>>(
      future: _combinedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Error: ${snapshot.error}")); // Error handling
        } else if (snapshot.hasData) {
          final List<Wallet> wallets = snapshot.data![0];
          final List<TransactionModel> transactions = snapshot.data![1];
          final List<Parameter> parameters = snapshot.data![2];
          final List<Category> categories = snapshot.data![3];
          final currencyGB = parameters.first.currency;
          Map<String, bool> mapIncome = { for (var item in categories) if(item.type == 1) item.name : true };
          Map<String, bool> mapOutcome = { for (var item in categories) if(item.type == 0) item.name : true };
          mapIncome['Tất cả'] = true;
          mapOutcome['Tất cả'] = true;
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
                                            state.selectedWallet.amount * state.selectedWallet.currency.value / currencyGB.value) +
                                        " " +
                                        currencyGB.name,
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
                                _showSearchDialog(context)
                              },
                              icon: Icon(
                                Icons.search,
                                size: 30,
                              ),
                            ),
                            PopupMenuButton<int>(
                              icon: Icon(Icons.more_vert), // Thay đổi icon ở đây
                              onSelected: (value) {
                                if (value == 0) {
                                  _openBottomSheet(context, mapIncome, (updatedMap) {
                                    setState(() {
                                      mapIncome = updatedMap; // Cập nhật giá trị bên ngoài
                                    });
                                  }); // Cập nhật và render lại toàn bộ widget);
                                } else if (value == 1) {
                                  _openBottomSheet(context, mapOutcome, (updatedMap) {
                                    setState(() {
                                      mapOutcome = updatedMap; // Cập nhật giá trị bên ngoài
                                    });
                                  });
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Text("Giao dịch thu"),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Text("Giao dịch chi"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                              if (mon < 1) {
                                mon = 12;
                                yea = yea - 1;
                              }
                              dateTransaction = DateTime(yea, mon);
                            })
                          },
                          icon: const Icon(
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
                          onPressed: () => {_selectDate(context, 'vi')},
                          child: Text(
                            "Thg ${dateTransaction.month} ${dateTransaction.year}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            setState(() {
                              int mon = dateTransaction.month;
                              int yea = dateTransaction.year;
                              mon = mon + 1;
                              if (mon > 12) {
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
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: BlocBuilder<WalletBloc, WalletState>(
                        builder: (context, state) {
                          if (state is WalletSelectedState)
                            return Column(
                              children: List.generate(31, (index) {
                                // final listDayTransaction =
                                //     GlobalFunction.getTransactionByDate(
                                //         transactions,
                                //         DateTime(
                                //             dateTransaction.year,
                                //             dateTransaction.month,
                                //             31 - index + 1));
                                // final listNote = GlobalFunction.getTransactionByNote(listDayTransaction, searchText);
                                // final listTran =
                                //     GlobalFunction.getTransactionByWallet(
                                //         listNote,
                                //         state.selectedWallet.id!);
                                // print("----------------MAP CHANGE----------------  ${countDebug++}  ${index} ${mapOutcome['Ăn uống']}");
                                final listTransaction = GlobalFunction.getTransactionByAll(transactions, DateTime(dateTransaction.year, dateTransaction.month, 31 - index + 1),
                                    state.selectedWallet.id!, searchText, mapIncome, mapOutcome);
                                if (listTransaction.isNotEmpty) {
                                  return Column(
                                    children: [
                                      // Container cho ngày
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        height: 30,
                                        color: AppColors.Nen,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              (31 - index + 1).toString(),
                                              // Hiển thị ngày
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),
                                      ...listTransaction
                                          .map((item) => Column(
                                                children: [
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    color: AppColors.Nen,
                                                    child: InkWell(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  item.category
                                                                      .name,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Color(
                                                                        0xff787878),
                                                                  )),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 30,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        item.note,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 30,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        item.wallet
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Color(0xff787878)),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 5),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  child: Text(
                                                                    item.category.type ==
                                                                            0
                                                                        ? "-" +
                                                                            GlobalFunction.formatCurrency(item.amount * item.wallet.currency.value / currencyGB.value) + " " + currencyGB.name
                                                                        : "+" +
                                                                            GlobalFunction.formatCurrency(item.amount * item.wallet.currency.value / currencyGB.value) + " " + currencyGB.name,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: item.category.type == 0
                                                                          ? AppColors
                                                                              .Cam
                                                                          : AppColors
                                                                              .XanhLaDam,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                          .toList(),
                                    ],
                                  );
                                } else {
                                  // Nếu danh sách trống, trả về SizedBox hoặc widget rỗng
                                  return SizedBox.shrink();
                                }
                              }).toList(),
                            );
                          else
                            return Center(
                              child: Text("Không có dữ liệu"),
                            );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text("Failed to load Wallet"));
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
