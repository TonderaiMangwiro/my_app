import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/core/api_client.dart';
import 'package:my_app/screens/listusers.dart';
import 'package:my_app/utils/validator.dart';

// ignore: camel_case_types
class AddUserScreen extends StatefulWidget {
  static String id = "add_screen";
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final ApiClient _apiClient = ApiClient();
  bool _showPassword = false;

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Request sent. please wait'),
        backgroundColor: Colors.orangeAccent,
      ));

      Map<String, dynamic> userData = {
        "token": tokenController.text,
        "name": nameController.text,
        "email": emailController.text,
      };

      var res = await ApiClient.registerUser(userData);
      var decodedResponse = jsonDecode(res);

      if (decodedResponse['message']
          .toString()
          // .toLowerCase()
          .contains("User Added")) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Success: ${decodedResponse['message']}. User Added'),
          backgroundColor: Colors.greenAccent,
        ));
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ViewListScreen(
                      items: [],
                    )));
      } else if (!decodedResponse['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Failed to process request: ${decodedResponse['message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to process request contact admin'),
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
                        "Add User",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      controller: tokenController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "token",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

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
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Name",
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
                        onPressed: registerUser,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15)),
                        child: const Text(
                          "Add User",
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
                                  builder: (context) => const ViewListScreen(
                                        items: [],
                                      ))),
                          child: const Text('View added users')),
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
