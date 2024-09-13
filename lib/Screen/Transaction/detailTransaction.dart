import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Currency.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Resources/global_function.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_bloc.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_state.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_bloc.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_state.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_event.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_state.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_event.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_state.dart';

class Detailtransaction extends StatefulWidget {
  final TransactionModel transaction;

  const Detailtransaction({super.key, required this.transaction});

  @override
  State<Detailtransaction> createState() => _Detailtransaction();
}

class _Detailtransaction extends State<Detailtransaction> {
  late int selectCategory = 0;
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerCategory = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerWallet = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  final TextEditingController _controllerRepeat = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _inputAmount = "0";
  bool _isEnterDot = false;
  String _preTextAmount = "";
  Category _selectCattegoryType = Category(id: -1, name: "", type: 0);
  Wallet _selectWallet = Wallet(
      id: -1,
      name: "",
      amount: 0,
      currency: Currency(name: "", value: 0),
      note: "");
  RepeatOption _selectRepeat = RepeatOption(id: 1, option_name: "Không");
  bool _isEditable = false;

  @override
  void initState() {
    super.initState();
    selectCategory = widget.transaction.category.type;
    _inputAmount = widget.transaction.amount.toString();
    _preTextAmount = _inputAmount;
    _selectCattegoryType = widget.transaction.category;
    _selectWallet = widget.transaction.wallet;
    _selectRepeat = widget.transaction.repeat_option;
    _controllerDate.text = DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd').parse(widget.transaction.date));
    _controllerRepeat.text = widget.transaction.repeat_option.option_name;
    _controllerAmount.text =
        formatCurrency2(widget.transaction.amount.toString());
    _controllerDescription.text = widget.transaction.description ?? "";
    _controllerNote.text = widget.transaction.note ?? "";
    _controllerCategory.text = widget.transaction.category.name;
    _controllerWallet.text = widget.transaction.wallet.name;
    _controllerAmount.addListener(() {
      if (_controllerAmount.text.isNotEmpty) {
        // Lấy giá trị nguyên bản từ chuỗi mà không có định dạng
        _inputAmount =
            _controllerAmount.text.replaceAll('.', '').replaceAll(',', '.');
      }
    });
  }

  void handleEnterAmount(String value) {
    _preTextAmount = value;
  }

  void onTapCategory(int value) {
    setState(() {
      if (selectCategory != value) {
        _controllerCategory.text = '';
        _selectCattegoryType = Category(id: -1, name: "", type: 0);
      }
      selectCategory = value;
    });
  }

  String formatCurrency2(String input) {
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

  void _showCategoryOption(BuildContext context, List<Category> listCat, int _typeCat) {
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
                      "Loại giao dịch",
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
                      children: listCat
                          .where((item) => item.type == _typeCat)
                          .map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black26, // Màu của đường viền
                                  width: 1.0, // Độ dày của đường viền
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Text(item.name),
                              onTap: () {
                                _selectCategoryOption(item.name, item);
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

  void _showRepeatOption(BuildContext context, List<RepeatOption> listRep) {
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
                      "Lặp lại",
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
                      children: listRep.map((item) {
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
                              title: Text(item.option_name),
                              onTap: () {
                                _selectRepeatOption(item.option_name, item);
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

  void _selectCategoryOption(String value, Category item) {
    setState(() {
      _controllerCategory.text = value;
      _selectCattegoryType = item;
    });
  }

  void _selectWalletOption(String value, Wallet item) {
    setState(() {
      _controllerWallet.text = value;
      _selectWallet = item;
    });
  }

  void _selectRepeatOption(String value, RepeatOption item) {
    setState(() {
      _controllerRepeat.text = value;
      _selectRepeat = item;
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
      helpText: 'Chọn ngày giao dịch',
      // Tiêu đề của DatePicker
      cancelText: 'Huỷ',
      // Nút hủy
      confirmText: 'Xác nhận',
      // Nút xác nhận
      fieldLabelText: 'Enter date', // Nhãn của trường nhập
    );

    if (selectedDate != null) {
      _controllerDate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      print("Selected date: $selectedDate");
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Lỗi')),
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveUpdateTransaction(BuildContext context) async {
    String dateTra = DateFormat('yyyy-MM-dd')
        .format(DateFormat('dd/MM/yyyy').parse(_controllerDate.text));

    if (_selectCattegoryType.id == -1) {
      _showErrorDialog(context, "Thiếu thông tin loại giao dịch");
      return;
    }
    if (_selectWallet.id == -1) {
      _showErrorDialog(context, "Thiếu thông tin ví");
      return;
    }

    List<Wallet> wallets = await DatabaseHelper().getWallet();
    _selectWallet = wallets.where((item) => item.id == _selectWallet.id).first;
    widget.transaction.wallet = wallets.where((item) => item.id == widget.transaction.wallet.id).first;
    TransactionModel newTran = TransactionModel(
        id: widget.transaction.id,
        date: dateTra,
        amount: double.parse(_inputAmount),
        wallet: _selectWallet,
        category: _selectCattegoryType,
        note: _controllerNote.text ?? "",
        description: _controllerDescription.text ?? "",
        repeat_option: _selectRepeat);
    print(
        "Tran: ${newTran.date} - ${newTran.amount} - ${newTran.wallet.name} - ${newTran.category.name} - ${newTran.note} - ${newTran.description} - ${newTran.repeat_option.option_name}");

    WalletBloc walletBloc = context.read<WalletBloc>();
    TransactionBloc transactionBloc = context.read<TransactionBloc>();

    try {
      if (_selectWallet.id == widget.transaction.wallet.id) {
        double amountDiff = double.parse(_inputAmount) - widget.transaction.amount;
        Wallet updWal;
        if (_selectCattegoryType.type == widget.transaction.category.type) {
          if (_selectCattegoryType.type == 0) {
            if (amountDiff > _selectWallet.amount) {
              _showErrorDialog(context, "Ví không đủ số dư để thực hiện giao dịch");
              return;
            }
            updWal = Wallet(
                id: _selectWallet.id,
                name: _selectWallet.name,
                amount: _selectWallet.amount - amountDiff,
                currency: _selectWallet.currency,
                note: _selectWallet.note);
          } else {
            updWal = Wallet(
                id: _selectWallet.id,
                name: _selectWallet.name,
                amount: _selectWallet.amount + amountDiff,
                currency: _selectWallet.currency,
                note: _selectWallet.note);
          }
        } else {
          if (_selectCattegoryType.type == 0) {
            if (_selectWallet.amount < (widget.transaction.amount + double.parse(_inputAmount))) {
              _showErrorDialog(context, "Ví không đủ số dư để thực hiện giao dịch");
              return;
            }
            updWal = Wallet(
                id: _selectWallet.id,
                name: _selectWallet.name,
                amount: _selectWallet.amount - widget.transaction.amount - double.parse(_inputAmount),
                currency: _selectWallet.currency,
                note: _selectWallet.note);
          } else {
            updWal = Wallet(
                id: _selectWallet.id,
                name: _selectWallet.name,
                amount: _selectWallet.amount + widget.transaction.amount + double.parse(_inputAmount),
                currency: _selectWallet.currency,
                note: _selectWallet.note);
          }
        }

        walletBloc.add(UpdateWalletEvent(updWal));

      } else {
        Wallet updWal1 = Wallet(
            id: widget.transaction.wallet.id,
            name: widget.transaction.wallet.name,
            amount: widget.transaction.wallet.amount,
            currency: widget.transaction.wallet.currency,
            note: widget.transaction.wallet.note);
        if (widget.transaction.category.type == 0)
          updWal1.amount += widget.transaction.amount;
        else {
          if (widget.transaction.wallet.amount < widget.transaction.amount) {
            _showErrorDialog(context,
                "Ví ${widget.transaction.wallet.name} không đủ số dư để hoàn lại số tiền giao dịch cũ");
            return;
          }
          updWal1.amount -= widget.transaction.amount;
        }

        Wallet updWal2 = Wallet(
            id: _selectWallet.id,
            name: _selectWallet.name,
            amount: _selectWallet.amount,
            currency: _selectWallet.currency,
            note: _selectWallet.note);
        if (_selectCattegoryType.type == 0) {
          if (_selectWallet.amount < double.parse(_inputAmount)) {
            _showErrorDialog(context,
                "Ví ${_selectWallet.name} không đủ số dư để thực hiện giao dịch");
            return;
          }
          updWal2.amount -= widget.transaction.amount;
        } else
          updWal2.amount += widget.transaction.amount;

        walletBloc.add(UpdateWalletEvent(updWal1));
        await Future.delayed(Duration(milliseconds: 500)); // Chờ một chút để đảm bảo wallet đã được cập nhật
        walletBloc.add(UpdateWalletEvent(updWal2));
      }

      await Future.delayed(Duration(milliseconds: 500)); // Chờ một chút để đảm bảo wallet đã được cập nhật

      transactionBloc.add(UpdateTransactionEvent(newTran));

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Error: $e");
      _showErrorDialog(context, "Có lỗi xảy ra. Vui lòng thử lại.");
    }
  }

  void _deleteTransaction(BuildContext context) async {
    WalletBloc walletBloc = context.read<WalletBloc>();
    TransactionBloc transactionBloc = context.read<TransactionBloc>();
    List<Wallet> wallets = await DatabaseHelper().getWallet();
    widget.transaction.wallet = wallets.where((item) => item.id == widget.transaction.wallet.id).first;
    Wallet updWal;
    if(widget.transaction.category.type == 0) {
      updWal = Wallet(
          id: widget.transaction.wallet.id,
          name: widget.transaction.wallet.name,
          amount: widget.transaction.wallet.amount + widget.transaction.amount,
          currency: widget.transaction.wallet.currency,
          note: widget.transaction.wallet.note);
    }
    else {
      if(widget.transaction.wallet.amount < widget.transaction.amount) {
        _showErrorDialog(context,
            "Ví ${_selectWallet.name} không đủ số dư để hoàn lại giao dịch");
        return;
      }
      updWal = Wallet(
          id: widget.transaction.wallet.id,
          name: widget.transaction.wallet.name,
          amount: widget.transaction.wallet.amount - widget.transaction.amount,
          currency: widget.transaction.wallet.currency,
          note: widget.transaction.wallet.note);
    }
    walletBloc.add(UpdateWalletEvent(updWal));
    await Future.delayed(Duration(milliseconds: 500));
    transactionBloc.add(RemoveTransactionEvent(widget.transaction));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showDeleteConfirmDialog(BuildContext ncontext) {
    print("Xoa2? ${ncontext}");;
    showDialog(
      context: ncontext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa giao dịch này không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                _deleteTransaction(ncontext); // Gọi hàm xác nhận xóa
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controllerAmount.dispose();
    _controllerCategory.dispose();
    _controllerDate.dispose();
    _controllerWallet.dispose();
    _controllerNote.dispose();
    _controllerRepeat.dispose();
    _controllerDescription.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.width;

    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Chi tiết giao dịch",
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
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print("Xoa?");
                _showDeleteConfirmDialog(context);
                // if(mounted)
                //   Navigator.of(context).pop();
              },
              child: Text(
                'Xóa',
                style: TextStyle(
                  color: Colors.black, // Màu chữ của nút
                  fontSize: 16, // Kích thước chữ
                ),
              ),
            ),
          ],
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
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              child: InkWell(
                                child: Center(
                                  child: Text(
                                    "Chi",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: selectCategory == 0
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                onTap: () =>
                                    {if (_isEditable) onTapCategory(0)},
                              ),
                              decoration: BoxDecoration(
                                color: selectCategory == 0
                                    ? AppColors.Cam
                                    : AppColors.Nen, // Màu nền
                                border: Border.all(
                                  color: AppColors.Cam,
                                  width: 2.5,
                                ),
                                borderRadius:
                                    BorderRadius.circular(8), // Bo góc
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 150,
                              child: InkWell(
                                child: Center(
                                  child: Text(
                                    "Thu",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: selectCategory == 1
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                onTap: () =>
                                    {if (_isEditable) onTapCategory(1)},
                              ),
                              decoration: BoxDecoration(
                                color: selectCategory == 1
                                    ? AppColors.XanhLaDam
                                    : AppColors.Nen,
                                // Màu nền
                                border: Border.all(
                                  color: AppColors.XanhLaDam,
                                  // Màu viền
                                  width: 2.5, // Độ dày viền
                                ),
                                borderRadius:
                                    BorderRadius.circular(8), // Bo góc
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
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
                              child: TextField(
                                focusNode: _focusNode,
                                controller: _controllerAmount,
                                enabled: _isEditable,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      !_isEnterDot ? r'[0-9,]' : r'[0-9]')),
                                  // Cho phép số và dấu phẩy
                                ],
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Nhập số tiền',
                                ),
                                onChanged: (value) {
                                  // Xử lý giá trị hiển thị trong TextField
                                  if (value.length < _preTextAmount.length) {
                                    if (_preTextAmount[
                                            _preTextAmount.length - 1] ==
                                        ',') {
                                      setState(() {
                                        _isEnterDot = false;
                                      });
                                    }
                                  }
                                  late String formatted = formatCurrency2(value
                                      .replaceAll('.', '')
                                      .replaceAll(',', '.'));
                                  _controllerAmount.value = TextEditingValue(
                                    text: formatted,
                                    selection: TextSelection.collapsed(
                                        offset: formatted.length),
                                  );
                                  _preTextAmount = value;
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            if (state is CategoryUpdateState) {
                              final List<Category> listCat = state.updCategory;

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
                                          "Thể loại",
                                          style: TextStyle(fontSize: 16),
                                        )),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => {
                                        if (_isEditable)
                                          _showCategoryOption(
                                              context, listCat, selectCategory)
                                      },
                                      child: AbsorbPointer(
                                        child: TextField(
                                            enabled: _isEditable,
                                            controller: _controllerCategory,
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: "Thể loại"),
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
                        SizedBox(
                          height: 8,
                        ),
                        Row(
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
                                onTap: () =>
                                    {if (_isEditable) _selectDate(context)},
                                child: AbsorbPointer(
                                  child: TextField(
                                      enabled: _isEditable,
                                      controller: _controllerDate,
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: "Ngày thực hiện"),
                                      onChanged: (value) {}),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        BlocBuilder<WalletBloc, WalletState>(
                          builder: (context, state) {
                            if (state is WalletUpdatedState) {
                              final List<Wallet> listWal = state.updatedWallet;
                              print("Update wallet in detail ${listWal[1].name ?? "x"} - ${listWal[1].amount}");
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
                                          "Ví",
                                          style: TextStyle(fontSize: 16),
                                        )),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => {
                                        if (_isEditable)
                                          _showWalletOption(context, listWal)
                                      },
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
                              );
                            } else {
                              return Text(
                                  "Failed to load Category in add transaction");
                            }
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
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
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Ghi chú',
                                ),
                                onChanged: (value) {},
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        BlocBuilder<RepeatOptionBloc, RepeatOptionState>(
                          builder: (context, state) {
                            if (state is RepeatOptionUpdateState) {
                              final List<RepeatOption> listRep = state.updRep;

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
                                          "Lặp lại",
                                          style: TextStyle(fontSize: 16),
                                        )),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => {
                                        if (_isEditable)
                                          _showRepeatOption(context, listRep)
                                      },
                                      child: AbsorbPointer(
                                        child: TextField(
                                            enabled: _isEditable,
                                            controller: _controllerRepeat,
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: "Lặp lại"),
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
                        SizedBox(
                          height: 8,
                        ),
                        Row(
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
                                    "Mô tả",
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            Expanded(
                              child: TextField(
                                enabled: _isEditable,
                                controller: _controllerDescription,
                                maxLines: null,
                                minLines: 1,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Nhập mô tả',
                                ),
                                onChanged: (value) {},
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ],
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
                      if (!_isEditable)
                        {
                          setState(() {
                            _isEditable = true;
                          })
                        }
                      else
                        _saveUpdateTransaction(context)
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
