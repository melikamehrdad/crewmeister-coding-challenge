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
    _loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: _scrollToTop,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Absences Manager'),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.bar_chart),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return InformationDialog();
            },
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => BlocProvider.of<AbsencesBloc>(context)
              .add(AbsencesExportDataFileCreated()),
        ),
      ],
    );
  }
}
