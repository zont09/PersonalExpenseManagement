import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/Screen/More/SavingDetailScreen/addSavingDetailScreen.dart';
import 'package:personal_expense_management/Screen/More/SavingDetailScreen/detailSavingDetailScreen.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_state.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_bloc.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_state.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';

import '../../../Components/amount_textfield.dart';
import '../../../Components/error_dialog.dart';
import '../../../Database/database_helper.dart';

class Detailsavingscreen extends StatefulWidget {
  final Saving sav;

  const Detailsavingscreen({super.key, required this.sav});

  @override
  State<Detailsavingscreen> createState() => _DetailsavingscreenState();
}

class _DetailsavingscreenState extends State<Detailsavingscreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  String _inputAmount = '0';
  bool _isEditable = false;

  @override
  void initState() {
    _controllerDate.text =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.sav.target_date));
    _inputAmount = widget.sav.target_amount.toString();
    _controllerAmount.text = GlobalFunction.formatCurrency2(_inputAmount);
    _controllerName.text = widget.sav.name;
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
      initialDate: DateFormat('dd/MM/yyyy').parse(_controllerDate.text),
      // Ngày mặc định là ngày hiện tại
      firstDate: DateTime(2000),
      // Ngày bắt đầu
      lastDate: DateTime(2100),
      // Ngày kết thúc
      helpText: 'Chọn ngày mục tiêu',
      // Tiêu đề của DatePicker
      cancelText: 'Huỷ',
      // Nút hủy
      confirmText: 'Xác nhận',
      // Nút xác nhận
      fieldLabelText: 'Nhập ngày', // Nhãn của trường nhập
    );

    if (selectedDate != null) {
      _controllerDate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      print("Selected date: $selectedDate");
    }
  }

  void _updateSaving(BuildContext context) {
    if (_controllerName.text.length <= 0) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập tên khoản tiết kiệm");
    } else {
      Saving newSav = Saving(
          id: widget.sav.id,
          name: _controllerName.text,
          target_amount: double.parse(_inputAmount),
          target_date: DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd/MM/yyyy').parse(_controllerDate.text)),
          current_amount: 0,
          is_finished: 0);
      context.read<SavingBloc>().add(UpdateSavingEvent(newSav));
      context.read<SavingBloc>().stream.listen((state) {
        if (state is SavingUpdateState) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      });
    }
  }

  void _removeSavingDetail(BuildContext context) async {
    context.read<SavingBloc>().add(RemoveSavingEvent(widget.sav));
    context.read<SavingBloc>().stream.listen((state) {
      if (state is SavingUpdateState) {
        print("Remove category successful");
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
          title: Text('Xác nhận xóa'),
          content: IntrinsicWidth(
            child: Text('Bạn có chắc chắn muốn xóa khoản tiết kiệm này không?'),
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
                _removeSavingDetail(ncontext);
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
    final maxH = MediaQuery.of(context).size.height;
    final maxW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.Nen,
          title: Text(
            "Thêm khoản tiết kiệm",
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
                        enabled: _isEditable,
                        controller: _controllerName,
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Tên khoản tiết kiệm',
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
                            "Số tiền",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    Expanded(
                      child: AmountTextfield(
                        controllerTF: _controllerAmount,
                        isEdit: _isEditable,
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
                            "Ngày",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => {if (_isEditable) _selectDate(context)},
                        child: AbsorbPointer(
                          child: TextField(
                              enabled: _isEditable,
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
              if(!_isEditable)
              Container(
                margin: EdgeInsets.only(
                  top: 16,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: maxW,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.XanhLaDam,
                      side: BorderSide(
                        color: AppColors.XanhLaDam,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12), // Độ bo góc của viền
                      ),
                    ),
                    onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (newContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: BlocProvider.of<SavingBloc>(
                                    context),
                              ),
                              BlocProvider.value(
                                value:
                                BlocProvider.of<SavingDetailBloc>(context),
                              ),
                              BlocProvider.value(
                                value:
                                BlocProvider.of<WalletBloc>(context),
                              ),

                            ],
                            child: Addsavingdetailscreen(sav: widget.sav),
                          ),
                        ),
                      )
                    },
                    child: Center(
                      child: Text(
                        "Thêm tiền vào khoản tiết kiệm",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
              ),
              if(!_isEditable)
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: BlocBuilder<SavingDetailBloc, SavingDetailState>(
                      builder: (context, state) {
                        if (state is SavingDetailUpdateState) {
                          final listSavDet = state.updSavDet.where(
                              (item) => item.id_saving.id == widget.sav.id);
                          return Column(
                            children: listSavDet
                                .map((item) => Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    GestureDetector(
                                      onTap: () => {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (newContext) => MultiBlocProvider(
                                              providers: [
                                                BlocProvider.value(
                                                  value: BlocProvider.of<SavingBloc>(
                                                      context),
                                                ),
                                                BlocProvider.value(
                                                  value:
                                                  BlocProvider.of<SavingDetailBloc>(context),
                                                ),
                                                BlocProvider.value(
                                                  value:
                                                  BlocProvider.of<WalletBloc>(context),
                                                ),

                                              ],
                                              child: Detailsavingdetailscreen(sav: widget.sav, savDet: item,),
                                            ),
                                          ),
                                        )
                                      },
                                      child: Container(
                                            height: 80,
                                            width: maxW,
                                            color: AppColors.Nen,
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              item.note,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            )),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                item.wallet.name,
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Color(0xFF787878),
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                              ))),
                                                      ],
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: FittedBox(
                                                                fit: BoxFit.scaleDown,
                                                                child: Text(
                                                                  '${GlobalFunction.formatCurrency(item.amount, 2)} ${item.wallet.currency.name}',
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      color: AppColors.XanhLaDam,
                                                                      fontWeight:
                                                                      FontWeight.w500,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                                ),
                                                              ),
                                                            ))
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                    ),
                                  ],
                                ))
                                .toList(),
                          );
                        } else
                          return Text("");
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
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
                      if (_isEditable)
                        _updateSaving(context)
                      else
                        setState(() {
                          _isEditable = true;
                        })
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
          ),
        ),
      ),
    ));
  }
}
