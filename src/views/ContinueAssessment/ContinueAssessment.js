import React, { useEffect, useState } from 'react';
import APIS from '../../common/hooks/useApiCalls';
import colorPalette from '../../theme/Palette';
import Header from '../Components/Header';
// import Footer from '../Components/Footer';
import Icon from 'react-native-vector-icons/FontAwesome5';
import FilterIcon from 'react-native-vector-icons/Ionicons';
import CloseIcon from 'react-native-vector-icons/AntDesign';
import { View, SafeAreaView, Text, TouchableOpacity, FlatList, ActivityIndicator, TextInput, Platform, Keyboard, StyleSheet } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useOfflineDataContext } from '../../helpers/OfflineOperationHandler';
import Constants from '../../common/hooks/Constants';
import { useIsFocused } from '@react-navigation/native';
import CaseNavigationModal from '../Components/CaseNavigationModal';
import { Portal } from 'react-native-paper';
import AssessmentListItem from '../Components/AssessmentListItem/AssessmentListItem';
import TitleBar from '../Components/TitleBar';
import { useTranslation } from 'react-i18next';
import TextView from '../Components/TextView/TextView';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import { convertHeight } from '../../common/utils/dimensionUtil';

const ContinueAssessment = ({ toggleMenu, toggleBellIcon }) => {
    const navigation = useNavigation();
    const isFocused = useIsFocused();
    const { t } = useTranslation();

    const [assessments, setAssessments] = useState([]);
    const [fullAssessments, setFullAssessments] = useState([]);

    const [loading, setLoading] = useState(false);
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedAssessmentData, setSelectedAssessmentData] = useState({})
    const [assessmentSelected, setAssessmentSelected] = useState(false)

    const [caseDetails, setCaseDetails] = useState({})

    const [showFilter, setShowFilter] = useState(false)
    const [selectedIsComplete, setSelectedIsComplete] = useState(false)
    // const [keyboardIsOpen, setKeyboardIsOpen] = useState(false);

    const { callOfflineOperation, isAppOnline, operationResult } = useOfflineDataContext()
    const { logScreen, hasNewNotifications } = useAuthHandlerContext()

    const InputAccessoryViewID = 'continueAssessmentID';

    useEffect(() => {
        const logScreenAnalytics = () => {
            logScreen(ScreenConfigs.partiallyCompleted)
        }
        if (isAppOnline) {
            logScreenAnalytics()
        }
    }, [])

    // useEffect(() => {
    //     const keyboardDidShowListener = Keyboard.addListener("keyboardDidShow", () => {
    //         setKeyboardIsOpen(true);
    //     });
    //     const keyboardDidHideListener = Keyboard.addListener("keyboardDidHide", () => {
    //         setKeyboardIsOpen(false);
    //     });
    //     return () => {
    //         // Anything in here is fired on component unmount.
    //         keyboardDidHideListener.remove();
    //         keyboardDidShowListener.remove();
    //     }
    // }, []);

    useEffect(() => {
        if (isFocused) {
            console.log('CA', operationResult.operationKey);
            switch (operationResult.operationKey) {
                
                case Constants.offlineOperations.getAssessmentsList:
                    console.log('ddd', operationResult.data.length);
                    if (operationResult.data.length > 0) {
                        if (isAppOnline) {
                            if (operationResult.data.length > 0) {
                                const allList = [...operationResult.data, ...fullAssessments]
                                // const ids = allList.map(o => o.id)
                                // const filtered = allList.filter(({ id }, index) => !ids.includes(id, index + 1))
                                setFullAssessments(allList)
                            }
                        } else {
                            // console.log('Assessment List offline >> ', operationResult.data.length)
                            setFullAssessments(operationResult.data)
                        }
                    }
                    setLoading(false)
                    return
                case Constants.offlineOperations.getCaseDetail:
                    // console.log('Case Detail >> ', operationResult.data)
                    setCaseDetails(operationResult.data)
                    setAssessmentSelected(true)
                    return
            }
        }
    }, [operationResult])

    useEffect(() => {
        if (isFocused) {
            getFullAssessment()
            setLoading(true)
        }
    }, [isFocused, isAppOnline])

    useEffect(() => {
        setAssessments(fullAssessments.filter((assessmentItem) => assessmentItem.isComplete === selectedIsComplete))
    }, [fullAssessments, selectedIsComplete])

    useEffect(() => {
        if (fullAssessments.length > 0) {
            if (searchQuery.length > 0) {
                const searchQueryLowerCase = searchQuery.toLowerCase().replace(/\s/g, "");
                const isCompleteAssessment = 
                    fullAssessments.filter((assessmentItem) => assessmentItem.isComplete === selectedIsComplete)
                const checkSearch =
                    isCompleteAssessment.filter((assessmentItem) => {
                        const fullNameChild = assessmentItem.childFirstName.replace(/\s/g, "") + assessmentItem.childLastName.replace(/\s/g, "");
                        return assessmentItem.caseWorkerFirstName.toLowerCase().includes(searchQueryLowerCase) ||
                            assessmentItem.caseWorkerLastName.toLowerCase().includes(searchQueryLowerCase) || assessmentItem.childFirstName.toLowerCase().includes(searchQueryLowerCase) ||
                            assessmentItem.childLastName.toLowerCase().includes(searchQueryLowerCase) || assessmentItem.organizationName.toLowerCase().includes(searchQueryLowerCase) ||
                            fullNameChild.toLowerCase().includes(searchQueryLowerCase)
                    }) 
                setAssessments(checkSearch);
                // setAssessments(assessments.filter((assessmentItem) => {
                //     return assessmentItem.caseWorkerFirstName.toLowerCase().includes(searchQueryLowerCase) ||
                //         assessmentItem.caseWorkerLastName.toLowerCase().includes(searchQueryLowerCase) || assessmentItem.childFirstName.toLowerCase().includes(searchQueryLowerCase) ||
                //         assessmentItem.childLastName.toLowerCase().includes(searchQueryLowerCase) || assessmentItem.organizationName.toLowerCase().includes(searchQueryLowerCase)
                // }))
            } else {
                setAssessments(fullAssessments.filter((assessmentItem) => assessmentItem.isComplete === selectedIsComplete))
            }
        }
    }, [searchQuery])

    const getFullAssessment = async () => {
        let payload = {
            "rowCount": `10`,
            "pageNumber": `1`,
            "needFullData": "true",
            "assessmentStatus": "Active",
            "orderByField": [
                [
                    "dateOfAssessment",
                    "ASC"
                ],
                [
                    "id",
                    "DESC"
                ]
            ],
            "globalSearchQuery": "",
            "isComplete": "",
            "loggedInDevice": "mobile"
        }
        if (isAppOnline) {
            const data = await APIS.AssessmentList(payload)
            // console.log('Payload >> ', payload)
            if (data && data.data && data.data.data) {
                let fullData = data.data.data
                if (fullData.length > 0) {
                    setFullAssessments(fullData)
                }
            }
        }
        callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getAssessmentsList, { ...payload }))
    }

    const cancelSearch = () => {
        if (searchQuery.length > 0) {
            setSearchQuery('')
        }
    }

    const handleOnClick = () => {
        setAssessmentSelected(false)
        navigation.navigate('Assessment',
            {
                caseData: selectedAssessmentData,
                editAssessment: true,
                assessmentId: selectedAssessmentData.id,
                fromAssessment: true,
                viewAssessment: selectedAssessmentData.isComplete,
                caseDetails: caseDetails,
                formRevisionNumber: selectedAssessmentData.formRevisionNumber
            })
    }

    const handleModalAssessmentList = (item) => {
        if (item) {
            // console.log('item >> !null', item)
            setSelectedAssessmentData(item)
            getAssessmentCaseDetails(item.HTCaseId)
        } else {
            // console.log('item >> null')
            setAssessmentSelected(false)
        }
    }

    const getAssessmentCaseDetails = async (id) => {
        try {
            if (isAppOnline) {
                const data = await APIS.CaseDetails(id);
                if (data && data.data && data.data.data) {
                    // console.log('Case Details >> ', data.data.data)
                    setCaseDetails(data.data.data)
                    setAssessmentSelected(true)
                }
            } else {
                callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getCaseDetail, { data: id }))
            }
        } catch (err) {
            console.error(err)
        }
    }

    const styles = StyleSheet.create({
        mainContainer: {
            flex: 1,
            borderRadius: 5,
            borderWidth: 0.8,
            borderColor: colorPalette.text.primary,
            flexDirection: "row",
            alignItems: "center",
            alignSelf: "center",
            width: '100%'
        },
        searchBox: {
            paddingLeft: 10,
            fontSize: 20,
            color: colorPalette.text.primary,
            flex: 1
        },
        cancelBtnContainer: {
            width: "10%",
            justifyContent: "center",
            alignItems: "center"
        },
        filterCloseContainer: {
            flexDirection: 'row',
            justifyContent: 'space-between',
            borderRadius: 20,
            borderWidth: 1,
            borderColor: selectedIsComplete ? 'limegreen' : 'grey',
            paddingHorizontal: 10,
            paddingVertical: 6,
            marginVertical: 10,
            alignSelf: 'flex-end'
        },
        filterCloseIcon: { 
            backgroundColor: selectedIsComplete ? 'limegreen' : 'grey', 
            alignContent: 'center', 
            padding: 3, 
            borderRadius: 10 
        }
    });

    return (
        <SafeAreaView style={{ display: "flex", flex: 1 }}>
            <Header toggleDrawer={toggleMenu} toggleBellIcon={toggleBellIcon} hasNewNotifications={hasNewNotifications} />
            <TitleBar title={'ContinueAssessment:header'} />
            {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}

            <View style={{ paddingHorizontal: 10, paddingVertical: 10 }}>
                <View style={{ flexDirection: 'row' }}>
                    <View style={styles.mainContainer}>
                        <TextInput 
                            style={styles.searchBox}
                            placeholder={t('Common:label:search')}
                            value={searchQuery}
                            placeholderTextColor={colorPalette.text.primary}
                            underlineColorAndroid={'transparent'}
                            onChangeText={(text) => setSearchQuery(text)}
                            inputAccessoryViewID={InputAccessoryViewID}
                        />
                        {searchQuery.length > 0 && <TouchableOpacity style={styles.cancelBtnContainer} onPress={() => cancelSearch()}>
                            <CloseIcon name="close" size={25} color={colorPalette.text.primary} />
                        </TouchableOpacity>}
                    </View>
                    <FilterIcon name={'filter'} color={'#052536'} size={20} style={{ padding: 10, alignSelf: 'center' }} onPress={() => setShowFilter(!showFilter)} />
                </View>

                {showFilter && <TouchableOpacity onPress={() => setSelectedIsComplete(!selectedIsComplete)}>
                    <View style={styles.filterCloseContainer}>
                        <Icon name={'check'} color={'white'} size={12} style={styles.filterCloseIcon} onPress={() => setShowCalendar(!showFilter)} />
                        <TextView style={{ color: selectedIsComplete ? 'limegreen' : 'grey', marginHorizontal: 8 }} textObject={'Common:label:closed'} />
                    </View>
                </TouchableOpacity>}
            </View>

            {assessments && assessments.length > 0 ?
                <View style={{ display: "flex", flex: 1, paddingHorizontal: 10 }}>
                    <FlatList
                        keyExtractor={(item, index) => item.id + index}
                        style={{ display: "flex", height: "100%", marginBottom: 10 }}
                        data={assessments}
                        showsVerticalScrollIndicator={false}
                        renderItem={({ item, index }) => <AssessmentListItem
                            item={item}
                            index={index}
                            totalAssesments={assessments.length}
                            onSelectAssessment={() => handleModalAssessmentList(item)} />}
                    />
                </View>
                :
                <View style={{ display: "flex", justifyContent: "center", alignItems: "center", flex: 1 }}>
                    <TextView style={{ fontSize: convertHeight(14), marginTop: "20%" }} textObject={searchQuery.length > 0 ? 'AssessmentList:message:noSearchItems' : 'AssessmentList:message:noItems'} />
                    <ActivityIndicator animating={loading} color={colorPalette.primary.main} size={"large"} style={{ marginTop: 10 }} />
                </View>
            }

            <Portal>
                {assessmentSelected && <CaseNavigationModal
                    caseData={selectedAssessmentData}
                    caseDetails={caseDetails}
                    fromAssessment={true}
                    onDismiss={() => setAssessmentSelected(false)}
                    visible={assessmentSelected}
                    onNavButtonPress={handleOnClick}
                    navButtonText={t(selectedAssessmentData && selectedAssessmentData.isComplete ? 'ContinueAssessment:actions:viewAssessment' : 'ContinueAssessment:actions:continueAssessment')} />}
            </Portal>
            {/* {!keyboardIsOpen && ( <Footer /> )} */}
        </SafeAreaView >
    )
}

export default ContinueAssessment;