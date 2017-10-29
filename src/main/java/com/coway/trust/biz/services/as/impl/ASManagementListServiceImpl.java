package com.coway.trust.biz.services.as.impl;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.customer.impl.CustomerServiceImpl;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import oracle.sql.DATE;

@Service("ASManagementListService")
public class ASManagementListServiceImpl extends EgovAbstractServiceImpl implements ASManagementListService{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovAbstractServiceImpl.class);
	
	@Resource(name = "ASManagementListMapper")
	private ASManagementListMapper ASManagementListMapper;
	
	@Override
	public List<EgovMap> selectASManagementList(Map<String, Object> params) {
		return ASManagementListMapper.selectASManagementList(params);
	}
	
	@Override 
	public List<EgovMap> getASHistoryList(Map<String, Object> params) {
		return ASManagementListMapper.getASHistoryList(params);
	}
	  
	
	@Override
	public List<EgovMap> getASStockPrice(Map<String, Object> params) {
		return ASManagementListMapper.getASStockPrice(params);
	}
	
	@Override
	public List<EgovMap> getASFilterInfo(Map<String, Object> params) {
		return ASManagementListMapper.getASFilterInfo(params);
	}
	

	@Override
	public List<EgovMap> getASReasonCode(Map<String, Object> params) {
		return ASManagementListMapper.getASReasonCode(params);
	}

	@Override
	public List<EgovMap> getASMember(Map<String, Object> params) {
		return ASManagementListMapper.getASMember(params);
	}
	  
	@Override
	public List<EgovMap> getASReasonCode2(Map<String, Object> params) {
		return ASManagementListMapper.getASReasonCode2(params);
	}
	  
	
	@Override 
	public List<EgovMap> getBSHistoryList(Map<String, Object> params) {
		return ASManagementListMapper.getBSHistoryList(params); 
	}
	
	@Override 
	public List<EgovMap> getBrnchId(Map<String, Object> params) {
		return ASManagementListMapper.getBrnchId(params);
	}
	
	@Override 
	public List<EgovMap> getCallLog(Map<String, Object> params) {
		return ASManagementListMapper.getCallLog(params);
	}
	
	
	@Override 
	public List<EgovMap> getASRulstEditFilterInfo(Map<String, Object> params) {
		return ASManagementListMapper.getASRulstEditFilterInfo(params);
	}
	
	
	
	@Override 
	public List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params) {
		return ASManagementListMapper.getASRulstSVC0004DInfo(params);
	}
	
	
	@Override 
	public List<EgovMap> assignCtList(Map<String, Object> params) {
		return ASManagementListMapper.assignCtList(params);
	}
	
	@Override 
	public List<EgovMap> assignCtOrderList(Map<String, Object> params) {
		return ASManagementListMapper.assignCtOrderList(params);
	}
	
	
	
	@Override 
	public  EgovMap  getMemberBymemberID(Map<String, Object> params) {
		return ASManagementListMapper.getMemberBymemberID(params);
	}
	
	
	@Override
	public EgovMap selectOrderBasicInfo(Map<String, Object> params) {
		return ASManagementListMapper.selectOrderBasicInfo(params);
	}
	
	@Override
	public EgovMap  getASEntryDocNo(Map<String, Object> params) {
		return ASManagementListMapper.getASEntryDocNo(params);
	}
	
	@Override
	public EgovMap  getASEntryId(Map<String, Object> params) {
		return ASManagementListMapper.getASEntryId(params);
	}
	
	@Override
	public EgovMap  getResultASEntryId(Map<String, Object> params) {
		return ASManagementListMapper.getResultASEntryId(params);
	}
	
	
	@Override
	public int  addASRemark(Map<String, Object> params) {

		int result  =-1;
		result =ASManagementListMapper.insertAddCCR0007D(params);
		
		if(result  > 0){
			ASManagementListMapper.updateCCR0006D(params);
		}
		
		return result;
	}
	
	@Override
	public int  updateAssignCT(Map<String, Object> params) {
		List <EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
		int rtnValue  =-1;
		
		if (updateItemList.size() > 0) {  
			
			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
				rtnValue= ASManagementListMapper.updateAssignCT(updateMap) ;
			}
		}
		return rtnValue;
	} 
	
	  
	@Override
	public EgovMap  saveASEntry(Map<String, Object> params) {
		
		String AS_NO ="";
		
		params.put("DOCNO", "17");
		EgovMap  eMap = ASManagementListMapper.getASEntryDocNo(params); 
		
		EgovMap  seqMap = ASManagementListMapper.getASEntryId(params); 
		EgovMap	 ccrSeqMap = ASManagementListMapper.getCCR0006D_CALL_ENTRY_ID_SEQ(params);  
		
		params.put("AS_ID",   String.valueOf( seqMap.get("seq")).trim() );
		params.put("AS_NO",  String.valueOf( eMap.get("asno")).trim());
		params.put("AS_CALLLOG_ID",  String.valueOf( ccrSeqMap.get("seq")).trim());
		
		//서비스 마스터 
		int  a = ASManagementListMapper.insertSVC0001D(params);
		int  b =0;

		//콜로그생성 
		int  c6d  =ASManagementListMapper.insertCCR0006D(setCCR000Data(params));
		int  c7d  =ASManagementListMapper.insertCCR0007D(setCCR000Data(params));
		
		
		String PIC_NAME =String.valueOf(  params.get("PIC_NAME")) ;
		String PIC_CNTC  =String.valueOf( params.get("PIC_CNTC")) ;
		
		if(PIC_NAME.length()  > 0  ||  PIC_CNTC.length()  > 0  ){
			  b = ASManagementListMapper.insertSVC0003D(params);
		}
		
		
		//물류 호출   
	
		EgovMap em = new EgovMap();
		em.put("AS_NO", String.valueOf( eMap.get("asno")).trim());
		
		return em;
	} 
	
	public Map<String, Object>  setCCR000Data(Map<String, Object> params){
		
		   Map em = new HashMap();
    		  
			//CCR0006d
			em.put("CALL_ENTRY_ID", params.get("AS_CALLLOG_ID"));
    		em.put("SALES_ORD_ID", params.get("AS_SO_ID"));
    		em.put("TYPE_ID",  "339");
    		em.put("STUS_CODE_ID",  "40");
    		em.put("RESULT_ID",  "0");
    		em.put("DOC_ID",  params.get("AS_ID"));
    		em.put("USER_ID",  params.get("updator"));
    		em.put("IS_WAIT_FOR_CANCL",  "0");  
    		em.put("HAPY_CALLER_ID",  "0");
    				  
    		   
		    //CCR0007d
		    em.put("CALL_ENTRY_ID",  params.get("AS_CALLLOG_ID"));
    		em.put("CALL_STUS_ID",  "40");
    		em.put("CALL_FDBCK_ID", "0");
    		em.put("CALL_REM",  params.get("CALL_REM"));
    		em.put("CALL_HC_ID",  "0");
    		em.put("CALL_ROS_AMT",  "0");   
    		em.put("CALL_SMS", "0");
    		em.put("CALL_SMS_REM" ,"");
    		  
    		LOGGER.debug("============>");
    		LOGGER.debug("========================>"+ em.toString());
    		LOGGER.debug("============>");
		return 	em;
	}   
	
	

	@Override
	public EgovMap  updateASEntry(Map<String, Object> params) {
		
		String m="";  
		int a= ASManagementListMapper.updateSVC0001D(params);
				
		String PIC_NAME =String.valueOf(  params.get("PIC_NAME")) ;
		String PIC_CNTC  =String.valueOf( params.get("PIC_CNTC")) ;
		
		//if(PIC_NAME.length()  > 0  ||  PIC_CNTC.length()  > 0  ){
				ASManagementListMapper.updateSVC0003D(params);
		//}
		
		
		//물류 호출     
		if(a>0 ) m ="goodjob";
	
		EgovMap em = new EgovMap();
		em.put("result", m);
		
		return em;
	} 
	
	
	@Override
	public EgovMap  selASEntryView(Map<String, Object> params) {
		return ASManagementListMapper.selASEntryView(params);
	}
	
	
	
	@Override
	public boolean insertASNo(Map<String, Object> params,SessionVO sessionVO) {
		Map<String, Object> asEntryData = getSaveASEntry(params,sessionVO);
		//String remark
		return false;
	}
	
	
	
	
	

	@Override 
	public List<EgovMap> getASOrderInfo(Map<String, Object> params) {
		return ASManagementListMapper.getASOrderInfo(params);
	}
	

	@Override 
	public List<EgovMap> getASEvntsInfo(Map<String, Object> params) {
		return ASManagementListMapper.getASEvntsInfo(params);
	}
	

	@Override 
	public List<EgovMap> getASHistoryInfo(Map<String, Object> params) {
		return ASManagementListMapper.getASHistoryInfo(params);
	}
	
	
	@Override
	public EgovMap  asResult_insert(Map<String, Object> params) {
	
		String m ="";
		int a =-1;
		
		params.put("DOCNO", "21");
		EgovMap  eMap = ASManagementListMapper.getASEntryDocNo(params); 		
		EgovMap  seqMap = ASManagementListMapper.getResultASEntryId(params); 
		
		//EgovMap	 ccrSeqMap = ASManagementListMapper.getCCR0006D_CALL_ENTRY_ID_SEQ(params);  
		
		//String CALL_ENTRY_ID  = String.valueOf(ccrSeqMap.get("seq"));
		String AS_RESULT_ID    = String.valueOf(seqMap.get("seq"));
		  
		
		LinkedHashMap  svc0004dmap = (LinkedHashMap)  params.get("asResultM");
		svc0004dmap.put("AS_RESULT_ID", AS_RESULT_ID);
		svc0004dmap.put("AS_RESULT_NO", String.valueOf(eMap.get("asno")));
		//svc0004dmap.put("CALL_ENTRY_ID " ,CALL_ENTRY_ID);
		
		svc0004dmap.put("updator",params.get("updator"));
		
		
		List <EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		  
		
		int c=  ASManagementListMapper.insertSVC0004D(svc0004dmap);  
		
		//svc0001d 상태 업데이트 
		int b=  ASManagementListMapper.updateStateSVC0001D(svc0004dmap);
		
		   
		if(c >0){  

				int r=0;
		    	if (addItemList.size() > 0) {  
					for (int i = 0; i < addItemList.size(); i++) {
						
						Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
						Map<String, Object> iMap = new HashMap();
					    
						if(! "".equals(updateMap.get("filterDesc") )){
						
							String temp =(String)updateMap.get("filterDesc");
							String[] animals = temp.split("-"); 
							
							if(animals.length>0){
								iMap.put("ASR_ITM_PART_DESC",   animals[1] );
							}else{
								iMap.put("ASR_ITM_PART_DESC",   "");
							}
						}
						
						iMap.put("AS_RESULT_ID",			 AS_RESULT_ID);
						iMap.put("ASR_ITM_PART_ID",  	 updateMap.get("filterID") ); 
						iMap.put("ASR_ITM_PART_QTY",  updateMap.get("filterQty") ); 
						iMap.put("ASR_ITM_PART_PRC",   updateMap.get("filterPrice") ); 
						iMap.put("ASR_ITM_CHRG_AMT",  updateMap.get("filterTotal") ); 
						iMap.put("ASR_ITM_REM",   		 updateMap.get("filterRemark") ); 
						iMap.put("ASR_ITM_CRT_USER_ID", params.get("updator") );
						iMap.put("ASR_ITM_CHRG_FOC",   (String)updateMap.get("filterType")=="FOC" ? "1": "0"); 
						iMap.put("ASR_ITM_EXCHG_ID",    updateMap.get("filterExCode") ); 
						iMap.put("ASR_ITM_CLM",   		  		"0"); 
						iMap.put("ASR_ITM_TAX_CODE_ID",    "0" ); 
						iMap.put("ASR_ITM_TXS_AMT" , 			"0" ); 
						
						r = ASManagementListMapper.insertSVC0005D(iMap) ;
					}
				}
		} 

		
		
		/*
         * as result 
             1. select ==> ASStatusID 1 인것만 허용 
             2. GetDocNo(DocTypes.AS_RESULT) 채번 
             3. 데이터 생성 
               3.1 ASResultM 
               3.2 HappyCallM
               3.3 ASResultD 없는경우 기본 row만 생성 
                 3.3.1  ASResultD   loop  
            	    3.3.1.1    ASResultD  
            		3.3.1.2    InvStkRecordCard
               3.4 Billing (   asResultMas.ASTotalAmount > 0 )
            	 3.4.1 빌랭 GetDocNo 채번 
               3.5 CallEntries	 
		 * */
		
		//물류 호출
		/*
		Map procMap = new HashMap();
		procMap.put("P_ARR", value);
		procMap.put("RETYPE", value);
		procMap.put("P_TYPE", value);
		procMap.put("USERID", params.get("updator"));
		
		Map  reProcess =ASManagementListMapper.callSP_LOGISTIC_REQUEST(procMap);
	   	*/
		
		
		if(c>0 ) m = String.valueOf(eMap.get("asno"));
	
		EgovMap em = new EgovMap();
		em.put("AS_NO", m);
		//em.put("CALLSP_CODE" ,reProcess);
		
		
		
		return em;
	}
	
	

	@Override
	public EgovMap  asResult_update(Map<String, Object> params) {
	
		String m ="";
		int a =-1;
		
		params.put("DOCNO", "21");
		EgovMap  eMap = ASManagementListMapper.getASEntryDocNo(params); 		
		EgovMap  seqMap = ASManagementListMapper.getResultASEntryId(params); 
		
		String AS_RESULT_ID   = String.valueOf(seqMap.get("seq"));
		  
		
		params.put("AS_RESULT_ID",  AS_RESULT_ID);
		params.put("AS_RESULT_NO", String.valueOf(eMap.get("asno")));
		
		LinkedHashMap  svc0004dmap = (LinkedHashMap)  params.get("asResultM");
		svc0004dmap.put("AS_RESULT_ID", AS_RESULT_ID);
		svc0004dmap.put("AS_RESULT_NO", String.valueOf(eMap.get("asno")));
		svc0004dmap.put("updator",params.get("updator"));
		
		
		List <EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		  
		
		int c=  ASManagementListMapper.insertSVC0004D(svc0004dmap);  
		   
		if(c >0){  

				int r=0;
		    	if (addItemList.size() > 0) {  
					for (int i = 0; i < addItemList.size(); i++) {
						
						Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
						Map<String, Object> iMap = new HashMap();
					    
						if(! "".equals(updateMap.get("filterDesc") )){
						
							String temp =(String)updateMap.get("filterDesc");
							String[] animals = temp.split("-"); 
							
							if(animals.length>0){
								iMap.put("ASR_ITM_PART_DESC",   animals[1] );
							}else{
								iMap.put("ASR_ITM_PART_DESC",   "");
							}
						}
						
						iMap.put("AS_RESULT_ID",			 AS_RESULT_ID);
						iMap.put("ASR_ITM_PART_ID",  	 updateMap.get("filterID") ); 
						iMap.put("ASR_ITM_PART_QTY",  updateMap.get("filterQty") ); 
						iMap.put("ASR_ITM_PART_PRC",   updateMap.get("filterPrice") ); 
						iMap.put("ASR_ITM_CHRG_AMT",  updateMap.get("filterTotal") ); 
						iMap.put("ASR_ITM_REM",   		 updateMap.get("filterRemark") ); 
						iMap.put("ASR_ITM_CRT_USER_ID", params.get("updator") );
						iMap.put("ASR_ITM_CHRG_FOC",   (String)updateMap.get("filterType")=="FOC" ? "1": "0"); 
						iMap.put("ASR_ITM_EXCHG_ID",    updateMap.get("filterExCode") ); 
						iMap.put("ASR_ITM_CLM",   		  		"0"); 
						iMap.put("ASR_ITM_TAX_CODE_ID",    "0" ); 
						iMap.put("ASR_ITM_TXS_AMT" , 			"0" ); 
						
						r = ASManagementListMapper.insertSVC0005D(iMap) ;
					}
				}
		} 

		
		
		/*
         * as result 
             1. select ==> ASStatusID 1 인것만 허용 
             2. GetDocNo(DocTypes.AS_RESULT) 채번 
             3. 데이터 생성 
               3.1 ASResultM 
               3.2 HappyCallM
               3.3 ASResultD 없는경우 기본 row만 생성 
                 3.3.1  ASResultD   loop  
            	    3.3.1.1    ASResultD  
            		3.3.1.2    InvStkRecordCard
               3.4 Billing (   asResultMas.ASTotalAmount > 0 )
            	 3.4.1 빌랭 GetDocNo 채번 
               3.5 CallEntries	 
		 * */
		
		//물류 호출
		/*
		Map procMap = new HashMap();
		procMap.put("P_ARR", value);
		procMap.put("RETYPE", value);
		procMap.put("P_TYPE", value);
		procMap.put("USERID", params.get("updator"));
		
		Map  reProcess =ASManagementListMapper.callSP_LOGISTIC_REQUEST(procMap);
	   	*/
		
		
		if(c>0 ) m = String.valueOf(eMap.get("asno"));
	
		EgovMap em = new EgovMap();
		em.put("AS_NO", m);
		//em.put("CALLSP_CODE" ,reProcess);
		
		
		
		return em;
	}
	
	
	
	@Override
	public int  asResultBasic_update(Map<String, Object> params) {
	
		LinkedHashMap  svc0004dmap = (LinkedHashMap)  params.get("asResultM");
		int c=  ASManagementListMapper.updateBasicSVC0004D(svc0004dmap);  
		return c;    
	}
	
	
	private Map<String, Object> getSaveASEntry(Map<String, Object> params,SessionVO sessionVO){
		Map<String, Object> asEntry = new HashMap<String, Object>(); 
		asEntry.put("ASID", 0);
		asEntry.put("ASNo", "");
		asEntry.put("ASSOID", Integer.parseInt(params.get("hiddenOrderID").toString()));
		asEntry.put("ASMemID", Integer.parseInt(params.get("assignCT").toString()));
		asEntry.put("ASMemGroup", Integer.parseInt(params.get("CTGroup").toString()));
		asEntry.put("ASMemGroup", Integer.parseInt(params.get("CTGroup").toString()));
		
		if(CommonUtils.isNotEmpty(params.get("requestDate").toString())){
			asEntry.put("ASRequestDate", params.get("requestDate"));
		}else{
			asEntry.put("ASRequestDate", "01/01/1900");
		}
		
		if(CommonUtils.isNotEmpty(params.get("appDate").toString())){
			asEntry.put("ASAppoinmentDate", params.get("appDate"));
		}else{
			asEntry.put("ASAppoinmentDate", "01/01/1900");
		}
		asEntry.put("ASBranchID", Integer.parseInt(params.get("branchDSC").toString()));
		asEntry.put("ASMalfunctionID", Integer.parseInt(params.get("errorCode").toString()));
		asEntry.put("ASMalfunctionReasonID", Integer.parseInt(params.get("errorDesc").toString()));
		asEntry.put("ASRemarkRequestor", params.get("requestor").toString().trim());
		asEntry.put("ASRemarkRequestorContact", params.get("requestorCont").toString().trim());
		asEntry.put("ASCalllogID",  0);
		asEntry.put("ASStatusID",  1);
		asEntry.put("ASSMS",  false);
		asEntry.put("ASCreateBy",  sessionVO.getUserId());
		asEntry.put("ASCreateAt", new DATE());
		asEntry.put("ASUpdateBy",  sessionVO.getUserId());
		asEntry.put("ASUpdateAt", new DATE());
		asEntry.put("ASEntryIsSynch", false);
		asEntry.put("ASEntryIsEdit", false);
		asEntry.put("ASTypeID", 674);
		asEntry.put("ASRequestorTypeID", Integer.parseInt(params.get("requestor").toString()));
		asEntry.put("ASIsBSWithin30Days",params.get("checkBS") != null ? true:false);
		asEntry.put("ASAllowComm",params.get("checkComm") != null ? true:false);
		asEntry.put("ASRemarkAdditionalContact",params.get("additionalCont").toString().trim());
		asEntry.put("ASRemarkRequestorContactSMS",params.get("checkSms1") != null ? true:false);
		asEntry.put("ASRemarkAdditionalContactSMS",params.get("checkSms2") != null ? true:false);
		
		return asEntry;
	}
}
