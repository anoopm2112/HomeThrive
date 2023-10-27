import React, { createContext, useState, useMemo, useContext, useEffect } from 'react';
import AsyncStorage from "@react-native-async-storage/async-storage";
import { useNetInfo } from "@react-native-community/netinfo";
import { signIn } from '../../common/contexts/CognitoHandler';
import APIS from './useApiCalls';
import logoPath from '../../common/Path';
import { useTranslation } from 'react-i18next';
import { useNavigation } from '@react-navigation/native';
import { signOut } from '../../common/contexts/CognitoHandler';
import { Dialog, List, Portal } from 'react-native-paper';
import { FlatList, Image, Platform, Modal, View, Text, TouchableOpacity } from 'react-native';
import TextView from '../../views/Components/TextView/TextView';
import Icon from 'react-native-vector-icons/MaterialIcons';
import analytics from '@react-native-firebase/analytics';
import { getFCMToken, hasPermissionIniOS, notificationListener } from '../contexts/FCMHandler'
import { convertHeight } from '../../common/utils/dimensionUtil';
import TextAnimator from '../../views/Components/TextAnimator';
import { LANGUAGE_CODE } from '../../common/constant';

const AuthHandlerContext = createContext(() => { });
export const useAuthHandlerContext = () => useContext(AuthHandlerContext);

const userEmailKey = 'userEmail'
const userPasswordKey = 'userPassword'
const accessTokenKey = 'accessToken'
const refreshTokenKey = 'refreshToken'
const appLanguageKey = 'appLanguage'
const userAttributesKey = 'userAttributesKey'

const AuthHandler = (props) => {

    const { i18n, t } = useTranslation()
    const navigation = useNavigation()
    const netInfo = useNetInfo()
    const [isOnline, setIsOnline] = useState(true)
    const [authorized, setAuthorized] = useState(null)
    const [currentLanguage, setCurrentLanguage] = useState(languagesInitialValue.find((item) => i18n.language === item.languageCode))
    const [languages, setLanguages] = useState(languagesInitialValue)
    const [showSelectLanguagePrompt, setShowSelectLanguagePrompt] = useState(false)
    const [loadingSelectModal, setLoadingSelectModal] = useState(false)
    const platform = Platform.OS.toUpperCase()
    const [userAllDetails, setUserAllDetails] = useState({});

    const [hasNewNotifications, setHasNewNotifications] = useState(null)

    useEffect(() => {
        setIsOnline(netInfo.isConnected)
    }, [netInfo.isConnected])

    useEffect(() => {
        const startUp = async () => {
            const appLanguage = await AsyncStorage.getItem(appLanguageKey)
            if (appLanguage !== null) {
                const appLanguageObject = JSON.parse(appLanguage)
                setCurrentLanguage(appLanguageObject)
            } else {
                setCurrentLanguage(languagesInitialValue[0])
            }
        }
        startUp()
    }, [])

    useEffect(() => {
        const updateNotificationStatus = async () => {
            if (hasNewNotifications === null) {
                const hasNotification = await AsyncStorage.getItem('thrive_scale_fcm_has_new_notification')
                setHasNewNotifications(hasNotification === 'true')
            } else {
                await AsyncStorage.setItem('thrive_scale_fcm_has_new_notification', hasNewNotifications ? 'true' : 'false')
            }
        }
        updateNotificationStatus()
    }, [hasNewNotifications])

    useEffect(() => {
        const fetchLanguages = async () => {
            const languageList = await APIS.Languages()
            if (languageList) {
                setLanguages(languageList.data.languages)
            }
        }
        if (isOnline && authorized) {
            fetchLanguages()
        }
    }, [isOnline])

    useEffect(() => {
        const authorizeUserEvent = async () => {
            if (authorized !== null) {
                const id = Date.now()
                await logEventAnalytics('miracle_native_user_status', {
                    id: id,
                    authorizationStatus: authorized ? 'Logged In' : 'Logged Out'
                })
                if (authorized) {
                    navigation.reset({
                        index: 0,
                        routes: [{ name: 'AssessmentList' }],
                    })
                } else {
                    navigation.reset({
                        index: 0,
                        routes: [{ name: 'Login' }],
                    })
                }
            }
        }

        authorizeUserEvent()

        if (authorized) {
            if (Platform.OS === 'ios') {
                const hasPermission = hasPermissionIniOS()
                if (!hasPermission) {
                    return
                }
            }
            getFCMToken()
            notificationListener(hasNewNotifications, setHasNewNotifications)
        }

    }, [authorized])

    const updateAppLanguage = async (lang) => {
        const langString = JSON.stringify(lang)
        await AsyncStorage.setItem(appLanguageKey, langString)
        i18n.changeLanguage(lang.languageCode)
        setCurrentLanguage(lang)

        if (isOnline) {
            const langId = lang.id;
            const userId = userAllDetails.sub;
            let payload = JSON.stringify({
                "userId": `${userId}`,
                "languageId": `${langId}`
            });
            await APIS.SaveUserLanguage(payload);
        }
    }

    const checkPermission = async () => {
        try {
            const accessToken = await AsyncStorage.getItem(accessTokenKey)
            if (accessToken !== null) {
                const data = await APIS.CheckUserPermission()
                if (data && data.accessPermission !== undefined) {
                    if (data.accessPermission === true) {
                        setAuthorized(true)
                    } else {
                        signOut().then(() => {
                            setAuthorized(false)
                        }).catch((err) => {
                            console.log('Error >> ', err)
                        })
                    }
                } else {
                    setAuthorized(false)
                }
            } else {
                setAuthorized(false)
            }
        } catch (err) {
            console.error(err)
        }
    }

    const logEventAnalytics = async (eventName, eventParams) => {
        await analytics().logEvent(eventName, eventParams)
    }

    const logScreen = async (screen) => {
        await analytics().logScreenView({
            screen_class: screen.class,
            screen_name: `${screen.name} | Native | ${platform}`
        })
    }


    const signInUser = async () => {
        const userEmail = await AsyncStorage.getItem(userEmailKey)
        const userPassword = await AsyncStorage.getItem(userPasswordKey)
        if (userEmail !== null && userPassword !== null) {
            if (isOnline) {
                let signinData = {
                    username: userEmail,
                    password: userPassword
                }
                await signIn(signinData).then((res) => {
                    if (res.signInUserSession) {
                        checkPermission()
                    } else {
                        setAuthorized(false)
                    }
                })
            } else {
                setAuthorized(false)
            }
        } else {
            setAuthorized(false)
        }
    }

    const logIn = async (accessToken, refreshToken, email, pass, userAttributes) => {
        await AsyncStorage.setItem(refreshTokenKey, refreshToken)
        await AsyncStorage.setItem(accessTokenKey, accessToken)
        // await AsyncStorage.setItem(userEmailKey, email)
        // await AsyncStorage.setItem(userPasswordKey, pass)
        // await AsyncStorage.setItem(userAttributesKey, JSON.stringify(userAttributes))
        setUserAllDetails(userAttributes);
        checkPermission()
    }

    const logInOffline = () => {
        setAuthorized(true)
    }

    const logOut = async () => {
        if (isOnline) {
            await AsyncStorage.removeItem(refreshTokenKey)
            await AsyncStorage.removeItem(accessTokenKey)
            await AsyncStorage.setItem('thrive_scale_fcm_has_new_notification', 'false')
            // await AsyncStorage.removeItem(userEmailKey)
            // await AsyncStorage.removeItem(userPasswordKey)
            // await AsyncStorage.removeItem(userAttributesKey)
            signOut().then(() => {
                setAuthorized(false)
            }).catch((err) => {
                console.log('Error >> ', err)
            })
        } 
    }

    const getCurrentLanguageId = () => {
        return currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? '' : currentLanguage.id
    }

    const getCurrentLanguageImage = () => {
        return languagesInitialValue.find((item) => item.languageCode === currentLanguage.languageCode)?.imageUrl
    }

    const contextValues = useMemo(() => ({
        isAppOnline: isOnline,
        userAuthorized: authorized,
        currentLanguage: currentLanguage,
        hasNewNotifications: hasNewNotifications,
        userAllDetails: userAllDetails,
        logIn,
        logOut,
        updateAppLanguage,
        logInOffline: logInOffline,
        checkAuthorization: signInUser,
        setAppLanguage: updateAppLanguage,
        getCurrentLanguageId: getCurrentLanguageId,
        currentLanguageImage: getCurrentLanguageImage,
        setShowLanguagePrompt: setShowSelectLanguagePrompt,
        setLoadingModal: setLoadingSelectModal,
        logEvent: logEventAnalytics,
        logScreen: logScreen,
        setHasNewNotifications: setHasNewNotifications,
    }), [isOnline, authorized, currentLanguage, hasNewNotifications, userAllDetails])

    return (
        <AuthHandlerContext.Provider value={contextValues} {...props}>
            {props.children}
            <Portal>
                <Dialog dismissable visible={showSelectLanguagePrompt}
                    onDismiss={() => setShowSelectLanguagePrompt(false)}
                    style={[{ borderRadius: 10 }, Platform.OS === 'ios' ? { marginBottom: 80 } : {}]}>
                    {isOnline && <Dialog.Title><TextView textObject={'Common:label:selectLanguage'} style={{ marginBottom: 10 }} /></Dialog.Title>}
                    {isOnline ? 
                    <Dialog.Content>
                        <FlatList
                            keyExtractor={(item, index) => index}
                            data={languages}
                            showsVerticalScrollIndicator={false}
                            renderItem={({ item, index }) => <List.Item
                                onPress={() => {
                                    setShowSelectLanguagePrompt(false)
                                    updateAppLanguage(item)
                                }}
                                style={{
                                    flex: 1,
                                    borderRadius: 10,
                                    borderColor: item.languageCode === currentLanguage.languageCode ? 'green' : 'transparent',
                                    borderWidth: 1,
                                    backgroundColor: 'white',
                                    margin: 8
                                }}
                                title={item.language}
                                left={props => <Image {...props}
                                    style={{
                                        height: 20,
                                        width: 20,
                                        borderRadius: 40,
                                        alignSelf: 'center',
                                        marginHorizontal: 8
                                    }}
                                    source={{ uri: languagesInitialValue.find((langList) => langList.languageCode === item.languageCode)?.imageUrl }}
                                />}
                                right={(props) =>
                                    item.languageCode === currentLanguage.languageCode ? <Icon {...props}
                                        name={'check-circle'}
                                        color={'green'}
                                        size={22}
                                        style={{ alignSelf: 'center', height: 24 }} /> : <></>
                                }
                            />}
                        />
                    </Dialog.Content>
                    :
                    <Dialog.Content>
                        <Text style={{ fontSize: 16 }}>{t('Common:label:offlineLanguageMsg')}</Text>
                        <Dialog.Actions>
                            <TouchableOpacity onPress={() => setShowSelectLanguagePrompt(false)}>
                                <Text style={{ fontWeight: 'bold', color: '#f37123', fontSize: 16 }}>{t('Common:label:ok')}</Text>
                            </TouchableOpacity>
                        </Dialog.Actions>
                    </Dialog.Content>
                    }   
                </Dialog>
                {/* <Modal
                    animationType="fade"
                    transparent={false}
                    visible={loadingSelectModal}
                    onRequestClose={() => {
                        setLoadingSelectModal(false);
                    }}>
                    <View style={{ flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: '#1D334B' }}>
                        <Image source={logoPath.loading_appIcon} resizeMode={'contain'} style={{ height: convertHeight(90), width: convertHeight(90) }} />
                        <TextAnimator content='Loading...' duration={500} textStyle={{ fontSize: convertHeight(14), color: '#FFFFFF' }} />
                    </View>
                </Modal> */}
            </Portal>
        </AuthHandlerContext.Provider>
    )
}

const languagesInitialValue = [
    {
        language: 'English',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/197/197484.png',
        languageCode: LANGUAGE_CODE.LANG_ENGLISH,
        id: '1'
    },
    {
        language: 'Hindi',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/197/197419.png',
        languageCode: LANGUAGE_CODE.LANG_HINDI,
        id: '2'
    },
    {
        language: 'Tamil',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/197/197419.png',
        languageCode: LANGUAGE_CODE.LANG_TAMIL,
        id: '3'
    }
]

export default AuthHandler