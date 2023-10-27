import 'package:graphql/client.dart';

class Queries {
  static final appAvailability = gql(r'''
      query GetAppUpdateAvailability($input: GetAppUpdateAvailabilityInput!) {
        appUpdateAvailability(input: $input) {
          state
          url
        }
      }
  ''');

  static final resourceCategory = gql(r'''
    query ResoureCategory($id: ID!) {
      resourceCategory(id: $id) {
        id
        name
        image
        alternateImage
        resources {
          id
          title
          summary
          url
          image
          alternateImageUrl
        }
      }
    }
  ''');

  static final resourceFeed = gql(r'''
    query ResourceFeed() {
      resourceCategories {
        id
        name
        image
        alternateImage
        resourcesCount
      }
      popularCategory {
        id
        name
        resourcesCount
        resources {
          id
          title
          summary
          image
          url
          alternateImageUrl
        }
      }
    }
  ''');
}
