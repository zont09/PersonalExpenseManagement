import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_state.dart';

import '../../../Components/amount_textfield.dart';
import '../../../Components/error_dialog.dart';

class Addsavingscreen extends StatefulWidget {
  const Addsavingscreen({super.key});

  @override
  State<Addsavingscreen> createState() => _AddsavingscreenState();
}

class _AddsavingscreenState extends State<Addsavingscreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  String _inputAmount = '0';
  @override
  void initState() {
    _controllerDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _controllerAmount.addListener(() {
      if (_controllerAmount.text.isNotEmpty) {
        _inputAmount =
            _controllerAmount.text.replaceAll('.', '').replaceAll(',', '.');
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      locale: Locale("vi", "VN"),
      initialDate: DateFormat('dd/MM/yyyy').parse(_controllerDate.text), // Ngày mặc định là ngày hiện tại
      firstDate: DateTime(2000),   // Ngày bắt đầu
      lastDate: DateTime(2100),    // Ngày kết thúc
      helpText: 'Chọn ngày mục tiêu',     // Tiêu đề của DatePicker
      cancelText: 'Huỷ',        // Nút hủy
      confirmText: 'Xác nhận',           // Nút xác nhận
      fieldLabelText: 'Nhập ngày',// Nhãn của trường nhập
    );

    if (selectedDate != null) {
      _controllerDate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      print("Selected date: $selectedDate");
    }
  }

  void _saveNewSaving(BuildContext context) async {
    if(_controllerName.text.length <= 0) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập tên khoản tiết kiệm");
    }
    else {
      Saving newSav = Saving(name: _controllerName.text, target_amount: double.parse(_inputAmount), target_date: DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(_controllerDate.text)), current_amount: 0, is_finished: 0);
      context.read<SavingBloc>().add(AddSavingEvent(newSav));
      await context.read<SavingBloc>().stream.firstWhere((walletState) => walletState is SavingUpdateState);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height;
    final maxW = MediaQuery.of(context).size.width;
    return SafeArea(child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.Nen,
          title: Text("Thêm khoản tiết kiệm", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),
        body: Container(
          height: maxH,
          width: maxW,
          margin: EdgeInsets.only(top: 10),
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
                            "Tên",
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
                          labelText: 'Tên khoản tiết kiệm',
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
                            "Số tiền",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    Expanded(
                      child: AmountTextfield(controllerTF: _controllerAmount, isEdit: true,),
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
                            "Ngày",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => {
                          _selectDate(context)
                        },
                        child: AbsorbPointer(
                          child: TextField(
                              controller: _controllerDate,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Ngày mục tiêu"),
                              onChanged: (value) {}),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
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
                onPressed: () => {
                  _saveNewSaving(context)
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
          ),
        ),
      ),
    ));
  }
}
