import 'package:flutter/material.dart';

class DropdownMenuBoxWidget extends StatefulWidget {
  final List<String> itemList;
  final String hintText;
  final Function(String?)? onChanged;
  final String? initialValue;
  const DropdownMenuBoxWidget({
    super.key,
    required this.itemList,
    required this.hintText,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<DropdownMenuBoxWidget> createState() => _DropdownMenuBoxState();
}

class _DropdownMenuBoxState extends State<DropdownMenuBoxWidget> {
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: DropdownButtonFormField(
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          borderRadius: BorderRadius.circular(6),
          hint: Text(widget.hintText),
          initialValue: selectedItem,
          onChanged: (value) {
            setState(() {
              selectedItem = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          items: widget.itemList.map((String service) {
            return DropdownMenuItem(
              value: service,
              child: Text(
                service,
                style: const TextStyle(color: Colors.black54),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
