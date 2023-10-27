import React, { useEffect, useState } from 'react';
import APIS from '../../common/hooks/useApiCalls';
import colorPalette from '../../theme/Palette';
import Header from '../Components/Header';
import Footer from '../Components/Footer';
import Icon from 'react-native-vector-icons/FontAwesome5';
import FilterIcon from 'react-native-vector-icons/Ionicons';
import CloseIcon from 'react-native-vector-icons/AntDesign';
import { View, SafeAreaView, Text, TouchableOpacity, FlatList, ActivityIndicator, TextInput, Platform, Keyboard, StyleSheet } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useOfflineDataContext } from '../../helpers/OfflineOperationHandler';
import Constants from '../../common/hooks/Constants';
import { useIsFocused } from '@react-navigation/native';
import CaseNavigationModal from '../Components/CaseNavigationModal';
import EventCalendar from '../Components/EventCalendar/EventCalendar';
import { Portal, Snackbar } from 'react-native-paper';
import AssessmentListItem from '../Components/AssessmentListItem/AssessmentListItem';
import TextView from '../Components/TextView/TextView';
import { useTranslation } from "react-i18next";
import moment from 'moment';
import AssessmentFilter from '../Components/AssessmentFilter/AssessmentFilter';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import AsyncStorage from '@react-native-async-storage/async-storage';
import _ from 'lodash';
import { languagesInitialValue } from '../../common/translation/constant';
import { convertHeight } from '../../common/utils/dimensionUtil';
import { LANGUAGE_CODE } from '../../common/constant';

const AssessmentList = ({ toggleMenu, toggleBellIcon }) => {
    const navigation = useNavigation()
    const isFocused = useIsFocused();
    const { t } = useTranslation()
    const { callOfflineOperation, isAppOnline, operationResult } = useOfflineDataContext()
    const { logScreen, hasNewNotifications, currentLanguage, userAllDetails, getCurrentLanguageId, updateAppLanguage, setLoadingModal } = useAuthHandlerContext();

    const [assessments, setAssessments] = useState([]);
    const [fullAssessments, setFullAssessments] = useState([]);
    const [loading, setLoading] = useState(false);
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedAssessmentData, setSelectedAssessmentData] = useState({})
    const [assessmentSelected, setAssessmentSelected] = useState(false)
    const [caseDetails, setCaseDetails] = useState({})

    const [showCalendar, setShowCalendar] = useState(true)
    const [calendarAssessments, setCalendarAssessments] = useState([])
    const [showFilter, setShowFilter] = useState(false)
    const [selectedIsComplete, setSelectedIsComplete] = useState(false)
    const [calendarSelectedDate, setCalendarSelectedDate] = useState('')
    const [currentDate] = useState(moment(new Date()).format("DD/MM/YYYY"))

    const [selectedDateRange, setSelectedDateRange] = useState({ from: "", to: "" })
    const [eventCalendarType, setEventCalendarType] = useState('custom')
    const [isDataError, setIsDataError] = useState(false)
    const [keyboardIsOpen, setKeyboardIsOpen] = useState(false);
    const [fullDataloader, setFullDataloader] = useState(false);

    const InputAccessoryViewID = 'assessmentListID';

    useEffect(() => {
        const logScreenAnalytics = () => { logScreen(ScreenConfigs.upcomingAssessments) }
        if (isAppOnline) { logScreenAnalytics() }
    }, [])

    useEffect(() => {
        setLoadingModal(false);
        getExcludedDateAssessment();
    }, [isFocused, isAppOnline, selectedDateRange]);

    useEffect(() => {
        const keyboardDidShowListener = Keyboard.addListener("keyboardDidShow", () => {
            setKeyboardIsOpen(true);
        });
        const keyboardDidHideListener = Keyboard.addListener("keyboardDidHide", () => {
            setKeyboardIsOpen(false);
        });
        return () => {
            // Anything in here is fired on component unmount.
            keyboardDidHideListener.remove();
            keyboardDidShowListener.remove();
        }
    }, []);

    useEffect(() => {
        if (isFocused) {
            switch (operationResult.operationKey) {
                case Constants.offlineOperations.getAssessmentsList:
                    // Assessment List offline
                    if (operationResult.data.length > 0) {
                        if (isAppOnline) {
                            if (operationResult.data.length > 0) {
                                const allList = [...operationResult.data, ...fullAssessments]
                                setFullAssessments(allList)
                            }
                        } else {
                            console.log(operationResult.data);
                            // Assessment List offline
                            setFullAssessments(operationResult.data)
                        }
                    } 
                    setLoading(false)
                    return
                case Constants.offlineOperations.getCaseDetail:
                    // Case details
                    setCaseDetails(operationResult.data)
                    setAssessmentSelected(true)
                    return
            }
        }
    }, [operationResult, isFocused])

    useEffect(() => {
        setCalendarAssessments(fullAssessments.filter((assessmentItem) => assessmentItem.isComplete === selectedIsComplete))
    }, [fullAssessments, selectedIsComplete])

    useEffect(() => {
        performSearch()
    }, [searchQuery])

    useEffect(() => {
        if (isFocused) {
            getFullAssessment();
            getCurrentUserDetails();
            getCurrentFormVersion();
            setEventCalendarType(selectedDateRange.from !== "" && selectedDateRange.to !== "" ? 'period' : 'custom')
            setLoading(true)
        }
    }, [isFocused, isAppOnline, selectedDateRange])

    const performSearch = (list = null) => {
        if (fullAssessments.length > 0) {
            if (searchQuery.length > 0) {
                const calenderSearch = 
                    fullAssessments.filter((assessmentItem) => assessmentItem.isComplete === selectedIsComplete &&
                    assessmentItem.dateOfAssessment === calendarSelectedDate)
                const data = (list === null ? calenderSearch : list)
                const searchQueryLowerCase = searchQuery.toLowerCase().replace(/\s/g, "");
                setAssessments(data.filter((assessmentItem) => {
                    const fullNameChild = assessmentItem.childFirstName.replace(/\s/g, "") + assessmentItem.childLastName.replace(/\s/g, "");
                    return assessmentItem.caseWorkerFirstName.toLowerCase().includes(searchQueryLowerCase) ||
                        assessmentItem.caseWorkerLastName.toLowerCase().includes(searchQueryLowerCase) || 
                        assessmentItem.childFirstName.toLowerCase().includes(searchQueryLowerCase) ||
                        assessmentItem.childLastName.toLowerCase().includes(searchQueryLowerCase) || 
                        assessmentItem.organizationName.toLowerCase().includes(searchQueryLowerCase) ||
                        fullNameChild.toLowerCase().includes(searchQueryLowerCase)
                }))
            } else {
                setAssessments(fullAssessments.filter((assessmentItem) => assessmentItem.isComplete === selectedIsComplete &&
                    assessmentItem.dateOfAssessment === calendarSelectedDate))
            }
        }
    }

    const getFullAssessment = async () => {
        var firstDayofCurrentMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
        var lastDayofCurrentMonth = new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0);
        let payload = {
            "rowCount": `10`,
            "pageNumber": `1`,
            "needFullData": "true",
            "assessmentStatus": "Active",
            "orderByField": [
                [
                    "dateOfAssessment",
                    "DESC"
                ],
                [
                    "id",
                    "DESC"
                ]
            ],
            "globalSearchQuery": "",
            "isComplete": "",
            // "dateFilterFrom": selectedDateRange.from === undefined ? "" : selectedDateRange.from,
            // "dateFilterTo": selectedDateRange.to === undefined ? "" : selectedDateRange.to,
            "dateFilterFrom": moment(selectedDateRange.from).isValid() ? selectedDateRange.from : "",
            "dateFilterTo": moment(selectedDateRange.to).isValid() ?  selectedDateRange.to : "",
            "loggedInDevice": "mobile"

        }
        if (isAppOnline) {
            const data = await APIS.AssessmentList(payload)
            if (data && data.data && data.data.data) {
                let fullData = data.data.data
                if (selectedDateRange.from != undefined || selectedDateRange.from != "" && selectedDateRange.to != undefined || selectedDateRange.to !== "") {
                    let sortedList = fullData.sort((a, b) => new Date(...a.dateOfAssessment.split('/').reverse()) - new Date(...b.dateOfAssessment.split('/').reverse()));
                    setFullAssessments(fullData)
                } else {
                    setFullAssessments(fullData);
                }
            }
        }
        callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getAssessmentsList, { ...payload }))
    }

    const getExcludedDateAssessment = async () => {
        setFullDataloader(true);
        let payload = {
            "needFullData": "true",
            "assessmentStatus": "Active",
            "orderByField": [["dateOfAssessment", "DESC"],["id", "DESC"]],
            "globalSearchQuery": "",
            "isComplete": "",
            "dateFilterFrom": moment(selectedDateRange.from).isValid() ? selectedDateRange.from : "",
            "dateFilterTo": moment(selectedDateRange.to).isValid() ?  selectedDateRange.to : "",
            "loggedInDevice": "mobile",
        }
        if (!moment(selectedDateRange.from).isValid() && !moment(selectedDateRange.to).isValid()) {
        if (isAppOnline) {
            const data = await APIS.AssessmentList(payload);
            if (data && data.data && data.data.data) {
                let fullData = data.data.data;
                var result = fullData.concat(fullAssessments.filter(bo => fullData.every(ao => ao.id != bo.id)));
                setFullAssessments(result);
            }
        }
        callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getAssessmentsList, { ...payload }))
        setFullDataloader(false);
    }
    }

    const getCurrentUserDetails = async () => {
        const userId = userAllDetails && userAllDetails?.sub;
        if (isAppOnline) {
            const data = await APIS.CurrentUserDetails(userId);
            const userDetailsResult = data.data.userDetails;

            // Previous User language setting
            const PreviousUserLang = data.data.userDetails.HTLanguageId;
            const getPreviousLang = _.find(languagesInitialValue, { id: PreviousUserLang });
            updateAppLanguage(getPreviousLang);

            // User Details
            const CountryStateCityList = await APIS.CountryStateCity(getCurrentLanguageId());
            const OrganizationName = await APIS.OrganizationName(userDetailsResult.HTOrganizationId);
            const Counrties = CountryStateCityList.data.countries;
            const Districts = CountryStateCityList.data.districts;
            const States = CountryStateCityList.data.states;
            const getUserCountry = _.find(Counrties, { id: userDetailsResult.HTCountryId });
            const getUserDistricts = _.find(Districts, { id: userDetailsResult.HTDistrictId });
            const getUserStates = _.find(States, { id: userDetailsResult.HTStateId });
            if (getUserCountry) {
                userDetailsResult.HTCountryName = getUserCountry?.countryName;
            } 
            if (getUserDistricts) {
                userDetailsResult.HTDistrictName = getUserDistricts?.districtName;
            } 
            if (getUserStates) {
                userDetailsResult.HTStateName = getUserStates?.stateName;
            }
            if (OrganizationName) {
                userDetailsResult.HTOrganizationName = OrganizationName?.data?.organizationTypeDetails?.name;
            }
            await AsyncStorage.setItem('currentserDetails', JSON.stringify(userDetailsResult));
        }
    }

    const getCurrentFormVersion = async () => {
        if (isAppOnline) {
            const data = await APIS.FormList();
            if (data && data.data && data.data.data[0]) {
                let details = data.data.data[0];
                await AsyncStorage.setItem('currentFormVersion', JSON.stringify(details.currentRevision));
            }
        }
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
            if (isDataValid(item)) {
                setSelectedAssessmentData(item)
                getAssessmentCaseDetails(item.HTCaseId)
            } else {
                setIsDataError(true)
            }
        } else {
            setAssessmentSelected(false)
        }
    }

    const getAssessmentCaseDetails = async (id) => {
        try {
            if (isAppOnline) {
                const data = await APIS.CaseDetails(id);
                if (data && data.data && data.data.data) {
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

    const isDataValid = (caseData) => {
        try {
            if (isAppOnline) {
                return true
            } else {
                return caseData.formQuestions !== undefined ||
                    data !== undefined || caseData.integrationOptions !== undefined ||
                    caseData.primaryChoices !== undefined
            }
        } catch (eror) {
            return false
        }
    }

    const styles = StyleSheet.create({
        HeaderContainer: {
            display: 'flex',
            flexDirection: 'row',
            alignItems: "center",
            marginTop: 17,
            marginBottom: 10,
            paddingHorizontal: 10,
            justifyContent: 'center'
        },
        calenderIconContainer: {
            position: 'absolute',
            right: 0,
            alignItems: 'center',
            width: 60
        },
        textBoxContainer: {
            flex: 1,
            borderRadius: 5,
            borderWidth: 0.8,
            borderColor: colorPalette.text.primary,
            flexDirection: "row",
            alignItems: "center",
            alignSelf: "center",
            width: '100%'
        },
        closeBtnContainer: {
            width: "10%",
            justifyContent: "center",
            alignItems: "center"
        },
        flatlistContainer: {
            display: "flex",
            flex: 1,
            paddingHorizontal: 10
        },
        noItemMsgContainer: {
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            flex: 1
        },
        loader: {
            marginTop: 10,
            backgroundColor: 'transparent',
            borderRadius: 10,
            position: 'absolute',
            top: 0, left: 0, right: 0, bottom: 0,
        }
    });


    return (
        <SafeAreaView style={{ display: "flex", flex: 1 }}>
            <Header toggleDrawer={toggleMenu} toggleBellIcon={toggleBellIcon} hasNewNotifications={hasNewNotifications} />
            <KeyboardAwareScrollView keyboardShouldPersistTaps="handled" showsVerticalScrollIndicator={false}>
                <View style={styles.HeaderContainer}>
                    <TextView style={{ fontSize: currentLanguage.languageCode == LANGUAGE_CODE.LANG_TAMIL ? convertHeight(14) : convertHeight(17), fontWeight: "500", color: '#000000' }} textObject={'AssessmentList:header'} />
                    <View style={styles.calenderIconContainer}>
                        <Icon name={showCalendar ? 'calendar' : 'calendar-alt'} color={'#052536'} size={20} onPress={() => setShowCalendar(!showCalendar)} />
                    </View>
                </View>

                <EventCalendar
                    displayType={eventCalendarType}
                    showCalendar={showCalendar}
                    assessments={calendarAssessments}
                    events={[]}
                    dateRange={selectedDateRange}
                    currentLanguage={currentLanguage.languageCode}
                    selectedDateAssessments={(list, date) => {
                        setCalendarSelectedDate(date)
                        if (searchQuery.length > 0) {
                            performSearch(list)
                        } else {
                            setAssessments(list)
                        }
                    }}
                    fullDataloader={fullDataloader}
                />

                {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}
                <View style={{ paddingHorizontal: 10, paddingVertical: 10 }}>
                    <View style={{ flexDirection: 'row' }}>
                        <View style={styles.textBoxContainer}>
                            <TextInput
                                style={{ paddingLeft: 10, fontSize: convertHeight(14), color: colorPalette.text.primary, flex: 1 }}
                                placeholder={t('Common:label:search')}
                                value={searchQuery}
                                underlineColorAndroid={'transparent'}
                                onChangeText={(text) => setSearchQuery(text)}
                                inputAccessoryViewID={InputAccessoryViewID}
                            />
                            {searchQuery.length > 0 &&
                                <TouchableOpacity style={styles.closeBtnContainer} onPress={() => cancelSearch()}>
                                    <CloseIcon name="close" size={25} color={colorPalette.text.primary} />
                                </TouchableOpacity>
                            }
                        </View>
                        <FilterIcon name={'filter'} color={'#052536'} size={20} style={{ padding: 10, alignSelf: 'center' }} onPress={() => setShowFilter(!showFilter)} />
                    </View>
                </View>

                {!loading && <Text style={{ marginHorizontal: 14, fontWeight: 'bold' }}>
                    {eventCalendarType === 'custom' ?
                        (currentDate === calendarSelectedDate ? t('month:today') : `${t(`${'month:'}${moment(calendarSelectedDate, 'DD/MM/YYYY').format("MMMM")}`)} ${moment(calendarSelectedDate, 'DD/MM/YYYY').format("DD, YYYY")}`)
                        :
                        `${t(`${'month:'}${moment(selectedDateRange.from).format("MMMM")}`)} ${moment(selectedDateRange.from).format("DD, YYYY")} - ${t(`${'month:'}${moment(selectedDateRange.to).format("MMMM")}`)} ${moment(selectedDateRange.to).format("DD, YYYY")}`
                    }
                </Text>}

                {assessments && assessments.length > 0 ?
                    <View style={styles.flatlistContainer}>
                        {assessments.map((item, index) => {
                            return (
                                <View key={index} style={{ paddingBottom: 12 }}>
                                    <AssessmentListItem
                                        item={item}
                                        index={index}
                                        totalAssesments={assessments.length}
                                        onSelectAssessment={() => handleModalAssessmentList(item)} />
                                </View>
                            )
                        })}
                    </View>
                    :
                    <View style={styles.noItemMsgContainer}>
                        <TextView
                            textObject={searchQuery.length > 0 ? 'AssessmentList:message:noSearchItems' : 'AssessmentList:message:noItems'}
                            style={{ fontSize: convertHeight(14), marginTop: "20%" }} />
                    </View>
                }

                <Portal>
                    {assessmentSelected &&
                        <CaseNavigationModal
                            caseData={selectedAssessmentData}
                            caseDetails={caseDetails}
                            fromAssessment={true}
                            onDismiss={() => setAssessmentSelected(false)}
                            visible={assessmentSelected}
                            onNavButtonPress={handleOnClick}
                            navButtonText={selectedAssessmentData && selectedAssessmentData.isComplete ? 'AssessmentList:actions:viewAssessment' : 'AssessmentList:actions:continueAssessment'}
                        />
                    }

                    {showFilter &&
                        <AssessmentFilter
                            visible={showFilter}
                            assessmentStatus={selectedIsComplete}
                            setAssessmentStatus={setSelectedIsComplete}
                            dateRange={selectedDateRange}
                            onApply={(data) => {
                                setSelectedIsComplete(data.assessmentStatus)
                                if (selectedDateRange.from !== data.from || selectedDateRange.to !== data.to) {
                                    setSelectedDateRange({ from: data.from, to: data.to })
                                }
                            }}
                            onDismiss={() => setShowFilter(false)}
                        />
                    }
                </Portal>
            </KeyboardAwareScrollView>
            {/* {!keyboardIsOpen && ( <Footer /> )} */}
            {loading && <ActivityIndicator animating={loading} color={colorPalette.primary.main} size={"large"} style={styles.loader} />}
            {isDataError &&
                <Snackbar visible={isDataError} onDismiss={() => setIsDataError(false)}>
                    {t('AssessmentList:message:dataError:part1')}{'\n'}{t('AssessmentList:message:dataError:part2')}
                </Snackbar>
            }
        </SafeAreaView >
    )
}

export default AssessmentList
