import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/View/Screens/HomeScreen/home_screen.dart';
import 'package:flutter_chatx/View/Screens/RootScreen/bloc/root_bloc.dart';

import 'package:flutter_chatx/View/Screens/IntroScreen/intro_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = RootBloc();
        bloc.add(RootStart());
        return bloc;
      },
      child: BlocBuilder<RootBloc, RootState>(
        builder: (context, state) {
          if (state is RootShowIntro) {
            return const IntroScreen();
          } else if (state is RootShowHomeScreen) {
            return const HomeScreen();
          }
          return Container();
        },
      ),
    );
  }
}
