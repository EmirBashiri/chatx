import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/HomeScreen/bloc/home_bloc.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          shape: const CircleBorder(),
          backgroundColor: colorScheme.primary,
          onPressed: () {
            // TODO implement navigate to setting screen
          },
          label: Icon(settingIcon, color: colorScheme.background)),
      appBar: AppBar(
        title: Text(
          messages,
          style: textTheme.headlineSmall!.copyWith(
              color: colorScheme.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = HomeBloc();
          bloc.add(HomeStart());
          return bloc;
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeMainScreen) {
              return _HomeMainWidget(userList: state.userList);
            } else if (state is HomeLoadingScreen) {
              return const CustomLoadingScreen();
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class _HomeMainWidget extends StatelessWidget {
  const _HomeMainWidget({super.key, required this.userList});
  final List<AppUser> userList;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        final AppUser user = userList[index];
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  // TODO implement navigate to chat screen here
                },
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.profileUrl),
                ),
                title: Text(user.fullName ?? user.email),
              ),
              Container(
                height: 1.5,
                width: Get.width,
                margin: const EdgeInsets.only(top: 5),
                color: colorScheme.secondary.withOpacity(0.4),
              ),
            ],
          ),
        );
      },
    );
  }
}
