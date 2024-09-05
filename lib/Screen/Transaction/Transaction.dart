import 'package:flutter/material.dart';
import 'package:personal_expense_management/Components/dropdown.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});
  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;
    final maxH = MediaQuery.of(context).size.height;
    return  Container(
      height: maxH,
      width: maxW,
      // color: Colors.amber,
      child: Column(
        children: [
          Container(
            height: 0.1 * maxH,
            // color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 96,),
                Column (
                  children: [
                    Text("Số dư"),
                    Text("22.092.004", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.XanhDuong),),
                    DropdownMenuW(items: <String>["Tien mat", "VCB", "MB", "VIP", "Viecombankneee"], height: 0.04 * maxH, width: 0.25 * maxW)
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => {},
                        icon: Icon(Icons.search, size: 30,),
                    ),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(Icons.more_vert, size: 32),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
