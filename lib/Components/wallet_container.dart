import 'package:flutter/material.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';

class WalletContainer extends StatelessWidget {
  final Wallet wal;
  final double height;
  final double width;
  final bool isSelect;

  const WalletContainer(
      {super.key,
      required this.wal,
      required this.height,
      required this.width,
      required this.isSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isSelect ? Color(0xFF006A9D) : Color(0xFFCEF6FF),
          border: Border.all(
            style: BorderStyle.solid,
            color: isSelect ? AppColors.XanhDuong : Colors.black54,
            width: isSelect ? 1.5 : 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        wal.name,
                        style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontWeight:
                            FontWeight.w600,
                          color: isSelect ? Color(0xFFFFFFFF) : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        wal.note,
                        style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            color: isSelect ? Color(0xFF9EADBD) : Color(0xFF878787)),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
              child: Align(
            alignment: Alignment.center,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  GlobalFunction.formatCurrency(wal.amount, 2) +
                      " " +
                      wal.currency.name,
                  style: TextStyle(fontSize: 16, color: isSelect ? Color(0xFFD3F4FF) : AppColors.XanhDuong, fontWeight: FontWeight.w600),
                )),
          ))
        ],
      ),
    );
  }
}
