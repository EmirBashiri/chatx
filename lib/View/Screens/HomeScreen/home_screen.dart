import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/HomeScreen/bloc/home_bloc.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/HomeNavigation/navigation.dart';
import 'package:get/get.dart';

final DependencyController _dependencyController = Get.find();
final HomeNavigation _homeNavigation =
    _dependencyController.navigationSystem.homeNavigation;

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
              return _HomeMainWidget(
                  userList: state.userList, currentUser: state.currnetUser);
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
  const _HomeMainWidget({required this.userList, required this.currentUser});
  final List<AppUser> userList;
  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        final AppUser user = userList[index];
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              user.email == currentUser.email
                  ? ListTile(
                      onTap: () => _homeNavigation.goToChatScreen(
                        senderUser: currentUser,
                        receiverUser: user,
                      ),
                      leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(tagIcon, color: colorScheme.primary)),
                      title: duplicateText(
                          textTheme: textTheme, text: savedMessages),
                    )
                  : ListTile(
                      onTap: () => _homeNavigation.goToChatScreen(
                        senderUser: currentUser,
                        receiverUser: user,
                      ),
                      leading: CircleAvatar(
                        backgroundImage:
                            networkImageProvider(imageUr: user.profileUrl),
                      ),
                      title: duplicateText(
                          textTheme: textTheme,
                          text: user.fullName ?? user.email),
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

// Build duplicate text field
  Text duplicateText({required TextTheme textTheme, required String text}) {
    return Text(
      text,
      style: textTheme.bodyMedium,
      overflow: TextOverflow.clip,
    );
  }
}
