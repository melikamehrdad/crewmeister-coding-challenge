import 'package:code_challenge/presentation/bloc/absences_bloc.dart';
import 'package:code_challenge/presentation/utils/app_colors.dart';
import 'package:code_challenge/presentation/widgets/date_range_picker_button.dart';
import 'package:code_challenge/presentation/widgets/dropdown_with_border.dart';
import 'package:code_challenge/presentation/widgets/text_button_with_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({super.key});

  void _filterAbsences(
    BuildContext context,
    String selectedType,
    DateTimeRange? selectedDateRange,
  ) {
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
                    child: DropdownWithBorder(
                      types: const [
                        'All',
                        'vacation',
                        'sickness',
                      ],
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
                  SizedBox(
                    height: 50,
                    width: 70,
                    child: TextButtonWithBorder(
                      title: 'Reset',
                      widgetColor: AppColors.accentColor1,
                      onPressed: () {
                        _filterAbsences(context, 'All', null);
                      },
                    ),
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
