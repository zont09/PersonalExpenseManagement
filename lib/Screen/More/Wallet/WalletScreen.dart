import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Screen/More/Wallet/addWalletScreen.dart';
import 'package:personal_expense_management/Screen/More/Wallet/detailWalletScreen.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_state.dart';
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
        title: Text(
          "Quản lý ví",
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
                              value: BlocProvider.of<WalletBloc>(context),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<ParameterBloc>(context),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CurrencyBloc>(context),
                            ),
                          ],
                          child: Addwalletscreen(),
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
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletUpdatedState) {
            final listWallet = state.updatedWallet;
            return BlocBuilder<ParameterBloc, ParameterState>(
              builder: (context, state) {
                if (state is ParameterUpdateState) {
                  final currencyGB = state.updPar.currency;
                  return Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Container(
                            height: 0.07 * maxH,
                            // color: Colors.amber,
                            child: Column(
                              children: [
                                const Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        "Tổng số dư",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                          "${GlobalFunction.formatCurrency(listWallet.first.amount * listWallet.first.currency.value / currencyGB.value, 2)} ${currencyGB.name}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.XanhDuong)),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    // Màu của shadow
                                    spreadRadius: 1,
                                    // Độ lan rộng của shadow
                                    blurRadius: 3,
                                    // Độ mờ của shadow
                                    offset:
                                        const Offset(0, 3), // Vị trí của shadow
                                  ),
                                ],
                              ),
                              child: Column(children: [
                                const SizedBox(
                                  height: 2,
                                ),
                                ...listWallet
                                    .skip(1)
                                    .map((item) => GestureDetector(
                                          onTap: () => {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (newContext) =>
                                                    MultiBlocProvider(
                                                  providers: [
                                                    BlocProvider.value(
                                                      value: BlocProvider.of<
                                                          WalletBloc>(context),
                                                    ),
                                                    BlocProvider.value(
                                                      value: BlocProvider.of<
                                                              ParameterBloc>(
                                                          context),
                                                    ),
                                                    BlocProvider.value(
                                                      value: BlocProvider.of<
                                                              CurrencyBloc>(
                                                          context),
                                                    ),
                                                  ],
                                                  child: Detailwalletscreen(
                                                      wal: item),
                                                ),
                                              ),
                                            )
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Container(
                                              height: 70,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color:
                                                              Color(0xFFDADADA),
                                                          width: 1))),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          item.name,
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "${GlobalFunction.formatCurrency(item.amount, 2)} ${item.currency.name}",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xFF787878)),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                SizedBox(
                                  height: 20,
                                )
                              ]),
                            ),
                          ))
                        ],
                      ));
                } else {
                  return Text("");
                }
              },
            );
          } else {
            return Text("Failed to load wallet in wallet screen");
          }
        },
      ),
    ));
  }
}
