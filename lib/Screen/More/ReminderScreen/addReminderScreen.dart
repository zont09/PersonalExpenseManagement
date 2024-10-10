import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_management/Components/datetime_picker.dart';
import 'package:personal_expense_management/Components/error_dialog.dart';
import 'package:personal_expense_management/Model/Reminder.dart';
import 'package:personal_expense_management/Model/RepeatOption.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';
import 'package:personal_expense_management/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:personal_expense_management/bloc/reminder_bloc/reminder_event.dart';
import 'package:personal_expense_management/bloc/reminder_bloc/reminder_state.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_bloc.dart';
import 'package:personal_expense_management/bloc/repeat_option_bloc/repeat_option_state.dart';

import '../../../Service/NotificationService.dart';

class Addreminderscreen extends StatefulWidget {
  const Addreminderscreen({super.key});

  @override
  State<Addreminderscreen> createState() => _AddreminderscreenState();
}

class _AddreminderscreenState extends State<Addreminderscreen> {
  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerRepeat = TextEditingController();
  RepeatOption _selectRepeat = RepeatOption(id: 1,option_name: "Không");

  @override
  void initState() {
    _controllerDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _controllerRepeat.text = "Không";
    _controllerDescription.text = "";
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

  void _selectRepeatOption(String value, RepeatOption item) {
    setState(() {
      _controllerRepeat.text = value;
      _selectRepeat = item;
    });
  }

  void _saveNewReminder(BuildContext context) async {
    if(_controllerDescription.text.isEmpty) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập mô tả lời nhắc");
    }
    else {
      Reminder newRem = Reminder(date: DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(_controllerDate.text)), description: _controllerDescription.text, repeat_option: _selectRepeat);
      context.read<ReminderBloc>().add(AddReminderEvent(newRem));
      int idRem = -1;
      await context.read<ReminderBloc>().stream.firstWhere((state) {
        if (state is ReminderUpdateState) {
          idRem = state.updRem.last.id ?? -1;
          return true;
        }
        return false;
      });
      print("ID Reminder: $idRem");
      if(idRem != -1)
      await NotificationService().scheduleNotification(
        id: idRem,
        title: 'Lời nhắc',
        body: _controllerDescription.text,
        scheduledDate: DateFormat("dd/MM/yyyy").parse(_controllerDate.text),
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height;
    final maxW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
                appBar: AppBar(
          title: Text(
            "Thêm lời nhắc",
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
                ),
                body: Container(
          height: maxH,
          width: maxW,
          margin: EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
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
                              "Thời gian",
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => {
                            openDatetimePicker(context, _controllerDate,
                                (newDate) => {_controllerDate.text = newDate})
                          },
                          child: AbsorbPointer(
                            child: TextField(
                                controller: _controllerDate,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: "Thời gian nhắc"),
                                onChanged: (value) {}),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
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
                          onChanged: (value) {},
                        ),
                      )
                    ],
                  ),
                ),
                BlocBuilder<RepeatOptionBloc, RepeatOptionState>(
                  builder: (context, state) {
                    if(state is RepeatOptionUpdateState) {
                      final listRep = state.updRep;
                      return Container(
                        color: Colors.white,
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
                        ),
                      );
                    }
                    else {
                      return Text("");
                    }
                  },
                )
              ],
            ),
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
                    onPressed: () => {
                      _saveNewReminder(context)
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
