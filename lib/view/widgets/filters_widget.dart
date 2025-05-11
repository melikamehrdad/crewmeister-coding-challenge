import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedType == 'All'
                          ? Colors.black54
                          : Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: _selectedType != 'All'
                          ? Colors.green
                          : Colors.black54,
                    ),
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() => _selectedType = value!);
                      _filterAbsences();
                    },
                    items: ['All', 'vacation', 'sickness']
                        .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: TextStyle(
                                color: _selectedType != 'All' &&
                                        type == _selectedType
                                    ? Colors.green
                                    : Colors.black54,
                              ),
                            )))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2025),
                        initialDateRange: _selectedDateRange,
                        currentDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedDateRange = picked);
                        _filterAbsences();
                      }
                    },
                    icon: const Icon(
                      Icons.date_range,
                      color: Colors.black54,
                    ),
                    label: Text(
                      _selectedDateRange == null
                          ? 'Date'
                          : '${DateFormat('dd MMM').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM').format(_selectedDateRange!.end)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _selectedDateRange == null
                            ? Colors.black54
                            : Colors.green,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: _selectedDateRange == null
                              ? Colors.black54
                              : Colors.green,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                width: 70,
                child: TextButton(
                  onPressed: _resetFilters,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                  child: const Text('Reset', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
