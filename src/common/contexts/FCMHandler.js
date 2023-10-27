import messaging from '@react-native-firebase/messaging';
import AsyncStorage from "@react-native-async-storage/async-storage";
import APIS from '../hooks/useApiCalls';
import notify, { AndroidImportance } from '@notifee/react-native';


export const getFCMToken = async () => {
    try {
        const fcmToken = await AsyncStorage.getItem('thrive_scale_fcm_token')
        if (!fcmToken) {
            const newToken = await messaging().getToken()
            await AsyncStorage.setItem('thrive_scale_fcm_token', newToken)
            // upload token to server
            const data = await APIS.RegisterDeviceForPushNotification(newToken)
            if (data.data && data.data.Message && data.data.Message.includes('saved Successfully')) {
                console.log("FCM Token Saved successfully");
            }
        }
    } catch (err) {
        console.log('FCM Token error >> ', err);
    }
}

export const hasPermissionIniOS = async () => {
    const authStatus = await messaging().requestPermission();
    const enabled =
        authStatus === messaging.AuthorizationStatus.AUTHORIZED ||
        authStatus === messaging.AuthorizationStatus.PROVISIONAL;

    return enabled
}

export const notificationListener = async (hasNewNotifications, setHasNewNotifications) => {
    messaging().onMessage(async remoteMessage => {
        onDisplayNotification(remoteMessage?.notification?.title, remoteMessage?.notification?.body)
        if (!hasNewNotifications) {
            setHasNewNotifications(true)
        }
    })

    messaging().onNotificationOpenedApp(remoteMessage => {
        console.log('Notification caused app to open from background state:');
        // navigation.navigate(remoteMessage.data.type);
    });

    messaging()
        .getInitialNotification()
        .then(remoteMessage => {
            if (remoteMessage) {
                console.log('Notification caused app to open from quit state:');
                // setInitialRoute(remoteMessage.data.type); // e.g. "Settings"
            }
        });
}

export const setBackgroundMessageHandler = async () => {
    messaging().setBackgroundMessageHandler(async remoteMessage => {
        await AsyncStorage.setItem('thrive_scale_fcm_has_new_notification', 'true')
    })
    notify.onBackgroundEvent(async ({ type, detail }) => {
        // const { notification, pressAction } = detail;
      
        // // Check if the user pressed the "Mark as read" action
        // if (type === EventType.ACTION_PRESS && pressAction.id === 'mark-as-read') {
        //   // Remove the notification
        //   await notify.cancelNotification(notification.id);
        // }
      });
}

export const onDisplayNotification = async (title = '', body = '') => {
    // Create a channel
    const channelId = await notify.createChannel({
        id: 'general',
        name: 'General',
        importance: AndroidImportance.HIGH,
    });

    // Display a notification
    const postNotification = await notify.displayNotification({
        title: title,
        body: body,
        android: {
            channelId,
            // color: '#4caf50',
            //   smallIcon: 'name-of-a-small-icon', // <---- optional, defaults to 'ic_launcher'.
        },
    });

}

export const hasNotificationPermissionForIOS = async () => {
    const access = await notify.requestPermission()
    return settings.authorizationStatus !== AuthorizationStatus.DENIED
}
