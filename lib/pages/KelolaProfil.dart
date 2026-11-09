import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';
import 'package:route_wise/services/app_state.dart';

class KelolaProfil extends StatefulWidget {
  const KelolaProfil({super.key});

  @override
  State<KelolaProfil> createState() => _KelolaProfilState();
}

class _KelolaProfilState extends State<KelolaProfil> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final user = AppStateScope.of(context).currentUser;
      _nameController.text = user.fullName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    AppStateScope.of(context).updateProfile(
      fullName: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phoneNumber: _phoneController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui.')),
    );
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).currentUser;

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
            color: Color.fromARGB(255, 255, 94, 0),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              FontAwesomeIcons.rightFromBracket,
              color: Color.fromARGB(255, 255, 94, 0),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'PROFILE',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/images/Profile.jpg'),
            ),
            const SizedBox(height: 10),
            Text(
              user.fullName,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              user.email,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  inputFile(
                    label: 'Full Name',
                    teks: user.fullName,
                    icon: FontAwesomeIcons.solidCircleUser,
                    controller: _nameController,
                    labelColor: Colors.grey,
                    iconColor: Colors.black,
                  ),
                  inputFile(
                    label: 'E-mail',
                    teks: user.email,
                    icon: FontAwesomeIcons.solidEnvelope,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    labelColor: Colors.grey,
                    iconColor: Colors.black,
                  ),
                  inputFile(
                    label: 'Password',
                    teks: 'Kosongkan jika tidak diubah',
                    obscureText: true,
                    icon: FontAwesomeIcons.key,
                    controller: _passwordController,
                    labelColor: Colors.grey,
                    iconColor: Colors.black,
                  ),
                  inputFile(
                    label: 'Phone Number',
                    teks: user.phoneNumber,
                    icon: FontAwesomeIcons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    labelColor: Colors.grey,
                    iconColor: Colors.black,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA0E548),
                  ),
                  onPressed: _saveProfile,
                  child: Text(
                    'SAVE',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
