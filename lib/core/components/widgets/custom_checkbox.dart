import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox(
      {super.key,
      this.label,
      this.value,
      this.onCheck,
      this.activeColor,
      this.hasBorder = false});
  final String? label;
  final dynamic value;
  final Function(dynamic)? onCheck;
  final Color? activeColor;
  final bool? hasBorder;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
          borderRadius: widget.hasBorder ?? false
              ? const BorderRadius.all(Radius.circular(10))
              : null,
          border: widget.hasBorder ?? false
              ? Border.all(color: Colors.grey)
              : null),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Checkbox(
            value: isSelected,
            onChanged: (value) {
              if (value ?? false) {
                widget.onCheck!(widget.value);
              }
              setState(() {
                isSelected = !isSelected;
              });
            },
            activeColor: widget.activeColor ?? Theme.of(context).primaryColor),
        Text(widget.label ?? '')
      ]),
    );
  }
}
