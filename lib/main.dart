import 'package:flutter/material.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Database/initdata.dart';
import 'package:personal_expense_management/Model/Category.dart';
import 'package:personal_expense_management/Model/Parameter.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Model/TransactionModel.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Screen/Budget/BudgetScreen.dart';
import 'package:personal_expense_management/Screen/More/More.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Screen/Statistical/Statistical.dart';
import 'package:personal_expense_management/Screen/Transaction/TransactionScreen.dart';
import 'package:intl/intl.dart'; // Nhập thư viện intl
import 'package:intl/date_symbol_data_local.dart'; // Nhập để sử dụng hàm initializeDateFormatting
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Screen/Transaction/addTransaction.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_bloc.dart';
import 'package:personal_expense_management/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_select_bloc/wallet_select_bloc.dart';

void main() {
  Intl.defaultLocale = 'vi_VN'; // Hoặc locale khác nếu cần
  initializeDateFormatting(Intl.defaultLocale);
  runApp(const MyApp());
}

class Routes {
  static String Transaction = '/transaction';
  static String Statistical = '/statistical';
  static String Budget = '/budget';
  static String More = '/more';
  static String AddTransaction = '/addtransaction';
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
        Routes.AddTransaction: (context) => Addtransaction(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate, // Thêm dòng này
      ],

      supportedLocales: [
        const Locale('vi', 'VN'),
        const Locale('en', ''), // Hoặc các locale khác mà bạn hỗ trợ
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Future<List<dynamic>>? _combinedFuture;
  DatabaseHelper dbHelper = DatabaseHelper();
  final List<Widget> _pages = [
    Transaction(),
    Statistical(),
    BudgetScreen(),
    More(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> _initializeData() async {
    // await Initdata.addAllSampleData();
    // await Initdata.addWallet();
    // await dbHelper.deleteDatabasee() ;
    _combinedFuture =
        Future.wait([dbHelper.getWallet(), dbHelper.getTransactions(), dbHelper.getParameters(), dbHelper.getCategorys(),
                    dbHelper.getRepeatOptions()]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _combinedFuture,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
            child: CircularProgressIndicator()); // Loading indicator
      } else if (snapshot.hasError) {
        return Center(
            child: Text("Error: ${snapshot.error}")); // Error handling
      } else if (snapshot.hasData) {
        final List<Wallet> wallets = snapshot.data![0];
        final List<TransactionModel> transactions = snapshot.data![1];
        final List<Parameter> parameters = snapshot.data![2];
        final List<Category> categories = snapshot.data![3];
        final List<RepeatOption> repeat_options = snapshot.data![4];
        final currencyGB = parameters.first.currency;
        // print("RepeatOption: ${repeat_options.first.id} - ${repeat_options.first.option_name}");
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TransactionBloc(transactions),
          ),
          BlocProvider(
            create: (context) => WalletBloc(wallets),
          ),
          BlocProvider(
            create: (context) => WalletSelectBloc(wallets),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(categories),
          ),
          BlocProvider(
            create: (context) => RepeatOptionBloc(repeat_options),
          ),
          BlocProvider(
            create: (context) => ParameterBloc(parameters.first),
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
              ),
              floatingActionButton: AddTransactionButton(),
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
                        onTap: () => {_onItemTapped(0)},
                        child: Container(
                          width: 63,
                          child: Column(
                            children: [
                              Icon(
                                Icons.currency_exchange,
                                color: _selectedIndex == 0
                                    ? AppColors.XanhDuong
                                    : Colors.black,
                              ),
                              Text(
                                "Giao dịch",
                                style: TextStyle(
                                    color: _selectedIndex == 0
                                        ? AppColors.XanhDuong
                                        : Colors.black,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      InkWell(
                        onTap: () => {_onItemTapped(1)},
                        child: Container(
                          width: 63,
                          child: Column(
                            children: [
                              Icon(
                                Icons.pie_chart,
                                color: _selectedIndex == 1
                                    ? AppColors.XanhDuong
                                    : Colors.black,
                              ),
                              Text(
                                "Thống kê",
                                style: TextStyle(
                                    color: _selectedIndex == 1
                                        ? AppColors.XanhDuong
                                        : Colors.black,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () => {_onItemTapped(2)},
                        child: Container(
                          width: 63,
                          child: Column(
                            children: [
                              Icon(
                                Icons.savings,
                                color: _selectedIndex == 2
                                    ? AppColors.XanhDuong
                                    : Colors.black,
                              ),
                              Text(
                                "Ngân sách",
                                style: TextStyle(
                                    color: _selectedIndex == 2
                                        ? AppColors.XanhDuong
                                        : Colors.black,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      InkWell(
                        onTap: () => {_onItemTapped(3)},
                        child: Container(
                          width: 63,
                          child: Column(
                            children: [
                              Icon(
                                Icons.more_horiz,
                                color: _selectedIndex == 3
                                    ? AppColors.XanhDuong
                                    : Colors.black,
                              ),
                              Text(
                                "Thêm",
                                style: TextStyle(
                                    color: _selectedIndex == 3
                                        ? AppColors.XanhDuong
                                        : Colors.black,
                                    fontSize: 12),
                              )
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
        ),
      );
          } else {
          return Center(child: Text("Failed to load Main Transaction"));
          }
        },
    );
  }
}

class AddTransactionButton extends StatelessWidget {
  const AddTransactionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (newContext) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<CategoryBloc>(context),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<WalletBloc>(context),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<RepeatOptionBloc>(context),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<TransactionBloc>(context),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<ParameterBloc>(context),
                ),
              ],
              child: Addtransaction(),
            ),
          ),
        );
      },
      child: Icon(Icons.add, color: Colors.white),
      shape: CircleBorder(),
      backgroundColor: AppColors.XanhDuong,
    );
  }
}
