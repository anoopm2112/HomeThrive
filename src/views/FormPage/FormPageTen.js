import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image, ScrollView } from 'react-native';
import { useTranslation } from 'react-i18next';
// Custom Imports
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';
import Path from '../../common/Path';

const FormPageTen = (props) => {
    const { navigation } = props;

    const { t } = useTranslation();

    const styles = StyleSheet.create({
        returnToCalendar: {
            paddingVertical: convertHeight(10),
            backgroundColor: '#1D334B',
            justifyContent: 'center',
            alignItems: 'center',
            borderRadius: convertHeight(4),
            width: convertWidth(300)
        },
        imageIcon: {
            height: convertHeight(132),
            width: convertWidth(160)
        }
    });

    return (
        <ScrollView contentContainerStyle={{ flexGrow: 1 }} showsVerticalScrollIndicator={false}>
            <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
                <View style={{ flex: 1, justifyContent: 'center' }}>
                    <Text style={{ fontWeight: 'bold', fontSize: convertHeight(20), color: '#000000' }}>{t('Assessment:label:thriveScaleComplete')}</Text>
                </View>

                <View style={{ flex: 2, justifyContent: 'center' }}>
                    <Image style={styles.imageIcon} source={Path.paperwork} resizeMode={'contain'} />
                </View>

                <View style={{ flex: 1, justifyContent: 'center' }}>
                    <TouchableOpacity onPress={() => navigation.navigate('AssessmentList')} style={styles.returnToCalendar}>
                        <Text style={{ color: '#FFFFFF', fontSize: convertHeight(14) }}>{t('Assessment:label:returnToCalendar')}</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </ScrollView>
    )
}

export default FormPageTen;