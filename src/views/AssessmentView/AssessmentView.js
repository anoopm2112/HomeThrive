import React, { useEffect } from 'react';
import { View, Text, StyleSheet, Image, ScrollView, TouchableOpacity } from 'react-native';
import { useTranslation } from 'react-i18next';
// Custom Pages
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import Header from '../Components/Header';
import TitleBar from '../Components/TitleBar';
import logoPath from '../../common/Path';
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';

export default function AssessmentView({ navigation, toggleMenu, toggleBellIcon }) {
    const { t } = useTranslation();
    const { logScreen, isAppOnline, hasNewNotifications } = useAuthHandlerContext();

    useEffect(() => {
        const logScreenAnalytics = () => {
            logScreen(ScreenConfigs.assessmentView);
        }
        if (isAppOnline) {
            logScreenAnalytics();
        }
    }, []);

    const manageNavigation = (screenName) => {
        if (screenName !== 'Login') {
            navigation.navigate(screenName, screenName === "AssessmentUpload" ? { forceUpload: false } : {})
        } else {
            navigation.reset({
                index: 0,
                routes: [{ name: screenName }],
            })
        }
    }

    const styles = StyleSheet.create({
        mainContainer: {
            paddingVertical: convertHeight(30),
            paddingHorizontal: convertWidth(20),
        },
        boxContainer: {
            height: convertWidth(130),
            width: convertWidth(130),
            borderRadius: convertWidth(8),
            elevation: 5,
            backgroundColor: '#F27227',
            justifyContent: 'center',
            alignItems: 'center',
            marginHorizontal: convertWidth(10),
            paddingHorizontal: convertWidth(5),
        },
        image: {
            height: convertHeight(30),
            width: convertHeight(30)
        },
        textView: {
            paddingTop: convertHeight(10),
            fontSize: convertHeight(14),
            color: '#FFFFFF',
            fontWeight: '600'
        }
    });

    return (
        <View>
            <Header toggleDrawer={toggleMenu} toggleBellIcon={toggleBellIcon} hasNewNotifications={hasNewNotifications} />
            <TitleBar goBack={() => navigation.goBack()} title={'Assessment:label:assessment'} hideBack={false} />
            <ScrollView>
                <View style={styles.mainContainer}>
                    <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                        <TouchableOpacity onPress={() => manageNavigation('CaseList')} activeOpacity={0.6} style={styles.boxContainer}>
                            <Image source={logoPath.new_assessment_icon} resizeMode={'contain'} style={styles.image} />
                            <Text style={styles.textView}>{t('Assessment:label:new')}</Text>
                        </TouchableOpacity>
                        <TouchableOpacity onPress={() => manageNavigation('ContinueAssessment')} activeOpacity={0.6} style={styles.boxContainer}>
                            <Image source={logoPath.incomplete_assessment_icon} resizeMode={'contain'} style={styles.image} />
                            <Text style={styles.textView}>{t('Assessment:label:incomplete')}</Text>
                        </TouchableOpacity>
                    </View>
                    {/* <View style={{ flexDirection: 'row', justifyContent: 'space-between', paddingTop: convertHeight(30) }}>
                        <TouchableOpacity onPress={() => {}} activeOpacity={0.6} style={styles.boxContainer}>
                            <Image source={logoPath.overdue_assessment_icon} resizeMode={'contain'} style={styles.image} />
                            <Text style={styles.textView}>{t('Assessment:label:overdue')}</Text>
                        </TouchableOpacity>
                        <TouchableOpacity onPress={() => {}} activeOpacity={0.6} style={styles.boxContainer}>
                            <Image source={logoPath.complete_assessment_icon} resizeMode={'contain'} style={styles.image} />
                            <Text style={styles.textView}>{t('Assessment:label:complete')}</Text>
                        </TouchableOpacity>
                    </View> */}
                    <View style={{ flexDirection: 'row', justifyContent: 'space-between', paddingTop: convertHeight(30) }}>
                        <TouchableOpacity onPress={() => manageNavigation('AssessmentUpload')} activeOpacity={0.6} style={styles.boxContainer}>
                            <Image source={logoPath.upload_assessment_icon} resizeMode={'contain'} style={styles.image} />
                            <Text style={styles.textView}>{t('Assessment:label:upload')}</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </ScrollView>
        </View>
    )
}