import 'package:fostershare/core/services/graphql/common/agql.dart';

class AuthMutations {
  // TODO do we need all these fields?

  static final createChildLog = agql(
    document: r'''
      mutation CreateChildLog($input: CreateChildLogInput!) {
        createChildLog(input: $input) {
          id
          createdAt
          updatedAt
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

  static final createChildLogImage = agql(
    document: r'''
      mutation CreateChildLogImage($input: CreateChildLogImageInput!) {
        createChildLogImage(input: $input) {
          id
          imageURL
          title
        }
      }
    ''',
  );

  static final createChildLogNote = agql(
    document: r'''
      mutation CreateChildLogNote($input: CreateChildLogNoteInput!) {
        createChildLogNote(input: $input) {
          id
          createdAt
          text
        }
      }
    ''',
  );

  static final markMessagesAsRead = agql(
    document: r'''
      mutation MarkMessagesAsRead($input: MarkMessagesAsReadInput!) {
        markMessagesAsRead(input: $input) {
          id
          createdAt
          title
          body
          status
        }
      }
    ''',
  );

  static final registerDevice = agql(
    document: r'''
      mutation RegisterDevice($input: RegisterDeviceInput!) {
        registerDevice(input: $input)
      }
    ''',
  );

  static final removeDevice = agql(
    document: r'''
      mutation RemoveDevice($input: RemoveDeviceInput!) {
        removeDevice(input: $input)
      }
    ''',
  );

  static final updateChild = agql(
    document: r'''
      mutation UpdateChild($input: UpdateChildInput!) {
        updateChild(input: $input) {
          id
          firstName
          lastName
          dateOfBirth
          imageURL
          logsCount
          agentName
          recentLogs {
            id
            date
            childMoodRating
          }
        }
      }
    ''',
  );

  static final updateChildNickName = agql(
    document: r'''
      mutation UpdateChildNickname($input: UpdateChildNiknameInput!) {
        updateChildNickname(input: $input) {
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

  static final updateEventParticipantStatus = agql(
    document: r'''
      mutation UpdateEventParticipantStatus($input: UpdateParticipantStatusInput!) {
        updateEventParticipantStatus(input: $input) {
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

  // TODO fragments
  static final updateProfile = agql(
    document: r'''
      mutation UpdateProfile($input: UpdateProfileInput!) {
        updateProfile(input: $input) {
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
    ''',
  );

  static final createFamilyImage = agql(
    document: r'''
      mutation CreateFamilyImage($input: CreateFamilyImageInput!) {
        createFamilyImage(input: $input) {
          id
          url
          name
          file
        }
      }
    ''',
  );

  static final updateChildLog = agql(
    document: r'''
      mutation UpdateChildLog($input: UpdateChildLogInput!) {
        updateChildLog(input: $input) {
          id
          createdAt
          updatedAt
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
        }
      }
    ''',
  );

  static final createRecreationLog = agql(
    document: r'''
      mutation createReacreationLog($input: CreateRecreationLogInput!) {
        createReacreationLog(input: $input) {
          id
          createdAt
          updatedAt
          date
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
        }
      }
    ''',
  );

  static final createMedLog = agql(
    document: r'''
      mutation CreateMedLog($input: CreateMedLogInput!) {
        createMedLog(input: $input) {
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
          medications {
            id
            medicationName
            reason
            dosage
            strength
            notesCount
          }
        }
      }
    ''',
  );

  static final updateMedLogMedication = agql(
    document: r'''
      mutation UpdateMedLog($input: UpdateMedLogInput!) {
        updateMedLog(input: $input) {
          id
          medications {
            id
            medicationName
            reason
            dosage
            strength
            notesCount
            prescriptionDate
          }
        }
      }
    ''',
  );

  static final updateMedLogNotes = agql(
    document: r'''
      mutation UpdateMedLog($input: UpdateMedLogInput!) {
        updateMedLog(input: $input) {
          id
          notes {
            id
            content
            enteredBy
          }
        }
      }
    ''',
  );

  static final createMedLogEntry = agql(
    document: r'''
      mutation Mutation($input: CreateMedLogEntryInput!) {
        createMedLogEntry(input: $input) {
          id
          dateTime
          dateString
          timeString
          isFailure
          given
          failureReason
          failureDescription
          enteredBy
          notesCount
        }
      }
    ''',
  );

  static final updateMedLogEntryNotes = agql(
    document: r'''
      mutation Mutation($input: UpdateMedEntryLogInput!) {
        updateMedLogEntry(input: $input) {
          id
          notes {
            id
            content
            enteredBy
          }
        }
      }
    ''',
  );

  static final deleteMedLogEntry = agql(
    document: r'''
      mutation DeleteMedLogEntry($input: GetMedLogEntryInput!) {
        deleteMedLogEntry(input: $input) {
          id
        }
      }
    ''',
  );

  static final submitAndCreateSigningRequest = agql(
    document: r'''
      mutation Mutation($input: GenerateSigningRequestInput!) {
        submitMedLog(input: $input) {
          id
        }
        createSigningRequest(input: $input) {
          id
        }
      }
    ''',
  );

  static final generateSigningUrl = agql(
    document: r'''
      mutation Mutation($input: GenerateSigningRequestInput!) {
        generateSigningUrl(input: $input)
      }
    ''',
  );

  static final updateSigningStatus = agql(
    document: r'''
      mutation UpdateSigningStatus($input: UpdateSigningStatusInput!) {
        UpdateSigningStatus(input: $input) {
          id
          signingStatus          
        }
      }
    ''',
  );
}
