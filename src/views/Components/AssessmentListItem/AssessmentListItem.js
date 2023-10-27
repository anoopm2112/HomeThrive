import React from 'react'
import { View, Image, TouchableOpacity } from 'react-native'
import { List } from 'react-native-paper';
import Path from '../../../common/Path';
import Icon from 'react-native-vector-icons/FontAwesome5';
import colorPalette from '../../../theme/Palette';
import { useTranslation } from "react-i18next";

const AssessmentListItem = (props) => {

    const { item, index, totalAssesments, onSelectAssessment } = props
    const { t } = useTranslation()
    // console.log('previosScore >> ', item.previousScore)

    return (
        <List.Item
            onPress={() => onSelectAssessment(item)}
            style={{
                flex: 1,
                borderRadius: 10,
                borderColor: 'grey',
                borderWidth: 1,
                backgroundColor: 'white',
                marginTop: 10,
                marginBottom: index === totalAssesments ? 20 : 0
            }}
            descriptionStyle={{ color: 'grey' }}
            title={`${item.childFirstName} ${item.childLastName}`}
            descriptionNumberOfLines={4}
            description={`${t('Common:label:previousTSScore')}: ${item.previousScore === null ? t('Common:label:noPreviousRecords') : item.previousScore.length > 0 ? item.previousScore + `${'%'}` : '0%'}${'\n'}${t('ListItem:label:assessmentDate')}: ${item.dateOfAssessment}`}
            left={props => <Image {...props}
                style={{
                    height: 60,
                    width: 60,
                    borderRadius: 40,
                    alignSelf: 'center'
                }}
                source={item.fileUrl !== null &&
                    item.fileUrl !== undefined ? {
                    uri: item.fileUrl
                } : Path.childImagePlaceholder}
            />}
            right={props => <View style={{ justifyContent: 'space-around', alignItems: 'center' }}>
                <TouchableOpacity onPress={() => onSelectAssessment(item)}>
                    <Icon name={item.isComplete ? "eye" : "edit"}
                        size={18} color={colorPalette.primary.icon} style={{ padding: 4 }} />
                </TouchableOpacity>
                {item.isSynced === undefined ? <></> : !item.isSynced && <View
                    style={{
                        backgroundColor: 'crimson',
                        borderRadius: 26,
                        height: 22, width: 22,
                        justifyContent: 'center',
                        alignItems: 'center',
                    }}>
                    <Icon name={'sync'}
                        size={12} color={'white'} style={{ padding: 4 }} />
                </View>}
            </View>}
        />
    )
}

export default AssessmentListItem
