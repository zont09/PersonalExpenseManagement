import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Components/error_dialog.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_event.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_state.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_event.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_state.dart';

import '../../../Components/amount_textfield.dart';

class Detailcurrencyscreen extends StatefulWidget {
  final Currency cur;

  const Detailcurrencyscreen({super.key, required this.cur});

  @override
  State<Detailcurrencyscreen> createState() => _Detailcurrencyscreen();
}

class _Detailcurrencyscreen extends State<Detailcurrencyscreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  String _inputAmount = "0";
  bool _isEditable = false;

  @override
  void initState() {
    super.initState();
    _controllerAmount.text = formatCurrency2(widget.cur.value.toString());
    _controllerName.text = widget.cur.name;
    _inputAmount = widget.cur.value.toString();
    _controllerAmount.addListener(() {
      if (_controllerAmount.text.isNotEmpty) {
        // Lấy giá trị nguyên bản từ chuỗi mà không có định dạng
        print("Change ${_inputAmount}");
        _inputAmount =
            _controllerAmount.text.replaceAll('.', '').replaceAll(',', '.');
      }
    });
  }

  String formatCurrency2(String input) {
    List<String> parts = input.split('.');
    String integerPart = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    NumberFormat numberFormat = NumberFormat('#,##0', 'vi');
    String formattedInteger =
        numberFormat.format(int.tryParse(integerPart) ?? 0);
    String decimalPart = '';
    if (parts.length > 1) {
      decimalPart = parts[1];
      return formattedInteger.replaceAll(',', '.') + ',' + decimalPart;
    }
    return formattedInteger.replaceAll(',', '.');
  }

  void _updateNewCurrency(BuildContext context, List<Currency> listCur) async {
    if (_controllerName.text.length <= 0) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập đơn vị tiền tệ");
    } else if (_controllerName.text != widget.cur.name &&
        listCur.any((item) => item.name == _controllerName.text)) {
      ErrorDialog.showErrorDialog(context, "Đơn vị tiền tệ đã tồn tại");
    } else if (double.parse(_inputAmount) <= 0) {
      ErrorDialog.showErrorDialog(context, "Giá trị mệnh giá không hợp lệ");
    } else {
      Currency updCur = Currency(
          id: widget.cur.id,
          name: _controllerName.text,
          value: double.parse(_inputAmount));
      context.read<CurrencyBloc>().add(UpdateCurrencyEvent(updCur));
      context.read<CurrencyBloc>().stream.listen((state) async {
        if (state is CurrencyUpdateState) {
          print("Update budgetdetail successful");
          await Future.delayed(Duration(milliseconds: 500));
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      });
    }
  }

  void _removeBudgetDetail(BuildContext context) async {
    double newAmount = double.parse(_inputAmount);
    context.read<CurrencyBloc>().add(RemoveCurrencyEvent(widget.cur));
    context.read<CurrencyBloc>().stream.listen((state) async {
      if (state is CurrencyUpdateState) {
        print("Remove currency successful");
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  void _showDeleteConfirmDialog(BuildContext ncontext) {
    showDialog(
      context: ncontext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Bạn có chắc chắn muốn xóa tiền tệ này không?'),
                SizedBox(height: 8), // Khoảng cách giữa hai Text
                Text(
                  'Sau khi bạn xoá thì các ví liên quan sẽ bị xoá theo, hãy cân nhắc thật kỹ!',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Color(0xFF822623)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                _removeBudgetDetail(ncontext);
                if (mounted) {
                  Navigator.of(ncontext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _setGlobalCurrency(BuildContext context) async {
    context
        .read<ParameterBloc>()
        .add(UpdateParameterEvent(Parameter(currency: widget.cur)));
    await context.read<ParameterBloc>()
        .stream
        .firstWhere((state) => state is ParameterUpdateState);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showSetGlobalCurrencyConfirmDialog(BuildContext ncontext) {
    showDialog(
      context: ncontext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    'Bạn có chắc chắn muốn đặt tiền tệ này làm tiền tệ chung không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xác nhận'),
              onPressed: () {
                _setGlobalCurrency(ncontext);
                if (mounted) {
                  Navigator.of(ncontext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double maxH = MediaQuery.of(context).size.height;
    final double maxW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.Nen,
            title: Text(
              "Chi tiết tiền tệ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                  onPressed: () => {_showDeleteConfirmDialog(context)},
                  child: Text(
                    "Xoá",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ],
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
                            enabled: _isEditable,
                            controller: _controllerName,
                            maxLines: null,
                            minLines: 1,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Đơn vị tiền tệ',
                            ),
                            onChanged: (value) {},
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
                          child: AmountTextfield(
                            controllerTF: _controllerAmount,
                            isEdit: _isEditable,
                            hintText: "Nhập mệnh giá",
                          ),
                        )
                      ],
                    ),
                  ),
                  if (!_isEditable)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.XanhLaDam,
                            side: const BorderSide(
                              color: AppColors.XanhLaDam,
                              width: 2.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5), // Độ bo góc của viền
                            ),
                          ),
                          onPressed: () => {
                            _showSetGlobalCurrencyConfirmDialog(context)
                          },
                          child: const Center(
                            child: Text(
                              "Đặt làm tiền tệ chung",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                if (state is CurrencyUpdateState) {
                  final listCur = state.updCur;
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
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
                              if (!_isEditable)
                                setState(() {
                                  _isEditable = true;
                                })
                              else
                                _updateNewCurrency(context, listCur)
                            },
                        child: Center(
                          child: Text(
                            _isEditable ? "Lưu" : "Sửa",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                  );
                } else {
                  return Text("Failed to load currency in add currency");
                }
              },
            ),
          )),
    ));
  }
}
