import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListViewApi extends StatefulWidget {
  @override
  _ListViewApiState createState() => _ListViewApiState();
}

class _ListViewApiState extends State<ListViewApi> {
  final String uri = 'http://jsonplaceholder.typicode.com/users';

  Future<List<Users>> _fetchUsers() async{
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Users> listOfUsers = items.map<Users>((json){
        return Users.fromJson(json);
      }).toList();

      return listOfUsers;
    }else {
      throw Exception('Connection error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetching data from JSON - ListView'),
      ),
      body: FutureBuilder<List<Users>>(
        future: _fetchUsers(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data.map((user) => ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              leading: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(user.name[0],
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                )),
              ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}


class Users{
  int id;
  String name;
  String email;
  String phone;
  String website;
  String address;
  String company;

  Users({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.company,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: json['address'],
      company: json['company'],
    );
  }
}