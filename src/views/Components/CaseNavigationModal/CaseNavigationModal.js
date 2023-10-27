import React from 'react'
import { Text, View, StyleSheet, Image, TouchableOpacity } from 'react-native'
import { Modal, Button } from 'react-native-paper';
import Icon from 'react-native-vector-icons/Ionicons';
import Palette from '../../../theme/Palette';
import TextView from '../TextView/TextView';
// import CaseDetailsCard from '../CaseDetailsCard';
import moment from 'moment';
import Path from '../../../common/Path';
import { useTranslation } from 'react-i18next';
import colorPalette from '../../../theme/Palette';
import { convertHeight, convertWidth } from '../../../common/utils/dimensionUtil';


const CaseNavigationModal = ({ caseData, fromAssessment, onDismiss, visible, navButtonText, onNavButtonPress, caseDetails }) => {

    const onNavClick = () => {
        onNavButtonPress()
        onDismiss()
    }

    const { t } = useTranslation();

    const styles = StyleSheet.create({
        mainContainer: {
            flexDirection: "row",
            marginVertical: 8,
            alignItems: 'center',
            justifyContent: 'space-around'
        },
        imageContainer: {
            height: convertHeight(60),
            width: convertHeight(60)
        },
        userName: {
            fontSize: convertHeight(12),
            fontWeight: "bold",
            color: colorPalette.text.primary
        },
        previousScoreText: { 
            color: colorPalette.text.orange, 
            fontWeight: "800", 
            marginTop: convertHeight(4), 
            textAlign: 'center' 
        },
        actionBtn: {
            marginHorizontal: 30,
            backgroundColor: Palette.primary.main,
            marginVertical: 10,
            borderRadius: 10,
            padding: 10,
            justifyContent: 'center',
            alignItems: 'center'
        }
    });

    return (
        <Modal
            visible={visible}
            onDismiss={onDismiss}
            contentContainerStyle={{ backgroundColor: 'white', padding: 20, marginHorizontal: 20, borderRadius: 8 }}>
            <View>
                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                    <Text style={{ flex: 1, marginStart: 40, textAlign: 'center', fontSize: 14, fontWeight: 'bold' }}>{caseData && caseData.dateOfAssessment && moment(caseData.dateOfAssessment, 'DD/MM/YYYY').format("DD MMMM, YYYY")}</Text>
                    <Icon name={'close'} size={30}
                        color={Palette.primary.icon}
                        style={{ alignSelf: 'flex-end' }}
                        onPress={onDismiss} />
                </View>
                {/* <CaseDetailsCard
                    hideMinimiseButton
                    caseData={caseData}
                    caseDetails={caseDetails}
                    minimized={false}
                    fromAssessment={fromAssessment} /> */}
                <View>
                    <Text style={[styles.previousScoreText, { color: '#000000', fontWeight:'bold', fontSize: 16 }]}>{fromAssessment ? caseDetails.caseId : caseData.caseid}</Text>
                    {/* <Text style={[styles.previousScoreText, { flexWrap: 'wrap', width: convertHeight(250), fontSize: 18, color: '#000000' }]}>{caseDetails.childFirstName} {caseDetails.childLastName}</Text> */}
                    {/* {caseDetails && <Text style={styles.previousScoreText}>{`${t('Common:label:previousScore')}: ${caseDetails.previousScore ? caseDetails.previousScore : '0'}%`}</Text>} */}
                </View>
                <View style={styles.mainContainer}>
                    <View style={{ width: convertWidth(70) }}>
                        <Image style={styles.imageContainer} source={caseData.fileUrl !== null && caseData.fileUrl !== undefined ? { uri: caseData.fileUrl } : Path.childImagePlaceholder} />
                        {/* <Text style={[styles.userName, { textAlign: 'center', paddingTop: convertHeight(7), flexWrap: 'wrap', width: convertHeight(68) }]}>{caseDetails.childFirstName} {caseDetails.childLastName}</Text> */}
                    </View>
                    <View style={{ width: convertWidth(200)}}>
                        {/* <Text style={[styles.userName,{ flexWrap: 'wrap', width: convertHeight(150)}]}>{caseDetails.childFirstName} {caseDetails.childLastName}</Text> */}
                        <Text style={[styles.userName, { flexWrap: 'wrap', width: convertHeight(150), color: '#000000' }]}>{caseDetails.childFirstName} {caseDetails.childLastName}</Text>
                        {/* <Text style={{ fontWeight: 'bold', paddingVertical: convertHeight(5), color: '#000000' }}>{fromAssessment ? caseDetails.caseId : caseData.caseid}</Text> */}
                        {caseDetails.lastAssesmentDate && <View>
                            <Text style={{ fontWeight: "800", paddingVertical: convertHeight(5) }}>{`${t('Common:label:lastReport')}: ${caseDetails.lastAssesmentDate}`}</Text>
                            {caseDetails && <Text style={[styles.userName, { color: colorPalette.text.orange, fontSize: 13, fontWeight:'bold' }]}>{`${t('Common:label:previousScore')}: ${caseDetails.previousScore ? caseDetails.previousScore : '0'}%`}</Text>}
                        </View>}
                    </View>
                </View>
                {/* <Button uppercase={false} mode={'outlined'}
                    style={{
                        marginHorizontal: 30,
                        borderColor: Palette.primary.main,
                        borderWidth: 1,
                        marginVertical: 10,
                        borderRadius: 10,
                    }}
                    labelStyle={{ color: Palette.primary.main, }}
                    onPress={onNavClick}>
                    <TextView textObject={navButtonText} />
                </Button> */}
                <TouchableOpacity style={styles.actionBtn} onPress={onNavClick}>
                        <TextView style={{ color: "#FFFFFF" }} textObject={navButtonText} />
                </TouchableOpacity>
            </View>
        </Modal>
    )
}

export default CaseNavigationModal
