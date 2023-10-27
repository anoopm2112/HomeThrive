import React, { useEffect, useState, useRef  } from 'react'
import { View, SafeAreaView, Text, Image, TouchableOpacity, Platform, StyleSheet, Keyboard, Modal } from 'react-native';
import { TextInput, ActivityIndicator, HelperText, Snackbar, Portal, Dialog } from 'react-native-paper';
import colorPalette from '../../theme/Palette';
import colorTheme from '../../theme/Theme';
import logoPath from '../../common/Path';
import { signIn, completePassword, forgotPassword } from '../../common/contexts/CognitoHandler';
import Constants from '../../common/hooks/Constants';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import MaterialIcons from 'react-native-vector-icons/MaterialIcons';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import TextView from '../Components/TextView/TextView';
import { useTranslation } from 'react-i18next';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';
import APIS from "../../common/hooks/useApiCalls";
import TextAnimator from '../Components/TextAnimator';
import { CommonAppStyle } from '../../common/CommonAppStyle';
import { LANGUAGE_CODE } from '../../common/constant';

const Login = ({ navigation }) => {
    const { logIn, currentLanguageImage, setShowLanguagePrompt, isAppOnline, logScreen, currentLanguage, setLoadingModal } = useAuthHandlerContext();
    const { t } = useTranslation();

    const [loading, setLoading] = useState(false);
    const [challenge, setChallenge] = useState(false);
    // TextField
    const [email, setEmail] = useState("tijom@mailinator.com");
    const [password, setPassword] = useState("Inapp@123");
    const [new_password, setNewPassword] = useState("");
    const [confirm_new_password, setConfirmNewPassword] = useState("");
    // Validation
    const [isEmailValid, setEmailValid] = useState(true);
    const [isPasswordValid, setPasswordValid] = useState(true);
    const [isNewPasswordValid, setNewPasswordValid] = useState(true);
    const [isConfirmPasswordValid, setConfirmPasswordValid] = useState(true);
    // Security
    const [signinError, setSignInError] = useState('')
    const [securePassword, setSecurePassword] = useState(true);
    const [secureNewPassword, setSecureNewPassword] = useState(true);
    const [secureConfirmPassword, setSecureConfirmPassword] = useState(true);
    const [showAlert, setShowAlert] = useState(false);
    const [passwordIndication, setPasswordIndication] = useState(false);

    const InputAccessoryViewID = 'LoginTextFieldID';
    const passwordInputRef = useRef();
    const confirmPasswordInputRef = useRef();

    useEffect(() => {
        const logScreenAnalytics = () => { logScreen(ScreenConfigs.login) }
        if (isAppOnline) { logScreenAnalytics() }
    }, [])

    const dismissAlert = () => {
        setSignInError('')
        setShowAlert(false)
    }

    // LOGIN API CALL
    const verifyAndSignIn = (loginAcion) => {
        Keyboard.dismiss();
        if(!loginAcion && new_password.length == 0) {
            setNewPasswordValid(false);
        } else if (!loginAcion && confirm_new_password == '') {
            setConfirmPasswordValid(false);
        } else {
            setLoading(true)
            setLoadingModal(true);
            try {
                let signinData = {
                    username: email,
                    password: password
                }
                if (challenge === true) {
                    let isValid = true
                    if (new_password !== confirm_new_password || confirm_new_password.length == 0) {
                        setConfirmPasswordValid(false)
                        isValid = false
                    }
                    if (!Constants.validatePassword(new_password)) {
                        setNewPasswordValid(false)
                        isValid = false
                    }
                    if (!isValid) {
                        return
                    }
                }
                signIn(signinData)
                    .then(async (res) => {

                        // Checking organisation type
                        let OrganizationName;
                        if (res?.signInUserSession) {
                            OrganizationName = await APIS.OrganizationName(res.attributes['custom:organization_id']);
                        }
                        if (res.challengeName === 'NEW_PASSWORD_REQUIRED') {
                            if (challenge === true) {
                                let newPassword = new_password
                                completePassword(res, newPassword)
                                    .then((resp) => {

                                        let accessToken = resp && resp.signInUserSession &&
                                            resp.signInUserSession.idToken &&
                                            resp.signInUserSession.idToken.jwtToken &&
                                            resp.signInUserSession.idToken.jwtToken

                                        // let accessToken = resp && resp.signInUserSession &&
                                        //     resp.signInUserSession.accessToken &&
                                        //     resp.signInUserSession.accessToken.jwtToken &&
                                        //     resp.signInUserSession.accessToken.jwtToken

                                        let refreshToken = resp && resp.signInUserSession &&
                                            resp.signInUserSession.refreshToken &&
                                            resp.signInUserSession.refreshToken.token &&
                                            resp.signInUserSession.refreshToken.token

                                        if(OrganizationName?.data?.organizationTypeDetails?.name == 'Miracle Foundation' && res.attributes['custom:role'] === 'caseworker') {
                                            notifyInvalidPassword({error: ['NotAuthorizedOrganizationException: User not allowed to login.'], message: 'Error in user org signIn'});
                                            setLoading(false);
                                            setLoadingModal(false);
                                        } else {
                                            logIn(accessToken, refreshToken, email, password)
                                            // setLoading(false)
                                        }
                                    })
                                    .catch((err) => {
                                        console.error('Error in confirm pass >>', err)
                                        setLoading(false)
                                        setLoadingModal(false);

                                        // navigate('/dashboard'); // bypassing
                                    });
                            } else {
                                setChallenge(true)
                                setLoading(false)
                                setLoadingModal(false);
                            }
                        } else {
                            if (res.signInUserSession) {
                                let accessToken = res.signInUserSession && res.signInUserSession.idToken && res.signInUserSession.idToken.jwtToken
                                let refreshToken = res.signInUserSession && res.signInUserSession.refreshToken && res.signInUserSession.refreshToken.token
                                let userAttributes = res && res.attributes
                                if(OrganizationName?.data?.organizationTypeDetails?.name == 'Miracle Foundation' && res.attributes['custom:role'] === 'caseworker') {
                                    notifyInvalidPassword({error: ['NotAuthorizedOrganizationException: User not allowed to login.'], message: 'Error in user org signIn'});
                                    setLoading(false);
                                    setLoadingModal(false);
                                } else {
                                    // setLoading(false);
                                    logIn(accessToken, refreshToken, email, password, userAttributes)
                                }

                            } else {
                                if (res.error !== undefined && res.error.toString().includes('NotAuthorizedException')) {
                                    notifyInvalidPassword(res)
                                }
                                if (res.error !== undefined && res.error.toString().includes('UserNotFoundException')) {
                                    notifyInvalidPassword(res)
                                }
                                if (res.error !== undefined && res.error.toString().includes('PasswordResetRequiredException')) {
                                    try {
                                        forgotPassword(email)
                                            .then((res) => {
                                                setLoading(false)
                                                setLoadingModal(false);
                                                if (res && res["CodeDeliveryDetails"]) {
                                                    setLoadingModal(false);
                                                    navigation.navigate('NewPassword', { email: email })
                                                } else {
                                                    notifyInvalidPassword(res)
                                                    setLoadingModal(false);
                                                }
                                            })
                                    } catch (err) {
                                        console.log("Please try after sometime.")
                                    }
                                }
                                //setErrors({ password: res.error && res.error.message });
                                setLoading(false)
                                setLoadingModal(false);
                            }
                        }
                    })
                    .catch((err) => {
                        setLoading(false)
                        setLoadingModal(false);
                    })
            } catch (err) {
                setLoading(false)
                setLoadingModal(false);
            }
        }
    }

    const notifyInvalidPassword = (res) => {
        setSignInError(res.error.toString().replace('NotAuthorizedException: ', '').replace('UserNotFoundException: ', '').replace('NotAuthorizedOrganizationException: ', '').replace('PasswordResetRequiredException: ', ''))
        setTimeout(() => {
            setSignInError('')
        }, 3000)
    }

    const setEmailAndValidate = (mail) => {
        setEmail(mail)
        setEmailValid(Constants.validateEmail(mail))
    }

    const setPasswodAndValidate = (pass) => {
        setPassword(pass)
        setPasswordValid(Constants.validatePassword(pass))
    }

    const setNewPasswordAndValidate = (pass) => {
        setNewPassword(pass)
        setNewPasswordValid(Constants.validatePassword(pass))
    }

    const setConfirmNewPasswordAndValidate = (pass) => {
        setConfirmNewPassword(pass)
        setConfirmPasswordValid(new_password === pass)
    }

    const validateLoginAction = () => {
        const emailValid = Constants.validateEmail(email)
        // const passwordValid = Constants.validatePassword(password)
        setEmailValid(emailValid)
        // setPasswordValid(passwordValid)
        if(password.length < 6) {
            setPasswordValid(true);
            setPasswordIndication(true);
        } else if (emailValid && password.length >= 6) {
            verifyAndSignIn(true)
        }
    }

    const Alert = ({ message, visible, onDismiss }) => {
        return (
            <Portal>
                <Dialog visible={visible} onDismiss={onDismiss} style={styles.dialogAlertContainer}>
                    <Dialog.Content>
                        <View style={styles.dialogContent}>
                            <Icon size={40} color={'crimson'} name={'alert-circle-outline'} style={{ marginEnd: 10 }} />
                            <Text style={{ fontWeight: 'bold', fontSize: 16 }}>{message}</Text>
                        </View>
                    </Dialog.Content>
                </Dialog>
            </Portal>
        )
    }

    const styles = StyleSheet.create({
        mainContainer: {
            margin: convertWidth(7),
        },
        htIcon: {
            marginVertical: convertHeight(7),
            width: 50,
            height: 36
        },
        changeLangContainer: {
            flexDirection: 'row',
            justifyContent: 'center',
            alignItems: 'center',
            marginVertical: 25
        },
        changeLang: {
            height: 28,
            width: 28,
            alignSelf: 'baseline'
        },
        changeLangImg: {
            height: 28,
            width: 28,
            alignSelf: 'baseline'
        },
        dialogAlertContainer: {
            borderRadius: 10,
            width: '50%',
            alignSelf: 'center'
        },
        dialogContent: {
            flexDirection: 'row',
            alignItems: 'center',
            justifyContent: 'center'
        },
        image: {
            height: convertHeight(90),
            width: convertHeight(90)
        },
    });

    const [isBlurInput, setIsBlurInput] = useState(true);
    const handleInputBlur = (fName) => {
        if (fName === 'email') { 
            setIsBlurInput(true); 
        } else if (fName === 'password') { 
            setIsBlurInput(true); 
        } else if (fName === 'newPassword') {
            setIsBlurInput(true);
        } else if (fName === 'confirmNewPassword') {
            setIsBlurInput(true);
        }
    };
    const handleInputFocus = (fName) => {
        if (fName === 'email'){ 
            setIsBlurInput(false);
        } else if (fName === 'password') { 
            setIsBlurInput(false); 
        } else if (fName === 'newPassword') {
            setIsBlurInput(false);
        } else if (fName === 'confirmNewPassword') {
            setIsBlurInput(false);
        }
    };

    return (
        <SafeAreaView style={[colorTheme.safeAreaStyle, { flex: 1, marginBottom: Platform.OS === 'ios' && !isBlurInput ? 100 : 0 }]}>
            {!loading ? <KeyboardAwareScrollView keyboardShouldPersistTaps="handled" showsVerticalScrollIndicator={false} contentContainerStyle={{ flex: 1, justifyContent:'center' }} extraHeight={isBlurInput && Platform.OS === 'ios' ? 320 : 0}>
                <View style={styles.mainContainer}>
                    {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}

                    <View>
                        {/* HEADER */}
                        <TextView textObject={'LoginScreen:thriveScale'} style={[colorTheme.primaryLabel, CommonAppStyle?.[currentLanguage.languageCode].logo_header ]} />
                        <TextView textObject={'LoginScreen:poweredBy'} style={[colorTheme.secondaryLabel, { fontSize: convertHeight(10), color: '#8A8A8A', textAlign: 'center', paddingTop: convertHeight(5) }]} />
                        <View style={{ alignItems: "center", }}>
                            <Image style={styles.htIcon} resizeMode={'contain'} source={logoPath.Miracle_Verticle_logo} />
                        </View>

                        {/* LOGIN VIEW */}
                        <View style={{ marginTop: convertHeight(15) }}>
                        {!challenge ?
                            <View style={{ margin: 20 }}>
                                {/* <TextView textObject={'LoginScreen:signInToYourAccount'} style={[colorTheme.secondaryLabel, { marginBottom: 20 }]} /> */}
                                <TextInput
                                    key="1"
                                    outlineColor={colorPalette.grey2}
                                    activeOutlineColor={colorPalette.primary.main}
                                    value={email}
                                    placeholderTextColor={colorPalette.text.primary}
                                    onChangeText={(text) => setEmailAndValidate(text)}
                                    label={`${t('LoginScreen:email')}${'*'}`}
                                    style={[colorTheme.textInputStyle, { textAlign: 'auto', marginBottom: isEmailValid ? 10 : 0, backgroundColor: '#FFFFFF' }]}
                                    mode="outlined"
                                    onBlur={() => handleInputBlur('email')}
                                    onFocus={() => handleInputFocus('email')}
                                    underlineColor='transparent'
                                    autoCapitalize='none'
                                    keyboardAppearance='light'
                                    keyboardType="email-address"
                                    inputAccessoryViewID={InputAccessoryViewID}
                                    onSubmitEditing={() => passwordInputRef.current.focus()}
                                    returnKeyType={'next'}
                                />
                                {!isEmailValid && <HelperText type="error" visible={!isEmailValid} style={{ marginBottom: 10 }}>
                                    {email.length > 0 ? t('LoginScreen:message:invalidEmail') : t('LoginScreen:message:emailRequired')}
                                </HelperText>}

                                <TextInput
                                    maxLength={25}
                                    secureTextEntry={securePassword}
                                    underlineColorAndroid="none"
                                    onChangeText={(text) => {
                                        setPassword(text)
                                        setPasswordIndication(true)
                                    }}
                                    editable
                                    outlineColor={colorPalette.grey2}
                                    activeOutlineColor={colorPalette.primary.main}
                                    placeholderTextColor={colorPalette.text.primary}
                                    label={`${t('LoginScreen:password')}${'*'}`}
                                    value={password}
                                    mode="outlined"
                                    onBlur={() => handleInputBlur('password')}
                                    onFocus={() => handleInputFocus('password')}
                                    underlineColor='transparent'
                                    style={[colorTheme.textInputStyle, { textAlign: 'auto', backgroundColor: '#FFFFFF' }]}
                                    inputAccessoryViewID={InputAccessoryViewID}
                                    right={securePassword ?
                                        <TextInput.Icon name="eye" onPress={() => setSecurePassword(false)} /> :
                                        <TextInput.Icon name="eye-off" onPress={() => setSecurePassword(true)} />
                                    }
                                    ref={passwordInputRef}
                                />
                                {password.length === 0 && passwordIndication ?
                                    <HelperText type="error">{t('LoginScreen:message:passwordRequired')}</HelperText> 
                                    : password.length > 0 && password.length < 6 ? 
                                    <HelperText type="error">{t('LoginScreen:message:loginPasswordMustBe6Characters')}</HelperText> : null
                                }
                                {/* {password.length < 8 && passwordIndication ?
                                    <HelperText type="error">{t('LoginScreen:message:passwordMustBe8Characters')}</HelperText> : null} */}

                                {/* FORGET PASSWORD */}
                                <View style={{ alignItems: 'flex-end' }}>
                                    <TextView textObject={'LoginScreen:forgotPassword'} style={[colorTheme.textLinks, { color: '#1406B1' }]} onPress={() => navigation.navigate('ForgotPassword')} />
                                </View>

                                {/* LOGIN BUTTON */}
                                <TouchableOpacity style={[colorTheme.button, { marginTop: convertHeight(45), borderRadius: 6 }, !isAppOnline && { backgroundColor: 'grey' }]}
                                    disabled={!isAppOnline}
                                    onPress={() => { if (isAppOnline) { validateLoginAction() } }}>
                                    <TextView textObject={'LoginScreen:signIn'} style={colorTheme.buttonLabel} />
                                </TouchableOpacity>
                            </View>
                            :
                            // CHANGE PASSWORD VIEW
                            <View style={{ margin: 20 }}>
                                <TextView style={[colorTheme.secondaryLabel, { marginBottom: 20 }]} textObject={'LoginScreen:message:changeTempPassword'} />

                                <TextInput
                                    maxLength={25}
                                    secureTextEntry={secureNewPassword}
                                    underlineColorAndroid="none"
                                    // onChangeText={(text) => setNewPassword(text)}
                                    onChangeText={(text) => setNewPasswordAndValidate(text)}
                                    editable
                                    outlineColor={colorPalette.grey2}
                                    activeOutlineColor={colorPalette.primary.main}
                                    placeholderTextColor={colorPalette.text.primary}
                                    autoFocus={true}
                                    label={`${t('LoginScreen:newPassword')}${'*'}`}
                                    mode="outlined"
                                    value={new_password}
                                    underlineColor='transparent'
                                    style={[colorTheme.textInputStyle, { textAlign: 'auto', backgroundColor: '#FFFFFF', fontSize: 12 }]}
                                    onBlur={() => handleInputBlur('newPassword')}
                                    onFocus={() => handleInputFocus('newPassword')}
                                    inputAccessoryViewID={InputAccessoryViewID}
                                    right={secureNewPassword ?
                                        <TextInput.Icon name="eye" onPress={() => setSecureNewPassword(false)} /> :
                                        <TextInput.Icon name="eye-off" onPress={() => setSecureNewPassword(true)} />
                                    }
                                    onSubmitEditing={() => confirmPasswordInputRef.current.focus()}
                                    returnKeyType={'next'}
                                />
                                {!isNewPasswordValid && <HelperText type="error" visible={!isNewPasswordValid}>
                                    {new_password.length == 0 ? t('ChangePassword:message:newPasswordRequired') : new_password.length > 8 ? t('LoginScreen:message:invalidPassword') : t('LoginScreen:message:passwordMustBe8Characters')}
                                </HelperText>}

                                <TextInput
                                    multiline={false}
                                    maxLength={25}
                                    secureTextEntry={secureConfirmPassword}
                                    underlineColorAndroid="none"
                                    onChangeText={(text) => setConfirmNewPasswordAndValidate(text)}
                                    editable
                                    outlineColor={colorPalette.grey2}
                                    activeOutlineColor={colorPalette.primary.main}
                                    placeholderTextColor={colorPalette.text.primary}
                                    label={`${t('LoginScreen:confirmPassword')}${'*'}`}
                                    mode="outlined"
                                    value={confirm_new_password}
                                    underlineColor='transparent'
                                    style={[colorTheme.textInputStyle, { marginTop: 20, textAlign: 'auto', backgroundColor: '#FFFFFF', fontSize: 12 }]}
                                    onBlur={() => handleInputBlur('confirmNewPassword')}
                                    onFocus={() => handleInputFocus('confirmNewPassword')}
                                    inputAccessoryViewID={InputAccessoryViewID}
                                    right={secureConfirmPassword ?
                                        <TextInput.Icon name="eye" onPress={() => setSecureConfirmPassword(false)} /> :
                                        <TextInput.Icon name="eye-off" onPress={() => setSecureConfirmPassword(true)} />
                                    }
                                    ref={confirmPasswordInputRef}
                                />
                                {!isConfirmPasswordValid && <HelperText type="error" visible={!isConfirmPasswordValid}>
                                    {confirm_new_password.length == 0 ? t('ChangePassword:message:confirmPasswordRequired') : confirm_new_password === new_password ? '' : t('ChangePassword:message:passwordDoesNotMatch')}
                                </HelperText>}

                                {/* CHANGE PASSWORD BUTTON */}
                                <TouchableOpacity style={[colorTheme.button, { marginTop: convertHeight(45), borderRadius: 6 }]} disabled={!isConfirmPasswordValid} onPress={() => verifyAndSignIn(false)}>
                                    <TextView style={colorTheme.buttonLabel} textObject={'LoginScreen:changePassword'} />
                                </TouchableOpacity>
                            </View>
                        }
                    </View>
                </View>
                </View>
                <TouchableOpacity activeOpacity={0.5} onPress={() => { setShowLanguagePrompt(true) }} style={styles.changeLangContainer}>
                    <TextView onPress={() => { setShowLanguagePrompt(true) }} textObject={'AppSettings:label:language'} style={{ fontSize: 13, marginEnd: 10 }} />
                    <Image style={styles.changeLangImg} source={{ uri: currentLanguageImage() }} />
                    <Text style={{ color: '#000000', paddingLeft: 7, fontSize: 15 }}>{currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? 'EN' : currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI ? 'HI' : 'TA'}</Text>
                    <MaterialIcons name="keyboard-arrow-down" size={24} color="black" />
                </TouchableOpacity>
            </KeyboardAwareScrollView> : 
            <View style={{ flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: '#1D334B' }}>
                <Image source={logoPath.loading_appIcon} resizeMode={'contain'} style={{ height: convertHeight(90), width: convertHeight(90) }} />
                <TextAnimator content={t('LoginScreen:loading')} duration={500} textStyle={{ fontSize: convertHeight(14), color: '#FFFFFF' }} />
            </View>}
            {/* CHANGE LANGUAGE VIEW */}
            {/* <TouchableOpacity activeOpacity={0.5} onPress={() => { setShowLanguagePrompt(true) }} style={styles.changeLangContainer}>
                <TextView onPress={() => { setShowLanguagePrompt(true) }} textObject={'AppSettings:label:language'} style={{ fontSize: 13, marginEnd: 10 }} />
                <Image style={styles.changeLangImg} source={{ uri: currentLanguageImage() }} />
                <Text style={{ color: '#000000', paddingLeft: 7, fontSize: 15 }}>{currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? 'EN' : 'HI'}</Text>
                <MaterialIcons name="keyboard-arrow-down" size={24} color="black" />
            </TouchableOpacity> */}

            {/* SIGN IN ERROR TOAST */}
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH &&
                <Snackbar visible={signinError.length > 0 && !showAlert}>
                    {
                        signinError === 'User does not exist.' ? <Text>User does not exist.</Text> :
                        signinError === 'Incorrect username or password.' ? <Text>Either the username was not found or the password is incorrect. Please try again or use 'forgot password'.</Text> : 
                        signinError === 'Password reset required for the user' ? <Text>Password reset required for the user.</Text> : 
                        signinError === 'User not allowed to login.' ? <Text>User under miracle organization, Unable to login.</Text> : 
                        signinError
                    }
                </Snackbar>
            }
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI &&
                <Snackbar visible={signinError.length > 0 && !showAlert}>
                    {
                        signinError === 'User does not exist.' ? <Text>उपयोगकर्ता मौजूद नहीं है</Text> :
                        signinError === 'Incorrect username or password.' ? <Text>या तो उपयोगकर्ता नाम नहीं मिला या पासवर्ड गलत है। कृपया पुन: प्रयास करें या 'पासवर्ड भूल गए' का उपयोग करें।</Text> : 
                        signinError === 'Password reset required for the user' ? <Text>उपयोगकर्ता के लिए आवश्यक पासवर्ड रीसेट</Text> : 
                        signinError === 'User not allowed to login.' ? <Text>चमत्कार संगठन के तहत उपयोगकर्ता, लॉगिन करने में असमर्थ</Text> : 
                        signinError
                    }
                </Snackbar>
            }
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_TAMIL &&
                <Snackbar visible={signinError.length > 0 && !showAlert}>
                    {
                        signinError === 'User does not exist.' ? <Text>பயனர் இல்லை.</Text> :
                        signinError === 'Incorrect username or password.' ? <Text>பயனர் பெயர் கிடைக்கவில்லை அல்லது கடவுச்சொல் தவறாக உள்ளது. மீண்டும் முயற்சிக்கவும் அல்லது 'கடவுச்சொல்லை மறந்துவிட்டேன்' என்பதைப் பயன்படுத்தவும்.</Text> : 
                        signinError === 'Password reset required for the user' ? <Text>பயனருக்கு கடவுச்சொல் மீட்டமைப்பு தேவை.</Text> : 
                        signinError === 'User not allowed to login.' ? <Text>அதிசய அமைப்பின் கீழ் உள்ள பயனர், உள்நுழைய முடியவில்லை.</Text> : 
                        signinError
                    }
                </Snackbar>
            }

            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH && showAlert &&
                <Alert visible={showAlert} 
                    message={
                        signinError === 'User does not exist.' ? <Text>User does not exist.</Text> :
                        signinError === 'Incorrect username or password.' ? <Text>Either the username was not found or the password is incorrect. Please try again or use 'forgot password'.</Text> : 
                        signinError === 'Password reset required for the user' ? <Text>Password reset required for the user.</Text> : 
                        signinError === 'User not allowed to login.' ? <Text>User under miracle organization, Unable to login.</Text> :  
                        signinError
                    } 
                    onDismiss={() => dismissAlert()} />
            }

            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI && showAlert &&
                <Alert visible={showAlert} 
                    message= {
                        signinError === 'User does not exist.' ? <Text>उपयोगकर्ता मौजूद नहीं है</Text> :
                        signinError === 'Incorrect username or password.' ? <Text>या तो उपयोगकर्ता नाम नहीं मिला या पासवर्ड गलत है। कृपया पुन: प्रयास करें या 'पासवर्ड भूल गए' का उपयोग करें।</Text> : 
                        signinError === 'Password reset required for the user' ? <Text>उपयोगकर्ता के लिए आवश्यक पासवर्ड रीसेट</Text> : 
                        signinError === 'User not allowed to login.' ? <Text>चमत्कार संगठन के तहत उपयोगकर्ता, लॉगिन करने में असमर्थ</Text> : 
                        signinError
                    }
                    onDismiss={() => dismissAlert()} />
            }

            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_TAMIL && showAlert &&
                <Alert visible={showAlert} 
                    message= {
                        signinError === 'User does not exist.' ? <Text>பயனர் இல்லை.</Text> :
                        signinError === 'Incorrect username or password.' ? <Text>பயனர் பெயர் கிடைக்கவில்லை அல்லது கடவுச்சொல் தவறாக உள்ளது. மீண்டும் முயற்சிக்கவும் அல்லது 'கடவுச்சொல்லை மறந்துவிட்டேன்' என்பதைப் பயன்படுத்தவும்.</Text> : 
                        signinError === 'Password reset required for the user' ? <Text>பயனருக்கு கடவுச்சொல் மீட்டமைப்பு தேவை.</Text> : 
                        signinError === 'User not allowed to login.' ? <Text>அதிசய அமைப்பின் கீழ் உள்ள பயனர், உள்நுழைய முடியவில்லை.</Text> : 
                        signinError
                    }
                    onDismiss={() => dismissAlert()} />
            }


        </SafeAreaView>
    )
}

export default Login
