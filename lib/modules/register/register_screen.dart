import 'package:chat/layout/login.dart';
import 'package:chat/modules/register/cubit/cubit.dart';
import 'package:chat/modules/register/cubit/states.dart';
import 'package:chat/modules/register/pick-user-image.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var usernameController = TextEditingController();
    var passwordController = TextEditingController();
    late RegisterCubit cubit;

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
          cubit = RegisterCubit.get(context);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SIGN IN',
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(fontSize: 30),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text('Sign in now to get chatting with your friends.',
                          style: Theme.of(context).textTheme.headline6!),
                      Divider(
                        height: 50,
                        thickness: 1,
                      ),
                      defaultFormField(
                        context: context,
                        label: 'Username',
                        type: TextInputType.text,
                        controller: usernameController,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Username mustn\'t be empty';
                        },
                        prefix: Icons.person,
                        onSubmit: () {
                          cubit.changeEmailFocus();
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      defaultFormField(
                        context: context,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) return 'Email mustn\'t be empty';
                        },
                        prefix: Icons.email_outlined,
                        focusNode: cubit.emailFocus,
                        onSubmit: () {
                          cubit.changePasswordFocus();
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
                            color: MediaQuery.of(context).platformBrightness ==
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
                          if (formKey.currentState!.validate()) {}
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      defaultButton(
                        text: 'next',
                        width: double.infinity,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            navigate(
                              context,
                              PickUserImage(
                                usernameController.text,
                                emailController.text,
                                passwordController.text,
                              ),
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
                              'I have an account.',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                navigateAndFinish(context, Login());
                              },
                              child: Text(
                                'Login',
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
    );
  }
}
