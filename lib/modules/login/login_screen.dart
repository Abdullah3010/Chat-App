import 'package:chat/layout/register.dart';
import 'package:chat/modules/chat/chat_screen.dart';
import 'package:chat/modules/login/cubit/cubit.dart';
import 'package:chat/modules/login/cubit/states.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    late LoginCubit cubit;
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginSuccessesState) {
              navigateAndFinish(context, ChatScreen());
            }
            if (state is LoginErrorState) {
              showMyDialog(
                context: context,
                title: 'Sorry',
                content: cubit.errorMessage[cubit.errorMessageIndex],
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      defaultButton(
                        text: 'Ok',
                        background: Colors.red,
                        textColor: Colors.white,
                        width: 80,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      if (cubit.errorMessageIndex == 2)
                        defaultButton(
                          text: 'Register',
                          width: 130,
                          onPressed: () {
                            Navigator.pop(context);
                            navigate(context, Register());
                          },
                        ),
                    ],
                  ),
                ],
              );
            }
          },
          builder: (context, state) {
            cubit = LoginCubit.get(context);
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 30),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Start your chats with your friends.',
                          style: Theme.of(context).textTheme.headline6!,
                        ),
                        Divider(
                          height: 50,
                          thickness: 1,
                        ),
                        defaultFormField(
                          context: context,
                          label: 'Email',
                          type: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Email mustn\'t be empty';
                          },
                          prefix: Icons.email_outlined,
                          onSubmit: () {
                            cubit.changeFocus();
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        defaultFormField(
                          context: context,
                          label: 'Password',
                          isPassword: cubit.isPassword,
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Password mustn\'t be empty';
                          },
                          prefix: Icons.password_outlined,
                          suffix: IconButton(
                            splashRadius: 20,
                            icon: Icon(
                              cubit.isPassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.lock,
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? Color.fromRGBO(226, 226, 226, 1.0)
                                      : Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              cubit.changePasswordState();
                            },
                          ),
                          focusNode: cubit.passwordFocus,
                          onSubmit: () {
                            if (formKey.currentState!.validate()) {
                              cubit.login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        if (state is LoginLoadingState)
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        if (state is! LoginLoadingState)
                          defaultButton(
                            text: 'login',
                            width: double.infinity,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'I don\'t have an account.',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  navigateAndFinish(context, Register());
                                },
                                child: Text(
                                  'Register',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: Colors.blue,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
