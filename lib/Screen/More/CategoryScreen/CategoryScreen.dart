import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset_box_shadow;
import 'package:personal_expense_management/Screen/More/CategoryScreen/addCategory.dart';
import 'package:personal_expense_management/Screen/More/CategoryScreen/detailCategory.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_bloc.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_state.dart';

class Categoryscreen extends StatefulWidget {
  const Categoryscreen({super.key});

  @override
  State<Categoryscreen> createState() => _CategoryscreenState();
}

class _CategoryscreenState extends State<Categoryscreen> {
  int _categoryOption = 0;

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height;
    final maxW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFf339DD4),
                Color(0xFF00D0CC)
              ],
              begin: Alignment.topLeft,
              end: Alignment
                  .bottomRight, // Điểm kết thúc của gradient
            ),
          ),
        ),
        title: const Text(
          "Quản lý loại giao dịch",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (newContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: BlocProvider.of<CategoryBloc>(context),
                            ),
                          ],
                          child: Addcategory(),
                        ),
                      ),
                    )
                  },
              child: Text(
                "Thêm",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ))
        ],
      ),
      body: Container(
        height: maxH,
        width: maxW,
        margin: EdgeInsets.only(top: 10),
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
                          fontWeight:
                              FontWeight.bold, // Chỉnh kiểu chữ nếu muốn
                        ),
                        unselectedLabelColor: Colors.black,
                        // Màu chữ cho tab không được chọn
                        unselectedLabelStyle: const TextStyle(
                          fontWeight:
                              FontWeight.bold, // Chỉnh kiểu chữ nếu muốn
                        ),
                        indicator: inset_box_shadow.BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: _categoryOption == 0
                              ? LinearGradient(
                                  colors: [
                                    Color(0XFFffb578),
                                    AppColors.Cam,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : LinearGradient(colors: [
                                  Color(0XFFaae386),
                                  AppColors.XanhLaDam,
                                ]),
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
            SizedBox(
              height: 8,
            ),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryUpdateState) {
                  final listCategory = state.updCategory;
                  final listCatIncome =
                      listCategory.where((item) => item.type == 1).toList();
                  final listCatoutcome =
                      listCategory.where((item) => item.type == 0).toList();

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _categoryOption == 0
                            ? listCatoutcome
                                .map(
                                  (item) => GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (newContext) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(
                                                value: BlocProvider.of<CategoryBloc>(
                                                    context),
                                              ),

                                            ],
                                            child: Detailcategory(cat: item),
                                          ),
                                        ),
                                      )
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16.0),
                                      color: AppColors.Nen,
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0xFFDADADA),
                                                    width: 1))),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "${item.name}",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                            : listCatIncome
                                .map(
                                  (item) => GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (newContext) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(
                                                value: BlocProvider.of<CategoryBloc>(
                                                    context),
                                              ),

                                            ],
                                            child: Detailcategory(cat: item),
                                          ),
                                        ),
                                      )
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16.0),
                                      color: AppColors.Nen,
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0xFFDADADA),
                                                    width: 1))),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    item.name,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        // children: [
                        //   Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 16.0),
                        //     color: AppColors.Nen,
                        //     child: Container(
                        //       height: 60,
                        //       width: double.infinity,
                        //       decoration: BoxDecoration(
                        //           border: Border(
                        //               bottom:
                        //               BorderSide(color: Color(0xFFDADADA), width: 1))),
                        //       child: Column(
                        //         children: [
                        //           Expanded(
                        //               flex: 1,
                        //               child: Align(
                        //                 alignment: Alignment.centerLeft,
                        //                 child: Text("ABCCCC", style: TextStyle(
                        //                     fontSize: 18,
                        //                     fontWeight: FontWeight.bold),),
                        //               )),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ],
                      ),
                    ),
                  );
                } else
                  return Text("");
              },
            ),
          ],
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
