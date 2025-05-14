import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/utils.dart/app_colors.dart';
import 'package:code_challenge/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InformationDialog extends StatelessWidget {
  const InformationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Absences Information',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: BlocBuilder<AbsencesBloc, AbsencesState>(
        builder: (context, state) {
          if (state.status == AbsencesStatus.success) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    'Today\'s Absences:', '${state.todayTotalAbsencesCount}'),
                const SizedBox(height: 8),
                _buildInfoRow('Total Absences:', '${state.totalAbsencesCount}'),
                const SizedBox(height: 8),
                _buildInfoRow(
                    'Total Requests:', '${state.totalAbsencesRequestCount}'),
              ],
            );
          } else if (state.status == AbsencesStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Text(
              'Failed to load data',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            );
          }
        },
      ),
      actions: [
        Center(
          child: TextButtonWithBorder(
            onPressed: () {
              Navigator.of(context).pop();
            },
            title: 'Close',
            widgetColor: AppColors.accentColor1,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
