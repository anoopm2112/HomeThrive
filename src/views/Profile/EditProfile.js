import React, { useEffect, useState, useCallback } from 'react';
import { View, SafeAreaView, Text, Image, TouchableOpacity, ActivityIndicator, StyleSheet, Platform } from 'react-native';
import colorPalette from '../../theme/Palette';
import { useTranslation } from 'react-i18next';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useIsFocused } from '@react-navigation/native';
import { TextInput, Snackbar, HelperText } from 'react-native-paper';
import DropDown from "react-native-paper-dropdown";
import { launchImageLibrary } from 'react-native-image-picker';
import _ from 'lodash';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
// custom imports
import Path from '../../common/Path';
import Header from '../Components/Header';
import TitleBar from '../Components/TitleBar';
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';
import APIS from '../../common/hooks/useApiCalls';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import { LANGUAGE_CODE } from '../../common/constant';

const EditProfile = (props) => {
    const { navigation, toggleMenu, toggleBellIcon } = props;
    const { userData } = props.route.params;
    const { t } = useTranslation();
    const isFocused = useIsFocused();
    const { getCurrentLanguageId, currentLanguage } = useAuthHandlerContext();

    // Full List
    const [allCountryArray, setAllCountryArray] = useState();
    const [allStateArray, setAllStateArray] = useState([]);
    const [allDistrictArray, setAllDistrictArray] = useState([]);

    // Dropdown
    const [countryListVisible, setCountryListVisible] = useState(false);
    const [stateListVisible, setStateListVisible] = useState(false);
    const [districtListVisible, setDistrictListVisible] = useState(false);

    // Component value
    const [firstNameValue, setFirstNameValue] = useState(userData?.firstName);
    const [lastNameValue, setLastNameValue] = useState(userData?.lastName);
    const [cityValue, setCityValue] = useState(userData?.city);
    const [countryListValue, setCountryListValue] = useState('');
    const [stateListValue, setStateListValue] = useState('');
    const [districtListValue, setDistrictListValue] = useState('');
    const [zipCodeValue, setZipCodeValue] = useState(userData?.zipCode);
    const [address1Value, setAddress1Value] = useState(userData?.addressLine1);
    const [address2Value, setAddress2Value] = useState(userData?.addressLine2);
    const [phoneValue, setPhoneValue] = useState(userData?.phoneNumber);

    // Manipulate Arrays for dropdown
    const [countryListArray, setCountryListArray] = useState([]);
    const [stateListArray, setStateListArray] = useState([]);
    const [districtListArray, setDistrictListArray] = useState([]);

    //Image Setting
    const [fileImageURI, setFileImageURI] = useState();
    const [isImageProcessCompleted, setIsImageProcessCompleted] = useState();
    const [isImageDeleteProcessCompleted, setIsImageDeleteProcessCompleted] = useState();
    const [isEditDetailsProcessCompleted, setIsEditDetailsProcessCompleted] = useState();

    const [isLoading, setIsLoading] = useState(false);
    const [isLoadingImage, setIsLoadingImage] = useState(false);
    const [isBlurInput, setIsBlurInput] = useState(false);

    // Form Validation
    const [valFirstName, setValFirstName] = useState(false);
    const [valLastName, setValLastName] = useState(false);
    const [valCity, setValCity] = useState(false);
    const [valZipCode, setValZipCode] = useState(false);
    const [valAddress1, setValAddress1] = useState(false);
    const [valPhone, setValPhone] = useState(false);
    const [valCountry, setValCountry] = useState(false);
    const [valState, setValState] = useState(false);
    const [valDistrict, setValDistrict] = useState(false);

    const InputAccessoryViewID = 'editProfileID';

    useEffect(() => {
        if (isFocused) {
            const fetchCountryStateCity = async () => {
                setIsLoading(true);
                const CountryStateCityList = await APIS.CountryStateCity(getCurrentLanguageId());
                // set all arrays
                setAllCountryArray(CountryStateCityList.data.countries);
                setAllStateArray(CountryStateCityList.data.states);
                setAllDistrictArray(CountryStateCityList.data.districts);

                // Country Operations
                const countryList = CountryStateCityList.data.countries;
                // current country set in dropdown
                const getUserCountryValue = _.find(countryList, { id: userData.HTCountryId });
                setCountryListValue(getUserCountryValue.id.toString());
                // Manipulate country dropdown list to label and value
                var manipulateCountryList = countryList.map((item) => ({ label: item.countryName, value: item.id }));
                setCountryListArray(manipulateCountryList);

                // State Operations
                const stateList = CountryStateCityList.data.states;
                // current state set in dropdown
                const getUserStateValue = _.find(stateList, { id: userData.HTStateId });
                setStateListValue(getUserStateValue.id.toString());
                // Manipulate state dropdown list to label and value
                var manipulateStateList = stateList.map((item) => ({ label: item.stateName, value: item.id }));
                setStateListArray(manipulateStateList);

                // District Operations
                const districtList = CountryStateCityList.data.districts;
                // current district set in dropdown
                const getUserDistrictValue = _.find(districtList, { id: userData.HTDistrictId });
                setDistrictListValue(getUserDistrictValue.id.toString());
                // Manipulate district dropdown list to label and value
                var manipulateDistrictList = districtList.map((item) => ({ label: item.districtName, value: item.id, stateId: item.HTStateId }));
                // filter district by state
                const filterDistrict = _.filter(manipulateDistrictList, { stateId: getUserStateValue.id.toString() });
                setDistrictListArray(filterDistrict);

                setIsLoading(false);
            }
            fetchCountryStateCity();
        }
    }, [isFocused]);

    const handleInputBlur = (fName) => {
        if (fName === 'city') {
            setIsBlurInput(false);
        } else if (fName === 'zipcode') {
            setIsBlurInput(false);
        } else if (fName === 'addressFirst') {
            setIsBlurInput(false);
        } else if (fName === 'addressSecond') {
            setIsBlurInput(false);
        } else if (fName === 'phone') {
            setIsBlurInput(false);
        }
    };
    const handleInputFocus = (fName) => {
        if (fName === 'city') {
            setIsBlurInput(true);
        } else if (fName === 'zipcode') {
            setIsBlurInput(true);
        } else if (fName === 'addressFirst') {
            setIsBlurInput(true);
        } else if (fName === 'addressSecond') {
            setIsBlurInput(true);
        } else if (fName === 'phone') {
            setIsBlurInput(true);
        }
    };

    const handleChangeState = (value) => {
        const filterDistrict = _.filter(allDistrictArray, { HTStateId: value });
        var manipulateDistrictList = filterDistrict.map((item) => ({ label: item.districtName, value: item.id, stateId: item.HTStateId }));
        setDistrictListArray(manipulateDistrictList);
        setDistrictListValue(manipulateDistrictList[0].value.toString());
    }

    const handleEditSubmit = async () => {
        if (firstNameValue === '') {
            setValFirstName(true);
        } else if (lastNameValue === '') {
            setValLastName(true);
        } else if (cityValue === '') {
            setValCity(true);
        } else if (address1Value === '') {
            setValAddress1(true);
        } else if (phoneValue.length < 13) {
            setValPhone(true);
        } else if (zipCodeValue === '') {
            setValZipCode(true);
        } else if (countryListValue === '') {
            setValCountry(true);
        } else if (stateListValue === '') {
            setValState(true);
        } else if (districtListValue === '') {
            setValDistrict(true);
        } else {

            setIsLoading(true);

            let payload = {
                "HTCountryId": countryListValue,
                "HTDistrictId": districtListValue,
                "HTLanguageId": currentLanguage.id,
                "HTOrganizationId": userData?.HTOrganizationId,
                "HTStateId": stateListValue,
                "HTUserRoleId": userData?.HTUserRoleId,
                "addressLine1": address1Value,
                "addressLine2": address2Value,
                "city": cityValue,
                "email": userData?.email,
                "firstName": firstNameValue,
                "id": userData?.id,
                "lastName": lastNameValue,
                "phoneNumber": phoneValue,
                "zipCode": zipCodeValue
            };
            const editResponse = await APIS.UserProfileEdit(payload);
            if (editResponse.status) {
                setIsEditDetailsProcessCompleted(true);
            } else {
                setIsEditDetailsProcessCompleted(false);
            }

            const getUserCountry = _.find(allCountryArray, { id: countryListValue.toString() });
            const getUserStates = _.find(allStateArray, { id: payload.HTStateId });
            const getUserDistricts = _.find(allDistrictArray, { id: payload.HTDistrictId });
            if (getUserCountry) {
                payload.HTCountryName = getUserCountry?.countryName;
            }
            if (getUserDistricts) {
                payload.HTDistrictName = getUserDistricts?.districtName;
            }
            if (getUserStates) {
                payload.HTStateName = getUserStates?.stateName;
            }
            if (userData?.HTOrganizationName) {
                payload.HTOrganizationName = userData?.HTOrganizationName
            }
            if (userData?.fileUrl) {
                payload.fileUrl = userData?.fileUrl
            }
            await AsyncStorage.setItem('currentserDetails', JSON.stringify(payload));

            setIsLoading(false);

            setTimeout(() => {
                navigation.goBack();
            }, 1000)
        }
    }

    const removeUserImage = async () => {
        setIsLoadingImage(true);

        let payload = {
            moduleType: 'user',
            documentType: 'profile-image',
            moduleId: `${userData?.id}`,
        }

        const result = await APIS.DeleteProfileImage(payload);
        if (result && result.data && result.status === 200) {
            setFileImageURI(null);
            userData.fileUrl = null;
            await AsyncStorage.setItem('currentserDetails', JSON.stringify(userData));
            setIsImageDeleteProcessCompleted(true);
        } else {
            setIsImageDeleteProcessCompleted(false);
        }

        setIsLoadingImage(false);
    }

    const changeUserImage = async () => {
        const result = await launchImageLibrary({ includeBase64: true });
        if (result.didCancel) {
            // User Cancel
        } else {
            setFileImageURI(result.assets[0].uri);
            if (fileImageURI && userData?.fileUrl) {
                // Update signed URL
                getUpdatedSignedURL(result.assets[0], userData?.id, true);
            } else {
                // New signed URL
                getUpdatedSignedURL(result.assets[0], userData?.id);
            }
        }
    }

    const getUpdatedSignedURL = useCallback(async (value, id, type) => {
        setIsLoadingImage(true);
        // New Function
        try {
            let finalPayload = {
                moduleType: 'user',
                documentType: 'profile-image',
                moduleId: `${id}`,
                fileName: `${value.fileName}`,
                fileSize: `${value.fileSize / 1024}`,
                description: 'profile picture',
            }
            let data;
            if (type) {
                finalPayload.documentId = `${userData.fileUploadMappingId}`
                data = await APIS.UploadUpdatedFile(finalPayload);
            } else {
                data = await APIS.UploadFile(finalPayload);
            }
            // const data = await APIS.UploadUpdatedFile(finalPayload);
            if (data.status === 200) {
                fileUpload(value, data.data.signedUrl);
            } else {
                console.log('An Error occurred');
            }
        } catch (err) {
            console.error(err);
        }
    }, []);

    const fileUpload = useCallback(async (selectedFile, signedURL) => {
        const response = await fetch(signedURL, {
            method: 'put',
            headers: {
                'Content-Type': selectedFile.type
            },
            body: { uri: selectedFile.uri }
        });

        setIsLoadingImage(false);
        if (response.status === 200) {
            setIsImageProcessCompleted(true);
            if (response.uri) {
                userData.fileUrl = response.url
            }
            await AsyncStorage.setItem('currentserDetails', JSON.stringify(userData));
        } else {
            setIsImageProcessCompleted(false);
        }
    });

    const phoneFormat = (phNumber) => {
        if (phNumber === '' || phNumber.length === 1 || phNumber.length === 2 || phNumber.length === 3) {
            setPhoneValue('+91');
        } else {
            setPhoneValue(phNumber);
        }
        setValPhone(false);
    }

    const styles = StyleSheet.create({
        mainContainer: {
            backgroundColor: "#FFFFFF",
            borderRadius: convertHeight(5),
            margin: convertHeight(10),
            shadowColor: '#000',
            shadowOffset: { width: 0, height: 3 },
            shadowOpacity: 0.5,
            shadowRadius: 3,
            elevation: 4,
            paddingVertical: convertHeight(10)
        },
        nameContainer: {
            flexDirection: 'row',
            justifyContent: 'space-between',
            paddingHorizontal: convertWidth(7)
        },
        userIcon: {
            height: convertHeight(85),
            width: convertHeight(85),
            borderRadius: convertHeight(85)
        },
        editProfileBtnContainer: {
            backgroundColor: colorPalette.primary.main,
            justifyContent: 'center',
            alignItems: 'center',
            // height: convertHeight(40),
            margin: convertWidth(7),
            marginTop: convertHeight(15),
            borderRadius: 10
        },
        cancelProfileChangesBtnContainer: {
            // backgroundColor: colorPalette.primary.main,
            justifyContent: 'center',
            alignItems: 'center',
            // height: convertHeight(40),
            margin: convertWidth(7),
            marginTop: convertHeight(10),
            borderRadius: 10,
            borderWidth: 1,
            borderColor: '#B7B7B7'
        },
        activitIndicatorStyle: {
            position: 'absolute',
            zIndex: 1000,
            left: 0,
            right: 0,
            top: 0,
            bottom: 0
        },
        actionlabel: {
            textDecorationLine: 'underline',
            marginTop: convertHeight(4),
            color: colorPalette.primary.main
        }
    });

    return (
        <SafeAreaView style={{ flex: 1 }}>
            <Header toggleDrawer={toggleMenu} toggleBellIcon={toggleBellIcon} />
            <TitleBar goBack={() => navigation.goBack()} title={'Profile:label:editProfile'} hideBack={false} />
            {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}
            <KeyboardAwareScrollView keyboardShouldPersistTaps="handled" showsVerticalScrollIndicator={false} extraHeight={isBlurInput && Platform.OS === 'ios' ? 320 : 0}>
                <View pointerEvents={isLoading ? 'none' : 'auto'} style={styles.mainContainer}>
                    <View style={{ alignItems: 'center', paddingBottom: convertHeight(10) }}>
                        <ActivityIndicator style={styles.activitIndicatorStyle} size="large" color={colorPalette.primary.main} animating={isLoadingImage} />
                        {fileImageURI || userData?.fileUrl ?
                            <Image source={{ uri: fileImageURI ? fileImageURI : userData?.fileUrl }} style={styles.userIcon} />
                            :
                            <Image style={styles.userIcon} source={Path.childImagePlaceholder} resizeMode={'contain'} />
                        }
                    </View>
                    {!isLoadingImage &&
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingBottom: convertHeight(10) }}>
                            <TouchableOpacity style={{ width: '50%' }} onPress={() => changeUserImage()}>
                                <Text style={[styles.actionlabel, { paddingRight: convertWidth(8), textAlign: 'right' }]}>{fileImageURI || userData?.fileUrl ? t('Profile:message:changeImage') : t('Profile:message:selectImage')}</Text>
                            </TouchableOpacity>
                            {fileImageURI || userData?.fileUrl ?
                                <TouchableOpacity style={{ width: '50%' }} onPress={() => removeUserImage()}>
                                    <Text style={[styles.actionlabel, { paddingLeft: convertWidth(8), textAlign: 'left' }]}>{t('Profile:message:removeImage')}</Text>
                                </TouchableOpacity> : null}
                        </View>}
                    <View style={styles.nameContainer}>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <TextInput
                                value={firstNameValue}
                                style={{ width: convertWidth(155) }}
                                mode='outlined'
                                label={`${t('Profile:label:firstName')} ${'*'}`}
                                onChangeText={(text) => {
                                    setFirstNameValue(text);
                                    setValFirstName(false);
                                }}
                                inputAccessoryViewID={InputAccessoryViewID}
                            />
                            {valFirstName &&
                                <HelperText type="error" visible={valFirstName}>
                                    {t('Profile:validationMessage:firstnameRequired')}
                                </HelperText>}
                        </View>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <TextInput
                                value={lastNameValue}
                                style={{ width: convertWidth(160) }}
                                mode='outlined'
                                label={`${t('Profile:label:lastName')} ${'*'}`}
                                onChangeText={(text) => {
                                    setLastNameValue(text);
                                    setValLastName(false);
                                }}
                                inputAccessoryViewID={InputAccessoryViewID}
                            />
                            {valLastName &&
                                <HelperText type="error" visible={valLastName}>
                                    {t('Profile:validationMessage:lastnameRequired')}
                                </HelperText>}
                        </View>
                    </View>
                    <View style={{ paddingTop: convertHeight(10), paddingHorizontal: convertWidth(7) }}>
                        <DropDown
                            label={`${t('Profile:label:country')} ${'*'}`}
                            mode={"outlined"}
                            visible={countryListVisible}
                            showDropDown={() => setCountryListVisible(true)}
                            onDismiss={() => setCountryListVisible(false)}
                            value={countryListValue}
                            setValue={(value) => {
                                setCountryListValue(value);
                                setValCountry(false);
                            }}
                            list={countryListArray}
                            theme={{
                                colors: {
                                    placeholder: countryListVisible ? colorPalette.primary.main : '#000000'
                                }
                            }}
                        />
                        {valCountry &&
                            <HelperText type="error" visible={valCountry}>
                                {t('Profile:validationMessage:countryRequired')}
                            </HelperText>}
                    </View>
                    <View style={{ paddingTop: convertHeight(10), paddingHorizontal: convertWidth(7) }}>
                        <DropDown
                            label={`${t('Profile:label:regionState')} ${'*'}`}
                            mode={"outlined"}
                            visible={stateListVisible}
                            showDropDown={() => setStateListVisible(true)}
                            onDismiss={() => setStateListVisible(false)}
                            value={stateListValue}
                            setValue={(value) => {
                                setStateListValue(value);
                                handleChangeState(value);
                                setValState(false);
                            }}
                            list={stateListArray}
                            theme={{
                                colors: {
                                    placeholder: stateListVisible ? colorPalette.primary.main : '#000000'
                                }
                            }}
                        />
                        {valState &&
                            <HelperText type="error" visible={valState}>
                                {t('Profile:validationMessage:stateRequired')}
                            </HelperText>}
                    </View>
                    {isLoading &&
                        <View style={{ position: 'absolute', top: 325, left: 160 }}>
                            <ActivityIndicator size="large" color={colorPalette.primary.main} animating={isLoading} />
                        </View>}
                    <View style={{ paddingTop: convertHeight(10), paddingHorizontal: convertWidth(7) }}>
                        <DropDown
                            label={`${t('Profile:label:districtCounty')} ${'*'}`}
                            mode={"outlined"}
                            visible={districtListVisible}
                            showDropDown={() => setDistrictListVisible(true)}
                            onDismiss={() => setDistrictListVisible(false)}
                            value={districtListValue}
                            setValue={(value) => {
                                setDistrictListValue(value);
                                setValDistrict(false);
                            }}
                            list={districtListArray}
                            theme={{
                                colors: {
                                    placeholder: districtListVisible ? colorPalette.primary.main : '#000000'
                                }
                            }}
                        />
                        {valDistrict &&
                            <HelperText type="error" visible={valDistrict}>
                                {t('Profile:validationMessage:districtRequired')}
                            </HelperText>}
                    </View>
                    <View style={[styles.nameContainer, { paddingTop: convertHeight(10) }]}>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <TextInput
                                value={cityValue}
                                style={{ width: convertWidth(155) }}
                                mode='outlined'
                                label={`${t('Profile:label:city')} ${'*'}`}
                                onChangeText={(text) => {
                                    setCityValue(text);
                                    setValCity(false);
                                }}
                                inputAccessoryViewID={InputAccessoryViewID}
                                onBlur={() => handleInputBlur('city')}
                                onFocus={() => handleInputFocus('city')}
                            />
                            {valCity &&
                                <HelperText type="error" visible={valCity}>
                                    {t('Profile:validationMessage:cityRequired')}
                                </HelperText>}
                        </View>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <TextInput
                                value={zipCodeValue}
                                maxLength={6}
                                style={{ width: convertWidth(160) }}
                                mode='outlined'
                                label={`${t('Profile:label:zipcode')} ${'*'}`}
                                onChangeText={(text) => {
                                    setZipCodeValue(text);
                                    setValZipCode(false);
                                }}
                                inputAccessoryViewID={InputAccessoryViewID}
                                onBlur={() => handleInputBlur('zipcode')}
                                onFocus={() => handleInputFocus('zipcode')}
                            />
                            {valZipCode &&
                                <HelperText type="error" visible={valZipCode}>
                                    {t('Profile:validationMessage:zipCodeRequired')}
                                </HelperText>}
                        </View>
                    </View>
                    <View style={[styles.nameContainer, { paddingTop: convertHeight(10) }]}>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <TextInput
                                value={address1Value}
                                style={{ width: convertWidth(155), textAlign: 'auto' }}
                                mode='outlined'
                                label={`${t('Profile:label:Address1')} ${'*'}`}
                                onChangeText={(text) => {
                                    setAddress1Value(text);
                                    setValAddress1(false);
                                }}
                                inputAccessoryViewID={InputAccessoryViewID}
                                onBlur={() => handleInputBlur('addressFirst')}
                                onFocus={() => handleInputFocus('addressFirst')}
                            />
                            {valAddress1 &&
                                <HelperText type="error" visible={valAddress1}>
                                    {t('Profile:validationMessage:address1Required')}
                                </HelperText>}
                        </View>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <TextInput
                                value={address2Value}
                                style={{ width: convertWidth(160), textAlign: 'auto' }}
                                mode='outlined'
                                label={t('Profile:label:Address2')}
                                onChangeText={(text) => setAddress2Value(text)}
                                inputAccessoryViewID={InputAccessoryViewID}
                                onBlur={() => handleInputBlur('addressSecond')}
                                onFocus={() => handleInputFocus('addressSecond')}
                            />
                        </View>
                    </View>
                    <View style={[styles.nameContainer, { paddingTop: convertHeight(10) }]}>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <TextInput
                                value={phoneValue}
                                maxLength={13}
                                mode='outlined'
                                label={`${t('Profile:label:phone')} ${'*'}`}
                                onChangeText={(text) => phoneFormat(text)}
                                inputAccessoryViewID={InputAccessoryViewID}
                                keyboardType={'phone-pad'}
                                onBlur={() => handleInputBlur('phone')}
                                onFocus={() => handleInputFocus('phone')}
                            />
                            {valPhone &&
                                <HelperText type="error" visible={valPhone}>
                                    {
                                        phoneValue === '' ? t('Profile:validationMessage:phoneRequired') :
                                            phoneValue.length < 13 ? t('Profile:validationMessage:validPhoneRequired') : ''
                                    }
                                </HelperText>}
                        </View>
                    </View>

                    <TouchableOpacity onPress={() => handleEditSubmit()} style={styles.editProfileBtnContainer}>
                        <Text style={{ color: '#FFFFFF', fontWeight: 'bold', paddingVertical: convertHeight(11), paddingHorizontal: convertWidth(6) }}>{t('Profile:label:saveChanges')}</Text>
                    </TouchableOpacity>

                    <TouchableOpacity onPress={() => navigation.goBack()} style={styles.cancelProfileChangesBtnContainer}>
                        <Text style={{ color: '#F27123', fontWeight: '500', paddingVertical: convertHeight(11), paddingHorizontal: convertWidth(6) }}>{t('Profile:label:cancelChanges')}</Text>
                    </TouchableOpacity>
                </View>
            </KeyboardAwareScrollView>

            {/* EDIT PROFILE TOAST ENGLISH */}

            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH &&
                <Snackbar duration={1000} visible={isImageProcessCompleted} onDismiss={() => setIsImageProcessCompleted()}
                    action={{ label: 'close', onPress: () => { setIsImageProcessCompleted() } }}>
                    {isImageProcessCompleted ? <Text>Image uploaded successfully</Text> : <Text>Something went wrong, Please try again.</Text>}
                </Snackbar>}
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH &&
                <Snackbar onDismiss={() => setIsEditDetailsProcessCompleted()} duration={1000} visible={isEditDetailsProcessCompleted}
                    action={{ label: 'close', onPress: () => { setIsEditDetailsProcessCompleted() } }}>
                    {isEditDetailsProcessCompleted ? <Text>User updated successfully</Text> : <Text>Something went wrong, Please try again.</Text>}
                </Snackbar>}
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH &&
                <Snackbar onDismiss={() => setIsImageDeleteProcessCompleted()} duration={1000} visible={isImageDeleteProcessCompleted}
                    action={{ label: 'close', onPress: () => { setIsImageDeleteProcessCompleted() } }}>
                    {isImageDeleteProcessCompleted ? <Text>Image removed successfully</Text> : <Text>Something went wrong, Please try again.</Text>}
                </Snackbar>}

            {/* EDIT PROFILE TOAST HINDI */}

            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI &&
                <Snackbar duration={1000} visible={isImageProcessCompleted} onDismiss={() => setIsImageProcessCompleted()}
                    action={{ label: 'close', onPress: () => { setIsImageProcessCompleted() } }}>
                    {isImageProcessCompleted ? <Text>छवि सफलतापूर्वक अपलोड की गई</Text> : <Text>कुछ गड़बड़ हुई है। कृपया दोबारा प्रयास करें।</Text>}
                </Snackbar>}
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI &&
                <Snackbar onDismiss={() => setIsEditDetailsProcessCompleted()} duration={1000} visible={isEditDetailsProcessCompleted}
                    action={{ label: 'close', onPress: () => { setIsEditDetailsProcessCompleted() } }}>
                    {isEditDetailsProcessCompleted ? <Text>उपयोगकर्ता सफलतापूर्वक संपादित किया गया</Text> : <Text>कुछ गड़बड़ हुई है। कृपया दोबारा प्रयास करें।</Text>}
                </Snackbar>}
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI &&
                <Snackbar onDismiss={() => setIsImageDeleteProcessCompleted()} duration={1000} visible={isImageDeleteProcessCompleted}
                    action={{ label: 'close', onPress: () => { setIsImageDeleteProcessCompleted() } }}>
                    {isImageDeleteProcessCompleted ? <Text>छवि सफलतापूर्वक हटाई गई</Text> : <Text>कुछ गड़बड़ हुई है। कृपया दोबारा प्रयास करें।</Text>}
                </Snackbar>}

            {/* EDIT PROFILE TOAST TAMIL */}

            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_TAMIL &&
                <Snackbar duration={1000} visible={isImageProcessCompleted} onDismiss={() => setIsImageProcessCompleted()}
                    action={{ label: 'close', onPress: () => { setIsImageProcessCompleted() } }}>
                    {isImageProcessCompleted ? <Text>படம் வெற்றிகரமாக பதிவேற்றப்பட்டது</Text> : <Text>ஏதோ தவறாகிவிட்டது, மீண்டும் முயற்சிக்கவும்.</Text>}
                </Snackbar>}
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_TAMIL &&
                <Snackbar onDismiss={() => setIsEditDetailsProcessCompleted()} duration={1000} visible={isEditDetailsProcessCompleted}
                    action={{ label: 'close', onPress: () => { setIsEditDetailsProcessCompleted() } }}>
                    {isEditDetailsProcessCompleted ? <Text>பயனர் வெற்றிகரமாக புதுப்பிக்கப்பட்டார்</Text> : <Text>ஏதோ தவறாகிவிட்டது, மீண்டும் முயற்சிக்கவும்.</Text>}
                </Snackbar>}
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_TAMIL &&
                <Snackbar onDismiss={() => setIsImageDeleteProcessCompleted()} duration={1000} visible={isImageDeleteProcessCompleted}
                    action={{ label: 'close', onPress: () => { setIsImageDeleteProcessCompleted() } }}>
                    {isImageDeleteProcessCompleted ? <Text>படம் வெற்றிகரமாக அகற்றப்பட்டது</Text> : <Text>ஏதோ தவறாகிவிட்டது, மீண்டும் முயற்சிக்கவும்.</Text>}
                </Snackbar>}

        </SafeAreaView>
    )
}

export default EditProfile; 