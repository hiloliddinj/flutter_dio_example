import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dio_example/http_service.dart';
import 'package:flutter_dio_example/model/SingleUserResponse/single_user_response.dart';
import 'package:flutter_dio_example/screens/list_user_screen.dart';

import '../model/User/user.dart';

class SingleUserScreen extends StatefulWidget {
  const SingleUserScreen({Key? key}) : super(key: key);

  @override
  State<SingleUserScreen> createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends State<SingleUserScreen> {
  late HttpService http;
  SingleUserResponse? singleUserResponse;
  User? user;

  bool isLoading = false;

  Future getUser() async {
    Response response;
    try {
      isLoading = true;
      response = await http.getRequest("/api/users/2");

      isLoading = false;

      if (response.statusCode == 200) {
        setState(() {
          singleUserResponse = SingleUserResponse.fromJson(response.data);
          user = singleUserResponse!.user;
        });
      } else {
        print("PROBLEM, Status code: ${response.statusCode}");
      }
    } on Exception catch (e) {
      isLoading = false;
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    http = HttpService();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Single User"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (user != null) ? _userData()
          : const Center(child: Text("User is empty")),
    );
  }

  Widget _userData() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(user?.avatar ?? ""),
          const SizedBox(height: 16),
          Text("Hello, ${user?.firstName} ${user?.lastName}"),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListUserScreen()),
                );
              },
              child: const Text("Go To List Screen"),
          ),
        ],
      ),
    );
  }
}
