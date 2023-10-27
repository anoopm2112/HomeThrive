import 'package:fostershare/core/services/graphql/common/agql.dart';
import 'package:graphql/client.dart';

class AuthQueries {
  static final childLog = agql(
    document: r'''
      query ChildLog($input: GetChildLogInput!) {
        childLog(input: $input) {
          id
          date
          dayRating
          dayRatingComments
          childMoodRating
          childMoodComments
          parentMoodRating
          parentMoodComments
          familyVisit
          familyVisitComments
          behavioralIssues
          behavioralIssuesComments
          medicationChange
          medicationChangeComments
          child {
            id
            firstName
            lastName
            nickName
            imageURL
            dateOfBirth
          }
          notes {
            id
            createdAt
            text
          }
        }
      }
    ''',
  );

  static final children = agql(
    document: r'''
      query Children {
        children {
          id
          firstName
          lastName
          dateOfBirth
          imageURL
          logsCount
          agentName
          nickName
          recentLogs {
            id
            date
            childMoodRating
          }
        }
      }
    ''',
  );

  static final childrenLogs = agql(
    document: r'''
      query ChildrenLogs($input: GetChildrenLogsInput!) {
        childrenLogs(input: $input) {
          items {
            id
            date
            child {
              id
              firstName
              lastName
              nickName
              imageURL
              dateOfBirth
            }
          }
          pageInfo {
            cursor
            hasNextPage
            count
          }
        }
      }
    ''',
  );

  static final childrenSummary = agql(
    document: r'''
      query Events($input: GetChildrenLogsInput!) {
        children {
          id
          firstName
          lastName
          nickName
          dateOfBirth
          imageURL
        }
        logs(input: $input) {
          items {
            events {
              id
              createdAt
              updatedAt
              title
              description
              venue
              startsAt
              endsAt
              eventType
            }
            childLog {
              id
              date
              child {
                id
                firstName
                lastName
                nickName
                imageURL
                dateOfBirth
              }
            }
            recreationLog {
              id
              createdAt
              child {
                id
                firstName
                lastName
                nickName
                imageURL
                dateOfBirth
              }
            }
            medLog {
              id
              createdAt
              isSubmitted
              signingStatus
              canSign  
              month
              year
              documentUrl
              entries{
                id
                dateTime
                isFailure
                given
                failureDescription
                enteredBy
                notesCount
                medication {
                  id
                  medicationName
                  dosage
                  reason
                  notes{
                    id
                    content
                  }
                }
              }           
              child {
                id
                firstName
                lastName
                nickName
                imageURL
                dateOfBirth
              }
            }
          }
        }
      }
    ''',
  );

  static final event = agql(
    document: r'''
      query Event($input: GetEventInput!) {
        event(input: $input) {
          id
          title
          description
          venue
          address
          image
          latitude
          longitude
          startsAt
          endsAt
          eventType
          status
        }
      }
    ''',
  );

  static final events = gql(r'''
    query Events($input: GetEventsInput!) {
      events(input: $input) {
        id
        title
        startsAt
        endsAt
        eventType
        venue
      }
    }
  ''');

  static final messages = agql(
    document: r'''
      query Messages($input: GetMessagesInput!) {
        messages(input: $input) {
          items {
            id
            createdAt
            title
            body
            status
          }
          pageInfo {
            cursor
            hasNextPage
            count
          }
        }
      }
    ''',
  );

  static final profile = gql(r'''
    query Profile {
      family {
        id
        address
        email
        licenseNumber
        occupation
        phoneNumber
        primaryLanguage
        zipCode
        firstName
        lastName
        isWeekly
        secondaryParents {
          id
          firstName
          lastName
          email
          phoneNumber
          occupation
        }
      }
    }
  ''');

  static final resourceFeed = gql(r'''
    query ResourceFeed {
      resourceCategories {
        id
        name
        image
        alternateImage
        resourcesCount
      }
      localResources {
        id
        title
        summary
        image
        url
        alternateImageUrl
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

  static final familyImages = gql(r'''
    query FamilyImages($input: GetFamilyImagesInput!) {
      familyImages(input: $input) {
        items {
          id
          url
          name
          file
        }
        pageInfo {
          cursor
          hasNextPage
          count
        }
      }
    }
  ''');

  static final supportServices = gql(r'''
    query SupportServices($input: GetSupportServicesInput!) {
      supportServices(input: $input) {
        items {
          id
          name
          description
        }
        pageInfo {
          cursor
          hasNextPage
          count
        }
      }
    }
  ''');

  static final supportService = gql(r'''
    query SupportService($input: GetSupportServiceInput!) {
      supportService(input: $input) {
        id
        name
        description
        email
        phoneNumber
        website
      }
    }
  ''');

  static final listMedLogs = gql(r'''
    query MedLogs($input: GetMedLogsInput!) {
      medLogs(input: $input) {
        items {
          id
          month
          year
          isSubmitted
          signingStatus
          canSign          
          child {
            id
            firstName
            lastName
            nickName
            imageURL
          }
          entries{
            id
            dateTime
            timeString
            isFailure
            given
            failureDescription
            enteredBy
            notesCount
            medication {
              id
              medicationName
              dosage
            }
          }   
        }
        pageInfo {
          cursor
          hasNextPage
          count
        }
      }
    }
  ''');

  static final recreationLog = gql(r'''
    query RecreationLog($input: GetRecreationLogInput!) {
      recreationLog(input: $input) {
        id
        activityComment
        dailyIndoorOutdoorActivity
        individualFreeTimeActivity
        communityActivity
        familyActivity
      }
    }
  ''');

  static final listMedLogsExtendedDetails = gql(r'''
    query MedLogs($input: GetMedLogsInput!) {
      medLogs(input: $input) {
        items {
          id
          month
          year
          isSubmitted
          signingStatus
          canSign
          medications {
            id
            medicationName
            reason
            dosage
            strength
          }      
          entries{
            id
            dateTime
            timeString
            isFailure
            given
            failureDescription
            enteredBy
            notesCount
            medication {
              id
              medicationName
              dosage
            }
          }       
          childSex
          allergies
          child {
            id
            firstName
            lastName
            nickName
            imageURL
          }
        }
        pageInfo {
          cursor
          hasNextPage
          count
        }
      }
    }
  ''');

  static final listMedLogEntries = gql(r'''
    query MedLogEntries($input: GetMedLogEntriesInput!) {
      medLogEntries(input: $input) {
        items {
          id
          dateTime
          dateString
          timeString
          isFailure
          given
          failureReason
          enteredBy
          failureDescription
          medication {
            id
            medicationName
            dosage
            reason
            notes{
              id
              content
            }
          }
          notesCount
        }
        pageInfo {
          cursor
          hasNextPage
          count
        }
      }
    }
  ''');

  static final medLog = gql(r'''
    query Query($input: GetMedLogInput!) {
      medLog(input: $input) {
        id
        month
        year
        isSubmitted
        signingStatus
        canSign
        medications {
            id
            medicationName
            strength
            notesCount
            notes{
              id
              content
            }
        }
        child {
          id
          firstName
          lastName
          nickName
          imageURL
        }
      }
    }
  ''');

  static final medLogMedication = gql(r'''
    query Medication($input: GetMedicationInput!) {
      medication(input: $input) {
        id
        medicationName
        dosage
        reason
        strength
        notesCount
        notes {
          id
          content
          enteredBy
        }
      }
    }
  ''');

  static final medLogEntry = gql(r'''
    query Query($input: GetMedLogEntryInput!) {
      medLogEntry(input: $input) {
        id
        dateTime
        dateString
        timeString
        isFailure
        given
        failureReason
        failureDescription
        enteredBy
        notes {
          id
          content
          enteredBy
        }
        notesCount
        medication {
          id
          medicationName
        }
      }
    }
  ''');

  static final medLogExtended = gql(r'''
    query MedLogs($input: GetMedLogInput!) {
      medLog(input: $input) {
        id
        childSex
        month
        year
        allergies
        signingStatus
        isSubmitted
        submittedBy
        canSign
        medications {
          id
          medicationName
          reason
          dosage
          strength
          prescriptionDate
          prescriptionDateString
          physicianName
          notes{
            id
            content
          }
        }
        child {
          id
          firstName
          lastName
          nickName
          imageURL
        }
      }
    }
  ''');

  static final medLogDocumentUrl = gql(r'''
    query MedLogs($input: GetMedLogInput!) {
      medLog(input: $input) {
        id
        documentUrl
      }
    }
  ''');
  static final recreationLogs = agql(
    document: r'''
      query RecreationLogs($input: GetRecreationLogsInput!) {
        recreationLogs(input: $input) {
          items {
            id
            createdAt
            activityComment
            dailyIndoorOutdoorActivity
            individualFreeTimeActivity
            communityActivity
            familyActivity
            child {
              id
              firstName
              lastName
              nickName
              imageURL
              dateOfBirth
            }
            family {
              firstName
              lastName
              id
            }
          }
          pageInfo {
            cursor
            hasNextPage
            count
          }
        }
      }
    ''',
  );
}
