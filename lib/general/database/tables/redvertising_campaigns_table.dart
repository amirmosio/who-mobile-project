import 'package:drift/drift.dart';

/// Redvertising advertising campaigns table
/// Matches iOS CoreData: RedvertisingCampaign entity
/// Reference: QuizPatente-iOS/QuizPatentePlus/Model/RedvertisingCampaign+CoreDataProperties.swift
@DataClassName('RedvertisingCampaignEntity')
class RedvertisingCampaigns extends Table {
  // Primary key
  IntColumn get id => integer()();

  // Campaign metadata
  TextColumn get title => text()();
  TextColumn get descrizione =>
      text()(); // "description" in iOS (nameExceptions mapping)

  // Display configuration
  IntColumn get viewForUser => integer().named('view_for_user')();
  IntColumn get secondForSkip => integer().named('second_for_skip')();

  // Banner URLs
  TextColumn get banner16 => text().named('banner_16')();
  TextColumn get banner21 => text().named('banner_21')();

  // Target and location
  TextColumn get url => text()();
  TextColumn get latitude => text()();
  TextColumn get longitude => text()();
  TextColumn get radius => text()();

  // Campaign controls
  RealColumn get fillRate => real().named('fill_rate')();
  BoolColumn get isActive => boolean().named('is_active')();
  DateTimeColumn get startDatetime => dateTime().named('start_datetime')();

  // Local tracking (iOS: displayed property)
  IntColumn get displayed => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Redvertising advertising image sets (for Zero Pensieri campaigns)
/// Matches iOS CoreData: RedvertisingImageSet entity
/// Reference: QuizPatente-iOS/QuizPatentePlus/Model/RedvertisingImageSet+CoreDataProperties.swift
@DataClassName('RedvertisingImageSetEntity')
class RedvertisingImageSets extends Table {
  // Primary key
  IntColumn get id => integer()();

  // Foreign key to campaign
  IntColumn get campaignId => integer().named('campaign_id')();

  // Banner URLs for different device types
  TextColumn get banner16 => text().named('banner_16')();
  TextColumn get banner21 => text().named('banner_21')();

  // Tag format: "DS{drivingSchoolId}" (e.g., "DS123")
  TextColumn get tag => text()();

  @override
  Set<Column> get primaryKey => {id};
}
