import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/data/absences_remote_data_source.dart';
import 'package:code_challenge/data/absences_repository_impl.dart';
import 'package:code_challenge/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final absencesRepository = AbsencesRepositoryImpl(
    remoteDataSource: AbsencesRemoteDataSource(),
  );

    return BlocProvider<AbsencesBloc>(
      create: (context) => AbsencesBloc(absencesRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Absences Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AbsencesPage(),
      ),
    );
  }
}
