import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/View/Screens/AuthenticationScreen/authentication_screen.dart';
import 'package:flutter_chatx/View/Screens/RootScreen/bloc/root_bloc.dart';

import 'package:flutter_chatx/View/Screens/SplashScreen/splash_screen.dart';

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
          if (state is RootShowSplash) {
            return const SplashScreen();
          } else if (state is RootShowAuthentication) {
            return const AuthenticationScreen();
          }
          return Container();
        },
      ),
    );
  }
}
