import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Components/error_dialog.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_event.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_state.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_event.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';

import '../../../Components/amount_textfield.dart';

class Addwalletscreen extends StatefulWidget {
  const Addwalletscreen({super.key});

  @override
  State<Addwalletscreen> createState() => _AddwalletscreenState();
}

class _AddwalletscreenState extends State<Addwalletscreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerCurrency = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  Currency _selectCurerncy = Currency(id: -1, name: "", value: 0);
  String _inputAmount = '0';

  @override
  void initState() {
    super.initState();
    _controllerAmount.text = "0";
    _controllerAmount.addListener(() {
      if (_controllerAmount.text.isNotEmpty) {
        print("Change ${_inputAmount}");
        _inputAmount =
            _controllerAmount.text.replaceAll('.', '').replaceAll(',', '.');
      }
    });
  }

  void _showCurrencyOption(BuildContext context, List<Currency> listCur) {
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
                      "Chọn tiền tệ",
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
                      children: listCur.map((item) {
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
                                _selectCurrencyOption(item.name, item);
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

  void _selectCurrencyOption(String value, Currency item) {
    setState(() {
      _controllerCurrency.text = value;
      _selectCurerncy = item;
    });
  }

  void _saveNewCurrency(BuildContext context, Wallet totalWallet) async {
    if (_controllerName.text.isEmpty) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập tên ví");
    } else if (_selectCurerncy.id == -1) {
      ErrorDialog.showErrorDialog(context, "Chưa chọn loại tiền tệ cho ví");
    } else {
      Wallet newTotal = Wallet(
          id: totalWallet.id,
          name: totalWallet.name,
          amount: totalWallet.amount +
              double.parse(_inputAmount) * _selectCurerncy.value,
          currency: totalWallet.currency,
          note: totalWallet.note);
      print("Total?: ${totalWallet.amount}");
      Wallet newWal = Wallet(
          name: _controllerName.text,
          amount: double.parse(_inputAmount),
          currency: _selectCurerncy,
          note: _controllerNote.text);

      // Sử dụng Completer để đợi cập nhật hoàn tất


      // Cập nhật tổng số dư
      context.read<WalletBloc>().add(UpdateWalletEvent(newTotal));
      await context.read<WalletBloc>().stream.firstWhere((walletState) => walletState is WalletUpdatedState);
      context.read<WalletBloc>().add(AddWalletEvent(newWal));
      await context.read<WalletBloc>().stream.firstWhere((walletState) => walletState is WalletUpdatedState);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
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
            "Thêm ví",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          // height: maxH,
          width: maxW,
          color: AppColors.Nen,
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
                              "Tên ví",
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
                            labelText: 'Tên ví',
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
                              "Số dư",
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                      Expanded(
                        child: AmountTextfield(
                          controllerTF: _controllerAmount,
                          isEdit: true,
                        ),
                      )
                    ],
                  ),
                ),
                BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, state) {
                    if (state is CurrencyUpdateState) {
                      final List<Currency> listCur = state.updCur;

                      return Row(
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
                                  "Tiền tệ",
                                  style: TextStyle(fontSize: 16),
                                )),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  {_showCurrencyOption(context, listCur)},
                              child: AbsorbPointer(
                                child: TextField(
                                    controller: _controllerCurrency,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Tiền tệ"),
                                    onChanged: (value) {}),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Text("Failed to load Category in add transaction");
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
          child: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletUpdatedState) {
                final wallet = state.updatedWallet;
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
                      onPressed: () =>
                          {_saveNewCurrency(context, wallet.first)},
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
              } else {
                return Text("");
              }
            },
          ),
        ),
      ),
    ));
  }
}
