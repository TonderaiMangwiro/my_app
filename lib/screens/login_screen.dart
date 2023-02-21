import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/core/api_client.dart';
import 'package:my_app/screens/home.dart';
import 'package:my_app/screens/register.dart';
import 'package:my_app/screens/addusers.dart';
import 'package:my_app/utils/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.orangeAccent,
      ));

      var res = await ApiClient.login(
        emailController.text,
        passwordController.text,
      );

      var decodedResponse = jsonDecode(res);

      if (decodedResponse['status']) {
        String accessToken = decodedResponse['token'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${decodedResponse['message']}'),
          backgroundColor: Colors.green.shade300,
        ));
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddUserScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${decodedResponse['message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.blueGrey[200],
        body: Form(
          key: _formKey,
          child: Stack(children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.85,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(height: size.height * 0.08),

                          const Center(
                            child: Text(
                              "BronzedBlue",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.06),
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              return Validator.validateEmail(value ?? "");
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          TextFormField(
                            obscureText: _showPassword,
                            controller: passwordController,
                            validator: (value) {
                              return Validator.validatePassword(value ?? "");
                            },
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(
                                      () => _showPassword = !_showPassword);
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Password",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen())),
                                child: const Text('Register')),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
