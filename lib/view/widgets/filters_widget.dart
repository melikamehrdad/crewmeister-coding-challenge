import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/view/widgets/filters_widgets.dart/filters_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiltersWidget extends StatefulWidget {
  const FiltersWidget({super.key});

  @override
  State<FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  String _selectedType = 'All';
  DateTimeRange? _selectedDateRange;

  void _filterAbsences() {
    BlocProvider.of<AbsencesBloc>(context).add(AbsencesFiltered(
      filterType: _selectedType,
      dateRange: _selectedDateRange,
    ));
  }

  void _resetFilters() {
    setState(() {
      _selectedType = 'All';
      _selectedDateRange = null;
    });
    _filterAbsences();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilterDropdown(
                  selectedType: _selectedType,
                  onChanged: (value) {
                    setState(() => _selectedType = value);
                    _filterAbsences();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DateRangePickerButton(
                  selectedDateRange: _selectedDateRange,
                  onDateRangePicked: (picked) {
                    setState(() => _selectedDateRange = picked);
                    _filterAbsences();
                  },
                ),
              ),
              const SizedBox(width: 12),
              ResetButton(onPressed: _resetFilters),
            ],
          ),
        ],
      ),
    );
  }
}
