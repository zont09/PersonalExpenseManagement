import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/Screen/More/SavingScreen/addSavingScreen.dart';
import 'package:personal_expense_management/Screen/More/SavingScreen/detailSavingScreen.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_state.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_state.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';

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
      days += DateTime(previousMonth.year, previousMonth.month + 1, 0)
          .day; // Lấy ngày cuối cùng của tháng trước đó
    }
    if (years == 0) {
      if (months == 0) return '$days ngày';
      return '$months tháng, $days ngày';
    }
    return '$years năm, $months tháng, $days ngày';
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height;
    final maxW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFf339DD4), Color(0xFF00D0CC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight, // Điểm kết thúc của gradient
            ),
          ),
        ),
        title: const Text(
          "Khoản tiết kiệm",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (newContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: BlocProvider.of<SavingBloc>(context),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SavingDetailBloc>(context),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<WalletBloc>(context),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CurrencyBloc>(context),
                            ),
                          ],
                          child: Addsavingscreen(),
                        ),
                      ),
                    )
                  },
              child: Text(
                "Thêm",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ))
        ],
      ),
      body: Container(
        height: maxH,
        width: maxW,
        color: Colors.white,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<SavingBloc, SavingState>(
                builder: (context, state) {
                  if (state is SavingUpdateState) {
                    final listSaving = state.updSaving;
                    print(listSaving.length);
                    return BlocBuilder<ParameterBloc, ParameterState>(
                      builder: (context, state) {
                        if(state is ParameterUpdateState) {
                          final currencyGB = state.updPar.currency;
                          return SingleChildScrollView(
                            child: Column(
                              children: listSaving
                                  .map((item) =>
                                  GestureDetector(
                                    onTap: () =>
                                    {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (newContext) =>
                                              MultiBlocProvider(
                                                providers: [
                                                  BlocProvider.value(
                                                    value: BlocProvider.of<
                                                        SavingBloc>(context),
                                                  ),
                                                  BlocProvider.value(
                                                    value: BlocProvider.of<
                                                        SavingDetailBloc>(
                                                        context),
                                                  ),
                                                  BlocProvider.value(
                                                    value: BlocProvider.of<
                                                        WalletBloc>(context),
                                                  ),
                                                  BlocProvider.value(
                                                    value: BlocProvider.of<
                                                        CurrencyBloc>(context),
                                                  ),
                                                ],
                                                child:
                                                Detailsavingscreen(sav: item),
                                              ),
                                        ),
                                      )
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 100,
                                          width: maxW,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                // Màu của shadow
                                                spreadRadius: 1,
                                                // Độ lan rộng của shadow
                                                blurRadius: 3,
                                                // Độ mờ của shadow
                                                offset: const Offset(0,
                                                    3), // Vị trí của shadow
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
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
                                                            item.name,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          )),
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
                                                                      2)} ${item.currency.name}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      color: AppColors
                                                                          .XanhDuong),
                                                                )),
                                                          )),
                                                    ],
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            DateFormat(
                                                                'dd/MM/yyyy')
                                                                .format(DateTime
                                                                .parse(item
                                                                .target_date)),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  item
                                                                      .is_finished ==
                                                                      1
                                                                      ? "Đã xong"
                                                                      : calculateDateDifference(
                                                                      DateTime
                                                                          .now(),
                                                                      DateTime
                                                                          .parse(
                                                                          item
                                                                              .target_date)),
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                  ),
                                                                )),
                                                          )),
                                                    ],
                                                  )),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: 10,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    child:
                                                    LinearProgressIndicator(
                                                      value: item
                                                          .current_amount /
                                                          item.target_amount,
                                                      backgroundColor:
                                                      Colors.grey[200],
                                                      valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                        Colors.blue,
                                                      ),
                                                      minHeight: 10,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                  .toList(),
                            ),
                          );
                        }
                        else return Text("");
                      },
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
