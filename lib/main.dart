import 'package:code_challenge/bloc/absences_bloc.dart';
import 'package:code_challenge/data/absences_local_data_source.dart';
import 'package:code_challenge/data/absences_remote_data_source.dart';
import 'package:code_challenge/data/absences_repository_impl.dart';
import 'package:code_challenge/utils.dart/app_colors.dart';
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
      localDataSource: AbsencesLocalDataSource(),
    );

    return BlocProvider<AbsencesBloc>(
      create: (context) => AbsencesBloc(absencesRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Absences Manager',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          scaffoldBackgroundColor: AppColors.secondaryColor2,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            iconTheme: IconThemeData(color: AppColors.secondaryColor2),
            titleTextStyle: TextStyle(
              color: AppColors.secondaryColor2,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: AppColors.primaryColor,
            textTheme: ButtonTextTheme.primary,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.secondaryColor2,
            foregroundColor: AppColors.accentColor1,
          ),
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryColor,
            secondary: AppColors.accentColor1,
            surface: AppColors.secondaryColor2,
            onPrimary: AppColors.secondaryColor2,
            onSurface: AppColors.secondaryColor1,
          ),
          useMaterial3: true,
        ),
        home: const AbsencesPage(),
      ),
    );
  }
}
