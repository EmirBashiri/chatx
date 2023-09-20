import 'package:flutter/material.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/SettingsFunctions/settings_functions.dart';
import 'package:get/get.dart';

import '../../Theme/icons.dart';

// A boolean to controll password field
bool _obscurePassword = true;

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key, required this.currentUser});
  final AppUser currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> nameKey = GlobalKey();
  final GlobalKey<FormState> emailKey = GlobalKey();
  final GlobalKey<FormState> passwordKey = GlobalKey();

  final SettingsFunctions settingsFunctions =
      Get.find<DependencyController>().appFunctions.settingsFunctions;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: settingsAppBar(
        colorScheme: colorScheme,
        textTheme: textTheme,
        title: editProfileDialog,
      ),
      body: SettingsDuplicateFrame(
        children: [
          _AvatarPart(imageUrl: currentUser.profileImageUrl),
          // Full name edit field
          _EditFields(
            settingsFunctions: settingsFunctions,
            textController: nameController,
            formKey: nameKey,
            title: fullNameDialog,
            fieldHint: currentUser.fullName,
          ),
          // Email edit field
          _EditFields(
            settingsFunctions: settingsFunctions,
            textController: emailController,
            formKey: emailKey,
            title: emailDialog,
            fieldHint: currentUser.email,
          ),
          // Password edit field
          _EditFields(
            settingsFunctions: settingsFunctions,
            textController: passwordController,
            formKey: passwordKey,
            title: passwordDialog,
            fieldHint: currentUser.password,
            isPasswordField: true,
          ),
          // Save button
          _SaveButton(
            onPressed: () {
              // TODO Implement save changes here
            },
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed});
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Flexible(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: CustomButton(
          backgroundColor: colorScheme.primary,
          title: saveProfileDialog,
          titleStyle:
              textTheme.headlineSmall!.copyWith(color: colorScheme.background),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _AvatarPart extends StatelessWidget {
  const _AvatarPart({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: badges.Badge(
          onTap: () {
            // TODO implement update profile image here
          },
          position: badges.BadgePosition.bottomEnd(),
          badgeAnimation: const badges.BadgeAnimation.size(),
          badgeStyle:
              badges.BadgeStyle(badgeColor: colorScheme.primaryContainer),
          badgeContent: Icon(changeIcon, color: colorScheme.primary),
          child: ProfileAvatar(profileImageUrl: imageUrl),
        ),
      ),
    );
  }
}

class _EditFields extends StatelessWidget {
  const _EditFields({
    required this.settingsFunctions,
    required this.textController,
    required this.formKey,
    required this.title,
    required this.fieldHint,
    this.isPasswordField = false,
  });
  final SettingsFunctions settingsFunctions;
  final TextEditingController textController;
  final GlobalKey<FormState> formKey;
  final String title;
  final String? fieldHint;
  final bool isPasswordField;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.primary, width: 1.5),
              ),
              child: _CustomTextField(
                settingsFunctions: settingsFunctions,
                textController: textController,
                formKey: formKey,
                fieldHint: fieldHint,
                isPasswordField: isPasswordField,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Edit screens custom text filed
class _CustomTextField extends StatefulWidget {
  const _CustomTextField({
    required this.settingsFunctions,
    required this.textController,
    required this.fieldHint,
    required this.isPasswordField,
    required this.formKey,
  });
  final SettingsFunctions settingsFunctions;
  final TextEditingController textController;
  final GlobalKey<FormState> formKey;

  final String? fieldHint;
  final bool isPasswordField;

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        validator: widget.settingsFunctions.textFieldValidator,
        controller: widget.textController,
        obscureText: widget.isPasswordField ? _obscurePassword : false,
        decoration: InputDecoration(
          hintText: widget.settingsFunctions.fetchHintText(
            isPasswordField: widget.isPasswordField,
            hintText: widget.fieldHint,
          ),
          border: InputBorder.none,
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  onPressed: () => setState(() {
                    _obscurePassword = !_obscurePassword;
                  }),
                  icon: Icon(_obscurePassword ? inVisibileIcon : visibileIcon),
                )
              : null,
        ),
      ),
    );
  }
}
