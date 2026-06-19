import 'enums.dart';

class UserProfile {
  final UserRole role;
  final AgeGroup ageGroup;
  final SkillLevel skillLevel;
  final String locationLabel;
  final double? latitude;
  final double? longitude;
  final bool onboardingComplete;

  const UserProfile({
    this.role = UserRole.player,
    this.ageGroup = AgeGroup.adult,
    this.skillLevel = SkillLevel.beginner,
    this.locationLabel = '',
    this.latitude,
    this.longitude,
    this.onboardingComplete = false,
  });

  UserProfile copyWith({
    UserRole? role,
    AgeGroup? ageGroup,
    SkillLevel? skillLevel,
    String? locationLabel,
    double? latitude,
    double? longitude,
    bool? onboardingComplete,
  }) {
    return UserProfile(
      role: role ?? this.role,
      ageGroup: ageGroup ?? this.ageGroup,
      skillLevel: skillLevel ?? this.skillLevel,
      locationLabel: locationLabel ?? this.locationLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  Map<String, dynamic> toMap() => {
        'role': role.index,
        'ageGroup': ageGroup.index,
        'skillLevel': skillLevel.index,
        'locationLabel': locationLabel,
        'latitude': latitude,
        'longitude': longitude,
        'onboardingComplete': onboardingComplete,
      };

  factory UserProfile.fromMap(Map<dynamic, dynamic> map) => UserProfile(
        role: UserRole.values[map['role'] as int? ?? 0],
        ageGroup: AgeGroup.values[map['ageGroup'] as int? ?? 7],
        skillLevel: SkillLevel.values[map['skillLevel'] as int? ?? 0],
        locationLabel: map['locationLabel'] as String? ?? '',
        latitude: map['latitude'] as double?,
        longitude: map['longitude'] as double?,
        onboardingComplete: map['onboardingComplete'] as bool? ?? false,
      );
}
