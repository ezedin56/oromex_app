import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/exam_card.dart';
import '../../../shared/providers/exam_provider.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../domain/models/exam_model.dart';

class ExamSelectionPage extends StatefulWidget {
  const ExamSelectionPage({super.key});

  @override
  State<ExamSelectionPage> createState() => _ExamSelectionPageState();
}

class _ExamSelectionPageState extends State<ExamSelectionPage> {
  String? _selectedGrade;
  String? _selectedYear;
  String? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Load available exams - you'll need to implement this in ExamProvider
    await examProvider.loadAvailableExams(
      region: authProvider.user?.region,
      languageStream: authProvider.user?.languageStream,
      grade: authProvider.user?.grade,
    );
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Select Exam'),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.secondaryBackground,
            child: Row(
              children: [
                // Grade Filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Grade',
                      labelStyle: TextStyle(
                        color: AppColors.primaryText.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: _selectedGrade ?? authProvider.user?.grade,
                    items: ['7', '8'].map((grade) {
                      return DropdownMenuItem(
                        value: grade,
                        child: Text(
                          'Grade $grade',
                          style: TextStyle(color: AppColors.primaryText),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGrade = value;
                      });
                      _filterExams();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Year Filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Year',
                      labelStyle: TextStyle(
                        color: AppColors.primaryText.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: _selectedYear,
                    items: ['2024', '2023', '2022', '2021', '2020'].map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(
                          year,
                          style: TextStyle(color: AppColors.primaryText),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                      _filterExams();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Unit Filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      labelStyle: TextStyle(
                        color: AppColors.primaryText.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: _selectedUnit,
                    items: ['1', '2', '3', '4', '5'].map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(
                          'Unit $unit',
                          style: TextStyle(color: AppColors.primaryText),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUnit = value;
                      });
                      _filterExams();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Exam List
          Expanded(
            child: examProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : examProvider.availableExams.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: examProvider.availableExams.length,
                        itemBuilder: (context, index) {
                          final exam = examProvider.availableExams[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ExamCard(
                              exam: exam,
                              onTap: () {
                                if (!exam.isAccessible &&
                                    !authProvider.user!.isPremium) {
                                  _showPremiumRequiredDialog(exam);
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    '/exam',
                                    arguments: {
                                      'examId': exam.id,
                                      'examTitle': exam
                                          .title, // Changed from displayTitle
                                    },
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: AppColors.primaryText.withOpacity(0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No exams found',
            style: TextStyles.headline3.copyWith(
              color: AppColors.primaryText.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or check back later',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.primaryText.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Reset Filters',
            variant: ButtonVariant.outlined,
            onPressed: () {
              setState(() {
                _selectedGrade = null;
                _selectedYear = null;
                _selectedUnit = null;
              });
              _filterExams();
            },
          ),
        ],
      ),
    );
  }

  void _filterExams() {
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    examProvider.filterExams(
      grade: _selectedGrade,
      year: _selectedYear != null ? int.tryParse(_selectedYear!) : null,
      unit: _selectedUnit != null ? int.tryParse(_selectedUnit!) : null,
    );
  }

  void _showPremiumRequiredDialog(Exam exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Required'),
        content: Text(
          'This exam is available only for premium users. '
          'Please complete your payment to unlock all chapters.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/premium');
            },
            child: const Text('Go Premium'),
          ),
        ],
      ),
    );
  }
}
