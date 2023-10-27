import React, { useState, useEffect } from "react";
import Modal from "react-native-modal";
import { View, TouchableOpacity, StyleSheet, SafeAreaView, Platform, Image, FlatList, Text } from 'react-native';
import { Avatar } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import Icon from 'react-native-vector-icons/SimpleLineIcons';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Palette from "../../../theme/Palette";
import TextView from "../TextView/TextView";
import { useAuthHandlerContext } from "../../../common/hooks/AuthHandler";

const SideMenuView = (props) => {

    const navigation = useNavigation()
    const [activeLabel, setActiveLabel] = useState('')
    const [attributesData, setUserAttibutesData] = useState('');
    const { logOut, currentLanguageImage, setShowLanguagePrompt, isAppOnline, userAllDetails } = useAuthHandlerContext()

    const manageNavigation = (screenName) => {
        // navigation.navigate(screenName)
        if (screenName !== 'Login') {
            navigation.navigate(screenName, screenName === "AssessmentUpload" ? { forceUpload: false } : {})
        } else {
            navigation.reset({
                index: 0,
                routes: [{ name: screenName }],
            })
        }
        setActiveLabelData(screenName)
        props.onBackdropPress()
    }

    const manageLogout = () => {
        logOut()
        props.onBackdropPress()
    }

    useEffect(() => {
        const startUpCheck = async () => {
            const label = await AsyncStorage.getItem('activeLabel')
            setActiveLabel(label)
        }
        startUpCheck()
    }, [])

    useEffect(() => {
        const getUserAttributes = async () => {
            const userAttributes = await AsyncStorage.getItem('userAttributesKey');
            setUserAttibutesData(userAttributes);
        }
        getUserAttributes()
    }, []);

    const setActiveLabelData = async (label) => {
        try {
            await AsyncStorage.setItem('activeLabel', label)
            setActiveLabel(label)
            console.log("activelabel set : ", label)
        } catch (e) {
            return null
        }
    }

    return (
        <SafeAreaView>
            <Modal isVisible={props.isVisible}
                animationIn="slideInLeft"
                animationOut="slideOutLeft"
                animationInTiming={300}
                onBackdropPress={props.onBackdropPress}
                style={{
                    backgroundColor: 'white',
                    minHeight: '100%',
                    width: '75%',
                    marginLeft: 0,
                    marginVertical: 0,
                    flexDirection: 'column',
                    paddingTop: Platform.OS === 'ios' ? 45 : 0,
                }}>
                <View style={{
                    paddingVertical: 10,
                    backgroundColor: Palette.primary.main,
                    justifyContent: 'center',
                    marginHorizontal: 10,
                    marginVertical: 10,
                    borderRadius: 8
                }}>
                    <TouchableOpacity activeOpacity={0.5} onPress={() => manageNavigation('Profile')}>
                        {/* onPress={() => manageNavigation('Profile')} */}
                        <View style={styles.profileHeader}>
                            <View style={{ flex: 1 }}>
                                {/* <TextView style={{ fontWeight: '800', color: 'white' }} textObject={'SideMenuItem:label:username'} /> */}
                                {/* <Text style={{ fontWeight: '800', color: 'white' }}>{attributesData ? `${JSON.parse(attributesData)?.given_name} ${JSON.parse(attributesData)?.family_name}` : 'User Name'}</Text> */}
                                <Text style={{ fontWeight: '800', color: 'white' }}>{userAllDetails ? `${userAllDetails?.given_name} ${userAllDetails?.family_name}` : 'User Name'}</Text>
                                {/* <TextView style={{ color: 'white' }} textObject={'SideMenuItem:label:profile'} /> */}
                            </View>
                            {/* <Avatar.Image size={68} source={{ uri: "https://dss.mo.gov/child-support/img/custodial-parents-tile.png" }} /> */}
                        </View>
                    </TouchableOpacity>
                </View>

                <View style={{ marginVertical: 18, marginHorizontal: 10 }}>
                    <FlatList
                        keyExtractor={(item, index) => index}
                        style={{ display: "flex" }}
                        data={MenuList}
                        showsVerticalScrollIndicator={false}
                        renderItem={({ item, index }) => <TouchableOpacity activeOpacity={0.5} onPress={() => manageNavigation(item.navId)}>
                            <View style={activeLabel === item.navId ? styles.activeMenuItem : styles.menuItem}>
                                <TextView style={[styles.boldText, { color: 'black' }]} textObject={item.label} />
                            </View>
                        </TouchableOpacity>
                        }
                    />
                </View>
                <View style={{ flex: 1, justifyContent: 'flex-end', paddingVertical: 10 }}>
                    <View style={{ flexDirection: 'row' }}>
                        <TouchableOpacity activeOpacity={0.5}
                            disabled={!isAppOnline}
                            onPress={() => manageLogout()} style={{
                                alignSelf: 'flex-start',
                                marginStart: 10,
                                marginBottom: 20,
                                flexDirection: 'row',
                                alignItems: 'center',
                                backgroundColor: Palette.primary.main,
                                padding: 10,
                                borderRadius: 8,
                                width: '55%'
                            }}>
                            <Icon size={18} name='logout' color='white' />
                            <TextView style={[styles.boldText, { marginStart: 10, color: 'white', fontWeight: 'bold' }]}
                                textObject={'SideMenuItem:label:logOut'} />
                        </TouchableOpacity>
                        <View style={{ flex: 1 }} />
                        <TouchableOpacity activeOpacity={0.5} onPress={() => {
                            props.onBackdropPress()
                            setShowLanguagePrompt(true)

                        }} style={{
                            marginStart: 10,
                            marginBottom: 20,
                            marginEnd: 20,
                            alignSelf: 'center',
                            height: 34,
                            width: 34,
                        }}>
                            <Image
                                style={{
                                    height: '100%',
                                    width: '100%'
                                }}
                                source={{ uri: currentLanguageImage() }}
                            />
                        </TouchableOpacity>
                    </View>
                </View>
            </Modal>
        </SafeAreaView>
    )
}

const MenuList = [
    // {
    //     navId: "CaseList",
    //     label: "SideMenuItem:label:startAnAssessment"
    // },
    // {
    //     navId: "ContinueAssessment",
    //     label: "SideMenuItem:label:continueAnAssessment"
    // },
    // {
    //     navId: "AssessmentUpload",
    //     label: "SideMenuItem:label:upload"
    // },
    {
        navId: "AssessmentView",
        label: "Assessment:label:assessment"
    },
    {
        navId: "ChangePassword",
        label: "SideMenuItem:label:changePassword"
    }
]

const styles = StyleSheet.create({
    menuItem: {
        flexDirection: 'column',
        padding: 10,
        borderRadius: 8,
        backgroundColor: 'ghostwhite',
        marginBottom: 16,
        borderColor: 'lavender',
        borderWidth: 1
    },
    activeMenuItem: {
        flexDirection: 'column',
        padding: 10,
        borderRadius: 8,
        backgroundColor: 'ghostwhite',
        marginBottom: 16,
        borderColor: Palette.primary.light,
        borderWidth: 1
    },
    profileHeader: {
        flexDirection: 'row',
        padding: 10,
        // backgroundColor: 'linen',
        borderRadius: 8,
        alignItems: 'center'
    },
    boldText: {
        fontWeight: '400'
    }
})

export default SideMenuView