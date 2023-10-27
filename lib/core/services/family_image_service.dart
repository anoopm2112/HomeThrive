import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/family_image/family_image.dart';
import 'package:fostershare/core/models/input/create_family_image_input/create_family_image_input.dart';
import 'package:fostershare/core/models/input/get_family_images_input/get_family_images_input.dart';
import 'package:fostershare/core/models/response/get_family_images_response/get_family_images_response.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:graphql/client.dart';

class FamilyImageService {
  final _authGraphQLService = locator<AuthGraphQLService>();

  Future<GetFamilyImagesResponse> familyImages(
      GetFamilyImagesInput input) async {
    final QueryResult result = await _authGraphQLService.familyImages(input);
    var response =
        GetFamilyImagesResponse.fromJson(result.data["familyImages"]);
    return response;
  }

  Future<FamilyImage> createFamilyImage(CreateFamilyImageInput input) async {
    final QueryResult result =
        await _authGraphQLService.createFamilyImage(input);
    var response = FamilyImage.fromJson(result.data["createFamilyImage"]);
    return response;
  }
}
