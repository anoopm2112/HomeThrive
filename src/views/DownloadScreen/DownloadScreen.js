import React, { useState, useEffect } from 'react';
import { View, SafeAreaView, Text } from 'react-native';
import { ProgressBar, Button, Avatar } from 'react-native-paper'
import colorPalette from '../../theme/Palette';
import Header from '../Components/Header';

import { useOfflineDataContext } from '../../helpers/OfflineOperationHandler';
import Constants from '../../common/hooks/Constants';
import Icon from 'react-native-vector-icons/FontAwesome5';
// import { useNavigation } from '@react-navigation/native';
import TitleBar from '../Components/TitleBar';
import { useTranslation } from 'react-i18next';
import TextView from '../Components/TextView/TextView'
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';

const DownloadScreen = ({ toggleMenu, toggleBellIcon }) => {

    // const navigation = useNavigation()

    const { callOfflineOperation, isAppOnline, operationResult, handleContinue } = useOfflineDataContext()
    const [isDownloading, setIsDownloading] = useState(false)
    const { t } = useTranslation()
    const [isDownloadComplete, setIsDownloadComplete] = useState(false)

    const { logScreen } = useAuthHandlerContext()

    useEffect(() => {
        const logScreenAnalytics = () => {
            logScreen(ScreenConfigs.download)
        }
        if (isAppOnline) {
            logScreenAnalytics()
        }
    }, [])


    useEffect(() => {
        switch (operationResult.operationKey) {
            case Constants.offlineOperations.downloadData:
                setIsDownloading(false)
                setIsDownloadComplete(operationResult.data === 'success')
                return
        }
    }, [operationResult])

    useEffect(() => {
        handleContinue(isDownloading)
        if (isDownloading) {
            console.log('Offline Handler: callOfflineOperation >> Called')
            callOfflineOperation(Constants.createRequest(Constants.offlineOperations.downloadData, {}))
        }
    }, [isDownloading])

    const handleDownloadProcess = () => {
        setIsDownloading(!isDownloading)
    }

    return (
        <SafeAreaView style={{ flex: 1 }}>
            <Header
                toggleDrawer={toggleMenu}
                toggleBellIcon={toggleBellIcon}
            />
            <TitleBar />
            {!isDownloadComplete ? <View style={{ flex: 1 }}>
                <View style={{ justifyContent: 'flex-end', alignItems: 'center', flex: 1 }}>
                    <Text style={{ fontSize: 20, fontWeight: 'bold' }}>{t('Download:header')}</Text>
                    <Text style={{ textAlign: 'center' }}>{t('Download:message:downloadMessage:part1')}{'\n'}{t('Download:message:downloadMessage:part2')}</Text>
                </View>
                {!isDownloading && <View style={{ justifyContent: 'center', flex: 1 }}>
                    <Avatar.Icon size={50} icon="download" color='darkslategrey' style={{ alignSelf: 'center', margin: 30, backgroundColor: '#0000' }} />
                </View>}
                {isDownloading && <View style={{ justifyContent: 'center', flex: 1 }}>
                    <ProgressBar progress={0.5}
                        color={colorPalette.primary.main}
                        indeterminate
                        style={{ width: '50%', height: 8, borderRadius: 10, alignSelf: 'center' }} />
                    <Text style={{ alignSelf: 'center', marginTop: 8 }}>{t('Download:message:downloading')}</Text>
                </View>}
                <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
                    <Button icon={isDownloading ? 'stop' : 'download'}
                        mode="contained"
                        onPress={() => handleDownloadProcess()}
                        style={{ width: '40%', borderRadius: 20 }}
                        labelStyle={{ color: 'white' }}
                        disabled={!isAppOnline}
                    >
                        {isDownloading ? t('Download:message:stop') : t('Download:message:start')}
                    </Button>
                </View>
            </View> : <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
                <Icon
                    name={'check'}
                    color={'white'}
                    size={15}
                    style={{
                        backgroundColor: 'green',
                        alignContent: 'center',
                        padding: 6,
                        borderRadius: 28,
                        marginVertical: 10,
                        height: 28,
                        width: 28
                    }}
                />
                <TextView style={{ fontSize: 17 }} textObject={'Download:message:success'} />
            </View>}
        </SafeAreaView>
    )
}

export default DownloadScreen