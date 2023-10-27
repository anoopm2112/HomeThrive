import React, { useRef, useState, useEffect } from 'react';
import { View, Text, ScrollView, StyleSheet, Image, TouchableOpacity, Platform } from 'react-native';
import { useTranslation } from 'react-i18next';
import { RadarChart } from 'react-native-charts-wrapper';
import RBSheet from "react-native-raw-bottom-sheet";
import Icon from 'react-native-vector-icons/FontAwesome';
// Custom Pages
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';
import Theme from '../../theme/Theme';
import TextView from '../Components/TextView/TextView';
import Path from '../../common/Path';

const FormPageSeven = (props) => {
  const {
    showOfflineMessage, score, radarChartConfig, selectedChartValue,
    handleRightClick, validateSaveAndReturn, processColor, getScoreInInteger,
    setSelectedChartValue, getScore, getHTScore
  } = props;

  const [labelCount, setLabelCount] = useState(0);

  useEffect(() => {
    const timer = setTimeout(() => {
      setLabelCount(10);
    }, 100);
    return () => clearTimeout(timer);
  }, []);

  const { t } = useTranslation();
  const refRBSheet = useRef();

  const styles = StyleSheet.create({
    showOfflineMsgContainer: {
      marginTop: convertHeight(7),
      alignItems: 'center',
      backgroundColor: 'lightgrey',
      borderRadius: convertWidth(8),
      paddingVertical: convertHeight(3),
      paddingStart: 14,
      paddingEnd: 14
    },
    selectedChartValueText: {
      color: 'white',
      fontWeight: 'bold',
      position: 'absolute',
      bottom: convertHeight(15),
      borderRadius: 8,
      backgroundColor: 'dodgerblue',
      paddingHorizontal: convertWidth(8),
      paddingVertical: convertHeight(2)
    },
    radarChartIcon: {
      position: 'absolute',
      alignItems: 'center'
    },
    moreDetailsBtnContainer: {
      paddingVertical: convertHeight(10),
      backgroundColor: '#1D334B',
      justifyContent: 'center',
      alignItems: 'center',
      borderRadius: convertHeight(4)
    },
    exitReturnText: {
      color: '#666666',
      fontSize: convertHeight(14),
      textAlign: 'center',
      paddingVertical: convertHeight(10)
    },
    htScoreContainer: {
      flexDirection: "row",
      justifyContent: 'space-between',
      paddingBottom: convertHeight(7),
      alignContent:'center'
    },
    scoreContainer: {
      flexDirection: "row",
      justifyContent: 'space-between',
      paddingTop: convertHeight(14)
    },
    label: {
      fontSize: convertHeight(14),
      flexWrap: 'wrap', 
      alignSelf: 'center'
    },
    htLabel: {
      fontSize: convertHeight(20),
      fontWeight: 'bold'
    },
    iconContainer: {  
      width: convertHeight(25), 
      height: convertHeight(25), 
      alignItems: 'flex-end', 
      justifyContent: 'center',
      borderRadius: convertHeight(25)
    }
  });

  return (
    <ScrollView style={{ margin: convertWidth(4) }} contentContainerStyle={{ flexGrow: 1, justifyContent: 'space-around' }} showsVerticalScrollIndicator={false}>
      <View>
        <View style={{ flexDirection: "row", justifyContent: 'center', paddingBottom: convertHeight(20) }}>
          <Text style={[{ fontSize: convertHeight(15) }, Theme.text]}>{`${t('Assessment:label:thriveScaleScore')}${score.totalScoreInPercentageAsString !== undefined ? score.totalScoreInPercentageAsString : '0.0'}%`}</Text>
        </View>

        {showOfflineMessage &&
          <View style={styles.showOfflineMsgContainer}>
            <TextView style={Theme.text} textObject={'Assessment:message:noInternet'} />
            <Text style={[{ fontWeight: 'bold', marginTop: 6, textAlign: 'center' }, Theme.text]}><TextView textObject={'Assessment:message:assessmentSavedToLocal:part1'} />{'\n'}<TextView textObject={'Assessment:message:assessmentSavedToLocal:part2'} /></Text>
          </View>}

        <View style={{ justifyContent: 'center', alignItems: 'center', width: '100%' }}>
          <RadarChart
            chartDescription={{ text: '' }}
            yAxis={{ ...radarChartConfig, labelCount: labelCount }}
            xAxis={{ ...radarChartConfig, valueFormatter: ['a', 'b', 'c', 'd', 'e'], drawLabels: false }}
            drawEntryLabels={false}
            rotationEnabled={false}
            drawWeb
            webLineWidth={1}
            webLineWidthInner={1}
            webAlpha={255}
            webColor={processColor("gainsboro")}
            webColorInner={processColor("gainsboro")}
            touchEnabled={true}
            legend={{ enabled: false }}
            minOffset={20}
            onSelect={(event) => setSelectedChartValue(event.nativeEvent?.data?.value !== undefined ? event.nativeEvent?.data?.value.toString() : '')}
            animation={{ durationX: 0, durationY: 600 }}
            data={{
              dataSets: [
                {
                  values: [{ value: 100 }, { value: 100 }, { value: 100 }, { value: 100 }, { value: 100 }],
                  label: '',
                  config: { color: processColor('limegreen'), lineWidth: 2, drawValues: false }
                }, {
                  values: [{ value: getScoreInInteger('1') }, { value: getScoreInInteger('2') }, { value: getScoreInInteger('3') }, { value: getScoreInInteger('4') }, { value: getScoreInInteger('5') }],
                  label: '',
                  config: { color: processColor('orange'), lineWidth: 2, drawValues: false }
                }
              ]
            }}
            style={{ marginVertical: convertHeight(45), height: convertHeight(180), width: convertWidth(230) }}
          />

          <TouchableOpacity onPress={() => setSelectedChartValue(getScore("1").toString())} style={[styles.radarChartIcon, { left: 12, right: 12, top: 20 }]}>
            <Image style={{ height: 22, width: 22 }} source={Path.familAndSocialRelationIcon} />
            <Text style={{ fontSize: 10 }}>{t('Assessment:spiderChartDomains:familyAndSocialRelationship')}</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => setSelectedChartValue(getScore("2").toString())} 
            style={[styles.radarChartIcon, { 
              width: '20%',
              justifyContent: 'center', alignItems: 'center',
              right:  Platform.OS === 'ios' ? convertHeight(20) : convertHeight(20), top: convertHeight(90) 
            }]}>
            <Image style={{ height: 20, width: 20 }} source={Path.householdEconomyIcon} />
            {/* <Text style={{ fontSize: 10, textAlign: 'center' }}>{t('Assessment:spiderChartDomains:householdEconomy:part1')}{'\n'}{t('Assessment:spiderChartDomains:householdEconomy:part2')}</Text> */}
            <Text style={{ fontSize: 10, textAlign: 'center' }}>{t('Assessment:spiderChartDomains:householdEconomy:part1')}</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => setSelectedChartValue(getScore("3").toString())} 
            style={[styles.radarChartIcon, { 
              width: '25%', justifyContent: 'center', alignItems: 'center',
              right: Platform.OS === 'ios' ? convertHeight(60) : convertHeight(70), top: convertHeight(205) 
            }]}>
            <Image style={{ height: 20, width: 20 }} source={Path.livingConditionIcon} />
            <Text style={{ fontSize: 10 }}>{t('Assessment:spiderChartDomains:livingConditions')}</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => setSelectedChartValue(getScore("4").toString())} 
            style={[styles.radarChartIcon, {
              width: '25%', justifyContent: 'center', alignItems: 'center',
              left: Platform.OS === 'ios' ? convertHeight(70) : convertHeight(80), top: convertHeight(205) 
            }]}>
            <Image style={{ height: 20, width: 20 }} source={Path.educationIcon} />
            <Text style={{ fontSize: 10 }}>{t('Assessment:spiderChartDomains:education')}</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => setSelectedChartValue(getScore("5").toString())} 
            style={[styles.radarChartIcon, { 
              left: Platform.OS === 'ios' ? convertHeight(10) : convertHeight(20), top: convertHeight(90), 
              width: '20%'
            }]}>
            <Image style={{ height: 18, width: 18 }} source={Path.healthAndMentalHealthIcon} />
            <Text style={{ fontSize: 10, textAlign: 'center' }}>{t('Assessment:spiderChartDomains:healthAndmentalHealth:part1')}</Text>
          </TouchableOpacity>
          {selectedChartValue.length > 0 && <Text style={styles.selectedChartValueText}>{selectedChartValue}</Text>}
        </View>
        <View>
          <View style={{ padding: convertHeight(10), justifyContent: 'center', paddingTop: convertHeight(20) }}>
            <TouchableOpacity onPress={() => refRBSheet.current.open()} style={styles.moreDetailsBtnContainer}>
              <Text style={{ color: '#FFFFFF', fontSize: convertHeight(14) }}>{t('Assessment:label:scoresByDomain')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>

      <RBSheet
        ref={refRBSheet}
        height={convertHeight(500)}
        animationType={'none'}
        closeOnPressBack={true}
        openDuration={250}
        closeOnDragDown
        customStyles={{ container: { backgroundColor: Theme.safeAreaStyle.backgroundColor } }}>
        <ScrollView
          style={{ margin: convertWidth(4) }}
          contentContainerStyle={{ flexGrow: 1, justifyContent: 'space-around' }}
          showsVerticalScrollIndicator={false}>

          <View style={{ flex: 1, padding: convertHeight(19) }}>
            <View style={styles.htScoreContainer}>
              <Text style={[styles.label, Theme.text, { fontWeight: 'bold', paddingTop: convertHeight(6) }]}>{t('Assessment:label:domainThriveScaleScore')}</Text>
              <TouchableOpacity style={styles.iconContainer} onPress={() => refRBSheet.current.close()}>
                <Icon name={"close"} size={convertHeight(18)} color={'#052536'} />
              </TouchableOpacity>
            </View>
            <View style={styles.scoreContainer}>
              <TextView style={[styles.htLabel, Theme.text, { width: convertWidth(215), flexWrap: 'wrap' }]} textObject={"Assessment:label:homeThriveScore"} />
              <Text style={[styles.htLabel, Theme.text, { width: convertWidth(90), flexWrap: 'wrap', textAlign: 'right', alignSelf: 'center' }]}>{getHTScore()}</Text>
            </View>

            <View style={styles.scoreContainer}>
              <TextView style={[styles.label, Theme.text, { width: convertWidth(225) }]} textObject={"Assessment:label:familyAndSocialRelationship"} />
              <Text style={[styles.label, Theme.text, { width: convertWidth(80), textAlign: 'right' }]}>{getScore("1")}</Text>
            </View>

            <View style={styles.scoreContainer}>
              <TextView style={[styles.label, Theme.text, { width: convertWidth(225) }]} textObject={"Assessment:label:householdEconomy"} />
              <Text style={[styles.label, Theme.text, { width: convertWidth(80), textAlign: 'right' }]}>{getScore("2")}</Text>
            </View>

            <View style={styles.scoreContainer}>
              <TextView style={[styles.label, Theme.text, { width: convertWidth(225) }]} textObject={"Assessment:label:livingConditions"} />
              <Text style={[styles.label, Theme.text, { width: convertWidth(80), textAlign: 'right' }]}>{getScore("3")}</Text>
            </View>

            <View style={styles.scoreContainer}>
              <TextView style={[styles.label, Theme.text, { width: convertWidth(225) }]} textObject={"Assessment:label:education"} />
              <Text style={[styles.label, Theme.text, { width: convertWidth(80), textAlign: 'right' }]}>{getScore("4")}</Text>
            </View>

            <View style={styles.scoreContainer}>
              <TextView style={[styles.label, Theme.text, { width: convertWidth(225) }]} textObject={"Assessment:label:healthAndmentalHealth"} />
              <Text style={[styles.label, Theme.text, { width: convertWidth(80), textAlign: 'right' }]}>{getScore("5")}</Text>
            </View>
          </View>
        </ScrollView>
      </RBSheet>
    </ScrollView>
  )
}

export default FormPageSeven;