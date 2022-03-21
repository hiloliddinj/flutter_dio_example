import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dio_example/model/ListUserResponse/list_user_response.dart';
import 'package:flutter_dio_example/model/User/user.dart';

import '../http_service.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({Key? key}) : super(key: key);

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  late HttpService http;

  ListUserResponse? listUserResponse;

  List<User>? usersList;

  bool isLoading = false;

  Future _getListUser() async {
    Response response;
    try {
      isLoading = true;
      response = await http.getRequest("/api/users?page=2");

      isLoading = false;

      if (response.statusCode == 200) {
        setState(() {
          listUserResponse = ListUserResponse.fromJson(response.data);
          usersList = listUserResponse!.usersList;
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
    _getListUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List User Screen"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (usersList != null)
              ? ListView.builder(
                  itemCount: usersList!.length,
                  itemBuilder: (context, index) {
                    final User user = usersList![index];
                    return ListTile(
                      leading: Image.network(user.avatar!),
                      title: Text("${user.firstName}, ${user.lastName}"),
                      subtitle: Text(user.email!),
                    );
                  },
                )
              : const Text("No Users fetched!"),
    );
  }
}
