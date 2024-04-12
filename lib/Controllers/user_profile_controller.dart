class UserProfile {
  String? profileImageUrl;
  String? specialty;
  String? about;
  String email;
  String? phoneNumber;
  String? address;
  String? resumeUrl;
  List<WorkExperience> workExperiences;
  List<String> skills;
  List<Education> education;

  UserProfile({
    this.profileImageUrl,
    this.specialty,
    this.about,
    required this.email,
    this.phoneNumber,
    this.address,
    this.resumeUrl,
    this.workExperiences = const [],
    this.skills = const [],
    this.education = const [],
  });
}

class WorkExperience {
  String company;
  String position;
  String duration; // Could be enhanced with DateTime for start and end date

  WorkExperience(
      {required this.company, required this.position, required this.duration});
}

class Education {
  String schoolName;
  String duration; // Example: "2012 - 2016"

  Education({required this.schoolName, required this.duration});
}
