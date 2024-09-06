import 'package:flutter/material.dart';
import 'package:personal_expense_management/Screen/Budget/BudgetScreen.dart';
import 'package:personal_expense_management/Screen/More/More.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Screen/Statistical/Statistical.dart';
import 'package:personal_expense_management/Screen/Transaction/TransactionScreen.dart';
void main() {
  runApp(const MyApp());
}

class Routes {
  static String Transaction = '/transaction';
  static String Statistical = '/statistical';
  static String Budget = '/budget';
  static String More = '/more';
  // static String Home = '/home';
  // static String Home = '/home';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF8F8F8)),
        useMaterial3: true,
      ),
      home: SafeArea(child: HomeScreen()),
      routes: {
        Routes.Transaction: (context) => Transaction(),
        Routes.Statistical: (context) => Statistical(),
        Routes.Budget: (context) => BudgetScreen(),
        Routes.More: (context) => More(),
      },
    );
  }
}
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Transaction(),
    Statistical(),
    BudgetScreen(),
    More(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
        shape: CircleBorder(),
        backgroundColor: AppColors.XanhDuong,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0.0),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: AppColors.Nen,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => {
                  _onItemTapped(0)
                },
                child: Container(
                  width: 63,
                  child: Column(
                    children: [
                      Icon(Icons.currency_exchange, color: _selectedIndex == 0 ? AppColors.XanhDuong : Colors.black,),
                      Text("Giao dịch", style: TextStyle(
                        color: _selectedIndex == 0 ? AppColors.XanhDuong : Colors.black,
                        fontSize: 12),)
                    ],
                  ),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),

              InkWell(
                onTap: () => {
                  _onItemTapped(1)
                },
                child: Container(
                  width: 63,
                  child: Column(
                    children: [
                      Icon(Icons.pie_chart, color: _selectedIndex == 1 ? AppColors.XanhDuong : Colors.black,),
                      Text("Thống kê", style: TextStyle(
                        color: _selectedIndex == 1 ? AppColors.XanhDuong : Colors.black, fontSize: 12),)
                    ],
                  ),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              SizedBox(width: 20,),

              InkWell(
                onTap: () => {
                  _onItemTapped(2)
                },
                child: Container(
                  width: 63,
                  child: Column(
                    children: [
                      Icon(Icons.savings, color: _selectedIndex == 2 ? AppColors.XanhDuong : Colors.black,),
                      Text("Ngân sách", style: TextStyle(color: _selectedIndex == 2 ? AppColors.XanhDuong : Colors.black,
                          fontSize: 12),)
                    ],
                  ),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              InkWell(
                onTap: () => {
                  _onItemTapped(3)
                },
                child: Container(
                  width: 63,
                  child: Column(
                    children: [
                      Icon(Icons.more_horiz, color: _selectedIndex == 3 ? AppColors.XanhDuong : Colors.black,),
                      Text("Thêm", style: TextStyle(color: _selectedIndex == 3 ? AppColors.XanhDuong : Colors.black,
                          fontSize: 12),)
                    ],
                  ),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
