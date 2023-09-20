import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/NavigationSystem/SettingsNavigation/navigation.dart';
import 'package:get/get.dart';

// Duplicate padding vlaue
const double _paddingValue = 12;

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.currentUser});
  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: settingsAppBar(
        colorScheme: colorScheme,
        textTheme: textTheme,
        title: settingsDialog,
      ),
      body: SettingsDuplicateFrame(
        children: [
          _ProfilePart(currentUser: currentUser),
          // Support action
          _SettingsAction(
            iconData: supportIcon,
            title: supportDialog,
            onTap: () {
              //  TODO implement settings action here
            },
          ),
          // Share action
          _SettingsAction(
            iconData: shareIcon,
            title: shareDialog,
            onTap: () {
              //  TODO implement settings action here
            },
          ),
          // Clean cache action
          _SettingsAction(
            iconData: cleanupIcon,
            title: clearCacheDialog,
            onTap: () {
              //  TODO implement settings action here
            },
          ),
          // Logout action
          _SettingsAction(
            iconData: logoutIcon,
            title: logoutDialog,
            leadingColor: colorScheme.tertiaryContainer,
            onTap: () {
              //  TODO implement settings action here
            },
          ),
        ],
      ),
    );
  }
}

class _ProfilePart extends StatelessWidget {
  const _ProfilePart({required this.currentUser});

  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileAvatar(
              profileImageUrl: currentUser.profileImageUrl,
            ),
            _ProfileDetail(currentUser: currentUser),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  _ProfileDetail({required this.currentUser});
  final AppUser currentUser;

  final SettingsNavigation settingsNavigation =
      Get.find<DependencyController>().navigationSystem.settingsNavigation;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (currentUser.fullName != null) {
      return _columnFrame(
        children: [
          _buildLargeText(textTheme: textTheme, content: currentUser.fullName!),
          _buildSmallText(textTheme: textTheme, content: currentUser.email),
          _profileEditButton(colorScheme: colorScheme, textTheme: textTheme),
        ],
      );
    } else {
      return _columnFrame(
        children: [
          _buildLargeText(textTheme: textTheme, content: currentUser.email),
          _profileEditButton(colorScheme: colorScheme, textTheme: textTheme),
        ],
      );
    }
  }

  Column _columnFrame({required List<Widget> children}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Text _buildLargeText(
      {required TextTheme textTheme, required String content}) {
    return Text(
      content,
      style: textTheme.bodyLarge
          ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.clip),
    );
  }

  Text _buildSmallText(
      {required TextTheme textTheme, required String content}) {
    return Text(
      content,
      style: textTheme.bodySmall?.copyWith(overflow: TextOverflow.clip),
    );
  }

  Widget _profileEditButton(
      {required ColorScheme colorScheme, required TextTheme textTheme}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () =>
            settingsNavigation.goToEditScreen(currentUser: currentUser),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.secondary),
          ),
        ),
        child: Text(
          editProfileDialog,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _SettingsAction extends StatelessWidget {
  const _SettingsAction({
    required this.iconData,
    required this.title,
    required this.onTap,
    this.leadingColor,
  });
  final IconData iconData;
  final String title;
  final void Function()? onTap;
  final Color? leadingColor;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Flexible(
      child: Padding(
        padding:
            const EdgeInsets.only(left: _paddingValue, right: _paddingValue),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: leadingColor ?? colorScheme.primary,
                child: Icon(
                  iconData,
                  color: colorScheme.background,
                ),
              ),
              title: Text(
                title,
                style:
                    textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              onTap: onTap,
            ),
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              height: 1.5,
              color: colorScheme.secondaryContainer,
            )
          ],
        ),
      ),
    );
  }
}
