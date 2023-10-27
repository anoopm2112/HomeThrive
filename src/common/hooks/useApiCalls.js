import _ from "lodash";
import axios from "axios";

import { AppConfig } from './config';
import { Auth } from 'aws-amplify';

import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from "react-native";


axios.defaults.baseURL = AppConfig.baseURL;
axios.defaults.headers.post["Content-Type"] = "application/json";
axios.defaults.headers.put["Content-Type"] = "application/json";
axios.defaults.headers.patch["Content-Type"] = "application/json";
axios.defaults.headers.post['Accept'] = 'application/json';
axios.defaults.headers.put["Accept"] = "application/json";
axios.defaults.headers.patch['Accept'] = 'application/json';
// axios.defaults.headers.common['Authorization'] = getAccessToken();

axios.interceptors.request.use(async (config) => {
    config.headers.Authorization = await getAccessToken()
    return config;
});


const CaseListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/case/list';
//const AddCaseURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/case';
const CaseDetailsPartialURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/case?case_id=';

const DomainListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/question/domain';

const FormListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/form';
//assessments

const VisitTypeListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/assessment/visittypes';
const ReIntegrationTypeListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/assessment/reintegrationtypes';
const AssessmentListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/assessment/list';
const SaveResponseURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/assessment/save/response';
const ListFormQuestionsURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/assessment/getassessmentform?formId=';
const GetAssessmentDetailsURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/assessment/getassessmentdetails?assessmentId=';
const CalculateScoreURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/score/calculate';
const UserPermissionURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/user/caseworker/auth';
const EventListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/events/list';
const LanguageListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/languages';
const CaseDetailsDownloadURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/casedetails/download';
const NotificationsListURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/notification/list';
const NotificationsUpdateURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/notification/update';
const NotificationsRegisterDeviceURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/notification/register';
const CurrentUserDetailsURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/user?user_id=';
const CountryStateCityURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/location/countryStateCityList?languageId=';
const organizationNameURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/organization/orgType?organization_id=';
const userProfileEditURL = AppConfig.baseURL + '/' + AppConfig.baseEndPoint + '/user/profile';
const UploadURL = AppConfig.baseURL + "/" + AppConfig.baseEndPoint + "/fileUploads/";
const saveUserLanguageURL = AppConfig.baseURL + "/" + AppConfig.baseEndPoint + "/user/saveLanguage";

const imageUrl = (imageName) => {
    return AppConfig.baseURL + '/static/icons/' + imageName
}

const getAccessToken = async () => {
    try {
        const accessToken = await AsyncStorage.getItem('accessToken')
        if (accessToken !== null) {
            return accessToken
        }
    } catch (e) {
        return null
    }
}

const storeAccessToken = async (accessToken, refreshToken) => {
    try {
        await AsyncStorage.setItem('accessToken', accessToken)
        await AsyncStorage.setItem('refreshToken', refreshToken)
    } catch {
        // console.log("tokens not stored locally.")
    }
}

const APIS = {
    async PreRequestCall() {
        try {
            const session = await Auth.currentSession()
            const jwtToken = session.getAccessToken().getJwtToken()
            const idToken = session.getIdToken().getJwtToken()
            const refreshToken = session.getRefreshToken().getToken()
            storeAccessToken(idToken, refreshToken)
            return session
        } catch (err) {
            // console.log('Error prerequest >> ', err)
        }
    },
    async CaseList(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.post(CaseListURL, payload);
                return response
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async CaseDetails(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.get(CaseDetailsPartialURL + payload);
                return response
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async CaseDetailsDownload(caseIds) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.post(CaseDetailsDownloadURL, { caseIds: caseIds });
                return response
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async ReIntegrationTypeList() {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.get(ReIntegrationTypeListURL + `?device=mobile`);
                return response;
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async VisitTypeList() {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.get(VisitTypeListURL + `?device=mobile`);
                return response;
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async DomainList() {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.get(DomainListURL);
                return response;
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async FormList() {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.get(FormListURL);
                return response;
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async AssessmentList(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.post(AssessmentListURL, payload);
                return response;
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async SaveAssessmentResponse(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const resonse = await axios.post(SaveResponseURL, payload);
                return resonse;
            }
        } catch (error) {
            let errorObject = {
                status: '',
                body: {}
            };
            if (error.request) {
                errorObject.status = error.request.status;
                errorObject.body = JSON.parse(error.request.response);
                return errorObject;
            }
        }
    },
    async GetAssessmentDetails(assessmentId, formRevision, languageId) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const GetAssessmentDetailCompletedURL = GetAssessmentDetailsURL + assessmentId + `&formRevision=${formRevision}` + `&languageId=${languageId}`;
                const response = await axios.get(GetAssessmentDetailCompletedURL);
                return response;
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async CalculateScore(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.post(CalculateScoreURL, payload);
                return response;
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async ListAssessmentFormQuestions(formId, formRevision, languageId) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const FormQuestionsCompletedURL = ListFormQuestionsURL + formId + `&formRevision=${formRevision}` + `&languageId=${languageId}`;
                const response = await axios.get(FormQuestionsCompletedURL);
                return response;
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async CheckUserPermission() {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.post(UserPermissionURL, {
                    "loggedInDevice": "mobile"
                })
                return response.data
            }
        } catch (error) {
            // console.log('Check user permission Error >> ', error);
        }
    },
    async EventList(childId = null) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const payload = {
                    "childFilter": `${childId !== null ? childId : ''}`
                }
                const response = axios.post(EventListURL, payload)
                return response
            }
        } catch (error) {
            console.error('Error >> ', error)
        }
    },
    async Languages(childId = null) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const payload = {
                    "childFilter": `${childId !== null ? childId : ''}`
                }
                const response = axios.get(LanguageListURL)
                return response
            }
        } catch (error) {
            console.error('Error >> ', error)
        }
    },
    async NotificationList(payloadData) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const payload = payloadData
                const response = axios.post(NotificationsListURL, payload)
                return response
            }
        } catch (error) {
            console.error('Error >> ', error)
            return null
        }
    },
    async NotificationUpdate(id, readStatus = true) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const payload = `{
                    "id": "${id}",
                    "readStatus": "${readStatus}"
                }`
                const response = axios.patch(NotificationsUpdateURL, payload);
                return response
            }
        } catch (error) {
            console.error('Error >> ', error)
            return null
        }
    },
    async RegisterDeviceForPushNotification(token) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const payload = `{ "token": "${token}",
                "appPlatform": "${Platform.OS.toUpperCase()}",
                "model" : "test",
                "osVersion" : "" }`
                const response = axios.post(NotificationsRegisterDeviceURL, payload)
                return response
            }
        } catch (error) {
            console.error('Error >> ', error)
            return null
        }
    },
    async CurrentUserDetails(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.get(CurrentUserDetailsURL + payload);
                return response
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async CountryStateCity(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.get(CountryStateCityURL + payload);
                return response
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async OrganizationName(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = await axios.get(organizationNameURL + payload);
                return response
            }
        } catch (error) {
            // console.log('Error >> ', error);
        }
    },
    async UserProfileEdit(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = axios.put(userProfileEditURL, payload);
                return response
            }
        } catch (error) {
            console.error('Error >> ', error)
            return null
        }
    },
    async UploadFile(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                let payloadURL = `${payload.moduleType}/${payload.documentType}?fileName=${payload.fileName}&moduleId=${payload.moduleId}&fileSize=${payload.fileSize}&description=${payload.description}`;
                let newUploadURL = UploadURL + payloadURL;
                return axios.post(newUploadURL).then((response) => { return response })
                    .catch((error) => {
                        let errorObject = { status: "", body: {} };
                        if (error.request) {
                            errorObject.status = error.request.status;
                            errorObject.body = JSON.parse(error.request.response);
                            return errorObject;
                        }
                        // console.log("error", error);
                    });
            }
        } catch (error) {
            console.error('Error >> ', error)
            return null
        }
    },
    async UploadUpdatedFile(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                let payloadURL = `${payload.moduleType}/${payload.documentType}/${payload.documentId}?fileName=${payload.fileName}&moduleId=${payload.moduleId}&fileSize=${payload.fileSize}&description=${payload.description}`;
                let newUploadURL = UploadURL + payloadURL;
                return axios.put(newUploadURL).then((response) => { return response })
                    .catch((error) => {
                        let errorObject = { status: "", body: {} };
                        if (error.request) {
                            errorObject.status = error.request.status;
                            errorObject.body = JSON.parse(error.request.response);
                            return errorObject;
                        }
                        // console.log("error", error);
                    });
            }
        } catch (error) {
            console.error('Error >> ', error)
            return null
        }
    },
    async SaveUserLanguage(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                const response = axios.post(saveUserLanguageURL, payload);
                return response
            }
        } catch (error) {
            console.error('Error >> ', error)
            return null
        }
    },
    async DeleteProfileImage(payload) {
        try {
            const preRequestData = await this.PreRequestCall()
            if (preRequestData !== null) {
                let payloadURL = `${payload.moduleType}/${payload.documentType}?moduleId=${payload.moduleId}`;
                let newUploadURl = UploadURL + payloadURL;

                return axios.delete(newUploadURl).then((response) => { return response })
                    .catch((error) => {
                        let errorObject = { status: "", body: {} };
                        if (error.request) {
                            errorObject.status = error.request.status;
                            errorObject.body = JSON.parse(error.request.response);
                            return errorObject;
                        }
                        // console.log("error", error);
                    });
            }
        } catch (error) {
            console.error('Error >> ', error)
            return null
        }
    }
}

export default APIS