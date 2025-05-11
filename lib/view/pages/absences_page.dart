import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/view/widgets/widgets.dart';
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
    return BlocBuilder<AbsencesBloc, AbsencesState>(
      builder: (context, state) {
        if (state.status == AbsencesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == AbsencesStatus.failure) {
          return const Center(child: Text('Failed to load data.'));
        } else if (state.status == AbsencesStatus.success) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Absences Manager'),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
            ),
            body: Column(
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
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.absences.length,
                    itemBuilder: (context, index) =>
                        AbsenceCardWidget(absence: state.absences[index]),
                  ),
                ),
                if (state.hasReachedMax)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
