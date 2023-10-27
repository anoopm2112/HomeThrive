export default {
    createRequest: (operation, params) => {
        return {
            operationKey: operation,
            ...params,
        }
    },
    createResponse: (operation, response) => {
        return {
            operationKey: operation,
            data: response,
        }
    },
    offlineOperations: {
        fetchCaseList: 'fetch-case-list',
        fetchFormData: 'fetch-form-data',
        fetchFormDetails: 'fetch-form-details',
        fetchAssessments: 'fetch-assessments-list',
        calculateAssessmentScore: 'calculate-assessment-score',
        saveCaseList: 'offline-save-case-list',
        saveFormData: 'offline-save-form-data',
        saveFormDetails: 'offline-save-form-details',
        saveAssessment: 'offline-save-assessment',
        getCaseList: 'offline-get-case-list',
        getFormData: 'offline-get-form-data',
        getFormDetails: 'offline-get-form-details',
        getAssessmentsList: 'offline-get-assessments',
        saveCaseDetail: 'save-case-detail',
        getCaseDetail: 'offline-get-case-detail',
        dropAllTables: 'offline-drop-all-tables',
        downloadData: 'operation-download-data',
        deleteAssessment: 'operation-delete-assessment',

        isSyncPending: 'operation-offline-data-sync-pending',

        downloadWeeklyAssessments: "download-weekly-assessments",
    },
    defaultValues: {
        highestScore: 4,
    },
    offlineDataKeys: {
        caseList: 'offlineCaseList',
        formDetails: 'offlineFormDetails',
        domains: 'offlineDomains',
        formQuestions: 'offlineFormQuestions',
        reIntegrationTypes: 'offlineReIntegrationTypes',
        visitTypes: 'offlineVisitTypes'
    },
    validateEmail: (email) => {
        return String(email)
            .toLowerCase()
            .match(
                /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            );
    },
    validatePassword: (password) => {
        return String(password)
            .match(
                /(?=^.{8,}$)(?=.*\d)(?=.*[!@#$%^&*]+)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/
            );
    }
}