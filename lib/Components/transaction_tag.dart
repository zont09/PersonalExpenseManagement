import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';

import '../Animation/Wavepainter.dart';
import '../Screen/Transaction/detailTransaction.dart';
import '../bloc/category_bloc/category_bloc.dart';
import '../bloc/repeat_option_bloc/repeat_option_bloc.dart';
import '../bloc/transaction_bloc/transaction_bloc.dart';
import '../bloc/wallet_bloc/wallet_bloc.dart';

class TransactionTag extends StatelessWidget {
  final TransactionModel tran;
  final Currency cur;
  final double height;
  final double width;

  const TransactionTag({super.key, required this.tran, required this.cur, this.height = 200, this.width = 180});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              child: Detailtransaction(transaction: tran),
            ),
          ),
        )
      },
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Màu của shadow
              spreadRadius: 3, // Độ lan rộng của shadow
              blurRadius: 7, // Độ mờ của shadow
              offset: Offset(-5, 5), // Vị trí của shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: WavePainter(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Center(
                child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Center(
                      child: Text(
                        tran.category.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                            color: Color(0xFF002E5B)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "${tran.category.type == 0 ? "-" : "+"}${GlobalFunction.formatCurrency(tran.amount * tran.wallet.currency.value / cur.value, 2)} ${cur.name}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: tran.category.type == 0
                                    ? AppColors.Cam
                                    : AppColors.XanhLaDam),
                          )),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tran.wallet.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                          color: Color(0xFF0056B1)),
                    ),
                  )),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(tran.note,
                          softWrap: true, // Tự động xuống dòng nếu hết chiều ngang
                          overflow: TextOverflow.ellipsis, // Hiển thị dấu '...' khi không đủ không gian
                          style: TextStyle(fontSize: 16, color: Color(0xFF535354)),
                          maxLines: 4,

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
