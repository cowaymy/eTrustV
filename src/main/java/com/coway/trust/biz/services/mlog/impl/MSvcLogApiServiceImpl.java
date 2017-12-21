package com.coway.trust.biz.services.mlog.impl;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.services.sales.OutStandingResultVo;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.SmsMapper;
import com.coway.trust.biz.common.type.SMSTemplateType;
import com.coway.trust.biz.logistics.returnusedparts.impl.ReturnUsedPartsMapper;
import com.coway.trust.biz.services.as.impl.ASManagementListMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.impl.InstallationResultListMapper;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.model.SmsVO;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
//import com.coway.trust.biz.logistics.returnusedparts.impl;

@Service("MSvcLogApiService")
public class MSvcLogApiServiceImpl extends EgovAbstractServiceImpl implements MSvcLogApiService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "MSvcLogApiMapper")
	private MSvcLogApiMapper MSvcLogApiMapper;
	
	@Resource(name = "returnUsedPartsMapper")
	private ReturnUsedPartsMapper returnUsedPartsMapper;
	
	@Autowired
	private SmsMapper smsMapper;
	
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Resource(name = "installationResultListMapper")
	private InstallationResultListMapper installationResultListMapper;

	@Resource(name = "ASManagementListMapper")
	private ASManagementListMapper ASManagementListMapper;
	
	
	@Resource(name = "servicesLogisticsPFCMapper")
	private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;
	
	
	@Override
	public List<EgovMap> getHeartServiceJobList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getHeartServiceJobList(params);
	}

	@Override
	public List<EgovMap> getAfterServiceJobList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getAfterServiceJobList(params);
	}
	
	
	@Override
	public void saveHearLogs(List<Map<String, Object>> logs) {
		// TODO Auto-generated method stub
		for (Map<String, Object> log : logs) {
			MSvcLogApiMapper.insertHeatLog(log);
		}
		
	}

	@Override
	public void updateSuccessStatus(String transactionId) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.updateSuccessStatus(transactionId);
		
	}

	@Override
	public List<EgovMap> heartServiceParts(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.heartServiceParts(params);
	}

	@Override
	public List<EgovMap> afterServiceParts(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.afterServiceParts(params);
	}

	@Override
	public void resultRegistration(List<Map<String, Object>> heartLogs) {
		// TODO Auto-generated method stub

		
		Map<String, Object> insMap = null;
		int seq = MSvcLogApiMapper.getNextSvc006dSeq();
		String docNo= commonMapper.selectDocNo("11");
		String returnMsg = "";
		String memId ="";
		
		
		if (heartLogs.size() > 0) {
			//SVC0007D
			for (int i = 0; i < heartLogs.size(); i++) {
				insMap = heartLogs.get(i);
				memId = MSvcLogApiMapper.getUseridToMemid(insMap);
				
				insMap.put("bsResultId", seq);
				insMap.put("docNo", docNo);
				insMap.put("typeId", 306);
				insMap.put("memId", memId);
				
				

				//insert start >>>>
				//SVC0007D
				MSvcLogApiMapper.insertHsResultD(insMap);
				logger.info(" reqstno : {}", insMap);
			}
			

			
			//baseInfo
			EgovMap hsAssiinlList = MSvcLogApiMapper.selectHsAssiinlList(insMap);
			insMap.put("salesOrdId", hsAssiinlList.get("salesOrdId"));
			insMap.put("schdulId", hsAssiinlList.get("schdulId"));
//			insMap.put("memId", memId); //userid -> memcode
			insMap.put("failResnId", 0);

			if(hsAssiinlList.size()<0 ){
				returnMsg += "baseInfo empty!!"; 
			}
			
			//temp setting
			insMap.put("resultIsSync", '0');
			insMap.put("resultIsEdit", '0');
			insMap.put("resultStockUse", '1');
			insMap.put("resultIsCurr", '1');
			insMap.put("resultMtchId", '0');
			insMap.put("resultIsAdj", '0');

			insMap.put("resultStusCodeId", '4');
			insMap.put("renColctId", '0');
			
			
			//SVC0006D
			MSvcLogApiMapper.insertHsResultSVC0006D(insMap);

			EgovMap getHsResultMList = MSvcLogApiMapper.selectHSResultMList(insMap);
			 //BSScheduleM	
			int scheduleCnt = MSvcLogApiMapper.selectHSScheduleMCnt(insMap);
			
			if(scheduleCnt > 0 ) {
				EgovMap insertHsSchedule = new EgovMap();
//				insMap.put("resultStusCodeId", getHsResultMList.get("resultStusCodeId"));
//				insMap.put("actnMemId", getHsResultMList.get("codyId"));
				
				MSvcLogApiMapper.updateHsSVC0008D(insMap);
				
			}	
			
			
			//logs call
			logger.info(" serviceNo>>>>>> : {}", insMap.get("serviceNo").toString());
			returnUsedPartsMapper.returnPartsInsert(insMap.get("serviceNo").toString());

		}
	}

	
	
	
	@Override
	public void insertInstallationResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Map<String, Object> resultValue = new HashMap<String, Object>();
		Map<String, Object> callEntry = new HashMap<String, Object>();
		Map<String, Object> callResult = new HashMap<String, Object>();
		Map<String, Object> orderLog = new HashMap<String, Object>();
		
		String serialNo = params.get("serialNo").toString();

		//api setting 
		EgovMap installResult = MSvcLogApiMapper.getInstallResultByInstallEntryID(params);
		String usrId = MSvcLogApiMapper.getUseridToMemid(params);

		
		int statusId = '4'; //installStatus
		String sirimNo = params.get("sirimNo").toString();
		String userId = params.get("userId").toString();	//CTCode
		String curTime = new SimpleDateFormat("yyyyMMdd").format(new Date());
		
//		installResult.put("resultID", 0);
		installResult.put("resultID",0);
		installResult.put("entryId", installResult.get("installEntryId"));
		installResult.put("statusCodeId",  statusId);
		installResult.put("ctid", usrId);
		
//		installResult.put("installDate", params.get("installDate"));-> todate

		installResult.put("installDate", curTime);
		installResult.put("remark", params.get("resultRemark").toString().trim());
//		installResult.put("GLPost", 0);
//		installResult.put("creator", sessionVO.getUserId());
		installResult.put("created", new Date());
		installResult.put("sirimNo", sirimNo);
		installResult.put("serialNo", serialNo);
		installResult.put("updated", new Date());
		installResult.put("updator", usrId);
		installResult.put("adjAmount", 0);
		installResult.put("statusCodeId", 4);
		
		resultValue.put("value", "Completed");
		resultValue.put("installEntryNo", installResult.get("installEntryId"));


		params.put("installStatus",4);

		try {
			insertInstallation(statusId,installResult,callEntry,callResult,orderLog);
			
			//물류 호출   add by hgham
	        Map<String, Object>  logPram = null ;
			if(Integer.parseInt(params.get("installStatus").toString()) == 4 ){
	    
				/////////////////////////물류 호출//////////////////////
				logPram =new HashMap<String, Object>();
	            logPram.put("ORD_ID",    installResult.get("installEntryNo") );      // edit 2017-11-19 by hgham
	            logPram.put("RETYPE", "COMPLET");  
	            logPram.put("P_TYPE", "OD01");  
	            logPram.put("P_PRGNM", "INSCOM");  
	            logPram.put("USERID", usrId);   
	            
	            logger.debug("ORDERCALL 물류 호출 PRAM ===>"+ logPram.toString());
	            servicesLogisticsPFCMapper.install_Active_SP_LOGISTIC_REQUEST(logPram);
	            logger.debug("ORDERCALL 물류 호출 결과 ===>");
	            /////////////////////////물류 호출 END //////////////////////   	
	            
			} 
		}	catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	
	private boolean insertInstallation(int statusId,Map<String, Object> installResult,Map<String, Object> callEntry,Map<String, Object> callResult,Map<String, Object> orderLog) throws ParseException{
		
		String maxId = "";  //각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
		EgovMap maxIdValue = new EgovMap();
		MSvcLogApiMapper.insertInstallResult(installResult);
		EgovMap entry = installationResultListMapper.selectEntry(installResult);
		logger.debug("entry : {}", entry);	
		maxIdValue.put("value", "resultId");
		maxId = installationResultListMapper.selectMaxId(maxIdValue);
		logger.debug("maxId : {}", maxId);
		entry.put("installResultId", maxId);
		entry.put("stusCodeId", installResult.get("statusCodeId"));
		entry.put("updated",  installResult.get("created"));
		entry.put("updator",  installResult.get("creator"));
		installationResultListMapper.updateInstallEntry(entry);

		
		return true;
	}

	
		
	
	
	@Override
	public List<EgovMap> getInstallationJobList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getInstallationJobList(params);
	}

	@Override
	public List<EgovMap> getProductRetrunJobList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getProductRetrunJobList(params);
	}

	@Override
	public void saveAfterServiceLogs(List<Map<String, Object>> asTransLogs) {
		// TODO Auto-generated method stub
		for (Map<String, Object> asTransLog : asTransLogs) {
			MSvcLogApiMapper.insertAsResultLog(asTransLog);
		}
		
	}

	
	
	@Override
	public void saveInstallServiceLogs(Map<String, Object> params) {
		// TODO Auto-generated method stub

			MSvcLogApiMapper.insertInstallServiceLog(params);			

	}
	
	
	
	@Override
	public void updateSuccessASStatus(String transactionId) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.updateSuccessASStatus(transactionId);
	}

	@Override
	public void updateSuccessInstallStatus(String transactionId) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.updateSuccessInstallStatus(transactionId);
	}

	@Override
	public List<EgovMap> getRentalCustomerList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getRentalCustomerList(params);
	}

	@Override
	public EgovMap productReturnResult (Map<String, Object> params) {
		
		EgovMap  rMp = new EgovMap();
		
		
		//lev 1   =>  39m insert   결과 생성 
		//lev 2   =>  38m update 상태 
		//lev 3   =>  물류 return 
		//lev 4   =>   xxxx....
		
		logger.debug("insert_LOG0039D==>" +params.toString());
		int  log39cnt  = MSvcLogApiMapper.insert_LOG0039D(params);
		logger.debug("log39cnt==>" +log39cnt);
		
		
		if(log39cnt > 0){
			logger.debug("updateState_LOG0038D==>" +params.toString());
			int  log38cnt  = MSvcLogApiMapper.updateState_LOG0038D(params);
			logger.debug("log38cnt==>" +log39cnt);
		}
		
		
		   //물류 호출   add by hgham
        Map<String, Object>  logPram = null ;
		/////////////////////////물류 호출/////////////////////////
		logPram =new HashMap<String, Object>();
        logPram.put("ORD_ID",   params.get("salesOrderNo") );
        logPram.put("RETYPE",  "COMPLET");  
        logPram.put("P_TYPE",  "OD91");  
        logPram.put("P_PRGNM","LOG39");  
        logPram.put("USERID", MSvcLogApiMapper.getRetnCrtUserId(params));   
        
        
        logger.debug("productReturnResult 물류  PRAM ===>"+ logPram.toString());
		servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);  
		logger.debug("productReturnResult 물류  결과 ===>" +logPram.toString());
		logPram.put("P_RESULT_TYPE", "PR");
		logPram.put("P_RESULT_MSG", logPram.get("p1"));
        /////////////////////////물류 호출 END //////////////////////   	
		
		rMp.put("SP_MAP", logPram);
		
		return rMp;
		
	}

	
	@Override
	public void  setPRFailJobRequest (Map<String, Object> params) {
		
		
		//lev 1   =>  38m ffaild   
		//lev 2   =>  39m ffaild  
		
		logger.debug("setPRFailJobRequest==>" +params.toString());
		int  log38cnt  = MSvcLogApiMapper.updateFailed_LOG0038D(params);
		int  log39cnt  = MSvcLogApiMapper.insertFailed_LOG0039D(params);  
		logger.debug("log39cnt==>" +log39cnt);
	}
	
	
	
	
	
	@Override
	public void aSresultRegistration(List<Map<String, Object>> asTransLogs) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<EgovMap> serviceHistory(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.serviceHistory(params);
	}

	@Override
	public List<EgovMap> getAsFilterHistoryDList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getAsFilterHistoryDList(params);
	}

	@Override
	public List<EgovMap> getAsPartsHistoryDList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getAsPartsHistoryDList(params);
	}

	
	
	@Override
	public List<EgovMap> getHsFilterHistoryDList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getHsFilterHistoryDList(params);
	}

	@Override
	public List<EgovMap> getHsPartsHistoryDList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getHsPartsHistoryDList(params);
	}

	@Override
	public Map<String, Object> getAsBasic(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getAsBasic(params);
	}
	
	@Override
	public Map<String, Object> selectOutstandingResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.selectOutstandingResult(params);
	}
	
	@Override
	public List<EgovMap> selectOutstandingResultDetailList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.selectOutstandingResultDetailList(params);
	}

	
	

	
	@Override
	public void updateSuccessAsReStatus(String transactionId) {
		MSvcLogApiMapper.insertAsReServiceLog(transactionId);		
		
	}

	@Override
	public void updateSuccessHsReStatus(String transactionId) {
		MSvcLogApiMapper.insertHsReServiceLog(transactionId);		
		
	}

	@Override
	public void updateSuccessInsReStatus(String transactionId) {
		MSvcLogApiMapper.insertInsReServiceLog(transactionId);		
		
	}
	
	@Override
	public EgovMap getInstallResultByInstallEntryID(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getInstallResultByInstallEntryID(params);
	}

	@Override
	public String getUseridToMemid(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getUseridToMemid(params);
	}

	@Override
	public void savePrFailServiceLogs(Map<String, Object> params) {
		MSvcLogApiMapper.insertPrFailServiceLog(params);	
		
	}

	@Override
	public void saveInsFailServiceLogs(Map<String, Object> params) {
		MSvcLogApiMapper.insertInsFailServiceLog(params);	
		
	}

	@Override
	public void saveAsFailServiceLogs(Map<String, Object> params) {
		MSvcLogApiMapper.insertAsFailServiceLog(params);	
		
	}

	@Override
	public void saveHsFailServiceLogs(Map<String, Object> params) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.insertHsFailServiceLog(params);	
	}

	@Override
	public void savePrReServiceLogs(Map<String, Object> params) {
		MSvcLogApiMapper.insertPrReServiceLog(params);	
	}

	@Override
	public void saveInsReServiceLogs(Map<String, Object> params) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.insertInsReServiceLog(params);		
	}


	@Override
	public void saveHsReServiceLogs(Map<String, Object> params) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.insertHsReServiceLog(params);			
	}
	
	
	@Override
	public void saveAsReServiceLogs(Map<String, Object> params) {
		MSvcLogApiMapper.insertAsReServiceLog(params);			
	}

	@Override
	public Map<String, Object> getHsBasic(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getHsBasic(params);
	}

	@Override
	public void saveCanSMSServiceLogs(Map<String, Object> params) {
		MSvcLogApiMapper.insertCanSMSServiceLog(params);
	}

	@Override
	public void updateReApointResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.updateReApointResult(params);
	}

	@Override
	public EgovMap selectAsBasicInfo(Map<String, Object> params) {
		return MSvcLogApiMapper.selectAsBasicInfo(params);
	}

	@Override
	public void updateInsReAppointmentReturnResult(Map<String, Object> params) {
		 MSvcLogApiMapper.updateInsReAppointmentReturnResult(params);
		
	}

	@Override
	public void updateHsReAppointmentReturnResult(Map<String, Object> params) {
		 MSvcLogApiMapper.updateHsReAppointmentReturnResult(params);
		
	}

	@Override
	public void updatePrReAppointmentReturnResult(Map<String, Object> params) {
		 MSvcLogApiMapper.updateAppTm_LOG0038D(params);
		
	}

	@Override
	public void saveASRequestRegistrationLogs(Map<String, Object> params) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.insertASRequestRegistrationLogs(params);
	}

	@Override
	public void updateSuccessRequestRegiStatus(String transactionId) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.updateSuccessRequestRegiStatus(transactionId);
	}

	@Override
	public void insertASRequestRegist(Map<String, Object> params) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.insertASRequestRegist(params);
	}

	@Override
	public void insertHsFailJobResult(Map<String, Object> params) {
		MSvcLogApiMapper.insertHsFailJobResult(params);
		
	}

	@Override
	public void insertAsFailJobResult(Map<String, Object> params) {
		MSvcLogApiMapper.insertAsFailJobResult(params);
		
	}

	@Override
	public void insertInstallFailJobResult(Map<String, Object> params) {
		MSvcLogApiMapper.insertInstallFailJobResult(params);
		
	}

	
	@Override
	public List<EgovMap> getASRequestResultList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getASRequestResultList(params);
	}

	@Override
	public List<EgovMap> getASRequestCustList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		
		logger.info(" params>>>>>> : {}", params);
		return MSvcLogApiMapper.getASRequestCustList(params);
	}

	@Override
	public void upDateHsFailJobResultM(Map<String, Object> params) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.upDateHsFailJobResultM(params);
	}

	@Override
	public void upDatetAsFailJobResultM(Map<String, Object> params) {
		MSvcLogApiMapper.upDatetAsFailJobResultM(params);
		
	}

	@Override
	public void upDateInstallFailJobResultM(Map<String, Object> params) {
		MSvcLogApiMapper.upDateInstallFailJobResultM(params);
		
	}

	@Override
	public void insertCancelSMS(Map<String, Object> params) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.insertCancelSMS(params);
	}
	
	
	   
/*	@Override
	public void aSresultRegistration(List<Map<String, Object>> asTransLogs) {
		// TODO Auto-generated method stub
		
		Map<String, Object> insMap = null;
		int r=0;
		
		if(asTransLogs.size()>0){
			
			insMap.put("DOCNO", "21");
			EgovMap  eMap = ASManagementListMapper.getASEntryDocNo(insMap); 		
			EgovMap  seqMap = ASManagementListMapper.getResultASEntryId(insMap); 
			
			String AS_RESULT_ID    = String.valueOf(seqMap.get("seq"));
			
			insMap.put("AS_RESULT_ID", AS_RESULT_ID);
			insMap.put("AS_RESULT_NO", String.valueOf(eMap.get("asno")));
			insMap.put("updator",insMap.get("updator"));
			
			//master insert
			int c=  ASManagementListMapper.insertSVC0004D(insMap);  
			
			//svc0001d 상태 업데이트 
			int b=  ASManagementListMapper.updateStateSVC0001D(insMap);
			

			for (int i = 0; i < asTransLogs.size(); i++) {
				
				Map<String, Object> insMapDtail = asTransLogs.get(i);
				Map<String, Object> iMap = new HashMap();

				iMap.put("AS_RESULT_ID",			 AS_RESULT_ID);
				iMap.put("ASR_ITM_CLM",   		  		"0"); 
				iMap.put("ASR_ITM_TAX_CODE_ID",    "0" ); 
				iMap.put("ASR_ITM_TXS_AMT" , 			"0" ); 
				
				r = ASManagementListMapper.insertSVC0005D(iMap) ;
			}
		}
	}*/
	
	
	
	
	

	

	
}
