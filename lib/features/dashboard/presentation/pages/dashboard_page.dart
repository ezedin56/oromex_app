import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/widgets/social_footer.dart';
import '../widgets/welcome_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/subject_grid.dart';
import '../widgets/progress_widget.dart';
import '../../../shared/providers/auth_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          'OROMEX',
          style: TextStyles.headline3.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  WelcomeCard(userName: user?.name ?? 'Student'),
                  const SizedBox(height: 20),

                  // Profile Card
                  const ProfileCard(),
                  const SizedBox(height: 20),

                  // Progress Widget
                  const ProgressWidget(),
                  const SizedBox(height: 20),

                  // Subjects Grid
                  Text(
                    'Available Subjects',
                    style: TextStyles.headline2.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SubjectGrid(),
                ],
              ),
            ),
          ),

          // Social Footer
          const SocialFooter(),
        ],
      ),
    );
  }
}
