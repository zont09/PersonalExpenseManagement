import 'package:flutter/material.dart';

class AddDropdown extends StatefulWidget {
  final String title;
  final TextEditingController controllerTF;
  final List<dynamic> listData;
  final Function(dynamic) onChanged;

  const AddDropdown(
      {super.key,
      required this.title,
      required this.controllerTF,
      required this.listData,
      required this.onChanged});

  @override
  State<AddDropdown> createState() => _AddDropdownState();
}

class _AddDropdownState extends State<AddDropdown> {
  late TextEditingController _controllerCategory;
  late dynamic _selectItem;

  void _showItemOption(BuildContext context) {
    final listItem = widget.listData;
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
                      "Loại giao dịch",
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
                      children: listItem.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black26, // Màu của đường viền
                                  width: 1.0, // Độ dày của đường viền
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Text(item.name),
                              onTap: () {
                                _selectItemOption(item.name, item);
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

  void _selectItemOption(String value, dynamic item) {
    setState(() {
      _controllerCategory.text = value;
      _selectItem = item;
      widget.onChanged(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    _controllerCategory = widget.controllerTF;
    return Row(
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
                widget.title,
                style: TextStyle(fontSize: 16),
              )),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => {_showItemOption(context)},
            child: AbsorbPointer(
              child: TextField(
                  controller: _controllerCategory,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: "Thể loại"),
                  onChanged: (value) {}),
            ),
          ),
        )
      ],
    );
  }
}
