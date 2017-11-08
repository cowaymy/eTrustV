package com.coway.trust.biz.services.mlog.impl;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.logistics.returnusedparts.impl.ReturnUsedPartsMapper;
import com.coway.trust.biz.services.installation.impl.InstallationResultListMapper;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
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
	
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Resource(name = "installationResultListMapper")
	private InstallationResultListMapper installationResultListMapper;
	
	
	
	
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
		
		if (heartLogs.size() > 0) {
			//SVC0007D
			for (int i = 0; i < heartLogs.size(); i++) {
				insMap = heartLogs.get(i);
				
				insMap.put("bsResultId", seq);
				insMap.put("docNo", docNo);
				insMap.put("typeId", 306);

				//insert start >>>>
				//SVC0007D
				MSvcLogApiMapper.insertHsResultD(insMap);
				logger.info(" reqstno : {}", insMap);
			}
			
			String memId = MSvcLogApiMapper.getUseridToMemid(insMap);
			
			//baseInfo
			EgovMap hsAssiinlList = MSvcLogApiMapper.selectHsAssiinlList(insMap);
			insMap.put("salesOrdId", hsAssiinlList.get("salesOrdId"));
			insMap.put("schdulId", hsAssiinlList.get("schdulId"));
			insMap.put("memId", memId); //userid -> memcode
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
		
//		String sirimNo = params.get("hidStockIsSirim").toString() != "0" ? params.get("hidStockIsSirim").toString().toUpperCase() : "";
		String serialNo = params.get("serialNo").toString();
//		int failId = params.get("failReason") != null ? Integer.parseInt(params.get("failReason").toString()) : 0;
//		String nextCallDate = params.get("nextCallDate").toString();
//		boolean allowComm = params.get("checkCommission") != null ? true : false;
//		boolean inTradeIn = params.get("checkTrade")!= null ? true : false;
//		boolean reqSms = params.get("reqSms") != null ? true : false;
//		String refNo1 = params.get("refNo1").toString();
//		String refNo2 = params.get("refNo2").toString();
//		String nextDateCall = (String) params.get("nextCallDate");
//		int statusId =  Integer.parseInt(params.get("installStatus").toString());

		//api setting 
//		List<EgovMap> failReason = installationResultListMapper.selectFailReason(params);
//		params.put("installEntryId", params.get("serviceNo"));
		
//		EgovMap callType = installationResultListMapper.selectCallType(params);
		EgovMap installResult = MSvcLogApiMapper.getInstallResultByInstallEntryID(params);
		String usrId = MSvcLogApiMapper.getUseridToMemid(params);
//		EgovMap stock = installationResultListMapper.getStockInCTIDByInstallEntryIDForInstallationView(installResult);
//		EgovMap sirimLoc = installationResultListMapper.getSirimLocByInstallEntryID(installResult);
//		EgovMap orderInfo = null;
		
//		EgovMap customerInfo = installationResultListMapper.getcustomerInfo(orderInfo == null ?installResult.get("custId") :  orderInfo.get("custId"));
//		EgovMap customerContractInfo = installationResultListMapper.getCustomerContractInfo(customerInfo);
//		EgovMap installation = installationResultListMapper.getInstallationBySalesOrderID(installResult);
//		EgovMap installationContract = installationResultListMapper.getInstallContactByContactID(installation);
//		EgovMap salseOrder = installationResultListMapper.getSalesOrderMBySalesOrderID(installResult);
//		EgovMap hpMember= installationResultListMapper.getMemberFullDetailsByMemberIDCode(salseOrder);
		
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
		
		resultValue.put("value", "Completed");
		resultValue.put("installEntryNo", installResult.get("installEntryId"));
//		resultValue.put("installEntryNo", params.get("hiddeninstallEntryNo"));
//		installResult.put("entryId", Integer.parseInt(params.get("hidEntryId").toString()));
//		installResult.put("failId", failId);
//		installResult.put("nextCallDate", nextCallDate);
//		installResult.put("allowComm", allowComm);
//		installResult.put("inTradeIn", inTradeIn);
//		installResult.put("reqSms", reqSms);
//		installResult.put("docRefNo1", refNo1);
//		installResult.put("docRefNo2", refNo2);		
		
		try {
			insertInstallation(statusId,installResult,callEntry,callResult,orderLog);
		} catch (ParseException e) {
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





	
}
