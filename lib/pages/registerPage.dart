import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/buttons.dart';
import '../components/textFields.dart';
import '../services/auth/AuthService.dart';

class RegisterPage extends StatefulWidget{
  final void Function()? ontap;
  const RegisterPage({super.key, this.ontap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  void signUp() async{
    if (passwordController.text != passwordConfirmController.text){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Passwords don't match")
          )
      );
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);
    try{
      await authService.signUpWithEmailandPassword(
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
                  "Let's create an account!",
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

                const SizedBox(height: 10,),

                TextFields(
                  controller: passwordConfirmController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 20,),

                Buttons(onTap: signUp, text: "Sign Up"),

                const SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.ontap,
                      child: const Text(
                        'Login now',
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