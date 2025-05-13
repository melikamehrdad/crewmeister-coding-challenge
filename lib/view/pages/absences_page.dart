import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/view/widgets/absence_card_widget.dart';
import 'package:code_challenge/view/widgets/filters_widget.dart';
import 'package:code_challenge/view/widgets/loading_widget.dart';
import 'package:code_challenge/view/widgets/text_button_with_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({super.key});

  @override
  State<AbsencesPage> createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AbsencesBloc>(context).add(AbsencesFetched());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        BlocProvider.of<AbsencesBloc>(context).add(
          AbsencesLoadMore(
            pageNumber:
                BlocProvider.of<AbsencesBloc>(context).state.correctPageNumber +
                    1,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absences Manager'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButtonWithBorder(
              title: 'Export',
              widgetColor: Colors.white,
              onPressed: () {
                BlocProvider.of<AbsencesBloc>(context)
                    .add(AbsencesExportDataFileCreated());
              },
            ),
          ),
        ],
      ),
      body: BlocListener<AbsencesBloc, AbsencesState>(
        listener: (context, state) {
          if (state.status == AbsencesStatus.fileExported) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data file exported successfully!'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<AbsencesBloc, AbsencesState>(
          builder: (context, state) {
            if (state.status == AbsencesStatus.loading) {
              return const LoadingWidget();
            } else if (state.status == AbsencesStatus.failure) {
              return const Center(child: Text('Failed to load data.'));
            } else {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Total number of absences is ${state.totalAbsencesCount}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  FiltersWidget(),
                  Expanded(
                    child: state.absences.isNotEmpty
                        ? ListView.builder(
                            controller: _scrollController,
                            itemCount: state.absences.length,
                            itemBuilder: (context, index) => AbsenceCardWidget(
                              absence: state.absences[index],
                            ),
                          )
                        : const Center(child: Text('No absences found.')),
                  ),
                  if (state.hasReachedMax) const LoadingWidget(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
