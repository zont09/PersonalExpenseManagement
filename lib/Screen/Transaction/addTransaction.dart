import 'package:flutter/material.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';

class Addtransaction extends StatefulWidget {
  const Addtransaction({super.key});

  @override
  State<Addtransaction> createState() => _AddtransactionState();
}

class _AddtransactionState extends State<Addtransaction> {
  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Thêm giao dịch",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              backgroundColor: AppColors.Nen,
              leading: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Hủy",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        // height: 100,
                        color: AppColors.Nen,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  
                                  child: InkWell(
                                    
                                  ),
                                  // decoration: DecoratedBox(decoration: decoration),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  height: 50,
                  width: maxW,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.XanhDuong,
                        side: BorderSide(
                          color: AppColors.XanhDuong,
                          width: 2.0, // Độ dày của viền
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Độ bo góc của viền
                        ),
                      ),
                      onPressed: () => {},
                      child: Center(
                        child: Text(
                          "Lưu",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                )
              ],
            )));
  }
}
