import React, { useEffect, useState } from 'react';
import { View, StyleSheet, SafeAreaView, FlatList, Image, TouchableOpacity } from 'react-native'
import Icon from 'react-native-vector-icons/MaterialIcons';
import Footer from '../Components/Footer';
import Header from '../Components/Header';
import TextView from '../Components/TextView/TextView';
import TitleBar from '../Components/TitleBar';
import { List } from 'react-native-paper';
import { useTranslation } from 'react-i18next';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import APIS from '../../common/hooks/useApiCalls';

const AppSettings = ({ toggleMenu, toggleBellIcon }) => {

    const { i18n } = useTranslation()
    const { isAppOnline, setAppLanguage } = useAuthHandlerContext()
    const selectedLanguageCode = i18n.language
    const [expand, setExpand] = useState('')
    const [languages, setLanguages] = useState(languagesInitialValue)

    const setLanguage = async (lang) => {
        setAppLanguage(lang)
    }

    useEffect(() => {
        const fetchLanguages = async () => {
            const languageList = await APIS.Languages()
            if (languageList) {
                setLanguages(languageList.data.languages)
            }
        }
        if (isAppOnline) {
            fetchLanguages()
        }
    }, [isAppOnline])

    return (
        <SafeAreaView style={{
            display: "flex",
            flex: 1
        }}>
            <Header
                toggleDrawer={toggleMenu}
                toggleBellIcon={toggleBellIcon}
            />
            <TitleBar title={'AppSettings:header'} />

            <View style={{ flex: 1, padding: 12 }}>
                <View style={{ backgroundColor: 'white', borderRadius: 10, padding: 8 }}>
                    <TouchableOpacity
                        disabled={!isAppOnline}
                        activeOpacity={0.4}
                        onPress={() => setExpand(expand === 'language' ? '' : 'language')}>
                        <View style={{
                            flexDirection: 'row',
                            alignItems: 'center',
                            margin: 8,
                            borderWidth: 1,
                            padding: 8,
                            borderRadius: 8,
                            borderColor: isAppOnline ? 'black' : 'lightgrey'
                        }}>
                            <TextView textObject={'AppSettings:label:language'}
                                style={{ flex: 1, fontSize: 16, fontWeight: 'bold', color: isAppOnline ? 'black' : 'lightgrey' }} />
                            <Icon
                                name={expand === 'language' ? 'expand-less' : 'expand-more'}
                                color={isAppOnline ? 'black' : 'lightgrey'}
                                size={24} />
                        </View>
                    </TouchableOpacity>
                    <View>
                        {expand === 'language' && <FlatList
                            keyExtractor={(item, index) => index}
                            data={languages}
                            showsVerticalScrollIndicator={false}
                            renderItem={({ item, index }) => <List.Item
                                onPress={() => setLanguage(item)}
                                style={{
                                    flex: 1,
                                    borderRadius: 10,
                                    borderColor: item.languageCode === selectedLanguageCode ? 'green' : 'lightgrey',
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
                                    item.languageCode === selectedLanguageCode ? <Icon {...props}
                                        name={'check-circle'}
                                        color={'green'}
                                        size={22}
                                        style={{ alignSelf: 'center', height: 24 }} /> : <></>
                                }
                            />}
                        />}
                    </View>
                </View>
            </View>

            {/* <Footer /> */}
        </SafeAreaView>
    )
}

const languagesInitialValue = [
    {
        language: 'English',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/197/197484.png',
        languageCode: 'en',
        id: '1'
    },
    {
        language: 'Hindi',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/197/197419.png',
        languageCode: 'hi',
        id: '2'
    }
]

const styles = StyleSheet.create({
    parent: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        flex: 1
    },
    labelTyle: {
        marginHorizontal: 6,
        color: 'black',
        flex: 1
    }
})

export default AppSettings

