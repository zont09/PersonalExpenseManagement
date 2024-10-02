import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense_management/Components/dropdown.dart';
import 'package:personal_expense_management/Components/transaction_tag.dart';
import 'package:personal_expense_management/Components/transaction_tag2.dart';
import 'package:personal_expense_management/Components/wallet_container.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Database/initdata.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
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
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../Animation/Wavepainter.dart';

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
  Wallet _walletSelect = Wallet(
      id: 0,
      name: "",
      amount: 0,
      currency: Currency(name: "", value: 0),
      note: "");

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
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.white, // Picker background color
              onSurface: Colors.black, // Picker text color
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 12,
                color: Colors.black, // Text color for picker body
              ),
              titleLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Text color for picker title
              ),
            ),
          ),
          child: Center(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.6,
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
          title: const Text(
            'Tìm kiếm ghi chú',
            style: TextStyle(color: Color(0xFF339DD4)),
          ),
          content: TextField(
            style: const TextStyle(
              color: Color(0xFF384955), // Đổi màu chữ
              fontSize: 16.0, // Kích thước chữ
            ),
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: "Nhập ghi chú",
              hintStyle: TextStyle(
                color: Color(0xFF9CADBC), // Đổi màu gợi ý
              ),
            ),
          ),
          backgroundColor: Colors.white,
          // Thay đổi màu nền
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Thêm border radius
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy', style: TextStyle(color: Color(0xFF339DD4))),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child:
                  const Text('Xác nhận', style: TextStyle(color: Color(0xFF339DD4))),
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
      backgroundColor: Colors.white, // Make background transparent to apply custom radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)), // Set border radius
      ),
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 200), // Adjust the opening speed here
        vsync: Scaffold.of(context),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      type == 1 ? 'Giao dịch thu' : 'Giao dịch chi',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Column(
                      children: checkboxValues.keys.map((key) {
                        return CheckboxListTile(
                          title: Text(key),
                          activeColor: AppColors.XanhDuong, // Color when checked
                          checkColor: Colors.white,
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
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.XanhDuong, // Text color
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          completer.complete();
                        },
                        child: Text('Hủy', style: TextStyle(),),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.XanhDuong, // Text color
                        ),
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
                    final totalWallet =
                        wallets.firstWhere((item) => item.id == 0);
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
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFf339DD4),
                                          Color(0xFF00D0CC)
                                        ],
                                        // Các màu bạn muốn chuyển tiếp
                                        begin: Alignment.topLeft,
                                        // Điểm bắt đầu của gradient
                                        end: Alignment
                                            .bottomRight, // Điểm kết thúc của gradient
                                      ),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(25),
                                          bottomRight: Radius.circular(25))),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 0.07 * maxH,
                                        // color: AppColors.Nen,
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
                                            Theme(
                                              data: Theme.of(context).copyWith(
                                                popupMenuTheme: const PopupMenuThemeData(
                                                  color: Color(0xFFF2FBFF), // Đổi màu nền của PopupMenu
                                                  textStyle: TextStyle(
                                                    color: Colors.white, // Đổi màu chữ của tất cả các mục
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)), // Bo góc cho PopupMenu
                                                    side: BorderSide(
                                                      color: Colors.white, // Màu viền của PopupMenu
                                                      width: 2.0, // Độ dày của viền
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              child: PopupMenuButton<int>(
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
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 70,
                                        width: maxW * 3 / 4,
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            const Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Tổng",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFCEF6FF)),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "${GlobalFunction.formatCurrency(totalWallet.amount, 2)} ${totalWallet.currency.name}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            Color(0xFF006A9D)),
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
                                            children: wallets
                                                .skip(1)
                                                .map((item) => Row(
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () => {
                                                                  setState(() {
                                                                    if (_walletSelect
                                                                            .id !=
                                                                        item.id) {
                                                                      _walletSelect =
                                                                          item;
                                                                    } else {
                                                                      _walletSelect =
                                                                          totalWallet;
                                                                    }
                                                                  })
                                                                },
                                                            child:
                                                                WalletContainer(
                                                              wal: item,
                                                              height: 80,
                                                              width:
                                                                  maxW * 2 / 3,
                                                              isSelect:
                                                                  _walletSelect
                                                                          .id ==
                                                                      item.id,
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
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ),
                                // TransactionTag(tran: TransactionModel(date: "2024-09-30", amount: 5000000, wallet: Wallet(name: "tien mat", amount: 90, currency: Currency(name: "VND", value: 1), note: ""), category: Category(name: "An uong", type: 0), note: "", description: "", repeat_option: RepeatOption(option_name: ""))),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: BlocBuilder<TransactionBloc,
                                        TransactionState>(
                                      builder: (context, state) {
                                        if (state is TransactionChangedState) {
                                          final transactions =
                                              state.newTransaction;
                                          return BlocBuilder<CategoryMapBloc,
                                                  CategoryMapState>(
                                              builder:
                                                  (context, categoryState) {
                                            if (categoryState
                                                is CategoryMapUpdatedState) {
                                              final mapIncome =
                                                  categoryState.mapIncome;
                                              final mapOutcome =
                                                  categoryState.mapOutcome;

                                              return Column(
                                                children:
                                                    List.generate(31, (index) {
                                                  final listTransaction =
                                                      GlobalFunction
                                                          .getTransactionByAll(
                                                    transactions,
                                                    DateTime(
                                                        dateTransaction.year,
                                                        dateTransaction.month,
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
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 5),
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.2),
                                                                  // Màu của shadow
                                                                  spreadRadius:
                                                                      3,
                                                                  // Độ lan rộng của shadow
                                                                  blurRadius: 7,
                                                                  // Độ mờ của shadow
                                                                  offset: Offset(
                                                                      0,
                                                                      0), // Vị trí của shadow
                                                                ),
                                                              ],
                                                                  color: Colors
                                                                      .white),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Ngày ${(31 - index + 1)}",
                                                                // Hiển thị ngày
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children:
                                                                listTransaction
                                                                    .reversed
                                                                    .map(
                                                                        (item) =>
                                                                            Row(
                                                                              children: [
                                                                                TransactionTag(
                                                                                  tran: item,
                                                                                  cur: currencyGB,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 8,
                                                                                )
                                                                              ],
                                                                            ))
                                                                    .toList(),
                                                          ),
                                                        )
                                                        // ...listTransaction
                                                        //     .reversed
                                                        //     .map(
                                                        //         (item) =>
                                                        //             TransactionTag(tran: item, cur: currencyGB,)
                                                        // ).toList(),
                                                      ],
                                                    );
                                                  } else {
                                                    // Nếu danh sách trống, trả về SizedBox hoặc widget rỗng
                                                    return SizedBox.shrink();
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
