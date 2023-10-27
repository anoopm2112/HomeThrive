import React, { useState, useEffect, useCallback, useRef } from 'react';
import { View, SafeAreaView, Text, Image, ScrollView, processColor, Platform, StyleSheet, TouchableOpacity, Keyboard } from 'react-native';
import { useIsFocused, useNavigation } from '@react-navigation/native';
import colorPalette from '../../theme/Palette';
import logoPath from '../../common/Path';
import APIS from '../../common/hooks/useApiCalls';
import Icon from 'react-native-vector-icons/FontAwesome5';
import AntDesignIcon from 'react-native-vector-icons/AntDesign';
import Header from '../Components/Header';
import Footer from '../Components/Footer';
import PrevNextButtons from '../Components/PrevNextButtons';
import CaseDetailsCard from '../Components/CaseDetailsCard';

import DropDown from "react-native-paper-dropdown";
import { RadioButton, TextInput, List, Button, Snackbar, Dialog, Portal, Paragraph, ActivityIndicator } from 'react-native-paper';
import StepIndicator from 'react-native-step-indicator';
import { useOfflineDataContext } from '../../helpers/OfflineOperationHandler';
import Constants from '../../common/hooks/Constants';
import { ModalDatePicker } from "react-native-material-date-picker";
import moment from 'moment';
import _ from 'lodash';
import TitleBar from '../Components/TitleBar';
import Theme from '../../theme/Theme';
import { RadarChart } from 'react-native-charts-wrapper';
import { theme } from '../../theme/PaperTheme';
import Path from '../../common/Path';
import CustRadioButton from '../Components/RadioButton/RadioButton'
import CheckBox from '../Components/CheckBox/CheckBox';
import { useTranslation } from 'react-i18next';
import TextView from '../Components/TextView/TextView';
import { useAuthHandlerContext } from '../../common/hooks/AuthHandler';
import ScreenConfigs from '../../common/hooks/ScreenConfigs';
import InputAccessory from '../Components/InputAccessory/InputAccessory';
import OptionButton from '../Components/OptionButton/OptionButton';
import ErrorShowView from '../Components/ErrorShowView/ErrorShowView';
import { convertHeight, convertWidth } from '../../common/utils/dimensionUtil';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { LANGUAGE_CODE } from '../../common/constant';
// Forms
import FormPageSeven from '../../views/FormPage/FormPageSeven';
import FormPageTen from '../../views/FormPage/FormPageTen';
// Fontello SVG Icon
import CustomIcon from '../../common/CustomIcon';
import AsyncStorage from '@react-native-async-storage/async-storage';

const Assessment = ({ route, toggleMenu, toggleBellIcon }) => {
  const navigation = useNavigation()
  const isFocused = useIsFocused()
  const { t } = useTranslation()
  const { caseData, editAssessment, assessmentId, formRevisionNumber, fromAssessment, viewAssessment, caseDetails } = route.params;

  const [loading, setLoading] = useState(true);
  const [updateLastPosition, setUpdateLastPosition] = useState(false);
  const [currentDomain, setCurrentDomain] = useState(-1);
  const [renderedIndex, setRenderedIndex] = useState(0);
  const [minimized, setMinimized] = useState(false);
  const [caseId, setCaseId] = useState((editAssessment && caseData) ? caseData.HTCaseId : `${caseData.id}`);
  const [showDropDown1, setShowDropDown1] = useState(false);
  const [showDropDown2, setShowDropDown2] = useState(false);
  const [showDropDown3, setShowDropDown3] = useState(false);
  const [type_of_visit, setTypeVisit] = useState('');
  const [type_of_reintegration, setTypeReintegration] = useState('');
  const [other_type_of_reintegration, setOtherTypeReintegration] = useState("");
  const [overall_observations, setOverallObservations] = useState('');
  const [specify_reason, setSpecifyReason] = useState('');
  const [child_thought, setChildThought] = useState('');
  const [family_thought, setFamilyThought] = useState('');
  const [meet_with_child, setMeetWithChild] = useState('Yes');
  const currentDirection = useRef("right")
  const stepClicked = useRef(false)
  const [date_of_assessment, setDateOfAssessment] = useState(moment(new Date()).format("YYYY-MM-DD"));
  const [radarChartConfig, setRadarChartConfig] = useState({})

  //from fe
  const [formPage, setFormPage] = useState(1)
  const [domains, setDomains] = useState([])
  const [formQuestionsMaster, setFormQuestionsMaster] = useState([])
  const [formQuestions, setFormQuestions] = useState([])
  const [assessment, setAssessment] = useState(null)
  const [integrationOptions, setIntegrationOptions] = useState([])
  const [caseList, setCaseList] = useState([])
  const [reIntegrationTypeList, setReIntegrationTypeList] = useState([])
  const [visitTypeList, setVisitTypeList] = useState([])
  const [primaryChoices, setPrimaryChoices] = useState([])
  const [visitInterval, setVisitInterval] = useState('')
  const [helperText, setHelperText] = useState('');
  const [formError, setFormError] = useState(false);
  const [score, setScore] = useState({});
  const [assessmentStartsAt, setAssessmentStartsAt] = useState(new Date().toISOString());
  const [currentFormRevision, setCurrentFormRevision] = useState();

  const [submitAssessment, setSubmitAssessment] = useState('')
  const [isComplete, setIsComplete] = useState(false)
  const [calculateScore, setCalculateScore] = useState('')

  const [showThoughtsInputDialog, setShowThoughtsInputDialog] = useState('')
  const [thoughtsinputDialogAction, setThoughtsInputDialogAction] = useState('')
  const [thoughtsInput, setThoughtsInput] = useState('')

  const [showQuestionTip, setShowQuestionTip] = useState('')

  const { callOfflineOperation, isAppOnline, operationResult } = useOfflineDataContext()
  const [saveAndReturnLaterError, setSaveAndReturnLaterError] = useState('')
  const [userWarningDialogEnabled, setUserWarningDialogEnabled] = useState(undefined)
  const { currentLanguage, getCurrentLanguageId, logScreen, hasNewNotifications } = useAuthHandlerContext()

  const [formSubmitted, setFormSubmitted] = useState(false)
  const [selectedChartValue, setSelectedChartValue] = useState('')

  const [showFosterCareOnlyQuestion, setShowFosterCareOnlyQuestion] = useState(false)
  const [showOfflineMessage, setShowOfflineMessage] = useState(false)

  const [disableBackHandler, setDisableBackHandler] = useState(false)
  const [keyboardIsOpen, setKeyboardIsOpen] = useState(false);
  const [questionIndexLength, setQuestionIndexLength] = useState(1);
  const [bottomTextInputHeight, setBottomTextInputHeight] = useState(false);
  const [formSevenIndication, setFormSevenIndication] = useState(false);
  const InputAccessoryViewID = 'assessmentID';

  // console.log('selectedChartValue >> ', selectedChartValue)
  // console.log('renderedIndex >> ', renderedIndex)
  // console.log('showFosterCareOnlyQuestion >> ', showFosterCareOnlyQuestion)
  // console.log('type_of_reintegration >> ', type_of_reintegration)
  // console.log('Curent questions >> ', currentDomain)
  // console.log('Curent formPage >> ', formPage)

  // Validation States

  // For Pre-Assessment Questionaire
  const [valTypeOfVisit, setValTypeOfVisit] = useState(false);
  const [valTypeOfReIntegrationDropDown, setValTypeOfReIntegrationDropDown] = useState(false);
  const [valTypeOfReIntegration, setValTypeOfReIntegration] = useState(false);
  const [valChildThought, setValChildThought] = useState(false);
  const [valFamilyThought, setValFamilyThought] = useState(false);
  // useRef
  const childThoughtRef = useRef();
  const familyThoughtRef = useRef();

  const [currentFormVersion, setCurrentFormVersion] = useState(null);

  useEffect(() => {
    getCurrentFormVersion();
    const keyboardDidShowListener = Keyboard.addListener("keyboardDidShow", () => {
        setKeyboardIsOpen(true);
    });
    const keyboardDidHideListener = Keyboard.addListener("keyboardDidHide", () => {
        setKeyboardIsOpen(false);
    });
    return () => {
        // Anything in here is fired on component unmount.
        keyboardDidHideListener.remove();
        keyboardDidShowListener.remove();
    }
  }, []);

  const getCurrentFormVersion = async () => {
    const formVersionData = await AsyncStorage.getItem('currentFormVersion');
    setCurrentFormVersion(formVersionData);
  }

  useEffect(() => {
    let newDate = assessment?.dateOfAssessment
    if (caseData.isSynced === undefined || caseData.isSynced) {
      setDateOfAssessment(newDate ? moment(newDate, 'DD/MM/YYYY').format("YYYY-MM-DD") : moment(new Date()).format("YYYY-MM-DD"))
      setMeetWithChild(assessment && assessment.meetWithChild === true ? 'Yes' : assessment && assessment.meetWithChild === false ? 'No' : 'Yes')
    } else {
      setDateOfAssessment(newDate ? newDate : moment(new Date()).format("YYYY-MM-DD"))
      setMeetWithChild(assessment && assessment.meetWithChild === 'true' ? 'Yes' : assessment && assessment.meetWithChild === 'false' ? 'No' : '')
    }
    setFamilyThought(assessment?.placementThoughtsOfFamily || '')
    setChildThought(assessment?.placementThoughtsOfChild || '')
    setSpecifyReason(assessment?.specifyReason || '')
    setOverallObservations(assessment?.overallObservation || '')
    setTypeReintegration(assessment?.HTAssessmentReintegrationTypeId || '')
    setTypeVisit(assessment?.HTAssessmentVisitTypeId || '')
    setOtherTypeReintegration(assessment?.otherReIntegrationTypeValue || '')
  }, [assessment])

  useEffect(() => {
    if (updateLastPosition) {
      updateLastPositionState(assessment)
    }
  }, [updateLastPosition])

  useEffect(() => {
    if (calculateScore === 'do-calculate-score' && !viewAssessment) {
      CalculateAssessmentScore()
    }
  }, [calculateScore])

  const updateLastPositionState = (assessmentData) => {
    if (!viewAssessment) {
      console.log('called >> ')
      setFormPage(assessmentData?.currentPagePosition)
      if (assessmentData?.lastIndex !== null) {
        console.log('position >> ', assessmentData?.currentPagePosition - 2)
        console.log('index >> ', assessmentData?.lastIndex)
        setCurrentDomain(assessmentData?.currentPagePosition - 2)
        setRenderedIndex(assessmentData?.lastIndex)
        setQuestionIndexLength(assessmentData?.lastIndex)
      } else {
        let domainPosition = 0
        let questionPosition = 0
        let doBreak = false
        domains.forEach((domain, index) => {
          if (!doBreak) {
            domainPosition = index
            const currentDomainQuestions = formQuestionsMaster && formQuestionsMaster.length > 0 &&
              formQuestionsMaster.filter((item) => item.HT_question.HTQuestionDomainId === domain.id).filter((resFilter) => !resFilter.isInterResp)
            const currentDomainQuestionWithResponse = currentDomainQuestions.filter((resFilter) => resFilter.HT_question.HT_responses.length !== 0)
            console.log('currentDomainQuestions >> ', currentDomainQuestions)
            if (currentDomainQuestions.length !== currentDomainQuestionWithResponse.length) {
              console.log('currentDomainQuestions.length >> ')
              if (currentDomainQuestionWithResponse.length === 0) {
                const first = currentDomainQuestions[0]
                questionPosition = parseInt(first.HT_question.id)
                questionPosition -= 1
                console.log('questionPosition 1 >> ', questionPosition)
                if (questionPosition === 0) {
                  setFormPage(2)
                  setCurrentDomain(1)
                  setRenderedIndex(0)
                } else {
                  setFormPage(domainPosition + 2)
                  setCurrentDomain(domainPosition)
                  setRenderedIndex(questionPosition)
                  setQuestionIndexLength(questionPosition)
                }
                doBreak = true
              } else {
                const position = currentDomainQuestions.length - currentDomainQuestionWithResponse.length
                questionPosition = position === 0 ? currentDomainQuestions.length : position
                console.log('questionPosition 2 >> ', questionPosition)
                setFormPage(domainPosition + 2)
                setCurrentDomain(domainPosition)
                setRenderedIndex(questionPosition)
                setQuestionIndexLength(questionPosition)
                doBreak = true
              }
            } else {
              questionPosition = parseInt(currentDomainQuestionWithResponse[currentDomainQuestionWithResponse.length - 1].HT_question.id, 10)
            }
          }
        })
        if (!doBreak) {
          setFormPage(7)
          setCurrentDomain(domains.length - 1)
          setRenderedIndex(questionPosition)
          setQuestionIndexLength(questionPosition)
          console.log('questionPosition >> ', questionPosition)
        }
      }
      setLoading(false)
    }
  }

  useEffect(() => {
    getFormList()
    getCaseList()
    getReIntegrationTypeList()
    getVisitTypeList()
    const logScreenAnalytics = () => {
      logScreen(ScreenConfigs.assessment)
    }
    if (isAppOnline) {
      logScreenAnalytics()
    }
  }, [])

  // useEffect(() => {
  //   BackHandler.addEventListener('hardwareBackPress', handleBackButtonPress)

  //   return () => BackHandler.removeEventListener('hardwareBackPress', handleBackButtonPress)
  // }, [isFocused])

  useEffect(() =>
    navigation.addListener('beforeRemove', (e) => {
      if (!disableBackHandler) {
        if (userWarningDialogEnabled) {
          navigation.dispatch(e.data.action)
          return
        }

        e.preventDefault()
        // Prompt the user before leaving the screen
        if(e.data.action?.type === 'GO_BACK') {
          setUserWarningDialogEnabled(e.data.action)
        } else if (e.data.action?.type === 'NAVIGATE') {
          navigation.dispatch(e.data.action)
        }
      } else {
        navigation.dispatch(e.data.action)
      }
    }), [navigation, disableBackHandler])

  // useEffect(() => {
  //   if (thoughtsinputDialogAction === 'ok') {
  //     if (showThoughtsInputDialog === 'child') {
  //       setChildThought(thoughtsInput)
  //     } else {
  //       setFamilyThought(thoughtsInput)
  //     }
  //     setShowThoughtsInputDialog('')
  //     setThoughtsInputDialogAction('')
  //   }
  // }, [thoughtsinputDialogAction])

  // useEffect(() => {
  //   if (showThoughtsInputDialog !== '') {
  //     setThoughtsInput(showThoughtsInputDialog === 'child' ? child_thought : family_thought)
  //   }
  // }, [showThoughtsInputDialog])

  useEffect(() => {
    const updateFormQuestions = () => {
      const filteredQuestions = (reIntegrationTypeList &&
        reIntegrationTypeList.find((item) => item.value === type_of_reintegration)?.value != 4 ?
        formQuestionsMaster.filter((item) => !item.HT_question.isFosterCareFlag) : formQuestionsMaster).sort((a, b) => parseInt(a.order, 10) - parseInt(b.order, 10))
      console.log('filteredQuestions >> ', filteredQuestions);
      setFormQuestions(filteredQuestions)
    }
    if (type_of_reintegration !== '') {
      updateFormQuestions()
    }
  }, [type_of_reintegration])

  const getCaseList = useCallback(async () => {
    try {
      let payload = {
        "needFullData": true,
        "orderByField": [
          ["id", "ASC"]
        ],
      }
      if (isAppOnline) {
        const data = await APIS.CaseList(payload);
        if (data && data.data && data.data.data.length) {
          let list = data.data.data
          let newCaseList = [];
          list && list.length > 0 && list.map((item) => {
            let newItem = {
              value: item.id,
              label: item.dispplytext
            }
            newCaseList.push(newItem)
          })
          setCaseList(newCaseList)
        }
      } else {
        callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getCaseList, { ...payload }))
      }
    } catch (err) {
      console.error(err);
    }
  }, []);

  const getReIntegrationTypeList = useCallback(async () => {
    try {
      if (isAppOnline) {
        const data = await APIS.ReIntegrationTypeList();
        if (data && data.data && data.data.data.length !== 0) {
          let list = data.data.data
          let newReIntegrationList = [];
          list && list.length > 0 && list.map((item) => {
            let newItem = { value: item.id }
            if(currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH) {
              newItem.label = item.reIntegrationType;
            } else if(currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI) {
              newItem.label = item.reIntegrationType_Hi;
            } else {
              newItem.label = item.reIntegrationType_Ta;
            }
            newReIntegrationList.push(newItem)
          })
          setReIntegrationTypeList(newReIntegrationList)
          callOfflineOperation(Constants.createRequest(Constants.offlineOperations.saveFormData, { reIntegrationTypes: list }))
        }
      }
    } catch (err) {
      console.error(err);
    }
  }, []);

  const getVisitTypeList = useCallback(async () => {
    try {
      if (isAppOnline) {
        const data = await APIS.VisitTypeList();
        if (data && data.data && data.data.data.length !== 0) {
          let list = data.data.data
          let newVisitTypeList = [];
          list && list.length > 0 && list.map((item) => {
            let newItem = { value: item.id }
            if(currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH) {
              newItem.label = item.visitType;
            } else if(currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI) {
              newItem.label = item.visitType_Hi;
            } else {
              newItem.label = item.visitType_Ta;
            }
            newVisitTypeList.push(newItem)
          })
          setVisitTypeList(newVisitTypeList)
          callOfflineOperation(Constants.createRequest(Constants.offlineOperations.saveFormData, { visitTypes: list }))
        }
      }
    } catch (err) {
      console.error(err);
    }
  }, []);

  useEffect(() => {
    console.log('Operation >> ', operationResult.operationKey)
    switch (operationResult.operationKey) {
      case Constants.offlineOperations.getFormData:
        const offlineResult = operationResult.data
        setDomains(offlineResult.domains)
        if (!fromAssessment) {
          setFormQuestionsMaster(offlineResult.data && offlineResult.data.form[0].HT_formRevisions)
          setPrimaryChoices(offlineResult.data && offlineResult.data.primaryChoices.sort((a, b) => a.id - b.id))
          setIntegrationOptions(offlineResult.data && offlineResult.data.integrationOptions)
        } else {
          fetchDataForOfflineAssessment()
        }
        if(offlineResult.reIntegrationTypes) {
          let newReIntegrationList = [];
          offlineResult.reIntegrationTypes && offlineResult.reIntegrationTypes.length > 0 && offlineResult.reIntegrationTypes.map((item) => {
            let newItem = { value: item.id }
            if(currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH) {
              newItem.label = item.reIntegrationType;
            } else if(currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI) {
              newItem.label = item.reIntegrationType_Hi;
            } else {
              newItem.label = item.reIntegrationType_Ta;
            }
            newReIntegrationList.push(newItem);
          });
          setReIntegrationTypeList(newReIntegrationList)
        }
        if(offlineResult.visitTypes) {
          let newVisitTypeList = [];
          offlineResult.visitTypes && offlineResult.visitTypes.length > 0 && offlineResult.visitTypes.map((item) => {
            let newItem = { value: item.id }
            if(currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH) {
              newItem.label = item.visitType;
            } else if(currentLanguage.languageCode === LANGUAGE_CODE.LANG_HINDI) {
              newItem.label = item.visitType_Hi;
            } else {
              newItem.label = item.visitType_Ta;
            }
            newVisitTypeList.push(newItem);
          });
          setVisitTypeList(newVisitTypeList)
        }
        setLoading(false)
        return
      case Constants.offlineOperations.calculateAssessmentScore:
        const calculatedScore = operationResult.data
        setScore(calculatedScore)
        setCalculateScore('')
        setLoading(false)
        return
      case Constants.offlineOperations.getCaseList:
        let newCaseList = [];
        operationResult.data && operationResult.data.length > 0 && operationResult.data.map((item) => {
          let newItem = {
            value: `${item.id}`,
            label: item.dispplytext
          }
          newCaseList.push(newItem)
        })
        setCaseList(newCaseList)
        return
      case Constants.offlineOperations.saveAssessment:
        // navigateHome()
        if (!isComplete) {
          navigation.goBack()
        }
        return
    }
  }, [operationResult])

  useEffect(() => {
    if (submitAssessment === 'do-submit' || submitAssessment === 'do-save') {
      submitValues(isComplete)
    }
  }, [submitAssessment])

  const validateButton = () => {
    if (formPage === 1) {
      const reIntegrationTypeValue = reIntegrationTypeList.find((item) => item.value === type_of_reintegration)?.label
      if (
        caseId === '' ||
        type_of_visit === '' ||
        meet_with_child === '' ||
        type_of_reintegration === "" ||
        child_thought.trim() === "" ||
        family_thought.trim() === "" ||
        (reIntegrationTypeValue === 'Other' && other_type_of_reintegration === '') ||
        (reIntegrationTypeValue === 'अन्य' && other_type_of_reintegration === '') ||
        (reIntegrationTypeValue === 'மற்றவை' && other_type_of_reintegration === '')) {
        return true
      } else {
        return false
      }
    }

    if (formPage === 8) {
      let isDisabled = false
      const redFlagOptionIds = primaryChoices && primaryChoices.length > 0 && primaryChoices.map(c => {
        if (c.id === "1" || c.id === "2") { return c.id }
      }).filter(c => c)

      formQuestions.map(item => {
        if (item.HT_question?.HT_choices?.length > 0 && (item.HT_question?.isRedFlag &&
          (item.HT_question?.HT_responses?.find(resp => resp.HTChoiceId == redFlagOptionIds[0]) ||
            item.HT_question?.HT_responses?.find(resp => resp.HTChoiceId == redFlagOptionIds[1])) &&
          item.HT_question?.HT_responses?.length < 2)) {
          isDisabled = true
        }
        return item
      })

      if (!isDisabled) {
        const redFlagQuestions = formQuestions.filter((item) => item.HT_question?.isRedFlag &&
          (item.HT_question?.HT_responses?.find((resp) => resp.HTChoiceId === redFlagOptionIds[0] ||
            resp.HTChoiceId === redFlagOptionIds[1])))?.filter((item) => {
              return (item.HT_question?.HT_responses?.find((resp) => resp.HTChoiceId === item.HT_question.HT_choices.find(c => c.choiceName === "Other (please specify)" || c.choiceName === "மற்றவை (தயவுசெய்து குறிப்பிடவும்)" || c.choiceName === "अन्य (कृपया निर्दिष्ट करें)")?.id) ||
                item.HT_question?.HT_responses?.find((resp) => resp.HTChoiceId === item.HT_question.HT_choices.find(c => c.choiceName === "Other (please specify)" || c.choiceName === "மற்றவை (தயவுசெய்து குறிப்பிடவும்)" || c.choiceName === "अन्य (कृपया निर्दिष्ट करें)")?.id))
            })
        redFlagQuestions.forEach((item) => {
          console.log('Other >> ', !item.HT_question.HT_responses.find(r => r.otherResponse)?.otherResponse)
          if (!item.HT_question.HT_responses.find(r => r.otherResponse)?.otherResponse) {
            isDisabled = true
            return
          }
        })
      }
      return isDisabled
    }
    if (formPage === 9) {
      if (overall_observations === '' || specify_reason === '' || !visitInterval) {
        return true
      } else {
        if (!viewAssessment) {
          let isDisabled = false
          const redFlagOptionIds = primaryChoices && primaryChoices.length > 0 && primaryChoices.map(c => {
            if (c.id === "1" || c.id === "2") { return c.id }
          }).filter(c => c)
          formQuestions.map((item) => {
            if (item.HT_question?.HT_choices?.length > 0 && !item.HT_question.isRedFlag &&
              (item.HT_question?.HT_responses?.find(resp => resp.HTChoiceId == redFlagOptionIds[0]) ||
                item.HT_question?.HT_responses?.find(resp => resp.HTChoiceId == redFlagOptionIds[1])) &&
              item.HT_question?.HT_responses?.length < 2) {
              isDisabled = true
            }
            return item
          })

          if (!isDisabled) {
            const redFlagQuestions = formQuestions.filter((item) => !item.HT_question?.isRedFlag &&
              (item.HT_question?.HT_responses?.find((resp) => resp.HTChoiceId === redFlagOptionIds[0] ||
                resp.HTChoiceId === redFlagOptionIds[1])))?.filter((item) => {
                  return (item.HT_question?.HT_responses?.find((resp) => resp.HTChoiceId === item.HT_question.HT_choices.find(c => c.choiceName === "Other (please specify)" || c.choiceName === "மற்றவை (தயவுசெய்து குறிப்பிடவும்)" || c.choiceName === "अन्य (कृपया निर्दिष्ट करें)")?.id) ||
                    item.HT_question?.HT_responses?.find((resp) => resp.HTChoiceId === item.HT_question.HT_choices.find(c => c.choiceName === "Other (please specify)" || c.choiceName === "மற்றவை (தயவுசெய்து குறிப்பிடவும்)" || c.choiceName === "अन्य (कृपया निर्दिष्ट करें)")?.id))
                })
            redFlagQuestions.forEach((item) => {
              console.log('Other >> ', !item.HT_question.HT_responses.find(r => r.otherResponse)?.otherResponse)
              if (!item.HT_question.HT_responses.find(r => r.otherResponse)?.otherResponse) {
                isDisabled = true
                return
              }
            })
          }

          const integrationValidation = integrationOptions.filter(opt => checkIntegrationOptionStatus() ? opt.isRedFlag : !opt.isRedFlag)?.length > 0 &&
            integrationOptions.filter(opt => checkIntegrationOptionStatus() ? opt.isRedFlag : !opt.isRedFlag).
              filter(item => item.HT_assessmentIntegrationOptionMappings && item.HT_assessmentIntegrationOptionMappings.length > 0)
          if (!integrationValidation || !integrationValidation.length) {
            isDisabled = true
          }
          return isDisabled
        } else {
          return false
        }
      }
    }
    if (formPage >= 2 && formPage <= domains.length + 1) {
      const unanswered = formQuestions.filter((item) =>
        ((domains && domains[currentDomain] && domains[currentDomain]?.id === item.HT_question.HTQuestionDomainId) && item.order === renderedIndex && (!item.HT_question?.HT_responses || !item.HT_question?.HT_responses?.length)))
      return unanswered.length ? true : false
    } else {
      return false
    }
  }

  const stepIndicatorStyles = {
    stepIndicatorSize: 28,
    currentStepIndicatorSize: 35,
    separatorStrokeWidth: 2,
    currentStepStrokeWidth: 2,
    stepStrokeCurrentColor: '#fe7013',
    stepStrokeWidth: 2,
    stepStrokeFinishedColor: '#fe7013',
    stepStrokeUnFinishedColor: '#aaaaaa',

    separatorFinishedColor: '#fe7013',
    separatorUnFinishedColor: '#aaaaaa',

    stepIndicatorFinishedColor: '#fe7013',
    stepIndicatorUnFinishedColor: '#ffffff',
    stepIndicatorCurrentColor: '#ffffff',
    stepIndicatorLabelFontSize: 10,

    currentStepIndicatorLabelFontSize: 13,
    stepIndicatorLabelCurrentColor: '#fe7013',
    stepIndicatorLabelFinishedColor: '#ffffff',
    stepIndicatorLabelUnFinishedColor: '#aaaaaa',
    labelColor: '#999999',
    labelSize: 0,
    currentStepLabelColor: '#fe7013',
  }

  useEffect(() => {
    if (formPage === 1) {
      setRenderedIndex(0)
      setQuestionIndexLength(0)
    }
    if (formPage < 7 && formPage > 1) {
      setCurrentDomain(formPage - 2)
    }
    if (domains && domains.length > 0 && formQuestions &&
      formQuestions.length > 0 && formPage === 7) {
      setCalculateScore('do-calculate-score')
    }
    if (formPage === 7) {
      setTimeout(() => {
        setRadarChartConfig({
          axisMaximum: 90,
          axisMinimum: 0
        })
      }, 100)
    }
    if (formPage === 10) {
      setTimeout(() => {
        setRadarChartConfig({
          axisMaximum: 90,
          axisMinimum: 0
        })
      }, 100)
    }
  }, [formPage]);

  // useEffect(() => {
  //   const reIntegrationTypeValue = reIntegrationTypeList.find((item) => item.value === type_of_reintegration)?.label
  //   if(type_of_visit != '') {
  //     setValTypeOfVisit(false);
  //   } else if (type_of_reintegration != '') {
  //     setValTypeOfReIntegrationDropDown(false);
  //   } else if ((reIntegrationTypeValue === 'Other' && other_type_of_reintegration != '') || (reIntegrationTypeValue === 'अन्य' && other_type_of_reintegration != '')) {
  //     setValTypeOfReIntegration(false);
  //   } else if (child_thought.trim() != '') {
  //     setValChildThought(false);
  //   } else if (family_thought.trim() != '') {
  //     setValFamilyThought(false);
  //   }
  // }, []);

  useEffect(() => {
    if (formPage < 7 && formPage > 1 && stepClicked.current === false) {
      if (currentDirection.current === "right") {
        setSubQuestionRight()
      } else {
        setSubQuestionLeft()
      }
    }
    if (formPage < 7 && formPage > 1 && stepClicked.current === true) {
      setSubQuestion()
    }
  }, [currentDomain])



  const handleRightClick = () => {
    // currentDirection.current = "right"
    // if (formPage === 1 || formPage === 7 || formPage === 8 || formPage === 9) {
    //   setFormPage(formPage + 1)
    //   if (formPage === 9 && !viewAssessment) {
    //     setIsComplete(true)
    //     setDisableBackHandler(true)
    //     setSubmitAssessment('do-submit')
    //   }
    // }
    // if (formPage < 7 && formPage > 1) {
    //   setSubQuestionRight()
    //   // setSubQuestion()
    // }

    currentDirection.current = "right"
    // if (formPage === 1) {
    //   const reIntegrationTypeValue = reIntegrationTypeList.find((item) => item.value === type_of_reintegration)?.label
    //   if(type_of_visit === '') {
    //     setValTypeOfVisit(true);
    //   } else if (type_of_reintegration === '') {
    //     setValTypeOfReIntegrationDropDown(true);
    //   } else if ((reIntegrationTypeValue === 'Other' && other_type_of_reintegration === '') || (reIntegrationTypeValue === 'अन्य' && other_type_of_reintegration === '')) {
    //     setValTypeOfReIntegration(true);
    //   } else if (child_thought.trim() === '') {
    //     setValChildThought(true);
    //   } else if (family_thought.trim() === '') {
    //     setValFamilyThought(true);
    //   } else {
    //     setFormPage(formPage + 1)
    //   }
    // }
    // else 
    setFormSevenIndication(false);
    if (formPage === 1 || formPage === 7 || formPage === 8 || formPage === 9) {
      setFormPage(formPage + 1)
      if (formPage === 9 && !viewAssessment) {
        setIsComplete(true)
        setDisableBackHandler(true)
        setSubmitAssessment('do-submit')
      }
    } else if (formPage === 7 && !viewAssessment) {
      setIsComplete(true)
      setDisableBackHandler(true)
      setSubmitAssessment('do-submit')
    }
    if (formPage < 7 && formPage > 1) {
      setSubQuestionRight()
      // setSubQuestion()
    }
  }



  const handleLeftClick = () => {
    currentDirection.current = "left"
    if (formPage === 1) {
      navigation.goBack();
    }
    if (formPage <=6 && formPage > 1) {
      setSubQuestionLeft()
      // setSubQuestion()
    }
    if (formPage === 9 || formPage === 8) {
      setFormPage(formPage - 1)
    }
    if (formPage === 7) {
      if (formSevenIndication) {
        currentDirection.current = "right"
        setFormPage(formPage - 1);
      } else {
        setFormPage(formPage - 1);
      }
    }
  }

  const setSubQuestion = () => {
    let questionIndex = formQuestions && formQuestions.length > 0 && formQuestions.find((item) => {
      if (domains && domains.length > 0 && domains[currentDomain] && domains[currentDomain]?.id == item.HT_question.HTQuestionDomainId) {
        return item
      }
      return null
    })
    let questionIndexId = questionIndex && questionIndex.HT_question &&
      questionIndex.order ? questionIndex.order : renderedIndex
    setRenderedIndex(questionIndexId)
    let indQus = questionIndex != undefined ? 1 : 0;
    setQuestionIndexLength(questionIndexLength + indQus);
    //console.log("questionIndexId >>",questionIndexId)

  }

  const setSubQuestionRight = () => {
    let questionIndex = formQuestions && formQuestions.length > 0 &&
      formQuestions.filter((item) => domains[currentDomain]?.id == item.HT_question.HTQuestionDomainId)?.find((item) => {
        if (domains && domains.length > 0 && domains[currentDomain] && domains[currentDomain]?.id == item.HT_question.HTQuestionDomainId &&
          parseInt(item.order) > parseInt(renderedIndex)) {
          return item
        }
        return null
      })

    if ((questionIndex === null || questionIndex === undefined) && formPage < 7) {
      setCurrentDomain(currentDomain + 1)
      setFormPage(formPage + 1)
    }

    let questionIndexId = questionIndex && questionIndex.HT_question &&
      questionIndex.order ? questionIndex.order : renderedIndex
    setRenderedIndex(questionIndexId)
    let indQus = questionIndex != undefined ? 1 : 0;
    setQuestionIndexLength(questionIndexLength + indQus);
  }

  const setSubQuestionLeft = () => {
    let questionIndex = formQuestions.filter((item) => domains[currentDomain]?.id == item.HT_question.HTQuestionDomainId)?.reverse().find((item) => {
      if (domains && domains.length > 0 && domains[currentDomain] && domains[currentDomain]?.id === item.HT_question.HTQuestionDomainId &&
        parseInt(item.order, 10) < parseInt(renderedIndex, 10)) {
        return item
      }
      return null
    })
    if (questionIndex === null || questionIndex === undefined) {
      setCurrentDomain(currentDomain - 1)
      setFormPage(formPage - 1)
    }
    let questionIndexId = questionIndex !== null && questionIndex !== undefined ?
      questionIndex && questionIndex.order : renderedIndex
    setRenderedIndex(questionIndexId)
    let indQus = questionIndex != undefined ? 1 : 0;
    setQuestionIndexLength(questionIndexLength - indQus);
  }

  const handleStepClick = (value) => {
    if (value !== formPage) {
      currentDirection.current = "right"
      if (!viewAssessment && value > formPage) {
        // const unanswered = formQuestions.filter((item) => {
        //   ((domains && domains[currentDomain] && 
        //     domains[currentDomain]?.id === item.HT_question.HTQuestionDomainId) &&
        //     item.order === renderedIndex &&
        //     (item.HT_question?.HT_responses))})
        let domainRelateQuestions = _.filter(formQuestions, function(item) {
          return item.HT_question.HTQuestionDomainId == value - 1;
        });

        let stepNavigateValue;
        if (value <= 6) {
          if (!_.isEmpty(domainRelateQuestions[0]?.HT_question.HT_responses)) {
            stepNavigateValue = domainRelateQuestions[0]?.HT_question.HT_responses ? true : undefined
          } else {
            stepNavigateValue = undefined
          }
        } else if (value === 7) {
          setFormSevenIndication(true);
          stepNavigateValue = score?.totalScoreInPercentage
        } else if (value === 8) {
          if (checkRedFlagIntervention('1') || checkRedFlagIntervention('2')) {
            // Get all redFlag questions
            let RedFlagQuestions = _.filter(formQuestions, function(item) {
              return item.HT_question.isRedFlag == true;
            });
            // Get all redFlag questions responses
            let isInterRespTrue = RedFlagQuestions.map((item) => {
              return item?.HT_question?.HT_responses
            })
            // Merge all redFlag questions responses
            var mergedRedFlagQuestions = [].concat.apply([], isInterRespTrue);
            console.log(mergedRedFlagQuestions);
            // Find any interRespTrue
            var status = mergedRedFlagQuestions.some(function(el) {
              return (el.isInterResp == true);
            });
            // if status false - undefined or true - true
            stepNavigateValue = status == false && undefined
          } else {
            stepNavigateValue = true;
          }
        } else if (value === 9) {
          if (visitInterval) {
            stepNavigateValue = true;
          } else {
            stepNavigateValue = undefined;
          }
        }
        if (stepNavigateValue === undefined) {
          return false
        }
      }

      if (!viewAssessment && value < formPage) {
        const unanswered = formQuestions.filter((item) =>
        ((domains && domains[currentDomain] && domains[currentDomain]?.id === item.HT_question.HTQuestionDomainId) && item.order === renderedIndex && (!item.HT_question?.HT_responses || !item.HT_question?.HT_responses?.length)))
          
        let stepNavigateValue;

        if (_.isEmpty(unanswered)) {
          stepNavigateValue = true;
        } else if (_.isEmpty(unanswered?.HT_question?.HT_responses) || unanswered?.HT_question?.HT_responses === undefined) {
          stepNavigateValue = undefined
        } else {
          stepNavigateValue = true
        }

        if (stepNavigateValue === undefined) {
          return false
        }
      }
      stepClicked.current === true
      setFormPage(value)
      if (value > 1 || value < 7) {
        setRenderedIndex(0)
        setQuestionIndexLength(0)
        if (value === 1) {
          setCurrentDomain(-1)
        }
      }
    }
  }

  const getFormList = useCallback(async () => {
    try {
      if (isAppOnline) {
        const data = await APIS.FormList();
        if (data && data.data && data.data.data[0]) {
          let details = data.data.data[0]
          if (editAssessment || viewAssessment) {
            //if (editAssessment) {
            if (assessmentId) {
              getAssessmentDetails(assessmentId,  formRevisionNumber)
            }
          } else {
            setCurrentFormRevision(details.currentRevision);
            getFormQuestions(details.id, details.currentRevision)
          }
        }
      } else {
        callOfflineOperation(Constants.createRequest(Constants.offlineOperations.getFormData, {}))

      }
    } catch (err) {
      console.error(err);
      setLoading(false)
    }
  }, []);

  const fetchDataForOfflineAssessment = () => {
    setFormQuestionsMaster(caseData.formQuestions)
    const data = caseData && caseData.isSynced && caseData.assessment ? caseData.assessment : caseData.payload
    setAssessment(data)
    setIntegrationOptions(caseData.integrationOptions)
    setPrimaryChoices(caseData.primaryChoices.sort((a, b) => a.id - b.id))
    setScore(caseData.assessmentScore)
    setVisitInterval(data.schedulingOption)
    if (editAssessment && !viewAssessment && data.currentPagePosition) {
      setUpdateLastPosition(true)
    } else {
      setLoading(false)
    }
  }

  const getFormQuestions = useCallback(async (id, revision) => {
    try {
      const domainData = await APIS.DomainList();
      setDomains(domainData && domainData.data && domainData.data.data)
      const data = await APIS.ListAssessmentFormQuestions(id, revision, getCurrentLanguageId());
      setFormQuestionsMaster(data && data.data && data.data.form[0].HT_formRevisions)
      setPrimaryChoices(data && data.data && data.data.primaryChoices.sort((a, b) => a.id - b.id))
      setIntegrationOptions(data && data.data && data.data.integrationOptions)
      setLoading(false)
      // setAssessmentStartsAt(new Date().toISOString())
    } catch (err) {
      console.error(err)
      setLoading(false)
    }
  }, []);

  const CalculateAssessmentScore = async () => {
    setLoading(true)
    const formattedData = formQuestions && formQuestions.length > 0 && formQuestions.map(item => {
      const formattedResponses = item.HT_question && item.HT_question.HT_responses &&
        item.HT_question.HT_responses.length > 0 &&
        item.HT_question.HT_responses.filter((resFilter) => !resFilter.isInterResp).map(c => {
          const resp = {
            HTChoiceId: primaryChoices && primaryChoices.length > 0 && primaryChoices.find((primaryChoice) => primaryChoice.id == c.HTChoiceId).id,
            isInterResp: c.isInterResp,
            HTResponseId: c.id || ''
          }
          return resp;
        })
      const formattedQuestions = {
        HTQuestionId: item.HT_question && item.HT_question.id,
        HTQuestionDomainId: item.HT_question && item.HT_question.HTQuestionDomainId,
        textResponse: item.HT_question && item.HT_question.HT_responses && item.HT_question.HT_responses.find(c => c.textResponse)?.textResponse || '',
        otherResponse: item.HT_question && item.HT_question.HT_responses && item.HT_question.HT_responses.find(c => c.otherResponse)?.otherResponse || '',
        choiceDetails: formattedResponses || []
      }
      return formattedQuestions
    })

    const questionAndChoices = domains?.length > 0 && domains.map(domain => {
      const filteredQuestions = formattedData && formattedData.length > 0 && formattedData.filter(item => item.HTQuestionDomainId === domain.id)
      const formattedFilteredQuestions = filteredQuestions?.length > 0 ? filteredQuestions.map(item => {
        return {
          HTQuestionId: item.HTQuestionId,
          textResponse: item.textResponse,
          otherResponse: item.otherResponse,
          choiceDetails: item.choiceDetails,
        }
      }) : [];
      const option = {
        HTQuestionDomainId: domain.id,
        questions: formattedFilteredQuestions
      }
      return option
    })

    try {
      let payload = { "questionAndChoices": questionAndChoices }
      console.log("payload for CalculateAssessmentScore >>", payload.toString())
      if (isAppOnline) {
        await APIS.CalculateScore(payload)
          .then((res) => {
            if (res && res.data && res.data.score) {
              setScore(res.data.score)
            }
            setCalculateScore('')
            setLoading(false)
          })
      } else {
        callOfflineOperation(Constants.createRequest(Constants.offlineOperations.calculateAssessmentScore, payload))
      }
    } catch (err) {
      setLoading(false)
    }
  };

  const getAssessmentDetails = useCallback(async (id, revision) => {
    try {
      const domainData = await APIS.DomainList();
      setDomains(domainData && domainData.data && domainData.data.data)
      if (caseData.isSynced === undefined) {
        const data = await APIS.GetAssessmentDetails(id, revision, getCurrentLanguageId());
        if (data && data.data) {
          let details = data.data
          let formQuestions = details.assessmentDetails[0] &&
            details.assessmentDetails[0].HT_form &&
            details.assessmentDetails[0].HT_form.HT_formRevisions
          setFormQuestionsMaster(formQuestions)
          // getCaseDetails(details.assessmentDetails[0].HTCaseId)
          // setRenderedIndex(details.assessmentDetails[0].lastIndex)
          setAssessment(details.assessmentDetails[0])
          setIntegrationOptions(details.integrationOptionResponses)
          setPrimaryChoices(details.primaryChoices.sort((a, b) => a.id - b.id))
          setScore(details && details.assessmentScore ? details.assessmentScore : {})
          setVisitInterval(details.assessmentDetails[0].schedulingOption)
          if (editAssessment && !viewAssessment && details.assessmentDetails[0] && details.assessmentDetails[0].currentPagePosition) {
            setUpdateLastPosition(true)
          }
        }
        setLoading(false)
      } else {
        fetchDataForOfflineAssessment()
      }
      // setAssessmentStartsAt(new Date().toISOString())
    } catch (err) {
      console.error(err);
      setLoading(false)
    }
  }, []);


  const findAge = (dateString) => {
    var birthday = +new Date(dateString);
    return ~~((Date.now() - birthday) / (31557600000));
  }

  const handleCaseIdChange = (values, setFieldValue, value) => {
    getCaseDetails(value)
    setFieldValue('case_id', value)
  }


  const getCaseId = () => {
    let caseValue;
    if (assessment && assessment.HTCaseId) {
      caseValue = assessment.HTCaseId
    } else if (fromCaseList) {
      caseValue = caseId
    } else {
      caseValue = ''
    }
    return caseValue
  }

  const getCaseDetails = useCallback(async (id) => {
    let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
    try {
      const data = await APIS.CaseDetails(id);
      if (data && data.data && data.data.data) {
        // setCaseDetails(data.data.data)
        setLoading(false)
      }
    } catch (err) {
      setLoading(false)
      console.error(err)
    }
  }, []);

  const getCaseData = (type) => {
    let options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
    if (caseDetails && Object.keys(caseDetails).length !== 0) {
      switch (type) {
        case "id": {
          return caseDetails.childId
        }
        case "age": {
          return findAge(caseDetails.childBirthDate)
        }
        case "gender": {
          return caseDetails.childGender
        }
        case "name": {
          return caseDetails.childFirstName + ' ' + caseDetails.childLastName
        }
        case "caseWorkerName": {
          return caseDetails.userFirstName + " " + caseDetails.userLastName
        }
        case "lastDate": {
          return caseDetails.lastAsessmentDate.toLocaleDateString("en-US", options)
        }

        default: {
          return " "
        }
      }
    }

  }

  const handleChangeDomainQuestionValue = (value, id) => {
    // const optionId = primaryChoices && primaryChoices.length > 0 &&
    //   primaryChoices.find(c => c.choiceName == value)?.id
    const questions = formQuestions && formQuestions.length > 0 && formQuestions.map(item => {
      if (item.HT_question.id === id) {
        if (item.HT_question.HT_responses?.length && item.HT_question.HT_responses.find(c => !c.isInterResp).HTChoiceId) {
          item.HT_question.HT_responses.find(c => !c.isInterResp).HTChoiceId = value
        } else {
          item.HT_question.HT_responses = [{ HTChoiceId: value, isInterResp: false }]
        }
        return item
      } else {
        return item
      }
    })
    setFormQuestions(questions)
  }

  const changeInterventionCheckValue = (value, questionId, choiceId) => {
    const options = formQuestions && formQuestions.length > 0 && formQuestions.map(item => {
      if (item.HT_question.id === questionId) {
        if (value) {
          item.HT_question.HT_responses.push({ HTChoiceId: choiceId, isInterResp: true })
        } else {
          item.HT_question.HT_responses = item.HT_question.HT_responses.filter(resp => resp.HTChoiceId !== choiceId)
        }
        return item
      } else {
        return item
      }
    })
    setFormQuestions(options)
  }


  const changeInterventionValue = (value, questionId, field) => {
    const options = formQuestions && formQuestions.length > 0 && formQuestions.map(item => {
      if (item.HT_question.id === questionId) {
        item.HT_question && item.HT_question.HT_responses &&
          item.HT_question.HT_responses.length > 0 &&
          item.HT_question.HT_responses.map(resp => {
            if (field === 'textResponse') {
              resp.textResponse = value;
            } else if (field === 'otherResponse') {
              resp.otherResponse = value;
            }
            return resp
          })
        return item
      } else {
        return item
      }
    })
    setFormQuestions(options)
  }

  const checkIntegrationOptionStatus = () => {
    const redFlagOptionIds = primaryChoices && primaryChoices.length > 0 && primaryChoices.map(c => {
      if (c.id === "1" || c.id === "2") { return c.id }
    }).filter(c => c)
    let count = 0;
    formQuestions && formQuestions.length > 0 && formQuestions.map(item => {
      if (item.HT_question.isRedFlag && redFlagOptionIds.length > 0 && item.HT_question.HT_responses?.find(resp => redFlagOptionIds.find(c => c == resp.HTChoiceId))) {
        count = 1;
      }
      return item
    })
    return count ? true : false;
  }


  const checkIsAnswered = () => {
    let answered = false;
    formQuestions && formQuestions.length > 0 && formQuestions.map((item) => {
      if (item.choiceDetails && item.choiceDetails.length > 0 && answered === false) {
        answered = true
      }
    })
    return answered
  }

  const getDate = (payload = null) => {
    let yourDate = payload === null ? new Date() : new Date(payload)
    const offset = yourDate.getTimezoneOffset()
    yourDate = new Date(yourDate.getTime() - (offset * 60 * 1000))
    return yourDate.toISOString().split('T')[0]
  }

  const getScore = (value) => {
    let domainScore = "0.0 %";
    score && score.questionDomains && score.questionDomains.length > 0 && score.questionDomains.map((item) => {
      if (item.HTQuestionDomainId === value) {
        domainScore = item.totalScoreInPercentageAsString + " %"
      }
    })
    return domainScore;
  }

  const getScoreInInteger = (value) => {
    let domainScore = 0.0
    if (score && score.questionDomains && score.questionDomains.length > 0) {
      domainScore = score.questionDomains.find((item) => item.HTQuestionDomainId === value)?.totalScoreInPercentage
    }
    return parseInt(domainScore, 10)
  }

  const getHTScore = () => {
    let totalScoreInPercentageAsString = '0.0 %';
    if (score && score.totalScoreInPercentageAsString) {
      totalScoreInPercentageAsString = score.totalScoreInPercentageAsString + " %"
    }
    return totalScoreInPercentageAsString;
  }

  const checkRedFlagIntervention = (value) => {
    const redFlagOptionId = primaryChoices && primaryChoices.length > 0 &&
      primaryChoices.find((c) => c.id === value)?.id
    let count = 0;
    formQuestions && formQuestions.length > 0 && formQuestions.map(item => {

      if (item.HT_question && item.HT_question.isRedFlag && item.HT_question &&
        item.HT_question.HT_responses?.find(resp => redFlagOptionId == resp.HTChoiceId)) {
        count = count + 1;
      }
      return item
    })
    return count > 0 ? true : false;
  }

  const changeIntegrationCheckValue = (value, id) => {
    const options = integrationOptions && integrationOptions.length > 0 && integrationOptions.map(item => {
      if (item.id === id) {
        if (value) {
          item.HT_assessmentIntegrationOptionMappings = [{ HTIntegrationOptionId: id }]
        } else {
          item.HT_assessmentIntegrationOptionMappings = []
        }
        return item
      } else {
        return item
      }
    })
    setIntegrationOptions(options)
  }



  const labelList = [{
    label: 'Assessment:label:PreAssessmentQuestionairre',
    status: 'Inactive'
  },
  {
    label: 'Assessment:label:familyAndSocialRelationship',
    status: 'Active'
  },
  {
    label: 'Assessment:label:householdEconomy',
    status: 'Active'
  },
  {
    label: 'Assessment:label:livingConditions',
    status: 'Inactive'
  },
  {
    label: 'Assessment:label:education',
    status: 'Inactive'
  },
  {
    label: 'Assessment:label:healthAndmentalHealth',
    status: 'Inactive'
  },
  {
    label: 'Assessment:label:summary',
    status: 'Inactive'
  },
  {
    label: 'Assessment:label:redFlagMilestones',
    status: 'Inactive'
  },
  {
    label: 'Assessment:label:areaNeedingImmediateIntervention',
    status: 'Inactive'
  }
  ]

  const domainLabels = [
    {
      label: 'Assessment:label:familyAndSocialRelationship',
      status: 'Active'
    },
    {
      label: 'Assessment:label:householdEconomy',
      status: 'Active'
    },
    {
      label: 'Assessment:label:livingConditions',
      status: 'Inactive'
    },
    {
      label: 'Assessment:label:education',
      status: 'Inactive'
    },
    {
      label: 'Assessment:label:healthAndmentalHealth',
      status: 'Inactive'
    }
  ]



  const recommendationQuestionOptions = [{
    id: "1",
    option: t('Assessment:followUps:weekly'),
    key: "Weekly"
  }, {
    id: "2",
    option: t('Assessment:followUps:fortnightly'),
    key: "Fortnightly (Bi-weekly)"
  }, {
    id: "3",
    option: t('Assessment:followUps:monthly'),
    key: "Monthly"
  }, {
    id: "4",
    option: t('Assessment:followUps:everyTwoMonths'),
    key: "Every 2 Months (Bi-monthly)"
  }, {
    id: "5",
    option: t('Assessment:followUps:noNeedForFollowUps'),
    key: "No need for more frequent follow ups - stay with regular schedule"
  }]



  const setCheckBoxValues = (item, choice) => {
    if (item && choice) {
      const checked = item.HT_question && item.HT_question.HT_responses?.length > 0 &&
        item.HT_question.HT_responses.find((c) => c.HTChoiceId === choice?.id)
      if (checked) {
        return true
      } else {
        return false
      }
    }


  }

  const setAssessementIntegrationOptions = (item) => {
    if (item) {
      console.log('Integration >> ', item)
      return item.HT_assessmentIntegrationOptionMappings?.length > 0
    }
  }

  const handleSpecifyReasonChange = async (text) => {
    if (text) {
      await setSpecifyReason(text)
    } else {
      setSpecifyReason(text)
    }
  }

  const validateSaveAndReturn = () => {
    let isError = !validateButton()
    if (isError) {
      setLoading(true)
      setSaveAndReturnLaterError('')
      setIsComplete(false)
      setDisableBackHandler(true)
      setSubmitAssessment('do-save')
    } else {
      if (formPage === 1) {
        const reIntegrationTypeValue = reIntegrationTypeList.find((item) => item.value === type_of_reintegration)?.label
        if(type_of_visit === '') {
          setValTypeOfVisit(true);
        } else if (type_of_reintegration === '') {
          setValTypeOfReIntegrationDropDown(true);
        } else if ((reIntegrationTypeValue === 'Other' && other_type_of_reintegration === '') || (reIntegrationTypeValue === 'अन्य' && other_type_of_reintegration === '') || (reIntegrationTypeValue === 'மற்றவை' && other_type_of_reintegration === '')) {
          setValTypeOfReIntegration(true);
        } else if (child_thought.trim() === '') {
          childThoughtRef.current.focus();
          setValChildThought(true);
        } else if (family_thought.trim() === '') {
          familyThoughtRef.current.focus();
          setValFamilyThought(true);
        }
      } else {
        setSaveAndReturnLaterError('Please fill the details');
      }
    }
  }

  const submitValues = async () => {

    if (meet_with_child !== 'Yes' || meet_with_child !== 'No') {
      setHelperText("Please Choose an option")
      setLoading(false)
    }

    const formattedData = formQuestions && formQuestions.length > 0 && formQuestions.map(item => {
      const formattedResponses = item.HT_question && item.HT_question.HT_responses && item.HT_question.HT_responses.map(c => {
        const resp = {
          HTChoiceId: c.HTChoiceId,
          isInterResp: c.isInterResp,
          HTResponseId: c.id || ''
        }
        return resp;
      })

      const formattedQuestions = {
        HTQuestionId: item.HT_question.id,
        HTQuestionDomainId: item.HT_question.HTQuestionDomainId,
        textResponse: item.HT_question && item.HT_question.HT_responses && item.HT_question.HT_responses.find(c => c.textResponse)?.textResponse || '',
        otherResponse: item.HT_question && item.HT_question.HT_responses && item.HT_question.HT_responses.find(c => c.otherResponse)?.otherResponse || '',
        choiceDetails: formattedResponses || []
      }
      return formattedQuestions
    })
    const finalQuestionAndChoices = domains?.length > 0 && domains.map(domain => {
      const filteredQuestions = formattedData && formattedData.length > 0 && formattedData.filter(item => item.HTQuestionDomainId === domain.id)
      const formattedFilteredQuestions = filteredQuestions?.length > 0 ? filteredQuestions.map(item => {
        return {
          HTQuestionId: item.HTQuestionId,
          textResponse: item.textResponse,
          otherResponse: item.otherResponse,
          choiceDetails: item.choiceDetails,
        }
      }) : [];
      const option = {
        HTQuestionDomainId: domain.id,
        questions: formattedFilteredQuestions
      }
      return option
    })

    const formattedintegrationOptions = integrationOptions && integrationOptions.length > 0 && integrationOptions.filter(item => item.HT_assessmentIntegrationOptionMappings?.length > 0).map((item) => {
      return {
        HTIntegrationOptionId: item.id,
        isCaseCloseOption: item.isCaseCloseOption
      }
    })


    let payload = {
      "HTAssessmentId": assessment?.id || '',
      "HTCaseId": caseId,
      "HTAssessmentVisitTypeId": type_of_visit,
      "HTAssessmentReintegrationTypeId": type_of_reintegration,
      "meetWithChild": meet_with_child === "Yes" ? "true" : "false",
      "placementThoughtsOfChild": child_thought,
      "placementThoughtsOfFamily": family_thought,
      "dateOfAssessment": date_of_assessment,
      "otherReIntegrationTypeValue": other_type_of_reintegration,
      "isComplete": isComplete, // need to change
      "totalScore": score && score.totalScoreInPercentage !== undefined ? score.totalScoreInPercentage : 0,
      "currentPagePosition": formPage,
      "specifyReason": specify_reason,
      "overallObservation": overall_observations,
      "schedulingOption": visitInterval || '',
      "questionAndChoices": checkIsAnswered() ? [] : finalQuestionAndChoices,
      "integrationOptions": formattedintegrationOptions.length > 0 ? formattedintegrationOptions : [],
      // "formRevisionNumber": editAssessment ? formRevisionNumber.toString() : currentFormVersion,
      "HTFormId": "1",
      "lastIndex": renderedIndex,
      "assessmentStartsAt": assessmentStartsAt,
      "isOffline": isAppOnline ? false : true,
      "deviceType": "MOBILE"
    }

    if (isAppOnline) {
      payload.formRevisionNumber = editAssessment ? formRevisionNumber.toString() : currentFormVersion;
    } else {
      payload.formRevisionNumber = editAssessment ? Number(formRevisionNumber) : currentFormVersion;
    }

    if (meet_with_child === 'Yes' || meet_with_child === 'No') {

      try {

        if (formPage === 9 && isComplete) {
          setFormPage(formPage + 1)
        }

        setFormSubmitted(true)
        if (isAppOnline) {
          const res = await APIS.SaveAssessmentResponse(payload)
          if (res && res.data && res.status === 200) {
            console.log("Assessment Submitted")
            setSubmitAssessment('')
            setShowOfflineMessage(false)
            if (!isComplete) {
              navigation.goBack()
            }
          }
          setLoading(false)
        } else {
          payload.assessmentEndsAt = isComplete ? new Date().toISOString() : null;
          setShowOfflineMessage(true)
          callOfflineOperation(Constants.createRequest(Constants.offlineOperations.saveAssessment, {
            isNew: !fromAssessment,
            data: payload,
            score: score,
            assessment: assessment,
            caseData: caseData,
            formQuestions: formQuestions,
            primaryChoices: primaryChoices,
            integrationOptions: integrationOptions
          }))
        }
      } catch (err) {
        console.error(err);
        setLoading(false)
      }
    }

  }

  const toggleAction = () => {
    if (formSubmitted) {
      toggleMenu()
      return
    }
    if (!viewAssessment) {
      setUserWarningDialogEnabled(true)
    } else {
      toggleMenu()
    }
  }

  // const handleBackButtonPress = () => {
  //   if (!userWarningDialogEnabled) {
  //     setUserWarningDialogEnabled(true)
  //   } else {
  //     navigation.goBack()
  //   }
  //   return true
  // }

  const RenderPrimaryChoice = () => {
    formQuestions.map((el, index) => {
      el.order = index + 1
      return el
    })
    const question = formQuestions && formQuestions.filter(item => domains[currentDomain] && domains[currentDomain]?.id === item.HT_question.HTQuestionDomainId).find((item) => item.order === renderedIndex)
    const QusCount = question?.order
    setQuestionIndexLength(QusCount);
    if (question) {
      const views = primaryChoices.map(choice => {
        const choiceSelected = question.HT_question?.HT_responses?.length &&
          question.HT_question.HT_responses.find(c => !c.isInterResp).HTChoiceId
        return (
          <View key={choice.id} style={{ paddingTop: convertHeight(10) }}>
            <OptionButton
              value={choice.id}
              label={choice.choiceName}
              checked={choiceSelected === choice.id}
              viewAssessment={viewAssessment}
              redFlagOption={question.HT_question.isRedFlag}
              onPress={() => handleChangeDomainQuestionValue(choice.id, question?.HT_question?.id)} />
          </View>
        )
      })
      return (
        <View style={{ flex: 1, paddingTop: convertHeight(6), paddingHorizontal: convertWidth(25) }}>
          <View style={{ flex: 1 }}>
            {/* <View>
              <TextView style={[{ marginVertical: 6, color: 'grey' }]} textObject={'Assessment:message:importantMessageNote'} />
            </View> */}
            <View>
              {question.HT_question.isRedFlag &&
                <Text style={{ color: question.HT_question.isRedFlag ? 'black' : 'black', marginVertical: 6, fontWeight: 'normal', width: '92%' }}>{t('Assessment:redFlagTranslation:redFlag')}</Text>}
              <Text style={{ color: '#000000', fontSize: convertHeight(14) }}>{question.HT_question.questionText}</Text>
              {question?.HT_question?.questionHelpText.length > 0 &&
                <TouchableOpacity onPress={() => setShowQuestionTip(question.HT_question.questionHelpText)}>
                  <Text style={styles.moreInfo}>{t('Assessment:actions:moreInfo')}</Text>
                </TouchableOpacity>}
            </View>
          </View>
          <View style={{ flex: 1, justifyContent: 'flex-end', paddingBottom: convertHeight(25) }}>
            {views}
          </View>
        </View>
      )
    } else {
      return (
        <>
          {formPage > 1 && formPage < 7  &&
            <View style={{ flex:1, justifyContent:'center', alignItems:'center' }}>
              <AntDesignIcon name="infocirlce" size={convertHeight(18)} color="black" />
              <Text style={{ color: '#000000', fontWeight: 'bold', paddingVertical: convertHeight(7) }}>{t('Common:label:formLoadError')}</Text>
              <Text style={{ color: '#999999' }}>{t('Common:label:formError')}</Text>
            </View>}
        </>
      )
    }
  }

  const styles = StyleSheet.create({
    labelText: {
      fontSize: convertHeight(11),
      fontWeight: "500",
      flexWrap: 'wrap'
      // paddingHorizontal: convertWidth(24)
    },
    btnContainer: {
      height: convertHeight(30),
      borderRadius: 5,
      justifyContent: 'center',
      borderColor: '#4E4E4E',
      borderWidth: 1,
      flexDirection: 'row',
      alignItems: 'center'
    },
    previousScoreTxt: {
      fontWeight: '400',
      fontSize: convertHeight(11),
      color: '#000000'
    },
    lineDivider: {
      borderBottomColor: '#E5E5E5',
      borderBottomWidth: 1,
      paddingTop: convertHeight(14)
    },
    moreInfo: {
      textDecorationLine: 'underline',
      paddingTop: convertHeight(5),
      color: '#122130',
      fontSize: convertHeight(10)
    },
    questionDivider: {
      borderBottomColor: '#666666',
      borderBottomWidth: 1,
      paddingVertical: convertHeight(4)
    }
  });

  // const onHandlesetTypeVisit = (value) => {
  //   setTypeVisit(value);
  //   setValTypeOfVisit(false);
  // }

  // const onHandlesetTypeReintegration = (value) => {
  //   setTypeReintegration(value)
  //   setValTypeOfReIntegrationDropDown(false);
  // }

  const getViewBorderStyleForOne = (item) => {
    const divdeLineCheckInterventionOne = 
      domains.map((domain) => formQuestions.filter((item) => 
        domain.id === item.HT_question.HTQuestionDomainId && 
        item.HT_question && item.HT_question.isRedFlag && 
      primaryChoices.filter((el) => el.id === "1")?.length > 0 && 
        item.HT_question && item.HT_question.HT_responses?.length > 0 &&
      primaryChoices.filter((el) => el.id === "1")[0].id === item.HT_question.HT_responses.find(c => !c.isInterResp).HTChoiceId))
      
    const divdeLineCheckInterventionTwo = 
      domains.map((domain) => formQuestions.filter((item) => 
        domain.id === item.HT_question.HTQuestionDomainId && 
        item.HT_question && item.HT_question.isRedFlag && 
      primaryChoices.filter((el) => el.id === "2")?.length > 0 && 
        item.HT_question && item.HT_question.HT_responses?.length > 0 &&
      primaryChoices.filter((el) => el.id === "2")[0].id === item.HT_question.HT_responses.find(c => !c.isInterResp).HTChoiceId))

      let filteredOne = JSON.stringify(divdeLineCheckInterventionOne.filter((el) => {
        return typeof el != "object" || Object.keys(el).length > 0
      }));
      let filteredTwo = JSON.stringify(divdeLineCheckInterventionTwo.filter((el) => {
        return typeof el != "object" || Object.keys(el).length > 0
      }));
      var mergedArrayOne = [].concat.apply([], JSON.parse(filteredOne));
      var mergedArrayTwo = [].concat.apply([], JSON.parse(filteredTwo));
      const lastItemOne = mergedArrayOne[mergedArrayOne.length - 1];

    if(!_.isEmpty(mergedArrayTwo)) {
      return { 
        marginBottom: 10, marginTop: 10, 
        borderBottomColor: '#666666', borderBottomWidth: 1, 
        paddingBottom: convertHeight(15) 
      }
    } else if (item != lastItemOne?.HT_question?.id) {
      return { 
        marginBottom: 10, marginTop: 10, 
        borderBottomColor: '#666666', borderBottomWidth: 1, 
        paddingBottom: convertHeight(15) 
      }
    } else {
      return { 
        marginBottom: 10, marginTop: 10, 
        paddingBottom: convertHeight(15) 
      }
    }
  }

  const getViewBorderStyleForTwo = (item) => {
    const divdeLineCheckInterventionTwo = 
      domains.map((domain) => formQuestions.filter((item) => 
        domain.id === item.HT_question.HTQuestionDomainId && 
        item.HT_question && item.HT_question.isRedFlag && 
      primaryChoices.filter((el) => el.id === "2")?.length > 0 && 
        item.HT_question && item.HT_question.HT_responses?.length > 0 &&
      primaryChoices.filter((el) => el.id === "2")[0].id === item.HT_question.HT_responses.find(c => !c.isInterResp).HTChoiceId))

      let filteredTwo = JSON.stringify(divdeLineCheckInterventionTwo.filter((el) => {
        return typeof el != "object" || Object.keys(el).length > 0
      }))
      var mergedArrayTwo = [].concat.apply([], JSON.parse(filteredTwo));
      const lastItemTwo = mergedArrayTwo[mergedArrayTwo.length - 1];

    if(item != lastItemTwo?.HT_question?.id) {
      return {
        marginBottom: 10, marginTop: 10,    
        borderBottomColor: '#666666', borderBottomWidth: 1, 
        paddingBottom: convertHeight(15)
      }
    } else {
      return {
        marginBottom: 10, marginTop: 10,    
        paddingBottom: convertHeight(15)
      }
    }
  }

  const [isBlurInput, setIsBlurInput] = useState(true);
  const handleInputBlur = (fName) => {
    if (fName === 'interventions') { 
      setIsBlurInput(true); 
    } else if (fName === 'details') { 
      setIsBlurInput(true);
    }
  };
  const handleInputFocus = (fName) => {
    if (fName === 'interventions'){ 
      setIsBlurInput(false);
    } else if (fName === 'details') {
      setIsBlurInput(false);
    }
  };

  const icons = [ "checkbox", "family", "money", "home-outline", "education", "heart-empty", "spider", "red-flag", "info" ];
  const renderStepIndicatorRender = (stepPosition, stepStatus) => {
    return stepStatus === "finished" ? (
      <CustomIcon name={icons[stepPosition]} size={10} color="#FFFFFF" />
    ) : (
      <CustomIcon name={icons[stepPosition]} size={formPage - 1 == stepPosition ? 15: 12 } color="#535353" />
    );
  }

  return (
    <SafeAreaView style={{ display: "flex", flex: 1 }}>
      {Platform.OS === 'ios' && <InputAccessory data={InputAccessoryViewID} />}

      {formPage <= 10 &&
        <CaseDetailsCard caseData={caseData} minimized={minimized} fromAssessment={fromAssessment} setMinimized={setMinimized} caseDetails={caseDetails} formPage={formPage} score={score} />}

      <View style={{ flex: 1 }}>
        {formPage <= 10 && !loading &&
          <View style={{ paddingHorizontal: convertWidth(14), paddingTop: convertWidth(8), paddingBottom: convertHeight(4) }}>
            <StepIndicator customStyles={stepIndicatorStyles}
              currentPosition={formPage - 1}
              labels={[]}
              stepCount={9}
              renderStepIndicator={({ position, stepStatus }) =>
                renderStepIndicatorRender(position, stepStatus)
              }
              onPress={(index) => handleStepClick(index + 1)}
            />
          </View>}

        {formPage < 10 && formPage != 7 &&
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginHorizontal: convertWidth(24) }}>
            <View style={{ width:  formPage === 1 || formPage > 7 ? '100%' : convertWidth(220) }}>
              <TextView numberOfLines={2} style={[Theme.text, styles.labelText]} textObject={labelList[formPage - 1].label} />
            </View>
            <View style={{  width: convertWidth(90), alignItems: 'flex-end', justifyContent: 'center' }}>
              {formPage > 1 && formPage < 7 && formPage != 7 && !isNaN(questionIndexLength) &&
                // <TextView numberOfLines={2} style={styles.labelText} textObject={`${'Assessment:label:Questions'} ${questionIndexLength} ${'of'} ${formQuestions.length}`} />}
                <Text numberOfLines={2} style={styles.labelText}>{`${t('Assessment:label:Questions')} ${questionIndexLength} ${t('Assessment:label:of')} ${formQuestions.length}`} </Text>}
            </View>
          </View>}
          

        {formPage != 7 && formPage != 10 && <View style={styles.lineDivider}></View>}

        {/* {formPage === 1 &&
          <View style={{ paddingVertical: convertHeight(7), paddingHorizontal: convertWidth(22) }}>
            <View style={{ flexDirection: 'row' }}>
              <Text style={[styles.previousScoreTxt, { fontWeight: 'bold' }]}> {`${t('Common:label:lastReport')}:`}</Text>
              <Text style={styles.previousScoreTxt}>{caseDetails.lastAssesmentDate}</Text>
            </View>
            <View style={{ flexDirection: 'row', paddingTop: convertHeight(5) }}>
              <Text style={[styles.previousScoreTxt, { fontWeight: 'bold' }]}> {`${t('Common:label:previousScore')}:`}</Text>
              <Text style={styles.previousScoreTxt}>{`${caseDetails.previousScore ? caseDetails.previousScore : '0'}%`}</Text>
            </View>
          </View>} */}

        {formPage === 1 && <ScrollView style={{ marginHorizontal: 4 }} showsVerticalScrollIndicator={false}>
        <KeyboardAwareScrollView keyboardShouldPersistTaps="handled" showsVerticalScrollIndicator={false} extraScrollHeight={convertHeight(100)}>
          <View>
            {/* <View style={{ marginVertical: 5 }}><DropDown label={t('Assessment:label:caseId')} mode={"outlined"} visible={!viewAssessment && showDropDown1} value={caseId} setValue={setCaseId} list={caseList}/></View> */}
            {formPage === 1 &&
              <View style={{ paddingVertical: convertHeight(7), paddingHorizontal: convertWidth(18) }}>
                <View style={{ flexDirection: 'row' }}>
                  <Text style={[styles.previousScoreTxt, { fontWeight: 'bold' }]}> {`${t('Common:label:lastReport')}: `}</Text>
                  <Text style={styles.previousScoreTxt}>{caseDetails.lastAssesmentDate}</Text>
                </View>
                <View style={{ flexDirection: 'row', paddingTop: convertHeight(5) }}>
                  <Text style={[styles.previousScoreTxt, { fontWeight: 'bold' }]}> {`${t('Common:label:previousTSScore')}: `}</Text>
                  <Text style={styles.previousScoreTxt}>{`${caseDetails.previousScore ? caseDetails.previousScore : '0'}%`}</Text>
                </View>
              </View>}
            <View style={{ paddingHorizontal: convertWidth(21), marginTop: convertHeight(10) }}>
              <DropDown
                activeColor={colorPalette.primary.main}
                label={<Text style={{
                  fontSize: currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? convertHeight(11) : convertHeight(9)}}>
                    {t('Assessment:label:typeOfVisit')}</Text>}
                mode={"outlined"}
                visible={!viewAssessment && showDropDown2}
                showDropDown={() => setShowDropDown2(true)}
                onDismiss={() => setShowDropDown2(false)}
                value={type_of_visit}
                setValue={(value) => {
                  setTypeVisit(value)
                  setValTypeOfVisit(false)
                }}
                theme={{ 
                  colors: {
                    placeholder: showDropDown2 && !viewAssessment ? colorPalette.primary.main : '#000000'
                  }
                }}
                list={visitTypeList}
                placeholder={<Text style={{fontSize: convertHeight(11)}}>{t('Assessment:label:typeOfVisit')}</Text>}
                dropDownItemTextStyle={{ 
                  fontSize: currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? convertHeight(10) : convertHeight(9),  
                  width: convertWidth(294) }}
                dropDownItemSelectedTextStyle={{
                  fontSize: currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? convertHeight(10) : convertHeight(9),  
                  width: convertWidth(294)
                }}
              />
              {valTypeOfVisit && <ErrorShowView />}
            </View>

            <View pointerEvents={viewAssessment ? 'none' : 'auto'} style={{ paddingHorizontal: convertWidth(21), marginTop: convertHeight(20) }}>
              <ModalDatePicker
                color={colorPalette.primary.main}
                button={
                  <DropDown
                    label={t('Assessment:label:dateOfVisit')}
                    mode={"outlined"}
                    value={'1'}
                    list={[{ "label": moment(date_of_assessment).format("DD/MM/YYYY"), "value": "1" }]}
                  />
                }
                locale="en"
                onSelect={(date) => setDateOfAssessment(moment(date).format("YYYY-MM-DD"))}
                isHideOnSelect={true}
                initialDate={date_of_assessment}
              />
            </View>

            <View style={{ paddingHorizontal: convertWidth(21), marginTop: convertHeight(20) }}>
              <TextView style={[{ marginRight: 40, fontSize: 14 }, Theme.text]} textObject={'Assessment:label:didYouMeetTheChild'} />
              <View style={{ flexDirection: 'row', marginVertical: convertHeight(4) }}>
                <CustRadioButton
                  style={{ marginRight: convertWidth(35) }}
                  value={'Yes'}
                  label={t('Common:label:yes')}
                  checked={meet_with_child === 'Yes'}
                  disabled={viewAssessment}
                  onPress={() => setMeetWithChild('Yes')}
                />
                <CustRadioButton
                  value={'No'}
                  label={t('Common:label:no')}
                  checked={meet_with_child === 'No'}
                  disabled={viewAssessment}
                  onPress={() => setMeetWithChild('No')}
                />
              </View>
            </View>

            <View style={{ paddingHorizontal: convertWidth(21), marginTop: convertHeight(20) }}>
              <DropDown
                label={<Text style={{
                  fontSize: currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? convertHeight(11) : convertHeight(9)}}>
                    {t('Assessment:label:typeOfReIntegration')}</Text>}
                mode={"outlined"}
                visible={!viewAssessment && showDropDown3}
                showDropDown={() => setShowDropDown3(true)}
                onDismiss={() => setShowDropDown3(false)}
                value={type_of_reintegration}
                setValue={(value) => {
                  setValTypeOfReIntegrationDropDown(false)
                  setTypeReintegration(value)
                }}
                list={reIntegrationTypeList}
                disabled={viewAssessment}
                placeholder={<Text style={{fontSize: convertHeight(11)}}>{t('Assessment:label:typeOfReIntegration')}</Text>}
                dropDownItemTextStyle={{ 
                  fontSize: currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? convertHeight(10) : convertHeight(9),  
                  width: convertWidth(294) }}
                dropDownItemSelectedTextStyle={{
                  fontSize: currentLanguage.languageCode === LANGUAGE_CODE.LANG_ENGLISH ? convertHeight(10) : convertHeight(9),  
                  width: convertWidth(294)
                }}
                theme={{ 
                  colors: {
                    placeholder: showDropDown3 && !viewAssessment ? colorPalette.primary.main : '#000000'
                  }
                }}
              />
              {valTypeOfReIntegrationDropDown && <ErrorShowView />}
            </View>


            {type_of_reintegration === '8' &&
              <View pointerEvents={viewAssessment ? 'none': 'auto'} style={{ paddingHorizontal: convertWidth(21), marginTop: convertHeight(20) }}>
                <TextInput
                  error={valTypeOfReIntegration}
                  editable={!viewAssessment}
                  outlineColor={colorPalette.grey2}
                  activeOutlineColor={colorPalette.primary.main}
                  value={other_type_of_reintegration}
                  placeholderTextColor={colorPalette.text.primary}
                  onChangeText={(text) => {
                    setValTypeOfReIntegration(false)
                    setOtherTypeReintegration(text)
                  }}
                  label={t('Assessment:label:otherValue')}
                  style={{
                    fontSize: 16
                  }}
                  mode="outlined"
                  dense={true}
                  underlineColor='transparent'
                  inputAccessoryViewID={InputAccessoryViewID}
                  disabled={viewAssessment}
                />
                {valTypeOfReIntegration && <ErrorShowView />}
              </View>}

            <View pointerEvents={viewAssessment ? 'none': 'auto'} style={{ paddingHorizontal: convertWidth(21), marginTop: convertHeight(20) }}>
              <TextInput
                ref={childThoughtRef}
                error={valChildThought}
                multiline={true}
                editable={!viewAssessment}
                outlineColor={colorPalette.grey2}
                activeOutlineColor={colorPalette.primary.main}
                value={child_thought}
                placeholderTextColor={colorPalette.text.primary}
                label={t('Assessment:label:childsThought')}
                style={{
                  fontSize: convertHeight(13),
                  minHeight: convertHeight(75)
                }}
                textAlignVertical={'top'}
                numberOfLines={4}
                mode="outlined"
                underlineColor='transparent'
                focusable={false}
                // onPressOut={() => setShowThoughtsInputDialog('child')}
                onChangeText={(text) => {
                  setValChildThought(false)
                  setChildThought(text)
                }}
                inputAccessoryViewID={InputAccessoryViewID}
                disabled={viewAssessment}
              />
              {valChildThought && <ErrorShowView />}
            </View>

            <View pointerEvents={viewAssessment ? 'none': 'auto'} style={{ paddingHorizontal: convertWidth(21), marginVertical: convertHeight(20) }}>
              <TextInput
                ref={familyThoughtRef}
                multiline={true}
                error={valFamilyThought}
                editable={!viewAssessment}
                outlineColor={colorPalette.grey2}
                activeOutlineColor={colorPalette.primary.main}
                value={family_thought}
                placeholderTextColor={colorPalette.text.primary}
                label={t('Assessment:label:familysThought')}
                style={{
                  fontSize: convertHeight(13),
                  minHeight: convertHeight(75)
                }}
                numberOfLines={4}
                textAlignVertical={'top'}
                mode="outlined"
                underlineColor='transparent'
                focusable={false}
                // onPressOut={() => setShowThoughtsInputDialog('family')}
                onChangeText={(text) => {
                  setValFamilyThought(false)
                  setFamilyThought(text)
                }}
                inputAccessoryViewID={InputAccessoryViewID}
                disabled={viewAssessment}
              />
              {valFamilyThought && <ErrorShowView />}
            </View>

          </View>
          </KeyboardAwareScrollView>
          </ScrollView>
        }

        {(formPage >= 2 || formPage <= 6) && domains && domains.length > 0 && formPage < domains.length + 2 && primaryChoices?.length > 0 &&
          <ScrollView contentContainerStyle={{ flexGrow: 1 }} showsVerticalScrollIndicator={false}>
            <RenderPrimaryChoice />
          </ScrollView>
        }

        {/* FORMPAGE 7 SPIDER CHART */}
        {formPage === 7 && !loading &&
          <FormPageSeven 
            showOfflineMessage={showOfflineMessage}
            score={score}
            radarChartConfig={radarChartConfig}
            selectedChartValue={selectedChartValue}
            handleRightClick={handleRightClick}
            validateSaveAndReturn={validateSaveAndReturn}
            processColor={processColor}
            getScoreInInteger={getScoreInInteger}
            setSelectedChartValue={(value) => setSelectedChartValue(value)}
            getScore={getScore}
            getHTScore={getHTScore}
          />}

        {formPage === 8 && !loading &&
          // <ScrollView style={{ marginHorizontal: 4 }} showsVerticalScrollIndicator={false}>
          <KeyboardAwareScrollView
            showsVerticalScrollIndicator={false}
            behavior={Platform.OS === "ios" ? "padding" : ""}
            keyboardShouldPersistTaps="handled"
            extraHeight={isBlurInput && Platform.OS === 'ios' ? 320 : 0}
            //  extraScrollHeight={isFocused && Platform.OS === 'ios' ? convertHeight(120): 0}
          >
            <View pointerEvents={viewAssessment ? 'none': 'auto'} style={{ flex: 1, paddingHorizontal: convertWidth(24) }}>
              <View style={{ flex: 1, marginVertical: convertHeight(10) }}>
                <Text style={[{ fontSize: 15 }, Theme.text]}>{t('Assessment:redFlagTranslation:subHead1')}</Text>
              </View>
              <View style={{ flex: 1, marginVertical: convertHeight(5) }}>
                <Text style={[{ fontSize: 15 }, Theme.text]}>{t('Assessment:redFlagTranslation:subHead2')}</Text>
              </View>

              {(checkRedFlagIntervention('1') || checkRedFlagIntervention('2')) ?
                <View>{formPage === 8 && <View style={styles.questionDivider}></View>}
                  <Text style={{ fontSize: 15, paddingTop: convertHeight(10) }}>{t('Assessment:redFlagTranslation:pleaseSelectIntervention')}</Text>
                </View> : <Text style={[{ fontSize: 15, fontWeight: 'bold', marginTop: 20 }, Theme.text]}>{t('Assessment:redFlagTranslation:noRedFlag')}</Text>
              }


              {checkRedFlagIntervention('1') ?
                <RadioButton.Group>
                  <Text style={[Theme.text, { paddingTop: convertHeight(10) }]}>{t('Assessment:redFlagTranslation:followingAreMarkedInCrisis')}</Text>
                  {/* <RedFlagMilestones choiceKey={'1'} /> */}
                  {domains.map((domain) =>
                    formQuestions.filter((item) => domain.id === item.HT_question.HTQuestionDomainId && item.HT_question && item.HT_question.isRedFlag
                      && primaryChoices.filter((el) => el.id === "1")?.length > 0 && item.HT_question && item.HT_question.HT_responses?.length > 0 &&
                      primaryChoices.filter((el) => el.id === "1")[0].id === item.HT_question.HT_responses.find(c => !c.isInterResp).HTChoiceId)?.map((item) => {
                        return (
                          <View key={item.HT_question && item.HT_question.id} style={getViewBorderStyleForOne(item.HT_question.id)}>
                            <Text style={Theme.text}>{item.HT_question && item.HT_question.questionText}</Text>
                            <View style={{ display: 'flex', flexDirection: 'column' }}>
                              {item.HT_question && item.HT_question.HT_choices?.length > 0 &&
                                item.HT_question.HT_choices.sort((a, b) => a?.id - b?.id).length > 0 &&
                                item.HT_question.HT_choices.sort((a, b) => a?.id - b?.id).map(choice => {
                                  return (
                                    <View key={choice?.id} style={{ flexDirection: "row", paddingTop: convertHeight(7) }}>
                                      <CheckBox value={choice?.id}
                                        label={choice.choiceName}
                                        checked={setCheckBoxValues(item, choice)}
                                        disabled={viewAssessment}
                                        onPress={() => changeInterventionCheckValue(!setCheckBoxValues(item, choice), item.HT_question?.id, choice?.id)} />
                                    </View>
                                  )
                                })}
                            </View>
                            {item.HT_question && item.HT_question.HT_responses?.length > 0 && item.HT_question.HT_choices.length > 0 &&
                              item.HT_question.HT_responses.find(r => r.HTChoiceId === item.HT_question.HT_choices.find(c => c.choiceName === "Other (please specify)" || c.choiceName === "மற்றவை (தயவுசெய்து குறிப்பிடவும்)" || c.choiceName === "अन्य (कृपया निर्दिष्ट करें)")?.id) &&
                              <TextInput
                                style={{
                                  fontSize: 20,
                                  // height: 55,
                                  textAlign: 'auto'
                                }}
                                placeholderTextColor={colorPalette.text.primary}
                                outlineColor={colorPalette.grey2}
                                activeOutlineColor={colorPalette.primary.main}
                                label={t('Assessment:label:explainOtherIntervention')}
                                name="otherIntervention"
                                // onBlur={handleBlur}
                                onChangeText={(text) => changeInterventionValue(text, item.HT_question.id, 'otherResponse')}
                                value={item.HT_question.HT_responses.find(r => r.otherResponse)?.otherResponse || ''}
                                disabled={viewAssessment}
                                mode="outlined"
                                onBlur={() => handleInputBlur('interventions')}
                                onFocus={() => handleInputFocus('interventions')}
                                underlineColor='transparent'
                                inputAccessoryViewID={InputAccessoryViewID}
                              />
                            }
                            {item.HT_question && item.HT_question.HT_responses &&
                              item.HT_question.HT_responses.filter(r => r.isInterResp).length > 0 ?
                              <TextInput
                                label={t('Assessment:label:interventionDetails')}
                                name="interventionDetails"
                                style={{
                                  fontSize: 20,
                                  // height: 55,
                                  textAlign: 'auto'
                                }}
                                outlineColor={colorPalette.grey2}
                                activeOutlineColor={colorPalette.primary.main}
                                // onBlur={handleBlur}
                                onChangeText={(text) => changeInterventionValue(text, item.HT_question && item.HT_question.id, 'textResponse')}
                                value={item.HT_question && item.HT_question.HT_responses && item.HT_question.HT_responses.find(r => r.textResponse)?.textResponse || ''}
                                disabled={viewAssessment}
                                //multiline
                                placeholderTextColor={colorPalette.text.primary}
                                underlineColor='transparent'
                                mode="outlined"
                                onBlur={() => handleInputBlur('details')}
                                onFocus={() => handleInputFocus('details')}
                                inputAccessoryViewID={InputAccessoryViewID}
                              /> : <></>
                            }
                          </View>
                        )
                      }
                      )
                  )}
                </RadioButton.Group> : <></>}

              {checkRedFlagIntervention('2') ?
                <RadioButton.Group>
                  <Text style={Theme.text}>{t('Assessment:redFlagTranslation:followingAreMarkedVulnerable')}</Text>
                  {/* <RedFlagMilestones choiceKey={'2'} /> */}
                  {domains.map((domain) =>
                    formQuestions.filter((item) => domain.id === item.HT_question.HTQuestionDomainId && item.HT_question && item.HT_question.isRedFlag
                      && primaryChoices.filter((el) => el.id === "2")?.length > 0 && item.HT_question && item.HT_question.HT_responses?.length > 0 &&
                      primaryChoices.filter((el) => el.id === "2")[0].id === item.HT_question.HT_responses.find(c => !c.isInterResp).HTChoiceId)?.map((item) => {
                        return (
                          <View key={item.HT_question && item.HT_question.id} style={getViewBorderStyleForTwo(item.HT_question.id)}>
                            <Text style={Theme.text}>{item.HT_question && item.HT_question.questionText}</Text>
                            <View style={{ display: 'flex', flexDirection: 'column' }}>
                              {item.HT_question && item.HT_question.HT_choices?.length > 0 &&
                                item.HT_question.HT_choices.sort((a, b) => a?.id - b?.id).length > 0 &&
                                item.HT_question.HT_choices.sort((a, b) => a?.id - b?.id).map(choice => {
                                  return (
                                    <View key={choice?.id} style={{ flexDirection: "row", paddingTop: convertHeight(7) }}>
                                      <CheckBox value={choice?.id}
                                        label={choice.choiceName}
                                        checked={setCheckBoxValues(item, choice)}
                                        disabled={viewAssessment}
                                        onPress={() => changeInterventionCheckValue(!setCheckBoxValues(item, choice), item.HT_question?.id, choice?.id)} />
                                    </View>
                                  )
                                })}
                            </View>
                            {item.HT_question && item.HT_question.HT_responses?.length > 0 && item.HT_question.HT_choices.length > 0 &&
                              item.HT_question.HT_responses.find(r => r.HTChoiceId === item.HT_question.HT_choices.find(c => c.choiceName === "Other (please specify)" || c.choiceName === "மற்றவை (தயவுசெய்து குறிப்பிடவும்)" || c.choiceName === "अन्य (कृपया निर्दिष्ट करें)")?.id) &&
                              <TextInput
                                style={{
                                  fontSize: 20,
                                  // height: 55,
                                  textAlign: 'auto'
                                }}
                                placeholderTextColor={colorPalette.text.primary}
                                outlineColor={colorPalette.grey2}
                                activeOutlineColor={colorPalette.primary.main}
                                label={t('Assessment:label:explainOtherIntervention')}
                                name="otherIntervention"
                                // onBlur={handleBlur}
                                onChangeText={(text) => changeInterventionValue(text, item.HT_question.id, 'otherResponse')}
                                value={item.HT_question.HT_responses.find(r => r.otherResponse)?.otherResponse || ''}
                                disabled={viewAssessment}
                                mode="outlined"
                                onBlur={() => handleInputBlur('interventions')}
                                onFocus={() => handleInputFocus('interventions')}
                                underlineColor='transparent'
                                inputAccessoryViewID={InputAccessoryViewID}
                              />
                            }
                            {item.HT_question && item.HT_question.HT_responses &&
                              item.HT_question.HT_responses.filter(r => r.isInterResp).length > 0 ?
                              <TextInput
                                label={t('Assessment:label:interventionDetails')}
                                name="interventionDetails"
                                style={{
                                  fontSize: 20,
                                  // height: 55,
                                  textAlign: 'auto'
                                }}
                                outlineColor={colorPalette.grey2}
                                activeOutlineColor={colorPalette.primary.main}
                                // onBlur={handleBlur}
                                onChangeText={(text) => changeInterventionValue(text, item.HT_question && item.HT_question.id, 'textResponse')}
                                value={item.HT_question && item.HT_question.HT_responses && item.HT_question.HT_responses.find(r => r.textResponse)?.textResponse || ''}
                                disabled={viewAssessment}
                                //multiline
                                placeholderTextColor={colorPalette.text.primary}
                                underlineColor='transparent'
                                mode="outlined"
                                onBlur={() => handleInputBlur('details')}
                                onFocus={() => handleInputFocus('details')}
                                inputAccessoryViewID={InputAccessoryViewID}
                              /> : <></>
                            }
                          </View>
                        )
                      }
                      )
                  )}
                </RadioButton.Group> : <></>}
            </View>
            </KeyboardAwareScrollView>
          // </ScrollView>
        }

        {formPage === 9 && !loading &&
          // <ScrollView style={{ marginHorizontal: 4 }} showsVerticalScrollIndicator={false}>
            <KeyboardAwareScrollView 
              showsVerticalScrollIndicator={false} 
              behavior={Platform.OS === "ios" ? "padding" : ""}
              keyboardShouldPersistTaps="handled"
              extraHeight={isBlurInput && Platform.OS === 'ios' ? 320 : 0}
              //  extraScrollHeight={isFocused && Platform.OS === 'ios' ? convertHeight(120): 0}
            >
            <View pointerEvents={viewAssessment ? 'none': 'auto'} style={{ paddingHorizontal: convertWidth(24) }}>
              <>
                <View style={{ paddingTop: convertHeight(10) }}>
                  <Text style={[{ fontSize: convertHeight(12) }, Theme.text]}>
                    {t('Assessment:redFlagTranslation:areaNeedingImmediateIntervention')} {t('Assessment:redFlagTranslation:followingAreEitherCrisisOrVulnerable')}
                  </Text>
                  <Text style={[Theme.text, { fontSize: convertHeight(12), paddingTop: convertHeight(10) } ]}>
                    {t('Assessment:redFlagTranslation:selectWhichInterventionWillBePlanned')}
                  </Text>
                </View>

                {formPage === 8 && <View style={styles.questionDivider}></View>}

                <View>
                  {domains && domains.length > 0 && domains.map((domain, index) => {
                    return (
                      <View>
                        {/* <List.Accordion title={t(domainLabels[index].label)} id={domain.id}> */}
                          {/* <ListInterventions domainId={domain.id} /> */}
                          <View>
                            {formQuestions && formQuestions.length > 0 && formQuestions.filter((item) => domain.id === item.HT_question?.HTQuestionDomainId)?.filter((item) =>
                              !item.HT_question?.isRedFlag && item.HT_question?.HT_responses?.length > 0 &&
                              ((primaryChoices.filter(el => el.id === '1')?.length > 0 &&
                                primaryChoices.filter(el => el.id === '1')[0].id == item.HT_question?.HT_responses?.find(c => !c.isInterResp).HTChoiceId) ||
                                (primaryChoices.filter(el => el.id === '2')?.length > 0 &&
                                  primaryChoices.filter(el => el.id === '2')[0].id == item.HT_question?.HT_responses?.find(c => !c.isInterResp).HTChoiceId))
                            ).length > 0 ? <RadioButton.Group key={'1'}>
                              {formQuestions && formQuestions.length > 0 && formQuestions.filter((item) => domain.id === item.HT_question?.HTQuestionDomainId)?.filter((item) =>
                                !item.HT_question?.isRedFlag && item.HT_question?.HT_responses?.length > 0 &&
                                ((primaryChoices.filter(el => el.id === '1')?.length > 0 &&
                                  primaryChoices.filter(el => el.id === '1')[0].id == item.HT_question?.HT_responses?.find(c => !c.isInterResp).HTChoiceId) ||
                                  (primaryChoices.filter(el => el.id === '2')?.length > 0 &&
                                    primaryChoices.filter(el => el.id === '2')[0].id == item.HT_question?.HT_responses?.find(c => !c.isInterResp).HTChoiceId))
                              ).map((item) => (<View style={{ borderBottomColor: '#666666', borderBottomWidth: 1, paddingBottom: convertHeight(15) }}>
                                <Text style={{ fontWeight: 'bold', fontSize: convertHeight(12), paddingVertical: convertHeight(10), color: '#000000' }}>{t(domainLabels[index].label)}</Text>
                                <Text style={Theme.text}>*{item.HT_question.questionText}</Text>
                                <View style={{ display: 'flex', flexDirection: 'column' }}>
                                  {item.HT_question && item.HT_question.HT_choices && item.HT_question.HT_choices.length > 0 &&
                                    item.HT_question.HT_choices.sort((a, b) => a.id - b.id).length > 0 &&
                                    item.HT_question.HT_choices.sort((a, b) => a.id - b.id).map(choice => {
                                      return (
                                        <View key={choice?.id} style={{ flexDirection: "row", alignItems: "center",  paddingTop: convertHeight(7) }}>
                                          <CheckBox
                                            value={choice.choiceName}
                                            label={choice.choiceName}
                                            disabled={viewAssessment}
                                            checked={setCheckBoxValues(item, choice)}
                                            onPress={() => changeInterventionCheckValue(!setCheckBoxValues(item, choice), item.HT_question?.id, choice?.id)}
                                          />
                                        </View>
                                      )
                                    })}
                                </View>

                                {item.HT_question && item.HT_question.HT_responses &&
                                  item.HT_question.HT_responses.find(r => r.HTChoiceId === item.HT_question?.HT_choices?.find(c => c.choiceName === "Other (please specify)" || c.choiceName === "மற்றவை (தயவுசெய்து குறிப்பிடவும்)" || c.choiceName === "अन्य (कृपया निर्दिष्ट करें)")?.id) &&
                                  <TextInput
                                    label={t('Assessment:label:explainOtherIntervention')}
                                    name="otherIntervention"
                                    //onBlur={handleBlur}
                                    disabled={viewAssessment}
                                    //error={Boolean(touched.city && errors.city)}
                                    //helperText={touched.city && errors.city}
                                    value={item.HT_question?.HT_responses?.find(r => r.otherResponse)?.otherResponse || ''}
                                    onChangeText={(text) => changeInterventionValue(text, item.HT_question?.id, 'otherResponse')}
                                    style={{
                                      // height: 55,
                                      fontSize: 20,
                                      textAlign: 'auto'
                                    }}
                                    outlineColor={colorPalette.grey2}
                                    activeOutlineColor={colorPalette.primary.main}
                                    placeholderTextColor={colorPalette.text.primary}
                                    underlineColor='transparent'
                                    mode="outlined"
                                    onBlur={() => handleInputBlur('interventions')}
                                    onFocus={() => handleInputFocus('interventions')}
                                    // onFocus={() => setBottomTextInputHeight(false)}
                                    inputAccessoryViewID={InputAccessoryViewID}
                                  />
                                }
                                {item.HT_question.HT_responses.filter(r => r.isInterResp).length > 0 ?
                                  <TextInput
                                    label={t('Assessment:label:interventionDetails')}
                                    name="interventionDetails"
                                    onChangeText={(text) => changeInterventionValue(text, item.HT_question?.id, 'textResponse')}
                                    value={item.HT_question && item.HT_question.HT_responses && item.HT_question.HT_responses.find(r => r.textResponse)?.textResponse || ''}
                                    disabled={viewAssessment}
                                    //onBlur={handleBlur}
                                    //error={Boolean(touched.city && errors.city)}
                                    //helperText={touched.city && errors.city}
                                    style={{
                                      // height: 55,
                                      fontSize: 20,
                                      textAlign: 'auto'
                                    }}
                                    outlineColor={colorPalette.grey2}
                                    activeOutlineColor={colorPalette.primary.main}
                                    placeholderTextColor={colorPalette.text.primary}
                                    underlineColor='transparent'
                                    mode="outlined"
                                    onBlur={() => handleInputBlur('details')}
                                    onFocus={() => handleInputFocus('details')}
                                    // onFocus={() => setBottomTextInputHeight(false)}
                                    inputAccessoryViewID={InputAccessoryViewID}
                                  /> : <></>
                                }
                              </View>))}
                            </RadioButton.Group> : null
                            // <Text style={{ marginVertical: 8 }}>{t('Assessment:message:noCrisisLevelConcern')}</Text>
                            }
                          </View>
                        {/* </List.Accordion > */}
                      </View>
                    )
                  })}

                </View >

                <View style={{ paddingTop: convertHeight(15) }}>
                  <View key="1">
                    <RadioButton.Group>
                      {checkIntegrationOptionStatus() ?
                        <Text style={Theme.text}>
                          {t('Assessment:redFlagTranslation:selectWhichInterventionWillBePlanned')}
                        </Text>
                        : <Text style={Theme.text}>{t('Assessment:redFlagTranslation:pleaseSelectFinalRecommendation')}</Text>
                      }
                      {integrationOptions.length > 0 &&
                        integrationOptions.filter(opt => checkIntegrationOptionStatus() ? opt.isRedFlag : !opt.isRedFlag).length > 0 &&
                        integrationOptions.filter(opt => checkIntegrationOptionStatus() ? opt.isRedFlag : !opt.isRedFlag).map((item) => {
                          return (
                            <View style={{ flexDirection: "row", alignItems: 'center', marginVertical: 6, paddingTop: convertHeight(7) }}>
                              <CheckBox
                                value={item.integrationOption}
                                label={item.integrationOption}
                                disabled={viewAssessment}
                                checked={setAssessementIntegrationOptions(item)}
                                onPress={() => changeIntegrationCheckValue(!setAssessementIntegrationOptions(item), item.id)}
                              />
                            </View>
                          )
                        }
                        )}
                    </RadioButton.Group>
                  </View>
                </View>
                <View pointerEvents={viewAssessment ? 'none': 'auto'}>
                  <TextInput
                    label={t('Assessment:label:specifyReason')}
                    name="specify_reason"
                    //onBlur={handleBlur}
                    //onChangeText={(text) => setSpecifyReason(text)}
                    onChangeText={(text) => handleSpecifyReasonChange(text)}
                    value={specify_reason}
                    disabled={viewAssessment}
                    // error={Boolean(touched.city && errors.city)}
                    // helperText={touched.city && errors.city}
                    style={{
                      minHeight: convertHeight(75),
                      fontSize: convertHeight(12),
                      marginVertical: 20
                    }}
                    multiline={true}
                    outlineColor={colorPalette.grey2}
                    activeOutlineColor={colorPalette.primary.main}
                    placeholderTextColor={colorPalette.text.primary}
                    underlineColor='transparent'
                    mode="outlined"
                    onFocus={() => setBottomTextInputHeight(true)}
                    inputAccessoryViewID={InputAccessoryViewID}
                  />

                </View>

                <View style={{ borderTopColor: '#666666', borderTopWidth: 1, paddingVertical: convertHeight(15) }}>
                  <View key="1">
                    <Text style={Theme.text}>{t('Assessment:redFlagTranslation:pleaseIndicateFollowUp')}</Text>
                    {/* <RadioGroup row value={visitInterval} onChange={(value) => setVisitInterval(value)} > */}
                    {recommendationQuestionOptions && recommendationQuestionOptions.length > 0 && recommendationQuestionOptions.map(item => {
                      return (
                        <View style={{ flexDirection: "row", alignItems: 'center', paddingTop: convertHeight(7) }}>
                          <CustRadioButton
                            style={{ marginVertical: 4, width: convertWidth(275) }}
                            value={item.key}
                            label={item.option}
                            checked={visitInterval && visitInterval === item.key}
                            disabled={viewAssessment}
                            onPress={() => setVisitInterval(item.key)}
                          />
                        </View>
                      )
                    })}
                  </View>
                </View>
                <View pointerEvents={viewAssessment ? 'none': 'auto'}>
                  <TextInput
                    // error={Boolean(touched.city && errors.city)}
                    // helperText={touched.city && errors.city}
                    style={{
                      minHeight: convertHeight(75),
                      fontSize: convertHeight(12),
                      marginBottom: keyboardIsOpen ? 320: 120
                    }}
                    multiline={true}
                    label={<Text style={{fontSize: convertHeight(11)}}>{t('Assessment:label:overallObservationAndThoughts')}</Text>}
                    name="overall_observations"
                    value={overall_observations}
                    disabled={viewAssessment}
                    outlineColor={colorPalette.grey2}
                    activeOutlineColor={colorPalette.primary.main}
                    onChangeText={(text) => setOverallObservations(text)}
                    placeholderTextColor={colorPalette.text.primary}
                    underlineColor='transparent'
                    mode="outlined"
                    onFocus={() => setBottomTextInputHeight(true)}
                    inputAccessoryViewID={InputAccessoryViewID}
                  />

                </View>
              </>
            </View >
            </KeyboardAwareScrollView>}
          {/* </ScrollView>} */}

        {formPage === 10 && <FormPageTen navigation={navigation} validateSaveAndReturn={validateSaveAndReturn} />}

      </View >

      <Portal>

        <Dialog dismissable visible={userWarningDialogEnabled !== undefined} onDismiss={() => {
          if (userWarningDialogEnabled) {
            setUserWarningDialogEnabled(undefined)
          }
        }}
          style={{ borderRadius: 10 }}>
          <Dialog.Title>{t('Assessment:message:confirm')}</Dialog.Title>
          <Dialog.Content>
            <Paragraph>{t('Assessment:message:areYouSureWantToLeave')}</Paragraph>
          </Dialog.Content>
          <Dialog.Actions>
            <Button labelStyle={{ color: colorPalette.primary.main }}
              style={{ marginHorizontal: 10 }}
              uppercase={false} onPress={() => setUserWarningDialogEnabled(undefined)}>{t('Common:label:cancel')}</Button>
            <Button style={{
              backgroundColor: colorPalette.primary.main,
              alignContent: 'center',
              width: 68
            }}
              labelStyle={{ color: 'white' }}
              mode={'outlined'} onPress={() => navigation.dispatch(userWarningDialogEnabled)}>{t('Common:label:ok')}</Button>
          </Dialog.Actions>
        </Dialog>


        <Dialog dismissable visible={showThoughtsInputDialog.length > 0} onDismiss={() => setShowThoughtsInputDialog('')}
          style={[{ borderRadius: 10 }, Platform.OS === 'ios' ? { marginBottom: 80 } : {}]}>
          <Dialog.Title>{showThoughtsInputDialog === 'child' ? t("Assessment:label:childsThought") : t("Assessment:label:familysThought")}</Dialog.Title>
          <Dialog.Content>
            <TextInput
              autoFocus={true}
              editable={!viewAssessment}
              outlineColor={colorPalette.grey2}
              activeOutlineColor={colorPalette.primary.main}
              value={thoughtsInput}
              placeholderTextColor={colorPalette.text.primary}
              onChangeText={(text) => {
                showThoughtsInputDialog === 'child' ? setValChildThought(false) : setValFamilyThought(false)
                setThoughtsInput(text)
              }}
              label={showThoughtsInputDialog === 'child' ? "Child's thought on placement" : "Family's thought on placement"}
              style={{
                fontSize: 16
              }}
              mode="outlined"
              underlineColor='transparent'
              inputAccessoryViewID={InputAccessoryViewID}
            />
          </Dialog.Content>
          <Dialog.Actions>
            <Button labelStyle={{ color: colorPalette.primary.main }}
              style={{ marginHorizontal: 10 }}
              uppercase={false} onPress={() => setShowThoughtsInputDialog('')}>{t('Common:label:cancel')}</Button>
            <Button style={{
              backgroundColor: colorPalette.primary.main,
              alignContent: 'center',
              width: 68
            }}
              labelStyle={{ color: 'white', alignContent: 'center', }}
              mode={'outlined'} onPress={() => setThoughtsInputDialogAction('ok')}>{t('Common:label:ok')}</Button>
          </Dialog.Actions>
        </Dialog>

        <Dialog dismissable visible={showQuestionTip.length > 0} onDismiss={() => setShowQuestionTip('')}
          style={{ borderRadius: 10 }}>
          <Dialog.Content>
            <Paragraph>{showQuestionTip}</Paragraph>
          </Dialog.Content>
          <Dialog.Actions>
            <Button labelStyle={{ color: colorPalette.primary.main }}
              style={{ marginHorizontal: 10 }}
              uppercase={false} onPress={() => setShowQuestionTip('')}><TextView textObject={'Common:label:close'} /></Button>
          </Dialog.Actions>
        </Dialog>

        {loading || submitAssessment === 'do-save' ? <View style={{
          flex: 1,
          justifyContent: 'center',
          alignItems: 'center',
        }}><ActivityIndicator
            animating={loading || submitAssessment === 'do-save'}
            color={colorPalette.primary.main}
            size={"large"} />
        </View> : <></>}

      </Portal>
      <Snackbar
        visible={saveAndReturnLaterError.length > 0}
        onDismiss={() => setSaveAndReturnLaterError('')}
        duration={3000}
      >
        {saveAndReturnLaterError}
      </Snackbar>
      {formPage !== 10 && !keyboardIsOpen && <PrevNextButtons
        handleRightClick={handleRightClick}
        handleLeftClick={handleLeftClick}
        loading={loading}
        formPage={formPage}
        viewAssessment={viewAssessment}
        validateButton={() => validateButton()}
        validateSaveAndReturn={() => validateSaveAndReturn()}
      />}
      {/* {formSubmitted || viewAssessment ? <Footer /> : <></>} */}
    </SafeAreaView>
  )
}



export default Assessment
