export default {
    dbInfo: {
        dbName: "MiracleOffline.db",
        dbVersion: '2.0',
        dbSize: 200000,
        dbDisplayName: 'Miracle Offline Data Storage'
    },
    tables: {
        VERSION: 'Version'
    }, 
    caseListTable: {
        tableName: 'CaseListTbl',
        columns: {
            htChildId: {
                columnName: 'ht_child_id',
                type: 'VARCHAR'
            },
            htUserId: {
                columnName: 'ht_user_id',
                type: "VARCHAR"
            },
            caseStatus: {
                columnName: 'case_status',
                type: 'VARCHAR'
            },
            caseId: {
                columnName: 'case_id',
                type: 'VARCHAR'
            },
            childBirthDate: {
                columnName: 'child_birth_date',
                type: 'VARCHAR'
            },
            childFirstName: {
                columnName: 'child_first_name',
                type: 'VARCHAR'
            },
            childLastName: {
                columnName: 'child_last_name',
                type: 'VARCHAR'
            },
            childGender: {
                columnName: 'child_gender',
                type: 'VARCHAR'
            },
            childId: {
                columnName: 'child_id',
                type: 'VARCHAR'
            },
            createdAt: {
                columnName: 'created_at',
                type: 'VARCHAR'
            },
            displayText: {
                columnName: 'display_text',
                type: 'VARCHAR'
            },
            endDate: {
                columnName: 'end_date',
                type: 'VARCHAR'
            },
            id: {
                columnName: 'id',
                type: 'INTEGER'
            },
            isActive: {
                columnName: 'is_active',
                type: 'BOOLEAN'
            },
            numberOfAssessments: {
                columnName: 'number_of_assessments',
                type: 'VARCHAR'
            },
            startDate: {
                columnName: 'start_date',
                type: 'VARCHAR'
            },
            userFirstName: {
                columnName: 'userFirstName',
                type: 'VARCHAR'
            },
            userLastName: {
                columnName: 'userLastName',
                type: 'VARCHAR'
            },
            fileUrl: {
                columnName: 'file_url',
                type: 'VARCHAR'
            },
            lastReportedDate: {
                columnName: 'lastReportedDate',
                type: 'VARCHAR'
            },
            city: {
                columnName: 'city',
                type: 'VARCHAR'
            },
            district: {
                columnName: 'district',
                type: 'VARCHAR'
            },
            state: {
                columnName: 'state',
                type: 'VARCHAR'
            },
            country: {
                columnName: 'country',
                type: 'VARCHAR'
            }
        }
    },
    assessmentListTable: {
        tableName: 'AssessmentsListTbl',
        columns: {
            htAssessmentReintegrationTypeId: {
                columnName: 'ht_assessment_reintegration_type_id',
                type: 'VARCHAR'
            },
            htCaseId: {
                columnName: 'ht_case_id',
                type: 'VARCHAR'
            },
            htFormId: {
                columnName: 'ht_form_id',
                type: 'VARCHAR'
            },
            caseId: {
                columnName: 'case_id',
                type: 'VARCHAR'
            },
            caseWorkerFirstName: {
                columnName: 'case_worker_first_name',
                type: 'VARCHAR'
            },
            caseWorkerLastName: {
                columnName: 'case_worker_last_name',
                type: 'VARCHAR'
            },
            childFirstName: {
                columnName: 'child_first_name',
                type: 'VARCHAR'
            },
            childId: {
                columnName: 'child_id',
                type: 'VARCHAR'
            },
            childLastName: {
                columnName: 'child_last_name',
                type: 'VARCHAR'
            },
            dateOfAssessment: {
                columnName: 'date_of_assessment',
                type: 'VARCHAR'
            },
            id: {
                columnName: 'id',
                type: 'INTEGER'
            },
            isActive: {
                columnName: 'is_active',
                type: 'BOOLEAN'
            },
            isComplete: {
                columnName: 'is_complete',
                type: 'BOOLEAN'
            },
            meetWithChild: {
                columnName: 'met_with_child',
                type: 'BOOLEAN'
            },
            organizationId: {
                columnName: 'organization_id',
                type: 'VARCHAR'
            },
            organizationName: {
                columnName: 'organization_name',
                type: 'VARCHAR'
            },
            updatedAt: {
                columnName: 'updated_at',
                type: 'VARCHAR'
            },
            userId: {
                columnName: 'user_id',
                type: 'VARCHAR'
            },
            assessmentPayload: {
                columnName: 'assessment_payload',
                type: 'VARCHAR'
            },
            assessmentInfo: {
                columnName: 'assessment_info',
                type: 'VARCHAR'
            },
            isSynced: {
                columnName: 'is_synced',
                type: 'BOOLEAN'
            },
            isOffline: {
                columnName: 'isOffline',
                type: 'BOOLEAN'
            },
            deviceType: {
                columnName: 'device_type',
                type: 'VARCHAR'
            },
            assessmentStartsAt: {
                columnName: 'assessmentStartsAt',
                type: 'VARCHAR'
            },
            assessmentEndsAt: {
                columnName: 'assessmentEndsAt',
                type: 'VARCHAR'
            },
            formRevisionNumber: {
                columnName: 'formRevisionNumber',
                type: 'VARCHAR'
            },
            formQuestions: {
                columnName: 'form_questions',
                type: 'VARCHAR'
            },
            primaryChoices: {
                columnName: 'primary_choices',
                type: 'VARCHAR'
            },
            integrationOptions: {
                columnName: 'integration_options',
                type: 'VARCHAR'
            },
            fileUrl: {
                columnName: 'file_url',
                type: 'VARCHAR'
            },
            assessmentScore: {
                columnName: 'assessmentScore',
                type: 'VARCHAR'
            },
            previousScore:{
                columnName: 'previousScore',
                type: 'VARCHAR'
            }
        }

    },
    caseDetailsTable: {
        tableName: 'CaseDetailsTbl',
        columns: {
            id:{
                columnName: 'id',
                type: 'INTEGER'
            },
            HTChildId:{
                columnName: 'HTChildId',
                type: 'VARCHAR'
            },
            caseStatus:{
                columnName: 'caseStatus',
                type: 'VARCHAR'
            },
            isActive:{
                columnName: 'isActive',
                type: 'BOOLEAN'
            },
            numberOfAssessments:{
                columnName: 'numberOfAssessments',
                type: 'VARCHAR'
            },
            userFirstName:{
                columnName: 'userFirstName',
                type: 'VARCHAR'
            },
            userLastName:{
                columnName: 'userLastName',
                type: 'VARCHAR'
            },
            childFirstName:{
                columnName: 'childFirstName',
                type: 'VARCHAR'
            },
            childLastName:{
                columnName: 'childLastName',
                type: 'VARCHAR'
            },
            childGender:{
                columnName: 'childGender',
                type: 'VARCHAR'
            },
            childBirthDate:{
                columnName: 'childBirthDate',
                type: 'VARCHAR'
            },
            dispplytext:{
                columnName: 'dispplytext',
                type: 'VARCHAR'
            },
            lastAssesmentDate:{
                columnName: 'lastAssesmentDate',
                type: 'VARCHAR'
            },
            previousScore:{
                columnName: 'previousScore',
                type: 'VARCHAR'
            },
            caseId:{
                columnName: 'caseId',
                type: 'VARCHAR'
            }
        }
    }
}