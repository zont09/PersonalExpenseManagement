import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Components/option_tag.dart';
import 'package:personal_expense_management/Database/database_helper.dart';
import 'package:personal_expense_management/Database/initdata.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Screen/More/CategoryScreen/CategoryScreen.dart';
import 'package:personal_expense_management/Screen/More/CurrencyScreen/CurrencyScreen.dart';
import 'package:personal_expense_management/Screen/More/ReminderScreen/ReminderScreen.dart';
import 'package:personal_expense_management/Screen/More/SavingScreen/SavingScreen.dart';
import 'package:personal_expense_management/Screen/More/Wallet/WalletScreen.dart';
import 'package:personal_expense_management/Screen/More/testAI.dart';
import 'package:personal_expense_management/Screen/More/testScan/scanbill2.dart';
import 'package:personal_expense_management/Screen/More/testScan/testInvoiceBill.dart';
import 'package:personal_expense_management/Screen/More/testScan/testScan.dart';
import 'package:personal_expense_management/Service/NotificationService.dart';
import 'package:personal_expense_management/bloc/category_bloc/category_bloc.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_bloc.dart';
import 'package:personal_expense_management/bloc/saving_bloc/saving_bloc.dart';
import 'package:personal_expense_management/bloc/saving_detail_bloc/saving_detail_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class More extends StatelessWidget {
  const More({super.key});

  void _resetData() async {
    await DatabaseHelper().deleteDatabasee();
    // await Initdata.addDefaultData();
    await Initdata.addAllSampleData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false);
  }

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
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
        title: Text("Tính năng khác", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
        backgroundColor: AppColors.Nen,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16),
        height: maxH,
        width: maxW,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ScanBillPage()))
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (newContext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<WalletBloc>(
                                context),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<ParameterBloc>(
                                context),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<CurrencyBloc>(
                                context),
                          ),
                        ],
                        child: Walletscreen(),
                      ),
                    ),
                  )
                },
                child: OptionTag(name: "Quản lý ví", height: 60, width: maxW)
              ),
              // SizedBox(height: 10,),
              GestureDetector(
                onTap: () => {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ScanBillPage()))
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (newContext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<CategoryBloc>(
                                context),
                          ),
                        ],
                        child: Categoryscreen(),
                      ),
                    ),
                  )
                },
                child: OptionTag(name: "Quản lý loại giao dịch", height: 60, width: maxW),
              ),
              // SizedBox(height: 10,),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (newContext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<SavingBloc>(
                                context),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<SavingDetailBloc>(
                                context),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<WalletBloc>(
                                context),
                          ),
                          BlocProvider.value(
                            value:
                            BlocProvider.of<ParameterBloc>(context),
                          ),
                          BlocProvider.value(
                            value:
                            BlocProvider.of<CurrencyBloc>(context),
                          ),
                        ],
                        child: Savingscreen(),
                      ),
                    ),
                  )
                },
                child: OptionTag(name: "Quản lý khoản tiết kiệm", height: 60, width: maxW)
              ),
              // SizedBox(height: 10,),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (newContext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<ReminderBloc>(
                                context),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<RepeatOptionBloc>(
                                context),
                          ),
                        ],
                        child: Reminderscreen(),
                      ),
                    ),
                  )
                },
                child: OptionTag(name: "Quản lý lời nhắc", height: 60, width: maxW)
              ),
              // SizedBox(height: 10,),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (newContext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<CurrencyBloc>(
                                context),
                          ),
                          BlocProvider.value(
                            value:
                            BlocProvider.of<ParameterBloc>(context),
                          ),
                        ],
                        child: Currencyscreen(),
                      ),
                    ),
                  )
                },
                child: OptionTag(name: "Quản lý tiền tệ", height: 60, width: maxW)
              ),
              // GestureDetector(
              //   onTap: () async => {
              //     _resetData()
              //   },
              //   child: OptionTag(name: "reset data", height: 60, width: maxW)
              // ),
              // GestureDetector(
              //     onTap: () async => {
              //       NotificationService().showNotification(title: "Nhắc nhở",body: "Đây là nội dung")
              //     },
              //     child: OptionTag(name: "Test notification", height: 60, width: maxW)
              // ),
              // GestureDetector(
              //     onTap: () async =>
              //     {
              //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReceiptScannerScreen()))
              //
              //
              //     },
              //     child: OptionTag(name: "Scan bills", height: 60, width: maxW)
              // ),
            ],
          ),
        ),
      ),
    ));
  }
}
