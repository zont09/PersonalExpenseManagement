import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Components/error_dialog.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
as inset_box_shadow;
import 'package:personal_expense_management/bloc/category_bloc/category_bloc.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_event.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_state.dart';

class Detailcategory extends StatefulWidget {
  final Category cat;
  const Detailcategory({super.key, required this.cat});

  @override
  State<Detailcategory> createState() => _Detailcategory();
}

class _Detailcategory extends State<Detailcategory> {
  final TextEditingController _controllerName = TextEditingController();
  int _categoryOption = 0;
  bool _isEditable = false;

  @override
  void initState() {
    super.initState();
    _controllerName.text = widget.cat.name;
    _categoryOption = widget.cat.type;
  }

  void _updateCurrency(BuildContext context) async {
    final listCat = await DatabaseHelper().getCategorys();
    if(_controllerName.text.length <= 0) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập tên loại giao dịch");
    }
    else if(_controllerName.text != widget.cat.name && listCat.any((item) => item.name == _controllerName.text)) {
      ErrorDialog.showErrorDialog(context, "Tên loại giao dịch đã tồn tại!");
    }
    else {
      Category newCat = Category(id: widget.cat.id ,name: _controllerName.text, type: widget.cat.type);
      context.read<CategoryBloc>().add(UpdateCategoryEvent(newCat));
      context.read<CategoryBloc>().stream.listen((state) {
        if (state is CategoryUpdateState) {
          print("Update category successful");
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      });
    }
  }

  void _removeBudgetDetail(BuildContext context) async {
    final listTran = await DatabaseHelper().getTransactions();
    if(listTran.any((item) => item.category.id == widget.cat.id)) {
      ErrorDialog.showErrorDialog(context, "Có giao dịch liên quan chưa được xoá, vui lòng xoá tất cả giao dịch liên quan trước khi xoá loại giao dịch");
    }
    else {
      context.read<CategoryBloc>().add(RemoveCategoryEvent(widget.cat));
      context.read<CategoryBloc>().stream.listen((state) {
        if (state is CategoryUpdateState) {
          print("Remove category successful");
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
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
                Text('Bạn có chắc chắn muốn xóa loại giao dịch này không?'),
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
    return SafeArea(child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.Nen,
          title: Text(
            "Thêm loại giao dịch",
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
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: AbsorbPointer(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 0.04 * maxH,
                    width: 0.9 * maxW,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black, // Màu viền
                        width: 1, // Độ dày viền
                      ),
                    ),
                    child: DefaultTabController(
                      length: 2,
                      child: PrimaryContainer(
                        radius: 10,
                        child: Center(
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight
                                  .bold, // Chỉnh kiểu chữ nếu muốn
                            ),
                            unselectedLabelColor: Colors.black,
                            // Màu chữ cho tab không được chọn
                            unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight
                                  .bold, // Chỉnh kiểu chữ nếu muốn
                            ),
                            indicator: inset_box_shadow.BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: _categoryOption == 0 ? LinearGradient(
                                colors: [
                                  Color(0XFFffb578),
                                  AppColors.Cam,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ) :
                              LinearGradient(
                                  colors: [
                                    Color(0XFFaae386),
                                    AppColors.XanhLaDam,
                                  ]
                              ),
                            ),
                            tabs: const [
                              Tab(
                                text: 'Chi',
                              ),
                              Tab(
                                text: 'Thu',
                              ),
                            ],
                            onTap: (index) {
                  
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
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
                          labelText: 'Tên loại giao dịch',
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
                      onPressed: () =>
                      {
                        if(!_isEditable)
                          setState(() {
                            _isEditable = true;
                          })
                        else
                          _updateCurrency(context)
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
          ),
        ),
      ),
    ));
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;

  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inset_box_shadow.BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: [
          inset_box_shadow.BoxShadow(
            color: color ?? const Color(0xFFFEFFFA),
          ),
          const inset_box_shadow.BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0xFFFEFFFA),
            inset: true,
          ),
        ],
      ),
      child: child,
    );
  }
}
