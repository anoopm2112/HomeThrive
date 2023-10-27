import React, { useState, useEffect } from 'react';
import { View, SafeAreaView, Text, StyleSheet } from 'react-native';
import { ProgressBar, Button, Snackbar } from 'react-native-paper'
import { BackHandler } from "react-native";
import colorPalette from '../../theme/Palette';
import Header from '../Components/Header';

import { useOfflineDataContext } from '../../helpers/OfflineOperationHandler';
import Constants from '../../common/hooks/Constants';
import Icon from 'react-native-vector-icons/FontAwesome';
import { useNavigation } from '@react-navigation/native';
import APIS from '../../common/hooks/useApiCalls';
import Theme from '../../theme/Theme';
import Palette from '../../theme/Palette';
import TitleBar from '../Components/TitleBar';
import { useTranslation } from 'react-i18next';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';

const AssessmentUpload = ({ route, toggleMenu, toggleBellIcon }) => {

    const navigation = useNavigation()
    const [assessments, setAssessments] = useState([])
    const [operationStatus, setOperationStatus] = useState(status.idle)
    const [uploadedItems, setUploadedItems] = useState(0)
    const [showSnackBar, setShowSnackBar] = useState(false)
    const { forceUpload } = route.params

    const { callOfflineOperation, operationResult } = useOfflineDataContext()
    const { t } = useTranslation()
    const { isAppOnline, logScreen, hasNewNotifications } = useAuthHandlerContext()

    useEffect(() => {
        if (showSnackBar) {
            setTimeout(() => {
                setShowSnackBar(false)
            }, 1200)
        }
    }, [showSnackBar])

    useEffect(() => {
        const initialPayload = {
            "rowCount": "10",
            "pageNumber": "1",
            "orderByField": [
                [
                    "id",
                    "DESC"
                ]
            ],
            "assessmentStatus": "",
            "globalSearchQuery": "",
            "isComplete": "",
            "isUpload": true
        }

        callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getAssessmentsList, initialPayload))

        const logScreenAnalytics = () => {
            logScreen(ScreenConfigs.upload)
        }
        if (isAppOnline) {
            logScreenAnalytics()
        }

    }, [])

    useEffect(() => {
        const handleBackButtonClick = () => {
            doAction(navigation.goBack)
            return true;
        }

        BackHandler.addEventListener("hardwareBackPress", handleBackButtonClick);
        switch (operationResult.operationKey) {
            case Constants.offlineOperations.getAssessmentsList:
                const assessmentList = operationResult.data
                // console.log('Assessment List >> ', assessmentList)
                if (assessmentList.length > 0) {
                    setAssessments(assessmentList)
                }
                return
        }
        
        return () => {
            BackHandler.removeEventListener("hardwareBackPress", handleBackButtonClick);
        };
    }, [operationResult])

    const uploadAssessment = () => {
        try {
            let uploadedAssessments = 0
            assessments.forEach(async (assessment, index) => {
                // console.log('Upload Payload >> ', assessment.payload)
                assessment.payload.formRevisionNumber = assessment.payload.formRevisionNumber.toString();
                const res = await APIS.SaveAssessmentResponse(assessment.payload)
                // console.log('Upload response >> ', res)
                if (res && res.data && res.status === 200) {
                    console.log("Assessment saved successfully.", assessment.id)
                    callOfflineOperation(Constants.createRequest(Constants.offlineOperations.deleteAssessment, { data: assessment.id }))
                    uploadedAssessments += 1
                    setUploadedItems(uploadedAssessments)
                    if ((index + 1) === assessments.length) {
                        setOperationStatus(status.success)
                        console.log('UPLOAD ENTER');
                        callOfflineOperation(Constants.createRequest(Constants.offlineOperations.dropAllTables, null))
                    }
                } else {
                    setOperationStatus(status.failed)
                    return
                }
            })

        } catch (error) {
            console.log('Upload Assessment - Error >> ', error)
        }
    }

    const handleDownloadProcess = () => {
        setOperationStatus('op-uploading')
        uploadAssessment()
    }

    const doAction = (action) => {
        if (!isAppOnline || forceUpload !== undefined && !forceUpload || operationStatus === status.success) {
            action()
        } else {
            setShowSnackBar(true)
        }
    }

    return (
        <SafeAreaView style={{ flex: 1 }}>
            <Header
                toggleDrawer={() => {
                    doAction(toggleMenu)
                }}
                toggleBellIcon={toggleBellIcon}
                hasNewNotifications={hasNewNotifications}
            />
           
            <TitleBar goBack={() => {
                doAction(navigation.goBack)
            }} title={t('Upload:header')} />
            {assessments.length > 0 ? <View style={{ flex: 1, justifyContent: 'center' }}>
                {operationStatus === status.uploading && <View style={{ justifyContent: 'center', marginTop: 100 }}>
                    <ProgressBar
                        indeterminate
                        color={colorPalette.primary.main}
                        style={styles.progressBar} />
                    <Text style={{ alignSelf: 'center', marginTop: 8 }}>
                        {uploadedItems > 0 ? `${uploadedItems} ${uploadedItems > 1 ?
                            t('Upload:message:oneUploaded') : t('Upload:message:multipleUploaded')}` : t('Upload:message:uploading')}
                    </Text>
                </View>}

                {operationStatus === status.idle ? <View>
                    <View style={{ justifyContent: 'center', flexDirection: 'row', alignItems: 'center' }}>
                        <Icon name='warning' color={'crimson'} size={16} />
                        <Text style={[styles.warningText]}>{`${assessments.length > 1 ?
                            `${t('Upload:message:youHaveOnePending:part1')} ${assessments.length} ${t('Upload:message:youHaveOnePending:part2')}` :
                            `${t('Upload:message:youHaveMultiplePending:part1')} ${assessments.length} ${t('Upload:message:youHaveMultiplePending:part2')}`}`}</Text>
                    </View>
                    <Button icon={operationStatus === status.uploading ? '' : 'upload'}
                        mode="contained"
                        onPress={() => handleDownloadProcess()}
                        style={styles.uploadButton}
                        labelStyle={{ color: 'white' }}
                        disabled={!isAppOnline}
                    >
                        {t('Upload:action:upload')}
                    </Button>
                    {!isAppOnline && <Text style={{ alignSelf: 'center', marginTop: 6, fontSize: 11 }}>{t('Upload:message:enableDataConnection')}</Text>}
                </View> : <></>}
                {operationStatus === status.success && <Text style={[Theme.primaryLabel, { fontSize: 17, color: Palette.primary.main }]}>{t('Upload:message:success')}</Text>}
                {operationStatus === status.failed && <Text style={{ alignSelf: 'center', fontSize: 17, }}>{t('Upload:message:failed')}</Text>}
            </View> : <View style={{ flex: 1, justifyContent: 'center' }}>
                <Text style={[Theme.primaryLabel, { fontSize: 17 }]}>{t('Upload:message:nothingToUpload')}</Text>
            </View>}
            <Snackbar
                visible={showSnackBar}
                onDismiss={() => setShowSnackBar(false)}
            >
                {t('Upload:message:pleaseSync')}
            </Snackbar>
        </SafeAreaView>
    )
}

const styles = StyleSheet.create({
    progressBar: {
        width: 200, height: 8, borderRadius: 10, alignSelf: 'center'
    },
    uploadButton: {
        width: '40%', borderRadius: 20, alignSelf: 'center', marginTop: 100
    },
    warningText: {
        paddingStart: 5,
        fontWeight: '700',
    }
})

const status = {
    uploading: 'op-uploading',
    idle: 'op-idle',
    success: 'status-success',
    failed: 'status-failed',
}

export default AssessmentUpload