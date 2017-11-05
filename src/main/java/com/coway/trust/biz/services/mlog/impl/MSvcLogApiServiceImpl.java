package com.coway.trust.biz.services.mlog.impl;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("MSvcLogApiService")
public class MSvcLogApiServiceImpl extends EgovAbstractServiceImpl implements MSvcLogApiService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "MSvcLogApiMapper")
	private MSvcLogApiMapper MSvcLogApiMapper;
	
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;
	
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
		}
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
	public void updateSuccessASStatus(String transactionId) {
		// TODO Auto-generated method stub
		MSvcLogApiMapper.updateSuccessASStatus(transactionId);
	}

	@Override
	public void saveInstallServiceLogs(Map<String, Object> params) {
		// TODO Auto-generated method stub
		
	}

//	@Override
//	public void saveInstallServiceLogs(Map<String, Object> params) {
//		// TODO Auto-generated method stub
//		MSvcLogApiMapper.insertInstallServiceLogs(params);
//		
//	}

	
	
	
	
	
}
