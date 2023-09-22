import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_chatx/View/Screens/SettingsScreen/ProfileEdit/bloc/profile_edit_bloc.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/SettingsFunctions/settings_functions.dart';
import 'package:get/get.dart';

import '../../../Theme/icons.dart';

// A boolean to controll password field
bool _obscurePassword = true;

class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({super.key, required this.currentUser});
  final AppUser currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SettingsFunctions settingsFunctions =
      Get.find<DependencyController>().appFunctions.settingsFunctions;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: settingsFunctions.onWillPop,
      child: BlocProvider(
        create: (context) {
          final bloc = ProfileEditBloc(currentUser);
          bloc.add(ProfileEditStart());
          return bloc;
        },
        child: Scaffold(
          appBar: settingsAppBar(
            colorScheme: colorScheme,
            textTheme: textTheme,
            title: editProfileDialog,
            leading: IconButton(
              onPressed: () async => await settingsFunctions.closeEditProfile(),
              icon: const Icon(backIcon),
            ),
          ),
          body: BlocBuilder<ProfileEditBloc, ProfileEditState>(
            builder: (context, state) {
              if (state is ProfileEditLoadingState) {
                return const CustomLoadingScreen();
              } else if (state is ProfileEditMainState) {
                return _ProfileEditMainState(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  currentUser: currentUser,
                  settingsFunctions: settingsFunctions,
                  nameController: nameController,
                  emailController: emailController,
                  passwordController: passwordController,
                );
              } else if (state is ProfileEditNewAvatarState) {
                return _ProfileEditNewAvatarState(
                  avatarFilePath: state.imageFilePath,
                  settingsFunctions: settingsFunctions,
                  nameController: nameController,
                  currentUser: currentUser,
                  emailController: emailController,
                  passwordController: passwordController,
                );
              } else if (state is ProfileEditErrorState) {
                return CustomErrorScreen(
                  callBack: () =>
                      context.read<ProfileEditBloc>().add(ProfileEditStart()),
                  errorMessage: state.errorMessage,
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileEditNewAvatarState extends StatelessWidget {
  const _ProfileEditNewAvatarState({
    required this.settingsFunctions,
    required this.nameController,
    required this.currentUser,
    required this.emailController,
    required this.passwordController,
    required this.avatarFilePath,
  });
  final String avatarFilePath;
  final SettingsFunctions settingsFunctions;
  final TextEditingController nameController;
  final AppUser currentUser;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return _ProfileEditTemplateWidget(
      image: fileImageProvider(imageFilePath: avatarFilePath),
      onSaveTapped: () => context.read<ProfileEditBloc>().add(
            ProfileEditSaveWithAvatar(
              newAvatarPath: avatarFilePath,
              userEntity: UserEntity(
                fullName: nameController.text,
                email: emailController.text,
                password: passwordController.text,
              ),
            ),
          ),
      settingsFunctions: settingsFunctions,
      nameController: nameController,
      currentUser: currentUser,
      emailController: emailController,
      passwordController: passwordController,
    );
  }
}

class _ProfileEditMainState extends StatelessWidget {
  const _ProfileEditMainState({
    required this.colorScheme,
    required this.textTheme,
    required this.currentUser,
    required this.settingsFunctions,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final AppUser currentUser;
  final SettingsFunctions settingsFunctions;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return _ProfileEditTemplateWidget(
      image: networkImageProvider(imageUr: currentUser.profileImageUrl),
      onSaveTapped: () => context.read<ProfileEditBloc>().add(
            ProfileEditSaveWithoutAvatar(
              userEntity: UserEntity(
                fullName: nameController.text,
                email: emailController.text,
                password: passwordController.text,
              ),
            ),
          ),
      settingsFunctions: settingsFunctions,
      nameController: nameController,
      currentUser: currentUser,
      emailController: emailController,
      passwordController: passwordController,
    );
  }
}

class _ProfileEditTemplateWidget extends StatelessWidget {
  const _ProfileEditTemplateWidget({
    required this.image,
    required this.onSaveTapped,
    required this.settingsFunctions,
    required this.nameController,
    required this.currentUser,
    required this.emailController,
    required this.passwordController,
  });
  final ImageProvider<Object> image;
  final void Function() onSaveTapped;
  final SettingsFunctions settingsFunctions;
  final TextEditingController nameController;
  final AppUser currentUser;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return SettingsDuplicateFrame(
      children: [
        _ProfileAvatar(image: image),
        // Full name edit field
        _EditFields(
          settingsFunctions: settingsFunctions,
          textController: nameController,
          title: fullNameDialog,
          fieldHint: currentUser.fullName,
        ),
        // Email edit field
        _EditFields(
          settingsFunctions: settingsFunctions,
          textController: emailController,
          title: emailDialog,
          fieldHint: currentUser.email,
        ),
        // Password edit field
        _EditFields(
          settingsFunctions: settingsFunctions,
          textController: passwordController,
          title: passwordDialog,
          fieldHint: currentUser.password,
          isPasswordField: true,
        ),
        // Save button
        _SaveButton(onPressed: onSaveTapped),
      ],
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.image});
  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: badges.Badge(
          onTap: () =>
              context.read<ProfileEditBloc>().add(ProfileEditSetAvatar()),
          position: badges.BadgePosition.bottomEnd(),
          badgeAnimation: const badges.BadgeAnimation.size(),
          badgeStyle:
              badges.BadgeStyle(badgeColor: colorScheme.primaryContainer),
          badgeContent: Icon(changeIcon, color: colorScheme.primary),
          child: ProfileAvatar(image: image),
        ),
      ),
    );
  }
}

class _EditFields extends StatelessWidget {
  const _EditFields({
    required this.settingsFunctions,
    required this.textController,
    required this.title,
    required this.fieldHint,
    this.isPasswordField = false,
  });
  final SettingsFunctions settingsFunctions;
  final TextEditingController textController;
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

// Profile Edit screens custom text filed
class _CustomTextField extends StatefulWidget {
  const _CustomTextField({
    required this.settingsFunctions,
    required this.textController,
    required this.fieldHint,
    required this.isPasswordField,
  });
  final SettingsFunctions settingsFunctions;
  final TextEditingController textController;
  final String? fieldHint;
  final bool isPasswordField;

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }
}
