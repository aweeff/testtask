import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testtask/services/auth/AuthService.dart';
import '../components/buttons.dart';
import '../components/textFields.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget{
  final void Function()? ontap;
  const LoginPage({super.key, this.ontap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async{
    final authService = Provider.of<AuthService>(context, listen: false);
    try{
      await authService.signInWithEmailandPassword(
          emailController.text, passwordController.text,
      );
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
            child: Column(
              children: [
                const Icon(Icons.message_rounded, size: 80, ),

                const Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35,),

                TextFields(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10,),

                TextFields(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 20,),
                
                Buttons(onTap: signIn, text: "Sign In"),

                const SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Do not have an account?'),
                    const SizedBox(width: 4,),

                    GestureDetector(
                      onTap: widget.ontap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
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