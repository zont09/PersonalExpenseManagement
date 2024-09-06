import 'package:flutter/material.dart';
import 'package:personal_expense_management/Model/Wallet.dart';
import 'package:personal_expense_management/Resources/AppColor.dart';

class DropdownMenuW extends StatefulWidget {
  final List<Wallet> wallets;
  final double height;
  final double width;
  final Function(int) onChanged;

  const DropdownMenuW({
    required this.wallets,
    required this.height,
    required this.width,
    required this.onChanged,
  });

  @override
  _DropdownMenuWState createState() => _DropdownMenuWState();
}

class _DropdownMenuWState extends State<DropdownMenuW> {
  int? selectedWalletId; // Lưu trữ id của wallet được chọn

  @override
  void initState() {
    super.initState();
    if (widget.wallets.isNotEmpty) {
      selectedWalletId = widget.wallets.first.id; // Hoặc bạn có thể chọn theo điều kiện khác
    }
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
      child: DropdownButton<int>(
        value: selectedWalletId,
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          size: 14,
          color: AppColors.XanhDuong,
        ),
        iconSize: 20,
        style: TextStyle(fontSize: 14,),
        onChanged: (int? newValue) {
          if (newValue != null) {
            setState(() {
              selectedWalletId = newValue; // Cập nhật giá trị được chọn
            });
            widget.onChanged(newValue); // Gọi hàm onChanged khi giá trị thay đổi
          }
        },
        items: widget.wallets.map<DropdownMenuItem<int>>((Wallet wallet) {
          return DropdownMenuItem<int>(
            value: wallet.id, // Sử dụng wallet.id làm giá trị
            child: Text(
              wallet.name, // Hiển thị wallet.name
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }
}
