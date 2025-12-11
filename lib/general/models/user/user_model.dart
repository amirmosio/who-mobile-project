import 'school_model.dart';

class UserModel {
  // Core fields (mandatory)
  final int id;
  final String email;

  // Authentication fields
  final String? password;
  final String? udid;
  final DateTime? lastLogin;

  // Social login fields
  final String? facebookId;

  // Personal information
  final String? firstName; // name in Android
  final String? surname;
  final DateTime? birthDate;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? province; // provincia in Android
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? image;

  // School and license information
  final SchoolModel? school;
  final int? licenseType;

  // Date fields
  final DateTime? registrationDate;
  final DateTime? nowDatetime;

  // Status flags
  final bool isPlayingCard;
  final bool isWinnerCard;
  final bool isGuest;
  final bool wasGuest;
  final bool isRegistered;

  // Arrays from Android
  final List<int> teacherLtDs;
  final List<int> instructorLtDs;
  final List<int> adminDrivingschool;

  // Activity flags
  final bool isAdvActive;
  final bool isPartnerActive;
  final List<String> badges;
  final bool isRetargetingConversion;

  // Video related
  final bool hasVideoBought;
  final int? videoState;

  // First lesson
  final bool hasFirstLesson;
  final DateTime? firstLessonDatetime;

  // Privacy and marketing
  final bool acceptedPrivacy;
  final bool acceptedMarketing;

  // Contest
  final bool isParticipatingContest;

  // E-book
  final bool hasEbook;

  // Mini videos
  final bool hasMiniVideoUnlocked;
  final bool hasMiniVideoBasic;
  final bool hasMiniVideoSilver;

  // Neith AI features
  final bool hasNeithAIActive;
  final bool hasNeithDeepeningVideosActive;
  final int? drivingSchoolNeith;
  final bool alreadySubscribedToDrivingSchool;
  final DateTime? neithDemoExpiration;

  // Additional fields
  final int? sex;
  final int? territory;

  // Teacher and instructor classes
  final List<int> teacherClasses;
  final List<int> instructorClasses;
  final List<int> studentLtDs;

  // Access and permissions
  final bool hasMatrixAccess;
  final bool isActive;
  final bool isCompleted;
  final bool isStaff;
  final bool isTutor;
  final bool? isAmbassador;
  final bool isArchived;
  final bool isDeleted;
  final bool isRobot;
  final bool isLink;
  final bool wasLink;

  // School and classroom
  final bool hasSchoolRecovery;
  final bool hasClassroomAccess;
  final bool hasReferral;
  final bool isRis;

  // Mail status
  final bool mailConfirmed;
  final bool mailBounced;
  final bool mailComplaints;

  // Study and lessons
  final int? statusStudy;
  final bool isTeacherNeith;
  final String? zoomUrl;
  final String? wherebyUrl;
  final double? amountForLesson;
  final String? personalEmailTeacherNeith;
  final bool isTeacherExpressPro;
  final bool isSuper;
  final int? adminEverestAccessCount;

  // Video dates
  final DateTime? startVideosDatetime;
  final DateTime? endVideosDatetime;

  // License information
  final DateTime? provisionalLicenseExpirationDate;
  final String? secondEmail;
  final String? licenseNumber;
  final DateTime? licenseExpirationDate;
  final DateTime? licenseCqcMerciExpirationDate;
  final DateTime? licenseCqcPersoneExpirationDate;
  final DateTime? licenseCapExpirationDate;
  final DateTime? licenseAdrExpirationDate;
  final DateTime? licenseMulettoExpirationDate;
  final DateTime? licenseGruExpirationDate;

  // Social login IDs
  final String? huaweiId;
  final String? appleId;

  // Contest and mini videos
  final int? contestVictories;
  final int? miniVideoViews;
  final bool isParticipatingAdventCalendar;

  // Phone for Neith
  final String? neithPhone;

  // Exam readiness
  final bool isAlmostReadyForExam;
  final bool isReadyForExam;

  // Neith features extended
  final bool hasNeithOnlineLessonsActive;
  final bool hasNeithFullActive;
  final DateTime? neithEntryDatetime;
  final bool hasNeithDemo;
  final int? neithDemoMessagesNumber;
  final bool hasNeithAIActiveBeforeDemo;
  final int? demoLiveCounter;
  final bool neithPrivacyAccepted;
  final DateTime? neithPrivacyAcceptedDate;
  final bool neithAddressInfoUpdated;
  final bool neithAppReviewSent;
  final bool hasNeithGpt;
  final bool hasNeithGptDemo;
  final DateTime? hasNeithGptDemoExpiration;

  // User type flags
  final bool isNotDrivingLicenseB;
  final String? abTestVersion;

  // Everest
  final DateTime? lastEverestLogin;
  final String? everestPages;

  // Neith demo
  final DateTime? neithDemoFirstMessageSentDate;
  final int? neithDemoMessageStep;

  // Neith subscription types
  final bool isNeithCodeUser;
  final bool isNeithBoostCode;
  final bool isNeithExpress;
  final bool isNeithExpressPro;
  final bool isNeithVip;
  final bool hasPaidMinimumNeithExpress;
  final bool examAsap;

  // Handler driving school
  final DateTime? handlerDrivingSchoolNeithAssociationDate;
  final double? handlerDrivingSchoolNeithAmount;
  final DateTime? handlerDrivingSchoolNeithAmountDate;
  final bool handlerWithDrivings;
  final bool handlerOnlyDrivings;

  // Enrollment
  final DateTime? enrollmentDatetime;
  final bool includedBulletins;

  // Neith zone gift
  final DateTime? neithZoneGiftRegistrationDate;
  final String? neithZoneGiftRegistrationPhoto;
  final int? neithZoneGiftStartingPoints;

  // Payment
  final int? neithDeferredPaymentStep;
  final bool hasVoucherAsRefund;

  // Related entities (IDs)
  final int? motorisation;
  final int? handlerDrivingSchoolNeith;
  final int? neithZoneGift;
  final int? neithTutorAssociated;

  // Driving license types
  final List<int> drivingLicenseTypes;

  // Privacy and consent
  final String? acceptedTermsVersion;
  final String? acceptedPrivacyVersion;
  final DateTime? lastConsentUpdate;
  final DateTime? entryDatetime;

  String? get fullName {
    if (firstName == null && surname == null) return null;
    return "${firstName ?? ''} ${surname ?? ''}".trim();
  }

  const UserModel({
    required this.id,
    required this.email,
    this.password,
    this.udid,
    this.lastLogin,
    this.facebookId,
    this.firstName,
    this.surname,
    this.birthDate,
    this.address,
    this.city,
    this.zipCode,
    this.province,
    this.country,
    this.latitude,
    this.longitude,
    this.phone,
    this.image,
    this.school,
    this.licenseType,
    this.registrationDate,
    this.nowDatetime,
    this.isPlayingCard = false,
    this.isWinnerCard = false,
    this.isGuest = true, // Default true like Android
    this.wasGuest = true, // Default true like Android
    this.isRegistered = true, // Default true like Android
    this.teacherLtDs = const [],
    this.instructorLtDs = const [],
    this.adminDrivingschool = const [],
    this.isAdvActive = true, // Default true like Android
    this.isPartnerActive = false,
    this.badges = const [],
    this.isRetargetingConversion = false,
    this.hasVideoBought = false,
    this.videoState,
    this.hasFirstLesson = false,
    this.firstLessonDatetime,
    this.acceptedPrivacy = false,
    this.acceptedMarketing = false,
    this.isParticipatingContest = false,
    this.hasEbook = false,
    this.hasMiniVideoUnlocked = false,
    this.hasMiniVideoBasic = false,
    this.hasMiniVideoSilver = false,
    this.hasNeithAIActive = false,
    this.hasNeithDeepeningVideosActive = false,
    this.drivingSchoolNeith,
    this.alreadySubscribedToDrivingSchool = false,
    this.neithDemoExpiration,
    this.sex,
    this.territory,
    // New fields
    this.teacherClasses = const [],
    this.instructorClasses = const [],
    this.studentLtDs = const [],
    this.hasMatrixAccess = false,
    this.isActive = true,
    this.isCompleted = false,
    this.isStaff = false,
    this.isTutor = false,
    this.isAmbassador,
    this.isArchived = false,
    this.isDeleted = false,
    this.isRobot = false,
    this.isLink = false,
    this.wasLink = false,
    this.hasSchoolRecovery = false,
    this.hasClassroomAccess = false,
    this.hasReferral = false,
    this.isRis = false,
    this.mailConfirmed = false,
    this.mailBounced = false,
    this.mailComplaints = false,
    this.statusStudy,
    this.isTeacherNeith = false,
    this.zoomUrl,
    this.wherebyUrl,
    this.amountForLesson,
    this.personalEmailTeacherNeith,
    this.isTeacherExpressPro = false,
    this.isSuper = false,
    this.adminEverestAccessCount,
    this.startVideosDatetime,
    this.endVideosDatetime,
    this.provisionalLicenseExpirationDate,
    this.secondEmail,
    this.licenseNumber,
    this.licenseExpirationDate,
    this.licenseCqcMerciExpirationDate,
    this.licenseCqcPersoneExpirationDate,
    this.licenseCapExpirationDate,
    this.licenseAdrExpirationDate,
    this.licenseMulettoExpirationDate,
    this.licenseGruExpirationDate,
    this.huaweiId,
    this.appleId,
    this.contestVictories,
    this.miniVideoViews,
    this.isParticipatingAdventCalendar = false,
    this.neithPhone,
    this.isAlmostReadyForExam = false,
    this.isReadyForExam = false,
    this.hasNeithOnlineLessonsActive = false,
    this.hasNeithFullActive = false,
    this.neithEntryDatetime,
    this.hasNeithDemo = false,
    this.neithDemoMessagesNumber,
    this.hasNeithAIActiveBeforeDemo = false,
    this.demoLiveCounter,
    this.neithPrivacyAccepted = false,
    this.neithPrivacyAcceptedDate,
    this.neithAddressInfoUpdated = false,
    this.neithAppReviewSent = false,
    this.hasNeithGpt = false,
    this.hasNeithGptDemo = false,
    this.hasNeithGptDemoExpiration,
    this.isNotDrivingLicenseB = false,
    this.abTestVersion,
    this.lastEverestLogin,
    this.everestPages,
    this.neithDemoFirstMessageSentDate,
    this.neithDemoMessageStep,
    this.isNeithCodeUser = false,
    this.isNeithBoostCode = false,
    this.isNeithExpress = false,
    this.isNeithExpressPro = false,
    this.isNeithVip = false,
    this.hasPaidMinimumNeithExpress = false,
    this.examAsap = false,
    this.handlerDrivingSchoolNeithAssociationDate,
    this.handlerDrivingSchoolNeithAmount,
    this.handlerDrivingSchoolNeithAmountDate,
    this.handlerWithDrivings = false,
    this.handlerOnlyDrivings = false,
    this.enrollmentDatetime,
    this.includedBulletins = false,
    this.neithZoneGiftRegistrationDate,
    this.neithZoneGiftRegistrationPhoto,
    this.neithZoneGiftStartingPoints,
    this.neithDeferredPaymentStep,
    this.hasVoucherAsRefund = false,
    this.motorisation,
    this.handlerDrivingSchoolNeith,
    this.neithZoneGift,
    this.neithTutorAssociated,
    this.drivingLicenseTypes = const [],
    this.acceptedTermsVersion,
    this.acceptedPrivacyVersion,
    this.lastConsentUpdate,
    this.entryDatetime,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      password: json['password'] as String?,
      udid: json['udid'] as String?,
      lastLogin: json['last_login'] != null
          ? DateTime.tryParse(json['last_login'] as String)
          : null,
      facebookId: json['facebook_id'] as String?,
      firstName: json['firstname'] as String?,
      surname: json['surname'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'] as String)
          : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      zipCode: json['zip_code'] as String?,
      province: json['provincia'] as String?,
      country: json['country'] as String?,
      latitude: _parseCoordinate(json['latitude']),
      longitude: _parseCoordinate(json['longitude']),
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      school: json['driving_school'] != null
          ? SchoolModel.fromJson(json['driving_school'] as Map<String, dynamic>)
          : null,
      licenseType: _parseLicenseTypeId(json['license_type']),
      registrationDate: json['registration_datetime'] != null
          ? DateTime.tryParse(json['registration_datetime'] as String)
          : null,
      nowDatetime: json['now_datetime'] != null
          ? DateTime.tryParse(json['now_datetime'] as String)
          : null,
      isPlayingCard: json['is_playing_card'] as bool? ?? false,
      isWinnerCard: json['is_winner_card'] as bool? ?? false,
      isGuest: json['is_guest'] as bool? ?? true,
      wasGuest: json['was_guest'] as bool? ?? true,
      isRegistered: json['is_registered'] as bool? ?? true,
      teacherLtDs:
          (json['teacher_lt_ds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      instructorLtDs:
          (json['instructor_lt_ds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      adminDrivingschool:
          (json['admin_drivingschool'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      isAdvActive: json['is_adv_active'] as bool? ?? true,
      isPartnerActive: json['is_partner_active'] as bool? ?? false,
      badges:
          (json['badges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isRetargetingConversion:
          json['is_retargeting_conversion'] as bool? ?? false,
      hasVideoBought: json['has_video_bought'] as bool? ?? false,
      videoState: json['video_state'] as int?,
      hasFirstLesson: json['has_first_lesson'] as bool? ?? false,
      firstLessonDatetime: json['first_lesson_datetime'] != null
          ? DateTime.tryParse(json['first_lesson_datetime'] as String)
          : null,
      acceptedPrivacy: json['accepted_privacy'] as bool? ?? false,
      acceptedMarketing: json['accepted_marketing'] as bool? ?? false,
      isParticipatingContest:
          json['is_participating_contest'] as bool? ?? false,
      hasEbook: json['has_ebook'] as bool? ?? false,
      hasMiniVideoUnlocked: json['has_mini_video_unlocked'] as bool? ?? false,
      hasMiniVideoBasic: json['has_mini_video_basic'] as bool? ?? false,
      hasMiniVideoSilver: json['has_mini_video_silver'] as bool? ?? false,
      hasNeithAIActive: json['has_neith_ai_active'] as bool? ?? false,
      hasNeithDeepeningVideosActive:
          json['has_neith_deepening_videos_active'] as bool? ?? false,
      drivingSchoolNeith: json['driving_school_neith'] as int?,
      alreadySubscribedToDrivingSchool:
          json['already_subscribed_to_driving_school'] as bool? ?? false,
      neithDemoExpiration: json['neith_demo_expiration'] != null
          ? DateTime.tryParse(json['neith_demo_expiration'] as String)
          : null,
      sex: json['sex'] as int?,
      territory: json['territory'] as int?,
      // New fields
      teacherClasses:
          (json['teacher_classes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      instructorClasses:
          (json['instructor_classes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      studentLtDs:
          (json['student_lt_ds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      hasMatrixAccess: json['has_matrix_access'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      isCompleted: json['is_completed'] as bool? ?? false,
      isStaff: json['is_staff'] as bool? ?? false,
      isTutor: json['is_tutor'] as bool? ?? false,
      isAmbassador: json['is_ambassador'] as bool?,
      isArchived: json['is_archived'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isRobot: json['is_robot'] as bool? ?? false,
      isLink: json['is_link'] as bool? ?? false,
      wasLink: json['was_link'] as bool? ?? false,
      hasSchoolRecovery: json['has_school_recovery'] as bool? ?? false,
      hasClassroomAccess: json['has_classroom_access'] as bool? ?? false,
      hasReferral: json['has_referral'] as bool? ?? false,
      isRis: json['is_ris'] as bool? ?? false,
      mailConfirmed: json['mail_confirmed'] as bool? ?? false,
      mailBounced: json['mail_bounced'] as bool? ?? false,
      mailComplaints: json['mail_complaints'] as bool? ?? false,
      statusStudy: json['status_study'] as int?,
      isTeacherNeith: json['is_teacher_neith'] as bool? ?? false,
      zoomUrl: json['zoom_url'] as String?,
      wherebyUrl: json['whereby_url'] as String?,
      amountForLesson: json['amount_for_lesson'] != null
          ? (json['amount_for_lesson'] is int
                ? (json['amount_for_lesson'] as int).toDouble()
                : json['amount_for_lesson'] as double?)
          : null,
      personalEmailTeacherNeith:
          json['personal_email_teacher_neith'] as String?,
      isTeacherExpressPro: json['is_teacher_express_pro'] as bool? ?? false,
      isSuper: json['is_super'] as bool? ?? false,
      adminEverestAccessCount: json['admin_everest_access_count'] as int?,
      startVideosDatetime: json['start_videos_datetime'] != null
          ? DateTime.tryParse(json['start_videos_datetime'] as String)
          : null,
      endVideosDatetime: json['end_videos_datetime'] != null
          ? DateTime.tryParse(json['end_videos_datetime'] as String)
          : null,
      provisionalLicenseExpirationDate:
          json['provisional_license_expiration_date'] != null
          ? DateTime.tryParse(
              json['provisional_license_expiration_date'] as String,
            )
          : null,
      secondEmail: json['second_email'] as String?,
      licenseNumber: json['license_number'] as String?,
      licenseExpirationDate: json['license_expiration_date'] != null
          ? DateTime.tryParse(json['license_expiration_date'] as String)
          : null,
      licenseCqcMerciExpirationDate:
          json['license_cqc_merci_expiration_date'] != null
          ? DateTime.tryParse(
              json['license_cqc_merci_expiration_date'] as String,
            )
          : null,
      licenseCqcPersoneExpirationDate:
          json['license_cqc_persone_expiration_date'] != null
          ? DateTime.tryParse(
              json['license_cqc_persone_expiration_date'] as String,
            )
          : null,
      licenseCapExpirationDate: json['license_cap_expiration_date'] != null
          ? DateTime.tryParse(json['license_cap_expiration_date'] as String)
          : null,
      licenseAdrExpirationDate: json['license_adr_expiration_date'] != null
          ? DateTime.tryParse(json['license_adr_expiration_date'] as String)
          : null,
      licenseMulettoExpirationDate:
          json['license_muletto_expiration_date'] != null
          ? DateTime.tryParse(json['license_muletto_expiration_date'] as String)
          : null,
      licenseGruExpirationDate: json['license_gru_expiration_date'] != null
          ? DateTime.tryParse(json['license_gru_expiration_date'] as String)
          : null,
      huaweiId: json['huawei_id'] as String?,
      appleId: json['apple_id'] as String?,
      contestVictories: json['contest_victories'] as int?,
      miniVideoViews: json['mini_video_views'] as int?,
      isParticipatingAdventCalendar:
          json['is_participating_advent_calendar'] as bool? ?? false,
      neithPhone: json['neith_phone'] as String?,
      isAlmostReadyForExam: json['is_almost_ready_for_exam'] as bool? ?? false,
      isReadyForExam: json['is_ready_for_exam'] as bool? ?? false,
      hasNeithOnlineLessonsActive:
          json['has_neith_online_lessons_active'] as bool? ?? false,
      hasNeithFullActive: json['has_neith_full_active'] as bool? ?? false,
      neithEntryDatetime: json['neith_entry_datetime'] != null
          ? DateTime.tryParse(json['neith_entry_datetime'] as String)
          : null,
      hasNeithDemo: json['has_neith_demo'] as bool? ?? false,
      neithDemoMessagesNumber: json['neith_demo_messages_number'] as int?,
      hasNeithAIActiveBeforeDemo:
          json['has_neith_ai_active_before_demo'] as bool? ?? false,
      demoLiveCounter: json['demo_live_counter'] as int?,
      neithPrivacyAccepted: json['neith_privacy_accepted'] as bool? ?? false,
      neithPrivacyAcceptedDate: json['neith_privacy_accepted_date'] != null
          ? DateTime.tryParse(json['neith_privacy_accepted_date'] as String)
          : null,
      neithAddressInfoUpdated:
          json['neith_address_info_updated'] as bool? ?? false,
      neithAppReviewSent: json['neith_app_review_sent'] as bool? ?? false,
      hasNeithGpt: json['has_neith_gpt'] as bool? ?? false,
      hasNeithGptDemo: json['has_neith_gpt_demo'] as bool? ?? false,
      hasNeithGptDemoExpiration: json['has_neith_gpt_demo_expiration'] != null
          ? DateTime.tryParse(json['has_neith_gpt_demo_expiration'] as String)
          : null,
      isNotDrivingLicenseB: json['is_not_driving_license_b'] as bool? ?? false,
      abTestVersion: json['ab_test_version'] as String?,
      lastEverestLogin: json['last_everest_login'] != null
          ? DateTime.tryParse(json['last_everest_login'] as String)
          : null,
      everestPages: json['everest_pages'] as String?,
      neithDemoFirstMessageSentDate:
          json['neith_demo_first_message_sent_date'] != null
          ? DateTime.tryParse(
              json['neith_demo_first_message_sent_date'] as String,
            )
          : null,
      neithDemoMessageStep: json['neith_demo_message_step'] as int?,
      isNeithCodeUser: json['is_neith_code_user'] as bool? ?? false,
      isNeithBoostCode: json['is_neith_boost_code'] as bool? ?? false,
      isNeithExpress: json['is_neith_express'] as bool? ?? false,
      isNeithExpressPro: json['is_neith_express_pro'] as bool? ?? false,
      isNeithVip: json['is_neith_vip'] as bool? ?? false,
      hasPaidMinimumNeithExpress:
          json['has_paid_minimum_neith_express'] as bool? ?? false,
      examAsap: json['exam_asap'] as bool? ?? false,
      handlerDrivingSchoolNeithAssociationDate:
          json['handler_driving_school_neith_association_date'] != null
          ? DateTime.tryParse(
              json['handler_driving_school_neith_association_date'] as String,
            )
          : null,
      handlerDrivingSchoolNeithAmount:
          json['handler_driving_school_neith_amount'] != null
          ? (json['handler_driving_school_neith_amount'] is int
                ? (json['handler_driving_school_neith_amount'] as int)
                      .toDouble()
                : json['handler_driving_school_neith_amount'] as double?)
          : null,
      handlerDrivingSchoolNeithAmountDate:
          json['handler_driving_school_neith_amount_date'] != null
          ? DateTime.tryParse(
              json['handler_driving_school_neith_amount_date'] as String,
            )
          : null,
      handlerWithDrivings: json['handler_with_drivings'] as bool? ?? false,
      handlerOnlyDrivings: json['handler_only_drivings'] as bool? ?? false,
      enrollmentDatetime: json['enrollment_datetime'] != null
          ? DateTime.tryParse(json['enrollment_datetime'] as String)
          : null,
      includedBulletins: json['included_bulletins'] as bool? ?? false,
      neithZoneGiftRegistrationDate:
          json['neith_zone_gift_registration_date'] != null
          ? DateTime.tryParse(
              json['neith_zone_gift_registration_date'] as String,
            )
          : null,
      neithZoneGiftRegistrationPhoto:
          json['neith_zone_gift_registration_photo'] as String?,
      neithZoneGiftStartingPoints:
          json['neith_zone_gift_starting_points'] as int?,
      neithDeferredPaymentStep: json['neith_deferred_payment_step'] as int?,
      hasVoucherAsRefund: json['has_voucher_as_refund'] as bool? ?? false,
      motorisation: json['motorisation'] as int?,
      handlerDrivingSchoolNeith: json['handler_driving_school_neith'] as int?,
      neithZoneGift: json['neith_zone_gift'] as int?,
      neithTutorAssociated: json['neith_tutor_associated'] as int?,
      drivingLicenseTypes:
          (json['driving_license_types'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      acceptedTermsVersion: json['accepted_terms_version'] as String?,
      acceptedPrivacyVersion: json['accepted_privacy_version'] as String?,
      lastConsentUpdate: json['last_consent_update'] != null
          ? DateTime.tryParse(json['last_consent_update'] as String)
          : null,
      entryDatetime: json['entry_datetime'] != null
          ? DateTime.tryParse(json['entry_datetime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (password != null) 'password': password,
      if (udid != null) 'udid': udid,
      if (lastLogin != null) 'last_login': lastLogin!.toIso8601String(),
      if (facebookId != null) 'facebook_id': facebookId,
      if (firstName != null) 'firstname': firstName,
      if (surname != null) 'surname': surname,
      if (birthDate != null)
        'birth_date': birthDate!.toIso8601String().split('T')[0],
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (zipCode != null) 'zip_code': zipCode,
      if (province != null) 'provincia': province,
      if (country != null) 'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (image != null) 'image': image,
      if (school != null) 'driving_school': school!.toJson(),
      if (licenseType != null) 'license_type': licenseType,
      if (registrationDate != null)
        'registration_datetime': registrationDate!.toIso8601String(),
      if (nowDatetime != null) 'now_datetime': nowDatetime!.toIso8601String(),
      'is_playing_card': isPlayingCard,
      'is_winner_card': isWinnerCard,
      'is_guest': isGuest,
      'was_guest': wasGuest,
      'is_registered': isRegistered,
      'teacher_lt_ds': teacherLtDs,
      'instructor_lt_ds': instructorLtDs,
      'admin_drivingschool': adminDrivingschool,
      'is_adv_active': isAdvActive,
      'is_partner_active': isPartnerActive,
      'badges': badges,
      'is_retargeting_conversion': isRetargetingConversion,
      'has_video_bought': hasVideoBought,
      if (videoState != null) 'video_state': videoState,
      'has_first_lesson': hasFirstLesson,
      if (firstLessonDatetime != null)
        'first_lesson_datetime': firstLessonDatetime!.toIso8601String(),
      'accepted_privacy': acceptedPrivacy,
      'accepted_marketing': acceptedMarketing,
      'is_participating_contest': isParticipatingContest,
      'has_ebook': hasEbook,
      'has_mini_video_unlocked': hasMiniVideoUnlocked,
      'has_mini_video_basic': hasMiniVideoBasic,
      'has_mini_video_silver': hasMiniVideoSilver,
      'has_neith_ai_active': hasNeithAIActive,
      'has_neith_deepening_videos_active': hasNeithDeepeningVideosActive,
      if (drivingSchoolNeith != null)
        'driving_school_neith': drivingSchoolNeith,
      'already_subscribed_to_driving_school': alreadySubscribedToDrivingSchool,
      if (neithDemoExpiration != null)
        'neith_demo_expiration': neithDemoExpiration!.toIso8601String(),
      if (sex != null) 'sex': sex,
      if (territory != null) 'territory': territory,
      // New fields
      'teacher_classes': teacherClasses,
      'instructor_classes': instructorClasses,
      'student_lt_ds': studentLtDs,
      'has_matrix_access': hasMatrixAccess,
      'is_active': isActive,
      'is_completed': isCompleted,
      'is_staff': isStaff,
      'is_tutor': isTutor,
      if (isAmbassador != null) 'is_ambassador': isAmbassador,
      'is_archived': isArchived,
      'is_deleted': isDeleted,
      'is_robot': isRobot,
      'is_link': isLink,
      'was_link': wasLink,
      'has_school_recovery': hasSchoolRecovery,
      'has_classroom_access': hasClassroomAccess,
      'has_referral': hasReferral,
      'is_ris': isRis,
      'mail_confirmed': mailConfirmed,
      'mail_bounced': mailBounced,
      'mail_complaints': mailComplaints,
      if (statusStudy != null) 'status_study': statusStudy,
      'is_teacher_neith': isTeacherNeith,
      if (zoomUrl != null) 'zoom_url': zoomUrl,
      if (wherebyUrl != null) 'whereby_url': wherebyUrl,
      if (amountForLesson != null) 'amount_for_lesson': amountForLesson,
      if (personalEmailTeacherNeith != null)
        'personal_email_teacher_neith': personalEmailTeacherNeith,
      'is_teacher_express_pro': isTeacherExpressPro,
      'is_super': isSuper,
      if (adminEverestAccessCount != null)
        'admin_everest_access_count': adminEverestAccessCount,
      if (startVideosDatetime != null)
        'start_videos_datetime': startVideosDatetime!.toIso8601String(),
      if (endVideosDatetime != null)
        'end_videos_datetime': endVideosDatetime!.toIso8601String(),
      if (provisionalLicenseExpirationDate != null)
        'provisional_license_expiration_date': provisionalLicenseExpirationDate!
            .toIso8601String()
            .split('T')[0],
      if (secondEmail != null) 'second_email': secondEmail,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (licenseExpirationDate != null)
        'license_expiration_date': licenseExpirationDate!
            .toIso8601String()
            .split('T')[0],
      if (licenseCqcMerciExpirationDate != null)
        'license_cqc_merci_expiration_date': licenseCqcMerciExpirationDate!
            .toIso8601String()
            .split('T')[0],
      if (licenseCqcPersoneExpirationDate != null)
        'license_cqc_persone_expiration_date': licenseCqcPersoneExpirationDate!
            .toIso8601String()
            .split('T')[0],
      if (licenseCapExpirationDate != null)
        'license_cap_expiration_date': licenseCapExpirationDate!
            .toIso8601String()
            .split('T')[0],
      if (licenseAdrExpirationDate != null)
        'license_adr_expiration_date': licenseAdrExpirationDate!
            .toIso8601String()
            .split('T')[0],
      if (licenseMulettoExpirationDate != null)
        'license_muletto_expiration_date': licenseMulettoExpirationDate!
            .toIso8601String()
            .split('T')[0],
      if (licenseGruExpirationDate != null)
        'license_gru_expiration_date': licenseGruExpirationDate!
            .toIso8601String()
            .split('T')[0],
      if (huaweiId != null) 'huawei_id': huaweiId,
      if (appleId != null) 'apple_id': appleId,
      if (contestVictories != null) 'contest_victories': contestVictories,
      if (miniVideoViews != null) 'mini_video_views': miniVideoViews,
      'is_participating_advent_calendar': isParticipatingAdventCalendar,
      if (neithPhone != null) 'neith_phone': neithPhone,
      'is_almost_ready_for_exam': isAlmostReadyForExam,
      'is_ready_for_exam': isReadyForExam,
      'has_neith_online_lessons_active': hasNeithOnlineLessonsActive,
      'has_neith_full_active': hasNeithFullActive,
      if (neithEntryDatetime != null)
        'neith_entry_datetime': neithEntryDatetime!.toIso8601String(),
      'has_neith_demo': hasNeithDemo,
      if (neithDemoMessagesNumber != null)
        'neith_demo_messages_number': neithDemoMessagesNumber,
      'has_neith_ai_active_before_demo': hasNeithAIActiveBeforeDemo,
      if (demoLiveCounter != null) 'demo_live_counter': demoLiveCounter,
      'neith_privacy_accepted': neithPrivacyAccepted,
      if (neithPrivacyAcceptedDate != null)
        'neith_privacy_accepted_date': neithPrivacyAcceptedDate!
            .toIso8601String(),
      'neith_address_info_updated': neithAddressInfoUpdated,
      'neith_app_review_sent': neithAppReviewSent,
      'has_neith_gpt': hasNeithGpt,
      'has_neith_gpt_demo': hasNeithGptDemo,
      if (hasNeithGptDemoExpiration != null)
        'has_neith_gpt_demo_expiration': hasNeithGptDemoExpiration!
            .toIso8601String(),
      'is_not_driving_license_b': isNotDrivingLicenseB,
      if (abTestVersion != null) 'ab_test_version': abTestVersion,
      if (lastEverestLogin != null)
        'last_everest_login': lastEverestLogin!.toIso8601String(),
      if (everestPages != null) 'everest_pages': everestPages,
      if (neithDemoFirstMessageSentDate != null)
        'neith_demo_first_message_sent_date': neithDemoFirstMessageSentDate!
            .toIso8601String(),
      if (neithDemoMessageStep != null)
        'neith_demo_message_step': neithDemoMessageStep,
      'is_neith_code_user': isNeithCodeUser,
      'is_neith_boost_code': isNeithBoostCode,
      'is_neith_express': isNeithExpress,
      'is_neith_express_pro': isNeithExpressPro,
      'is_neith_vip': isNeithVip,
      'has_paid_minimum_neith_express': hasPaidMinimumNeithExpress,
      'exam_asap': examAsap,
      if (handlerDrivingSchoolNeithAssociationDate != null)
        'handler_driving_school_neith_association_date':
            handlerDrivingSchoolNeithAssociationDate!.toIso8601String(),
      if (handlerDrivingSchoolNeithAmount != null)
        'handler_driving_school_neith_amount': handlerDrivingSchoolNeithAmount,
      if (handlerDrivingSchoolNeithAmountDate != null)
        'handler_driving_school_neith_amount_date':
            handlerDrivingSchoolNeithAmountDate!.toIso8601String(),
      'handler_with_drivings': handlerWithDrivings,
      'handler_only_drivings': handlerOnlyDrivings,
      if (enrollmentDatetime != null)
        'enrollment_datetime': enrollmentDatetime!.toIso8601String(),
      'included_bulletins': includedBulletins,
      if (neithZoneGiftRegistrationDate != null)
        'neith_zone_gift_registration_date': neithZoneGiftRegistrationDate!
            .toIso8601String(),
      if (neithZoneGiftRegistrationPhoto != null)
        'neith_zone_gift_registration_photo': neithZoneGiftRegistrationPhoto,
      if (neithZoneGiftStartingPoints != null)
        'neith_zone_gift_starting_points': neithZoneGiftStartingPoints,
      if (neithDeferredPaymentStep != null)
        'neith_deferred_payment_step': neithDeferredPaymentStep,
      'has_voucher_as_refund': hasVoucherAsRefund,
      if (motorisation != null) 'motorisation': motorisation,
      if (handlerDrivingSchoolNeith != null)
        'handler_driving_school_neith': handlerDrivingSchoolNeith,
      if (neithZoneGift != null) 'neith_zone_gift': neithZoneGift,
      if (neithTutorAssociated != null)
        'neith_tutor_associated': neithTutorAssociated,
      'driving_license_types': drivingLicenseTypes,
      if (acceptedTermsVersion != null)
        'accepted_terms_version': acceptedTermsVersion,
      if (acceptedPrivacyVersion != null)
        'accepted_privacy_version': acceptedPrivacyVersion,
      if (lastConsentUpdate != null)
        'last_consent_update': lastConsentUpdate!.toIso8601String(),
      if (entryDatetime != null)
        'entry_datetime': entryDatetime!.toIso8601String(),
    };
  }

  factory UserModel.empty() {
    return const UserModel(id: 0, email: "");
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    String? udid,
    DateTime? lastLogin,
    String? facebookId,
    String? firstName,
    String? surname,
    DateTime? birthDate,
    String? address,
    String? city,
    String? zipCode,
    String? province,
    String? country,
    double? latitude,
    double? longitude,
    String? phone,
    String? image,
    SchoolModel? school,
    int? licenseType,
    DateTime? registrationDate,
    DateTime? nowDatetime,
    bool? isPlayingCard,
    bool? isWinnerCard,
    bool? isGuest,
    bool? wasGuest,
    bool? isRegistered,
    List<int>? teacherLtDs,
    List<int>? instructorLtDs,
    List<int>? adminDrivingschool,
    bool? isAdvActive,
    bool? isPartnerActive,
    List<String>? badges,
    bool? isRetargetingConversion,
    bool? hasVideoBought,
    int? videoState,
    bool? hasFirstLesson,
    DateTime? firstLessonDatetime,
    bool? acceptedPrivacy,
    bool? acceptedMarketing,
    bool? isParticipatingContest,
    bool? hasEbook,
    bool? hasMiniVideoUnlocked,
    bool? hasMiniVideoBasic,
    bool? hasMiniVideoSilver,
    bool? hasNeithAIActive,
    bool? hasNeithDeepeningVideosActive,
    int? drivingSchoolNeith,
    bool? alreadySubscribedToDrivingSchool,
    DateTime? neithDemoExpiration,
    int? sex,
    int? territory,
    // New fields
    List<int>? teacherClasses,
    List<int>? instructorClasses,
    List<int>? studentLtDs,
    bool? hasMatrixAccess,
    bool? isActive,
    bool? isCompleted,
    bool? isStaff,
    bool? isTutor,
    bool? isAmbassador,
    bool? isArchived,
    bool? isDeleted,
    bool? isRobot,
    bool? isLink,
    bool? wasLink,
    bool? hasSchoolRecovery,
    bool? hasClassroomAccess,
    bool? hasReferral,
    bool? isRis,
    bool? mailConfirmed,
    bool? mailBounced,
    bool? mailComplaints,
    int? statusStudy,
    bool? isTeacherNeith,
    String? zoomUrl,
    String? wherebyUrl,
    double? amountForLesson,
    String? personalEmailTeacherNeith,
    bool? isTeacherExpressPro,
    bool? isSuper,
    int? adminEverestAccessCount,
    DateTime? startVideosDatetime,
    DateTime? endVideosDatetime,
    DateTime? provisionalLicenseExpirationDate,
    String? secondEmail,
    String? licenseNumber,
    DateTime? licenseExpirationDate,
    DateTime? licenseCqcMerciExpirationDate,
    DateTime? licenseCqcPersoneExpirationDate,
    DateTime? licenseCapExpirationDate,
    DateTime? licenseAdrExpirationDate,
    DateTime? licenseMulettoExpirationDate,
    DateTime? licenseGruExpirationDate,
    String? huaweiId,
    String? appleId,
    int? contestVictories,
    int? miniVideoViews,
    bool? isParticipatingAdventCalendar,
    String? neithPhone,
    bool? isAlmostReadyForExam,
    bool? isReadyForExam,
    bool? hasNeithOnlineLessonsActive,
    bool? hasNeithFullActive,
    DateTime? neithEntryDatetime,
    bool? hasNeithDemo,
    int? neithDemoMessagesNumber,
    bool? hasNeithAIActiveBeforeDemo,
    int? demoLiveCounter,
    bool? neithPrivacyAccepted,
    DateTime? neithPrivacyAcceptedDate,
    bool? neithAddressInfoUpdated,
    bool? neithAppReviewSent,
    bool? hasNeithGpt,
    bool? hasNeithGptDemo,
    DateTime? hasNeithGptDemoExpiration,
    bool? isNotDrivingLicenseB,
    String? abTestVersion,
    DateTime? lastEverestLogin,
    String? everestPages,
    DateTime? neithDemoFirstMessageSentDate,
    int? neithDemoMessageStep,
    bool? isNeithCodeUser,
    bool? isNeithBoostCode,
    bool? isNeithExpress,
    bool? isNeithExpressPro,
    bool? isNeithVip,
    bool? hasPaidMinimumNeithExpress,
    bool? examAsap,
    DateTime? handlerDrivingSchoolNeithAssociationDate,
    double? handlerDrivingSchoolNeithAmount,
    DateTime? handlerDrivingSchoolNeithAmountDate,
    bool? handlerWithDrivings,
    bool? handlerOnlyDrivings,
    DateTime? enrollmentDatetime,
    bool? includedBulletins,
    DateTime? neithZoneGiftRegistrationDate,
    String? neithZoneGiftRegistrationPhoto,
    int? neithZoneGiftStartingPoints,
    int? neithDeferredPaymentStep,
    bool? hasVoucherAsRefund,
    int? motorisation,
    int? handlerDrivingSchoolNeith,
    int? neithZoneGift,
    int? neithTutorAssociated,
    List<int>? drivingLicenseTypes,
    String? acceptedTermsVersion,
    String? acceptedPrivacyVersion,
    DateTime? lastConsentUpdate,
    DateTime? entryDatetime,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      udid: udid ?? this.udid,
      lastLogin: lastLogin ?? this.lastLogin,
      facebookId: facebookId ?? this.facebookId,
      firstName: firstName ?? this.firstName,
      surname: surname ?? this.surname,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      province: province ?? this.province,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      school: school ?? this.school,
      licenseType: licenseType ?? this.licenseType,
      registrationDate: registrationDate ?? this.registrationDate,
      nowDatetime: nowDatetime ?? this.nowDatetime,
      isPlayingCard: isPlayingCard ?? this.isPlayingCard,
      isWinnerCard: isWinnerCard ?? this.isWinnerCard,
      isGuest: isGuest ?? this.isGuest,
      wasGuest: wasGuest ?? this.wasGuest,
      isRegistered: isRegistered ?? this.isRegistered,
      teacherLtDs: teacherLtDs ?? this.teacherLtDs,
      instructorLtDs: instructorLtDs ?? this.instructorLtDs,
      adminDrivingschool: adminDrivingschool ?? this.adminDrivingschool,
      isAdvActive: isAdvActive ?? this.isAdvActive,
      isPartnerActive: isPartnerActive ?? this.isPartnerActive,
      badges: badges ?? this.badges,
      isRetargetingConversion:
          isRetargetingConversion ?? this.isRetargetingConversion,
      hasVideoBought: hasVideoBought ?? this.hasVideoBought,
      videoState: videoState ?? this.videoState,
      hasFirstLesson: hasFirstLesson ?? this.hasFirstLesson,
      firstLessonDatetime: firstLessonDatetime ?? this.firstLessonDatetime,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
      acceptedMarketing: acceptedMarketing ?? this.acceptedMarketing,
      isParticipatingContest:
          isParticipatingContest ?? this.isParticipatingContest,
      hasEbook: hasEbook ?? this.hasEbook,
      hasMiniVideoUnlocked: hasMiniVideoUnlocked ?? this.hasMiniVideoUnlocked,
      hasMiniVideoBasic: hasMiniVideoBasic ?? this.hasMiniVideoBasic,
      hasMiniVideoSilver: hasMiniVideoSilver ?? this.hasMiniVideoSilver,
      hasNeithAIActive: hasNeithAIActive ?? this.hasNeithAIActive,
      hasNeithDeepeningVideosActive:
          hasNeithDeepeningVideosActive ?? this.hasNeithDeepeningVideosActive,
      drivingSchoolNeith: drivingSchoolNeith ?? this.drivingSchoolNeith,
      alreadySubscribedToDrivingSchool:
          alreadySubscribedToDrivingSchool ??
          this.alreadySubscribedToDrivingSchool,
      neithDemoExpiration: neithDemoExpiration ?? this.neithDemoExpiration,
      sex: sex ?? this.sex,
      territory: territory ?? this.territory,
      // New fields
      teacherClasses: teacherClasses ?? this.teacherClasses,
      instructorClasses: instructorClasses ?? this.instructorClasses,
      studentLtDs: studentLtDs ?? this.studentLtDs,
      hasMatrixAccess: hasMatrixAccess ?? this.hasMatrixAccess,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      isStaff: isStaff ?? this.isStaff,
      isTutor: isTutor ?? this.isTutor,
      isAmbassador: isAmbassador ?? this.isAmbassador,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      isRobot: isRobot ?? this.isRobot,
      isLink: isLink ?? this.isLink,
      wasLink: wasLink ?? this.wasLink,
      hasSchoolRecovery: hasSchoolRecovery ?? this.hasSchoolRecovery,
      hasClassroomAccess: hasClassroomAccess ?? this.hasClassroomAccess,
      hasReferral: hasReferral ?? this.hasReferral,
      isRis: isRis ?? this.isRis,
      mailConfirmed: mailConfirmed ?? this.mailConfirmed,
      mailBounced: mailBounced ?? this.mailBounced,
      mailComplaints: mailComplaints ?? this.mailComplaints,
      statusStudy: statusStudy ?? this.statusStudy,
      isTeacherNeith: isTeacherNeith ?? this.isTeacherNeith,
      zoomUrl: zoomUrl ?? this.zoomUrl,
      wherebyUrl: wherebyUrl ?? this.wherebyUrl,
      amountForLesson: amountForLesson ?? this.amountForLesson,
      personalEmailTeacherNeith:
          personalEmailTeacherNeith ?? this.personalEmailTeacherNeith,
      isTeacherExpressPro: isTeacherExpressPro ?? this.isTeacherExpressPro,
      isSuper: isSuper ?? this.isSuper,
      adminEverestAccessCount:
          adminEverestAccessCount ?? this.adminEverestAccessCount,
      startVideosDatetime: startVideosDatetime ?? this.startVideosDatetime,
      endVideosDatetime: endVideosDatetime ?? this.endVideosDatetime,
      provisionalLicenseExpirationDate:
          provisionalLicenseExpirationDate ??
          this.provisionalLicenseExpirationDate,
      secondEmail: secondEmail ?? this.secondEmail,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpirationDate:
          licenseExpirationDate ?? this.licenseExpirationDate,
      licenseCqcMerciExpirationDate:
          licenseCqcMerciExpirationDate ?? this.licenseCqcMerciExpirationDate,
      licenseCqcPersoneExpirationDate:
          licenseCqcPersoneExpirationDate ??
          this.licenseCqcPersoneExpirationDate,
      licenseCapExpirationDate:
          licenseCapExpirationDate ?? this.licenseCapExpirationDate,
      licenseAdrExpirationDate:
          licenseAdrExpirationDate ?? this.licenseAdrExpirationDate,
      licenseMulettoExpirationDate:
          licenseMulettoExpirationDate ?? this.licenseMulettoExpirationDate,
      licenseGruExpirationDate:
          licenseGruExpirationDate ?? this.licenseGruExpirationDate,
      huaweiId: huaweiId ?? this.huaweiId,
      appleId: appleId ?? this.appleId,
      contestVictories: contestVictories ?? this.contestVictories,
      miniVideoViews: miniVideoViews ?? this.miniVideoViews,
      isParticipatingAdventCalendar:
          isParticipatingAdventCalendar ?? this.isParticipatingAdventCalendar,
      neithPhone: neithPhone ?? this.neithPhone,
      isAlmostReadyForExam: isAlmostReadyForExam ?? this.isAlmostReadyForExam,
      isReadyForExam: isReadyForExam ?? this.isReadyForExam,
      hasNeithOnlineLessonsActive:
          hasNeithOnlineLessonsActive ?? this.hasNeithOnlineLessonsActive,
      hasNeithFullActive: hasNeithFullActive ?? this.hasNeithFullActive,
      neithEntryDatetime: neithEntryDatetime ?? this.neithEntryDatetime,
      hasNeithDemo: hasNeithDemo ?? this.hasNeithDemo,
      neithDemoMessagesNumber:
          neithDemoMessagesNumber ?? this.neithDemoMessagesNumber,
      hasNeithAIActiveBeforeDemo:
          hasNeithAIActiveBeforeDemo ?? this.hasNeithAIActiveBeforeDemo,
      demoLiveCounter: demoLiveCounter ?? this.demoLiveCounter,
      neithPrivacyAccepted: neithPrivacyAccepted ?? this.neithPrivacyAccepted,
      neithPrivacyAcceptedDate:
          neithPrivacyAcceptedDate ?? this.neithPrivacyAcceptedDate,
      neithAddressInfoUpdated:
          neithAddressInfoUpdated ?? this.neithAddressInfoUpdated,
      neithAppReviewSent: neithAppReviewSent ?? this.neithAppReviewSent,
      hasNeithGpt: hasNeithGpt ?? this.hasNeithGpt,
      hasNeithGptDemo: hasNeithGptDemo ?? this.hasNeithGptDemo,
      hasNeithGptDemoExpiration:
          hasNeithGptDemoExpiration ?? this.hasNeithGptDemoExpiration,
      isNotDrivingLicenseB: isNotDrivingLicenseB ?? this.isNotDrivingLicenseB,
      abTestVersion: abTestVersion ?? this.abTestVersion,
      lastEverestLogin: lastEverestLogin ?? this.lastEverestLogin,
      everestPages: everestPages ?? this.everestPages,
      neithDemoFirstMessageSentDate:
          neithDemoFirstMessageSentDate ?? this.neithDemoFirstMessageSentDate,
      neithDemoMessageStep: neithDemoMessageStep ?? this.neithDemoMessageStep,
      isNeithCodeUser: isNeithCodeUser ?? this.isNeithCodeUser,
      isNeithBoostCode: isNeithBoostCode ?? this.isNeithBoostCode,
      isNeithExpress: isNeithExpress ?? this.isNeithExpress,
      isNeithExpressPro: isNeithExpressPro ?? this.isNeithExpressPro,
      isNeithVip: isNeithVip ?? this.isNeithVip,
      hasPaidMinimumNeithExpress:
          hasPaidMinimumNeithExpress ?? this.hasPaidMinimumNeithExpress,
      examAsap: examAsap ?? this.examAsap,
      handlerDrivingSchoolNeithAssociationDate:
          handlerDrivingSchoolNeithAssociationDate ??
          this.handlerDrivingSchoolNeithAssociationDate,
      handlerDrivingSchoolNeithAmount:
          handlerDrivingSchoolNeithAmount ??
          this.handlerDrivingSchoolNeithAmount,
      handlerDrivingSchoolNeithAmountDate:
          handlerDrivingSchoolNeithAmountDate ??
          this.handlerDrivingSchoolNeithAmountDate,
      handlerWithDrivings: handlerWithDrivings ?? this.handlerWithDrivings,
      handlerOnlyDrivings: handlerOnlyDrivings ?? this.handlerOnlyDrivings,
      enrollmentDatetime: enrollmentDatetime ?? this.enrollmentDatetime,
      includedBulletins: includedBulletins ?? this.includedBulletins,
      neithZoneGiftRegistrationDate:
          neithZoneGiftRegistrationDate ?? this.neithZoneGiftRegistrationDate,
      neithZoneGiftRegistrationPhoto:
          neithZoneGiftRegistrationPhoto ?? this.neithZoneGiftRegistrationPhoto,
      neithZoneGiftStartingPoints:
          neithZoneGiftStartingPoints ?? this.neithZoneGiftStartingPoints,
      neithDeferredPaymentStep:
          neithDeferredPaymentStep ?? this.neithDeferredPaymentStep,
      hasVoucherAsRefund: hasVoucherAsRefund ?? this.hasVoucherAsRefund,
      motorisation: motorisation ?? this.motorisation,
      handlerDrivingSchoolNeith:
          handlerDrivingSchoolNeith ?? this.handlerDrivingSchoolNeith,
      neithZoneGift: neithZoneGift ?? this.neithZoneGift,
      neithTutorAssociated: neithTutorAssociated ?? this.neithTutorAssociated,
      drivingLicenseTypes: drivingLicenseTypes ?? this.drivingLicenseTypes,
      acceptedTermsVersion: acceptedTermsVersion ?? this.acceptedTermsVersion,
      acceptedPrivacyVersion:
          acceptedPrivacyVersion ?? this.acceptedPrivacyVersion,
      lastConsentUpdate: lastConsentUpdate ?? this.lastConsentUpdate,
      entryDatetime: entryDatetime ?? this.entryDatetime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => Object.hash(id, email);

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, fullName: $fullName, isGuest: $isGuest, udid: $udid)';

  /// Helper method to parse coordinates from either string or number
  /// Treats 0.0, "0.0", "0.00000000", null, and empty strings as invalid (returns null)
  static double? _parseCoordinate(dynamic value) {
    if (value == null) return null;

    double? coordinate;

    if (value is num) {
      coordinate = value.toDouble();
    } else if (value is String) {
      if (value.isEmpty) return null;
      coordinate = double.tryParse(value);
    } else {
      return null;
    }

    // Treat 0.0 as invalid coordinate (likely means no location set)
    return coordinate == null || coordinate == 0.0 ? null : coordinate;
  }

  /// Helper method to parse license_type from either int or Map
  /// If it's an int, return it directly
  /// If it's a Map (LicenseTypeModel JSON), extract the 'id' field
  /// Otherwise return null
  static int? _parseLicenseTypeId(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    } else if (value is Map<String, dynamic>) {
      return value['id'] as int?;
    }

    return null;
  }
}
