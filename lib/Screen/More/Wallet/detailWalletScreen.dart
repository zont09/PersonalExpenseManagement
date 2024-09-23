import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

class Detailwalletscreen extends StatefulWidget {
  final Wallet wal;
  const Detailwalletscreen({super.key, required this.wal});

  @override
  State<Detailwalletscreen> createState() => _Detailwalletscreen();
}

class _Detailwalletscreen extends State<Detailwalletscreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerCurrency = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  Currency _selectCurerncy = Currency(id: -1,name: "", value: 0);
  String _inputAmount = '0';
  bool _isEditable = false;

  @override
  void initState() {
    super.initState();
    _controllerName.text = widget.wal.name;
    _controllerAmount.text = formatCurrency2(widget.wal.amount.toString());
    _controllerCurrency.text = widget.wal.currency.name;
    _controllerNote.text = widget.wal.note;
    _inputAmount = widget.wal.amount.toString();
    _selectCurerncy = widget.wal.currency;
    _controllerAmount.addListener(() {
      if (_controllerAmount.text.isNotEmpty) {
        print("Change ${_inputAmount}");
        _inputAmount =
            _controllerAmount.text.replaceAll('.', '').replaceAll(',', '.');
      }
    });
  }

  static String formatCurrency2(String input) {
    // Kiểm tra xem chuỗi có chứa phần thập phân không
    List<String> parts = input.split('.');

    // Xử lý phần nguyên
    String integerPart = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    NumberFormat numberFormat = NumberFormat('#,##0', 'vi');
    String formattedInteger =
    numberFormat.format(int.tryParse(integerPart) ?? 0);

    // Xử lý phần thập phân (nếu có)
    String decimalPart = '';
    if (parts.length > 1) {
      decimalPart = parts[1]; // Lấy phần thập phân sau dấu '.'

      // Nếu phần thập phân trống (ví dụ '1000000.'), thì mặc định là '0'
      return formattedInteger.replaceAll(',', '.') + ',' + decimalPart;
    }

    return formattedInteger.replaceAll(',', '.');
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
                      children: listCur
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

  void _updateWallet(BuildContext context, Wallet totalWallet) {
    if (_controllerName.text.isEmpty) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập tên ví");
    } else if (_selectCurerncy.id == -1) {
      ErrorDialog.showErrorDialog(context, "Chưa chọn loại tiền tệ cho ví");
    } else {

      Wallet newWal = Wallet(
          id: widget.wal.id,
          name: _controllerName.text,
          amount: double.parse(_inputAmount),
          currency: _selectCurerncy,
          note: _controllerNote.text
      );
      context.read<WalletBloc>().add(UpdateWalletEvent(newWal));

      // Lắng nghe sự kiện thêm ví mới
      context.read<WalletBloc>().stream.listen((state) {
        if (state is WalletUpdatedState) {
          // Kiểm tra xem widget còn mounted không trước khi pop
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      });

    }
  }
  void _removeBudgetDetail(BuildContext context) async {
    double newAmount = double.parse(_inputAmount);
    final listTran = await DatabaseHelper().getTransactions();
    if(listTran.any((item) => item.wallet.id == widget.wal.id)) {
      ErrorDialog.showErrorDialog(context, "Còn giao dịch đang dùng ví này nên không thể xoá");
    }
    else {
      final listWallet = await DatabaseHelper().getWallet();
      final totalWallet = listWallet.first;
      Wallet newTotal = Wallet(
          id: totalWallet.id,
          name: totalWallet.name,
          amount: totalWallet.amount - widget.wal.amount * widget.wal.currency.value,
          currency: totalWallet.currency,
          note: totalWallet.note
      );
      Wallet newWal = Wallet(
          id: widget.wal.id,
          name: _controllerName.text,
          amount: double.parse(_inputAmount),
          currency: _selectCurerncy,
          note: _controllerNote.text
      );

      // Sử dụng Completer để đợi cập nhật hoàn tất
      final completer = Completer<void>();

      // Lắng nghe sự kiện cập nhật
      late StreamSubscription<WalletState> subscription;
      subscription = context.read<WalletBloc>().stream.listen((state) {
        if (state is WalletUpdatedState) {
          subscription.cancel();
          completer.complete();
        }
      });

      // Cập nhật tổng số dư
      context.read<WalletBloc>().add(UpdateWalletEvent(newTotal));

      // Đợi cập nhật hoàn tất trước khi thêm ví mới
      completer.future.then((_) {
        // Thêm ví mới
        context.read<WalletBloc>().add(RemoveWalletEvent(newWal));

        // Lắng nghe sự kiện thêm ví mới
        context.read<WalletBloc>().stream.listen((state) {
          if (state is WalletUpdatedState) {
            // Kiểm tra xem widget còn mounted không trước khi pop
            if (mounted) {
              print("Delete wallet successful");
              Navigator.of(context).pop();
            }
          }
        });
      });
    }

  }

  void _showDeleteConfirmDialog(BuildContext ncontext) {
    showDialog(
      context: ncontext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Bạn có chắc chắn muốn xóa tiền tệ này không?'),
                SizedBox(height: 8), // Khoảng cách giữa hai Text
                Text(
                  'Sau khi bạn xoá thì các giao dich liên quan sẽ bị xoá theo, hãy cân nhắc thật kỹ!',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF822623)),
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
                "Chi tiết ví",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                    onPressed: () => {
                      _showDeleteConfirmDialog(context)
                    }, child:
                Text("Xoá", style: TextStyle(fontSize: 16, color: Colors.black),)),
              ],
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
                              enabled: _isEditable,
                              controller: _controllerName,
                              maxLines: null,
                              minLines: 1,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Tên ví',
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
                                  "Số dư",
                                  style: TextStyle(fontSize: 16),
                                )),
                          ),
                          Expanded(
                            child: AmountTextfield(controllerTF: _controllerAmount, isEdit: _isEditable,),
                          )
                        ],
                      ),
                    ),
                    BlocBuilder<CurrencyBloc, CurrencyState>(
                      builder: (context, state) {
                        if (state is CurrencyUpdateState) {
                          final List<Currency> listCur =
                              state.updCur;

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
                                  onTap: () => {
                                    // _showCurrencyOption(context, listCur)
                                  },
                                  child: AbsorbPointer(
                                    child: TextField(
                                      enabled: false,
                                        controller: _controllerCurrency,
                                        decoration: InputDecoration(
                                            border:
                                            UnderlineInputBorder(),
                                            labelText: "Tiền tệ"),
                                        onChanged: (value) {}),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Text(
                              "Failed to load Category in add transaction");
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
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if(state is WalletUpdatedState) {
                    final wallet = state.updatedWallet;
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
                            if(!_isEditable)
                              setState(() {
                                _isEditable = true;
                              })
                            else
                              _updateWallet(context, wallet.first)
                          },
                          child: Center(
                            child: Text(
                              _isEditable ?
                              "Lưu" : "Sửa",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    );
                  }
                  else {
                    return Text("");
                  }
                },
              ),
            ),
          ),
        ));
  }
}
