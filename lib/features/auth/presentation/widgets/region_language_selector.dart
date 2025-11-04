import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../core/constants/app_constants.dart';

class RegionLanguageSelector extends StatefulWidget {
  final ValueChanged<String> onRegionChanged;
  final ValueChanged<String?> onLanguageChanged;
  final ValueChanged<String> onGradeChanged;

  const RegionLanguageSelector({
    super.key,
    required this.onRegionChanged,
    required this.onLanguageChanged,
    required this.onGradeChanged,
  });

  @override
  State<RegionLanguageSelector> createState() => _RegionLanguageSelectorState();
}

class _RegionLanguageSelectorState extends State<RegionLanguageSelector> {
  String? _selectedRegion;
  String? _selectedLanguage;
  String? _selectedGrade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Region Selection
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Region',
            labelStyle: TextStyle(
              color: AppColors.primaryText.withOpacity(0.7),
            ),
            prefixIcon: Icon(
              Icons.location_on,
              color: AppColors.primaryText.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColors.secondaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          value: _selectedRegion,
          items: AppConstants.regions.map((region) {
            return DropdownMenuItem(
              value: region,
              child: Text(
                region,
                style: TextStyle(color: AppColors.primaryText),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedRegion = value;
              if (value == 'Harar') {
                _selectedLanguage = null;
                widget.onLanguageChanged(null);
              }
            });
            widget.onRegionChanged(value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your region';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Language Selection (only for Oromia and Dire Dawa)
        if (_selectedRegion != null && _selectedRegion != 'Harar')
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Language Stream',
              labelStyle: TextStyle(
                color: AppColors.primaryText.withOpacity(0.7),
              ),
              prefixIcon: Icon(
                Icons.language,
                color: AppColors.primaryText.withOpacity(0.7),
              ),
              filled: true,
              fillColor: AppColors.secondaryBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            value: _selectedLanguage,
            items: AppConstants.languages.map((language) {
              return DropdownMenuItem(
                value: language,
                child: Text(
                  language,
                  style: TextStyle(color: AppColors.primaryText),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value;
              });
              widget.onLanguageChanged(value);
            },
            validator: (value) {
              if (_selectedRegion != 'Harar' &&
                  (value == null || value.isEmpty)) {
                return 'Please select your language stream';
              }
              return null;
            },
          ),
        if (_selectedRegion != null && _selectedRegion != 'Harar')
          const SizedBox(height: 16),

        // Grade Selection
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Grade',
            labelStyle: TextStyle(
              color: AppColors.primaryText.withOpacity(0.7),
            ),
            prefixIcon: Icon(
              Icons.school,
              color: AppColors.primaryText.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColors.secondaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          value: _selectedGrade,
          items: AppConstants.grades.map((grade) {
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
            widget.onGradeChanged(value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your grade';
            }
            return null;
          },
        ),
      ],
    );
  }
}
