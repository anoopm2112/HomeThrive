import React, { useEffect, useState, useRef } from 'react'
import { View, SafeAreaView, Image, TouchableOpacity, Platform, StyleSheet } from 'react-native';
import { ActivityIndicator, HelperText, TextInput, Snackbar } from 'react-native-paper';
import colorPalette from '../../theme/Palette';
import logoPath from '../../common/Path';
import { forgotPasswordSubmit } from '../../common/contexts/CognitoHandler';
import TextView from '../Components/TextView/TextView';
import { useTranslation } from 'react-i18next';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import Constants from '../../common/hooks/Constants';
import colorTheme from '../../theme/Theme';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { convertHeight } from '../../common/utils/dimensionUtil';
import { CommonAppStyle } from '../../common/CommonAppStyle';

const NewPassword = ({ route, navigation }) => {
    const { logScreen, isAppOnline, currentLanguage } = useAuthHandlerContext();
    const { t } = useTranslation();
    const { email } = route.params;
    const [loading, setLoading] = useState(false);
    //TextField
    const [new_password, setNewPassword] = useState("");
    const [confirm_new_password, setConfirmNewPassword] = useState("");
    const [verification_code, setVerificationCode] = useState("");
    // Validation
    const [isPasswordValid, setPasswordValid] = useState(true);
    const [isConfirmPasswordValid, setConfirmPasswordValid] = useState(true);
    const [isVerificationCodeValid, setVerificationCodeValid] = useState(true);
    // Security
    const [secureNewPassword, setSecureNewPassword] = useState(true);
    const [secureConfirmNewPassword, setSecureConfirmNewPassword] = useState(true);
    const [errorNewPassword, setErrorNewPassword] = useState('');

    const InputAccessoryViewID = 'newPasswordID';
    // Reference
    const newPasswordInputRef = useRef();
    const confirmPasswordInputRef = useRef();

    useEffect(() => {
        const logScreenAnalytics = () => {
            logScreen(ScreenConfigs.newPassword)
        }
        if (isAppOnline) {
            logScreenAnalytics()
        }
    }, [])

    const setNewPasswordAndValidate = (pass) => {
        setNewPassword(pass)
        setPasswordValid(Constants.validatePassword(pass))
    }

    const setConfirmNewPasswordAndValidate = (pass) => {
        setConfirmNewPassword(pass)
        setConfirmPasswordValid(new_password === pass)
    }

    const setVerificationCodeAndValidate = (code) => {
        setVerificationCode(code)
        setVerificationCodeValid(code.length == 6)
    }

    const passwordSubmit = () => {
        let isValid = true
        if (verification_code.length === 0 || verification_code.length !== 6) {
            setVerificationCodeValid(false)
            isValid = false
        }
        if (new_password !== confirm_new_password || confirm_new_password.length == 0) {
            setConfirmPasswordValid(false)
            isValid = false
        }
        if (!Constants.validatePassword(new_password)) {
            setPasswordValid(false)
            isValid = false
        }
        if (!isValid) {
            return
        }

        setLoading(true)
        try {
            let data = {
                new_password: new_password,
                code: verification_code,
                username: email
            }
            forgotPasswordSubmit(data)
                .then((res) => {
                    setLoading(false)
                    if (res && (res["code"] || res["message"])) {
                        const errorMsg = res["message"] ? res["message"].replace(/ /g, '') : 'Error occured while changing password'
                        setErrorNewPassword(errorMsg.replace(/,/g, ''));
                    } else {
                        console.log("successfully changed password.")
                        navigation.navigate('Login')
                    }

                })
        }
        catch (err) {
            console.log("error in forgotPassword api call")
        }
    }

    const styles = StyleSheet.create({
        mainContainer: {
            // backgroundColor: "#fff",
            borderRadius: 15,
            margin: 20,
            // shadowColor: '#000',
            // shadowOffset: { width: 0, height: 3 },
            // shadowOpacity: 0.5,
            // shadowRadius: 3,
            // elevation: 4,
        },
        textView: {
            color: "gray",
            fontSize: convertHeight(14),
            fontWeight: "500",
            marginVertical: 20
        },
        btnContainer: {
            height: 60,
            backgroundColor: loading ? colorPalette.disabled : colorPalette.button.main,
            borderRadius: 6,
            marginTop: 20,
            alignItems: "center",
            justifyContent: "center"
        },
        btnText: {
            color: colorPalette.primary.white,
            fontSize: convertHeight(14),
            fontWeight: "500"
        },
        loader: {
            marginTop: 10,
            backgroundColor: 'transparent',
            borderRadius: 10,
            position: 'absolute',
            top: 0, left: 0, right: 0, bottom: 0,
        }
    });

    const [isBlurInput, setIsBlurInput] = useState(false);
    const handleInputBlur = (fName) => {
        if (fName === 'verificationCode') { 
            setIsBlurInput(true); 
        } else if (fName === 'newPassword') {
            setIsBlurInput(true);
        } else if (fName === 'confirmNewPassword') {
            setIsBlurInput(true);
        }
    };
    const handleInputFocus = (fName) => {
        if (fName === 'verificationCode') { 
            setIsBlurInput(false); 
        } else if (fName === 'newPassword') {
            setIsBlurInput(false);
        } else if (fName === 'confirmNewPassword') {
            setIsBlurInput(false);
        }
    };

    return (
        <SafeAreaView style={[colorTheme.safeAreaStyle, { flex: 1 }]}>
            <KeyboardAwareScrollView 
                // keyboardShouldPersistTaps="handled" 
                showsVerticalScrollIndicator={false} 
                // contentContainerStyle={{ flex: 1, justifyContent:'center' }} 
                extraScrollHeight={isBlurInput && Platform.OS === 'ios' ? 360 : 0}>
                <View style={styles.mainContainer}>
                    {/* <TextView textObject={'Common:header:thriveScale'} style={[colorTheme.primaryLabel, {  }]} /> */}
                    <TextView textObject={'LoginScreen:thriveScale'} style={[colorTheme.primaryLabel, CommonAppStyle?.[currentLanguage.languageCode].logo_header, { marginTop: 20 }]} />
                    <TextView textObject={'LoginScreen:poweredBy'} style={[colorTheme.secondaryLabel, { fontSize: 15, color: '#8A8A8A', textAlign: 'center', paddingTop: convertHeight(5) }]} />
                    <View style={{ alignItems: "center", }}>
                        <Image style={{ marginVertical: convertHeight(7), width: 50, height: 36 }} source={logoPath.Miracle_Verticle_logo} resizeMode={'contain'} />
                    </View>
                    {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}
                    <View style={{ margin: 10 }}>
                        <TextView style={styles.textView} textObject={'NewPassword:message:enterVerificationCodeAndPass'} />     
                        <TextInput
                            maxLength={25}
                            editable
                            key="1"
                            outlineColor={colorPalette.grey2}
                            activeOutlineColor={colorPalette.primary.main}
                            value={verification_code}
                            placeholderTextColor={colorPalette.text.primary}
                            onChangeText={(text) => setVerificationCodeAndValidate(text)}
                            label={t('NewPassword:label:enterVerificationCode')}
                            style={{ fontSize: convertHeight(14), backgroundColor: '#FFFFFF' }}
                            mode="outlined"
                            onBlur={() => handleInputBlur('verificationCode')}
                            onFocus={() => handleInputFocus('verificationCode')}
                            underlineColor='transparent'
                            inputAccessoryViewID={InputAccessoryViewID}
                            onSubmitEditing={() => newPasswordInputRef.current.focus()}
                            returnKeyType={'next'}
                        />
                        {!isVerificationCodeValid &&
                            <HelperText type="error" visible={!isVerificationCodeValid}>
                                {verification_code.length == 0 ? t('NewPassword:message:verificationCodeRequired') : verification_code.length == 6 ? '' : t('NewPassword:message:enterValidVerificationCode')}
                            </HelperText>}

                        <TextInput
                            maxLength={25}
                            editable
                            secureTextEntry={secureNewPassword}
                            key="2"
                            outlineColor={colorPalette.grey2}
                            activeOutlineColor={colorPalette.primary.main}
                            value={new_password}
                            placeholderTextColor={colorPalette.text.primary}
                            onChangeText={(text) => setNewPasswordAndValidate(text)}
                            label={t('NewPassword:label:newPassword')}
                            style={{ marginTop: convertHeight(10), fontSize: convertHeight(14), backgroundColor: '#FFFFFF' }}
                            mode="outlined"
                            onBlur={() => handleInputBlur('newPassword')}
                            onFocus={() => handleInputFocus('newPassword')}
                            underlineColor='transparent'
                            inputAccessoryViewID={InputAccessoryViewID}
                            right={secureNewPassword ?
                                <TextInput.Icon name="eye" onPress={() => setSecureNewPassword(false)} /> :
                                <TextInput.Icon name="eye-off" onPress={() => setSecureNewPassword(true)} />
                            }
                            ref={newPasswordInputRef}
                            onSubmitEditing={() => {
                                setIsBlurInput(true);
                                confirmPasswordInputRef.current.focus()
                            }}
                            returnKeyType={'next'}
                        />
                        {!isPasswordValid &&
                        <HelperText type="error" visible={!isPasswordValid}>
                            {new_password.length == 0 ? t('LoginScreen:message:passwordRequired') : new_password.length > 8 ? t('LoginScreen:message:invalidPassword') : t('LoginScreen:message:passwordMustBe8Characters')}
                        </HelperText>}

                        <TextInput
                            maxLength={25}
                            editable
                            secureTextEntry={secureConfirmNewPassword}
                            key="3"
                            outlineColor={colorPalette.grey2}
                            activeOutlineColor={colorPalette.primary.main}
                            value={confirm_new_password}
                            placeholderTextColor={colorPalette.text.primary}
                            onChangeText={(text) => setConfirmNewPasswordAndValidate(text)}
                            label={t('NewPassword:label:confirmNewPassword')}
                            style={{ marginTop: convertHeight(10), fontSize: convertHeight(14), backgroundColor: '#FFFFFF' }} 
                            verification_code
                            mode="outlined"
                            onBlur={() => handleInputBlur('confirmNewPassword')}
                            onFocus={() => handleInputFocus('confirmNewPassword')}
                            underlineColor='transparent'
                            inputAccessoryViewID={InputAccessoryViewID}
                            right={secureConfirmNewPassword ?
                                <TextInput.Icon name="eye" onPress={() => setSecureConfirmNewPassword(false)} /> :
                                <TextInput.Icon name="eye-off" onPress={() => setSecureConfirmNewPassword(true)} />
                            }
                            ref={confirmPasswordInputRef}
                        />
                        <HelperText type="error" visible={!isConfirmPasswordValid}>
                            {confirm_new_password.length == 0 ? t('NewPassword:message:confirmPasswordRequired') : new_password === confirm_new_password ? '' : t('NewPassword:message:passwordDoesNotMatch')}
                        </HelperText>

                        <TouchableOpacity disabled={loading} style={styles.btnContainer} onPress={() => passwordSubmit()}>
                            <TextView style={styles.btnText} textObject={'NewPassword:action:submit'} />
                        </TouchableOpacity>
                    </View>
                    {loading && <View style={{ position: 'absolute', top: 325, left: 185 }}>
                        <ActivityIndicator animating={loading} color={colorPalette.primary.main} size={"large"} style={styles.loader} />
                    </View>}
                </View>
            </KeyboardAwareScrollView>
            <Snackbar onDismiss={() => setErrorNewPassword('')} visible={errorNewPassword != ''} duration={2000}>{t(`NewPassword:message:${errorNewPassword}`)}</Snackbar>
        </SafeAreaView>
    )
}

export default NewPassword