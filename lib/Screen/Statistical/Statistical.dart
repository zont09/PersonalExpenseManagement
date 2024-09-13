import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset_box_shadow;
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_state.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_state.dart';

class Statistical extends StatefulWidget {
  const Statistical({super.key});

  @override
  State<Statistical> createState() => _StatisticalState();
}

class _StatisticalState extends State<Statistical> {
  int _dateOptionView = 0;
  DateTime _dateOption = DateTime.now();
  int touchedIndexIn = -1;
  int touchedIndexOut = -1;
  String labelIncome = "Tổng";
  String labelOutcome = "Tổng";

  Future<void> _selectDate(BuildContext context, String? locale) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _dateOption ?? DateTime.now(),
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
        _dateOption = selected;
      });
    }
  }

  List<PieChartSectionData> getSections(Map<String, double> dataChart, int touchedIndex) {
    double totalValue =
        dataChart.isNotEmpty ? dataChart.values.reduce((a, b) => a + b) : 0.0;
    return dataChart.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      print("Entry key: ${entry.value.key}");
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 60 : 50;

      return PieChartSectionData(
        value: data.value,
        color: AppColors.chartColors[index % 20],
        title: (data.value / totalValue * 100) > 3
            ? '${(data.value / totalValue * 100).toStringAsFixed(1)}%'
            : "",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Map<String, double> calculateCategoryTotals(List<TransactionModel> transactions, Currency currencyGB) {
    Map<String, double> categoryTotals = {};
    for (var transaction in transactions) {
      // Nếu danh mục đã có trong Map, cộng số tiền vào tổng hiện tại
      if (categoryTotals.containsKey(transaction.category.name)) {
        categoryTotals[transaction.category.name] =
            categoryTotals[transaction.category.name]! + transaction.amount * transaction.wallet.currency.value / currencyGB.value;
      } else {
        // Nếu danh mục chưa có trong Map, thêm danh mục vào với số tiền hiện tại
        categoryTotals[transaction.category.name] = transaction.amount * transaction.wallet.currency.value / currencyGB.value;
      }
    }

    return categoryTotals;
  }

  Map<int, double> calculateDateTotals(List<TransactionModel> transactions, Currency currencyGB, int typeCat) {
    final Map<int, double> dayToAmountMap = {};
    int daysInMonth = DateUtils.getDaysInMonth(_dateOption.year, _dateOption.month);
    for (int day = 1; day <= ((_dateOptionView == 0) ? daysInMonth : 12); day++) {
      dayToAmountMap[day] = 0.0;
    }
    for (var tran in transactions) {
      if(tran.category.type != typeCat) continue;
      final day = (_dateOptionView == 0) ? DateTime.parse(tran.date).day : DateTime.parse(tran.date).month;
      if (dayToAmountMap.containsKey(day)) {
        dayToAmountMap[day] = dayToAmountMap[day]! + tran.amount * tran.wallet.currency.value / currencyGB.value;
      } else {
        dayToAmountMap[day] = tran.amount * tran.wallet.currency.value / currencyGB.value;
      }
    }

    return dayToAmountMap;
  }

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.width;
    return SafeArea(
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionChangedState) {
            final listTran = state.newTransaction;
            final listTrans = listTran.where((item) {
              DateTime tranDate = DateTime.parse(item.date);
              return (tranDate.year == _dateOption.year &&
                  (_dateOptionView == 1 ||
                      tranDate.month == _dateOption.month));
            }).toList();

            return BlocBuilder<ParameterBloc, ParameterState>(
              builder: (context, state) {
                if(state is ParameterUpdateState) {
                  final currencyGB = state.updPar.currency;
                  final listTransIncome =
                  listTrans.where((item) => item.category.type == 1).toList();
                  final listTransOutcome =
                  listTrans.where((item) => item.category.type == 0).toList();
                  Map<String, double> mapsIncome =
                  calculateCategoryTotals(listTransIncome, currencyGB);
                  Map<String, double> mapsOutcome =
                  calculateCategoryTotals(listTransOutcome, currencyGB);
                  double totalIncome = mapsIncome.isNotEmpty
                      ? mapsIncome.values.reduce((a, b) => a + b)
                      : 0.0;
                  double totalOutcome = mapsOutcome.isNotEmpty
                      ? mapsOutcome.values.reduce((a, b) => a + b)
                      : 0.0;
                  List<MapEntry<String, double>> listIncome =
                  mapsIncome.entries.toList();
                  List<MapEntry<String, double>> listOutcome =
                  mapsOutcome.entries.toList();

                  Map<int, double> listIncomeRp = calculateDateTotals(listTrans, currencyGB, 1);
                  Map<int, double> listOutcomeRp = calculateDateTotals(listTrans, currencyGB, 0);
                  print("Lenght: ${listOutcomeRp.length}");
                  double maxValue = 0;
                  listIncomeRp.forEach((key, value) {
                    maxValue = max(value, maxValue);
                    print("item ${value}");
                  });
                  listOutcomeRp.forEach((key, value) {
                    maxValue = max(value, maxValue);
                  });
        print("Max value: $maxValue");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 0.05 * maxH,
                          width: 0.8 * maxW,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black, // Màu viền
                              width: 1, // Độ dày viền
                            ),
                          ),
                          child: DefaultTabController(
                            length: 2,
                            child: PrimaryContainer(
                              radius: 10,
                              child: Center(
                                child: TabBar(
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorColor: Colors.transparent,
                                  dividerColor: Colors.transparent,
                                  labelColor: Colors.white,
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight
                                        .bold, // Chỉnh kiểu chữ nếu muốn
                                  ),
                                  unselectedLabelColor: Colors.black,
                                  // Màu chữ cho tab không được chọn
                                  unselectedLabelStyle: const TextStyle(
                                    fontWeight: FontWeight
                                        .bold, // Chỉnh kiểu chữ nếu muốn
                                  ),
                                  indicator: inset_box_shadow.BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0XFF8dc6e3),
                                        Color(0xFF339DD4),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                  tabs: const [
                                    Tab(
                                      text: 'Tháng',
                                    ),
                                    Tab(
                                      text: 'Năm',
                                    ),
                                  ],
                                  onTap: (index) {
                                    print("Index $index");
                                    setState(() {
                                      _dateOptionView = index;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 0.05 * maxH,
                        color: AppColors.Nen,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () =>
                              {
                                setState(() {
                                  int mon = _dateOption.month;
                                  int yea = _dateOption.year;
                                  if(_dateOptionView == 0) {
                                    mon = mon - 1;
                                    if (mon < 1) {
                                      mon = 12;
                                      yea = yea - 1;
                                    }
                                    _dateOption = DateTime(yea, mon);
                                  }
                                  else {
                                    _dateOption = DateTime(yea-1, mon);
                                  }
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
                              onPressed: () => {
                                if(_dateOptionView == 0)
                                  _selectDate(context, 'vi')
                              },
                              child: Text(
                                _dateOptionView == 0 ?
                                "Thg ${_dateOption.month} ${_dateOption.year}" :
                                _dateOption.year.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                              {
                                setState(() {
                                  int mon = _dateOption.month;
                                  int yea = _dateOption.year;
                                  if(_dateOptionView == 0) {
                                    mon = mon + 1;
                                    if (mon > 12) {
                                      mon = 1;
                                      yea = yea + 1;
                                    }
                                    _dateOption = DateTime(yea, mon);
                                  }
                                  else {
                                    _dateOption = DateTime(yea + 1, mon);
                                  }
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
                          child: Column(
                            children: [
                              Container(
                                height: 0.5 * maxH,
                                width: maxW,
                                color: AppColors.Nen,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Báo cáo thu chi",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(bottom: 20),
                                                width: 30,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: List.generate(
                                                    6,
                                                        (index) {
                                                      // Các giá trị trục Y (từ 0 đến maxY)
                                                      final value =(5 - index) * (maxValue / 5).floor();
                                                      return Text(
                                                        GlobalFunction.shortMoney(value.toDouble()),
                                                        style: TextStyle(fontSize: 11, color: Colors.black),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Container(
                                                    width: _dateOptionView == 0 ? GlobalFunction.getDaysInMonth(_dateOption.year, _dateOption.month) * 40.0 : 480,
                                                    height: 0.4 * maxH,
                                                    child: BarChart(
                                                      BarChartData(
                                                        barGroups: listIncomeRp.entries.map((item) {
                                                          return
                                                            BarChartGroupData(
                                                              x: item.key,
                                                              barRods: [
                                                                BarChartRodData(
                                                                  toY: item.value,
                                                                  color: AppColors
                                                                      .XanhLaDam,
                                                                  width: 15,
                                                                  borderRadius:
                                                                  BorderRadius.zero,
                                                                ),
                                                                BarChartRodData(
                                                                  toY: listOutcomeRp[item.key]!,
                                                                  color: AppColors.Cam,
                                                                  width: 15,
                                                                  borderRadius:
                                                                  BorderRadius.zero,
                                                                ),
                                                              ],
                                                            );
                                                        }
                                                        ).toList(),
                                                        titlesData: FlTitlesData(
                                                          leftTitles: AxisTitles(
                                                            sideTitles:
                                                            SideTitles(
                                                                showTitles: false),
                                                          ),
                                                          rightTitles: AxisTitles(
                                                            sideTitles:
                                                            SideTitles(
                                                                showTitles: false),
                                                          ),
                                                          topTitles: AxisTitles(
                                                            sideTitles:
                                                            SideTitles(
                                                                showTitles: false),
                                                          ),
                                                          bottomTitles: AxisTitles(
                                                            sideTitles: SideTitles(
                                                              showTitles: true,
                                                              getTitlesWidget: (
                                                                  double value,
                                                                  TitleMeta meta) {
                                                                return Text(value.toInt().toString());
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        borderData: FlBorderData(
                                                          show: true,
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: Colors.black, // Màu của đường viền bên trái
                                                              width: 1, // Độ dày của đường viền
                                                            ),
                                                            bottom: BorderSide(
                                                              color: Colors.black, // Màu của đường viền dưới cùng
                                                              width: 1, // Độ dày của đường viền
                                                            ),
                                                            right: BorderSide.none, // Ẩn viền bên phải
                                                            top: BorderSide.none,   // Ẩn viền trên
                                                          ),
                                                        ),
                                                          gridData: FlGridData(
                                                            show: true,
                                                            drawVerticalLine: true,
                                                            drawHorizontalLine: true,
                                                            getDrawingHorizontalLine: (value) {
                                                              return FlLine(
                                                                color: Colors.grey,
                                                                strokeWidth: 0.5,
                                                              );
                                                            },
                                                            getDrawingVerticalLine: (value) {
                                                              return FlLine(
                                                                color: Colors.grey,
                                                                strokeWidth: 0.5,
                                                              );
                                                            },
                                                          ),
                                                        barTouchData: BarTouchData(
                                                          touchTooltipData: BarTouchTooltipData(
                                                            getTooltipColor: (group) {
                                                              return AppColors.XanhDuong;
                                                            },
                                                            tooltipMargin: 8, // Khoảng cách giữa tooltip và cột
                                                            fitInsideHorizontally: true, // Đảm bảo tooltip không vượt ra ngoài màn hình theo chiều ngang
                                                            fitInsideVertically: true, // Đảm bảo tooltip không vượt ra ngoài màn hình theo chiều dọc
                                                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                              return BarTooltipItem(
                                                                GlobalFunction.formatCurrency(rod.toY, 2) + " " + currencyGB.name,
                                                                TextStyle(color: Colors.white),
                                                              );
                                                            },
                                                          ),
                                                          touchCallback: (event, response) {
                                                            if (response != null && response.spot != null) {
                                                              print('Touched spot at x: ${response.spot!.touchedBarGroupIndex}, y: ${response.spot!.touchedRodData.toY}');
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IntrinsicHeight(
                                child: Container(
                                  width: maxW,
                                  color: AppColors.Nen,
                                  // color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Thống kê thu",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Container(
                                        height: 0.4 * maxH,
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              listIncome.isEmpty
                                                  ? Center(
                                                child: Text(
                                                    "Không có dữ liệu"),
                                              )
                                                  : Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 40,
                                                    right: 40,
                                                    top: 20,
                                                    bottom: 20),
                                                child: PieChart(
                                                  PieChartData(
                                                    sections: getSections(
                                                        mapsIncome,
                                                        touchedIndexIn),
                                                    pieTouchData:
                                                    PieTouchData(
                                                      touchCallback:
                                                          (FlTouchEvent
                                                      event,
                                                          pieTouchResponse) {
                                                        setState(() {
                                                          if (!event
                                                              .isInterestedForInteractions ||
                                                              pieTouchResponse ==
                                                                  null ||
                                                              pieTouchResponse
                                                                  .touchedSection ==
                                                                  null) {
                                                            touchedIndexIn =
                                                            -1;
                                                            return;
                                                          }
                                                          touchedIndexIn =
                                                              pieTouchResponse
                                                                  .touchedSection!
                                                                  .touchedSectionIndex;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              listIncome.isEmpty
                                                  ? Center(
                                                child: Text(
                                                    "Không có dữ liệu"),
                                              )
                                                  : Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  SizedBox(
                                                    width: 0.5 * maxW,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      // Thu nhỏ chữ nếu vượt quá không gian
                                                      child: Text(
                                                        touchedIndexIn == -1
                                                            ? "Tổng"
                                                            : listIncome[
                                                        touchedIndexIn]
                                                            .key,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 0.5 * maxW,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        touchedIndexIn == -1
                                                            ? GlobalFunction
                                                            .formatCurrency(
                                                            totalIncome,
                                                            2) + ' ' + currencyGB.name
                                                            : '${GlobalFunction
                                                            .formatCurrency(
                                                            getSections(
                                                                mapsIncome,
                                                                touchedIndexIn)[touchedIndexIn]
                                                                .value, 2)}'+ ' ' + currencyGB.name,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                      ...listIncome
                                          .asMap()
                                          .entries
                                          .map((item) =>
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 0,
                                                bottom: 16,
                                                left: 16,
                                                right: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.square,
                                                          color: AppColors
                                                              .chartColors[
                                                          item.key],
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          item.value.key,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis),
                                                        )
                                                      ],
                                                    )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Align(
                                                      alignment:
                                                      Alignment.centerLeft,
                                                      child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            GlobalFunction
                                                                .formatCurrency(
                                                                item.value
                                                                    .value,
                                                                2)+ ' ' + currencyGB.name,
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          )),
                                                    ))
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IntrinsicHeight(
                                child: Container(
                                  width: maxW,
                                  color: AppColors.Nen,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Thống kê chi",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Container(
                                        height: 0.4 * maxH,
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              listOutcome.isEmpty
                                                  ? Center(
                                                child: Text(
                                                    "Không có dữ liệu"),
                                              )
                                                  : Padding(
                                                padding: EdgeInsets.all(16),
                                                child: PieChart(
                                                  PieChartData(
                                                    sections: getSections(
                                                        mapsOutcome,
                                                        touchedIndexOut),
                                                    pieTouchData:
                                                    PieTouchData(
                                                      touchCallback:
                                                          (FlTouchEvent
                                                      event,
                                                          pieTouchResponse) {
                                                        setState(() {
                                                          if (!event
                                                              .isInterestedForInteractions ||
                                                              pieTouchResponse ==
                                                                  null ||
                                                              pieTouchResponse
                                                                  .touchedSection ==
                                                                  null) {
                                                            touchedIndexOut =
                                                            -1;
                                                            return;
                                                          }
                                                          touchedIndexOut =
                                                              pieTouchResponse
                                                                  .touchedSection!
                                                                  .touchedSectionIndex;
                                                          print(
                                                              "touched index ${touchedIndexOut}");
                                                          print(
                                                              "Value index ${touchedIndexOut !=
                                                                  -1
                                                                  ? getSections(
                                                                  mapsOutcome,
                                                                  touchedIndexOut)[touchedIndexOut]
                                                                  .value
                                                                  : 00} ");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              listOutcome.isEmpty
                                                  ? Center(
                                                child: Text(
                                                    "Không có dữ liệu"),
                                              )
                                                  : Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  SizedBox(
                                                    width: 0.5 * maxW,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      // Thu nhỏ chữ nếu vượt quá không gian
                                                      child: Text(
                                                        touchedIndexOut ==
                                                            -1
                                                            ? "Tổng"
                                                            : listOutcome[
                                                        touchedIndexOut]
                                                            .key,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 0.5 * maxW,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        touchedIndexOut ==
                                                            -1
                                                            ? GlobalFunction
                                                            .formatCurrency(
                                                            totalOutcome,
                                                            2)+ ' ' + currencyGB.name
                                                            : '${GlobalFunction
                                                            .formatCurrency(
                                                            getSections(
                                                                mapsOutcome,
                                                                touchedIndexOut)[touchedIndexOut]
                                                                .value, 2)}'+ ' ' + currencyGB.name,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                      ...listOutcome
                                          .asMap()
                                          .entries
                                          .map((item) =>
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 0,
                                                bottom: 16,
                                                left: 16,
                                                right: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.square,
                                                          color: AppColors
                                                              .chartColors[
                                                          item.key],
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          item.value.key,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis),
                                                        )
                                                      ],
                                                    )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Align(
                                                      alignment:
                                                      Alignment.centerLeft,
                                                      child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            GlobalFunction
                                                                .formatCurrency(
                                                                item.value
                                                                    .value,
                                                                2)+ ' ' + currencyGB.name,
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          )),
                                                    ))
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  );
                }
                else {
                  return Text("Failed to load parameter in Statistical");
                }
              },
            );
          } else {
            return Text("Failed to load transaction in Statistical");
          }
        },
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;

  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inset_box_shadow.BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: [
          inset_box_shadow.BoxShadow(
            color: color ?? const Color(0xFFFEFFFA),
          ),
          const inset_box_shadow.BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0xFFFEFFFA),
            inset: true,
          ),
        ],
      ),
      child: child,
    );
  }
}
