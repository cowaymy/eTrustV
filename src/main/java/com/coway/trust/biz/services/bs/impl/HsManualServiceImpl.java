package com.coway.trust.biz.services.bs.impl;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.MemberEventListController;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hsManualService")
public class HsManualServiceImpl extends EgovAbstractServiceImpl implements HsManualService {

	private static final Logger logger = LoggerFactory.getLogger(MemberEventListController.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;
	
	@Resource(name = "hsManualMapper")
	private HsManualMapper hsManualMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	
	@Override
	public List<EgovMap> selectHsManualList(Map<String, Object> params) {
		// TODO Auto-generated method stub
//		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		
		if(params.get("ManuaMyBSMonth") != null) {
				StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());
        //		while (str1.hasMoreElements()) { 
        ////	         String result = str1.nextElement().toString();  //공백으로 자를시 사용
        //	         String result = str1.nextToken("/");            //특정문자로 자를시 사용
        //	         System.out.println("결과 : " + result +", 사이즈 :"+result.length()); 
        //		}
        
        		
        		
        		for(int i =0; i <= 1 ; i++) {
        			str1.hasMoreElements();
        			String result = str1.nextToken("/");            //특정문자로 자를시 사용
        			
        			logger.debug("iiiii: {}", i);
        			
        			if(i==0){
        				params.put("myBSMonth", result);
        				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        			}else{
        				params.put("myBSYear", result);
        				logger.debug("myBSYear : {}", params.get("myBSYear"));
        			}
        		}		
			
		}
		
		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		logger.debug("saleOrdListSp : {}", params.get("saleOrdListSp"));
		logger.debug("ManualCustId : {}", params.get("ManualCustId"));
		
		return hsManualMapper.selectHsManualList(params);
	}

	
	
	@Override
	public List<EgovMap> selectHsAssiinlList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		StringTokenizer str1 = new StringTokenizer(params.get("myBSMonth").toString());
		
//		while (str1.hasMoreElements()) { 
////	         String result = str1.nextElement().toString();  //공백으로 자를시 사용
//	         String result = str1.nextToken("/");            //특정문자로 자를시 사용
//	         System.out.println("결과 : " + result +", 사이즈 :"+result.length()); 
//		}

		
		
		for(int i =0; i <= 1 ; i++) {
			str1.hasMoreElements();
			String result = str1.nextToken("/");            //특정문자로 자를시 사용
			
			logger.debug("iiiii: {}", i);
			
			if(i==0){
				params.put("myBSMonth", result);
				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
			}else{
				params.put("myBSYear", result);
				logger.debug("myBSYear : {}", params.get("myBSYear"));
			}
			
			
		}
		
		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		
		return hsManualMapper.selectHsAssiinlList(params);
	}
	
	
	
	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectBranchList(params);
	}

	@Override
	public List<EgovMap> selectCtList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectCtList(params);
	}


	@Override
	public List<EgovMap> getCdUpMemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 3);
		return hsManualMapper.getCdUpMemList(params);
	}

	
	@Override
	public List<EgovMap> getCdList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 4);
		return hsManualMapper.getCdUpMemList(params);
	}



	@Override
	public List<EgovMap> getCdList_1(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 3);
		return hsManualMapper.getCdList_1(params);
	}



	@Override
	public List<EgovMap> selectHsManualListPop(Map<String, Object> params) {
		// TODO Auto-generated method stub
        //		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        		
        		if(params.get("ManuaMyBSMonth") != null) {
        				StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());
                //		while (str1.hasMoreElements()) { 
                ////	         String result = str1.nextElement().toString();  //공백으로 자를시 사용
                //	         String result = str1.nextToken("/");            //특정문자로 자를시 사용
                //	         System.out.println("결과 : " + result +", 사이즈 :"+result.length()); 
                //		}
                
                		
                		
                		for(int i =0; i <= 1 ; i++) {
                			str1.hasMoreElements();
                			String result = str1.nextToken("/");            //특정문자로 자를시 사용
                			
                			logger.debug("iiiii: {}", i);
                			
                			if(i==0){
                				params.put("myBSMonth", result);
                				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
                			}else{
                				params.put("myBSYear", result);
                				logger.debug("myBSYear : {}", params.get("myBSYear"));
                			}
                		}		
        			
        		}
        		
        		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        		logger.debug("saleOrdListSp : {}", params.get("saleOrdListSp"));
        		logger.debug("ManualCustId : {}", params.get("ManualCustId"));
        		
        		return hsManualMapper.selectHsManualListPop(params);
	}

	
	
	public Boolean insertHsResult(Map<String, Object> params, List<Object> docType)  {

		Boolean success = false;
		
		String appId="";
		Map<String, Object> codeMap1 = new HashMap<String, Object>();
		Map<String, Object> MemApp = new HashMap<String, Object>();
    	

		
		for(int i=0; i< docType.size(); i++){
//		for(Object obj : docType){
			
			Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);
			
			int fomSalesOrdNo = Integer.parseInt((String)docSub.get("salesOrdNo"));
//			int nextSchId = (int) docSub.get("salesOrdNo");
			int nextSchId  = hsManualMapper.getNextSchdulId();
			String docNo= commonMapper.selectDocNo("10");
			
			docSub.put("no", docNo);
			docSub.put("schdulId", nextSchId);
			docSub.put("salesOrdId", docSub.get("salesOrdId"));
    		docSub.put("resultID", 0);
    		//hsResult.put("custId", (params.get("custId").toString()));
    		docSub.put("salesOrdNo", String.format("%08d", fomSalesOrdNo));
    		docSub.put("month", docSub.get("month"));
    		docSub.put("year",docSub.get("year"));
    		docSub.put("typeId", "438");
    		docSub.put("stus", docSub.get("stus"));
    		docSub.put("lok", "4");
    		docSub.put("lastSvc", "0");
    		docSub.put("codyId",docSub.get("codyId"));
    		docSub.put("creator", "1111");
    		docSub.put("created", new Date());

			
    		hsManualMapper.insertHsResult(docSub);
//    		hsManualMapper.insertHsResult((Map<String, Object>)obj);
		}
		success=true;
		//hsManualMapper.insertHsResult(MemApp);

		return success;
	}
	
	
	
	private boolean Save(boolean isfreepromo,Map<String, Object> params,SessionVO sessionVO) throws ParseException{
		
		String appId="";
		Map<String, Object> codeMap1 = new HashMap<String, Object>();
		Map<String, Object> MemApp = new HashMap<String, Object>();
    	
		hsManualMapper.insertHsResult(MemApp);
		
//		EgovMap hsResult = new EgovMap();
//    		
//    		hsResult.put("resultID", 0);
//    		//hsResult.put("custId", (params.get("custId").toString()));
//    		hsResult.put("salesOrdNo", (params.get("salesOrdNo")));
//    		hsResult.put("month", params.get("09"));
//    		hsResult.put("year", params.get("2017"));
//    		hsResult.put("typeId", "438");
//    		hsResult.put("codyId",params.get("codyId"));
//    		hsResult.put("creator", sessionVO.getUserId());
//    		hsResult.put("created", new Date());
		
    		
		insertHs(MemApp);
		 
		return true;
	}




	@Transactional
	private boolean insertHs(Map<String, Object> hsResult) throws ParseException{

		String appId="";
		Map<String, Object> codeMap1 = new HashMap<String, Object>();
		Map<String, Object> MemApp = new HashMap<String, Object>();
    	
		hsManualMapper.insertHsResult(MemApp);
		
		

    		
    		
//    		EgovMap entry = hsManualMapper.selectEntry(hsResult);
//    		logger.debug("entry : {}", entry);	
//    		maxIdValue.put("value", "resultId");
//    		maxId = hsManualMapper.selectMaxId(maxIdValue);
//    		logger.debug("maxId : {}", maxId);
//    		entry.put("hsResultId", maxId);
//    		entry.put("stusCodeId", hsResult.get("statusCodeId"));
//    		entry.put("updated",  hsResult.get("created"));
//    		entry.put("updator",  hsResult.get("creator"));
//    		hsManualMapper.updateInstallEntry(entry);
//    		if(hsResult.get("statusCodeId").toString().equals("21")){
//    			if(callEntry != null){
//    				hsManualMapper.insertCallEntry(callEntry);
//    				//callEntry에 max 값 구해서 CallResult에 저장
//    				maxIdValue.put("value", "callEntryId");
//    				maxId = hsManualMapper.selectMaxId(maxIdValue);
//    				callResult.put("callEntryId", maxId);
//    				
//    				hsManualMapper.insertCallResult(callResult);
//    				//callresult에 max값 구해서 callEntry에 업데이트
//    				maxIdValue.put("value", "callResultId");
//    				maxId = hsManualMapper.selectMaxId(maxIdValue);
//    				callEntry.put("resultId", maxId);
//    				maxIdValue.put("value", "resultId");
//    				maxId = hsManualMapper.selectMaxId(maxIdValue);
//    				callEntry.put("callEntryId", maxId);
//    				hsManualMapper.updateCallEntry(callEntry);
//    			}
//    			
//    			hsManualMapper.insertOrderLog(orderLog);
//    		}
		return true;
	}
	
	
	
	
	
	
}
