import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/Screen/More/CurrencyScreen/CurrencyScreen.dart';
import 'package:personal_expense_management/Screen/More/Wallet/WalletScreen.dart';
import 'package:personal_expense_management/Screen/More/testAI.dart';
import 'package:personal_expense_management/Screen/More/testScan/testScan.dart';
import 'package:personal_expense_management/bloc/currency_bloc/currency_bloc.dart';
import 'package:personal_expense_management/bloc/parameter_bloc/parameter_bloc.dart';
import 'package:personal_expense_management/bloc/wallet_bloc/wallet_bloc.dart';

class More extends StatelessWidget {
  const More({super.key});
  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Tính năng khác", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        backgroundColor: AppColors.Nen,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16),
        height: maxH,
        width: maxW,
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
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.all(16),
                  height: 80,
                  width: maxW,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quản lý ví", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.XanhDuong),),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền của Container
                    border: Border.all(
                      color: AppColors.XanhDuong, // Màu của border
                      width: 2.0, // Độ dày của border
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0), // Độ cong của các góc
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () => {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Workout()))
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.all(16),
                  height: 80,
                  width: maxW,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quản lý khoản tiết kiệm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.XanhDuong),),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền của Container
                    border: Border.all(
                      color: AppColors.XanhDuong, // Màu của border
                      width: 2.0, // Độ dày của border
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0), // Độ cong của các góc
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () => {
                  print("CLicked")
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.all(16),
                  height: 80,
                  width: maxW,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quản lý lời nhắc", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.XanhDuong),),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền của Container
                    border: Border.all(
                      color: AppColors.XanhDuong, // Màu của border
                      width: 2.0, // Độ dày của border
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0), // Độ cong của các góc
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
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
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.all(16),
                  height: 80,
                  width: maxW,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quản lý tiền tệ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.XanhDuong),),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền của Container
                    border: Border.all(
                      color: AppColors.XanhDuong, // Màu của border
                      width: 2.0, // Độ dày của border
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0), // Độ cong của các góc
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
