import 'package:flutter/material.dart';
//import 'Top.dart';

class Reading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test1"),
        ),
        body: Center(
            child: TextButton(
                onPressed: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Reading();
                      }))
                    },
                child: const Text("Top", style: TextStyle(fontSize: 80)))));
  }
}
