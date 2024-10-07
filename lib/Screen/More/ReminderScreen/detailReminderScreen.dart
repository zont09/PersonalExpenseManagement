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

class Detailreminderscreen extends StatefulWidget {
  final Reminder rem;

  const Detailreminderscreen({super.key, required this.rem});

  @override
  State<Detailreminderscreen> createState() => _DetailreminderscreenState();
}

class _DetailreminderscreenState extends State<Detailreminderscreen> {
  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerRepeat = TextEditingController();
  RepeatOption _selectRepeat = RepeatOption(id: 1, option_name: "Không");
  bool _isEditable = false;

  @override
  void initState() {
    _controllerDate.text =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.rem.date));
    _controllerRepeat.text = widget.rem.repeat_option.option_name;
    _controllerDescription.text = widget.rem.description;
    _selectRepeat = widget.rem.repeat_option;
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
                      children: listRep.map((item) {
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

  void _updateNewReminder(BuildContext context) async {
    if (_controllerDescription.text.isEmpty) {
      ErrorDialog.showErrorDialog(context, "Chưa nhập mô tả lời nhắc");
    } else {
      Reminder newRem = Reminder(
          id: widget.rem.id,
          date: DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd/MM/yyyy').parse(_controllerDate.text)),
          description: _controllerDescription.text,
          repeat_option: _selectRepeat);
      context.read<ReminderBloc>().add(UpdateReminderEvent(newRem));
      await context
          .read<ReminderBloc>()
          .stream
          .firstWhere((state) => state is ReminderUpdateState);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _deleteTransaction(BuildContext context) async {
    context.read<ReminderBloc>().add(RemoveReminderEvent(widget.rem));
    await context
        .read<ReminderBloc>()
        .stream
        .firstWhere((state) => state is ReminderUpdateState);
    if (mounted) {
      print("Pop in delete");
      Navigator.of(context).pop();
    }
  }

  void _showDeleteConfirmDialog(BuildContext ncontext) {
    print("Xoa2? ${ncontext}");
    ;
    showDialog(
      context: ncontext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa giao dịch này không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                _deleteTransaction(ncontext);
                if (mounted) {
                  print("Pop in dialog");
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
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print("Xoa?");
                _showDeleteConfirmDialog(context);
                // await if(mounted)
                //   Navigator.of(context).pop();
              },
              child: Text(
                'Xóa',
                style: TextStyle(
                  color: Colors.black, // Màu chữ của nút
                  fontSize: 16, // Kích thước chữ
                ),
              ),
            ),
          ],
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
                            if (_isEditable)
                              openDatetimePicker(context, _controllerDate,
                                  (newDate) => {_controllerDate.text = newDate})
                          },
                          child: AbsorbPointer(
                            child: TextField(
                                enabled: _isEditable,
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
                          enabled: _isEditable,
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
                    if (state is RepeatOptionUpdateState) {
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
                                  if (_isEditable)
                                    _showRepeatOption(context, listRep)
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                      enabled: _isEditable,
                                      controller: _controllerRepeat,
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: "Lặp lại"),
                                      onChanged: (value) {}),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
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
            margin: EdgeInsets.only(
              bottom: 10,
            ),
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
                      if (_isEditable)
                        _updateNewReminder(context)
                      else
                        setState(() {
                          _isEditable = true;
                        })
                    },
                child: Center(
                  child: Text(
                    _isEditable ? "Lưu" : "Sửa",
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
