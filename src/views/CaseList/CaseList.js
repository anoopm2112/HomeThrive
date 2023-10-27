import React, { useEffect, useState } from 'react';
import APIS from '../../common/hooks/useApiCalls';
import colorPalette from '../../theme/Palette';
//import { Searchbar } from 'react-native-paper';
import Header from '../Components/Header';
// import Footer from '../Components/Footer';
import CloseIcon from 'react-native-vector-icons/AntDesign';
import { View, SafeAreaView, Text, Image, TouchableOpacity, FlatList, ActivityIndicator, TextInput, Platform } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useOfflineDataContext } from '../../helpers/OfflineOperationHandler';
import Constants from '../../common/hooks/Constants';
import TitleBar from '../Components/TitleBar';
import { List, Portal } from 'react-native-paper';
import Path from '../../common/Path';
import CaseNavigationModal from '../Components/CaseNavigationModal';
import { useTranslation } from 'react-i18next';
import TextView from '../Components/TextView/TextView';
import { useIsFocused } from '@react-navigation/native';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import { convertHeight } from '../../common/utils/dimensionUtil';

const CaseList = ({ toggleMenu, toggleBellIcon }) => {

    const isFocused = useIsFocused()
    const [caseList, setCaseList] = useState([]);
    const [loading, setLoading] = useState(false);
    const [searchQuery, setSearchQuery] = useState('');
    const navigation = useNavigation()

    const [selectedCaseData, setSelectedCaseData] = useState({})
    const [caseDataSelected, setCaseDataSelected] = useState(false)

    const [caseDetails, setCaseDetails] = useState({})

    const [loadMore, setLoadMore] = useState(false)
    const [pageCount, setPageCount] = useState(1);
    const [page, setPage] = useState(1);


    const { callOfflineOperation, isAppOnline, operationResult } = useOfflineDataContext()

    const { logScreen, hasNewNotifications } = useAuthHandlerContext()

    const InputAccessoryViewID = 'caseListID';

    const { t } = useTranslation()

    useEffect(() => {
        const logScreenAnalytics = () => {
            logScreen(ScreenConfigs.caseList)
        }
        if (isAppOnline) {
            logScreenAnalytics()
        }
    }, [])

    useEffect(() => {
        switch (operationResult.operationKey) {
            case Constants.offlineOperations.getCaseList:
                setCaseList(operationResult.data)
                // console.log("Offline Handler : CaseList >>", operationResult.data)
                setLoading(false)
                return
            case Constants.offlineOperations.getCaseDetail:
                setCaseDetails(operationResult.data)
                setCaseDataSelected(true)
                return
        }
    }, [operationResult])

    useEffect(() => {
        if (loadMore && isAppOnline && page <= pageCount) {
            setLoading(true)
            fetchCaseList()
        }
    }, [loadMore])

    useEffect(() => {
        getCaseList()
    }, [searchQuery, isFocused])

    const fetchCaseList = async () => {
        let payload = {
            "needFullData": searchQuery.length > 0,
            "orderByField": [
                ["id", "ASC"]
            ],
            "globalSearchQuery": searchQuery,
            "rowCount": "10"
        }
        const data = await APIS.CaseList(payload);
        if (data && data.data && data.data.data) {
            let list = data.data.data
            setCaseList([...caseList, ...list])
            setPage(page + 1)
        }
        setLoadMore(false)
        setLoading(false)
    }

    const getCaseList = async () => {
        if (!loading) {
            setLoading(true)
        }

        let payload = {
            "needFullData": searchQuery.length > 0,
            "orderByField": [
                ["id", "ASC"]
            ],
            // "globalSearchQuery": searchQuery,
            "rowCount": "10"
        }

        // console.log("payload is >>", payload)
        try {
            if (isAppOnline) {
                payload.globalSearchQuery = searchQuery;
                const data = await APIS.CaseList(payload);
                if (data && data.data && data.data.data) {
                    let list = data.data.data
                    setCaseList(list)
                    setPageCount(data.data.pageCount)
                    setPage(page + 1)
                    // console.log("list is >>", list)
                    setLoading(false)
                }
            } else {
                payload.globalSearchQuery = searchQuery.replace(/\s/g, "");
                callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getCaseList, { ...payload }))
            }
        } catch (err) {
            console.error(err);
            setLoading(false)
        }
    }


    const getAge = (datestring) => {
        let dob = datestring.split("/");
        let birthdateTimeStamp = new Date(dob[2], dob[1] - 1, dob[0]);
        let cur = new Date();
        let diff = cur - birthdateTimeStamp;
        return Math.floor(diff / 31557600000);
    }

    const searchFilter = (text) => {
        setSearchQuery(text)
        setPage(0)
    }

    const cancelSearch = () => {
        if (searchQuery.length > 0) {
            setSearchQuery('')
            setPage(0)
        }
    }

    const handleOnClick = () => {
        setCaseDataSelected(false)
        navigation.navigate('Assessment',
            {
                caseData: selectedCaseData,
                fromAssessment: false,
                editAssessment: false,
                viewAssessment: false,
                caseDetails: caseDetails
            })
    }

    const handleModalClick = (item) => {
        if (item) {
            setSelectedCaseData(item)
            setLoading(true)
            getDetails(item.id)
        } else {
            // console.log('item >> null')
            setCaseDataSelected(false)
        }
    }

    const getDetails = async (id) => {
        try {
            if (isAppOnline) {
                const data = await APIS.CaseDetails(id);
                if (data && data.data && data.data.data) {
                    // console.log('Case Details >> ', data.data.data)
                    setCaseDetails(data.data.data)
                    setCaseDataSelected(!caseDataSelected)
                    setLoading(false)
                }
            } else {
                callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getCaseDetail, { data: id }))
            }
        } catch (err) {
            console.error(err)
        }
    }

    return (
        <SafeAreaView style={{
            display: "flex",
            flex: 1
        }}>

            <Header
                toggleDrawer={toggleMenu}
                toggleBellIcon={toggleBellIcon}
                hasNewNotifications={hasNewNotifications}
            />

            <TitleBar title={t('CaseList:header')} />
            {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}
            <View style={{ paddingHorizontal: 10 }}>
                <View style={{
                    height: 50,
                    width: "100%",
                    borderRadius: 5,
                    borderWidth: 0.8,
                    borderColor: colorPalette.text.primary,
                    marginVertical: 10,
                    flexDirection: "row",
                    alignItems: "center",
                    alignSelf: "center",
                    paddingHorizontal: 10,
                    //marginHorizontal : 10
                }}>
                    <TextInput style={{
                        height: "100%",
                        width: "90%",
                        paddingLeft: 10,
                        fontSize: 20,
                        color: colorPalette.text.primary
                    }}
                        placeholder={t('Common:label:search')}
                        //autoFocus={true}
                        value={searchQuery}
                        placeholderTextColor={colorPalette.text.primary}
                        underlineColorAndroid={'transparent'}
                        onChangeText={(text) => searchFilter(text)}
                        inputAccessoryViewID={InputAccessoryViewID}
                    >
                    </TextInput>
                    {searchQuery.length > 0 && <TouchableOpacity style={{
                        width: "10%",
                        justifyContent: "center",
                        alignItems: "center"
                    }}
                        onPress={() => cancelSearch()}>
                        <CloseIcon name="close" size={25}
                            color={colorPalette.text.primary} />
                    </TouchableOpacity>}

                </View>
            </View>

            {caseList && caseList.length > 0 ?

                <View style={{
                    display: "flex",
                    flex: 1,
                    paddingHorizontal: 10
                }}>
                    <FlatList
                        style={{ display: "flex", height: "100%" }}
                        data={caseList}
                        showsVerticalScrollIndicator={false}
                        onEndReached={() => setLoadMore(true)}
                        onEndReachedThreshold={0.3}
                        renderItem={({ item, index }) => (
                            <List.Item
                                onPress={() => handleModalClick(item)}
                                style={{
                                    flex: 1,
                                    borderRadius: 10,
                                    borderColor: 'grey',
                                    borderWidth: 1,
                                    backgroundColor: 'white',
                                    marginTop: 10,
                                    marginBottom: index === caseList.length - 1 ? 20 : 0
                                }}
                                descriptionStyle={{ color: 'grey' }}
                                title={`${item.childFirstName} ${item.childLastName} (${getAge(item.childBirthDate)} yo)`}
                                descriptionNumberOfLines={4}
                                description={(props) => <Text {...props}>
                                    {`${t('Common:label:lastReport')}:`} {item.lastReportedDate !== undefined && item.lastReportedDate}{'\n'}<Text style={{ color: colorPalette.text.linkBlue }}>{item.district}, {item.country}</Text></Text>}
                                left={props => <Image {...props}
                                    style={{
                                        height: 60,
                                        width: 60,
                                        borderRadius: 40,
                                        alignSelf: 'center'
                                    }}
                                    source={item.fileUrl !== null &&
                                        item.fileUrl !== undefined ? {
                                        uri: item.fileUrl
                                    } : Path.childImagePlaceholder}
                                />}
                            />
                        )}
                        keyExtractor={(item) => item.id}
                    />
                </View>
                :
                <View style={{
                    display: "flex",
                    flex: 1,
                    justifyContent: "center",
                    alignItems: "center"
                }}>
                    <TextView style={{
                        fontSize: convertHeight(14),
                        marginTop: "20%"
                    }}
                        textObject={searchQuery.length > 0 ? 'CaseList:message:noSearchItems' : 'CaseList:message:noItems'} />
                    <ActivityIndicator
                        animating={loading}
                        color={colorPalette.primary.main}
                        size={"large"}
                        style={{ marginTop: 10 }} />
                </View>
            }
            <Portal>
                {caseDataSelected && <CaseNavigationModal
                    caseData={selectedCaseData}
                    fromAssessment={false}
                    onDismiss={() => setCaseDataSelected(false)}
                    visible={caseDataSelected}
                    onNavButtonPress={handleOnClick}
                    caseDetails={caseDetails}
                    navButtonText={t('CaseList:actions:beginAssessment')} />}
            </Portal>
            {/* <Footer /> */}
        </SafeAreaView>
    )
}

export default CaseList
