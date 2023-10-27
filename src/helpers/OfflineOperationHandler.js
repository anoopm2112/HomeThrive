import React, { createContext, useState, useMemo, useContext, useEffect } from "react";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { View, StyleSheet } from "react-native";
import Constants from "../common/hooks/Constants";
import _ from "lodash";
import APIS from "../common/hooks/useApiCalls";
import SQLite from 'react-native-sqlite-storage';
import DbConstants from "../common/hooks/DbConstants";
import moment from 'moment';
import { useAuthHandlerContext } from "../common/hooks/AuthHandler";
import { Button, Dialog, Portal, Paragraph } from 'react-native-paper';
import { useTranslation } from 'react-i18next';
import colorPalette from '../theme/Palette';
import { useNavigation } from "@react-navigation/native";

SQLite.DEBUG(false);
SQLite.enablePromise(true);
let isValid = false;

const OfflineHandlerContext = createContext(() => { });
export const useOfflineDataContext = () => useContext(OfflineHandlerContext);

let dbInstance

const insertAssessmentQuery = `INSERT INTO ${DbConstants.assessmentListTable.tableName} (${DbConstants.assessmentListTable.columns.htAssessmentReintegrationTypeId.columnName},
    ${DbConstants.assessmentListTable.columns.htCaseId.columnName},
    ${DbConstants.assessmentListTable.columns.htFormId.columnName},
    ${DbConstants.assessmentListTable.columns.caseId.columnName},
    ${DbConstants.assessmentListTable.columns.caseWorkerFirstName.columnName},
    ${DbConstants.assessmentListTable.columns.caseWorkerLastName.columnName},
    ${DbConstants.assessmentListTable.columns.childFirstName.columnName},
    ${DbConstants.assessmentListTable.columns.childId.columnName},
    ${DbConstants.assessmentListTable.columns.childLastName.columnName},
    ${DbConstants.assessmentListTable.columns.dateOfAssessment.columnName},
    ${DbConstants.assessmentListTable.columns.id.columnName},
    ${DbConstants.assessmentListTable.columns.isActive.columnName},
    ${DbConstants.assessmentListTable.columns.isComplete.columnName},
    ${DbConstants.assessmentListTable.columns.meetWithChild.columnName},
    ${DbConstants.assessmentListTable.columns.organizationId.columnName},
    ${DbConstants.assessmentListTable.columns.organizationName.columnName},
    ${DbConstants.assessmentListTable.columns.updatedAt.columnName},
    ${DbConstants.assessmentListTable.columns.userId.columnName},
    ${DbConstants.assessmentListTable.columns.assessmentPayload.columnName},
    ${DbConstants.assessmentListTable.columns.assessmentInfo.columnName},
    ${DbConstants.assessmentListTable.columns.isSynced.columnName},
    ${DbConstants.assessmentListTable.columns.isOffline.columnName},
    ${DbConstants.assessmentListTable.columns.deviceType.columnName},
    ${DbConstants.assessmentListTable.columns.formRevisionNumber.columnName},
    ${DbConstants.assessmentListTable.columns.assessmentStartsAt.columnName},
    ${DbConstants.assessmentListTable.columns.assessmentEndsAt.columnName},
    ${DbConstants.assessmentListTable.columns.formQuestions.columnName},
    ${DbConstants.assessmentListTable.columns.primaryChoices.columnName},
    ${DbConstants.assessmentListTable.columns.integrationOptions.columnName},
    ${DbConstants.assessmentListTable.columns.fileUrl.columnName},
    ${DbConstants.assessmentListTable.columns.assessmentScore.columnName},
    ${DbConstants.assessmentListTable.columns.previousScore.columnName}) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);`

const insertCaseDetailScript = `INSERT INTO ${DbConstants.caseDetailsTable.tableName} (
    ${DbConstants.caseDetailsTable.columns.id.columnName},
    ${DbConstants.caseDetailsTable.columns.HTChildId.columnName},
    ${DbConstants.caseDetailsTable.columns.caseStatus.columnName},
    ${DbConstants.caseDetailsTable.columns.isActive.columnName},
    ${DbConstants.caseDetailsTable.columns.numberOfAssessments.columnName},
    ${DbConstants.caseDetailsTable.columns.userFirstName.columnName},
    ${DbConstants.caseDetailsTable.columns.userLastName.columnName},
    ${DbConstants.caseDetailsTable.columns.childFirstName.columnName},
    ${DbConstants.caseDetailsTable.columns.childLastName.columnName},
    ${DbConstants.caseDetailsTable.columns.childGender.columnName},
    ${DbConstants.caseDetailsTable.columns.childBirthDate.columnName},
    ${DbConstants.caseDetailsTable.columns.dispplytext.columnName},
    ${DbConstants.caseDetailsTable.columns.lastAssesmentDate.columnName},
    ${DbConstants.caseDetailsTable.columns.previousScore.columnName},
    ${DbConstants.caseDetailsTable.columns.caseId.columnName}
    ) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);`

const OfflineOperationHandler = (props) => {

    const { isAppOnline, userAuthorized, getCurrentLanguageId } = useAuthHandlerContext()
    const { t } = useTranslation()
    const navigation = useNavigation()

    const [result, setResultData] = useState({ data: null })
    const [showUserAlert, setShowUserAlert] = useState(false)
    let continueOperation = true


    const setResult = (response) => {
        setResultData(response)
        setTimeout(() => {
            setResultData(Constants.createResponse('', {}))
        }, 1000)
    }

    useEffect(() => {
        if (!isAppOnline && showUserAlert) {
            setShowUserAlert(false)
        }
        if (isAppOnline && userAuthorized) {
            doOperation({ operationKey: Constants.offlineOperations.isSyncPending })
            doOperation({
                operationKey: Constants.offlineOperations.downloadData,
                subOperation: Constants.offlineOperations.downloadWeeklyAssessments
            })
        }
    }, [isAppOnline, userAuthorized])

    const closeDatabase = () => {
        if (dbInstance) {
            dbInstance.close().then(() => {

            }).catch(() => {

            });
        } else {

        }
    }

    const handleSetContinue = (value) => {
        continueOperation = value
    }

    const doOperation = (params) => {
        if (isValid) {
            checkWhichDBQueryExecute(params);
        } else {
            SQLite.openDatabase(DbConstants.dbInfo.dbName, DbConstants.dbInfo.dbVersion, DbConstants.dbInfo.dbDisplayName, DbConstants.dbInfo.dbSize).then((DB) => {
                dbInstance = DB;
                // DB Opened
                checkExistingTablesVersionID(params);  
            }).catch(() => {  
                isValid = false;            
                // setDBProcessCompletedStatus(dbConstants.actionStatus.OPEN_DB_ERROR);  
            });
        } 
    }

    const checkExistingTablesVersionID = (params) => {
        // starting offline operation 
        const tableName = DbConstants.tables.VERSION;
        const dbVersionTxt = DbConstants.dbInfo.dbVersion;
    
        dbInstance.executeSql(`SELECT 1 FROM ${tableName} LIMIT 1`).then(() => {	//TABLE CHECK SUCCESS
            // console.log('SUCCESS');
            dbInstance.transaction((tx) => {              
                const sql = `SELECT version_id FROM ${tableName} LIMIT 1;`;  
                tx.executeSql(sql, [])
                    .then(([tx, results]) => {
                        const totalRecords = results.rows.length;
                        // console.log('totalRecords', totalRecords);                   
                        if (totalRecords > 0) {
                            const versionNumFromDB = _.get(results.rows.item(0), "version_id");
                            // console.log('versionNumFromDB', versionNumFromDB);                       
                            if (dbVersionTxt === versionNumFromDB){
                                // console.log('EQUAL');
                                checkWhichDBQueryExecute(params);
                            } else {   
                                // console.log('NOT EQUAL');   
                                dbInstance.transaction(tx => {
                                    tx.executeSql(
                                        `select exists(select 1 from ${DbConstants.assessmentListTable.tableName} where ${DbConstants.assessmentListTable.columns.isSynced.columnName} = ?);`,
                                        [0], (unused, { rows }) => {
                                            // Has data to sync >> ', rows.item(0))
                                            // Has data to sync >> ', rows.item(0)[Object.keys(rows.item(0))[0]] > 0)
                                            if (rows.item(0)[Object.keys(rows.item(0))[0]] == 0) {
                                                createAllTables(params);
                                            } else {
                                                checkWhichDBQueryExecute(params);
                                            }
                                        })
                                })                                     
                                // createAllTables(params);
                            }                                                
                        } else {
                            createAllTables(params);	                      
                        }                  
                    }).catch(() => {
                        createAllTables(params);	            
                    });
            }); 
    
        }).catch(() => { //TABLE CHECK FAILED
            console.log('FAILED');                    
            // createAllTables(params);	
            dbInstance.executeSql(`SELECT 1 FROM ${DbConstants.assessmentListTable.tableName} LIMIT 1`).then(() => {
                dbInstance.transaction(tx => {
                    tx.executeSql(
                        `select exists(select 1 from ${DbConstants.assessmentListTable.tableName} where ${DbConstants.assessmentListTable.columns.isSynced.columnName} = ?);`,
                        [0], (unused, { rows }) => {
                            // Has data to sync >> ', rows.item(0))
                            // Has data to sync >> ', rows.item(0)[Object.keys(rows.item(0))[0]] > 0)
                            if (rows.item(0)[Object.keys(rows.item(0))[0]] == 0) {
                                createAllTables(params);
                            } else {
                                checkWhichDBQueryExecute(params);
                            }
                        })
                })
            }).catch(() => {
                createAllTables(params);
            });
        });      
    };
    
    //CREATE ALL TABLES FOR OFFLINE MODE - START    
    const createAllTables = (params) => {         
        // appClearAllDBStorageItems();
        createVersionTableWithVersionID(params);               
    };

    const createVersionTableWithVersionID = (params) => {
        const tableName = DbConstants.tables.VERSION;        
        droppingTable(tableName);
        dbInstance.transaction((tx) => {                     
            const sql = `CREATE TABLE IF NOT EXISTS ${tableName}
            (version_id VARCHAR(8) DEFAULT '1.0');`;
            tx.executeSql(sql, [])
                .then(([tx, results]) => {  
                    insertVersionNumberData(params);
                }).catch(() => {                      
        //             setDBProcessCompletedStatus(dbConstants.actionStatus.ALL_TABLE_CREATION_ERROR);                                 
                }); 
        });                
    };

    const droppingTable = (tableName) => {
        dbInstance.transaction((tx) => {             
            const sql = `DROP TABLE IF EXISTS ${tableName};`;  
            tx.executeSql(sql, [])
                .then(([tx, results]) => {                    
                    console.log('dropTaaa',tableName);                     
                }).catch(() => {  
                    // console.log(tableName);               
                }); 
        });              
    };

    const insertVersionNumberData = (params) => {	       
        const tableName = DbConstants.tables.VERSION;
        const dbVersionTxt = DbConstants.dbInfo.dbVersion;
        dbInstance.transaction((tx) => {  
            const sql = `INSERT INTO ${tableName} (version_id) VALUES(${dbVersionTxt})`;           
            tx.executeSql(sql)
                .then(([tx, results]) => {                                             
                    const totalChanges = results.rowsAffected;  
                    console.log('totalChanges', totalChanges); 
                    if (totalChanges > 0) {                        
                        createTableAndContinueUpdatedAssessmentsListOperation(params); 
                    } else {    
                        console.log('ALL_TABLE_CREATION_ERROR');                  
                        // setDBProcessCompletedStatus(dbConstants.actionStatus.ALL_TABLE_CREATION_ERROR);                        
                    }       
                }).catch(() => {                      
                    // setDBProcessCompletedStatus(dbConstants.actionStatus.ALL_TABLE_CREATION_ERROR);                                 
                }); 
        });     		
    };

    const checkWhichDBQueryExecute = (params) => {
        
        isValid = true; 

        const operation = _.get(params, "operationKey")
        if (operation) {
            switch (operation) {
                case Constants.offlineOperations.fetchCaseList:
                case Constants.offlineOperations.saveCaseList:
                case Constants.offlineOperations.getCaseList:
                    checkCaseListDB(params)
                    return
                case Constants.offlineOperations.getAssessmentsList:
                case Constants.offlineOperations.saveAssessment:
                    console.log('SAVEASS - checkWhichDBQueryExecute');
                case Constants.offlineOperations.deleteAssessment:
                case Constants.offlineOperations.isSyncPending:
                    checkUpdatedAssessmentsListDB(params)
                    return
                case Constants.offlineOperations.getCaseDetail:
                case Constants.offlineOperations.saveCaseDetail:
                    checkCaseDetailsDB(params)
                    return
                case Constants.offlineOperations.fetchFormData:
                    fetchRecentFormData()
                    return
                case Constants.offlineOperations.saveFormData:
                    saveFormData(params && params.domainData,
                        params && params.assessmentFormQuestions,
                        params && params.reIntegrationTypes,
                        params && params.visitTypes)
                    return
                case Constants.offlineOperations.getFormData:
                    getFormData()
                    return
                case Constants.offlineOperations.saveFormDetails:
                    saveFormDetails(params.details)
                    return
                case Constants.offlineOperations.getFormDetails:

                    return
                case Constants.offlineOperations.calculateAssessmentScore:
                    calculateAssessmentScore(params)
                    return
                case Constants.offlineOperations.downloadData:
                    downloadData(params)
                    return
            }
        }  
    }; 

    const downloadData = async (params) => {
        if (continueOperation) {
            fetchRecentFormData().then(response => {
                if (response === 200 && continueOperation) {
                    checkUpdatedAssessmentsListDB(params)
                } else {
                    setResult(Constants.createResponse(Constants.offlineOperations.downloadData, null))
                }
            }).catch(error => {

            })
        }
    }

    const isSyncPending = () => {
        dbInstance.transaction(tx => {
            tx.executeSql(
                `select exists(select 1 from ${DbConstants.assessmentListTable.tableName} where ${DbConstants.assessmentListTable.columns.isSynced.columnName} = ?);`,
                [0], (unused, { rows }) => {
                    // Has data to sync >> ', rows.item(0))
                    // Has data to sync >> ', rows.item(0)[Object.keys(rows.item(0))[0]] > 0)
                    if (!showUserAlert) {
                        setShowUserAlert(rows.item(0)[Object.keys(rows.item(0))[0]] > 0)
                    }
                })
        })
    }


    //Updated Assessments operation ||---------------->

    const performAssessmentTableAction = (params) => {
        try {
            const operation = _.get(params, "operationKey")
            switch (operation) {
                case Constants.offlineOperations.getAssessmentsList:
                    fetchAssessmentsList(params)
                    return
                case Constants.offlineOperations.saveAssessment:
                    console.log('SAVEASS - performAssessmentTableAction');
                    saveAssessmentToDB(params.isNew,
                        params.data,
                        params.score,
                        params.assessment,
                        params.caseData,
                        params.formQuestions,
                        params.primaryChoices,
                        params.integrationOptions)
                    return
                case Constants.offlineOperations.downloadData:
                    if (continueOperation) {
                        if (params.subOperation && params.subOperation === Constants.offlineOperations.downloadWeeklyAssessments) {
                            handleSetContinue(true)
                            downloadThisWeekAssessments(params)
                        } else {
                            downloadAssessments(params)
                        }
                    }
                    return
                case Constants.offlineOperations.deleteAssessment:
                    deleteAssessment(params.data)
                    return
                case Constants.offlineOperations.dropAllTables:
                    dropAllTablesAfterUpload();
                    return
                case Constants.offlineOperations.isSyncPending:
                    isSyncPending()
                    return
            }
        } catch (err) {
            console.log('Offline handler : error >>', err)
        }
    }

    const deleteAssessment = (id) => {
        dbInstance.transaction(tx => {
            tx.executeSql(`DELETE FROM ${DbConstants.assessmentListTable.tableName} WHERE 
        ${DbConstants.assessmentListTable.columns.id.columnName} = ?`, [id], (unused, { rows }) => {
                // Assessment Deleted, rows
                setResult(Constants.createResponse(Constants.offlineOperations.deleteAssessment, []))
            })
        })
    }

    const dropAllTablesAfterUpload = () => {
        doOperation({ operationKey: Constants.offlineOperations.isSyncPending })
            doOperation({
                operationKey: Constants.offlineOperations.downloadData,
                subOperation: Constants.offlineOperations.downloadWeeklyAssessments
            })
    }

    const downloadAssessments = async (params) => {
        try {
            await dbInstance.transaction(tx => {
                tx.executeSql(`DELETE FROM ${DbConstants.assessmentListTable.tableName} WHERE 
            ${DbConstants.assessmentListTable.columns.isSynced.columnName} = ?`, [1])
            })

            const formList = await APIS.FormList();
            if (formList && formList.data && formList.data.data[0]) {
                let details = formList.data.data[0]

                let fetchAssessmentPayload = {
                    "rowCount": `10`,
                    "pageNumber": `1`,
                    "needFullData": "true",
                    "assessmentStatus": "Active",
                    "orderByField": [
                        [
                            "dateOfAssessment",
                            "ASC"
                        ],
                        [
                            "id",
                            "DESC"
                        ]
                    ],
                    "globalSearchQuery": "",
                    "isComplete": "",
                    "loggedInDevice": "mobile"
                }

                const assessmentsListData = await APIS.AssessmentList(fetchAssessmentPayload);
                let assessmentList = assessmentsListData.data.data

                const totalRecords = assessmentList.length
                let i = 0
                while (i < totalRecords) {
                    const caseData = assessmentList[i]
                    const data = await APIS.GetAssessmentDetails(caseData.id, details.currentRevision, getCurrentLanguageId());
                    if (data && data.data) {
                        let assessmentDetailsData = data.data
                        let formQuestions = assessmentDetailsData.assessmentDetails[0] &&
                            assessmentDetailsData.assessmentDetails[0].HT_form &&
                            assessmentDetailsData.assessmentDetails[0].HT_form.HT_formRevisions

                        saveAssessmentToDB(false,
                            null,
                            assessmentDetailsData.assessmentScore,
                            assessmentDetailsData.assessmentDetails[0],
                            caseData,
                            formQuestions,
                            assessmentDetailsData.primaryChoices,
                            assessmentDetailsData.integrationOptionResponses
                        )
                        if (!continueOperation) {
                            return
                        }
                        i++
                    } else {
                        return
                    }
                }
            }

            if (continueOperation) {
                checkCaseListDB(params)
            }

        } catch (error) {
            console.log("Error>>", error)
        }
    }

    const downloadThisWeekAssessments = async (params) => {
        try {
            await dbInstance.transaction(tx => {
                tx.executeSql(`DELETE FROM ${DbConstants.assessmentListTable.tableName} WHERE 
        ${DbConstants.assessmentListTable.columns.isSynced.columnName} = ?`, [1])
            })

            const formList = await APIS.FormList();
            if (formList && formList.data && formList.data.data[0]) {
                let details = formList.data.data[0]

                // const startDate = moment().startOf('week');
                // const endDate = moment().endOf('week');
                const startDate = moment().format('YYYY/MM/DD');
                const endDate = moment(startDate, "YYYY/MM/DD").add(6, 'days');

                let fetchAssessmentPayload = {
                    "rowCount": `10`,
                    "pageNumber": `1`,
                    "needFullData": "true",
                    "assessmentStatus": "Active",
                    "orderByField": [
                        [
                            "dateOfAssessment",
                            "ASC"
                        ],
                        [
                            "id",
                            "DESC"
                        ]
                    ],
                    "globalSearchQuery": "",
                    "isComplete": "Not Completed",
                    "dateFilterFrom": `${startDate}`,
                    "dateFilterTo": `${endDate.format('YYYY/MM/DD')}`,
                    "loggedInDevice": "mobile"
                }

                const assessmentsListData = await APIS.AssessmentList(fetchAssessmentPayload);
                let assessmentList = assessmentsListData.data.data

                const totalRecords = assessmentList.length
                let i = 0
                while (i < totalRecords) {
                    const caseData = assessmentList[i]
                    const data = await APIS.GetAssessmentDetails(caseData.id, details.currentRevision, getCurrentLanguageId());
                    if (data && data.data) {
                        let assessmentDetailsData = data.data
                        let formQuestions = assessmentDetailsData.assessmentDetails[0] &&
                            assessmentDetailsData.assessmentDetails[0].HT_form &&
                            assessmentDetailsData.assessmentDetails[0].HT_form.HT_formRevisions

                        saveAssessmentToDB(false,
                            null,
                            assessmentDetailsData.assessmentScore,
                            assessmentDetailsData.assessmentDetails[0],
                            caseData,
                            formQuestions,
                            assessmentDetailsData.primaryChoices,
                            assessmentDetailsData.integrationOptionResponses
                        )

                        i++
                    } else {
                        return
                    }
                }
            }

            //continue to download case list
            checkCaseListDB(params)

        } catch (error) {
            console.log("Error>>", error)
        }
    }


    const checkUpdatedAssessmentsListDB = (params) => {
        console.log('sssssyyy', params);
        dbInstance.transaction(tx => {
            tx.executeSql(
                `SELECT name FROM sqlite_master WHERE type='table' AND name='${DbConstants.assessmentListTable.tableName}';`,
                [], (unused, { rows }) => {
                    if (rows.length !== 0) {
                        console.log('ssyy - IF');
                        performAssessmentTableAction(params)
                    } else {
                        console.log('ssyy - ELSE');
                        createTableAndContinueUpdatedAssessmentsListOperation(params)
                    }
                }, (error) => {

                })
        })
    }

    const fetchAssessmentsList = (params) => {
        dbInstance.transaction(tx => {
            let selectRecordsQuery = `SELECT * FROM ${DbConstants.assessmentListTable.tableName}`
            selectRecordsQuery = `${selectRecordsQuery}${isAppOnline || params.isUpload !== undefined || (params.dateFilterFrom !== undefined && params.dateFilterFrom !== '' && params.dateFilterTo !== undefined && params.dateFilterTo !== '') ? ' WHERE ' : ''}`
            selectRecordsQuery = `${selectRecordsQuery}${isAppOnline || params.isUpload !== undefined ? `${DbConstants.assessmentListTable.columns.isSynced.columnName} = 0 ${params.dateFilterFrom !== undefined && params.dateFilterFrom !== '' && params.dateFilterTo !== undefined && params.dateFilterTo !== '' ? 'AND ' : ''}` : ''}`
            selectRecordsQuery = `${selectRecordsQuery}${params.dateFilterFrom !== undefined && params.dateFilterFrom !== '' && params.dateFilterTo !== undefined && params.dateFilterTo !== '' ? `${DbConstants.assessmentListTable.columns.dateOfAssessment.columnName} BETWEEN "${params.dateFilterFrom}" AND "${params.dateFilterTo}" ` : ''}`
            //  selectRecordsQuery = `${selectRecordsQuery} ${params.globalSearchQuery && params.globalSearchQuery.length > 0 ? `
            //  ${DbConstants.assessmentListTable.columns.childFirstName.columnName} LIKE "%${params.globalSearchQuery}%" or
            //  ${DbConstants.assessmentListTable.columns.childLastName.columnName} LIKE "%${params.globalSearchQuery}%" or 
            //  ${DbConstants.assessmentListTable.columns.caseWorkerFirstName.columnName} LIKE "%${params.globalSearchQuery}%" or
            //  ${DbConstants.assessmentListTable.columns.caseWorkerLastName.columnName} LIKE "%${params.globalSearchQuery}%" or 
            //  ${DbConstants.assessmentListTable.columns.caseId.columnName} LIKE "%CASE-${params.globalSearchQuery}%" ` : ''}`
            console.log('####', selectRecordsQuery);
            // params.orderByField.forEach((order, index) => {
            //     selectRecordsQuery = `${selectRecordsQuery} ${index === 0 ? 'ORDER BY' : ''} ${order[0] === 'dateOfAssessment' ? `${DbConstants.assessmentListTable.columns.dateOfAssessment.columnName}` : order[0]} ${order[1]}${index !== params.orderByField.length - 1 ? ',' : ';'}`
            // })

            


            tx.executeSql(selectRecordsQuery, [], (unused, { rows }) => {
                const totalRecords = rows.length;
                console.log('##*##', selectRecordsQuery, totalRecords);
                if (totalRecords > 0) {
                    let assessmentsList = [];
                    for (let i = 0; i < totalRecords; ++i) {
                        const assessment = rows.item(i);
                        assessmentsList.push({
                            HTAssessmentReintegrationTypeId: _.get(assessment, DbConstants.assessmentListTable.columns.htAssessmentReintegrationTypeId.columnName),
                            HTCaseId: _.get(assessment, DbConstants.assessmentListTable.columns.htCaseId.columnName),
                            HTFormId: _.get(assessment, DbConstants.assessmentListTable.columns.htFormId.columnName),
                            caseId: _.get(assessment, DbConstants.assessmentListTable.columns.caseId.columnName),
                            caseWorkerFirstName: _.get(assessment, DbConstants.assessmentListTable.columns.caseWorkerFirstName.columnName),
                            caseWorkerLastName: _.get(assessment, DbConstants.assessmentListTable.columns.caseWorkerLastName.columnName),
                            childFirstName: _.get(assessment, DbConstants.assessmentListTable.columns.childFirstName.columnName),
                            childId: _.get(assessment, DbConstants.assessmentListTable.columns.childId.columnName),
                            childLastName: _.get(assessment, DbConstants.assessmentListTable.columns.childLastName.columnName),
                            dateOfAssessment: _.get(assessment, DbConstants.assessmentListTable.columns.dateOfAssessment.columnName),
                            id: _.get(assessment, DbConstants.assessmentListTable.columns.id.columnName),
                            isActive: parseInt(_.get(assessment, DbConstants.assessmentListTable.columns.isActive.columnName), 10) === 1,
                            isComplete: parseInt(_.get(assessment, DbConstants.assessmentListTable.columns.isComplete.columnName), 10) === 1,
                            meetWithChild: parseInt(_.get(assessment, DbConstants.assessmentListTable.columns.meetWithChild.columnName), 10) === 1,
                            organizationId: _.get(assessment, DbConstants.assessmentListTable.columns.organizationId.columnName),
                            organizationName: _.get(assessment, DbConstants.assessmentListTable.columns.organizationName.columnName),
                            updatedAt: _.get(assessment, DbConstants.assessmentListTable.columns.updatedAt.columnName),
                            userId: _.get(assessment, DbConstants.assessmentListTable.columns.userId.columnName),
                            payload: _.get(assessment, DbConstants.assessmentListTable.columns.assessmentPayload.columnName).length > 0 ? JSON.parse(_.get(assessment, DbConstants.assessmentListTable.columns.assessmentPayload.columnName)) : _.get(assessment, DbConstants.assessmentListTable.columns.assessmentPayload.columnName),
                            assessment: _.get(assessment, DbConstants.assessmentListTable.columns.assessmentInfo.columnName).length > 0 ? JSON.parse(_.get(assessment, DbConstants.assessmentListTable.columns.assessmentInfo.columnName)) : '',
                            isSynced: parseInt(_.get(assessment, DbConstants.assessmentListTable.columns.isSynced.columnName), 10) === 1,      
                            isOffline: parseInt(_.get(assessment, DbConstants.assessmentListTable.columns.isOffline.columnName), 10) === 1,
                            deviceType: _.get(assessment, DbConstants.assessmentListTable.columns.deviceType.columnName),
                            formRevisionNumber: _.get(assessment, DbConstants.assessmentListTable.columns.formRevisionNumber.columnName),
                            assessmentStartsAt: _.get(assessment, DbConstants.assessmentListTable.columns.assessmentStartsAt.columnName),
                            assessmentEndsAt: _.get(assessment, DbConstants.assessmentListTable.columns.assessmentEndsAt.columnName),               
                            formQuestions: JSON.parse(_.get(assessment, DbConstants.assessmentListTable.columns.formQuestions.columnName)),
                            primaryChoices: JSON.parse(_.get(assessment, DbConstants.assessmentListTable.columns.primaryChoices.columnName)),
                            integrationOptions: JSON.parse(_.get(assessment, DbConstants.assessmentListTable.columns.integrationOptions.columnName)),
                            fileUrl: _.get(assessment, DbConstants.assessmentListTable.columns.fileUrl.columnName),
                            assessmentScore: JSON.parse(_.get(assessment, DbConstants.assessmentListTable.columns.assessmentScore.columnName)),
                            previousScore: _.get(assessment, DbConstants.assessmentListTable.columns.previousScore.columnName)
                        })
                    }
                    setResult(Constants.createResponse(Constants.offlineOperations.getAssessmentsList, assessmentsList))
                } else {
                    setResult(Constants.createResponse(Constants.offlineOperations.getAssessmentsList, []))
                }
            }, (error) => {
                console.log('error>>', error)
            })
        })

    }

    const saveAssessmentToDB = async (isNew, assessmentPayload, assessmentScore, assessment, caseData, formQuestions, primaryChoices, integrationOptions) => {
        dbInstance.transaction(tx => {
            const assessmentRecordID = isNew ? Math.floor(1000 + Math.random() * 9000) : caseData.id

            const checkRecordQuery = `SELECT COUNT(1) FROM ${DbConstants.assessmentListTable.tableName} WHERE ${DbConstants.assessmentListTable.columns.id.columnName} = ?`

            const calculatedScore = assessmentPayload !== null && assessmentScore === null ? calculateScore(assessmentPayload) : assessmentScore

            tx.executeSql(checkRecordQuery, [assessmentRecordID], (unused, { rows }) => {

                if (_.get(rows.item(0), "COUNT(1)") < 1) {
                    // Not Exist Condition, assessmentRecordID
                    // values to be inserted
                    // console.log('AKSHAY', insertAssessmentQuery);
                    let values = [
                        assessment && assessment.HTAssessmentReintegrationTypeId !== null ? assessment.HTAssessmentReintegrationTypeId : 1,
                        assessment && assessment.HTCaseId !== null ? assessment.HTCaseId : assessmentPayload.HTCaseId,
                        assessment && assessment.HTFormId !== null ? assessment.HTFormId : assessmentPayload.HTFormId,
                        !isNew ? assessment.HTCaseId : caseData.caseid,
                        isNew ? caseData.userFirstName : caseData.caseWorkerFirstName,
                        isNew ? caseData.userLastName : caseData.caseWorkerLastName,
                        caseData.childFirstName,
                        isNew ? caseData.childid : caseData.childId,
                        caseData.childLastName,
                        moment(assessment && assessment.dateOfAssessment !== null ? assessment.dateOfAssessment : assessmentPayload.dateOfAssessment, assessment && assessment.dateOfAssessment !== null ? 'DD/MM/YYYY' : 'YYYY-MM-DD').format('DD/MM/YYYY'),
                        assessmentRecordID,
                        assessment && assessment.isActive !== null ? assessment.isActive ? 1 : 0 : 1,
                        assessmentPayload !== null ? assessmentPayload.isComplete ? 1 : 0 : assessment && assessment.isComplete !== null && assessment.isComplete ? 1 : 0,
                        assessment && assessment.meetWithChild !== null ? assessment.meetWithChild === 'true' ? 1 : 0 : assessmentPayload.meetWithChild === 'true' ? 1 : 0,
                        !isNew ? caseData.organizationId : '',
                        !isNew ? caseData.organizationName : '',
                        assessment && assessment.updatedAt !== null ? assessment.updatedAt : assessmentPayload.dateOfAssessment,
                        assessment && assessment.userId !== null ? assessment.userId : caseData.HTUserId,
                        assessmentPayload !== null ? JSON.stringify(assessmentPayload) : '',
                        assessment !== null ? JSON.stringify(assessment) : '',
                        !isAppOnline ? 0 : 1,
                        true,
                        'MOBILE',
                        assessment && assessment.formRevisionNumber != null ? assessment.formRevisionNumber : assessmentPayload.formRevisionNumber,
                        assessment && assessment.assessmentStartsAt != null ? assessment.assessmentStartsAt : assessmentPayload.assessmentStartsAt,
                        assessment && assessment.assessmentEndsAt != null ? assessment.assessmentEndsAt : assessmentPayload.assessmentEndsAt,
                        JSON.stringify(formQuestions),
                        JSON.stringify(primaryChoices),
                        JSON.stringify(integrationOptions),
                        caseData.fileUrl,
                        JSON.stringify(calculatedScore),
                        caseData.previousScore !== undefined && caseData.previousScore !== null ? caseData.previousScore : '0'
                    ]
                    console.log('result - values', values,);
                    tx.executeSql(insertAssessmentQuery, values, (unused, result) => {
                        // Assessment saved, result
                        console.log('result', result);
                        setResult(Constants.createResponse(Constants.offlineOperations.saveAssessment, {}))
                    }, (error) => {
                        console.log('Offline handler: error', error)
                    })
                } else {
                    console.log('result - ELSE');
                    const operationalQuery = `UPDATE ${DbConstants.assessmentListTable.tableName} SET 
                    ${DbConstants.assessmentListTable.columns.assessmentPayload.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.formQuestions.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.primaryChoices.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.integrationOptions.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.isSynced.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.isOffline.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.formRevisionNumber.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.assessmentStartsAt.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.assessmentEndsAt.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.isComplete.columnName} = ?,
                    ${DbConstants.assessmentListTable.columns.assessmentScore.columnName} = ? 
                    WHERE 
                    ${DbConstants.assessmentListTable.columns.id.columnName} = ?`

                    // values
                    tx.executeSql(operationalQuery, [
                        JSON.stringify(assessmentPayload),
                        JSON.stringify(formQuestions),
                        JSON.stringify(primaryChoices),
                        JSON.stringify(integrationOptions),
                        0,
                        true,
                        JSON.stringify(assessmentPayload.formRevisionNumber),
                        JSON.stringify(assessmentPayload.assessmentStartsAt),
                        JSON.stringify(assessmentPayload.assessmentEndsAt),
                        assessmentPayload.isComplete ? 1 : 0,
                        JSON.stringify(calculatedScore),
                        assessmentRecordID
                    ], (unused, result) => {
                        // Assessment Updated
                        setResult(Constants.createResponse(Constants.offlineOperations.saveAssessment, {}))
                    }, (error) => {
                        console.log('Offline handler: Assessment Update failed')
                    })
                }
            })
        })
    }

    const createTableAndContinueUpdatedAssessmentsListOperation = (params) => {
        const tableName = DbConstants.assessmentListTable.tableName;
        droppingTable(tableName);
        const createTableScript = `CREATE TABLE IF NOT EXISTS ${DbConstants.assessmentListTable.tableName} (
            ${DbConstants.assessmentListTable.columns.id.columnName} ${DbConstants.assessmentListTable.columns.id.type} PRIMARY KEY,
            ${DbConstants.assessmentListTable.columns.htAssessmentReintegrationTypeId.columnName} ${DbConstants.assessmentListTable.columns.htAssessmentReintegrationTypeId.type},
            ${DbConstants.assessmentListTable.columns.htCaseId.columnName} ${DbConstants.assessmentListTable.columns.htCaseId.type},
            ${DbConstants.assessmentListTable.columns.htFormId.columnName} ${DbConstants.assessmentListTable.columns.htFormId.type},
            ${DbConstants.assessmentListTable.columns.caseId.columnName} ${DbConstants.assessmentListTable.columns.caseId.type},
            ${DbConstants.assessmentListTable.columns.caseWorkerFirstName.columnName} ${DbConstants.assessmentListTable.columns.caseWorkerFirstName.type},
            ${DbConstants.assessmentListTable.columns.caseWorkerLastName.columnName} ${DbConstants.assessmentListTable.columns.caseWorkerLastName.type},
            ${DbConstants.assessmentListTable.columns.childFirstName.columnName} ${DbConstants.assessmentListTable.columns.childFirstName.type},
            ${DbConstants.assessmentListTable.columns.childId.columnName} ${DbConstants.assessmentListTable.columns.childId.type},
            ${DbConstants.assessmentListTable.columns.childLastName.columnName} ${DbConstants.assessmentListTable.columns.childLastName.type},
            ${DbConstants.assessmentListTable.columns.dateOfAssessment.columnName} ${DbConstants.assessmentListTable.columns.dateOfAssessment.type},
            ${DbConstants.assessmentListTable.columns.isActive.columnName} ${DbConstants.assessmentListTable.columns.isActive.type} NOT NULL CHECK (${DbConstants.assessmentListTable.columns.isActive.columnName} IN (0, 1)),
            ${DbConstants.assessmentListTable.columns.isComplete.columnName} ${DbConstants.assessmentListTable.columns.isComplete.type} NOT NULL CHECK (${DbConstants.assessmentListTable.columns.isComplete.columnName} IN (0, 1)),
            ${DbConstants.assessmentListTable.columns.meetWithChild.columnName} ${DbConstants.assessmentListTable.columns.meetWithChild.type} NOT NULL CHECK (${DbConstants.assessmentListTable.columns.meetWithChild.columnName} IN (0, 1)),
            ${DbConstants.assessmentListTable.columns.organizationId.columnName} ${DbConstants.assessmentListTable.columns.organizationId.type},
            ${DbConstants.assessmentListTable.columns.organizationName.columnName} ${DbConstants.assessmentListTable.columns.organizationName.type}, 
            ${DbConstants.assessmentListTable.columns.updatedAt.columnName} ${DbConstants.assessmentListTable.columns.updatedAt.type},
            ${DbConstants.assessmentListTable.columns.userId.columnName} ${DbConstants.assessmentListTable.columns.userId.type},
            ${DbConstants.assessmentListTable.columns.assessmentPayload.columnName} ${DbConstants.assessmentListTable.columns.assessmentPayload.type},
            ${DbConstants.assessmentListTable.columns.assessmentInfo.columnName} ${DbConstants.assessmentListTable.columns.assessmentInfo.type},
            ${DbConstants.assessmentListTable.columns.isSynced.columnName} ${DbConstants.assessmentListTable.columns.isSynced.type} NOT NULL CHECK (${DbConstants.assessmentListTable.columns.isSynced.columnName} IN (0, 1)),
            ${DbConstants.assessmentListTable.columns.isOffline.columnName} ${DbConstants.assessmentListTable.columns.isOffline.type} NOT NULL CHECK (${DbConstants.assessmentListTable.columns.isOffline.columnName} IN (0, 1)),
            ${DbConstants.assessmentListTable.columns.deviceType.columnName} ${DbConstants.assessmentListTable.columns.deviceType.type},
            ${DbConstants.assessmentListTable.columns.formRevisionNumber.columnName} ${DbConstants.assessmentListTable.columns.formRevisionNumber.type},
            ${DbConstants.assessmentListTable.columns.assessmentStartsAt.columnName} ${DbConstants.assessmentListTable.columns.assessmentStartsAt.type},
            ${DbConstants.assessmentListTable.columns.assessmentEndsAt.columnName} ${DbConstants.assessmentListTable.columns.assessmentEndsAt.type},
            ${DbConstants.assessmentListTable.columns.formQuestions.columnName} ${DbConstants.assessmentListTable.columns.formQuestions.type},
            ${DbConstants.assessmentListTable.columns.primaryChoices.columnName} ${DbConstants.assessmentListTable.columns.primaryChoices.type},
            ${DbConstants.assessmentListTable.columns.integrationOptions.columnName} ${DbConstants.assessmentListTable.columns.integrationOptions.type},
            ${DbConstants.assessmentListTable.columns.fileUrl.columnName} ${DbConstants.assessmentListTable.columns.fileUrl.type},
            ${DbConstants.assessmentListTable.columns.assessmentScore.columnName} ${DbConstants.assessmentListTable.columns.assessmentScore.type},
            ${DbConstants.assessmentListTable.columns.previousScore.columnName} ${DbConstants.assessmentListTable.columns.previousScore.type}
        )`

        dbInstance.transaction(tx => {
            tx.executeSql(createTableScript, [], (unused, result) => {
                performAssessmentTableAction(params)
            }, (error) => {
                console.log('error>>', error)
            })
        })
    }

    //---------------------------------------------->||


    //Form questions operations ||-------------------->

    const fetchRecentFormData = async () => {
        try {
            const formList = await APIS.FormList();
            if (formList && formList.data && formList.data.data[0]) {
                let details = formList.data.data[0]
                const detailsString = JSON.stringify(details)
                await AsyncStorage.setItem(Constants.offlineDataKeys.formDetails, detailsString)

                const domainData = await APIS.DomainList();
                const domainString = JSON.stringify(domainData && domainData.data && domainData.data.data)
                await AsyncStorage.setItem(Constants.offlineDataKeys.domains, domainString)

                const formQuestionsData = await APIS.ListAssessmentFormQuestions(details.id, details.currentRevision, getCurrentLanguageId());
                if (formQuestionsData && formQuestionsData.data) {
                    const questionsString = JSON.stringify(formQuestionsData && formQuestionsData.data)
                    await AsyncStorage.setItem(Constants.offlineDataKeys.formQuestions, questionsString)
                }

                const dataReIntegrationTypes = await APIS.ReIntegrationTypeList()
                if (dataReIntegrationTypes && dataReIntegrationTypes.data && dataReIntegrationTypes.data.data.length !== 0) {
                    let list = dataReIntegrationTypes.data.data
                    let newReIntegrationList = [];
                    list && list.length > 0 && list.map((item) => {
                        let newItem = {
                            value: item.id,
                            label: item.reIntegrationType
                        }
                        newReIntegrationList.push(newItem)
                    })
                    const stringValue = JSON.stringify(list)
                    await AsyncStorage.setItem(Constants.offlineDataKeys.reIntegrationTypes, stringValue)
                }

                const dataVisitTypes = await APIS.VisitTypeList()
                if (dataVisitTypes && dataVisitTypes.data && dataVisitTypes.data.data.length !== 0) {
                    let list = dataVisitTypes.data.data
                    let newVisitTypeList = [];
                    list && list.length > 0 && list.map((item) => {
                        let newItem = {
                            value: item.id,
                            label: item.visitType
                        }
                        newVisitTypeList.push(newItem)
                    })
                    const stringValue = JSON.stringify(list)
                    await AsyncStorage.setItem(Constants.offlineDataKeys.visitTypes, stringValue)
                }
                // FormQuestions Stored
                return 200
            } else {
                return 204
            }
        } catch (err) {
            return 500
        }
    }

    const saveFormDetails = async (details) => {
        if (details) {
            const value = JSON.stringify(details)
            await AsyncStorage.setItem(Constants.offlineDataKeys.formDetails, value)
            // Save FormDetails
        }
    }

    const saveFormData = async (domainData, assessmentFormQuestions, reIntegrationTypes, visitTypes) => {
        if (domainData) {
            const value = JSON.stringify(domainData)
            await AsyncStorage.setItem(Constants.offlineDataKeys.domains, value)
            // Save DomainData
        }

        if (assessmentFormQuestions) {
            const formQuestionValue = JSON.stringify(assessmentFormQuestions)
            await AsyncStorage.setItem(Constants.offlineDataKeys.formQuestions, formQuestionValue)
            // Save FormQuestions
        }

        if (reIntegrationTypes) {
            const stringValue = JSON.stringify(reIntegrationTypes)
            await AsyncStorage.setItem(Constants.offlineDataKeys.reIntegrationTypes, stringValue)
        }

        if (visitTypes) {
            const stringValue = JSON.stringify(visitTypes)
            await AsyncStorage.setItem(Constants.offlineDataKeys.visitTypes, stringValue)
        }
    }

    const getFormData = async () => {
        try {
            const domainValue = await AsyncStorage.getItem(Constants.offlineDataKeys.domains)
            const parsedDomains = JSON.parse(domainValue)

            const questionValue = await AsyncStorage.getItem(Constants.offlineDataKeys.formQuestions)
            const parsedQuestions = JSON.parse(questionValue)

            const reIntegrationTypes = await AsyncStorage.getItem(Constants.offlineDataKeys.reIntegrationTypes)
            const parsedReIntegrationTypes = JSON.parse(reIntegrationTypes)

            const visitTypes = await AsyncStorage.getItem(Constants.offlineDataKeys.visitTypes)
            const parsedVisitTypes = JSON.parse(visitTypes)

            setResult(Constants.createResponse(Constants.offlineOperations.getFormData, {
                domains: parsedDomains,
                data: parsedQuestions,
                reIntegrationTypes: parsedReIntegrationTypes,
                visitTypes: parsedVisitTypes
            }
            ))
        } catch (err) {
            //console.log("Offline Handler: Get FormData Error >>", err)
        }
    }

    const fetchCaseList = async () => {
        const defaultPayload = {
            "needFullData": true,
            "orderByField": [
                ["id", "ASC"]
            ],
            "globalSearchQuery": ''
        }
        try {
            const data = await APIS.CaseList(defaultPayload);
            if (data && data.data && data.data.data) {
                let list = data.data.data
                await AsyncStorage.setItem(Constants.offlineDataKeys.caseList, list)
            }
        } catch (err) {
            console.error(err);
        }
    }
    //--------------------------------->||


    // Case List operations ||----->

    const performCaseTableAction = (params) => {
        try {
            const operation = _.get(params, "operationKey")
            switch (operation) {
                case Constants.offlineOperations.fetchCaseList:
                    fetchCaseList()
                    return
                case Constants.offlineOperations.saveCaseList:
                    saveCaseListToDB(params.data)
                    return
                case Constants.offlineOperations.getCaseList:
                    getCaseListFromDB(params)
                    return
                case Constants.offlineOperations.downloadData:
                    if (continueOperation) {
                        downloadCaseList(params)
                    }
                    return
            }
        } catch (err) {
            console.log('Offline handler : performCaseTableActionError >>', err)
        }
    }

    const downloadCaseList = async (params) => {
        try {
            await dbInstance.transaction(tx => {
                tx.executeSql(`DELETE FROM ${DbConstants.caseListTable.tableName}`)
            })

            const defaultPayload = {
                "needFullData": true,
                "orderByField": [
                    ["id", "ASC"]
                ],
                "globalSearchQuery": ''
            }
            let list = []
            if (continueOperation) {
                const data = await APIS.CaseList(defaultPayload)
                if (data && data.data && data.data.data) {
                    list = data.data.data
                    saveCaseListToDB(list)
                }
            }

            params.caseList = list
            checkCaseDetailsDB(params)
        } catch (error) {
            console.log('downloadCaseListError', error)
        }
    }

    const saveCaseListToDB = (caseList) => {

        dbInstance.transaction(tx => {
            tx.executeSql(`DELETE FROM ${DbConstants.caseListTable.tableName}`)

            const insertQuery = `INSERT INTO ${DbConstants.caseListTable.tableName} (${DbConstants.caseListTable.columns.caseId.columnName},
                ${DbConstants.caseListTable.columns.htChildId.columnName}, 
                ${DbConstants.caseListTable.columns.htUserId.columnName}, 
                ${DbConstants.caseListTable.columns.caseStatus.columnName}, 
                ${DbConstants.caseListTable.columns.childBirthDate.columnName}, 
                ${DbConstants.caseListTable.columns.childFirstName.columnName}, 
                ${DbConstants.caseListTable.columns.childLastName.columnName}, 
                ${DbConstants.caseListTable.columns.childGender.columnName},
                ${DbConstants.caseListTable.columns.childId.columnName}, 
                ${DbConstants.caseListTable.columns.createdAt.columnName}, 
                ${DbConstants.caseListTable.columns.displayText.columnName}, 
                ${DbConstants.caseListTable.columns.endDate.columnName}, 
                ${DbConstants.caseListTable.columns.id.columnName}, 
                ${DbConstants.caseListTable.columns.isActive.columnName}, 
                ${DbConstants.caseListTable.columns.numberOfAssessments.columnName},
                ${DbConstants.caseListTable.columns.startDate.columnName}, 
                ${DbConstants.caseListTable.columns.userFirstName.columnName}, 
                ${DbConstants.caseListTable.columns.userLastName.columnName},
                ${DbConstants.caseListTable.columns.fileUrl.columnName},
                ${DbConstants.caseListTable.columns.lastReportedDate.columnName},
                ${DbConstants.caseListTable.columns.city.columnName},
                ${DbConstants.caseListTable.columns.district.columnName},
                ${DbConstants.caseListTable.columns.state.columnName},
                ${DbConstants.caseListTable.columns.country.columnName}
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`

            caseList.forEach((caseItem) => {
                tx.executeSql(insertQuery, [
                    caseItem.caseid,
                    caseItem.HTChildId,
                    caseItem.HTUserId,
                    caseItem.caseStatus,
                    caseItem.childBirthDate,
                    caseItem.childFirstName,
                    caseItem.childLastName,
                    caseItem.childGender,
                    caseItem.childid,
                    caseItem.createdAt,
                    caseItem.dispplytext,
                    caseItem.endDate,
                    caseItem.id,
                    caseItem.isActive ? 1 : 0,
                    caseItem.numberOfAssessments,
                    caseItem.startDate,
                    caseItem.userFirstName,
                    caseItem.userLastName,
                    caseItem.fileUrl,
                    caseItem.lastReportedDate,
                    caseItem.city,
                    caseItem.district,
                    caseItem.state,
                    caseItem.country
                ], (unused, result) => {
                    // Case saved
                })
            })

        })
    }

    const checkCaseListDB = (params) => {
        dbInstance.transaction(tx => {
            tx.executeSql(
                `SELECT name FROM sqlite_master WHERE type='table' AND name='${DbConstants.caseListTable.tableName}';`,
                [], (unused, { rows }) => {
                    if (rows.length !== 0) {
                        performCaseTableAction(params)
                    } else {
                        createTableAndContinueCaseListOperation(params)
                    }
                }, (error) => {

                })
        })
    }

    const createTableAndContinueCaseListOperation = (params) => {
        const tableName = DbConstants.caseListTable.tableName;
        droppingTable(tableName);
        const createTableScript = `CREATE TABLE IF NOT EXISTS ${DbConstants.caseListTable.tableName} (${DbConstants.caseListTable.columns.id.columnName} ${DbConstants.caseListTable.columns.id.type} PRIMARY KEY, 
            ${DbConstants.caseListTable.columns.htChildId.columnName} ${DbConstants.caseListTable.columns.htChildId.type}, 
            ${DbConstants.caseListTable.columns.htUserId.columnName} ${DbConstants.caseListTable.columns.htUserId.type}, 
            ${DbConstants.caseListTable.columns.caseStatus.columnName} ${DbConstants.caseListTable.columns.caseStatus.type}, 
            ${DbConstants.caseListTable.columns.childBirthDate.columnName} ${DbConstants.caseListTable.columns.childBirthDate.type}, 
            ${DbConstants.caseListTable.columns.childFirstName.columnName} ${DbConstants.caseListTable.columns.childFirstName.type}, 
            ${DbConstants.caseListTable.columns.childLastName.columnName} ${DbConstants.caseListTable.columns.childLastName.type}, 
            ${DbConstants.caseListTable.columns.childGender.columnName} ${DbConstants.caseListTable.columns.childGender.type},
            ${DbConstants.caseListTable.columns.childId.columnName} ${DbConstants.caseListTable.columns.childId.type}, 
            ${DbConstants.caseListTable.columns.createdAt.columnName} ${DbConstants.caseListTable.columns.createdAt.type}, 
            ${DbConstants.caseListTable.columns.displayText.columnName} ${DbConstants.caseListTable.columns.displayText.type}, 
            ${DbConstants.caseListTable.columns.endDate.columnName} ${DbConstants.caseListTable.columns.endDate.type}, 
            ${DbConstants.caseListTable.columns.caseId.columnName} ${DbConstants.caseListTable.columns.caseId.type}, 
            ${DbConstants.caseListTable.columns.isActive.columnName} ${DbConstants.caseListTable.columns.isActive.type} NOT NULL CHECK (${DbConstants.caseListTable.columns.isActive.columnName} IN (0, 1)), 
            ${DbConstants.caseListTable.columns.numberOfAssessments.columnName} ${DbConstants.caseListTable.columns.numberOfAssessments.type},
            ${DbConstants.caseListTable.columns.startDate.columnName} ${DbConstants.caseListTable.columns.startDate.type}, 
            ${DbConstants.caseListTable.columns.userFirstName.columnName} ${DbConstants.caseListTable.columns.userFirstName.type}, 
            ${DbConstants.caseListTable.columns.userLastName.columnName} ${DbConstants.caseListTable.columns.userLastName.type},
            ${DbConstants.caseListTable.columns.fileUrl.columnName} ${DbConstants.caseListTable.columns.fileUrl.type},
            ${DbConstants.caseListTable.columns.lastReportedDate.columnName} ${DbConstants.caseListTable.columns.lastReportedDate.type},
            ${DbConstants.caseListTable.columns.city.columnName} ${DbConstants.caseListTable.columns.city.type},
            ${DbConstants.caseListTable.columns.district.columnName} ${DbConstants.caseListTable.columns.district.type},
            ${DbConstants.caseListTable.columns.state.columnName} ${DbConstants.caseListTable.columns.state.type},
            ${DbConstants.caseListTable.columns.country.columnName} ${DbConstants.caseListTable.columns.country.type}            
            );`
        dbInstance.transaction(tx => {
            tx.executeSql(createTableScript, [], () => {
                performCaseTableAction(params)
            })
        })
    }

    const getCaseListFromDB = (params) => {
        let fetchQuery = `SELECT * FROM ${DbConstants.caseListTable.tableName} ${params.globalSearchQuery && params.globalSearchQuery.length > 0 ? `WHERE 
        ${DbConstants.caseListTable.columns.childFirstName.columnName} LIKE "%${params.globalSearchQuery}%" or
         ${DbConstants.caseListTable.columns.childLastName.columnName} LIKE "%${params.globalSearchQuery}%" or 
         ${DbConstants.caseListTable.columns.userFirstName.columnName} LIKE "%${params.globalSearchQuery}%" or
         ${DbConstants.caseListTable.columns.userLastName.columnName} LIKE "%${params.globalSearchQuery}%" or 
         ${DbConstants.caseListTable.columns.caseId.columnName} LIKE "%CASE-${params.globalSearchQuery}%" or
         REPLACE(${DbConstants.caseListTable.columns.childFirstName.columnName}, ' ', '') || 
         REPLACE(${DbConstants.caseListTable.columns.childLastName.columnName}, ' ', '') LIKE "${params.globalSearchQuery}%" ` : ''}`
        params.orderByField.forEach((order, index) => {
            fetchQuery = `${fetchQuery} ${index === 0 ? 'ORDER BY' : ''} ${order[0]} ${order[1]}${index > 0 ? ', ' : ';'}`
        })
        dbInstance.transaction(tx => {
            tx.executeSql(fetchQuery, [], (unused, { rows }) => {

                const totalRecords = rows.length;
                if (totalRecords > 0) {
                    let caseList = [];
                    for (let i = 0; i < totalRecords; ++i) {
                        const caseItem = rows.item(i);
                        caseList.push({
                            HTChildId: _.get(caseItem, DbConstants.caseListTable.columns.htChildId.columnName),
                            HTUserId: _.get(caseItem, DbConstants.caseListTable.columns.htUserId.columnName),
                            caseStatus: _.get(caseItem, DbConstants.caseListTable.columns.caseStatus.columnName),
                            caseid: _.get(caseItem, DbConstants.caseListTable.columns.caseId.columnName),
                            childBirthDate: _.get(caseItem, DbConstants.caseListTable.columns.childBirthDate.columnName),
                            childFirstName: _.get(caseItem, DbConstants.caseListTable.columns.childFirstName.columnName),
                            childGender: _.get(caseItem, DbConstants.caseListTable.columns.childGender.columnName),
                            childLastName: _.get(caseItem, DbConstants.caseListTable.columns.childLastName.columnName),
                            childid: _.get(caseItem, DbConstants.caseListTable.columns.childId.columnName),
                            createdAt: _.get(caseItem, DbConstants.caseListTable.columns.createdAt.columnName),
                            dispplytext: _.get(caseItem, DbConstants.caseListTable.columns.displayText.columnName),
                            endDate: _.get(caseItem, DbConstants.caseListTable.columns.endDate.columnName),
                            id: _.get(caseItem, DbConstants.caseListTable.columns.id.columnName),
                            isActive: (parseInt(_.get(caseItem, DbConstants.caseListTable.columns.isActive.columnName), 10) === 1),
                            numberOfAssessments: _.get(caseItem, DbConstants.caseListTable.columns.numberOfAssessments.columnName),
                            startDate: _.get(caseItem, DbConstants.caseListTable.columns.startDate.columnName),
                            userFirstName: _.get(caseItem, DbConstants.caseListTable.columns.userFirstName.columnName),
                            userLastName: _.get(caseItem, DbConstants.caseListTable.columns.userLastName.columnName),
                            fileUrl: _.get(caseItem, DbConstants.caseListTable.columns.fileUrl.columnName),
                            lastReportedDate: _.get(caseItem, DbConstants.caseListTable.columns.lastReportedDate.columnName),
                            city: _.get(caseItem, DbConstants.caseListTable.columns.city.columnName),
                            district: _.get(caseItem, DbConstants.caseListTable.columns.district.columnName),
                            state: _.get(caseItem, DbConstants.caseListTable.columns.state.columnName),
                            country: _.get(caseItem, DbConstants.caseListTable.columns.country.columnName)
                        })
                    }
                    setResult(Constants.createResponse(Constants.offlineOperations.getCaseList, caseList))
                } else {
                    setResult(Constants.createResponse(Constants.offlineOperations.getCaseList, []))
                }
            })
        })
    }

    // ---------------------->||


    //------------------------->Case Details

    const performCaseDetailsAction = (params) => {
        try {
            const operation = _.get(params, "operationKey")
            switch (operation) {
                case Constants.offlineOperations.saveCaseDetail:
                    saveCaseDetail(params.data)
                    return
                case Constants.offlineOperations.getCaseDetail:
                    getCaseDetail(params.data)
                    return
                case Constants.offlineOperations.downloadData:
                    downloadCaseDetails(params)
                    return
            }
        } catch (err) {
            console.log('performCaseDetailsActionError', err)
        }
    }

    const downloadCaseDetails = ({ caseList }) => {
        dbInstance.transaction(async (tx) => {
            tx.executeSql(`DELETE FROM ${DbConstants.caseDetailsTable.tableName}`)
            const ids = caseList.map((item) => item.id)
            if (ids.length > 0) {
                const data = await APIS.CaseDetailsDownload([...new Set(ids)]);
                if (data.data.data !== undefined) {
                    const listData = data.data.data
                    let totalData = listData.length
                    let i = 0
                    while (i < totalData) {
                        const caseDetail = listData[i]
                        saveCaseDetail(caseDetail)
                        i++
                    }
                }
            }

            setResult(Constants.createResponse(Constants.offlineOperations.downloadData, 'success'))
        })
    }

    const saveCaseDetail = (caseItem) => {
        dbInstance.transaction(tx => {
            tx.executeSql(insertCaseDetailScript, [
                caseItem.id,
                caseItem.HTChildId,
                caseItem.caseStatus,
                caseItem.isActive ? 1 : 0,
                caseItem.numberOfAssessments,
                caseItem.userFirstName,
                caseItem.userLastName,
                caseItem.childFirstName,
                caseItem.childLastName,
                caseItem.childGender,
                caseItem.childBirthDate,
                caseItem.dispplytext,
                caseItem.lastAssesmentDate,
                caseItem.previousScore,
                caseItem.caseId
            ], (unused, result) => {
                // Case Detail saved
            })
        })
    }

    const getCaseDetail = (id) => {
        let fetchQuery = `SELECT * FROM ${DbConstants.caseDetailsTable.tableName} WHERE ${DbConstants.caseDetailsTable.columns.id.columnName} = ? LIMIT 1`
        dbInstance.transaction(tx => {
            tx.executeSql(fetchQuery, [id], (unused, { rows }) => {
                if (rows.length > 0) {
                    setResult(Constants.createResponse(Constants.offlineOperations.getCaseDetail, rows.item(0)))
                }
            })
        })
    }

    const checkCaseDetailsDB = (params) => {
        dbInstance.transaction(tx => {
            tx.executeSql(
                `SELECT name FROM sqlite_master WHERE type='table' AND name='${DbConstants.caseDetailsTable.tableName}';`,
                [], (unused, { rows }) => {
                    if (rows.length !== 0) {
                        performCaseDetailsAction(params)
                    } else {
                        createTableAndCaseDeatilsOperation(params)
                    }
                }, (error) => {

                })
        })
    }

    const createTableAndCaseDeatilsOperation = (params) => {
        const tableName = DbConstants.caseDetailsTable.tableName;
        droppingTable(tableName);
        const createTableScript = `CREATE TABLE IF NOT EXISTS ${DbConstants.caseDetailsTable.tableName} (
            ${DbConstants.caseDetailsTable.columns.id.columnName} ${DbConstants.caseDetailsTable.columns.id.type} PRIMARY KEY, 
            ${DbConstants.caseDetailsTable.columns.HTChildId.columnName} ${DbConstants.caseDetailsTable.columns.HTChildId.type}, 
            ${DbConstants.caseDetailsTable.columns.caseStatus.columnName} ${DbConstants.caseDetailsTable.columns.caseStatus.type}, 
            ${DbConstants.caseDetailsTable.columns.isActive.columnName} ${DbConstants.caseDetailsTable.columns.isActive.type} NOT NULL CHECK (${DbConstants.caseDetailsTable.columns.isActive.columnName} IN (0, 1)), 
            ${DbConstants.caseDetailsTable.columns.numberOfAssessments.columnName} ${DbConstants.caseDetailsTable.columns.numberOfAssessments.type}, 
            ${DbConstants.caseDetailsTable.columns.userFirstName.columnName} ${DbConstants.caseDetailsTable.columns.userFirstName.type}, 
            ${DbConstants.caseDetailsTable.columns.userLastName.columnName} ${DbConstants.caseDetailsTable.columns.userLastName.type}, 
            ${DbConstants.caseDetailsTable.columns.childFirstName.columnName} ${DbConstants.caseDetailsTable.columns.childFirstName.type}, 
            ${DbConstants.caseDetailsTable.columns.childLastName.columnName} ${DbConstants.caseDetailsTable.columns.childLastName.type}, 
            ${DbConstants.caseDetailsTable.columns.childGender.columnName} ${DbConstants.caseDetailsTable.columns.childGender.type}, 
            ${DbConstants.caseDetailsTable.columns.childBirthDate.columnName} ${DbConstants.caseDetailsTable.columns.childBirthDate.type}, 
            ${DbConstants.caseDetailsTable.columns.dispplytext.columnName} ${DbConstants.caseDetailsTable.columns.dispplytext.type}, 
            ${DbConstants.caseDetailsTable.columns.lastAssesmentDate.columnName} ${DbConstants.caseDetailsTable.columns.lastAssesmentDate.type}, 
            ${DbConstants.caseDetailsTable.columns.previousScore.columnName} ${DbConstants.caseDetailsTable.columns.previousScore.type},
            ${DbConstants.caseDetailsTable.columns.caseId.columnName} ${DbConstants.caseDetailsTable.columns.caseId.type}            
            );`
        dbInstance.transaction(tx => {
            tx.executeSql(createTableScript, [], () => {
                performCaseDetailsAction(params)
            })
        })
    }


    //------------------------------>||


    const calculateAssessmentScore = ({ questionAndChoices }) => {
        try {
            const calculatedDomainScores = []
            questionAndChoices.map((item) => {
                const totalsQuestions = item.questions.length
                const totalPossibleScore = totalsQuestions * Constants.defaultValues.highestScore
                const totalScore = item.questions.reduce((accu, { choiceDetails }) => choiceDetails.length > 0 ? choiceDetails.map((choice) => parseInt(choice.HTChoiceId, 10))[0] + accu : 0 + accu, 0)
                const totalScorePercentage = ((totalScore / totalPossibleScore) * 100).toFixed(1)
                calculatedDomainScores.push({
                    HTQuestionDomainId: item.HTQuestionDomainId,
                    highestScore: Constants.defaultValues.highestScore,
                    numderOfQuestions: totalsQuestions,
                    totalPossibleScore: totalPossibleScore,
                    totalScore: totalScore,
                    totalScoreInPercentage: totalScorePercentage,
                    totalScoreInPercentageAsString: `${totalScorePercentage}`
                })
            })

            const totalPossibleScore = calculatedDomainScores.reduce((accu, { totalPossibleScore }) => totalPossibleScore + accu, 0)
            const totalScore = calculatedDomainScores.reduce((accu, { totalScore }) => totalScore + accu, 0)
            const totalScoreInPercentage = ((totalScore / totalPossibleScore) * 100).toFixed(1)
            const totalScoreInPercentageAsString = `${totalScoreInPercentage}`

            const totalCalculatedScore = {
                questionDomains: calculatedDomainScores,
                totalPossibleScore: totalPossibleScore,
                totalScore: totalScore,
                totalScoreInPercentage: totalScoreInPercentage,
                totalScoreInPercentageAsString: totalScoreInPercentageAsString
            }

            setResult(Constants.createResponse(Constants.offlineOperations.calculateAssessmentScore, totalCalculatedScore))
        } catch (error) {
            setResult({})
        }
    }

    const calculateScore = ({ questionAndChoices }) => {
        try {
            const calculatedDomainScores = []
            questionAndChoices.map((item) => {
                const totalsQuestions = item.questions.length
                const totalPossibleScore = totalsQuestions * Constants.defaultValues.highestScore
                const totalScore = item.questions.reduce((accu, { choiceDetails }) => choiceDetails.length > 0 ? choiceDetails.map((choice) => parseInt(choice.HTChoiceId, 10))[0] + accu : 0 + accu, 0)
                const totalScorePercentage = ((totalScore / totalPossibleScore) * 100).toFixed(1)
                calculatedDomainScores.push({
                    HTQuestionDomainId: item.HTQuestionDomainId,
                    highestScore: Constants.defaultValues.highestScore,
                    numberOfQuestions: totalsQuestions,
                    totalPossibleScore: totalPossibleScore,
                    totalScore: totalScore,
                    totalScoreInPercentage: totalScorePercentage,
                    totalScoreInPercentageAsString: `${totalScorePercentage}`
                })
            })

            const totalPossibleScore = calculatedDomainScores.reduce((accu, { totalPossibleScore }) => totalPossibleScore + accu, 0)
            const totalScore = calculatedDomainScores.reduce((accu, { totalScore }) => totalScore + accu, 0)
            const totalScoreInPercentage = ((totalScore / totalPossibleScore) * 100).toFixed(1)
            const totalScoreInPercentageAsString = `${totalScoreInPercentage}`

            const totalCalculatedScore = {
                questionDomains: calculatedDomainScores,
                totalPossibleScore: totalPossibleScore,
                totalScore: totalScore,
                totalScoreInPercentage: totalScoreInPercentage,
                totalScoreInPercentageAsString: totalScoreInPercentageAsString
            }

            return totalCalculatedScore
        } catch (error) {
            return {}
        }
    }

    const contextValues = useMemo(() => ({
        operationResult: result,
        callOfflineOperation: doOperation,
        isAppOnline: isAppOnline,
        handleContinue: handleSetContinue
    }), [result, isAppOnline])

    return (
        <OfflineHandlerContext.Provider value={contextValues} {...props}>
            <View style={[styles.parent, props.style]}>
                {props.children}
            </View>
            <Portal>
                <Dialog dismissable={false} visible={showUserAlert}
                    style={{ borderRadius: 10 }}>
                    <Dialog.Title>{t('Upload:message:syncData')}</Dialog.Title>
                    <Dialog.Content>
                        <Paragraph>{t('Upload:message:syncMessage')}</Paragraph>
                    </Dialog.Content>
                    <Dialog.Actions>
                        <Button style={{
                            backgroundColor: colorPalette.primary.main,
                            alignContent: 'center',
                            width: 68
                        }}
                            labelStyle={{ color: 'white' }}
                            mode={'outlined'} onPress={() => {
                                setShowUserAlert(false)
                                navigation.navigate('AssessmentUpload', { forceUpload: true })
                            }}>{t('Common:label:ok')}</Button>
                    </Dialog.Actions>
                </Dialog>
            </Portal>
        </OfflineHandlerContext.Provider>
    )
}

const styles = StyleSheet.create({
    parent: {
        flex: 1
    }
})

export default OfflineOperationHandler