enum UserRole { player, parent, coach }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.player:
        return 'Player';
      case UserRole.parent:
        return 'Parent';
      case UserRole.coach:
        return 'Coach';
    }
  }
}

enum AgeGroup { u6, u8, u10, u12, u14, u16, u18, adult, over30, over40 }

extension AgeGroupX on AgeGroup {
  String get label {
    switch (this) {
      case AgeGroup.u6:
        return 'U6';
      case AgeGroup.u8:
        return 'U8';
      case AgeGroup.u10:
        return 'U10';
      case AgeGroup.u12:
        return 'U12';
      case AgeGroup.u14:
        return 'U14';
      case AgeGroup.u16:
        return 'U16';
      case AgeGroup.u18:
        return 'U18';
      case AgeGroup.adult:
        return 'Adult';
      case AgeGroup.over30:
        return 'Over 30';
      case AgeGroup.over40:
        return 'Over 40';
    }
  }

  String get range {
    switch (this) {
      case AgeGroup.u6:
        return '4-5';
      case AgeGroup.u8:
        return '6-7';
      case AgeGroup.u10:
        return '8-9';
      case AgeGroup.u12:
        return '10-11';
      case AgeGroup.u14:
        return '12-13';
      case AgeGroup.u16:
        return '14-15';
      case AgeGroup.u18:
        return '16-17';
      case AgeGroup.adult:
        return '18+';
      case AgeGroup.over30:
        return '30+';
      case AgeGroup.over40:
        return '40+';
    }
  }
}

enum SkillLevel { beginner, intermediate, expert }

extension SkillLevelX on SkillLevel {
  String get label {
    switch (this) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.expert:
        return 'Expert';
    }
  }

  String get description {
    switch (this) {
      case SkillLevel.beginner:
        return 'Recreational, new players';
      case SkillLevel.intermediate:
        return 'Club experience, competitive rec leagues';
      case SkillLevel.expert:
        return 'Academy, competitive travel, semi-pro';
    }
  }
}

enum OpportunityType { league, tournament, academy, pickup }

extension OpportunityTypeX on OpportunityType {
  String get label {
    switch (this) {
      case OpportunityType.league:
        return 'League';
      case OpportunityType.tournament:
        return 'Tournament';
      case OpportunityType.academy:
        return 'Academy';
      case OpportunityType.pickup:
        return 'Pickup Game';
    }
  }
}
