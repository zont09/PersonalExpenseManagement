import 'package:flutter/material.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';

class OptionTag extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  const OptionTag({super.key, required this.name, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin:  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Màu của shadow
            spreadRadius: 1, // Độ lan rộng của shadow
            blurRadius: 3, // Độ mờ của shadow
            offset: const Offset(0, 3), // Vị trí của shadow
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black, overflow: TextOverflow.ellipsis),),
            const Icon(Icons.keyboard_arrow_right, size: 20, color: Colors.black,)
          ],
        ),
      ),
    );
  }
}
