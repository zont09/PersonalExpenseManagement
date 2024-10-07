import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/Model/SavingDetail.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_event.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_state.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_bloc.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_event.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_state.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_event.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';

import '../../../Components/amount_textfield.dart';
import '../../../Components/error_dialog.dart';

class Detailsavingdetailscreen extends StatefulWidget {
  final Saving sav;
  final SavingDetail savDet;

  const Detailsavingdetailscreen(
      {super.key, required this.sav, required this.savDet});

  @override
  State<Detailsavingdetailscreen> createState() =>
      _DetailsavingdetailscreenState();
}

class _DetailsavingdetailscreenState extends State<Detailsavingdetailscreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerWallet = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  String _inputAmount = '0';
  Wallet _selectWallet = Wallet(
      id: -1,
      name: "",
      amount: 0,
      currency: Currency(name: "", value: 0),
      note: "");
  bool _isEditable = false;
  @override
  void initState() {
    _controllerAmount.text =
        GlobalFunction.formatCurrency2(widget.savDet.amount.toString());
    _inputAmount = widget.savDet.amount.toString();
    _controllerNote.text = widget.savDet.note;
    _controllerName.text = widget.sav.name;
    _selectWallet = widget.savDet.wallet;
    _controllerWallet.text = _selectWallet.name;
    _controllerAmount.addListener(() {
      if (_controllerAmount.text.isNotEmpty) {
        _inputAmount =
            _controllerAmount.text.replaceAll('.', '').replaceAll(',', '.');
      }
    });
  }

  void _showWalletOption(BuildContext context, List<Wallet> listWal) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      scrollControlDisabledMaxHeightRatio: 0.9,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 1,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Chọn ví",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black38,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: listWal.skip(1).map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black26,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Text(item.name),
                              onTap: () {
                                _selectWalletOption(item.name, item);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _selectWalletOption(String value, Wallet item) {
    setState(() {
      _controllerWallet.text = value;
      _selectWallet = item;
    });
  }

  Future<void> _updSavingDet(BuildContext context) async {
    print("On here?");
    final listWallets = await DatabaseHelper().getWallet();
    final listSavDet = await DatabaseHelper().getSavingDetails();
    _selectWallet =
        listWallets.firstWhere((item) => item.id == _selectWallet.id);
    double _inputValue = double.parse(_inputAmount);
    final _selectSavDet = listSavDet.firstWhere((item) => item.id == widget.savDet.id);

    if (_selectWallet.id == -1) {
      ErrorDialog.showErrorDialog(context, "Chưa chọn ví");
      return;
    }

    Wallet updWallet;
    if (_selectWallet.id == _selectSavDet.wallet.id) {
      double diffAmount = _inputValue - _selectSavDet.amount;

      if (diffAmount > _selectWallet.amount) {
        ErrorDialog.showErrorDialog(
            context, "Ví ${_selectWallet.name} không đủ tiền để thực hiện");
        return;
      }

      updWallet = Wallet(
        id: _selectWallet.id,
        name: _selectWallet.name,
        amount: _selectWallet.amount - diffAmount,
        currency: _selectWallet.currency,
        note: _selectWallet.note,
      );
    } else {
      if (_inputValue > _selectWallet.amount) {
        ErrorDialog.showErrorDialog(
            context, "Ví ${_selectWallet.name} không đủ tiền để thực hiện");
        return;
      }

      Wallet undoWallet = Wallet(
        id: _selectSavDet.wallet.id,
        name: _selectSavDet.wallet.name,
        amount: _selectSavDet.wallet.amount + _selectSavDet.amount,
        currency: _selectSavDet.wallet.currency,
        note: _selectSavDet.wallet.note,
      );

      context.read<WalletBloc>().add(UpdateWalletEvent(undoWallet));

      updWallet = Wallet(
        id: _selectWallet.id,
        name: _selectWallet.name,
        amount: _selectWallet.amount - _inputValue,
        currency: _selectWallet.currency,
        note: _selectWallet.note,
      );
    }

    await _proceedUpdate(context, updWallet, _selectSavDet);
  }

  Future<void> _proceedUpdate(BuildContext context, Wallet updWallet, SavingDetail _selectSavDet) async {
    final listSav = await DatabaseHelper().getSaving();
    final _selectSav = listSav.firstWhere((item) => item.id == widget.sav.id);
    Saving updSaving = Saving(
      id: _selectSav.id,
      name: _selectSav.name,
      target_amount: _selectSav.target_amount,
      target_date: _selectSav.target_date,
      current_amount: _selectSav.current_amount +
          double.parse(_inputAmount) -
          _selectSavDet.amount,
      is_finished: _selectSav.current_amount + double.parse(_inputAmount) >=
              _selectSav.target_amount
          ? 1
          : 0,
    );

    SavingDetail newSavDet = SavingDetail(
      id: _selectSavDet.id,
      id_saving: widget.sav,
      amount: double.parse(_inputAmount),
      wallet: _selectWallet,
      note: _controllerNote.text,
    );

    context.read<SavingDetailBloc>().add(UpdateSavingDetailEvent(newSavDet));
    await context.read<SavingDetailBloc>().stream.firstWhere((state) => state is SavingDetailUpdateState);
    context.read<WalletBloc>().add(UpdateWalletEvent(updWallet));
    await context.read<WalletBloc>().stream.firstWhere((state) => state is WalletUpdatedState);
    context.read<SavingBloc>().add(UpdateSavingEvent(updSaving));
    await context.read<SavingBloc>().stream.firstWhere((state) => state is SavingUpdateState);
    if (mounted) {
      print("Pop in delete");
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;
    final maxH = MediaQuery.of(context).size.height;
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.Nen,
          title: Text(
            "Thêm tiền vào KTK",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          height: maxH,
          width: maxW,
          margin: EdgeInsets.only(top: 10),
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
                              "Tên KTK",
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                      Expanded(
                        child: TextField(
                          enabled: false,
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
                BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    if (state is WalletUpdatedState) {
                      final List<Wallet> listWal = state.updatedWallet;

                      return Container(
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
                                    "Ví",
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    {_showWalletOption(context, listWal)},
                                child: AbsorbPointer(
                                  child: TextField(
                                      enabled: _isEditable,
                                      controller: _controllerWallet,
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: "Ví"),
                                      onChanged: (value) {}),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Text("");
                    }
                  },
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
                              "Ghi chú",
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                      Expanded(
                        child: TextField(
                          enabled: _isEditable,
                          controller: _controllerNote,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Ghi chú',
                          ),
                          onChanged: (value) {},
                        ),
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
                        _updSavingDet(context)
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
