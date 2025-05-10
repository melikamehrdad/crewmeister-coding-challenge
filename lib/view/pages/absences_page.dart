
import 'package:code_challenge/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});

  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  final int _pageSize = 10;
  List<Absence> _absences = [];
  List<Absence> _filteredAbsences = [];
  int _currentPage = 0;
  String _selectedType = 'All';
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadFakeData();
  }

  void _loadFakeData() {
    _absences = List.generate(
        25,
        (index) => Absence(
              userId: index,
              type: index % 2 == 0 ? "vacation" : "sickness",
              startDate:
                  "2024-05-${((index % 28) + 1).toString().padLeft(2, '0')}",
              endDate:
                  "2024-05-${((index % 28) + 2).toString().padLeft(2, '0')}",
              memberNote: index % 3 == 0 ? "Needs rest" : "",
              admitterNote: index % 5 == 0 ? "Approved" : "",
              status: ["Confirmed", "Rejected", "Requested"][index % 3],
              createdAt: "2024-05-${(index % 28) + 1}",
              crewId: index + 1,
              id: index,
            ));
    _filteredAbsences = _absences;
  }

  void _filterAbsences() {
    setState(() {
      _filteredAbsences = _absences.where((absence) {
        final matchType =
            _selectedType == 'All' || absence.type == _selectedType;
        final matchDate = _selectedDateRange == null ||
            (DateTime.parse(absence.startDate)
                    .isAfter(_selectedDateRange!.start) &&
                DateTime.parse(absence.endDate)
                    .isBefore(_selectedDateRange!.end));
        return matchType && matchDate;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedType = 'All';
      _selectedDateRange = null;
    });
    _filterAbsences();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green.shade200;
      case 'Rejected':
        return Colors.red.shade200;
      default:
        return Colors.orange.shade200;
    }
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Filters', style: TextStyle(fontSize: 18)),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    width: 70,
                    child: TextButton(
                      onPressed: _resetFilters,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                      child: const Text('Reset',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        onChanged: (value) {
                          setState(() => _selectedType = value!);
                          _filterAbsences();
                        },
                        decoration: InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        items: ['All', 'vacation', 'sickness']
                            .map((type) => DropdownMenuItem(
                                value: type, child: Text(type)))
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
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _selectedDateRange == null
                              ? 'Date'
                              : '${DateFormat('dd MMM').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM').format(_selectedDateRange!.end)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbsenceCard(Absence absence) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Member #${absence.userId}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(absence.status),
                  backgroundColor: _getStatusColor(absence.status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Type: ${absence.type}", style: const TextStyle(fontSize: 14)),
            Text("Period: ${absence.startDate} - ${absence.endDate}",
                style: const TextStyle(fontSize: 14)),
            if (absence.memberNote.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("Member note: ${absence.memberNote}",
                    style: const TextStyle(
                        fontSize: 13, fontStyle: FontStyle.italic)),
              ),
            if (absence.admitterNote.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("Admitter note: ${absence.admitterNote}",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed:
              _currentPage > 0 ? () => setState(() => _currentPage--) : null,
          child: const Text('Previous'),
        ),
        Text('Page ${_currentPage + 1}'),
        ElevatedButton(
          onPressed: (_currentPage + 1) * _pageSize < _filteredAbsences.length
              ? () => setState(() => _currentPage++)
              : null,
          child: const Text('Next'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = _currentPage * _pageSize;
    final end = (_currentPage + 1) * _pageSize;
    final pageItems = _filteredAbsences.sublist(
        start, end > _filteredAbsences.length ? _filteredAbsences.length : end);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Absences'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total number of absences is ${_filteredAbsences.length}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pageItems.length,
              itemBuilder: (context, index) =>
                  _buildAbsenceCard(pageItems[index]),
            ),
          ),
          _buildPaginationControls(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
