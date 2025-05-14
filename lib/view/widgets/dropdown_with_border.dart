import 'package:code_challenge/utils.dart/app_colors.dart';
import 'package:flutter/material.dart';

class DropdownWithBorder extends StatelessWidget {
  final List<String> types;
  final String selectedType;
  final ValueChanged<String> onChanged;

  const DropdownWithBorder({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.types = const ['All', 'Vacation', 'Sickness'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedType == types.first
              ? AppColors.secondaryColor1
              : AppColors.accentColor1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        value: selectedType,
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: selectedType == types.first
              ? AppColors.secondaryColor1
              : AppColors.accentColor1,
        ),
        underline: const SizedBox(),
        focusColor: Colors.transparent,
        onChanged: (value) => onChanged(value!),
        items: types
            .map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: TextStyle(
                    color: selectedType != types.first && type == selectedType
                        ? AppColors.accentColor1
                        : AppColors.secondaryColor1,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
