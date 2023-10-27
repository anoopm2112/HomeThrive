import React from 'react';
import { Text, View, StyleSheet } from 'react-native';
import { useTranslation } from 'react-i18next';
import MaterialCommunityIcon from 'react-native-vector-icons/MaterialCommunityIcons';
import { convertHeight, convertWidth } from '../../../common/utils/dimensionUtil';
import Palette from '../../../theme/Palette';

const ErrorShowView = () => {
    const { t } = useTranslation();

    const styles = StyleSheet.create({
        mainContainer: {
            backgroundColor: 'red',
            flexDirection: 'row',
            alignItems: 'center',
            paddingBottom: convertHeight(2)
        }, errorText: {
            color: Palette.primary.white,
            fontSize: convertHeight(8),
            fontWeight: 'bold'
        },
        icon: { 
            paddingHorizontal: convertWidth(5),
        }
    });

    return (
        <View style={styles.mainContainer}>
            <MaterialCommunityIcon
                name="information-outline" style={styles.icon}
                size={convertHeight(10)} color={Palette.primary.white} />
            <Text style={styles.errorText}>{t('AssessmentList:message:fieldValidationMsg')}</Text>
        </View>
    )
}

export default ErrorShowView;