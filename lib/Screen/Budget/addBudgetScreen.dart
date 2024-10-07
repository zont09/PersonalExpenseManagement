import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:personal_expense_management/Components/add_dropdown.dart';
import 'package:personal_expense_management/Components/amount_textfield.dart';
import 'package:personal_expense_management/Model/Budget.dart';
import 'package:personal_expense_management/Model/BudgetDetail.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_bloc.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_event.dart';
import 'package:personal_expense_management/bloc/budget_bloc/budget_state.dart';
import 'package:personal_expense_management/bloc/budget_detail_bloc/budget_detail_bloc.dart';
import 'package:personal_expense_management/bloc/budget_detail_bloc/budget_detail_event.dart';
import 'package:personal_expense_management/bloc/budget_detail_bloc/budget_detail_state.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_bloc.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_state.dart';

class Addbudgetscreen extends StatefulWidget {
  final DateTime dateTime;
  const Addbudgetscreen({super.key, required this.dateTime});

  @override
  State<Addbudgetscreen> createState() => _AddbudgetscreenState();
}

class _AddbudgetscreenState extends State<Addbudgetscreen> {
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerCategory = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  late DateTime _dateTime;
  Category selectCategory = Category(id: -1,name: "", type: 0);

  @override
  void initState() {
    super.initState();
    _dateTime = widget.dateTime ?? DateTime.now();
    _controllerAmount.text = "0";
    _controllerDate.text = DateFormat('MM/yyyy').format(_dateTime);
  }

  Future<void> _selectDate(BuildContext context, String? locale,) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _dateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: localeObj,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                fontSize: 12,
              ), // Center text
              titleLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: child,
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _dateTime = selected;
        _controllerDate.text = DateFormat('MM/yyyy').format(selected);
      });
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
          title: Text("Thêm ngân sách tháng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          leading: TextButton(onPressed: () => {Navigator.of(context).pop()}, child:
          Text("Huỷ", style: TextStyle(fontSize: 16, color: Colors.black),)),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          width: maxW,
          height: maxH,
          // color: AppColors.Nen,
          child: SingleChildScrollView(
            child: Container(
              color: AppColors.Nen,
              child: Column(
                children: [
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
                        child: AmountTextfield(controllerTF: _controllerAmount, isEdit: true,),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CategorySelect(controllerCategory: _controllerCategory, onChanged: (Category tmp) { selectCategory = tmp; },),
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
                            _selectDate(context, "vi")
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
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SaveButton(maxW: maxW, controllerCategory: _controllerCategory, controllerDate: _controllerDate, controllerAmount: _controllerAmount, selectItem: selectCategory,),
      ),
    ));
  }
}

class SaveButton extends StatefulWidget {
  const SaveButton({
    super.key,
    required this.maxW,
    required this.controllerDate,
    required this.controllerCategory,
    required this.controllerAmount,
    required this.selectItem,
  });

  final double maxW;
  final TextEditingController controllerDate;
  final TextEditingController controllerCategory;
  final TextEditingController controllerAmount;
  final Category selectItem;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  String _inputAmount = "0";
  void initState() {
    super.initState();
    widget.controllerAmount.addListener(() {
      if (widget.controllerAmount.text.isNotEmpty) {
        // Lấy giá trị nguyên bản từ chuỗi mà không có định dạng
        _inputAmount =
            widget.controllerAmount.text.replaceAll('.', '').replaceAll(',', '.');
      }
    });
  }

  Future<Budget> addNewBudgetIfNotExist(BuildContext context, DateTime dateBud, List<Budget> listBud) async {
    // Kiểm tra ngân sách đã tồn tại
    Budget? isExistBudget = listBud
        .where((item) => DateTime.parse(item.date).month == dateBud.month && DateTime.parse(item.date).year == dateBud.year)
        .firstOrNull;

    if (isExistBudget == null) {
      // Tạo Completer để đợi kết quả từ stream
      Completer<Budget> completer = Completer();

      // Gọi event để thêm ngân sách mới
      Budget newBud = Budget(date: DateFormat('yyyy-MM-dd').format(dateBud));
      context.read<BudgetBloc>().add(AddBudgetEvent(newBud));

      // Lắng nghe stream và xử lý khi có trạng thái cập nhật

      context.read<BudgetBloc>().stream.listen((budgetState) {
        if (budgetState is BudgetUpdateState) {
          // Tìm ngân sách mới vừa được thêm
          Budget? newBudget = budgetState.updBudget
              .where((item) => DateTime.parse(item.date).month == dateBud.month && DateTime.parse(item.date).year == dateBud.year)
              .firstOrNull;


          if (newBudget != null && !completer.isCompleted) {
            completer.complete(newBudget); // Trả về ngân sách mới
          }
        }
      });

      // Đợi cho đến khi Completer hoàn thành
      isExistBudget = await completer.future;
    }

    return isExistBudget; // Chắc chắn trả về Budget, không thể là null
  }

  void _saveNewTransaction(BuildContext context, List<Budget> listBud, List<BudgetDetail> listBudDt) async {
    DateTime dateBud = DateFormat('MM/yyyy').parse(widget.controllerDate.text);
    if(widget.controllerCategory.text.isEmpty) {
      _showErrorDialog(context ,"Thiếu thông tin loại giao dịch");
    }
    else {
       Budget? _budget = await addNewBudgetIfNotExist(context, dateBud, listBud);
      final listBudgetDt = listBudDt.where((item) => item.id_budget.id == _budget?.id).toList();

      if(listBudgetDt.any((item) => item.category.id == widget.selectItem.id)) {
        _showErrorDialog(context ,"Loại giao dịch ${widget.controllerCategory.text} đã tồn tại trong tháng này");
      }
      else {
        BudgetDetail budDet = BudgetDetail(id_budget: _budget, amount: double.parse(_inputAmount), category: widget.selectItem);
        context.read<BudgetDetailBloc>().add(AddBudgetDetailEvent(budDet));
        await context.read<BudgetDetailBloc>().stream.firstWhere((state) => state is BudgetDetailUpdateState);
        if (mounted) {
          Navigator.of(context).pop();
        }
      }

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        if(state is BudgetUpdateState) {
          final listBudget = state.updBudget;
          return BlocBuilder<BudgetDetailBloc, BudgetDetailState>(
          builder: (context, state) {
            if(state is BudgetDetailUpdateState) {
              final listBudgetDt = state.updBudgetDet;
              return BottomAppBar(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(bottom: 10,),
                  height: 50,
                  width: widget.maxW,
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
                        _saveNewTransaction(context, listBudget, listBudgetDt)
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
              );
            }
            else {
              return Text("Failed to load budget detail in add budget");
            }
  },
);
        }
        else {
          return Text("Failed to load budget in add budget");
        }
      },
    );
  }
}

class CategorySelect extends StatefulWidget {
  const CategorySelect({
    super.key,
    required TextEditingController controllerCategory,
    required this.onChanged
  }) : _controllerCategory = controllerCategory;

  final TextEditingController _controllerCategory;
  final Function(Category) onChanged;

  @override
  State<CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if(state is CategoryUpdateState) {
          final _listData = state.updCategory.where((item) => item.type == 0).toList();
          return AddDropdown(title: "Thể loại",
            controllerTF: widget._controllerCategory,
            listData: _listData,
            isEdit: true,
            onChanged: (dynamic _tmp) {
              widget.onChanged(_tmp as Category);
            });
        }
        else {
          return Text("Failed to load category in add budget");
        }
      },
    );
  }
}
