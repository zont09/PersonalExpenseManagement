import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/Screen/More/SavingScreen/addSavingScreen.dart';
import 'package:personal_expense_management/Screen/More/SavingScreen/detailSavingScreen.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_state.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_bloc.dart';

class Savingscreen extends StatefulWidget {
  const Savingscreen({super.key});

  @override
  State<Savingscreen> createState() => _SavingscreenState();
}

class _SavingscreenState extends State<Savingscreen> {
  DateTime _dateTime = DateTime.now();
  String calculateDateDifference(DateTime startDate, DateTime endDate) {
    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;
    int days = endDate.day - startDate.day;

    // Điều chỉnh nếu tháng của endDate nhỏ hơn startDate
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    // Điều chỉnh nếu ngày của endDate nhỏ hơn startDate
    if (days < 0) {
      months -= 1;
      // Tính lại số ngày dựa vào tháng trước đó
      DateTime previousMonth = DateTime(endDate.year, endDate.month - 1);
      days += DateTime(previousMonth.year, previousMonth.month + 1, 0).day; // Lấy ngày cuối cùng của tháng trước đó
    }
    if(years == 0) {
      if(months == 0) return '$days ngày';
      return '$months tháng, $days ngày';
    }
    return '$years năm, $months tháng, $days ngày';
  }
  Future<void> _selectDate(BuildContext context,
      String? locale,) async {
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
        _dateTime = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery
        .of(context)
        .size
        .height;
    final maxW = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.Nen,
            title: const Text(
              "Khoản tiết kiệm",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (newContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: BlocProvider.of<SavingBloc>(
                                  context),
                            ),
                            BlocProvider.value(
                              value:
                              BlocProvider.of<SavingDetailBloc>(context),
                            ),

                          ],
                          child: Addsavingscreen(),
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
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: BlocBuilder<SavingBloc, SavingState>(
                    builder: (context, state) {
                      if (state is SavingUpdateState) {
                        final listSaving = state.updSaving;
                        return SingleChildScrollView(
                          child: Column(
                            children: listSaving.map((item) =>
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (newContext) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value: BlocProvider.of<SavingBloc>(
                                                  context),
                                            ),
                                            BlocProvider.value(
                                              value:
                                              BlocProvider.of<SavingDetailBloc>(context),
                                            ),

                                          ],
                                          child: Detailsavingscreen(sav: item),
                                        ),
                                      ),
                                    )
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Container(
                                        height: 100,
                                        width: maxW,
                                        color: AppColors.Nen,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: FittedBox(
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              child: Text(
                                                                "${GlobalFunction
                                                                    .formatCurrency(
                                                                    item
                                                                        .current_amount,
                                                                    2)}/${GlobalFunction
                                                                    .formatCurrency(
                                                                    item
                                                                        .target_amount,
                                                                    2)}",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: AppColors
                                                                        .XanhDuong),)),
                                                        )
                                                    ),
                                                  ],
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          DateFormat('dd/MM/yyyy').format(DateTime.parse(item.target_date)), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: FittedBox(
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              child: Text(
                                                                item.is_finished == 1 ? "Đã xong" :
                                                                calculateDateDifference(DateTime.now(), DateTime.parse(item.target_date)),
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    ),)),
                                                        )
                                                    ),
                                                  ],
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: 10,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                  child: LinearProgressIndicator(
                                                    value: item.current_amount/item.target_amount,
                                                    backgroundColor: Colors
                                                        .grey[200],
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(
                                                      Colors.blue,
                                                    ),
                                                    minHeight: 10,
                                                  ),
                                                ),
                                              ),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ).toList(),
                          ),
                        );
                      } else {
                        return Text("");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
