import 'package:fostershare/core/models/input/pagination_input/pagination_input.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_support_services_input.g.dart';

@JsonSerializable(createFactory: false)
class GetSupportServicesInput {
  final PaginationInput pagination;
  final String search;

  const GetSupportServicesInput({@required this.pagination, this.search})
      : assert(pagination != null);

  void toJson() => _$GetSupportServicesInputToJson(this);
}
