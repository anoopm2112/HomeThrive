import React, { useEffect, useState } from 'react';
import { View, SafeAreaView, Text, Image, TouchableOpacity, ScrollView, Alert, StyleSheet, ActivityIndicator } from 'react-native';
import colorPalette from '../../theme/Palette';
import { useTranslation } from 'react-i18next';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useIsFocused } from '@react-navigation/native';
import AntDesignIcon from 'react-native-vector-icons/AntDesign';
// custom imports
import Path from '../../common/Path';
import Header from '../Components/Header';
import TitleBar from '../Components/TitleBar';
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import APIS from '../../common/hooks/useApiCalls';

const Profile = ({ navigation, toggleMenu, toggleBellIcon }) => {
    const { t } = useTranslation();
    const isFocused = useIsFocused();
    const { isAppOnline, userAllDetails, setShowLanguagePrompt } = useAuthHandlerContext();
    const [currentUserDetails, setCurrentUserDetails] = useState({});
    const [userProfileImg, setUserProfileImg] = useState();
    const [imageLoader, setImageLoader] = useState(false);

    useEffect(() => {
        if (isFocused) {
            const fetchUserDetails = async () => {
                const userDetails = await AsyncStorage.getItem('currentserDetails');
                setCurrentUserDetails(JSON.parse(userDetails));
                if (isAppOnline) {
                    const userId = userAllDetails && userAllDetails?.sub;
                    setImageLoader(true);
                    const data = await APIS.CurrentUserDetails(userId);
                    const userDetailsProfileImgResult = data.data.userDetails.fileUrl;
                    if (userDetailsProfileImgResult) {
                        setUserProfileImg(userDetailsProfileImgResult);
                    } else {
                        setUserProfileImg();
                    }
                    setImageLoader(false);
                }
            }
            fetchUserDetails();
        }
    }, [isFocused]);

    const handleNavigateToEditProfile = () => {
        let userDetailsData = currentUserDetails;
        if (userProfileImg) {
            userDetailsData.fileUrl = userProfileImg;
        }
        navigation.navigate('EditProfile', { userData: userDetailsData })
    }

    const styles = StyleSheet.create({
        mainContainer: {
            backgroundColor: imageLoader ? "#d9d9d9" : "#FFFFFF",
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
            paddingLeft: convertWidth(10)
        },
        emailContainer: {
            padding: convertWidth(10),
        },
        divider: {
            borderBottomColor: '#666666',
            borderBottomWidth: 1,
            marginHorizontal: convertWidth(10)
        },
        editProfileBtnContainer: {
            alignItems: 'flex-end',
            paddingHorizontal: convertWidth(10),
            paddingTop: convertWidth(10)
        },
        userIcon: {
            height: convertHeight(85),
            width: convertHeight(85),
            borderRadius: convertHeight(85),
            justifyContent: 'center',
            alignItems: 'center'
        }
    });

    return (
        <SafeAreaView style={{ flex: 1, backgroundColor: imageLoader ? "#d9d9d9" : "#FFFFFF" }}>
            <Header toggleDrawer={toggleMenu} toggleBellIcon={toggleBellIcon} />
            <TitleBar goBack={() => navigation.goBack()} title={'SideMenuItem:label:profile'} hideBack={false} />
            <ScrollView showsVerticalScrollIndicator={false}>
                <View style={styles.mainContainer}>
                    <View style={{ alignItems: 'center', paddingBottom: convertHeight(10) }}>
                        {userProfileImg && isAppOnline ?
                            <View style={styles.userIcon}>
                                {imageLoader ?
                                    <ActivityIndicator size={"large"} color={colorPalette.primary.main} animating={imageLoader} />
                                    :
                                    <Image source={{ uri: userProfileImg }} style={styles.userIcon} />
                                }
                            </View>
                            :
                            <Image style={styles.userIcon} source={Path.childImagePlaceholder} resizeMode={'contain'} />
                        }
                    </View>
                    <View style={styles.nameContainer}>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:firstName')}</Text>
                            <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.firstName : 'N/A'}</Text>
                        </View>
                        <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                            <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:lastName')}</Text>
                            <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.lastName : 'N/A'}</Text>
                        </View>
                    </View>
                    <View style={styles.emailContainer}>
                        <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:organization')}</Text>
                        <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.HTOrganizationName : 'N/A'}</Text>

                        <Text style={{ paddingTop: convertWidth(7), fontSize: convertHeight(9) }}>{t('Profile:label:email')}</Text>
                        <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.email : 'N/A'}</Text>
                    </View>
                    <View style={styles.divider} />
                    <View style={{ paddingVertical: convertHeight(7) }}>
                        <View style={styles.nameContainer}>
                            <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                                <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:country')}</Text>
                                <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.HTCountryName : 'N/A'}</Text>
                            </View>
                            <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                                <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:regionState')}</Text>
                                <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.HTStateName : 'N/A'}</Text>
                            </View>
                        </View>
                        <View style={[styles.nameContainer, { paddingTop: convertHeight(7) }]}>
                            <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                                <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:districtCounty')}</Text>
                                <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.HTDistrictName : 'N/A'}</Text>
                            </View>
                            <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                                <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:city')}</Text>
                                <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.city : 'N/A'}</Text>
                            </View>
                        </View>
                        <View style={[styles.nameContainer, { paddingTop: convertHeight(7) }]}>
                            <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                                <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:zipcode')}</Text>
                                <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.zipCode : 'N/A'}</Text>
                            </View>
                            <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                                <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:Address1')}</Text>
                                <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails && currentUserDetails?.addressLine1 != "" ? currentUserDetails?.addressLine1 : 'N/A'}</Text>
                            </View>
                        </View>
                        <View style={[styles.nameContainer, { paddingTop: convertHeight(7) }]}>
                            <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                                <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:Address2')}</Text>
                                <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails && currentUserDetails?.addressLine2 != "" ? currentUserDetails?.addressLine2 : 'N/A'}</Text>
                            </View>
                            <View style={{ justifyContent: 'flex-start', flex: 1 }}>
                                <Text style={{ fontSize: convertHeight(9) }}>{t('Profile:label:phone')}</Text>
                                <Text style={{ fontSize: convertHeight(11), fontWeight: 'bold' }}>{currentUserDetails ? currentUserDetails?.phoneNumber : 'N/A'}</Text>
                            </View>
                        </View>
                    </View>
                    <View style={styles.divider} />
                    <TouchableOpacity
                        disabled={!isAppOnline}
                        onPress={() => handleNavigateToEditProfile()}
                        style={styles.editProfileBtnContainer}>
                        <Text style={{ textDecorationLine: 'underline', color: !isAppOnline ? 'grey' : colorPalette.primary.main, fontSize: convertHeight(12) }}>{t('Profile:label:editProfile')}</Text>
                    </TouchableOpacity>
                </View>
                <View style={{ paddingHorizontal: convertWidth(17) }}>
                    <Text style={{ color: '#7A7A7A', fontSize: convertHeight(16), fontWeight: 'bold' }}>{t('Profile:label:settings')}</Text>
                </View>
                <View style={styles.mainContainer}>
                    <TouchableOpacity onPress={() => navigation.navigate('ChangePassword')} style={{ paddingHorizontal: convertWidth(7) }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                            <Text style={{ color: colorPalette.primary.main, fontSize: convertHeight(12) }}>{t('SideMenuItem:label:changePassword')}</Text>
                            <AntDesignIcon name="right" size={convertHeight(16)} color="black" />
                        </View>
                    </TouchableOpacity>
                </View>
                <View style={[styles.mainContainer, { marginTop: 0 }]}>
                    <TouchableOpacity onPress={() => setShowLanguagePrompt(true)} style={{ paddingHorizontal: convertWidth(7) }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                            <Text style={{ color: colorPalette.primary.main, fontSize: convertHeight(12) }}>{t('Common:label:changeLanguage')}</Text>
                            <AntDesignIcon name="right" size={convertHeight(16)} color="black" />
                        </View>
                    </TouchableOpacity>
                </View>
            </ScrollView>
        </SafeAreaView>
    )
}

export default Profile
