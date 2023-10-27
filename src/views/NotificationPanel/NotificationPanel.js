import React, { useEffect, useState } from 'react'
import { View, StyleSheet } from 'react-native'
import { List, Text, Switch } from 'react-native-paper';
import { FlatList, ActivityIndicator } from 'react-native';
import RBSheet from "react-native-raw-bottom-sheet";
import TextView from '../Components/TextView/TextView';
import Icon from 'react-native-vector-icons/FontAwesome';
import colorPalette from '../../theme/Palette';
import Theme from '../../theme/Theme';
import APIS from '../../common/hooks/useApiCalls';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import { convertHeight } from '../../common/utils/dimensionUtil';

const NotificationPanel = ({ reference, onDismiss, state }) => {

    const [notificationList, setNotificationList] = useState([]);
    const [loading, setLoading] = useState(false);
    const [loadMore, setLoadMore] = useState(false);
    const [pageCount, setPageCount] = useState(1);
    const [page, setPage] = useState(1);
    const [isSwitchOn, setIsSwitchOn] = useState(false);

    const { logScreen, setHasNewNotifications } = useAuthHandlerContext()

    const fetchNotifications = async () => {
        setLoading(true)
        setLoadMore(false)
        // setIsSwitchOn(false)

        let payloadData = {
            'rowCount': 10,
            'pageNumber': page,
        };
        if (isSwitchOn) {
            payloadData.readStatusFilter = "false";
        }
        const data = await APIS.NotificationList(JSON.stringify(payloadData))
        if (notificationList.length === 0) {
            setNotificationList(data.data.data)
        } else {
            setNotificationList([...notificationList, ...data.data.data])
        }
        setPageCount(data.data.pageCount)
        setPage(page + 1)
        setLoading(false)
    }

    useEffect(() => {
        if (state === 'open') {
            logScreen(ScreenConfigs.notificationPanel)
            setHasNewNotifications(false)
            if (!loading) {
                fetchNotifications()
            }
        } else {
            setPageCount(1)
            setPage(1)
            setLoadMore(false)
            setNotificationList([])
        }
    }, [state, loadMore])

    const onToggleSwitch = async () => {
        setPage(1);
        let payloadData = {
            'rowCount': 10,
            'pageNumber': 1,
        };
        if(!isSwitchOn) {
            setNotificationList([]);
            setIsSwitchOn(true);
            setLoading(true)
            payloadData.readStatusFilter = "false";
        } else {
            setNotificationList([]);
            setIsSwitchOn(false);
            setLoading(true)
        } 

        const data = await APIS.NotificationList(JSON.stringify(payloadData));
        setLoading(false)
        setNotificationList(data.data.data);
    }

    const NotificationMessage = ({ item, index, totalLength }) => {
        const [expand, setExpand] = useState(false);
        const updateNotification = async (id) => {
            if (!item.readStatus) {
                await APIS.NotificationUpdate(id, true);
            }
        }

        return (
            <List.Item
                onPress={() => {
                    updateNotification(item.id)
                    setExpand(!expand)
                }}
                style={[styles.listContainer, { marginBottom: index === totalLength - 1 ? 20 : 0, borderLeftWidth: !item.readStatus ? 5 : 0 , borderLeftColor : !item.readStatus ? colorPalette.primary.main : '#FFFFFF' }]}
                descriptionStyle={{ color: 'grey' }}
                title={(props) => <Text {...props} style={{ fontWeight: '600' }}>{item.title}</Text>}
                descriptionNumberOfLines={expand ? 10 : 1}
                description={item.body}
            />
        )
    }

    const onDismissBtn = () => {
        setIsSwitchOn(false);
        onDismiss();
    }

    const styles = StyleSheet.create({
        listContainer: {
            flex: 1,
            borderRadius: 8,
            backgroundColor: 'white',
            marginTop: 10,
            margin: 8,
            ...colorPalette.shadowProps.default
        },
        headerContainer: {
            flexDirection: 'row',
            justifyContent: 'center',
            padding: 20
        },
        textView: { 
            fontSize: 17, 
            flex: 1, 
            fontWeight: '600', 
            color: 'black'
        },
        secondContainer: {
            flexDirection: 'row',
            justifyContent: 'center',
            padding: 10
        },
        activityIndicator: {
            marginTop: 10,
            backgroundColor: 'transparent',
            borderRadius: 10,
            position: 'absolute',
            top: 0, left: 0, right: 0, bottom: 0,
        }
    });

    return (
        <RBSheet
            ref={reference}
            onClose={() => onDismissBtn()}
            height={600}
            animationType={'none'}
            closeOnPressBack={true}
            openDuration={250}
            customStyles={{
                container: {
                    justifyContent: "center",
                    alignItems: "center",
                    backgroundColor: Theme.safeAreaStyle.backgroundColor,
                    paddingTop: notificationList.length === 0 && !loading ? convertHeight(41) : 0
                },
            }}>
            <View style={styles.headerContainer}>
                <TextView style={styles.textView} textObject={'NotificationPanel:header'} />
                <Icon name={"close"} size={20} color={'#052536'} onPress={() => onDismiss()} />
            </View>
            <View style={styles.secondContainer}>
                <TextView style={[styles.textView, { paddingHorizontal: 10 }]} textObject={'NotificationPanel:unreadNotification'} />
                <Switch value={isSwitchOn} onValueChange={onToggleSwitch} />
            </View>
            {notificationList.length === 0 && !loading ?
            <View style={{ paddingTop: convertHeight(50) }}>
                <TextView style={styles.textView} textObject={'NotificationPanel:noNotification'} />
            </View>
            :
            <FlatList
                keyExtractor={(item, index) => index}
                style={{ display: "flex", width: '92%' }}
                onEndReached={() => {
                    if (page < pageCount) {
                        setLoadMore(true)
                    }
                }}
                onEndReachedThreshold={0.2}
                data={notificationList}
                showsVerticalScrollIndicator={false}
                renderItem={({ item, index }) => <NotificationMessage item={item} index={index} totalLength={notificationList.length} />}
            />}
            {loading && <ActivityIndicator animating={loading} color={colorPalette.primary.main} size={"large"} style={styles.activityIndicator} />}
        </RBSheet>
    )
}

export default NotificationPanel