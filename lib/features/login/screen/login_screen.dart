import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/login/bloc/login_bloc.dart';
import 'package:smart_grocery/features/login/bloc/login_event.dart';
import 'package:smart_grocery/features/login/bloc/login_state.dart';
import 'package:smart_grocery/features/product/screen/product_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool showAndHide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (BuildContext context, state) {
          if (state is LoginFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                duration: Duration(seconds: 2),
              ),
            );
          }
          if (state is LoginSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProductScreen()),
              (route) => false,
            );
          }
          if (state is GoogleLoginSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProductScreen()),
              (route) => false,
            );
          }
          if (state is GoogleLoginFailedState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 63, left: 32),
                      child: Text(
                        'Welcome\nBack!',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.grey[300],
                      hint: Text('Email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 29, right: 29),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: showAndHide,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.grey[300],
                      hint: Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showAndHide = !showAndHide;
                          });
                        },
                        icon: Icon(
                          showAndHide ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Forgot Password?'),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (BuildContext context, state) {
                    if (state is LoginLoadingState) {
                      return CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                          LoginSuccessEvent(
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        );
                      },
                      child: Text("Login"),
                    );
                  },
                ),
                SizedBox(height: 80),
                Text('- Or Continue with -'),
                SizedBox(height: 20),
                Row(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<LoginBloc>().add(GoogleLoginEvent());
                      },
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return CircleAvatar(
                            child: Image.asset('assets/Google.png'),
                          );
                        },
                      ),
                    ),
                    CircleAvatar(child: Image.asset('assets/Apple.png')),
                    CircleAvatar(child: Image.asset('assets/Facebook (1).png')),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Create An Account'),
                    TextButton(onPressed: () {}, child: Text('Sign Up')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
