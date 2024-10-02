import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';

import '../Resources/AppColor.dart';
import '../Resources/global_function.dart';
import '../Screen/Transaction/detailTransaction.dart';
import '../bloc/category_bloc/category_bloc.dart';
import '../bloc/repeat_option_bloc/repeat_option_bloc.dart';
import '../bloc/transaction_bloc/transaction_bloc.dart';
import '../bloc/wallet_bloc/wallet_bloc.dart';

class TransactionTag2 extends StatelessWidget {
  final TransactionModel tran;
  final Currency cur;
  const TransactionTag2({super.key, required this.tran, required this.cur});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height:
          2,
        ),
        Container(
          height:
          60,
          color:
          Color(0xFFF2FBFF).withOpacity(0.5),
          child:
          InkWell(
            onTap: () =>
            {
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
                    child: Detailtransaction(transaction: tran),
                  ),
                ),
              )
            },
            child:
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(tran.category.name,
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
                              tran.note,
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
                              tran.wallet.name,
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
                          tran.category.type == 0 ? "-" + GlobalFunction.formatCurrency(tran.amount * tran.wallet.currency.value / cur.value, 2) + " " + cur.name : "+" + GlobalFunction.formatCurrency(tran.amount * tran.wallet.currency.value / cur.value, 2) + " " + cur.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: tran.category.type == 0 ? AppColors.Cam : AppColors.XanhLaDam,
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
    );
  }
}
