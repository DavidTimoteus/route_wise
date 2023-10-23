import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            Image.asset(
              'assets/images/DB Route.png',
              width: 300,
              height: 205,
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Back ,",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 94, 0)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Make it",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Work",
                      style: TextStyle(
                          fontSize: 15, color: Color.fromARGB(255, 255, 94, 0)),
                    ),
                    Text(
                      ", Make it",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Right",
                      style: TextStyle(
                          fontSize: 15, color: Color.fromARGB(255, 255, 94, 0)),
                    ),
                    Text(
                      ", Make it",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Fast !",
                      style: TextStyle(
                          fontSize: 15, color: Color.fromARGB(255, 255, 94, 0)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "E-mail",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: 333,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.mail),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 17)),
                        )),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: 333,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.key),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 17)),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 333,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 94, 0),
                          ),
                          onPressed: () {},
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 7),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 255, 94, 0)),
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, top: 7),
                      child: Text(
                        "Remember me",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 75, top: 7),
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have an Account ?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " Create Account",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 94, 0)),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
