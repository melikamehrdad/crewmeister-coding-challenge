import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const FilterDropdown({
    required this.selectedType,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedType == 'All' ? Colors.black54 : Colors.green,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        value: selectedType,
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: selectedType != 'All' ? Colors.green : Colors.black54,
        ),
        underline: const SizedBox(),
        focusColor: Colors.transparent,
        onChanged: (value) => onChanged(value!),
        items: ['All', 'vacation', 'sickness']
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: TextStyle(
                      color: selectedType != 'All' && type == selectedType
                          ? Colors.green
                          : Colors.black54,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
