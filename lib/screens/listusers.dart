import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/core/api_client.dart';
import 'package:my_app/screens/home.dart';
import 'package:my_app/screens/addusers.dart';

class Data {
  final int id;
  final String email;
  final int name;
  final String inputter;
  final String created_at;
  final String updated_at;

  Data(
      {required this.id,
      required this.email,
      required this.name,
      required this.inputter,
      required this.created_at,
      required this.updated_at});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      inputter: json['inputter'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}

class ViewListScreen extends StatelessWidget {
  final List<String> items;

  const ViewListScreen({super.key, required this.items});

  Future<void> getUsers() async {
    var res = await ApiClient.getUsers();

    var decodedResponse = jsonDecode(res);

    @override
    Widget build(BuildContext context) {
      return FutureBuilder<List<Data>>(builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 75,
                  color: Colors.white,
                  child: Center(
                    child: Text(snapshot.data![index].name as String),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
