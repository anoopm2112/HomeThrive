import React from 'react'
import { View, Text, StyleSheet } from 'react-native';
import { useTranslation } from 'react-i18next';
import { convertHeight } from '../../../common/utils/dimensionUtil';

const CaseDetailsCard = (props) => {
    const { caseDetails, fromAssessment, caseData, formPage, score } = props;

    const { t } = useTranslation();

    const styles = StyleSheet.create({
        caseChildName: {
            fontSize: convertHeight(15),
            fontWeight: '400',
            color: '#666666'
        },
        caseIdTxt: {
            fontSize: convertHeight(9),
            fontWeight: '400',
            color: '#000000',
            paddingTop: convertHeight(4)
        },
        previousScoreTxt: {
            fontWeight: '400',
            fontSize: convertHeight(11),
            color: '#000000'
        },
        nameContainer: {
            paddingTop: convertHeight(10),
            flexDirection: 'row',
            justifyContent: 'space-between',
            alignItems: 'center'
        },
        // form7 styling
        container: { 
            justifyContent: 'center', 
            alignItems: 'center', 
            paddingTop: convertHeight(15) 
        },
        childNameChart: {
            fontSize: convertHeight(24),
            fontWeight: 'bold',
            color: '#000000',
            textAlign: 'center'
        },
        submitText: {
            fontSize: convertHeight(17),
            fontWeight: 'bold',
            color: '#000000',
            paddingVertical: convertHeight(7)
        }
    });

    return (
        <View>
            {(formPage === 7 || formPage === 10 ) ?
                <View style={styles.container}>
                    <View>
                        <Text style={styles.childNameChart}>{caseDetails.childFirstName} {caseDetails.childLastName}</Text>
                        {formPage === 7 && <Text style={styles.submitText}>{t('Assessment:label:assessmentScore')}</Text>}
                        {formPage === 10 && <Text style={styles.submitText}>{`${t('Assessment:label:homeThriveScore')}${' '}${score.totalScoreInPercentageAsString !== undefined ? score.totalScoreInPercentageAsString : '0.0'}%`}</Text>}
                    </View>
                </View>
                :
                <View style={{ paddingHorizontal: convertHeight(20) }}>
                    <View style={styles.nameContainer}>
                        <Text style={styles.caseChildName}>{caseDetails.childFirstName} {caseDetails.childLastName}</Text>
                        <Text style={styles.caseIdTxt}>{fromAssessment ? caseDetails.caseId : caseData.caseid}</Text>
                    </View>
                </View>
            }
        </View>
       
    )
}

export default CaseDetailsCard
