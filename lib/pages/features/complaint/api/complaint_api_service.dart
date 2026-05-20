import 'package:dio/dio.dart';
import 'package:mikrotic_customer/core/networking/api_constans.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_list_response_model.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_request_model.dart';
import 'package:mikrotic_customer/pages/features/complaint/model/complaint_response_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'complaint_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ComplaintApiService {
  factory ComplaintApiService(Dio dio, {String baseUrl}) = _ComplaintApiService;

  @POST(ApiConstants.complaint)
  Future<ComplaintResponseModel> addComplaint(
    @Body() ComplaintRequestModel request,
  );
  @GET(ApiConstants.complaint)
  Future<ComplaintListResponseModel> getComplaints();
  @DELETE(ApiConstants.complaintById)
  Future<ComplaintResponseModel> deleteComplaint(@Path('id') String id);
  @PATCH(ApiConstants.complaintById)
  Future<ComplaintResponseModel> updateComplaint(
    @Path('id') String id,
    @Body() ComplaintRequestModel request,
  );
}
