import React, { useState, useEffect } from "react";
import { View, Text, StyleSheet } from "react-native";
import { Calendar, LocaleConfig } from 'react-native-calendars';
import moment from 'moment';
import Palette from "../../../theme/Palette";
import _ from "lodash";
import { getDates } from "../../../helpers/Utils";
import { LANGUAGES } from '../../../common/translation/constant';
import { useTranslation } from "react-i18next";
import AntDesignIcon from 'react-native-vector-icons/AntDesign';
import { convertHeight } from '../../../common/utils/dimensionUtil';
import { LANGUAGE_CODE } from '../../../common/constant';

const EventCalendar = (props) => {
    const { t } = useTranslation();
    const { assessments, events, selectedDateAssessments, showCalendar, dateRange, displayType, currentLanguage, fullDataloader } = props
    const [markedAssessments, setMarkedAssessments] = useState({})
    // const [markedEvents, setMarkedEvents] = useState({})
    const [selectedMonth, setSeletedMonth] = useState(new Date())
    const [currentDate] = useState(new Date())
    const [selectedDate, setSelectedDate] = useState('')
    const [markedSelectedDateRange, setMarkedSelectedDateRange] = useState({})
    const [changeVal, setChange] = useState(currentLanguage)

    useEffect(() => {
        if (displayType === 'period') {
            markDateRange()
        } else {
            markAssessment()
        }
    }, [assessments, dateRange])

    useEffect(() => {
        const locales = _.find(LANGUAGES, function (o) { return o.locale === currentLanguage; });
        LocaleConfig.locales[LANGUAGE_CODE.LANG_ENGLISH] = locales;
        LocaleConfig.defaultLocale = LANGUAGE_CODE.LANG_ENGLISH;
        setChange(currentLanguage)
    }, [currentLanguage]);

    const markAssessment = () => {
        const assessmentDateList = assessments && assessments.length > 0 ? _.uniq(assessments.map((item) => item.dateOfAssessment)) : []
        let markedDatesProps = {}
        const currentDateFormatted = moment(currentDate).format("YYYY-MM-DD")
        assessmentDateList.forEach((date) => {
            const dateHasInCompleteAssessment = assessments.find((assessment) => assessment.dateOfAssessment === date && !assessment.isComplete)
            const dateFormatted = moment(date, 'DD/MM/YYYY').format("YYYY-MM-DD")
            let obj = {}
            // obj[dateFormatted] = {
            //     customStyles: {
            //         container: {
            //             backgroundColor: dateHasInCompleteAssessment ? 'dodgerblue' : 'yellowgreen'
            //         },
            //         text: {
            //             color: 'white',
            //             fontWeight: currentDateFormatted === dateFormatted ? '900' : 'normal',
            //         }
            //     }
            // }
            obj[dateFormatted] = {
                marked: true, dotColor: dateFormatted === currentDateFormatted ? 'white' : dateHasInCompleteAssessment ? 'dodgerblue' : 'yellowgreen'
            }
            markedDatesProps = {
                ...markedDatesProps, ...obj,
            }
        })
        setMarkedAssessments(markedDatesProps)
        let date = ''
        if (selectedDate.length === 0) {
            date = moment(currentDate).format("DD/MM/YYYY")
        } else {
            date = selectedDate
        }
        selectedDateAssessments(filterSelectedDayAssessments(date), date)
        setSelectedDate(date)
    }

    const markDateRange = () => {
        let obj = {}
        const currentDateFormatted = moment(currentDate).format("YYYY-MM-DD")
        const dates = getDates(dateRange.from, dateRange.to)
        dates.forEach((item, index) => {
            let propertyOfDate = {}
            if (index === 0) {
                propertyOfDate = {
                    startingDay: true,
                    color: Palette.primary.fair,
                    textColor: item === currentDateFormatted ? Palette.primary.main : 'black'
                }
            } else {
                propertyOfDate = {
                    endingDay: index > 0 && (index + 1) === dates.length,
                    color: Palette.primary.fair,
                    textColor: item === currentDateFormatted ? Palette.primary.main : 'black'
                }
            }
            obj[item] = propertyOfDate
        })
        setMarkedSelectedDateRange(obj)
        selectedDateAssessments(assessments, dateRange.from)
    }

    // const markEvents = () => {
    //     const eventDateList = events && events.length > 0 ? _.uniq(events.map((item) => item.startDate)) : []
    //     let markedDatesProps = {}
    //     eventDateList.forEach((eventDate) => {
    //         const dateHasEvent = events.find((eventItem) => eventItem.startDate === eventDate)
    //         const dateFormatted = moment(eventDate).format("YYYY-MM-DD")
    //         if (dateHasEvent) {
    //             let obj = {}
    //             obj[dateFormatted] = {
    //                 customStyles: {
    //                     container: {
    //                         backgroundColor: Palette.primary.main
    //                     },
    //                     text: {
    //                         color: 'white',
    //                         fontWeight: 'bold',
    //                     }
    //                 }
    //             }
    //             markedDatesProps = {
    //                 ...markedDatesProps, ...obj,
    //             }
    //         }
    //     })
    //     setMarkedEvents(markedDatesProps)
    // }

    const filterSelectedDayAssessments = (date) => {
        return assessments.filter((item) => item.dateOfAssessment === date)
    }

    const styles = StyleSheet.create({
        calendar: {
            backgroundColor: 'white',
            calendarBackground: 'white',
            textSectionTitleColor: 'black',
            textSectionTitleDisabledColor: '#d9e1e8',
            selectedDayBackgroundColor: '#00adf5',
            selectedDayTextColor: 'white',
            todayTextColor: Palette.primary.white,
            todayBackgroundColor: "dodgerblue",
            dayTextColor: '#2d4150',
            textDisabledColor: '#d9e1e8',
            dotColor: '#00adf5',
            selectedDotColor: 'white',
            disabledArrowColor: '#d9e1e8',
            monthTextColor: '#2d4150',
            indicatorColor: 'blue',
            textDayFontWeight: '300',
            textMonthFontWeight: 'bold',
            textDayHeaderFontWeight: '300',
            textDayFontSize: 17,
            textMonthFontSize: 17,
            textDayHeaderFontSize: 14
        }
    })

    return (
        <View>
            {showCalendar && <View>
                <Calendar
                    markingType={displayType}
                    onDayPress={day => {
                        if (displayType === 'custom') {
                            const date = moment(day.dateString).format("DD/MM/YYYY")
                            selectedDateAssessments(filterSelectedDayAssessments(date), date)
                            setSelectedDate(date)
                        }
                    }}
                    onDayLongPress={day => {
                        console.log('selected day', day)
                    }}
                    monthFormat={'MMM'}
                    onMonthChange={month => {
                        setSeletedMonth(month.dateString)
                    }}
                    onPressArrowLeft={subtractMonth => !fullDataloader && subtractMonth()}
                    onPressArrowRight={addMonth => !fullDataloader && addMonth()}
                    renderHeader={date => {
                        /*Return JSX*/
                        // console.log('Rendred date >> ', date)
                    }}
                    renderArrow={(direction) => direction === 'left' ?
                        <AntDesignIcon name="caretleft" size={convertHeight(10)} color={fullDataloader ? Palette.disabled : Palette.primary.main} /> :
                        <AntDesignIcon name="caretright" size={convertHeight(10)} color={fullDataloader ? Palette.disabled : Palette.primary.main} />
                    }
                    theme={styles.calendar}
                    markedDates={displayType === 'custom' ? markedAssessments : markedSelectedDateRange}
                    enableSwipeMonths={true}
                    style={{ marginHorizontal: 10, marginVertical: 10, borderRadius: 10, padding: 10 }}
                />
                <Text style={{
                    textAlign: 'center',
                    position: 'absolute',
                    right: 110,
                    left: 110,
                    top: 28,
                    alignItems: 'center',
                    fontWeight: styles.calendar.textMonthFontWeight,
                    flex: 1,
                    fontSize: currentLanguage === LANGUAGE_CODE.LANG_TAMIL ? 14: 17
                }}>
                {t(`${'month:'}${moment(selectedMonth).format("MMMM")}`)} {moment(selectedMonth).format("YYYY")}
                </Text>
            </View>}
        </View>
    )
}

export default EventCalendar