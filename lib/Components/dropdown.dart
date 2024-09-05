import 'package:flutter/material.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';

class DropdownMenuW extends StatefulWidget {
  final List<String> items;
  final double height;
  final double width;
  const DropdownMenuW({super.key, required this.items, required this.height, required this.width});

  @override
  State<DropdownMenuW> createState() => _DropdownMenuW();
}

class _DropdownMenuW extends State<DropdownMenuW> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.XanhDuong),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down, size: 14, color: AppColors.XanhDuong,),
        iconSize: 20,
        style: TextStyle(fontSize: 14),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          );
        }).toList(),
      ),
    );
  }
}