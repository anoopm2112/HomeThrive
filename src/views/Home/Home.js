import React, { useEffect } from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import colorPalette from '../../theme/Palette';
// import logoPath from '../../common/Path';
// import CaseList from '../CaseList';
// import Header from '../Components/Header';
// import Footer from '../Components/Footer';


const Home = ({ route, navigation }) => {
    //const { fromAssessment } = route && route.params ? route.params : false;
    //console.log("fromAssessment in Home>>", fromAssessment)

    useEffect(() => {
        // if(fromAssessment){
        //     console.log("caselist set to false >>")
        //     setCaseListShown(false)
        // }
        // return () => {
        //     //setLoading(false)
        // }
    }, [])

    return (
        <View style={{ display: "flex", flex: 1 }}>
            {/* <Header /> */}
            <View style={{
                flex: 1,
                display: "flex",
                width: "100%",
                flexDirection: "row",
                marginTop: 30
            }}>
                <TouchableOpacity style={{
                    flex: 1,
                    height: 120,
                    marginHorizontal: 30,
                    alignItems: "center",
                    justifyContent: "center",
                    borderColor: colorPalette.primary.main,
                    borderRadius: 5,
                    borderWidth: 2
                }}
                    onPress={() => { navigation.navigate('CaseList') }}
                //onPress={()=> setCaseListShown(true)}
                //onPress={()=> console.log("pressed")}
                >
                    <Text style={{
                        fontSize: 18,
                        color: colorPalette.text.primary,
                        textAlign: "center"
                    }}>
                        Start an assessment
                    </Text>
                </TouchableOpacity>

                <TouchableOpacity style={{
                    flex: 1,
                    height: 120,
                    marginHorizontal: 30,
                    alignItems: "center",
                    justifyContent: "center",
                    borderColor: colorPalette.primary.main,
                    borderRadius: 5,
                    borderWidth: 2
                }}
                    onPress={() => navigation.navigate('AssessmentList')}>
                    <Text style={{
                        fontSize: 18,
                        color: colorPalette.text.primary,
                        textAlign: "center"
                    }}>Continue an assessment</Text>
                </TouchableOpacity>
            </View>
            <TouchableOpacity style={{
                height: 50,
                marginHorizontal: 30,
                alignItems: "center",
                justifyContent: "center",
                borderColor: colorPalette.primary.main,
                borderRadius: 5,
                borderWidth: 2
            }}
                onPress={() => navigation.navigate('Download')}>
                <Text style={{
                    fontSize: 18,
                    color: colorPalette.text.primary,
                    textAlign: "center"
                }}>Download</Text>
            </TouchableOpacity>
            {/* <Footer
                printHai={() => console.log('hi')}
                navigation={navigation}
                goBack={() => navigation.goBack()}
            /> */}
        </View>

    )
}

export default Home
