import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Screen/More/ReminderScreen/addReminderScreen.dart';
import 'package:personal_expense_management/Screen/More/ReminderScreen/detailReminderScreen.dart';
import 'package:personal_expense_management/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:personal_expense_management/bloc/reminder_bloc/reminder_state.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_bloc.dart';

class Reminderscreen extends StatefulWidget {
  const Reminderscreen({super.key});

  @override
  State<Reminderscreen> createState() => _ReminderscreenState();
}

class _ReminderscreenState extends State<Reminderscreen> {
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
              colors: [Color(0xFf339DD4), Color(0xFF00D0CC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight, // Điểm kết thúc của gradient
            ),
          ),
        ),
        title: Text(
          "Quản lý lời nhắc",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          TextButton(
              onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (newContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: BlocProvider.of<ReminderBloc>(context),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<RepeatOptionBloc>(context),
                            ),
                          ],
                          child: Addreminderscreen(),
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
        color: Colors.white,
        child: SingleChildScrollView(
          child: BlocBuilder<ReminderBloc, ReminderState>(
            builder: (context, state) {
              if(state is ReminderUpdateState) {
                final reminders = state.updRem;
                return Column(
                  children: reminders.map((item) =>
                    Column(
                      children: [
                        SizedBox(height: 5,),
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (newContext) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: BlocProvider.of<ReminderBloc>(context),
                                    ),
                                    BlocProvider.value(
                                      value: BlocProvider.of<RepeatOptionBloc>(context),
                                    ),
                                  ],
                                  child: Detailreminderscreen(rem: item),
                                ),
                              ),
                            )
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Container(
                              height: 70,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xFFDADADA),
                                          width: 1))),
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment:
                                        Alignment.centerLeft,
                                        child: Text(
                                          item.description,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                              FontWeight.bold,
                                          overflow: TextOverflow.ellipsis),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment:
                                        Alignment.centerLeft,
                                        child: Text(
                                          "${DateFormat('dd/MM/yyyy').format(DateTime.parse(item.date))}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                              Color(0xFF787878)),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ).toList(),
                );
              }
              else {
                return Text("");
              }
            },
          ),
        ),
      ),
    ));
  }
}
