import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Dependency/GetX/Controller/getx_controller.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/AuthenticationScreen/bloc/authentication_bloc.dart';
import 'package:flutter_chatx/View/Theme/icons.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/AuthFunctions/auth_functions.dart';
import 'package:get/get.dart';

// Agreee checkBox
bool? _agreeBox = false;
// Password visibility
bool _passwordVisibility = true;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  // instance from authenticationbloc for call events
  AuthenticationBloc? _authenticationBloc;
  // instance from global keys to use in form
  final GlobalKey<FormState> nameKey = GlobalKey();
  final GlobalKey<FormState> emailKey = GlobalKey();
  final GlobalKey<FormState> passwordKey = GlobalKey();
  // instance from texteditengcontrollers to use in textfileds
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Instance of Dependency Controller for use app functions
  final DependencyController dpController = Get.find();
  // Instance of Auth Functions
  late final AuthFunctions authFunctions =
      dpController.appFunctions.authFunctions;

  @override
  void dispose() {
    _authenticationBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        title: Text(
          appName,
          style:
              textTheme.headlineMedium!.copyWith(color: colorScheme.background),
        ),
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = AuthenticationBloc();
          bloc.add(AuthenticationStart());
          _authenticationBloc = bloc;
          return bloc;
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationLoadingScreen) {
              return const CustomLoadingScreen();
            } else if (state is AuthenticationSignupScreen) {
              return AuthenticationTemplate(
                  loginMode: false,
                  topTitle: createAcount,
                  topDescription1: haveAcount,
                  topDescription2: login,
                  authButtonTitle: createAcount,
                  authButtonTap: () {
                    final UserEntity? userEntity =
                        authFunctions.buildUserEntity(
                            emailKey: emailKey,
                            passwordKey: passwordKey,
                            nameKey: nameKey,
                            emailController: emailController,
                            passwordController: passwordController,
                            nameController: nameController);
                    if (userEntity != null) {
                      _authenticationBloc!.add(AuthenticationSignup(
                          userEntity: userEntity, isPrivacyAgreed: _agreeBox!));
                    }
                  },
                  googleButtonTap: () => _authenticationBloc!
                      .add(AuthenticationContinueWithGoogle()),
                  topDescription2ButtonTap: () =>
                      _authenticationBloc!.add(AuthenticationGoLogin()),
                  nameKey: nameKey,
                  nameController: nameController,
                  emailKey: emailKey,
                  emailController: emailController,
                  passwordKey: passwordKey,
                  passwordController: passwordController);
            } else if (state is AuthenticationLoginScreen) {
              return AuthenticationTemplate(
                  loginMode: true,
                  topTitle: welcomeBack,
                  topDescription1: dontHaveAccount,
                  topDescription2: signUp,
                  authButtonTitle: login,
                  authButtonTap: () {
                    final UserEntity? userEntity =
                        authFunctions.buildUserEntity(
                            emailKey: emailKey,
                            passwordKey: passwordKey,
                            emailController: emailController,
                            passwordController: passwordController);
                    if (userEntity != null) {
                      _authenticationBloc!.add(AuthenticationLogin(userEntity));
                    }
                  },
                  googleButtonTap: () => _authenticationBloc!
                      .add(AuthenticationContinueWithGoogle()),
                  topDescription2ButtonTap: () =>
                      _authenticationBloc!.add(AuthenticationGoSignUp()),
                  emailKey: emailKey,
                  emailController: emailController,
                  passwordKey: passwordKey,
                  passwordController: passwordController);
            } else if (state is AuthenticationErrorScreen) {
              return CustomErrorScreen(
                  callBack: () =>
                      _authenticationBloc!.add(AuthenticationStart()),
                  errorMessage: state.errorMessage);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class AuthenticationTemplate extends StatelessWidget {
  final bool loginMode;
  final String topTitle;
  final String topDescription1;
  final String topDescription2;
  final String authButtonTitle;
  final void Function() authButtonTap;
  final void Function() googleButtonTap;
  final void Function()? topDescription2ButtonTap;
  final GlobalKey<FormState>? nameKey;
  final TextEditingController? nameController;
  final GlobalKey<FormState> emailKey;
  final TextEditingController emailController;
  final GlobalKey<FormState> passwordKey;
  final TextEditingController passwordController;

  const AuthenticationTemplate(
      {super.key,
      required this.loginMode,
      required this.topTitle,
      required this.topDescription1,
      required this.topDescription2,
      required this.authButtonTitle,
      required this.authButtonTap,
      required this.googleButtonTap,
      this.nameKey,
      this.nameController,
      required this.emailKey,
      required this.emailController,
      required this.passwordKey,
      required this.passwordController,
      this.topDescription2ButtonTap});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
      child: CustomScrollView(
        physics: defaultPhysics,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sign top part
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topTitle,
                        style: textTheme.headlineMedium!.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Text(topDescription1, style: textTheme.bodyMedium),
                          TextButton(
                            onPressed: topDescription2ButtonTap,
                            child: Text(
                              topDescription2,
                              style: textTheme.bodyMedium!
                                  .copyWith(color: colorScheme.scrim),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                // Text fields and agree parts

                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Column(
                    children: [
                      // Name text field if is signup mode
                      loginMode
                          ? Container()
                          : CustomTextFiled(
                              formKey: nameKey!,
                              controller: nameController!,
                              labelText: fullName,
                            ),
                      // Email text field
                      CustomTextFiled(
                        formKey: emailKey,
                        controller: emailController,
                        labelText: email,
                      ),
                      // Password text field
                      CustomTextFiled(
                        isPasswordFill: true,
                        formKey: passwordKey,
                        controller: passwordController,
                        labelText: password,
                      ),
                      // Agree part if is signup mode
                      loginMode ? Container() : const AgreeWidget()
                    ],
                  ),
                ),

                // bottom part

                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      // Create button part

                      CustomButton(
                        backgroundColor: colorScheme.primary,
                        title: authButtonTitle,
                        titleStyle: textTheme.headlineSmall!.copyWith(
                          color: colorScheme.background,
                        ),
                        onPressed: authButtonTap,
                      ),

                      // Or part

                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              color: colorScheme.primaryContainer,
                              height: 3,
                            ),
                            Positioned(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: colorScheme.background,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  or,
                                  style: textTheme.bodyMedium!.copyWith(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // continue with Googel part

                      CustomButton(
                        backgroundColor: colorScheme.background,
                        title: withGoogle,
                        titleStyle: textTheme.bodyMedium,
                        suffixIcon: const Icon(googelIcon),
                        onPressed: googleButtonTap,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AgreeWidget extends StatefulWidget {
  const AgreeWidget({super.key});

  @override
  State<AgreeWidget> createState() => _AgreeWidgetState();
}

class _AgreeWidgetState extends State<AgreeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Checkbox(
          value: _agreeBox,
          onChanged: (value) {
            setState(() {
              _agreeBox = value;
            });
          },
        ),
        const Expanded(
          child: Text(
            agree,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}

class CustomTextFiled extends StatefulWidget {
  const CustomTextFiled({
    super.key,
    required this.formKey,
    required this.controller,
    required this.labelText,
    this.isPasswordFill = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String labelText;
  final bool isPasswordFill;

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  // Instance of Dependency Controller for use app functions
  final DependencyController dpController = Get.find();
  // Instance of Auth Functions
  late final AuthFunctions authFunctions =
      dpController.appFunctions.authFunctions;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          validator: authFunctions.validator,
          obscureText: widget.isPasswordFill ? _passwordVisibility : false,
          controller: widget.controller,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              labelText: widget.labelText,
              suffixIcon: widget.isPasswordFill
                  ? IconButton(
                      onPressed: () => setState(() {
                        _passwordVisibility = !_passwordVisibility;
                      }),
                      icon: Icon(
                          _passwordVisibility ? inVisibileIcon : visibileIcon),
                    )
                  : null),
        ),
      ),
    );
  }
}
