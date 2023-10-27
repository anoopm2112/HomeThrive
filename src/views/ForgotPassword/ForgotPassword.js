import React, { useEffect, useState } from 'react'
import { View, SafeAreaView, Image, TouchableOpacity, Platform, StyleSheet, Text, Keyboard } from 'react-native';
import { TextInput, HelperText, ActivityIndicator, Snackbar } from 'react-native-paper';
import colorPalette from '../../theme/Palette';
import colorTheme from '../../theme/Theme';
import logoPath from '../../common/Path';
import { forgotPassword } from '../../common/contexts/CognitoHandler';
import Constants from '../../common/hooks/Constants';
import Theme from '../../theme/Theme';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs'
import { useTranslation } from 'react-i18next';
import TextView from '../Components/TextView/TextView';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';
import { CommonAppStyle } from '../../common/CommonAppStyle';
import { LANGUAGE_CODE } from '../../common/constant';

const ForgotPassword = ({ navigation }) => {
    const { t } = useTranslation();
    const { logScreen, isAppOnline, currentLanguage } = useAuthHandlerContext();

    const [loading, setLoading] = useState(false);
    // TextField
    const [email, setEmail] = useState("");
    const [isEmailInValid, setEmailInValid] = useState(false);
    // Error
    const [error, setError] = useState('');

    const InputAccessoryViewID = 'forgetPasswordID';

    useEffect(() => {
        const logScreenAnalytics = () => { logScreen(ScreenConfigs.forgotPassword) }
        if (isAppOnline) { logScreenAnalytics() }
    }, []);

    // FORGET PASSWORD API CALL
    const submitForgotPassword = () => {
        Keyboard.dismiss();
        setLoading(true)
        try {
            forgotPassword(email)
                .then((res) => {
                    setLoading(false)
                    // if (res && res["CodeDeliveryDetails"]) {
                        navigation.navigate('NewPassword', { email: email })
                    // } else {
                    //     console.log("User does not exist.")
                    //     showError('User does not exist.')
                    // }

                })
        } catch (err) {
            console.log("Please try after sometime.")
        }
    }

    const onSubmitAction = () => {
        const isValid = Constants.validateEmail(email)
        setEmailInValid(!isValid)
        if (isValid) {
            submitForgotPassword()
        }
    }

    const setEmailAndValidate = (email) => {
        setEmail(email)
        setEmailInValid(!Constants.validateEmail(email))
    }

    // const showError = (message) => {
    //     setError(message)
    //     setTimeout(() => { setError('') }, 3000);
    // }

    const styles = StyleSheet.create({
        htIcon: {
            width: 50,
            height: 36
        },
        btnContainer: {
            height: convertHeight(47),
            backgroundColor: colorPalette.button.main,
            borderRadius: 6,
            alignItems: "center",
            justifyContent: "center",
            marginVertical: 20,
        },
        btnText: {
            color: colorPalette.primary.white,
            fontSize: convertHeight(14),
            fontWeight: "500"
        },
        activityLoading: {
            backgroundColor: 'transparent',
            position: 'absolute',
            top: 0, left: 0, right: 0, bottom: 0,
        }
    });

    return (
        <SafeAreaView style={[Theme.safeAreaStyle, { flex: 1 }]}>
            <KeyboardAwareScrollView keyboardShouldPersistTaps="handled" showsVerticalScrollIndicator={false} contentContainerStyle={{ flex: 1, justifyContent: 'center' }}>
                
                {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}
                <View style={{ flex: 1, justifyContent: 'center' }}>
                    {/* HEADER */}
                    <View style={{ flex: 0.5, justifyContent: 'center', alignItems: 'center' }}>
                        <TextView textObject={'LoginScreen:thriveScale'} style={[colorTheme.primaryLabel, CommonAppStyle?.[currentLanguage.languageCode].logo_header]} />
                        <TextView textObject={'LoginScreen:poweredBy'} style={[colorTheme.secondaryLabel, { fontSize: 15, color: '#8A8A8A', textAlign: 'center', paddingTop: convertHeight(8) }]} />
                        <View style={{ alignItems: "center", paddingTop: convertHeight(10) }}>
                            <Image style={styles.htIcon} resizeMode={'contain'} source={logoPath.Miracle_Verticle_logo} />
                        </View>
                    </View>

                    <View style={{ flex: 1, paddingHorizontal: convertWidth(30) }}>
                        {/* FORGET PASSWORD VIEW */}
                        <TextView textObject={'ForgotPassword:label:forgotPassword'} style={[Theme.secondaryLabel, { marginVertical: 10, fontSize: convertHeight(14) }]} />
                        <TextInput
                            editable
                            key="1"
                            outlineColor={colorPalette.grey2}
                            activeOutlineColor={colorPalette.primary.main}
                            value={email}
                            placeholderTextColor={colorPalette.text.primary}
                            onChangeText={(text) => setEmailAndValidate(text)}
                            label={`${t('ForgotPassword:label:enterEmail')}${'*'}`}
                            style={{ fontSize: convertHeight(14), textAlign: 'auto', backgroundColor: '#FFFFFF' }}
                            mode="outlined"
                            underlineColor='transparent'
                            inputAccessoryViewID={InputAccessoryViewID}
                            keyboardType="email-address"
                            autoCapitalize='none'
                        />
                        <HelperText type="error" visible={isEmailInValid}>
                            {email.length > 0 ? t('ForgotPassword:message:invalidEmail') : t('ForgotPassword:message:emailRequired')}
                        </HelperText>

                        {/* SUBMIT BUTTON */}
                        <TouchableOpacity style={[colorTheme.button, { borderRadius: 6, marginTop: convertHeight(20) }]} onPress={() => onSubmitAction()}>
                            <TextView style={styles.btnText} textObject={'Common:label:submit'} />
                        </TouchableOpacity>
                    </View>
                </View>
                {loading && <ActivityIndicator animating={loading} color={colorPalette.primary.main} size={"large"} style={styles.activityLoading} />}
            </KeyboardAwareScrollView>
            {/* <Snackbar visible={error.length > 0}>{error}</Snackbar> */}

            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH &&
                <Snackbar visible={error.length > 0}>
                    {
                        error === 'User does not exist.' ? <Text>User does not exist.</Text> :
                        error === 'Incorrect username or password.' ? <Text>Either the username was not found or the password is incorrect. Please try again or use 'forgot password'.</Text> : error
                    }
                </Snackbar>
            }
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI &&
                <Snackbar visible={error.length > 0}>
                    {
                        error === 'User does not exist.' ? <Text>उपयोगकर्ता मौजूद नहीं है</Text> :
                        error === 'Incorrect username or password.' ? <Text>या तो उपयोगकर्ता नाम नहीं मिला या पासवर्ड गलत है। कृपया पुन: प्रयास करें या 'पासवर्ड भूल गए' का उपयोग करें।</Text> : error
                    }
                </Snackbar>
            }
            {currentLanguage.languageCode === LANGUAGE_CODE.LANG_TAMIL &&
                <Snackbar visible={error.length > 0}>
                    {
                        error === 'User does not exist.' ? <Text>பயனர் இல்லை.</Text> :
                        error === 'Incorrect username or password.' ? <Text>பயனர் பெயர் கிடைக்கவில்லை அல்லது கடவுச்சொல் தவறாக உள்ளது. மீண்டும் முயற்சிக்கவும் அல்லது 'கடவுச்சொல்லை மறந்துவிட்டேன்' என்பதைப் பயன்படுத்தவும்.</Text> : error
                    }
                </Snackbar>
            }
        </SafeAreaView>
    )
}

export default ForgotPassword;
