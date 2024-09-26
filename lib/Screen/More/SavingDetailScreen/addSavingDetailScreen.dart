import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Saving.dart';
import 'package:personal_expense_management/Model/SavingDetail.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
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

class Addsavingdetailscreen extends StatefulWidget {
  final Saving sav;
  const Addsavingdetailscreen({super.key, required this.sav});

  @override
  State<Addsavingdetailscreen> createState() => _AddsavingdetailscreenState();
}

class _AddsavingdetailscreenState extends State<Addsavingdetailscreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerWallet = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  String _inputAmount = '0';
  Wallet _selectWallet = Wallet(id: -1,name: "", amount: 0, currency: Currency(name: "", value: 0), note: "");

  @override
  void initState() {
    _controllerAmount.text = '0';
    _controllerName.text = widget.sav.name;
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
                      children: listWal
                          .skip(1)
                          .map((item) {
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

  void _saveNewSavingDet(BuildContext context) async {
    if(_selectWallet.id == -1) {
      ErrorDialog.showErrorDialog(context, "Chưa chọn ví");
    }
    else if(_selectWallet.amount < double.parse(_inputAmount)) {
      ErrorDialog.showErrorDialog(context, "Ví ${_selectWallet.name} không đủ tiền để thực hiện");
    }
    else {
      Wallet updWallet = Wallet(id: _selectWallet.id,name: _selectWallet.name, amount: _selectWallet.amount - double.parse(_inputAmount), currency: _selectWallet.currency, note: _selectWallet.note);
      Saving updSaving = Saving(id: widget.sav.id,name: widget.sav.name, target_amount: widget.sav.target_amount, target_date: widget.sav.target_date, current_amount: widget.sav.current_amount + double.parse(_inputAmount), is_finished: widget.sav.current_amount + double.parse(_inputAmount) >= widget.sav.target_amount ? 1 : 0);
      SavingDetail newSavDet = SavingDetail(id_saving: widget.sav, amount: double.parse(_inputAmount), wallet: _selectWallet, note: _controllerNote.text);
      final Completer<void> savingDetailCompleter = Completer<void>();
      final Completer<void> walletCompleter = Completer<void>();
      final Completer<void> savingCompleter = Completer<void>();

      // Step 1: Add the new saving detail
      context.read<SavingDetailBloc>().add(AddSavingDetailEvent(newSavDet));

      // Step 2: Wait for saving detail update completion
      context.read<SavingDetailBloc>().stream.listen((state) {
        if (state is SavingDetailUpdateState) {
          print("Success sav det");
          savingDetailCompleter.complete();
        }
      });

      // Wait for saving detail update to complete
      await savingDetailCompleter.future;

      // Step 3: Update wallet
      context.read<WalletBloc>().add(UpdateWalletEvent(updWallet));

      // Step 4: Wait for wallet update completion
      context.read<WalletBloc>().stream.listen((walletState) {
        if (walletState is WalletUpdatedState) {
          print("Success wallet det");
          walletCompleter.complete();
        }
      });

      // Wait for wallet update to complete
      await walletCompleter.future;

      // Step 5: Update saving
      context.read<SavingBloc>().add(UpdateSavingEvent(updSaving));

      // Step 6: Wait for saving update completion
      context.read<SavingBloc>().stream.listen((savingState) {
        if (savingState is SavingUpdateState) {
          print("Success sav");
          savingCompleter.complete();
        }
      });

      // Wait for saving update to complete
      await savingCompleter.future;

      // Step 7: Once all updates are done, pop the screen
      if (mounted) {
        Navigator.of(context).pop();
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;
    final maxH = MediaQuery.of(context).size.height;
    return SafeArea(child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.Nen,
          title: Text("Thêm tiền vào KTK", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    if (state is WalletUpdatedState) {
                      final List<Wallet> listWal =
                          state.updatedWallet;

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
                                onTap: () => {
                                  _showWalletOption(
                                      context, listWal)
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                      controller: _controllerWallet,
                                      decoration: InputDecoration(
                                          border:
                                          UnderlineInputBorder(),
                                          labelText: "Ví"),
                                      onChanged: (value) {}),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Text(
                          "");
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
                          controller: _controllerNote,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Ghi chú',
                          ),
                          onChanged: (value) {
                          },
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
                  _saveNewSavingDet(context)
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
