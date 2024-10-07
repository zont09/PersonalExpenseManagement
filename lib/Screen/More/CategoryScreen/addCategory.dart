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

class Addcategory extends StatefulWidget {
  const Addcategory({super.key});

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  final TextEditingController _controllerName = TextEditingController();
  int _categoryOption = 0;

  void _saveNewCurrency(BuildContext context) async {
    final listCat = await DatabaseHelper().getCategorys();
    if(_controllerName.text.length <= 0) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập tên loại giao dịch");
    }
    else if(listCat.any((item) => item.name == _controllerName.text)) {
      ErrorDialog.showErrorDialog(context, "Tên loại giao dịch đã tồn tại!");
    }
    else {
      Category newCat = Category(name: _controllerName.text, type: _categoryOption);
      context.read<CategoryBloc>().add(AddCategoryEvent(newCat));
      await context.read<CategoryBloc>().stream.firstWhere((state) => state is CategoryUpdateState);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
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
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
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
                            print("Index $index");
                            setState(() {
                              _categoryOption = index;
                            });
                          },
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
                        _saveNewCurrency(context)
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
