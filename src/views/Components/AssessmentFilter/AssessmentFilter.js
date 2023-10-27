import React, { useState } from 'react'
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import { Modal, Button } from 'react-native-paper';
import Icon from 'react-native-vector-icons/FontAwesome5';
import Palette from '../../../theme/Palette';
import TextView from '../TextView/TextView';
import moment from 'moment';
import { Calendar } from 'react-native-calendars';
import { useTranslation } from "react-i18next";
import { convertHeight, convertWidth } from '../../../common/utils/dimensionUtil';

const AssessmentFilter = ({ onDismiss, visible, assessmentStatus, onApply, dateRange }) => {
    const { t } = useTranslation();
    const { from, to } = dateRange
    const [selectedMonth, setSelectedMonth] = useState(new Date())
    const [showCalendar, setShowCalendar] = useState(false)
    const [selectedFromDate, setSelectedFromDate] = useState(from !== undefined ? from : '')
    const [selectedToDate, setSelectedToDate] = useState(to !== undefined ? to : '')
    const [selectedDatePosition, setSelectedDatePosition] = useState('')
    const [isClosed, setIsClosed] = useState(assessmentStatus)

    const styles = StyleSheet.create({
        calendar: {
            backgroundColor: 'white',
            calendarBackground: 'white',
            textSectionTitleColor: '#b6c1cd',
            textSectionTitleDisabledColor: '#d9e1e8',
            selectedDayBackgroundColor: '#00adf5',
            selectedDayTextColor: 'white',
            todayTextColor: Palette.primary.main,
            dayTextColor: '#2d4150',
            textDisabledColor: '#d9e1e8',
            dotColor: '#00adf5',
            selectedDotColor: 'white',
            arrowColor: 'orange',
            disabledArrowColor: '#d9e1e8',
            monthTextColor: '#2d4150',
            indicatorColor: 'blue',
            textDayFontWeight: '300',
            textMonthFontWeight: 'bold',
            textDayHeaderFontWeight: '300',
            textDayFontSize: 16,
            textMonthFontSize: 16,
            textDayHeaderFontSize: 16
        },
        contentContainer: {
            backgroundColor: 'white',
            marginHorizontal: 20,
            borderRadius: 8,
            paddingHorizontal: 20,
            paddingVertical: 20
        },
        mainContainer: {
            flexDirection: 'row',
            alignItems: 'center',
            marginTop: 10
        },
        closedBtnContainer: {
            flexDirection: 'row',
            justifyContent: 'space-between',
            borderRadius: 20,
            borderWidth: 1,
            borderColor: isClosed ? 'limegreen' : 'grey',
            paddingHorizontal: 10,
            paddingVertical: 6,
            marginHorizontal: 10,
            alignSelf: 'flex-start'
        },
        closedBtnIcon: {
            backgroundColor: isClosed ? 'limegreen' : 'grey',
            alignContent: 'center',
            padding: 3,
            borderRadius: 10
        },
        filterDateText: {
            flexDirection: 'row',
            alignItems: 'center',
            marginVertical: 8,
        },
        filterFrom: {
            borderWidth: 1,
            borderColor: 'grey',
            paddingVertical: 6,
            borderRadius: 10,
            width: convertWidth(120),
            paddingHorizontal: 5,
            textAlign: 'center'
        },
        filterTo: {
            borderWidth: 1,
            borderColor: 'grey',
            paddingVertical: 6,
            borderRadius: 10,
            width: convertWidth(120),
            paddingHorizontal: 5,
            textAlign: 'center'
        },
        undoIcon: {
            backgroundColor: 'grey',
            alignContent: 'center',
            padding: 6,
            borderRadius: 28,
            height: 28,
            width: 28
        },
        footerBtn: {
            flexDirection: 'row',
            justifyContent: 'flex-end',
            marginTop: convertHeight(20)
        }
    });

    return (
        <Modal visible={visible} onDismiss={onDismiss} contentContainerStyle={styles.contentContainer}>
            <View>
                <View style={styles.mainContainer}>
                    <TextView textObject={'AssessmentFilter:assessmentStatus'} />
                    <TouchableOpacity onPress={() => setIsClosed(!isClosed)}>
                        <View style={styles.closedBtnContainer}>
                            <Icon name={'check'} color={'white'} size={12} style={styles.closedBtnIcon} />
                            <TextView style={{ color: isClosed ? 'limegreen' : 'grey', marginHorizontal: 8 }} textObject={'Common:label:closed'} />
                        </View>
                    </TouchableOpacity>
                </View>
                <TextView style={styles.filterDateText} textObject={'AssessmentFilter:filterByDate'} />
                <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                    <TouchableOpacity activeOpacity={0.8} onPress={() => {
                        setShowCalendar(true)
                        setSelectedDatePosition('from')
                    }}>
                        <TextView style={styles.filterFrom} textObject={selectedFromDate.length > 0 ? moment(selectedFromDate).format("DD/MM/YYYY") : 'AssessmentFilter:from'} />
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={0.8}
                        onPress={() => {
                            setShowCalendar(true)
                            setSelectedDatePosition('to')
                        }}>
                        <TextView style={styles.filterTo} textObject={selectedToDate.length > 0 ? moment(selectedToDate).format("DD/MM/YYYY") : 'AssessmentFilter:to'} />
                    </TouchableOpacity>
                    <Icon name={'undo-alt'} color={'white'} size={15} style={styles.undoIcon}
                        onPress={() => {
                            setSelectedFromDate('')
                            setSelectedToDate('')
                            setIsClosed(false)
                        }} />
                </View>
                {showCalendar && <View>
                    <Calendar
                        markingType={'custom'}
                        onDayPress={(day) => {
                            const selectedDate = moment(day.dateString).format("YYYY-MM-DD")
                            if (selectedDatePosition === 'from') {
                                setSelectedFromDate(selectedDate)
                            } else {
                                setSelectedToDate(selectedDate)
                            }
                            setShowCalendar(false)
                        }}
                        onDayLongPress={day => {
                            console.log('selected day', day);
                        }}
                        monthFormat={'MMMM'}
                        onMonthChange={month => {
                            console.log('month changed', month)
                            setSelectedMonth(month.dateString)
                        }}
                        onPressArrowLeft={subtractMonth => subtractMonth()}
                        onPressArrowRight={addMonth => addMonth()}
                        renderHeader={date => {
                            /*Return JSX*/
                            console.log('Rendred date >> ', date)
                        }}
                        theme={styles.calendar}
                        // markedDates={markedAssessments}
                        enableSwipeMonths={true}
                        style={{ marginHorizontal: 10, marginVertical: 10, borderRadius: 10, padding: 10 }}
                    />
                    <Text style={{
                        textAlign: 'center',
                        position: 'absolute',
                        right: 110,
                        left: 110,
                        top: 38,
                        alignItems: 'center',
                        fontWeight: styles.calendar.textMonthFontWeight,
                        flex: 1,
                    }}>
                        {t(`${'month:'}${moment(selectedMonth).format("MMMM")}`)} {moment(selectedMonth).format("YYYY")}
                        {/* {moment(selectedMonth).format("MMMM YYYY")} */}
                    </Text>
                </View>}
                <View style={styles.footerBtn}>
                    {/* <Button color={Palette.primary.main} onPress={onDismiss}>
                        <TextView textObject={'Common:label:closeFilter'} />
                    </Button>
                    <Button mode='contained' color={Palette.primary.main}
                        onPress={() => {
                            onApply({ from: selectedFromDate, to: selectedToDate, assessmentStatus: isClosed })
                            onDismiss()
                        }}>
                        <TextView style={{ color: 'white' }} textObject={'Common:label:apply'} />
                    </Button> */}
                    <TouchableOpacity onPress={() => onDismiss()} style={{ borderRadius: 3, marginRight: 5, width: '50%', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ color: Palette.primary.main, padding: 5 }}>{t('Common:label:closeFilter')}</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                        onPress={() => {
                            if (moment(selectedFromDate).isValid()) {
                              if(moment(selectedToDate).isValid()) {
                                onApply({ from: selectedFromDate, to: selectedToDate, assessmentStatus: isClosed })
                                onDismiss()
                              } 
                            } else {
                                onApply({ from: selectedFromDate, to: selectedToDate, assessmentStatus: isClosed })
                                onDismiss()
                            }
                            // onApply({ from: selectedFromDate, to: selectedToDate, assessmentStatus: isClosed })
                            // onDismiss()
                        }}
                        style={{ borderRadius: 3, width: '50%', backgroundColor: Palette.primary.main, justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ color: '#FFFFFF', padding: 5 }}>{t('Common:label:apply')}</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </Modal>
    )
}

export default AssessmentFilter
