import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/pages/KelolaProfil.dart';
import 'package:route_wise/pages/WelcomeScreen.dart';
import 'package:route_wise/services/app_state.dart';
import 'package:route_wise/theme/app_theme.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final user = appState.currentUser;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.canvas,
        elevation: 0,
        title: Text(
          'PROFIL PERSONEL',
          style: GoogleFonts.robotoMono(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            letterSpacing: 1.0,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit Profil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KelolaProfil()),
              );
            },
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Personnel ID Card Container
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Header Strip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceMuted,
                          border: Border(
                            bottom:
                                BorderSide(color: AppColors.border, width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ID: RW-PER-0${user.role.index + 1}',
                              style: GoogleFonts.robotoMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.inkMuted,
                                letterSpacing: 0.8,
                              ),
                            ),
                            StatusStampBadge.approved(label: 'AKUN AKTIF'),
                          ],
                        ),
                      ),

                      // Avatar & Basic Info
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 46,
                              backgroundColor: AppColors.surfaceMuted,
                              backgroundImage: AssetImage(user.avatarAsset),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              user.fullName,
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: AppColors.inkMuted,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Text(
                                user.roleLabel.toUpperCase(),
                                style: GoogleFonts.robotoMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const DashedRule(),

                      // Structured Ledger Metadata Table
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.phone_rounded,
                              label: 'Kontak Telepon',
                              value: user.phoneNumber,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              icon: Icons.work_rounded,
                              label: 'Divisi / Jabatan',
                              value: user.occupation,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              icon: Icons.account_balance_rounded,
                              label: 'Unit Gudang',
                              value: 'Hub Malang Utama (Gudang Kebonsari)',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Switch Role Quick Utility
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PILIH / GANTI PERAN OPERASIONAL:',
                        style: GoogleFonts.robotoMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildRoleButton(
                              context: context,
                              role: UserRole.kepalaGudang,
                              label: 'Gudang',
                              icon: Icons.warehouse_rounded,
                              isSelected: user.role == UserRole.kepalaGudang,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildRoleButton(
                              context: context,
                              role: UserRole.driver,
                              label: 'Driver',
                              icon: Icons.local_shipping_rounded,
                              isSelected: user.role == UserRole.driver,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildRoleButton(
                              context: context,
                              role: UserRole.admin,
                              label: 'Admin',
                              icon: Icons.tune_rounded,
                              isSelected: user.role == UserRole.admin,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Actions
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(
                    'KELOLA DATA PROFIL',
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KelolaProfil(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.statusRedText,
                    side: const BorderSide(color: AppColors.statusRedBorder),
                    backgroundColor: AppColors.statusRedBg,
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(
                    'LOGOUT DARI SISTEM',
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required UserRole role,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        backgroundColor:
            isSelected ? AppColors.primaryLight : AppColors.surface,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: () {
        AppStateScope.of(context).switchRole(role);
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 14,
            color: isSelected ? AppColors.primary : AppColors.inkMuted,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
