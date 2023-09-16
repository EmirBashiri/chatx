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

// Home duplicate widget key
const Key _homeDuplicateFrameKey = Key("Home");

final DependencyController _dependencyController = Get.find();
final HomeNavigation _homeNavigation =
    _dependencyController.navigationSystem.homeNavigation;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
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
            return _HomeLoadingWidget();
          } else if (state is HomeErrorScreen) {
            return _HomeErrorWidget(
              errorMessage: state.errorMessage,
              currentUser: state.currentUser,
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// Home screens duplicate frame
class HomeDuplicateFrame extends StatelessWidget {
  const HomeDuplicateFrame({super.key, required this.body, this.homeFAB});
  final Widget body;
  final Widget? homeFAB;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      floatingActionButton: homeFAB,
      appBar: AppBar(
        title: Text(
          messages,
          style: textTheme.headlineSmall!.copyWith(
              color: colorScheme.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: body,
    );
  }
}

// Home screens floating action button
class _HomeFAB extends StatelessWidget {
  const _HomeFAB({required this.currentUser});

  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton.extended(
      shape: const CircleBorder(),
      backgroundColor: colorScheme.primary,
      onPressed: () =>
          _homeNavigation.goToSettingScreen(currentUser: currentUser),
      label: Icon(settingIcon, color: colorScheme.background),
    );
  }
}

// Home screens main widget
class _HomeMainWidget extends StatelessWidget {
  const _HomeMainWidget({required this.userList, required this.currentUser});
  final List<AppUser> userList;
  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return HomeDuplicateFrame(
      key: _homeDuplicateFrameKey,
      homeFAB: _HomeFAB(currentUser: currentUser),
      body: ListView.builder(
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
      ),
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

// Home screens loading widget
class _HomeLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const HomeDuplicateFrame(
      key: _homeDuplicateFrameKey,
      body: CustomLoadingScreen(),
    );
  }
}

// Home screens error widget
class _HomeErrorWidget extends StatelessWidget {
  const _HomeErrorWidget(
      {required this.errorMessage, required this.currentUser});

  final String errorMessage;
  final AppUser? currentUser;

  @override
  Widget build(BuildContext context) {
    return HomeDuplicateFrame(
      key: _homeDuplicateFrameKey,
      homeFAB: currentUser != null ? _HomeFAB(currentUser: currentUser!) : null,
      body: CustomErrorScreen(
        callBack: () => context.read<HomeBloc>().add(HomeStart()),
        errorMessage: errorMessage,
      ),
    );
  }
}
