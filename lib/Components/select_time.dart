import 'package:flutter/material.dart';
import 'package:personal_expense_management/Components/month_picker.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';

class SelectTime extends StatelessWidget {
  final int dateOptionView;
  final DateTime dateOption;
  final Function(DateTime) changed;
  const SelectTime({super.key, this.dateOptionView = 0, required this.dateOption, required this.changed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.05 * MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Màu của shadow
            spreadRadius: 2,                     // Độ lan rộng của shadow
            blurRadius: 7,                       // Độ mờ của shadow
            offset: Offset(5, 5),                // Vị trí của shadow
          ),
        ],
        color: Colors.white,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: ()  {

              int mon = dateOption.month;
              int yea = dateOption.year;
              if (dateOptionView == 0) {
                mon = mon - 1;
                if (mon < 1) {
                  mon = 12;
                  yea = yea - 1;
                }
                changed(DateTime(yea, mon));

              } else {
                changed(DateTime(yea - 1, mon));
              }

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
            onPressed: () =>
            {if (dateOptionView == 0) openMonthPicker(context, 'vi', dateOption, changed)},
            child: Text(
              dateOptionView == 0
                  ? "Thg ${dateOption.month} ${dateOption.year}"
                  : dateOption.year.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
          IconButton(
            onPressed: ()  {
                int mon = dateOption.month;
                int yea = dateOption.year;
                if (dateOptionView == 0) {
                  mon = mon + 1;
                  if (mon > 12) {
                    mon = 1;
                    yea = yea + 1;
                  }
                  changed(DateTime(yea, mon));
                } else {
                  changed( DateTime(yea + 1, mon));
                }
            },
            icon: const Icon(
              Icons.keyboard_arrow_right,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

