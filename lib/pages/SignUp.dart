import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/Components/bottom_nav_bar.dart';
import 'package:route_wise/Components/text_field.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/pages/Login.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/theme/app_theme.dart';

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
  final TextEditingController _occupationController =
      TextEditingController(text: 'Kepala Gudang');
  UserRole _selectedRole = UserRole.kepalaGudang;

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

    final appState = AppStateScope.of(context);
    appState.register(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phone,
      occupation: occupation.isEmpty ? 'Kepala Gudang' : occupation,
    );
    appState.switchRole(_selectedRole);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyBottomNavBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.canvas,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.ink,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pendaftaran Personel',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'LEDGER ENTRY',
                          style: GoogleFonts.robotoMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.inkMuted,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lengkapi identitas untuk mendapatkan hak akses rute & gudang.',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Role Selection
                  Text(
                    'PERAN OPERASIONAL:',
                    style: GoogleFonts.robotoMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildRoleOption(
                        role: UserRole.kepalaGudang,
                        label: 'Kepala Gudang',
                      ),
                      _buildRoleOption(
                        role: UserRole.driver,
                        label: 'Driver Ekspedisi',
                      ),
                      _buildRoleOption(
                        role: UserRole.admin,
                        label: 'Admin SPK',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  textField(
                    label: 'Nama Lengkap',
                    icon: FontAwesomeIcons.solidCircleUser,
                    controller: _fullNameController,
                    hintText: 'Contoh: Ahmad Maulana',
                  ),
                  const SizedBox(height: 12),
                  textField(
                    label: 'Email Operasional',
                    icon: FontAwesomeIcons.solidEnvelope,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'ahmad@routewise.id',
                  ),
                  const SizedBox(height: 12),
                  textField(
                    label: 'Kata Sandi',
                    obscureText: true,
                    icon: FontAwesomeIcons.key,
                    controller: _passwordController,
                    hintText: 'Minimal 6 karakter',
                  ),
                  const SizedBox(height: 12),
                  textField(
                    label: 'Nomor WhatsApp / Telepon',
                    icon: FontAwesomeIcons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: '08123456789',
                  ),
                  const SizedBox(height: 24),

                  // Submit CTA
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: _handleSignUp,
                      child: Text(
                        'DAFTARKAN PERSONEL',
                        style: GoogleFonts.robotoMono(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const DashedRule(),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah memiliki akun? ',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Masuk',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required UserRole role,
    required String label,
  }) {
    final isSelected = _selectedRole == role;
    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedRole = role;
          if (role == UserRole.kepalaGudang) {
            _occupationController.text = 'Kepala Gudang';
          } else if (role == UserRole.driver) {
            _occupationController.text = 'Driver Ekspedisi';
          } else {
            _occupationController.text = 'Admin SPK';
          }
        });
      },
      label: Text(label),
      labelStyle: GoogleFonts.montserrat(
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.ink,
      ),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceMuted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: isSelected ? AppColors.primaryDark : AppColors.border,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }
}
