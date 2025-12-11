import 'package:dio/dio.dart' hide Headers;
import 'package:who_mobile_project/general/models/redvertising/redvertising_campaign.dart';
import 'package:retrofit/retrofit.dart';

part 'redvertising_client.g.dart';

/// Redvertising API client for advertising campaigns
/// Uses separate base URL: https://redvertising.reddoak.com
/// Matches iOS implementation from QuizPatente-iOS/QuizPatentePlus/Routers/RedvertisingRouter.swift
@RestApi(baseUrl: "")
abstract class RedvertisingClient {
  factory RedvertisingClient(Dio dio, {String? baseUrl}) = _RedvertisingClient;

  /// Get advertising campaigns
  /// Matches iOS: RedvertisingRouter.getCampaigns
  /// GET /api/campaign/
  /// Query params:
  ///   - application: App ID (required)
  ///   - tag: "zeropensieri" for Zero Pensieri campaigns (optional)
  ///   - driving_school: Driving school ID for Zero Pensieri filtering (optional)
  @GET("/campaign/")
  Future<List<RedvertisingCampaign>> getCampaigns({
    @Query("application") required String applicationId,
    @Query("tag") String? tag,
    @Query("driving_school") int? drivingSchoolId,
  });

  /// Get specific advertising by campaign ID
  /// Matches iOS: RedvertisingRouter.getAdvertising
  /// GET /api/advertising/
  @GET("/advertising/")
  @DioResponseType(ResponseType.json)
  Future<HttpResponse<dynamic>> getAdvertising(
    @Query("campaign") int campaignId,
  );

  /// Update advertising statistics (impressions and clicks)
  /// Matches iOS: RedvertisingRouter.updateAdvertising (JSONEncoding, NOT FormUrlEncoded)
  /// POST /api/advertising-statistic/update_statistics/
  /// Body (JSON):
  ///   - campaign: Campaign ID
  ///   - content_type: 0 for impression (seen), 1 for click
  @POST("/advertising-statistic/update_statistics/")
  @DioResponseType(ResponseType.json)
  Future<HttpResponse<dynamic>> updateAdvertisingStatistics({
    @Body() required Map<String, dynamic> body,
  });
}
