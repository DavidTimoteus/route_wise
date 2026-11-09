import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/bottom_nav_bar.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/pages/SignUp.dart';
import 'package:route_wise/services/app_state.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isRememberMeChecked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan email dan password terlebih dahulu.'),
        ),
      );
      return;
    }

    final success = AppStateScope.of(context).login(
      email: email,
      password: password,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyBottomNavBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 4,
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/DB Route.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 20),
              child: RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Welcome ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Back ,\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Color.fromRGBO(228, 95, 43, 1),
                      ),
                    ),
                    TextSpan(
                      text: 'Make it ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Work, ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color.fromRGBO(228, 95, 43, 1),
                      ),
                    ),
                    TextSpan(
                      text: 'Make it ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Right, ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color.fromRGBO(228, 95, 43, 1),
                      ),
                    ),
                    TextSpan(
                      text: 'Make it ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Fast !',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color.fromRGBO(228, 95, 43, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  textField(
                    label: 'Email',
                    icon: FontAwesomeIcons.solidEnvelope,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'david@routewise.id',
                  ),
                  textField(
                    label: 'Password',
                    obscureText: true,
                    icon: FontAwesomeIcons.key,
                    controller: _passwordController,
                    hintText: 'Masukkan password',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: _handleLogin,
                color: const Color.fromRGBO(228, 95, 43, 1),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 5.0,
                    color: Color.fromRGBO(246, 196, 69, 1),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'LOGIN',
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isRememberMeChecked = !_isRememberMeChecked;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isRememberMeChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _isRememberMeChecked = newValue ?? false;
                            });
                          },
                          activeColor: Colors.orange,
                        ),
                        Text(
                          'Remember Me',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Silakan hubungi administrator gudang untuk reset password.',
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        'Forgot Password ?',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don’t Have an Account ?",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(228, 95, 43, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
