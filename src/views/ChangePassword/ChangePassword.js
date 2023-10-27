import React, { useEffect, useState, useRef } from 'react'
import { View, SafeAreaView, TouchableOpacity, Keyboard, Platform, StyleSheet } from 'react-native';
import { ActivityIndicator, HelperText, Snackbar, TextInput } from 'react-native-paper';
import colorPalette from '../../theme/Palette';
// import logoPath from '../../common/Path';
import { changePasswordSubmit } from '../../common/contexts/CognitoHandler';
import TextView from '../Components/TextView/TextView';
import { useTranslation } from 'react-i18next';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import Constants from '../../common/hooks/Constants';
import Header from '../Components/Header';
import TitleBar from '../Components/TitleBar';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';

const ChangePassword = ({ navigation, toggleMenu, toggleBellIcon }) => {
    const { logScreen, isAppOnline, hasNewNotifications } = useAuthHandlerContext();
    const { t } = useTranslation();

    const [loading, setLoading] = useState(false);
    // TextField
    const [currentPassword, setCurrentPassword] = useState('');
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    // Validation
    const [isCurrentPasswordValid, setIsCurrentPasswordValid] = useState(true);
    const [isNewPasswordValid, setIsNewPasswordValid] = useState(true);
    const [isConfirmPasswordValid, setIsConfirmPasswordValid] = useState(true);
    // Security
    const [secureCurrentPassword, setSecureCurrentPassword] = useState(true);
    const [secureNewPassword, setSecureNewPassword] = useState(true);
    const [secureConfirmPassword, setSecureConfirmPassword] = useState(true);
    const [error, setError] = useState('');
    const [isProcessCompleted, setIsProcessCompleted] = useState(false);

    const InputAccessoryViewID = 'changePasswordID';
    // Reference
    const newPasswordInputRef = useRef();
    const confirmPasswordInputRef = useRef();

    useEffect(() => {
        const logScreenAnalytics = () => {
            logScreen(ScreenConfigs.changePassword)
        }
        if (isAppOnline) {
            logScreenAnalytics()
        }
    }, [])

    const setNewPasswordAndValidate = (pass) => {
        setNewPassword(pass)
        setIsNewPasswordValid(Constants.validatePassword(pass))
    }

    const setConfirmNewPasswordAndValidate = (pass) => {
        setConfirmPassword(pass)
        setIsConfirmPasswordValid(newPassword === pass)
    }

    const setCurrentPasswordAndValidate = (pass) => {
        setCurrentPassword(pass)
        setIsCurrentPasswordValid(Constants.validatePassword(pass))
    }

    const changePassword = () => {
        Keyboard.dismiss()
        let isValid = true
        if (!Constants.validatePassword(currentPassword)) {
            setIsCurrentPasswordValid(false)
            isValid = false
        } else {
            setIsCurrentPasswordValid(true)
        }
        if (!Constants.validatePassword(newPassword)) {
            setIsNewPasswordValid(false)
            isValid = false
        } else {
            setIsNewPasswordValid(true)
        }
        if (newPassword !== confirmPassword || confirmPassword.length == 0) {
            setIsConfirmPasswordValid(false)
            isValid = false
        } else {
            setIsConfirmPasswordValid(true)
        }
        if (!isValid) {
            return
        }

        setLoading(true)
        try {
            changePasswordSubmit(currentPassword, newPassword)
                .then((res) => {

                    setLoading(false)

                    if (res.toString().includes('NotAuthorizedException')) {
                        showError("Current password is invalid")
                        setIsCurrentPasswordValid(false)
                        return
                    }
                    if (res.toString().includes('NotAuthorizedException')) {
                        showError("Attempt limit exceeded, please try after some time.")
                        return
                    }

                    setIsProcessCompleted(true)
                    setTimeout(() => {
                        navigation.goBack()
                    }, 2500)
                })
        }
        catch (err) {
            console.log("error in forgotPassword api call")
        }
    }

    const showError = (message) => {
        setError(message)
        setTimeout(() => {
            setError('')
        }, 3000)
    }

    const styles = StyleSheet.create({
        btnContainer: {
            // height: 48,
            backgroundColor: colorPalette.button.main,
            borderRadius: 7,
            marginTop: 20,
            alignItems: "center",
            justifyContent: "center"
        },
        btnText: {
            color: colorPalette.primary.white,
            fontSize: 16,
            fontWeight: "500",
            paddingVertical: convertHeight(11), 
            paddingHorizontal: convertWidth(6)
        },
        successMsgTxt: {
            fontSize: 19,
            fontWeight: 'bold',
            color: 'black'
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
        <SafeAreaView style={{ backgroundColor: "#f5f5f5", flex: 1 }}>
            <Header toggleDrawer={toggleMenu} toggleBellIcon={toggleBellIcon} hasNewNotifications={hasNewNotifications} />
            <TitleBar title={'ChangePassword:header'} />
            {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}
            {!isProcessCompleted ?
                <KeyboardAwareScrollView keyboardShouldPersistTaps="handled" showsVerticalScrollIndicator={false}>
                    <View style={{ marginHorizontal: 25, marginVertical: 20 }}>
                        <TextInput
                            multiline={false}
                            maxLength={25}
                            editable
                            key="1"
                            outlineColor={colorPalette.grey2}
                            activeOutlineColor={colorPalette.primary.main}
                            value={currentPassword}
                            placeholderTextColor={colorPalette.text.primary}
                            secureTextEntry={secureCurrentPassword}
                            onChangeText={(text) => setCurrentPasswordAndValidate(text)}
                            label={t('ChangePassword:label:currentPassword')}
                            style={{ fontSize: 15 }}
                            mode="outlined"
                            underlineColor='transparent'
                            inputAccessoryViewID={InputAccessoryViewID}
                            onSubmitEditing={() => newPasswordInputRef.current.focus()}
                            returnKeyType={'next'}
                            right={secureCurrentPassword ?
                                <TextInput.Icon name="eye" onPress={() => setSecureCurrentPassword(false)} /> :
                                <TextInput.Icon name="eye-off" onPress={() => setSecureCurrentPassword(true)} />
                            }
                        />
                        {/* <HelperText type="error" visible={!isCurrentPasswordValid}>
                            {error === '' ? currentPassword.length === 0 ? t('ChangePassword:message:currentPasswordRequired') : currentPassword.length < 8 ?  t('ChangePassword:message:currentPasswordIsInvalid') : '' : error}
                        </HelperText> */}
                        {!isCurrentPasswordValid &&
                            <HelperText type="error" visible={!isCurrentPasswordValid}>
                            {currentPassword.length == 0 ? t('ChangePassword:message:currentPasswordRequired') : currentPassword.length > 8 ? t('LoginScreen:message:invalidPassword') :  t('LoginScreen:message:passwordMustBe8Characters')}
                        </HelperText>}

                        <TextInput
                            multiline={false}
                            maxLength={25}
                            editable
                            key="2"
                            outlineColor={colorPalette.grey2}
                            activeOutlineColor={colorPalette.primary.main}
                            value={newPassword}
                            placeholderTextColor={colorPalette.text.primary}
                            secureTextEntry={secureNewPassword}
                            onChangeText={(text) => setNewPasswordAndValidate(text)}
                            label={t('ChangePassword:label:newPassword')}
                            style={{ marginTop: 10, fontSize: 15 }}
                            mode="outlined"
                            underlineColor='transparent'
                            inputAccessoryViewID={InputAccessoryViewID}
                            right={secureNewPassword ?
                                <TextInput.Icon name="eye" onPress={() => setSecureNewPassword(false)} /> :
                                <TextInput.Icon name="eye-off" onPress={() => setSecureNewPassword(true)} />
                            }
                            ref={newPasswordInputRef}
                            onSubmitEditing={() => confirmPasswordInputRef.current.focus()}
                            returnKeyType={'next'}
                        />
                        {!isNewPasswordValid &&
                            <HelperText type="error" visible={!isNewPasswordValid}>
                                {newPassword.length == 0 ? t('ChangePassword:message:newPasswordRequired') : newPassword.length > 8 ? t('LoginScreen:message:invalidPassword') : t('LoginScreen:message:passwordMustBe8Characters')}
                            </HelperText>}

                        <TextInput
                            multiline={false}
                            maxLength={25}
                            editable
                            key="3"
                            outlineColor={colorPalette.grey2}
                            activeOutlineColor={colorPalette.primary.main}
                            value={confirmPassword}
                            placeholderTextColor={colorPalette.text.primary}
                            secureTextEntry={secureConfirmPassword}
                            onChangeText={(text) => setConfirmNewPasswordAndValidate(text)}
                            label={t('ChangePassword:label:confirmNewPassword')}
                            style={{
                                marginTop: 10,
                                fontSize: 15
                            }} verification_code
                            mode="outlined"
                            underlineColor='transparent'
                            inputAccessoryViewID={InputAccessoryViewID}
                            right={secureConfirmPassword ?
                                <TextInput.Icon name="eye" onPress={() => setSecureConfirmPassword(false)} /> :
                                <TextInput.Icon name="eye-off" onPress={() => setSecureConfirmPassword(true)} />
                            }
                            ref={confirmPasswordInputRef}
                        />
                        {!isConfirmPasswordValid &&
                            <HelperText type="error" visible={!isConfirmPasswordValid}>
                                {confirmPassword.length == 0 ? t('ChangePassword:message:confirmPasswordRequired') : newPassword === confirmPassword ? '' : t('ChangePassword:message:passwordDoesNotMatch')}
                            </HelperText>}

                        <TouchableOpacity style={styles.btnContainer} onPress={() => changePassword()}>
                            <TextView style={styles.btnText} textObject={'ChangePassword:action:submit'} />
                        </TouchableOpacity>
                    </View>
                </KeyboardAwareScrollView>
                :
                <View style={{ height: '90%', justifyContent: 'center', alignItems: 'center' }}>
                    <View style={{ alignItems: 'center' }}>
                        <TextView style={styles.successMsgTxt} textObject={'ChangePassword:message:successMessage:part1'} />
                        <TextView textObject={'ChangePassword:message:successMessage:part2'} />
                    </View>
                </View>
            }
            {loading && <ActivityIndicator animating={loading} color={colorPalette.primary.main} size={"large"} style={styles.loader} />}
            <Snackbar visible={error.length > 0}>{error}</Snackbar>
        </SafeAreaView>
    )
}

export default ChangePassword
