import 'package:flutter/material.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:month_year_picker/month_year_picker.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime _dateTime = DateTime.now();

  Future<void> _selectDate(
    BuildContext context,
    String? locale,
  ) async {
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
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
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
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.Nen,
              title: Text(
                "Ngân sách",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              actions: [
                TextButton(
                    onPressed: () => {},
                    child: Text(
                      "Thêm",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ))
              ],
            ),
            body: Container(
              height: maxH,
              width: maxW,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 0.05 * maxH,
                    color: AppColors.Nen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => {
                            setState(() {
                              int mon = _dateTime.month;
                              int yea = _dateTime.year;
                              mon = mon - 1;
                              if (mon < 1) {
                                mon = 12;
                                yea = yea - 1;
                              }
                              _dateTime = DateTime(yea, mon);
                            })
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
                          onPressed: () => {_selectDate(context, 'vi')},
                          child: Text(
                            "Thg ${_dateTime.month} ${_dateTime.year}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            setState(() {
                              int mon = _dateTime.month;
                              int yea = _dateTime.year;
                              mon = mon + 1;
                              if (mon > 12) {
                                mon = 1;
                                yea = yea + 1;
                              }
                              _dateTime = DateTime(yea, mon);
                            })
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_right,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(8),
                              width: maxW,
                              height: 100,
                              color: AppColors.Nen,
                              child: Column(
                                children: [
                                  Container(
                                    height: 25,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                            child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Ăn uống",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        )),
                                        Expanded(
                                          flex: 1,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "50.000.000",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.XanhDuong),
                                                ),
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    height: 20,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: 0.229,
                                        backgroundColor: Colors.grey[200],
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                        minHeight: 10,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Center(child: Text("15.000.000", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),)
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
