import 'package:fostershare/core/models/data/page_info/page_info.dart';
import 'package:fostershare/core/models/data/support_service/support_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_support_services_response.g.dart';

@JsonSerializable(createToJson: false)
class GetSupportServicesResponse {
  final List<SupportService> items;
  final PageInfo pageInfo;

  const GetSupportServicesResponse({
    this.items,
    this.pageInfo,
  });

  factory GetSupportServicesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSupportServicesResponseFromJson(json);
}
