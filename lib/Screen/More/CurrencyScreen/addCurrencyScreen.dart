import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Components/error_dialog.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_bloc.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_event.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_state.dart';

import '../../../Components/amount_textfield.dart';

class Addcurrencyscreen extends StatefulWidget {
  const Addcurrencyscreen({super.key});

  @override
  State<Addcurrencyscreen> createState() => _AddcurrencyscreenState();
}

class _AddcurrencyscreenState extends State<Addcurrencyscreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  String _inputAmount = "0";

  @override
  void initState() {
    super.initState();
    _controllerAmount.addListener(() {
      if (_controllerAmount.text.isNotEmpty) {
        // Lấy giá trị nguyên bản từ chuỗi mà không có định dạng
        print("Change ${_inputAmount}");
        _inputAmount =
            _controllerAmount.text.replaceAll('.', '').replaceAll(',', '.');
      }
    });
  }

  void _saveNewCurrency(BuildContext context, List<Currency> listCur) async {
    if (_controllerName.text.length <= 0) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập đơn vị tiền tệ");
    }
    else if (listCur.any((item) => item.name == _controllerName.text)) {
      ErrorDialog.showErrorDialog(context, "Đơn vị tiền tệ đã tồn tại");
    }
    else if (double.parse(_inputAmount) <= 0) {
      print("Gia tri input: ${_inputAmount}");
      print("Gia tri controller: ${_controllerAmount.text}");
      ErrorDialog.showErrorDialog(context, "Giá trị mệnh giá không hợp lệ");
    }
    else {
      Currency newCur = Currency(
          name: _controllerName.text, value: double.parse(_inputAmount));
      context.read<CurrencyBloc>().add(AddCurrencyEvent(newCur));
      context
          .read<CurrencyBloc>()
          .stream
          .listen((state) async {
        if (state is CurrencyUpdateState) {
          print("Add budgetdetail successful");
          await Future.delayed(Duration(milliseconds: 500));
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final double maxH = MediaQuery.of(context).size.height;
    final double maxW = MediaQuery.of(context).size.width;
    return SafeArea(child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.Nen,
          title: Text("Thêm tiền tệ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        ),
          body: Container(
            margin: EdgeInsets.only(top: 10),
            height: maxH,
            width: maxW,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: AppColors.Nen,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 50,
                          width: 80,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Đơn vị",
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controllerName,
                            maxLines: null,
                            minLines: 1,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Đơn vị tiền tệ',
                            ),
                            onChanged: (value) {
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: AppColors.Nen,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 50,
                          width: 80,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Mệnh giá",
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        Expanded(
                          child: AmountTextfield(controllerTF: _controllerAmount, isEdit: true, hintText: "Nhập mệnh giá",),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: BlocBuilder<CurrencyBloc, CurrencyState>(
            builder: (context, state) {
              if(state is CurrencyUpdateState) {
                final listCur = state.updCur;
                return Container(
                  margin: EdgeInsets.only(bottom: 10,),
                  height: 50,
                  width: maxW,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.XanhDuong,
                        side: BorderSide(
                          color: AppColors.XanhDuong,
                          width: 2.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12), // Độ bo góc của viền
                        ),
                      ),
                      onPressed: () =>
                      {
                        _saveNewCurrency(context, listCur)
                      },
                      child: Center(
                        child: Text(
                          "Lưu",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                );
              }
              else {
                return Text("Failed to load currency in add currency");
              }
  },
),
          )
      ),
    ));
  }
}
