// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../../../app/theme/colors.dart';
// // import '../../../../app/theme/text_styles.dart';
// // import '../../../shared/widgets/custom_button.dart';
// // import '../widgets/exam_card.dart';
// // import '../../../shared/providers/exam_provider.dart';
// // import '../../../shared/providers/auth_provider.dart';
// // import '../../domain/models/exam_model.dart';

// // class ExamSelectionPage extends StatefulWidget {
// //   const ExamSelectionPage({super.key});

// //   @override
// //   State<ExamSelectionPage> createState() => _ExamSelectionPageState();
// // }

// // class _ExamSelectionPageState extends State<ExamSelectionPage> {
// //   String? _selectedGrade;
// //   int? _selectedYear; // Changed to int
// //   int? _selectedUnit;
// //   String? _selectedSubject;
// //   String? _selectedRegion;
// //   String? _selectedLanguageStream;

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _loadExams();
// //     });
// //   }

// //   Future<void> _loadExams() async {
// //     final examProvider = Provider.of<ExamProvider>(context, listen: false);
// //     final authProvider = Provider.of<AuthProvider>(context, listen: false);

// //     // Set initial filters from user data
// //     if (authProvider.user != null) {
// //       setState(() {
// //         _selectedGrade = authProvider.user!.grade;
// //         _selectedRegion = authProvider.user!.region;
// //         _selectedLanguageStream = authProvider.user!.languageStream;
// //       });
// //     }

// //     await examProvider.loadAvailableExams(
// //       region: _selectedRegion,
// //       languageStream: _selectedLanguageStream,
// //       grade: _selectedGrade,
// //     );
// //   }

// //   void _filterExams() {
// //     final examProvider = Provider.of<ExamProvider>(context, listen: false);
// //     examProvider.filterExams(
// //       grade: _selectedGrade,
// //       year: _selectedYear, // Now directly using int
// //       unit: _selectedUnit,
// //       subject: _selectedSubject,
// //       region: _selectedRegion,
// //       languageStream: _selectedLanguageStream,
// //     );
// //   }

// //   void _resetFilters() {
// //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
// //     setState(() {
// //       _selectedGrade = authProvider.user?.grade;
// //       _selectedYear = null;
// //       _selectedUnit = null;
// //       _selectedSubject = null;
// //       _selectedRegion = authProvider.user?.region;
// //       _selectedLanguageStream = authProvider.user?.languageStream;
// //     });
// //     _filterExams();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final examProvider = Provider.of<ExamProvider>(context);
// //     final authProvider = Provider.of<AuthProvider>(context);

// //     // Get unique values for dropdowns from available exams
// //     final uniqueGrades = _getUniqueGrades(examProvider.availableExams);
// //     final uniqueYears = _getUniqueYears(examProvider.availableExams);
// //     final uniqueUnits = _getUniqueUnits(examProvider.availableExams);
// //     final uniqueSubjects = _getUniqueSubjects(examProvider.availableExams);
// //     final uniqueRegions = _getUniqueRegions(examProvider.availableExams);
// //     final uniqueLanguageStreams =
// //         _getUniqueLanguageStreams(examProvider.availableExams);

// //     return Scaffold(
// //       backgroundColor: AppColors.primaryBackground,
// //       appBar: AppBar(
// //         title: const Text('Select Exam'),
// //         backgroundColor: AppColors.primaryBackground,
// //         elevation: 0,
// //         actions: [
// //           if (_hasActiveFilters())
// //             IconButton(
// //               onPressed: _resetFilters,
// //               icon: const Icon(Icons.filter_alt_off),
// //               tooltip: 'Reset Filters',
// //             ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // Filters Section
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             color: AppColors.secondaryBackground,
// //             child: Column(
// //               children: [
// //                 // First row of filters
// //                 Row(
// //                   children: [
// //                     // Grade Filter
// //                     Expanded(
// //                       child: _buildDropdown(
// //                         label: 'Grade',
// //                         value: _selectedGrade,
// //                         items: uniqueGrades,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _selectedGrade = value;
// //                           });
// //                           _filterExams();
// //                         },
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     // Year Filter
// //                     Expanded(
// //                       child: _buildYearDropdown(uniqueYears),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     // Unit Filter
// //                     Expanded(
// //                       child: _buildDropdown(
// //                         label: 'Unit',
// //                         value: _selectedUnit?.toString(),
// //                         items: uniqueUnits,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _selectedUnit =
// //                                 value != null ? int.tryParse(value) : null;
// //                           });
// //                           _filterExams();
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),
// //                 // Second row of filters
// //                 Row(
// //                   children: [
// //                     // Subject Filter
// //                     Expanded(
// //                       child: _buildDropdown(
// //                         label: 'Subject',
// //                         value: _selectedSubject,
// //                         items: uniqueSubjects,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _selectedSubject = value;
// //                           });
// //                           _filterExams();
// //                         },
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     // Region Filter
// //                     Expanded(
// //                       child: _buildDropdown(
// //                         label: 'Region',
// //                         value: _selectedRegion,
// //                         items: uniqueRegions,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _selectedRegion = value;
// //                           });
// //                           _filterExams();
// //                         },
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     // Language Stream Filter
// //                     Expanded(
// //                       child: _buildDropdown(
// //                         label: 'Language',
// //                         value: _selectedLanguageStream,
// //                         items: uniqueLanguageStreams,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _selectedLanguageStream = value;
// //                           });
// //                           _filterExams();
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),

// //           // Exam List
// //           Expanded(
// //             child: examProvider.isLoading
// //                 ? const Center(child: CircularProgressIndicator())
// //                 : examProvider.availableExams.isEmpty
// //                     ? _buildEmptyState()
// //                     : RefreshIndicator(
// //                         onRefresh: _loadExams,
// //                         child: ListView.builder(
// //                           padding: const EdgeInsets.all(16),
// //                           itemCount: examProvider.availableExams.length,
// //                           itemBuilder: (context, index) {
// //                             final exam = examProvider.availableExams[index];
// //                             return Padding(
// //                               padding: const EdgeInsets.only(bottom: 12),
// //                               child: ExamCard(
// //                                 exam: exam,
// //                                 onTap: () {
// //                                   // Check if user can access the exam
// //                                   if (exam.isPremium &&
// //                                       (authProvider.user == null ||
// //                                           !authProvider.user!.isPremium)) {
// //                                     _showPremiumRequiredDialog(exam);
// //                                   } else {
// //                                     Navigator.pushNamed(
// //                                       context,
// //                                       '/exam',
// //                                       arguments: {
// //                                         'examId': exam.id,
// //                                         'examTitle': exam.displayTitle,
// //                                       },
// //                                     );
// //                                   }
// //                                 },
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDropdown({
// //     required String label,
// //     required String? value,
// //     required List<String> items,
// //     required Function(String?) onChanged,
// //   }) {
// //     return DropdownButtonFormField<String>(
// //       decoration: InputDecoration(
// //         labelText: label,
// //         labelStyle: TextStyle(
// //           color: AppColors.primaryText.withOpacity(0.7),
// //         ),
// //         filled: true,
// //         fillColor: AppColors.cardBackground,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: BorderSide.none,
// //         ),
// //         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       ),
// //       value: value,
// //       items: [
// //         DropdownMenuItem(
// //           value: null,
// //           child: Text(
// //             'All $label',
// //             style: TextStyle(color: AppColors.primaryText.withOpacity(0.5)),
// //           ),
// //         ),
// //         ...items.map((item) {
// //           return DropdownMenuItem(
// //             value: item,
// //             child: Text(
// //               item,
// //               style: TextStyle(color: AppColors.primaryText),
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //           );
// //         }).toList(),
// //       ],
// //       onChanged: onChanged,
// //       isExpanded: true,
// //     );
// //   }

// //   Widget _buildYearDropdown(List<String> uniqueYears) {
// //     return DropdownButtonFormField<int>(
// //       decoration: InputDecoration(
// //         labelText: 'Year',
// //         labelStyle: TextStyle(
// //           color: AppColors.primaryText.withOpacity(0.7),
// //         ),
// //         filled: true,
// //         fillColor: AppColors.cardBackground,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: BorderSide.none,
// //         ),
// //         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       ),
// //       value: _selectedYear,
// //       items: [
// //         const DropdownMenuItem(
// //           value: null,
// //           child: Text(
// //             'All Years',
// //             style: TextStyle(color: AppColors.primaryText.withOpacity(0.5)),
// //           ),
// //         ),
// //         ...uniqueYears.map((year) {
// //           return DropdownMenuItem(
// //             value: int.tryParse(year),
// //             child: Text(
// //               year,
// //               style: TextStyle(color: AppColors.primaryText),
// //             ),
// //           );
// //         }).toList(),
// //       ],
// //       onChanged: (value) {
// //         setState(() {
// //           _selectedYear = value;
// //         });
// //         _filterExams();
// //       },
// //       isExpanded: true,
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(24.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Icons.search_off,
// //               color: AppColors.primaryText.withOpacity(0.5),
// //               size: 64,
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               'No exams found',
// //               style: TextStyles.headlineSmall.copyWith(
// //                 color: AppColors.primaryText.withOpacity(0.7),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Try adjusting your filters or check back later',
// //               style: TextStyles.bodyMedium.copyWith(
// //                 color: AppColors.primaryText.withOpacity(0.5),
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 24),
// //             CustomButton(
// //               text: 'Reset Filters',
// //               variant: ButtonVariant.outlined,
// //               onPressed: _resetFilters,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showPremiumRequiredDialog(Exam exam) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Premium Required'),
// //         content: Text(
// //           'The exam "${exam.displayTitle}" is available only for premium users. '
// //           'Please upgrade to premium to access this content.',
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               Navigator.pushNamed(context, '/premium');
// //             },
// //             child: const Text('Go Premium'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Helper methods to get unique values from exams
// //   List<String> _getUniqueGrades(List<Exam> exams) {
// //     return exams.map((e) => e.grade).toSet().toList()..sort();
// //   }

// //   List<String> _getUniqueYears(List<Exam> exams) {
// //     return exams.map((e) => e.year.toString()).toSet().toList()
// //       ..sort((a, b) => b.compareTo(a));
// //   }

// //   List<String> _getUniqueUnits(List<Exam> exams) {
// //     return exams.map((e) => e.unit.toString()).toSet().toList()..sort();
// //   }

// //   List<String> _getUniqueSubjects(List<Exam> exams) {
// //     return exams.map((e) => e.subject).toSet().toList()..sort();
// //   }

// //   List<String> _getUniqueRegions(List<Exam> exams) {
// //     return exams.map((e) => e.region).toSet().toList()..sort();
// //   }

// //   List<String> _getUniqueLanguageStreams(List<Exam> exams) {
// //     return exams.map((e) => e.languageStream).toSet().toList()..sort();
// //   }

// //   bool _hasActiveFilters() {
// //     return _selectedYear != null ||
// //         _selectedUnit != null ||
// //         _selectedSubject != null ||
// //         _selectedRegion != null ||
// //         _selectedLanguageStream != null;
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../app/theme/colors.dart';
// import '../../../../app/theme/text_styles.dart';
// import '../../../shared/widgets/custom_button.dart';
// import '../../../shared/widgets/loading_indicator.dart'; // Add this import
// import '../widgets/exam_card.dart';
// import '../../../shared/providers/exam_provider.dart';
// import '../../../shared/providers/auth_provider.dart';
// import '../../domain/models/exam_model.dart'; // Fixed import path

// class ExamSelectionPage extends StatefulWidget {
//   const ExamSelectionPage({super.key});

//   @override
//   State<ExamSelectionPage> createState() => _ExamSelectionPageState();
// }

// class _ExamSelectionPageState extends State<ExamSelectionPage> {
//   String? _selectedGrade;
//   int? _selectedYear;
//   int? _selectedUnit;
//   String? _selectedSubject;
//   String? _selectedRegion;
//   String? _selectedLanguageStream;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadExams();
//     });
//   }

//   Future<void> _loadExams() async {
//     final examProvider = Provider.of<ExamProvider>(context, listen: false);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     // Set initial filters from user data
//     if (authProvider.user != null) {
//       setState(() {
//         _selectedGrade = authProvider.user!.grade;
//         _selectedRegion = authProvider.user!.region;
//         _selectedLanguageStream = authProvider.user!.languageStream;
//       });
//     }

//     await examProvider.loadAvailableExams(
//       region: _selectedRegion,
//       languageStream: _selectedLanguageStream,
//       grade: _selectedGrade,
//     );
//   }

//   void _filterExams() {
//     final examProvider = Provider.of<ExamProvider>(context, listen: false);
//     examProvider.filterExams(
//       grade: _selectedGrade,
//       year: _selectedYear,
//       unit: _selectedUnit,
//       subject: _selectedSubject,
//       region: _selectedRegion,
//       languageStream: _selectedLanguageStream,
//     );
//   }

//   void _resetFilters() {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     setState(() {
//       _selectedGrade = authProvider.user?.grade;
//       _selectedYear = null;
//       _selectedUnit = null;
//       _selectedSubject = null;
//       _selectedRegion = authProvider.user?.region;
//       _selectedLanguageStream = authProvider.user?.languageStream;
//     });
//     _filterExams();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final examProvider = Provider.of<ExamProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context);

//     // Get unique values for dropdowns from available exams
//     final uniqueGrades = _getUniqueGrades(examProvider.availableExams);
//     final uniqueYears = _getUniqueYears(examProvider.availableExams);
//     final uniqueUnits = _getUniqueUnits(examProvider.availableExams);
//     final uniqueSubjects = _getUniqueSubjects(examProvider.availableExams);
//     final uniqueRegions = _getUniqueRegions(examProvider.availableExams);
//     final uniqueLanguageStreams =
//         _getUniqueLanguageStreams(examProvider.availableExams);

//     return Scaffold(
//       backgroundColor: AppColors.primaryBackground,
//       appBar: AppBar(
//         title: const Text('Select Exam'),
//         backgroundColor: AppColors.primaryBackground,
//         elevation: 0,
//         actions: [
//           if (_hasActiveFilters())
//             IconButton(
//               onPressed: _resetFilters,
//               icon: const Icon(Icons.filter_alt_off),
//               tooltip: 'Reset Filters',
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filters Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: AppColors.secondaryBackground,
//             child: Column(
//               children: [
//                 // First row of filters
//                 Row(
//                   children: [
//                     // Grade Filter
//                     Expanded(
//                       child: _buildDropdown(
//                         label: 'Grade',
//                         value: _selectedGrade,
//                         items: uniqueGrades,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedGrade = value;
//                           });
//                           _filterExams();
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Year Filter
//                     Expanded(
//                       child: _buildYearDropdown(uniqueYears),
//                     ),
//                     const SizedBox(width: 12),
//                     // Unit Filter
//                     Expanded(
//                       child: _buildDropdown(
//                         label: 'Unit',
//                         value: _selectedUnit?.toString(),
//                         items: uniqueUnits,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedUnit =
//                                 value != null ? int.tryParse(value) : null;
//                           });
//                           _filterExams();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 // Second row of filters
//                 Row(
//                   children: [
//                     // Subject Filter
//                     Expanded(
//                       child: _buildDropdown(
//                         label: 'Subject',
//                         value: _selectedSubject,
//                         items: uniqueSubjects,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedSubject = value;
//                           });
//                           _filterExams();
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Region Filter
//                     Expanded(
//                       child: _buildDropdown(
//                         label: 'Region',
//                         value: _selectedRegion,
//                         items: uniqueRegions,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedRegion = value;
//                           });
//                           _filterExams();
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Language Stream Filter
//                     Expanded(
//                       child: _buildDropdown(
//                         label: 'Language',
//                         value: _selectedLanguageStream,
//                         items: uniqueLanguageStreams,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedLanguageStream = value;
//                           });
//                           _filterExams();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Exam List
//           Expanded(
//             child: examProvider.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : examProvider.availableExams.isEmpty
//                     ? _buildEmptyState()
//                     : RefreshIndicator(
//                         onRefresh: _loadExams,
//                         child: ListView.builder(
//                           padding: const EdgeInsets.all(16),
//                           itemCount: examProvider.availableExams.length,
//                           itemBuilder: (context, index) {
//                             final exam = examProvider.availableExams[index];
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 12),
//                               child: ExamCard(
//                                 exam: exam,
//                                 onTap: () {
//                                   // Check if user can access the exam
//                                   if (exam.isPremium &&
//                                       (authProvider.user == null ||
//                                           !authProvider.user!.isPremium)) {
//                                     _showPremiumRequiredDialog(exam);
//                                   } else {
//                                     Navigator.pushNamed(
//                                       context,
//                                       '/exam',
//                                       arguments: {
//                                         'examId': exam.id,
//                                         'examTitle': exam.displayTitle,
//                                       },
//                                     );
//                                   }
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ... rest of your methods remain the same
//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(
//           color: AppColors.primaryText.withOpacity(0.7),
//         ),
//         filled: true,
//         fillColor: AppColors.cardBackground,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),
//       value: value,
//       items: [
//         DropdownMenuItem(
//           value: null,
//           child: Text(
//             'All $label',
//             style: TextStyle(color: AppColors.primaryText.withOpacity(0.5)),
//           ),
//         ),
//         ...items.map((item) {
//           return DropdownMenuItem(
//             value: item,
//             child: Text(
//               item,
//               style: TextStyle(color: AppColors.primaryText),
//               overflow: TextOverflow.ellipsis,
//             ),
//           );
//         }).toList(),
//       ],
//       onChanged: onChanged,
//       isExpanded: true,
//     );
//   }

//   Widget _buildYearDropdown(List<String> uniqueYears) {
//     return DropdownButtonFormField<int>(
//       decoration: InputDecoration(
//         labelText: 'Year',
//         labelStyle: TextStyle(
//           color: AppColors.primaryText.withOpacity(0.7),
//         ),
//         filled: true,
//         fillColor: AppColors.cardBackground,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),
//       value: _selectedYear,
//       items: [
//         const DropdownMenuItem(
//           value: null,
//           child: Text(
//             'All Years',
//             style: TextStyle(color: AppColors.primaryText.withOpacity(0.5)),
//           ),
//         ),
//         ...uniqueYears.map((year) {
//           return DropdownMenuItem(
//             value: int.tryParse(year),
//             child: Text(
//               year,
//               style: TextStyle(color: AppColors.primaryText),
//             ),
//           );
//         }).toList(),
//       ],
//       onChanged: (value) {
//         setState(() {
//           _selectedYear = value;
//         });
//         _filterExams();
//       },
//       isExpanded: true,
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.search_off,
//               color: AppColors.primaryText.withOpacity(0.5),
//               size: 64,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No exams found',
//               style: TextStyles.headline2.copyWith(
//                 // Fixed text style
//                 color: AppColors.primaryText.withOpacity(0.7),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Try adjusting your filters or check back later',
//               style: TextStyles.bodyMedium.copyWith(
//                 color: AppColors.primaryText.withOpacity(0.5),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             CustomButton(
//               text: 'Reset Filters',
//               variant: ButtonVariant.outlined,
//               onPressed: _resetFilters,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showPremiumRequiredDialog(Exam exam) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Premium Required'),
//         content: Text(
//           'The exam "${exam.displayTitle}" is available only for premium users. '
//           'Please upgrade to premium to access this content.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/premium');
//             },
//             child: const Text('Go Premium'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper methods to get unique values from exams
//   List<String> _getUniqueGrades(List<Exam> exams) {
//     return exams.map((e) => e.grade).toSet().toList()..sort();
//   }

//   List<String> _getUniqueYears(List<Exam> exams) {
//     return exams.map((e) => e.year.toString()).toSet().toList()
//       ..sort((a, b) => b.compareTo(a));
//   }

//   List<String> _getUniqueUnits(List<Exam> exams) {
//     return exams.map((e) => e.unit.toString()).toSet().toList()..sort();
//   }

//   List<String> _getUniqueSubjects(List<Exam> exams) {
//     return exams.map((e) => e.subject).toSet().toList()..sort();
//   }

//   List<String> _getUniqueRegions(List<Exam> exams) {
//     return exams.map((e) => e.region).toSet().toList()..sort();
//   }

//   List<String> _getUniqueLanguageStreams(List<Exam> exams) {
//     return exams.map((e) => e.languageStream).toSet().toList()..sort();
//   }

//   bool _hasActiveFilters() {
//     return _selectedYear != null ||
//         _selectedUnit != null ||
//         _selectedSubject != null ||
//         _selectedRegion != null ||
//         _selectedLanguageStream != null;
//   }
// }
class Exam {
  final String id;
  final String subject;
  final int year;
  final int unit;
  final String grade;
  final String region;
  final String languageStream;
  final String title;
  final String description;
  final int duration; // in minutes
  final int totalQuestions;
  final bool isPremium;
  final bool isFree;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exam({
    required this.id,
    required this.subject,
    required this.year,
    required this.unit,
    required this.grade,
    required this.region,
    required this.languageStream,
    required this.title,
    required this.description,
    required this.duration,
    required this.totalQuestions,
    required this.isPremium,
    required this.isFree,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      year: json['year'] is int
          ? json['year']
          : int.tryParse(json['year']?.toString() ?? '0') ?? 0,
      unit: json['unit'] is int
          ? json['unit']
          : int.tryParse(json['unit']?.toString() ?? '0') ?? 0,
      grade: json['grade']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      languageStream: json['language_stream']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? '60') ?? 60,
      totalQuestions: json['total_questions'] is int
          ? json['total_questions']
          : int.tryParse(json['total_questions']?.toString() ?? '0') ?? 0,
      isPremium: json['is_premium'] is bool
          ? json['is_premium']
          : (json['is_premium']?.toString() == 'true'),
      isFree: json['is_free'] is bool
          ? json['is_free']
          : (json['is_free']?.toString() != 'false'),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']?.toString() ?? '') ??
              DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
              DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'year': year,
      'unit': unit,
      'grade': grade,
      'region': region,
      'language_stream': languageStream,
      'title': title,
      'description': description,
      'duration': duration,
      'total_questions': totalQuestions,
      'is_premium': isPremium,
      'is_free': isFree,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayTitle => '$subject - $year (Unit $unit)';

  String get displayInfo =>
      'Grade $grade • $duration min • $totalQuestions questions';

  bool get isAccessible => isFree || !isPremium;

  Duration get durationAsDuration => Duration(minutes: duration);
}
