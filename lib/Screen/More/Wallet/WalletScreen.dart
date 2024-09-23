import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Screen/More/Wallet/addWalletScreen.dart';
import 'package:personal_expense_management/Screen/More/Wallet/detailWalletScreen.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';

import '../../../Resources/global_function.dart';

class Walletscreen extends StatefulWidget {
  const Walletscreen({super.key});

  @override
  State<Walletscreen> createState() => _WalletscreenState();
}

class _WalletscreenState extends State<Walletscreen> {
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
            title: Text(
              "Quản lý ví",
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
                              value: BlocProvider.of<WalletBloc>(
                                  context),
                            ),
                            BlocProvider.value(
                              value:
                              BlocProvider.of<ParameterBloc>(context),
                            ),
                            BlocProvider.value(
                              value:
                              BlocProvider.of<CurrencyBloc>(context),
                            ),
                          ],
                          child: Addwalletscreen(),
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
          body: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if(state is WalletUpdatedState) {
                final listWallet = state.updatedWallet;
                return Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Container(
                          height: 0.07 * maxH,
                          // color: Colors.amber,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text("Tổng số dư", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text("${GlobalFunction.formatCurrency(listWallet.first.amount, 2)}", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.XanhDuong)),
                                  ))
                            ],
                          ),
                        ),
                        Expanded(child: SingleChildScrollView(
                          child: Column(
                            children: listWallet.skip(1).map((item) =>
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (newContext) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value: BlocProvider.of<WalletBloc>(
                                                  context),
                                            ),
                                            BlocProvider.value(
                                              value:
                                              BlocProvider.of<ParameterBloc>(context),
                                            ),
                                            BlocProvider.value(
                                              value:
                                              BlocProvider.of<CurrencyBloc>(context),
                                            ),
                                          ],
                                          child: Detailwalletscreen(wal: item),
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
                                                child: Text("${GlobalFunction.formatCurrency(item.amount, 2)} ${item.currency.name}", style: TextStyle(
                                                    fontSize: 18, color: Color(0xFF787878)),),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ).toList(),
                          ),
                        ))
                      ],
                    ));
              }
              else {
                return Text("Failed to load wallet in wallet screen");
              }
            },
          ),
        ));
  }
}
