import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/view/widgets/date_range_picker_button.dart';
import 'package:code_challenge/view/widgets/filter_dropdown.dart';
import 'package:code_challenge/view/widgets/reset_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({super.key});

  void _filterAbsences(BuildContext context, String selectedType,
      DateTimeRange? selectedDateRange) {
    BlocProvider.of<AbsencesBloc>(context).add(AbsencesFiltered(
      filterType: selectedType,
      dateRange: selectedDateRange,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: BlocBuilder<AbsencesBloc, AbsencesState>(
        builder: (context, state) {
          String selectedType = state.selectedType;
          DateTimeRange? selectedDateRange = state.selectedDateRange;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilterDropdown(
                      selectedType: selectedType,
                      onChanged: (value) {
                        _filterAbsences(context, value, selectedDateRange);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DateRangePickerButton(
                      selectedDateRange: selectedDateRange,
                      onDateRangePicked: (picked) {
                        _filterAbsences(context, selectedType, picked);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ResetButton(
                    onPressed: () {
                      _filterAbsences(context, 'All', null);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
