import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/bottom_nav_bar.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/pages/Login.dart';
import 'package:route_wise/services/app_state.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();
    final occupation = _occupationController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lengkap, email, dan password wajib diisi.'),
        ),
      );
      return;
    }

    AppStateScope.of(context).register(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phone,
      occupation: occupation.isEmpty ? 'Kepala Gudang' : occupation,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyBottomNavBar()),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 10),
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Let’s Join ",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: "With Us ,\n",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: const Color.fromRGBO(228, 95, 43, 1),
                      ),
                    ),
                    TextSpan(
                      text:
                          'Create Your Profile for Exploring the Finest Routes',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  textField(
                    label: 'Full Name',
                    icon: FontAwesomeIcons.solidCircleUser,
                    controller: _fullNameController,
                  ),
                  textField(
                    label: 'Email',
                    icon: FontAwesomeIcons.solidEnvelope,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  textField(
                    label: 'Password',
                    obscureText: true,
                    icon: FontAwesomeIcons.key,
                    controller: _passwordController,
                  ),
                  textField(
                    label: 'Phone Number',
                    icon: FontAwesomeIcons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  textField(
                    label: 'Occupation',
                    icon: FontAwesomeIcons.solidAddressCard,
                    controller: _occupationController,
                    hintText: 'Kepala Gudang / Driver / Admin',
                  ),
                ],
              ),
            ),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: _handleSignUp,
              color: const Color.fromRGBO(228, 95, 43, 1),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 5.0,
                  color: Color.fromRGBO(246, 196, 69, 1),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'SIGN UP',
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an Account ? ',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(228, 95, 43, 1),
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
