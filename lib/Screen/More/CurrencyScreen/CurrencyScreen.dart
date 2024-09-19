import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/Screen/More/CurrencyScreen/addCurrencyScreen.dart';
import 'package:personal_expense_management/Screen/More/CurrencyScreen/detailCurrencyScreen.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_state.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';

class Currencyscreen extends StatefulWidget {
  const Currencyscreen({super.key});

  @override
  State<Currencyscreen> createState() => _CurrencyscreenState();
}

class _CurrencyscreenState extends State<Currencyscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Nen,
        title: Text(
          "Tiền tệ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (newContext) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: BlocProvider.of<CurrencyBloc>(
                              context),
                        ),
                        BlocProvider.value(
                          value:
                          BlocProvider.of<ParameterBloc>(context),
                        ),
                      ],
                      child: Addcurrencyscreen(),
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
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.only(top: 16),
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, state) {
            if(state is CurrencyUpdateState) {
              final listCurrency = state.updCur;
              return Column(
                children: listCurrency.map((item) =>
                    GestureDetector(
                      onTap: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (newContext) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: BlocProvider.of<CurrencyBloc>(
                                      context),
                                ),
                                BlocProvider.value(
                                  value:
                                  BlocProvider.of<ParameterBloc>(context),
                                ),
                              ],
                              child: Detailcurrencyscreen(cur: item),
                            ),
                          ),
                        )
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        color: AppColors.Nen,
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: Color(0xFFDADADA), width: 1))),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(item.name, style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("1 ~ ${GlobalFunction.formatCurrency(item.value, 2)}", style: TextStyle(
                                        fontSize: 18, color: Color(0xFF787878)),),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )
                ).toList(),
              );
            }
            else {
              return Text("Failed to load currency in currency screen");
            }
  },
),
      ),
    ));
  }
}
