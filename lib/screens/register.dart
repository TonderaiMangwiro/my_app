import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/core/api_client.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/utils/validator.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "register_screen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  // final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = false;

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Request sent. please wait'),
        backgroundColor: Colors.orangeAccent,
      ));

      Map<String, dynamic> userData = {
        "username": usernameController.text,
        //  "name": nameController.text,
        "password": passwordController.text,
        "email": emailController.text,
        "mobileNumber": phoneNumberController.text,
      };

      var res = await ApiClient.register(userData);
      var decodedResponse = jsonDecode(res);

      if (decodedResponse['status']
          .toString()
          // .toLowerCase()
          .contains("true")) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Success: ${decodedResponse['message']}. Login to continue.'),
          backgroundColor: Colors.greenAccent,
        ));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else if (!decodedResponse['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Failed to process request: ${decodedResponse['message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Self Registration Successful you can now login'),
          backgroundColor: Color.fromARGB(255, 138, 229, 115),
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
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //   SizedBox(height: size.height * 0.08),
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
                        "Register",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),

                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      validator: (value) =>
                          Validator.validateEmail(value ?? ""),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
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
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    //SizedBox(height: size.height * 0.03),
                    // TextFormField(
                    //  controller: nameController,
                    //   keyboardType: TextInputType.text,
                    //  decoration: InputDecoration(
                    //    hintText: "Full Name",
                    //   isDense: true,
                    //    border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //  ),
                    //  ),

                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Username",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.06),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15)),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen())),
                          child: const Text('Login')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
