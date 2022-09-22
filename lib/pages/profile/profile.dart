import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
        ),

        //create email input field
        Container(
          margin: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),

        //create phone input field
        Container(
          margin: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phone',
            ),
          ),
        ),

        //create address input field
        Container(
          margin: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Address',
            ),
          ),
        ),

        //create password input field
        Container(
          margin: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),

        //create confirm password input field
        Container(
          margin: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Confirm Password',
            ),
          ),
        ),

        //create update button
        Container(
          margin: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Update'),
          ),
        ),
      ]),
    ));
  }
}
