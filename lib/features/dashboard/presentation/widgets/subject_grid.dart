import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/providers/auth_provider.dart';

class SubjectGrid extends StatelessWidget {
  const SubjectGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Filter subjects based on user's language stream
    final availableSubjects = _getAvailableSubjects(user?.languageStream);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: availableSubjects.length,
      itemBuilder: (context, index) {
        final subject = availableSubjects[index];
        return _SubjectCard(
          subject: subject,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/exam-selection',
              arguments: {'subject': subject},
            );
          },
        );
      },
    );
  }

  List<String> _getAvailableSubjects(String? languageStream) {
    final subjects = List<String>.from(AppConstants.subjects);

    // Replace language subject based on user's stream
    if (languageStream == 'Afan Oromo') {
      subjects.remove('Amharic');
    } else if (languageStream == 'Amharic') {
      subjects.remove('Afan Oromo');
    } else {
      // For Harar region, show both or adjust as needed
      subjects.removeWhere(
        (subject) => subject == 'Afan Oromo' || subject == 'Amharic',
      );
    }

    return subjects;
  }
}

class _SubjectCard extends StatelessWidget {
  final String subject;
  final VoidCallback onTap;

  const _SubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Subject Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getSubjectColor(subject).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getSubjectIcon(subject),
                  color: _getSubjectColor(subject),
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              // Subject Name
              Text(
                subject,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Mathematics':
        return Colors.blue;
      case 'English':
        return Colors.green;
      case 'Afan Oromo':
        return Colors.orange;
      case 'Amharic':
        return Colors.purple;
      case 'Science':
        return Colors.red;
      case 'Social Studies':
        return Colors.brown;
      case 'Civic Education':
        return Colors.teal;
      default:
        return AppColors.accentColor;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Mathematics':
        return Icons.calculate;
      case 'English':
        return Icons.language;
      case 'Afan Oromo':
      case 'Amharic':
        return Icons.translate;
      case 'Science':
        return Icons.science;
      case 'Social Studies':
        return Icons.public;
      case 'Civic Education':
        return Icons.account_balance;
      default:
        return Icons.school;
    }
  }
}
