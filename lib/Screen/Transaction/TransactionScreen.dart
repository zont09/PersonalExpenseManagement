import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense_management/Components/dropdown.dart';
import 'package:personal_expense_management/Components/wallet_container.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Database/initdata.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/Screen/Transaction/detailTransaction.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_bloc.dart';
import 'package:personal_expense_management/bloc/category_map_bloc/category_map_bloc.dart';
import 'package:personal_expense_management/bloc/category_map_bloc/category_map_event.dart';
import 'package:personal_expense_management/bloc/category_map_bloc/category_map_state.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_state.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_bloc.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_state.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';
import 'package:personal_expense_management/bloc/wallet_select_bloc/wallet_select_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_select_bloc/wallet_select_event.dart';
import 'package:personal_expense_management/bloc/wallet_select_bloc/wallet_select_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';

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
  Wallet _walletSelect = Wallet(id: 0,name: "", amount: 0, currency: Currency(name: "", value: 0), note: "");

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // await Initdata.addCurrency();
    // await Initdata.addWallet();
    // await dbHelper.deleteDatabasee();
    _combinedFuture = Future.wait([
      dbHelper.getWallet(),
      dbHelper.getTransactions(),
      dbHelper.getParameters(),
      dbHelper.getCategorys()
    ]);
  }

  Future<void> _selectDate(
    BuildContext context,
    String? locale,
  ) async {
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openBottomSheet(BuildContext context,
      Map<String, bool> mapIncome, Map<String, bool> mapOutcome, int type) {
    bool isAllChecked = true;
    final Completer<void> completer = Completer<void>();

    Map<String, bool> checkboxValues;
    if (type == 0)
      checkboxValues = mapOutcome;
    else
      checkboxValues = mapIncome;
    for (var entry in checkboxValues.entries) {
      if (!entry.value) {
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
                    type == 1 ? 'Giao dịch thu' : 'Giao dịch chi',
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
                            bool isAllChecked = value;
                            checkboxValues
                                .updateAll((key, value) => isAllChecked);
                          } else {
                            if (!value)
                              checkboxValues['Tất cả'] = false;
                            else {
                              bool allTrue = checkboxValues.values
                                  .skip(1)
                                  .every((value) => value == true);
                              if (allTrue) checkboxValues['Tất cả'] = true;
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          completer.complete();
                        },
                        child: Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          completer.complete();
                        },
                        child: Text('Xác nhận'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    return completer.future;
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
          final List<Parameter> parameters = snapshot.data![2];
          final List<Category> categories = snapshot.data![3];
          Map<String, bool> mapIncome = {
            'Tất cả': true,
            for (var item in categories)
              if (item.type == 1) item.name: true
          };
          Map<String, bool> mapOutcome = {
            'Tất cả': true,
            for (var item in categories)
              if (item.type == 0) item.name: true
          };
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CategoryMapBloc(mapIncome, mapOutcome),
              ),
            ],
            child: Builder(builder: (BuildContext context) {
              return BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletUpdatedState) {
                    final List<Wallet> wallets = state.updatedWallet;
                    final totalWallet = wallets.firstWhere((item) => item.id == 0);
                          //state.selectedWallet.id;
                          return BlocBuilder<ParameterBloc, ParameterState>(
                            builder: (context, state) {
                              if (state is ParameterUpdateState) {
                                final currencyGB = state.updPar.currency;
                                return Container(
                                  height: maxH,
                                  width: maxW,
                                  color: Colors.white.withOpacity(0.6),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 0.07 * maxH,
                                        color: AppColors.Nen,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  {_showSearchDialog(context)},
                                              icon: Icon(
                                                Icons.search,
                                                size: 30,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () => {
                                                    setState(() {
                                                      int mon =
                                                          dateTransaction.month;
                                                      int yea =
                                                          dateTransaction.year;
                                                      mon = mon - 1;
                                                      if (mon < 1) {
                                                        mon = 12;
                                                        yea = yea - 1;
                                                      }
                                                      dateTransaction =
                                                          DateTime(yea, mon);
                                                    })
                                                  },
                                                  icon: const Icon(
                                                    Icons.keyboard_arrow_left,
                                                    size: 30,
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                  ),
                                                  onPressed: () => {
                                                    _selectDate(context, 'vi')
                                                  },
                                                  child: Text(
                                                    "Thg ${dateTransaction.month} ${dateTransaction.year}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () => {
                                                    setState(() {
                                                      int mon =
                                                          dateTransaction.month;
                                                      int yea =
                                                          dateTransaction.year;
                                                      mon = mon + 1;
                                                      if (mon > 12) {
                                                        mon = 1;
                                                        yea = yea + 1;
                                                      }
                                                      dateTransaction =
                                                          DateTime(yea, mon);
                                                    })
                                                  },
                                                  icon: const Icon(
                                                    Icons.keyboard_arrow_right,
                                                    size: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            PopupMenuButton<int>(
                                              icon: Icon(Icons.more_vert),
                                              onSelected: (value) async {
                                                if (value == 0) {
                                                  await _openBottomSheet(
                                                      context,
                                                      mapIncome,
                                                      mapOutcome,
                                                      1);
                                                  print("ra 0");
                                                  context
                                                      .read<CategoryMapBloc>()
                                                      .add(
                                                          UpdateCategoryMapEvent(
                                                              mapIncome,
                                                              mapOutcome));
                                                } else if (value == 1) {
                                                  await _openBottomSheet(
                                                      context,
                                                      mapIncome,
                                                      mapOutcome,
                                                      0);
                                                  print("ra 1");
                                                  context
                                                      .read<CategoryMapBloc>()
                                                      .add(
                                                          UpdateCategoryMapEvent(
                                                              mapIncome,
                                                              mapOutcome));
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
                                      ),
                                      Container(
                                        height: 70,
                                        width: maxW,
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            const Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Tổng",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF878787)),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "${GlobalFunction
                                                            .formatCurrency(
                                                                totalWallet
                                                                    .amount,
                                                                2)} ${totalWallet
                                                            .currency.name}"
                                                    ,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .XanhDuong),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 80,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        width: maxW,
                                        // color: Colors.amber,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: wallets.skip(1)
                                                .map((item) => Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () => {
                                                            setState(() {
                                                              if(_walletSelect.id != item.id) {
                                                                _walletSelect = item;
                                                              } else {
                                                                _walletSelect = totalWallet;
                                                              }
                                                            })
                                                          },
                                                            child:
                                                                WalletContainer(
                                                          wal: item,
                                                          height: 80,
                                                          width: maxW * 2 / 3,
                                                          isSelect: _walletSelect.id == item.id,
                                                        )),
                                                        SizedBox(
                                                          width: 8,
                                                        )
                                                      ],
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: BlocBuilder<TransactionBloc,
                                              TransactionState>(
                                            builder: (context, state) {
                                              if (state
                                                  is TransactionChangedState) {
                                                final transactions =
                                                    state.newTransaction;
                                                return BlocBuilder<
                                                        CategoryMapBloc,
                                                        CategoryMapState>(
                                                    builder: (context,
                                                        categoryState) {
                                                  if (categoryState
                                                      is CategoryMapUpdatedState) {
                                                    final mapIncome =
                                                        categoryState.mapIncome;
                                                    final mapOutcome =
                                                        categoryState
                                                            .mapOutcome;

                                                    return Column(
                                                      children: List.generate(
                                                          31, (index) {
                                                        final listTransaction =
                                                            GlobalFunction
                                                                .getTransactionByAll(
                                                          transactions,
                                                          DateTime(
                                                              dateTransaction
                                                                  .year,
                                                              dateTransaction
                                                                  .month,
                                                              31 - index + 1),
                                                          _walletSelect.id!,
                                                          searchText,
                                                          mapIncome,
                                                          mapOutcome,
                                                        );
                                                        if (listTransaction
                                                            .isNotEmpty) {
                                                          return Column(
                                                            children: [
                                                              // Container cho ngày
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                height: 30,
                                                                color: AppColors
                                                                    .Nen,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      (31 -
                                                                              index +
                                                                              1)
                                                                          .toString(),
                                                                      // Hiển thị ngày
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              ...listTransaction
                                                                  .reversed
                                                                  .map((item) =>
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                60,
                                                                            color:
                                                                                AppColors.Nen,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () => {
                                                                                Navigator.of(context).push(
                                                                                  MaterialPageRoute(
                                                                                    builder: (newContext) => MultiBlocProvider(
                                                                                      providers: [
                                                                                        BlocProvider.value(
                                                                                          value: BlocProvider.of<CategoryBloc>(context),
                                                                                        ),
                                                                                        BlocProvider.value(
                                                                                          value: BlocProvider.of<WalletBloc>(context),
                                                                                        ),
                                                                                        BlocProvider.value(
                                                                                          value: BlocProvider.of<RepeatOptionBloc>(context),
                                                                                        ),
                                                                                        BlocProvider.value(
                                                                                          value: BlocProvider.of<TransactionBloc>(context),
                                                                                        ),
                                                                                      ],
                                                                                      child: Detailtransaction(transaction: item),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.only(left: 10),
                                                                                      child: Text(item.category.name,
                                                                                          style: TextStyle(
                                                                                            fontSize: 16,
                                                                                            color: Color(0xff787878),
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
                                                                                            child: Align(
                                                                                              alignment: Alignment.centerLeft,
                                                                                              child: Text(
                                                                                                item.note,
                                                                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            height: 30,
                                                                                            child: Align(
                                                                                              alignment: Alignment.centerLeft,
                                                                                              child: Text(
                                                                                                item.wallet.name,
                                                                                                style: TextStyle(fontSize: 16, color: Color(0xff787878)),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                maxLines: 1,
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
                                                                                      padding: EdgeInsets.only(right: 5),
                                                                                      child: Align(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: FittedBox(
                                                                                          fit: BoxFit.scaleDown,
                                                                                          child: Text(
                                                                                            item.category.type == 0 ? "-" + GlobalFunction.formatCurrency(item.amount * item.wallet.currency.value / currencyGB.value, 2) + " " + currencyGB.name : "+" + GlobalFunction.formatCurrency(item.amount * item.wallet.currency.value / currencyGB.value, 2) + " " + currencyGB.name,
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: item.category.type == 0 ? AppColors.Cam : AppColors.XanhLaDam,
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
                                                          return SizedBox
                                                              .shrink();
                                                        }
                                                      }).toList(),
                                                    );
                                                  } else
                                                    return Center(
                                                      child: Text(
                                                          "Không có dữ liệu category"),
                                                    );
                                                });
                                              } else {
                                                return Text("Không có dữ liệu");
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Text(
                                    "Error load parameter in TransactionScreen");
                              }
                            },
                          );

                  } else {
                    return Text("Error load wallets in TransactionScreen");
                  }
                },
              );
            }),
          );
        } else {
          return Center(child: Text("Failed to load Wallet"));
        }
      },
    );
  }
}

// class DropdownWG extends StatelessWidget {
//   const DropdownWG({
//     super.key,
//     required this.wallets,
//     required this.maxH,
//     required this.maxW,
//   });
//
//   final List<Wallet> wallets;
//   final double maxH;
//   final double maxW;
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenuW(
//       wallets: wallets,
//       height: 0.04 * maxH,
//       width: 0.25 * maxW,
//       onChanged: (int selectedWalletId) {
//         // Dispatch the wallet change event
//         context.read<WalletSelectBloc>().add(SelectWalletEvent(selectedWalletId));
//       },
//     );
//   }
// }
