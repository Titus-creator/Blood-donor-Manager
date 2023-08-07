import 'package:blood_bridge/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabItem extends ConsumerWidget {
  const TabItem(
      {super.key, this.title, this.icon, this.isSelected, this.onTap});
  final String? title;
  final IconData? icon;
  final bool? isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected! ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected! ? Colors.red : Colors.black),
              const SizedBox(height: 5),
              Text(
                title!,
                style: normalText(
                  color: isSelected! ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ]),
      ),
    );
  }
}
