import 'enums.dart';

class SearchFilters {
  final double radiusMiles;
  final AgeGroup? ageGroup;
  final SkillLevel? skillLevel;
  final bool? indoor;
  final double? maxCost;
  final String query;

  const SearchFilters({
    this.radiusMiles = 25,
    this.ageGroup,
    this.skillLevel,
    this.indoor,
    this.maxCost,
    this.query = '',
  });

  SearchFilters copyWith({
    double? radiusMiles,
    AgeGroup? ageGroup,
    bool clearAgeGroup = false,
    SkillLevel? skillLevel,
    bool clearSkillLevel = false,
    bool? indoor,
    bool clearIndoor = false,
    double? maxCost,
    bool clearMaxCost = false,
    String? query,
  }) {
    return SearchFilters(
      radiusMiles: radiusMiles ?? this.radiusMiles,
      ageGroup: clearAgeGroup ? null : (ageGroup ?? this.ageGroup),
      skillLevel: clearSkillLevel ? null : (skillLevel ?? this.skillLevel),
      indoor: clearIndoor ? null : (indoor ?? this.indoor),
      maxCost: clearMaxCost ? null : (maxCost ?? this.maxCost),
      query: query ?? this.query,
    );
  }
}
