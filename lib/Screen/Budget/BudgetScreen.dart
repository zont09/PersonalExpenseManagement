import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/Screen/Budget/addBudgetScreen.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_bloc.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_state.dart';
import 'package:personal_expense_management/bloc/budget_detail_bloc/budget_detail_bloc.dart';
import 'package:personal_expense_management/bloc/budget_detail_bloc/budget_detail_state.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_state.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_state.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime _dateTime = DateTime.now();

  Future<void> _selectDate(BuildContext context, String? locale,) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _dateTime ?? DateTime.now(),
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
        _dateTime = selected;
      });
    }
  }

  Map<String, double> calculateCategoryTotals(List<TransactionModel> transactions, Currency currencyGB) {
    Map<String, double> categoryTotals = {};
    for (var transaction in transactions) {
      // Nếu danh mục đã có trong Map, cộng số tiền vào tổng hiện tại
      if (categoryTotals.containsKey(transaction.category.name)) {
        categoryTotals[transaction.category.name] =
            categoryTotals[transaction.category.name]! +
                transaction.amount *
                    transaction.wallet.currency.value /
                    currencyGB.value;
      } else {
        // Nếu danh mục chưa có trong Map, thêm danh mục vào với số tiền hiện tại
        categoryTotals[transaction.category.name] = transaction.amount *
            transaction.wallet.currency.value /
            currencyGB.value;
      }
    }

    return categoryTotals;
  }

  Color getColorForValue(double value) {
    // value ở đây là từ 0 đến 1
    return Color.lerp(AppColors.XanhDuong, Colors.red, value) ??
        AppColors.XanhDuong;
  }


  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.Nen,
              title: Text(
                "Ngân sách",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              actions: [
                TextButton(
                    onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (newContext) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: BlocProvider.of<TransactionBloc>(
                                        context),
                                  ),
                                  BlocProvider.value(
                                    value:
                                        BlocProvider.of<ParameterBloc>(context),
                                  ),
                                  BlocProvider.value(
                                    value:
                                    BlocProvider.of<CategoryBloc>(context),
                                  ),
                                  BlocProvider.value(
                                    value:
                                    BlocProvider.of<BudgetBloc>(context),
                                  ),
                                  BlocProvider.value(
                                    value:
                                    BlocProvider.of<BudgetDetailBloc>(context),
                                  ),
                                ],
                                child: Addbudgetscreen(dateTime: _dateTime),
                              ),
                            ),
                          )
                        },
                    child: Text(
                      "Thêm",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ))
              ],
            ),
            body: Container(
              height: maxH,
              width: maxW,
              child: Column(
                children: [
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
                              int mon = _dateTime.month;
                              int yea = _dateTime.year;
                              mon = mon - 1;
                              if (mon < 1) {
                                mon = 12;
                                yea = yea - 1;
                              }
                              _dateTime = DateTime(yea, mon);
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
                            "Thg ${_dateTime.month} ${_dateTime.year}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            setState(() {
                              int mon = _dateTime.month;
                              int yea = _dateTime.year;
                              mon = mon + 1;
                              if (mon > 12) {
                                mon = 1;
                                yea = yea + 1;
                              }
                              _dateTime = DateTime(yea, mon);
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
                  Expanded(
                    child: BlocBuilder<BudgetBloc, BudgetState>(
                      builder: (context, state) {
                        if (state is BudgetUpdateState) {
                          final _budgetSelect = state.updBudget
                              .where((item) =>
                                  DateTime.parse(item.date).month ==
                                      _dateTime.month &&
                                  DateTime.parse(item.date).year ==
                                      _dateTime.year)
                              .firstOrNull;
                          if (_budgetSelect != null)
                            print("Budget: ${_budgetSelect.date}");
                          return BlocBuilder<TransactionBloc, TransactionState>(
                            builder: (context, state) {
                              if (state is TransactionChangedState) {
                                final listTran = state.newTransaction;
                                final listTrans = listTran.where((item) {
                                  DateTime tranDate = DateTime.parse(item.date);
                                  return (tranDate.year == _dateTime.year &&
                                      tranDate.month == _dateTime.month);
                                }).toList();

                                final listTransOutcome = listTrans
                                    .where((item) => item.category.type == 0)
                                    .toList();

                                return BlocBuilder<ParameterBloc,
                                    ParameterState>(
                                  builder: (context, state) {
                                    if (state is ParameterUpdateState) {
                                      final currencyGB = state.updPar.currency;
                                      Map<String, double> mapsOutcome =
                                          calculateCategoryTotals(
                                              listTransOutcome, currencyGB);

                                      return BlocBuilder<BudgetDetailBloc,
                                          BudgetDetailState>(
                                        builder: (context, state) {
                                          if (state
                                              is BudgetDetailUpdateState) {
                                            final _budgetdetList = state
                                                .updBudgetDet
                                                .where((item) =>
                                                    (_budgetSelect != null &&
                                                        item.id_budget.id ==
                                                            _budgetSelect.id));
                                            return SingleChildScrollView(
                                              child: Column(
                                                  children:
                                                      (_budgetSelect == null ||
                                                              _budgetdetList ==
                                                                  null)
                                                          ? [
                                                              Center(
                                                                  child: Text(
                                                                      "Không có dữ liệu ngân sách tháng này"))
                                                            ]
                                                          : _budgetdetList
                                                              .map(
                                                                  (item) =>
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                              padding: EdgeInsets.all(8),
                                                                              width: maxW,
                                                                              height: 100,
                                                                              color: AppColors.Nen,
                                                                              child: Column(children: [
                                                                                Column(
                                                                                  children: [
                                                                                    // SizedBox(height: 20,),
                                                                                    Container(
                                                                                      height: 25,
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Expanded(
                                                                                              flex: 1,
                                                                                              child: Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Text(
                                                                                                  item.category.name,
                                                                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                                                                                ),
                                                                                              )),
                                                                                          Expanded(
                                                                                              flex: 1,
                                                                                              child: Align(
                                                                                                alignment: Alignment.centerRight,
                                                                                                child: FittedBox(
                                                                                                  fit: BoxFit.scaleDown,
                                                                                                  child: Text(
                                                                                                    GlobalFunction.formatCurrency(item.amount, 2),
                                                                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.XanhDuong),
                                                                                                  ),
                                                                                                ),
                                                                                              ))
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 20,
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        child: LinearProgressIndicator(
                                                                                          value: (mapsOutcome[item.category.name] ?? 0) / item.amount,
                                                                                          backgroundColor: Colors.grey[200],
                                                                                          valueColor: AlwaysStoppedAnimation<Color>(
                                                                                            getColorForValue((mapsOutcome[item.category.name] ?? 0) / item.amount),
                                                                                          ),
                                                                                          minHeight: 10,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Center(
                                                                                      child: Text(
                                                                                        GlobalFunction.formatCurrency(mapsOutcome[item.category.name] ?? 0, 2),
                                                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ]))
                                                                        ],
                                                                      ))
                                                              .toList()),
                                            );
                                          } else {
                                            return Text(
                                                "Failed to load budget detail in budget");
                                          }
                                        },
                                      );
                                    } else {
                                      return Text(
                                          "Failed to load parameter in budget");
                                    }
                                  },
                                );
                              } else {
                                return Text(
                                    "Failed to load Transacion in Budget");
                              }
                            },
                          );
                        } else {
                          return Text("Failed to load budget in budget");
                        }
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
