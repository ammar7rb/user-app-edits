import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final WidgetStateProperty<Color>? fillColor;
  final WidgetStateBorderSide? side;
  final Color? checkColor;
  final VisualDensity? visualDensity;

  final double size;

  final double checkSize;

  const CustomCheckbox({super.key, 
    required this.value,
    required this.onChanged,
    this.fillColor,
    this.side,
    this.checkColor,
    this.visualDensity,
    this.size = 24.0,
    this.checkSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final isChecked = value ?? false;
    final backgroundColor = fillColor?.resolve(
      isChecked ? {WidgetState.selected} : {},
    ) ??
        Theme.of(context).cardColor;
    final borderSide = side?.resolve(
      isChecked ? {WidgetState.selected} : {},
    ) ??
        BorderSide(
          color: Theme.of(context).hintColor.withValues(alpha: 0.5),
          width: 2,
        );

    return GestureDetector(
      onTap: () => onChanged?.call(!isChecked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: isChecked ? backgroundColor : Theme.of(context).cardColor,
          border: Border.fromBorderSide(borderSide),
          borderRadius: BorderRadius.circular(4),
        ),
        child: isChecked
            ? Center(
          child: Icon(
            fontWeight: FontWeight.w600,
            Icons.check,
            size: checkSize, // 👈 control tick mark size
            color: checkColor ?? Colors.white,
          ),
        )
            : null,
      ),
    );
  }
}
