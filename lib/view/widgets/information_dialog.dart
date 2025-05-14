import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InformationDialog extends StatelessWidget {
  const InformationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Absences Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<AbsencesBloc, AbsencesState>(
            builder: (context, state) {
              if (state.status == AbsencesStatus.success) {
                return Text(
                  'Total number of today absences is ${state.todayTotalAbsencesCount}\n'
                  'And number of all absences is ${state.totalAbsencesCount}\n'
                  'And number of all request is ${state.totalAbsencesRequestCount}\n',
                  style: const TextStyle(fontSize: 14),
                );
              } else if (state.status == AbsencesStatus.loading) {
                return const CircularProgressIndicator();
              } else {
                return const Text(
                  'Failed to load data',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
        ],
      ),
      actions: [
        TextButtonWithBorder(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Close',
          widgetColor: Colors.blue,
        ),
      ],
    );
  }
}
