import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Components/dialog_utils.dart';
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

class Addtransaction extends StatefulWidget {
  const Addtransaction({super.key});

  @override
  State<Addtransaction> createState() => _AddtransactionState();
}

class _AddtransactionState extends State<Addtransaction> {
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
  String selectedCategory = '';
  Category _selectCattegoryType = Category(id: -1, name: "", type: 0);
  Wallet _selectWallet = Wallet(id: -1,name: "", amount: 0, currency: Currency(name: "", value: 0), note: "");
  RepeatOption _selectRepeat = RepeatOption(id: 1,option_name: "Không");
  File? _image;
  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    _controllerDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _controllerRepeat.text = "Không";
    _controllerAmount.text = "0";
    _controllerDescription.text = "";
    _controllerNote.text = "";
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
      if (selectCategory != value) _controllerCategory.text = '';
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
                      children: listRep
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
      initialDate: DateFormat('dd/MM/yyyy').parse(_controllerDate.text), // Ngày mặc định là ngày hiện tại
      firstDate: DateTime(2000),   // Ngày bắt đầu
      lastDate: DateTime(2100),    // Ngày kết thúc
      helpText: 'Chọn ngày giao dịch',     // Tiêu đề của DatePicker
      cancelText: 'Huỷ',        // Nút hủy
      confirmText: 'Xác nhận',           // Nút xác nhận
      fieldLabelText: 'Enter date',// Nhãn của trường nhập
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
          title:  Center(child: Text('Lỗi')),
          content: Text(errorMessage, style: TextStyle(fontSize: 18),),
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

  void _saveNewTransaction(BuildContext context) async {
      String dateTra = DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(_controllerDate.text)) ;
      if(_selectCattegoryType.id == -1) {
        _showErrorDialog(context ,"Thiếu thông tin loại giao dịch");
      }
      else if(_selectWallet.id == -1) {
        _showErrorDialog(context ,"Thiếu thông tin ví");
      }
      else if(selectCategory == 0 && _selectWallet.amount < double.parse(_inputAmount)) {
        _showErrorDialog(context ,"Số dư trong ví không đủ để thực hiện giao dịch");
      }
      else {
        TransactionModel newTran = TransactionModel(date: dateTra,
            amount: double.parse(_inputAmount),
            wallet: _selectWallet,
            category: _selectCattegoryType,
            note: _controllerNote.text,
            description: _controllerDescription.text,
            repeat_option: _selectRepeat);
        print("Tran: ${newTran.date} - ${newTran.amount} - ${newTran.wallet
            .name} - ${newTran.category.name} - ${newTran.note} - ${newTran
            .description} - ${newTran.repeat_option.option_name}");
        Wallet updWal = Wallet(id: _selectWallet.id,name: _selectWallet.name, amount: _selectWallet.amount, currency: _selectWallet.currency, note: _selectWallet.note);
        if(selectCategory == 0)
          updWal.amount -= double.parse(_inputAmount);
        else
          updWal.amount += double.parse(_inputAmount);
        print("Wallet: ${updWal.id} - ${updWal.name} - ${updWal.amount}");

        context.read<WalletBloc>().add(UpdateWalletEvent(updWal));
        await context.read<WalletBloc>().stream.firstWhere((walletState) => walletState is WalletUpdatedState);
        
        context.read<TransactionBloc>().add(AddTransactionEvent(newTran));
        await context.read<TransactionBloc>().stream.firstWhere((state) => state is TransactionChangedState);

        if (mounted) {
          Navigator.of(context).pop();
        }
      }
  }

  Future<dynamic> _processReceipt(String imagePath, BuildContext context) async {
    try {
      final url = Uri.parse('https://api.mindee.net/v1/products/mindee/expense_receipts/v5/predict');
       DialogUtils.showLoadingDialog(context);
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Token d1250a3ec01bce694443f889d67c7f48'
        ..files.add(await http.MultipartFile.fromPath('document', imagePath)); // Thêm tệp ảnh vào yêu cầu

      final response = await request.send();
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        if(context.mounted) {
          Navigator.of(context).pop();
        }
        return data;
      } else {
        final errorData = await response.stream.bytesToString();
        print('Error Data: $errorData');  // In phản hồi lỗi chi tiết
        _showError('Lỗi xử lý hoá đơn: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Lỗi khi xử lý hoá đơn: $e');
    }
    if(context.mounted) {
      Navigator.of(context).pop();
    }
    return null;
  }
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> handlingScanBill(String imagePath, BuildContext context) async {
    dynamic dataRaw = await _processReceipt(imagePath, context);
    if(dataRaw == null) return;
    final data = dataRaw!['document']['inference']['prediction'];
    setState(() {
      if(data['total_amount']['value'] != null) {
        _controllerAmount.text =  GlobalFunction.formatCurrency(double.parse(data['total_amount']['value'].toString()) * 1000, 2);
        print("=======> Amount: ${GlobalFunction.formatCurrency(double.parse(data['total_amount']['value'].toString()) * 1000, 2)}");
      }
      if(data['date'] != null && data['date']['value'] != null) {
        _controllerDate.text = DateFormat("dd/MM/yyyy").format(DateTime.parse(data['date']['value'].toString()));
        print("=======> Date: ${DateFormat("dd/MM/yyyy").format(DateTime.parse(data['date']['value'].toString()))}");
      }
    });
  }

  Future<void> _getImageFromCamera(BuildContext ctx) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 100,
      );

      if (photo != null) {
        setState(() {
          _image = File(photo.path);
        });
        if(ctx.mounted) {
          await handlingScanBill(photo.path, ctx);
        }
      }
    } catch (e) {
      print('Error taking picture: $e');
      _showError('Không thể chụp ảnh: $e');
    }
  }

  // Chọn ảnh từ thư viện
  Future<void> _getImageFromGallery(BuildContext ctx) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
        if(ctx.mounted) {
          await handlingScanBill(image.path, ctx);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      _showError('Không thể chọn ảnh: $e');
    }
  }

  String formatVND(String? amountStr) {
    if (amountStr == null) return 'N/A';
    final amount = double.tryParse(amountStr) ?? 0;
    // Nếu giá trị nhỏ hơn 1000, giả định rằng giá trị bị rút gọn, nhân với 1000 để chuyển sang VND
    if (amount < 1000) {
      return (amount * 1000).toStringAsFixed(0);
    }
    return amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.width;

    return GestureDetector(
          onTap: () {
    FocusScope.of(context).unfocus();
          },
          child: Scaffold(
      resizeToAvoidBottomInset: true,
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
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  _getImageFromCamera(context);
                },
                  child: Icon(Icons.camera_alt)),
              SizedBox(width: 15,),
              InkWell(
                onTap: () {
                  _getImageFromGallery(context);
                },
                  child: Icon(Icons.image)),
              SizedBox(width: 9,),
            ],
          )
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
                              onTap: () => {onTapCategory(0)},
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
                              onTap: () => {onTapCategory(1)},
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
                                late String formatted = formatCurrency2(
                                    value
                                        .replaceAll('.', '')
                                        .replaceAll(',', '.'));
                                print(
                                    "Value: $value  -  Formated: $formatted");
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
                            final List<Category> listCat =
                                state.updCategory;

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
                                      _showCategoryOption(
                                          context, listCat, selectCategory)
                                    },
                                    child: AbsorbPointer(
                                      child: TextField(
                                          controller: _controllerCategory,
                                          decoration: InputDecoration(
                                              border:
                                                  UnderlineInputBorder(),
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
                      SizedBox(height: 8,),
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
                              onTap: () => {
                                _selectDate(context)
                              },
                              child: AbsorbPointer(
                                child: TextField(
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
                      SizedBox(height: 8,),
                      BlocBuilder<WalletBloc, WalletState>(
                        builder: (context, state) {
                          if (state is WalletUpdatedState) {
                            final List<Wallet> listWal =
                                state.updatedWallet;

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
                              controller: _controllerNote,
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
                      SizedBox(height: 8,),
                      BlocBuilder<RepeatOptionBloc, RepeatOptionState>(
                        builder: (context, state) {
                          if (state is RepeatOptionUpdateState) {
                            final List<RepeatOption> listRep =
                                state.updRep;

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
                                      _showRepeatOption(
                                          context, listRep)
                                    },
                                    child: AbsorbPointer(
                                      child: TextField(
                                          controller: _controllerRepeat,
                                          decoration: InputDecoration(
                                              border:
                                              UnderlineInputBorder(),
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
                              controller: _controllerDescription,
                              maxLines: null,
                              minLines: 1,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Nhập mô tả',
                              ),
                              onChanged: (value) {
                              },
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
              _saveNewTransaction(context)
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
        );
  }
}
