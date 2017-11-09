package com.coway.trust.biz.services.as.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.customer.impl.CustomerServiceImpl;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
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
	
	@Resource(name = "posMapper")
	private PosMapper posMapper;
	
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
	public EgovMap  spFilterClaimCheck(Map<String, Object> params) {
		return ASManagementListMapper.spFilterClaimCheck(params);
	}
	
	
	
	@Override 
	public List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params) {
		return ASManagementListMapper.getASRulstSVC0004DInfo(params);
	}	
	
	

	@Override 
	public List<EgovMap> selectASDataInfo(Map<String, Object> params) {
		return ASManagementListMapper.selectASDataInfo(params);
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
	
	
	
	/**
	 * /svc0001d 상태 업데이트 
	 * @param params
	 * @return
	 */
	public int updateStateSVC0001D(Map<String, Object> params){
		//svc0001d 상태 업데이트 
		int b=  ASManagementListMapper.updateStateSVC0001D(params);
		return b;
	}
	
	
	
	/**
	 * SVC0004D insert
	 * @param params
	 * @return
	 */
	public int insertSVC0004D(Map<String, Object> params){
		LOGGER.debug("							===> insertSVC0004D  in");
	    //SVC0004D insert  상태 업데이트 
		LOGGER.debug("					insertSVC0004D {} ",params);
		
		int a=  ASManagementListMapper.insertSVC0004D(params);
		LOGGER.debug(" insertSVC0004D  결과 {}",a);
		LOGGER.debug("							===> insertSVC0004D  out ");
		
		return a;
	}
	
	

	/**
	 * SVC0005D insert
	 * @param params
	 * @return
	 */
	public int insertSVC0005D(List <EgovMap> addItemList , String AS_RESULT_ID  , String  UPDATOR ){
		
		LOGGER.debug("							===> insertSVC0005D  in ");
		int rtnValue =-1;
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
				iMap.put("ASR_ITM_CRT_USER_ID", UPDATOR );
				iMap.put("ASR_ITM_CHRG_FOC",   (String)updateMap.get("filterType")=="FOC" ? "1": "0"); 
				iMap.put("ASR_ITM_EXCHG_ID",    updateMap.get("filterExCode") ); 
				iMap.put("ASR_ITM_CLM",   		  		"0"); 
				iMap.put("ASR_ITM_TAX_CODE_ID",    "0" ); 
				iMap.put("ASR_ITM_TXS_AMT" , 			"0" ); 
				

				LOGGER.debug("					insertSVC0005D {} ",iMap);
				rtnValue = ASManagementListMapper.insertSVC0005D(iMap) ;
			}
		}
	   
		LOGGER.debug(" insertSVC0005D  결과 {}",rtnValue);
		LOGGER.debug("							===> insertSVC0005D  out ");
		return rtnValue;
	}
	
	
	
	//invoice
	public  int  setPay31dData(ArrayList<AsResultChargesViewVO>  vewList ,Map<String, Object> params){ 
			
		LOGGER.debug("									===> setPay31dData   in");		
		Map<String, Object>  pay31dMap = new HashMap();
		   
			double  totalCharges =0;
			double  totalTaxes =0;
			double  totalAmountDue =0; 

			if(vewList.size()>0){
				for(AsResultChargesViewVO vo :   vewList){
					
					totalCharges  		  +=   Double.parseDouble(vo.getSpareCharges());
					totalTaxes     		  +=   Double.parseDouble(vo.getSpareTaxes());
					totalAmountDue     +=   Double.parseDouble(vo.getSpareAmountDue());
				}
			}
			
			
			
    	   pay31dMap.put("taxInvcId",params.get("taxInvcId")); 
    	   pay31dMap.put("taxInvcRefNo",params.get("taxInvcRefNo")); 
    	   pay31dMap.put("taxInvcRefDt","");
    	   pay31dMap.put("taxInvcSvcNo",params.get("AS_RESULT_NO")); 
    	   pay31dMap.put("taxInvcType","118"); 
    	   pay31dMap.put("taxInvcCustName",params.get("TAX_INVOICE_CUST_NAME"));    
    	   pay31dMap.put("taxInvcCntcPerson",params.get("TAX_INVOICE_CONT_PERS")); 
    	   pay31dMap.put("taxInvcAddr1",""); 
    	   pay31dMap.put("taxInvcAddr2",""); 
    	   pay31dMap.put("taxInvcAddr3",""); 
    	   pay31dMap.put("taxInvcAddr4",""); 
    	   pay31dMap.put("taxInvcPostCode",""); 
    	   pay31dMap.put("taxInvcStateName",""); 
    	   pay31dMap.put("taxInvcCnty",""); 
    	   pay31dMap.put("taxInvcTaskId",""); 
    	   pay31dMap.put("taxInvcRem",""); 
    	   pay31dMap.put("taxInvcChrg", Double.toString(totalCharges)); 
    	   pay31dMap.put("taxInvcTxs",Double.toString(totalTaxes)); 
    	   pay31dMap.put("taxInvcAmtDue",Double.toString(totalAmountDue)); 
    	   pay31dMap.put("taxInvcCrtDt",new Date()); 
    	   pay31dMap.put("taxInvcCrtUserId",params.get("updator"));
    	   
    		int a=  ASManagementListMapper.insert_Pay0031d(pay31dMap);
    	   
		   LOGGER.debug(" pay31dMap {}",pay31dMap.toString());
		   LOGGER.debug(" pay31dMap  결과 {}",a);
		   LOGGER.debug("									===> setPay31dData   out");	
		   return a;
    	   
	}
	
	
	//invoiced
	public  int  setPay32dData(ArrayList<AsResultChargesViewVO>  vewList ,Map<String, Object> params){
		 	LOGGER.debug("									===> setPay32dData   out");	
    		Map<String, Object>  pay32dMap = new HashMap() ;
            
    		int a=  -1;
    			if(vewList.size()>0){
    				
    				for(AsResultChargesViewVO vo :   vewList){
    		    		
    		    	  // pay32dMap.put("invcItmId", params.get("invcItmId") );
					   pay32dMap.put("taxInvcId", params.get("taxInvcId"));
		    		   pay32dMap.put("invcItmType",vo.getAsChargesTypeId()); 
		    		   pay32dMap.put("invcItmOrdNo",params.get("AS_SO_ID") ); 
		    		   pay32dMap.put("invcItmPoNo",""  ); 
		    		   pay32dMap.put("invcItmCode", vo.getSparePartCode()); 
		    		   pay32dMap.put("invcItmDesc1", vo.getSparePartName()); 
		    		   pay32dMap.put("invcItmDesc2", ""); 
		    		   pay32dMap.put("invcItmSerialNo", ""); 
		    		   pay32dMap.put("invcItmQty", vo.getAsChargeQty()); 
		    		   pay32dMap.put("invcItmUnitPrc", ""); 
		    		   pay32dMap.put("invcItmGstRate", vo.getGstRate()); 
		    		   pay32dMap.put("invcItmGstTxs", vo.getSpareTaxes()); 
		    		   pay32dMap.put("invcItmChrg",vo.getSpareCharges() ); 
		    		   pay32dMap.put("invcItmAmtDue",vo.getSpareAmountDue() ); 
		    		   pay32dMap.put("invcItmAdd1", ""); 
		    		   pay32dMap.put("invcItmAdd2",""); 
		    		   pay32dMap.put("invcItmAdd3","" ); 
		    		   pay32dMap.put("invcItmAdd4", "" ); 
		    		   pay32dMap.put("invcItmPostCode","" ); 
		    		   pay32dMap.put("invcItmAreaName", ""); 
		    		   pay32dMap.put("invcItmStateName","" ); 
		    		   pay32dMap.put("invcItmCnty", ""); 
		    		   pay32dMap.put("invcItmInstallDt", ""); 
		    		   pay32dMap.put("invcItmRetnDt", "");
		    		   pay32dMap.put("invcItmBillRefNo","");
		    		   
		    		   LOGGER.debug(" pay32d {}",pay32dMap.toString());
		    		
		    		   a=  ASManagementListMapper.insert_Pay0032d(pay32dMap);
		    		   
		    		   LOGGER.debug(" pay32d  결과 {}",a);
		    		   LOGGER.debug("									===> setPay32dData   out");	
    				}
    			}
    			
    		return a;	
	}
	
	
	public  int  setPay16dPartData(ArrayList<AsResultChargesViewVO>  vewList ,Map<String, Object> params){
		  LOGGER.debug("									===> setPay16dPartData   in");	
		
		   	  Map<String, Object>  pay0016dMap = new HashMap() ;
		   	  
		     double partCharges = 0;
	         double partTaxes = 0;
	         double partAmountDue = 0;
			 
	        int a= -1;
	        
	     	if(vewList.size()>0){
				for(AsResultChargesViewVO vo :   vewList){
					 if(vo.getAsChargesTypeId().equals("1262")){
						partCharges  		+= Double.parseDouble((vo.getSpareCharges()));
						partTaxes     		+= Double.parseDouble((vo.getSpareTaxes()));
						partAmountDue    += Double.parseDouble((vo.getSpareAmountDue()));
					} 
				}
	     	}
        	
    	   pay0016dMap.put("accBillTaskId","0"); 
    	   pay0016dMap.put("accBillRefDt",new Date()); 
    	   pay0016dMap.put("accBillRefNo","1000"); 
    	   pay0016dMap.put("accBillOrdId",params.get("AS_SO_ID")); 
    	   pay0016dMap.put("accBillTypeId","1159"); 
    	   pay0016dMap.put("accBillModeId","1263"); 
    	   pay0016dMap.put("accBillSchdulId","0"); 
    	   pay0016dMap.put("accBillSchdulPriod","0");
    	   pay0016dMap.put("accBillAdjId","0");
    	   pay0016dMap.put("accBillSchdulAmt",Double.toString(partAmountDue)); 
    	   pay0016dMap.put("accBillAdjAmt","0"); 
    	   pay0016dMap.put("accBillTxsAmt",Double.toString(partTaxes)); 
    	   pay0016dMap.put("accBillNetAmt",Double.toString(partAmountDue)); 
    	   pay0016dMap.put("accBillStus","1"); 
    	   pay0016dMap.put("accBillRem",params.get("taxInvcRefNo")); 
    	   pay0016dMap.put("accBillCrtDt",new Date()); 
    	   pay0016dMap.put("accBillCrtUserId",params.get("updator")); 
    	   pay0016dMap.put("accBillGrpId","0"); 
    	   pay0016dMap.put("accBillTaxCodeId",params.get("TaxCode")); 
    	   pay0016dMap.put("accBillTaxRate",params.get("TaxRate")); 
    	   pay0016dMap.put("accBillAcctCnvr","0"); 
    	   pay0016dMap.put("accBillCntrctId","0");
    	   
	   
		   a= ASManagementListMapper.insert_Pay0016d(pay0016dMap);
    	   
    	   
		   LOGGER.debug(" setPay16dPartData {}",pay0016dMap.toString());
		   LOGGER.debug(" setPay16dPartData  결과 {}",a);
    	   LOGGER.debug("									===> setPay16dPartData   out");	
	
        return a;	
	}
	
	
	

	public  int  setPay16dLabourData(ArrayList<AsResultChargesViewVO>  vewList ,Map<String, Object> params){
		LOGGER.debug("									===> setPay16dLabourData   in");	
		   	  Map<String, Object>  pay0016dMap = new HashMap() ;
		   	  
		   	double labourCharges = 0;
			 double labourTaxes = 0;
	         double labourAmountDue = 0;
			 
	         
	     	if(vewList.size()>0){
				for(AsResultChargesViewVO vo :   vewList){
					if(vo.getAsChargesTypeId().equals("1261")){
						labourCharges  		+= Double.parseDouble((vo.getSpareCharges()));
						labourTaxes     		+= Double.parseDouble((vo.getSpareTaxes()));
						labourAmountDue     += Double.parseDouble((vo.getSpareAmountDue()));
					}
				}
	     	}
	     	
	     	int a= -1;	

       	   pay0016dMap.put("accBillTaskId","0"); 
       	   pay0016dMap.put("accBillRefDt",new Date()); 
       	   pay0016dMap.put("accBillRefNo","1000"); 
       	   pay0016dMap.put("accBillOrdId",params.get("AS_SO_ID")); 
       	   pay0016dMap.put("accBillTypeId","1159"); 
       	   pay0016dMap.put("accBillModeId","1264"); 
       	   pay0016dMap.put("accBillSchdulId","0"); 
       	   pay0016dMap.put("accBillSchdulPriod","0");
       	   pay0016dMap.put("accBillAdjId","0");
       	   pay0016dMap.put("accBillSchdulAmt",Double.toString(labourAmountDue)); 
       	   pay0016dMap.put("accBillAdjAmt","0"); 
       	   pay0016dMap.put("accBillTxsAmt",Double.toString(labourTaxes)); 
       	   pay0016dMap.put("accBillNetAmt",Double.toString(labourAmountDue)); 
       	   pay0016dMap.put("accBillStus","1"); 
       	   pay0016dMap.put("accBillRem",params.get("taxInvcRefNo") ); 
       	   pay0016dMap.put("accBillCrtDt",new Date()); 
       	   pay0016dMap.put("accBillCrtUserId",params.get("updator")); 
       	   pay0016dMap.put("accBillGrpId","0"); 
       	   pay0016dMap.put("accBillTaxCodeId","32"); 
       	   pay0016dMap.put("accBillTaxRate","6"); 
       	   pay0016dMap.put("accBillAcctCnvr","0"); 
       	   pay0016dMap.put("accBillCntrctId","0");
           	   
	   
		  a=  ASManagementListMapper.insert_Pay0016d(pay0016dMap);


		   LOGGER.debug(" setPay16dLabourData {}",pay0016dMap.toString());
		   LOGGER.debug(" setPay16dLabourData  결과 {}",a);
    	   LOGGER.debug("									===> setPay16dLabourData   out");	
          		return a;	
	}
	
	
	

	//AccBilling
	public  int  setPay0007dData(ArrayList<AsResultChargesViewVO>  vewList ,Map<String, Object> params , String  billIsPaid){
		
			  LOGGER.debug("									===> setPay0007dData   in");	
		
		   	  Map<String, Object>  pay0007dMap = new HashMap() ;
		   	  
		   	  //채번 
	    	  int billId		 = posMapper.getSeqPay0007D();

		      pay0007dMap.put("billId",Integer.toString(billId)); 
		      pay0007dMap.put("billTypeId","238"); 
		      pay0007dMap.put("billSoId",params.get("AS_SO_ID")); 
		      pay0007dMap.put("billMemId","0"); 
		      pay0007dMap.put("billAsId",params.get("AS_ENTRY_ID")); 
		      pay0007dMap.put("billPayTypeId",""); 
		      pay0007dMap.put("billNo",params.get("AS_RESULT_NO")); 
		      pay0007dMap.put("billMemShipNo",params.get("asBillNo"));  
		      pay0007dMap.put("billDt",new Date()); 
		      pay0007dMap.put("billAmt",params.get("AS_TOT_AMT")); 
		      pay0007dMap.put("billRem",""); 
		      pay0007dMap.put("billIsPaid",billIsPaid); 
		      pay0007dMap.put("billIsComm",params.get("AS_CMMS")); 
		      pay0007dMap.put("updUserId",params.get("updator")); 
		      pay0007dMap.put("updDt",new Date()); 
		      pay0007dMap.put("syncChk","0"); 
		      pay0007dMap.put("coursId","0"); 
		      pay0007dMap.put("stusId","1");
	
		      
		     int a=  ASManagementListMapper.insert_Pay0007d(pay0007dMap);
		      

			   LOGGER.debug(" pay0007dMap {}",pay0007dMap.toString());
			   LOGGER.debug(" pay0007dMap  결과 {}",a);
	    	   LOGGER.debug("									===> pay0007dMap   out");	

		      
          return a;	
	}


	//AccASLedger
	public  int  setPay0006dData(ArrayList<AsResultChargesViewVO>  vewList ,Map<String, Object> params ,String type ){
		 LOGGER.debug("									===> setPay0006dData   in");	
	   	  Map<String, Object>  pay0006dMap = new HashMap() ;
	   	  
    	   pay0006dMap.put("asId",params.get("AS_ENTRY_ID")); 
    	   pay0006dMap.put("asDocNo",params.get("AS_RESULT_NO")); 
    	   pay0006dMap.put("asLgDocTypeId","163"); 
    	   pay0006dMap.put("asLgDt",new Date()); 
    	   
    	   if("A".equals(type)){
    		   pay0006dMap.put("asLgAmt",params.get("AS_TOT_AMT")); 
    		   
    	   }else if("B".equals(type)){
    		   pay0006dMap.put("asLgAmt" , Double.parseDouble((String)params.get("AS_TOT_AMT"))  * -1 );
    		   
    	   }else if("C".equals(type)){
    		   pay0006dMap.put("asLgAmt" , Double.parseDouble((String)params.get("totalAASLeft"))  * -1); 
    		}
    	  
    	   pay0006dMap.put("asLgUpdUserId",params.get("updator")); 
    	   pay0006dMap.put("asLgUpdDt",new Date()); 
    	  // pay0006dMap.put("asSoNo","");   //AS_SO_ID  select 
    	   pay0006dMap.put("asResultNo",params.get("AS_RESULT_NO")); 
    	   pay0006dMap.put("asSoId",params.get("AS_SO_ID")); 
    	   pay0006dMap.put("asAdvPay","0"); 
    	   pay0006dMap.put("r01","0");
    	   
    	    int a=  ASManagementListMapper.insert_Pay0006d(pay0006dMap);
    	   

		   LOGGER.debug(" pay0006dMap {}",pay0006dMap.toString());
		   LOGGER.debug(" pay0006dMap  결과 {}",a);
		   LOGGER.debug("									===> pay0006dMap   out");	
    
    	      
        return a;	
    }
		
	
	
	public int updateSTATE_CCR0006D(Map<String, Object> params){
			LOGGER.debug("									===> updateSTATE_CCR0006D   in");	

			int a=  ASManagementListMapper.updateSTATE_CCR0006D(params);
			
		   LOGGER.debug(" updateSTATE_CCR0006D {}",params.toString());
		   LOGGER.debug(" updateSTATE_CCR0006D  결과 {}",a);
    	   LOGGER.debug("									===> updateSTATE_CCR0006D   out");	
		
		
		return  a;
	}
	
	
	
	public int setCCR0001DData(Map<String, Object> params){
		  LOGGER.debug("									===> setCCR0001DData   in");	
		
	   	  Map<String, Object>  ccr01dMap = new HashMap() ;

		   ccr01dMap.put("hcsoid",params.get("AS_SO_ID")); 
		   ccr01dMap.put("hcTypeNo",params.get("AS_NO"));
		   ccr01dMap.put("hcCallEntryId","0");  
		   ccr01dMap.put("hcTypeId","510");  
		   ccr01dMap.put("hcStusId","33");  
		   ccr01dMap.put("hcRem","");  
		   ccr01dMap.put("hcCommentTypeId","0");  
		   ccr01dMap.put("hcCommentGid","0");  
		   ccr01dMap.put("hcCommentSid","0");  
		   ccr01dMap.put("hcCommentDid","0");  
		   ccr01dMap.put("crtUserId",params.get("updator"));  
		   ccr01dMap.put("crtDt",new Date());  
		   ccr01dMap.put("updUserId",params.get("updator"));  
		   ccr01dMap.put("updDt",new Date());  
		   ccr01dMap.put("hcNoSvc","0");  
		   ccr01dMap.put("hcLok","0");  
		   ccr01dMap.put("hcClosId","0"); 
		   
		   LOGGER.debug(" setCCR0001DData {}",ccr01dMap.toString());
		  int a=  ASManagementListMapper.insert_Ccr0001d(ccr01dMap);
 
		
		LOGGER.debug(" setCCR0001DData  결과 {}",a);
  	    LOGGER.debug("									===> setCCR0001DData   out");	  
  	    
  	    return a;
	}
	
	
	
	public  boolean  geGST_CHK (Map<String, Object> params){
		boolean isgST =false;
		LOGGER.debug("									===> geGST_CHK   in");	
		
		EgovMap  gstChk = ASManagementListMapper.geGST_CHK(params);
		
		String gst = "1";
		
		if (null !=gstChk){
			gst =(String)gstChk.get("GST_CHK") ;
		}
		
		if("1".equals(gst)){
			isgST  =false;
		}else{
			isgST  =true;
		}
		
	    LOGGER.debug(" gstChk {}",params.toString());
	    LOGGER.debug(" isgST {}",isgST);
		LOGGER.debug("									===> geGST_CHK   out");	
		
		return isgST;
	
	}
		
	@Override
	public EgovMap  asResult_insert(Map<String, Object> params) {
		
     	LOGGER.debug("==========asResult_insert  Log  in================");

     	
	
		String m ="";
		
		params.put("DOCNO", "21");
		EgovMap  eMap = ASManagementListMapper.getASEntryDocNo(params); 		
		EgovMap  seqMap = ASManagementListMapper.getResultASEntryId(params); 
		
		
		String AS_RESULT_ID    = String.valueOf(seqMap.get("seq"));
		
		LOGGER.debug("			getASEntryDocNo===>AS_RESULT_ID["+AS_RESULT_ID+"]");
		
		
		
		ArrayList<AsResultChargesViewVO>  vewList = new ArrayList<AsResultChargesViewVO>();
		
		List <EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		LinkedHashMap  svc0004dmap = (LinkedHashMap)  params.get("asResultM");
		
		svc0004dmap.put("AS_RESULT_ID", AS_RESULT_ID);
		svc0004dmap.put("AS_RESULT_NO", String.valueOf(eMap.get("asno")));
		svc0004dmap.put("updator",params.get("updator"));
		  

		//HappyCallM
		this.setCCR0001DData(svc0004dmap);
		
		double AS_TOT_AMT =0;
		AS_TOT_AMT = Double.parseDouble((String)svc0004dmap.get("AS_TOT_AMT"));
		
		
		LOGGER.debug("				Logic 1===> AS_TOT_AMT["+AS_TOT_AMT+"]");
		if(AS_TOT_AMT > 0){
			
			//asBillNo 채번 
			params.put("DOCNO", "22");
			EgovMap  asBillDocNo = ASManagementListMapper.getASEntryDocNo(params); 		
			svc0004dmap.put("asBillNo", String.valueOf(asBillDocNo.get("asno")))	;
			
			LOGGER.debug("									===> asBillDocNo["+asBillDocNo+"]");
			
			
			//InvoiceNum 채번 
			params.put("DOCNO", "128");
			EgovMap  invoiceDocNo = ASManagementListMapper.getASEntryDocNo(params); 		
			svc0004dmap.put("taxInvcRefNo", String.valueOf(invoiceDocNo.get("asno")))	;
			
			LOGGER.debug("									===> invoiceDocNo["+invoiceDocNo+"]");
			
    		int taxInvcId		 = posMapper.getSeqPay0031D();
    		//int invcItmId      = posMapper.getSeqPay0032D();
    		svc0004dmap.put("taxInvcId", String.valueOf(taxInvcId));
    		//svc0004dmap.put("invcItmId", String.valueOf(invcItmId))	;
    		LOGGER.debug("									===> taxInvcId Pay0031D 채번 ["+taxInvcId+"]");						
    		
    		
    		//getLeftSUM
    		EgovMap  sumLeftMap  = ASManagementListMapper.geTtotalAASLeft(svc0004dmap);
    		LOGGER.debug("									===> sumLeftMap  select ["+sumLeftMap+"]");		
			
			
			  if(  Double.parseDouble((String)svc0004dmap.get("AS_WORKMNSH")) > 0 ){   //txtLabourCharge
				  
				    double txtLabourCharge  =  Double.parseDouble((String)svc0004dmap.get("AS_WORKMNSH"));
			        double t_SpareCharges = (txtLabourCharge *100/106);
					double t_SpareTaxes =    txtLabourCharge - t_SpareCharges ;
					
			     	LOGGER.debug("txtLabourCharge["+txtLabourCharge+"]");
			     	LOGGER.debug("t_SpareCharges===>["+t_SpareCharges+"]");
			     	LOGGER.debug("vewList  loop===>["+t_SpareTaxes+"]");

					 
					//setAsChargesTypeId 1261
					AsResultChargesViewVO vo_1261  =null;
					vo_1261 =  new AsResultChargesViewVO();
					vo_1261.setAsEntryId("");
					vo_1261.setAsChargesTypeId("1261");
					vo_1261.setAsChargeQty("1");
					vo_1261.setSparePartId("0");
					vo_1261.setSparePartCode((String)svc0004dmap.get("productCode"));
					vo_1261.setSparePartName((String)svc0004dmap.get("productName"));
					vo_1261.setSparePartSerial((String)svc0004dmap.get("serialNo"));
					vo_1261.setSpareCharges(Double.toString(t_SpareCharges) );   //
					vo_1261.setSpareTaxes(Double.toString(t_SpareTaxes));
					vo_1261.setSpareAmountDue(Double.toString(txtLabourCharge));   
					vo_1261.setGstRate("6");
					vo_1261.setGstCode("32");
					vewList.add(vo_1261);
			  }
			
			
			 boolean isTaxCode_0 =this.geGST_CHK(svc0004dmap) ; //1   0 구분 
			 
		
			 
			 //isTaxCode  0
			 if(isTaxCode_0){

				 //호출후 값 세팅 하기 
				 svc0004dmap.put("TaxCode", "39");
				 svc0004dmap.put("TaxRate", "0");
				 
            			 if(  Double.parseDouble((String)svc0004dmap.get("AS_FILTER_AMT")) > 0 ){   //txtFilterCharge
            				  if (addItemList.size() > 0) {  
            						for (int i = 0; i < addItemList.size(); i++) {
            							Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
            							Map<String, Object> iMap = new HashMap();
            							
            							String tempFilterTotal =String.valueOf( updateMap.get("filterTotal"));
            							double ft =Double.parseDouble(tempFilterTotal);
            							if( ft >0){
            							
            								    String filterCode ="";
            								    String filterName ="";
                								if(! "".equals(updateMap.get("filterDesc") )){
                									
                									String temp =(String)updateMap.get("filterDesc");
                									String[] animals = temp.split("-"); 
                									
                									if(animals.length>0){
                										filterCode = animals[0];
                										filterName = animals[1];
                									}
                								}
                								
                								
                								//setAsChargesTypeId 1261
                								AsResultChargesViewVO vo_filter  =null;
                								vo_filter =  new AsResultChargesViewVO();
                								vo_filter.setAsEntryId("");
                								vo_filter.setAsChargesTypeId("1262");
                								vo_filter.setAsChargeQty((String)updateMap.get("filterQty"));
                								vo_filter.setSparePartId((String)updateMap.get("filterID") );
                								vo_filter.setSparePartCode(filterCode);
                								vo_filter.setSparePartName(filterName);
                								vo_filter.setSparePartSerial("");
                								vo_filter.setSpareCharges(Double.toString(ft) );   //
                								vo_filter.setSpareTaxes("0");
                								vo_filter.setSpareAmountDue(Double.toString(ft));   
                								vo_filter.setGstRate("0");
                								vo_filter.setGstCode("0");
                								vewList.add(vo_filter);   //   view.GSTCode = ZRLocationID.ToString() == "0" ? ZRLocationID.ToString() : ZRLocationID.ToString();
                						}
            						}
            				  }
            			  }
			 
			 //tax 32 
			 }else {
				 
				 //호출후 값 세팅 하기 
				 svc0004dmap.put("TaxCode", "32");
				 svc0004dmap.put("TaxRate", "6");
				 
    				 if(  Double.parseDouble((String)svc0004dmap.get("AS_FILTER_AMT")) > 0 ){   //txtFilterCharge
    					 if (addItemList.size() > 0) {  
       						for (int i = 0; i < addItemList.size(); i++) {
       							Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
       							Map<String, Object> iMap = new HashMap();

    							String tempFilterTotal =String.valueOf( updateMap.get("filterTotal"));
    							double ft =Double.parseDouble(tempFilterTotal);
    							
       							if( ft >0){
       							
       								    String filterCode ="";
       								    String filterName ="";
           								if(! "".equals(updateMap.get("filterDesc") )){
           									
           									String temp =(String)updateMap.get("filterDesc");
           									String[] animals = temp.split("-"); 
           									   
           									if(animals.length>0){
           										filterCode = animals[0];
           										filterName = animals[1];
           									}
           								}
           								
           							    double t_SpareCharges = (ft *100/106);
           								double t_SpareTaxes =  ft - t_SpareCharges ;
           						
           								
           								
           								//setAsChargesTypeId 1261
           								AsResultChargesViewVO vo_filter32  =null;
           								vo_filter32 =  new AsResultChargesViewVO();
           								vo_filter32.setAsEntryId("");
           								vo_filter32.setAsChargesTypeId("1262");
           								vo_filter32.setAsChargeQty((String)updateMap.get("filterQty"));
           								vo_filter32.setSparePartId((String)updateMap.get("filterID") );
           								vo_filter32.setSparePartCode(filterCode);
           								vo_filter32.setSparePartName(filterName);
           								vo_filter32.setSparePartSerial("");
           								vo_filter32.setSpareCharges(Double.toString(t_SpareCharges) );   //
           								vo_filter32.setSpareTaxes("0");
           								vo_filter32.setSpareAmountDue(Double.toString(t_SpareTaxes));   
           								vo_filter32.setGstRate("6");
           								vo_filter32.setGstCode("32");
           								vewList.add(vo_filter32);   //   view.GSTCode = ZRLocationID.ToString() == "0" ? ZRLocationID.ToString() : ZRLocationID.ToString();
           						}
       						}
       				  }
       			  }
			 }//isTaxCode_0  if eof 
			 
			 this.setPay31dData(vewList ,svc0004dmap);
			 this.setPay32dData(vewList, svc0004dmap);
			 
			 
			 double labourCharges = 0;
			 double labourTaxes = 0;
	         double labourAmountDue = 0;
	         double partCharges = 0;
	         double partTaxes = 0;
	         double partAmountDue = 0;
			 
	         
	     	if(vewList.size()>0){
				for(AsResultChargesViewVO vo :   vewList){
					if(vo.getAsChargesTypeId().equals("1261")){
						labourCharges  		+= Double.parseDouble((vo.getSpareCharges()));
						labourTaxes     		+= Double.parseDouble((vo.getSpareTaxes()));
						labourAmountDue     += Double.parseDouble((vo.getSpareAmountDue()));
					}else if(vo.getAsChargesTypeId().equals("1262")){
						partCharges  		+= Double.parseDouble((vo.getSpareCharges()));
						partTaxes     		+= Double.parseDouble((vo.getSpareTaxes()));
						partAmountDue    += Double.parseDouble((vo.getSpareAmountDue()));
					} 
				}
	     	}
	     	
	     	LOGGER.debug("vewList  loop===>");
	     	LOGGER.debug("					getAsChargesTypeId  1261 in===>");
	     	LOGGER.debug("											labourCharges["+labourCharges+"]");
	     	LOGGER.debug("											labourTaxes["+labourTaxes+"]");
	     	LOGGER.debug("											labourAmountDue["+labourAmountDue+"]");
	    	LOGGER.debug("					getAsChargesTypeId  1261  out===>");

	     	LOGGER.debug("					getAsChargesTypeId  1262 in===>");
	     	LOGGER.debug("											partCharges["+partCharges+"]");
	     	LOGGER.debug("											partTaxes["+partTaxes+"]");
	     	LOGGER.debug("											partAmountDue["+partAmountDue+"]");
	    	LOGGER.debug("					getAsChargesTypeId  1262  out===>");
	     	LOGGER.debug("vewList  loop===>");
	     	
	     	
	     	if (labourAmountDue > 0){
	     		this.setPay16dLabourData(vewList ,svc0004dmap);
	     	} 
	     	
	     	
	      	if (partAmountDue > 0){
	     		this.setPay16dPartData(vewList ,svc0004dmap);
	     	} 
	      	
			 
	      	
	      	
			 
	      	boolean isBillIsPaid =false;
	      	
	      	this.setPay0006dData(vewList ,svc0004dmap ,"A");
	      	
			double totalLgAmt =  0; 
			double totalUsedLgAmt = 0; 
			double totalAASLeft = 0;
			
			if( null !=sumLeftMap ){
				totalLgAmt =Double.parseDouble((String)sumLeftMap.get("totalLgAmt"));
				totalUsedLgAmt=Double.parseDouble((String)sumLeftMap.get("totalUsedLgAmt"));
				totalAASLeft=Double.parseDouble((String)sumLeftMap.get("totalAASLeft"));
			}
			 
			if(totalAASLeft >0) {
			    if (totalAASLeft >= AS_TOT_AMT){
			    	isBillIsPaid =true;
                	this.setPay0006dData(vewList ,svc0004dmap ,"B");
                	
                }else{
                	svc0004dmap.put("totalAASLeft", (String)sumLeftMap.get("totalAASLeft"));
                	this.setPay0006dData(vewList ,svc0004dmap,"C");
                }
			}
			
			
			this.setPay0007dData(vewList ,svc0004dmap,  isBillIsPaid==true ? "1" :"0");
			
		
	      	if(labourTaxes > 0){
				svc0004dmap.put("AS_WORKMNSH_TAX_CODE_ID", "32");  

			}else{
				svc0004dmap.put("AS_WORKMNSH_TAX_CODE_ID", "0");  
			}   
    		svc0004dmap.put("AS_WORKMNSH_TXS",Double.toString(labourTaxes));
    	
	  }//AS_TOT_AMT  if  eof 
		
		    	
		//insert svc0004d 
		int c=  this.insertSVC0004D(svc0004dmap);  
		int callint =updateSTATE_CCR0006D(svc0004dmap);
		insertSVC0005D(addItemList ,  AS_RESULT_ID , String.valueOf(params.get("updator"))); 
		
	    svc0004dmap.put("AS_RESULT_STUS_ID", params.get("AS_RESULT_STUS_ID") );
	    svc0004dmap.put("AS_ID", params.get("AS_ENTRY_ID") );
	    svc0004dmap.put("USER_ID", String.valueOf(params.get("updator")) );
		this.updateStateSVC0001D(svc0004dmap);
		
		EgovMap em = new EgovMap();
		em.put("AS_NO",String.valueOf(eMap.get("asno")));
		
		  
     	LOGGER.debug("==========asResult_insert  Log  out================");
		return em;
	}
	
	

	@Override
	public EgovMap  asResult_update(Map<String, Object> params) {
		
     	LOGGER.debug("==========asResult_update  Log  in================");
     	
     	ArrayList<AsResultChargesViewVO>  vewList = null;
     	List <EgovMap> addItemList = null;
    	List<EgovMap>  resultMList   	=null;
     	
    	LinkedHashMap  svc0004dmap  =null;
     	EgovMap  seqpay17Map = null;
     	EgovMap  eASEntryDocNo = null;
     	EgovMap  asResultASEntryId = null;
    	EgovMap  invoiceDocNo = null;
    	
    	
    	String ACC_INV_VOID_ID 		=null;
    	String NEW_AS_RESULT_ID  	 =null;
    	String	 NEW_AS_RESULT_NO   	 =null;
    	
    	int  asTotAmt =0;
    	
     	
     	String  AS_ID 			   =  String.valueOf(params.get("AS_ID"));
     	String  ACC_BILL_ID  =  String.valueOf(params.get("ACC_BILL_ID"));
     	String  ACC_INVOICE_NO  =  String.valueOf(params.get("ACC_INVOICE_NO")) !="" ? String.valueOf(params.get("ACC_INVOICE_NO")) : String.valueOf(params.get("AS_RESULT_NO"));
     	params.put("ACC_BILL_ID", ACC_BILL_ID);
     	params.put("ACC_INVOICE_NO", ACC_INVOICE_NO);

     	seqpay17Map = ASManagementListMapper.getPAY0017SEQ(params); 
     	ACC_INV_VOID_ID = String.valueOf(seqpay17Map.get("seq"));
     	params.put("ACC_INV_VOID_ID", ACC_INV_VOID_ID);
     	
     	
		params.put("DOCNO", "21");
		eASEntryDocNo = ASManagementListMapper.getASEntryDocNo(params); 		
		asResultASEntryId = ASManagementListMapper.getResultASEntryId(params); 
		
		NEW_AS_RESULT_ID   = String.valueOf(asResultASEntryId.get("seq"));
		NEW_AS_RESULT_NO  = String.valueOf(eASEntryDocNo.get("asno"));
		 
		//params.put("AS_RESULT_ID",  NEW_AS_RESULT_ID);
		//params.put("AS_RESULT_NO", NEW_AS_RESULT_NO);
		
		
		svc0004dmap = (LinkedHashMap)  params.get("asResultM");
		
		svc0004dmap.put("NEW_AS_RESULT_ID", NEW_AS_RESULT_ID);
		svc0004dmap.put("NEW_AS_RESULT_NO", NEW_AS_RESULT_NO);
		
		svc0004dmap.put("updator",params.get("updator"));
		svc0004dmap.put("AS_NO",  String.valueOf(params.get("AS_NO")));
		svc0004dmap.put("AS_ID",  String.valueOf(params.get("AS_ID")));
		
		
		vewList = new ArrayList<AsResultChargesViewVO>();
		addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
		 
		
		resultMList =ASManagementListMapper.getResult_SVC0004D(svc0004dmap);
		svc0004dmap.put("AS_RESULT_ID",  (String)((EgovMap)resultMList.get(0)).get("asResultId"));
		svc0004dmap.put("AS_RESULT_NO",  (String)((EgovMap)resultMList.get(0)).get("asResultNo"));
		asTotAmt = Integer.parseInt( (String)((EgovMap)resultMList.get(0)).get("asTotAmt"));  
		
		
		//reverse_SVC0004D
		 svc0004dmap.put("OLD_AS_RESULT_ID", params.get("AS_RESULT_ID"));
		 ASManagementListMapper.reverse_SVC0004D(svc0004dmap);
		 ASManagementListMapper.reverse_CURR_SVC0004D(svc0004dmap);
		 
		 EgovMap  cm = ASManagementListMapper. getLog0016DCount(svc0004dmap); 
		 int  log0016dCnt = Integer.parseInt((String)cm.get("cnt"));
		 
		 
		 //Auto Request PDO (If current result has complete PDO claim)
		 if(log0016dCnt > 0){
			 
			 EgovMap PDO_DocNoMap=null;
			 EgovMap LOG_IDMap=null;
			 String PDO_DocNo=null;
			 String LOG16_ID=null;
			 
			 
			 params.put("DOCNO", "26");
			 PDO_DocNoMap = ASManagementListMapper.getASEntryDocNo(params); 		
			 PDO_DocNo = String.valueOf(PDO_DocNoMap.get("asno"));
			 
			 LOG_IDMap = ASManagementListMapper.getLOG0015DSEQ(params);
			 LOG16_ID = String.valueOf(LOG_IDMap.get("seq"));
			 
			 svc0004dmap.put("STK_REQ_ID", LOG16_ID);
			 svc0004dmap.put("STK_REQ_NO", PDO_DocNo);
			 
			 int a =ASManagementListMapper.insert_LOG0015D(svc0004dmap);
			 if(a>0){
				 ASManagementListMapper.insert_LOG0016D(svc0004dmap);
			 }
		 }
		
		 
		 //Reverse InvStkRecordCard (Return Stock To Member's Hand) -- Prepare for PDO return (ACF)
		 ASManagementListMapper.insert_LOG0014D(svc0004dmap);
		 
		 
		//CN Waive Billing (If Current Result has charge)
         if (asTotAmt > 0) {
        	 //AccBillings
        	 ASManagementListMapper.reverse_PAY0007D(svc0004dmap);
        	 
         	 svc0004dmap.put("ACC_BILL_ID", params.get("ACC_BILL_ID") );
         	 List<EgovMap>  resultPAY0016DList   	=null;
     		 					   resultPAY0016DList =ASManagementListMapper.getResult_SVC0004D(svc0004dmap);
     		 					   
     		 EgovMap  pay0016dData = resultPAY0016DList.get(0);			   

     		 
        	 //AccOrderBill
        	 ASManagementListMapper.reverse_PAY0016D(svc0004dmap);
        	 
        	 EgovMap CN_DocNoMap=null;
        	 String CNNO=null;
        	 
        	 EgovMap CNReportNo_DocNoMap=null;
        	 String  CNReportNo=null;
        	 
        	 params.put("DOCNO", "134");
        	 CN_DocNoMap = ASManagementListMapper.getASEntryDocNo(params); 		
        	 CNNO = String.valueOf(CN_DocNoMap.get("asno"));
        	 
        	 params.put("DOCNO", "18");
        	 CNReportNo_DocNoMap = ASManagementListMapper.getASEntryDocNo(params); 		
        	 CNReportNo = String.valueOf(CNReportNo_DocNoMap.get("asno"));
        	 
        	 
        	 
			 
        	 List<EgovMap>  resultPAY0031DList   	=null;
      		 svc0004dmap.put("accBillRem",pay0016dData.get("accBillRem"));
      		 resultPAY0031DList =ASManagementListMapper.getResult_PAY0031D(svc0004dmap);
      		EgovMap  resultPAY0031DInfo = resultPAY0031DList.get(0);
      		 

      		
      		 //////////////////  pay16d  //////////////////// 
      		EgovMap PAY0016DSEQMap = ASManagementListMapper.getPAY0016DSEQ(params); 
          	String PAY0016DSEQ = String.valueOf(PAY0016DSEQMap.get("seq"));
          	EgovMap pay16d_insert = new EgovMap();
            pay16d_insert.put("memoAdjId",PAY0016DSEQ);
            pay16d_insert.put("memoAdjRefNo",CNNO); 
            pay16d_insert.put("memoAdjRptNo",CNReportNo); 
            pay16d_insert.put("memoAdjTypeId","1293");
            pay16d_insert.put("memoAdjInvcNo",pay0016dData.get("accBillRem"));
            pay16d_insert.put("memoAdjInvcTypeId","128"); 
            pay16d_insert.put("memoAdjStusId","4"); 
            pay16d_insert.put("memoAdjResnId","2038"); 
            pay16d_insert.put("memoAdjRem","AS RESULT REVERSAL_"+ resultPAY0031DInfo.get("taxInvcSvcNo")); 
            pay16d_insert.put("memoAdjTxsAmt",resultPAY0031DInfo.get("taxInvcTxs"));   
            pay16d_insert.put("memoAdjTotAmt",resultPAY0031DInfo.get("taxInvcAmtDue"));   
            pay16d_insert.put("memoAdjCrtDt",new Date()); 
            pay16d_insert.put("memoAdjCrtUserId",svc0004dmap.get("updator"));   
            pay16d_insert.put("memoAdjUpdDt",new Date()); 
            pay16d_insert.put("memoAdjUpdUserId",svc0004dmap.get("updator"));
            pay16d_insert.put("batchId","");
            ASManagementListMapper.reverse_PAY0016D(pay16d_insert);
            //////////////////  pay12d  //////////////////// 
            
            
            
            //////////////////  pay12d  //////////////////// 
            svc0004dmap.put("MEMO_ADJ_ID", PAY0016DSEQ);
 		    svc0004dmap.put("MEMO_ITM_TAX_CODE_ID", pay0016dData.get("accBillTaxCodeId"));
 		    svc0004dmap.put("MEMO_ITM_REM", "AS RESULT REVERSAL_"+ resultPAY0031DInfo.get("taxInvcSvcNo"));
            svc0004dmap.put("TAX_INVC_REF_NO", pay0016dData.get("accBillRem")); 		 
 		    int  reverse_PAY0012D_cnt =  ASManagementListMapper.reverse_PAY0012D(svc0004dmap);
 		    //////////////////  pay12d  //////////////////// 
 		    
 		    
 		    
 		    
 		    //////////////////  pay27d  //////////////////// 
 		    EgovMap PAY0027DSEQMap = ASManagementListMapper.getPAY0027DSEQ(params); 
            String PAY0027DSEQ = String.valueOf(PAY0027DSEQMap.get("seq"));
         	EgovMap pay27d_insert = new EgovMap();
         	pay27d_insert.put("noteId",PAY0027DSEQ); 
         	pay27d_insert.put("noteEntryId",PAY0016DSEQ); 
         	pay27d_insert.put("noteTypeId","1293");
         	pay27d_insert.put("noteGrpNo",resultPAY0031DInfo.get("taxInvcSvcNo")); 
         	pay27d_insert.put("noteRefNo",CNNO); 
            pay27d_insert.put("noteRefDt",resultPAY0031DInfo.get("taxInvcRefDt"));  
            pay27d_insert.put("noteInvcNo",pay0016dData.get("accBillRem"));
            pay27d_insert.put("noteInvcTypeId","128");
            pay27d_insert.put("noteCustName",resultPAY0031DInfo.get("taxInvcCustName"));  
            pay27d_insert.put("noteCntcPerson",resultPAY0031DInfo.get("taxInvcCntcPerson")); 
            pay27d_insert.put("noteAddr1",resultPAY0031DInfo.get("taxInvcAddr1"));	
            pay27d_insert.put("noteAddr2",resultPAY0031DInfo.get("taxInvcAddr2"));	
            pay27d_insert.put("noteAddr3",resultPAY0031DInfo.get("taxInvcAddr3"));
            pay27d_insert.put("noteAddr4",resultPAY0031DInfo.get("taxInvcAddr4"));
            pay27d_insert.put("notePostCode",resultPAY0031DInfo.get("taxInvcPostCode"));  
            pay27d_insert.put("noteAreaName","");
            pay27d_insert.put("noteStateName",resultPAY0031DInfo.get("taxInvcStateName"));
            pay27d_insert.put("noteCntyName",resultPAY0031DInfo.get("taxInvcCnty")); 
            pay27d_insert.put("noteTxs",resultPAY0031DInfo.get("taxInvcTxs"));
            pay27d_insert.put("noteChrg",resultPAY0031DInfo.get("taxInvcChrg")); 
            pay27d_insert.put("noteAmtDue",resultPAY0031DInfo.get("taxInvcAmtDue")); 
            pay27d_insert.put("noteRem", "AS RESULT REVERSAL - " +resultPAY0031DInfo.get("taxInvcSvcNo"));
            pay27d_insert.put("noteStusId","4");
            pay27d_insert.put("noteCrtDt",new Date()); 
            pay27d_insert.put("noteCrtUserId",svc0004dmap.get("updator"));
            ASManagementListMapper.reverse_PAY0027D(pay27d_insert);
           //////////////////  pay27d   end  //////////////////// 
           
           
            
            if(reverse_PAY0012D_cnt > 0){
                svc0004dmap.put("NOTE_ID", PAY0027DSEQ);
                int   reverse_PAY0028D_cnt = ASManagementListMapper.reverse_PAY0028D(svc0004dmap);
            }
            
            
            //////////////////  pay17d  pay18d  //////////////////// 
            EgovMap PAY0017DSEQMap = ASManagementListMapper.getPAY0017DSEQ(params); 
            String PAY0017DSEQ = String.valueOf(PAY0017DSEQMap.get("seq"));
            svc0004dmap.put("ACC_INV_VOID_ID", PAY0017DSEQ);
            svc0004dmap.put("accInvVoidSubCrditNoteId", PAY0016DSEQ);
            svc0004dmap.put("accInvVoidSubCrditNote", CNNO);
            setPay17dData(svc0004dmap);
            setPay18dData(svc0004dmap);
            //////////////////  pay17d   pay18d  end//////////////////// 
            
            
            
            //////////////////pay06d    //////////////////// 
         	EgovMap pay06d_insert = new EgovMap();
         	pay06d_insert.put("asId",AS_ID); 
         	pay06d_insert.put("asDocNo",CNNO); 
            pay06d_insert.put("asLgDocTypeId","155"); 
            pay06d_insert.put("asLgDt",new Date()); 
            pay06d_insert.put("asLgAmt", (-1 * asTotAmt) ); 
            pay06d_insert.put("asLgUpdUserId",svc0004dmap.get("updator"));
            pay06d_insert.put("asLgUpdDt", new Date());
            pay06d_insert.put("asSoNo",  params.get("AS_SO_NO")); 
            pay06d_insert.put("asResultNo",(String)((EgovMap)resultMList.get(0)).get("asResultNo"));
            pay06d_insert.put("asSoId",params.get("AS_SO_ID"));
            pay06d_insert.put("asAdvPay","0");
            pay06d_insert.put("r01","");
            
            int   reverse_PAY0006D_cnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
            //////////////////pay06d    end//////////////////// 
         }
		 
         //////////////////pay06d    //////////////////// 
         ///Restore Advanced AS Payment Use In Current Result
         List<EgovMap>  p6dList = ASManagementListMapper. getResult_PAY0006D(svc0004dmap); 
         if(null != p6dList && p6dList.size() >0){
        	 for(int i=0;i<p6dList.size(); i++){
        		 EgovMap pay06d_insert =p6dList.get(i);
        		 
        		 //////////////////pay06d    1set //////////////////// 
        		 int p16d_asTotAmt =  pay06d_insert.get("asLgAmt") ==null  ? 0 : Integer.parseInt((String)pay06d_insert.get("asLgAmt") );
				
        		 pay06d_insert.put("asId",AS_ID); 
		         pay06d_insert.put("asDocNo",NEW_AS_RESULT_NO); 
		         pay06d_insert.put("asLgDocTypeId","163"); 
		         pay06d_insert.put("asLgDt",new Date()); 
		         pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt) ); 
		         pay06d_insert.put("asLgUpdUserId",svc0004dmap.get("updator"));
		         pay06d_insert.put("asLgUpdDt", new Date());
		         pay06d_insert.put("asSoNo",  params.get("AS_SO_NO")); 
		         pay06d_insert.put("asResultNo",(String)((EgovMap)resultMList.get(0)).get("asResultNo"));
		         pay06d_insert.put("asSoId",params.get("AS_SO_ID"));
		         pay06d_insert.put("asAdvPay","1");
		         pay06d_insert.put("r01","");
		            
		         int   reverse_PAY0006D_1setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
				 //////////////////pay06d    1set end////////////////
				 
				 //////////////////pay06d    2set //////////////////// 
		    	 pay06d_insert.put("asId",AS_ID); 
		         pay06d_insert.put("asDocNo",NEW_AS_RESULT_NO); 
		         pay06d_insert.put("asLgDocTypeId","401"); 
		         pay06d_insert.put("asLgDt",new Date()); 
		         pay06d_insert.put("asLgAmt", (-1 * p16d_asTotAmt) ); 
		         pay06d_insert.put("asLgUpdUserId",svc0004dmap.get("updator"));
		         pay06d_insert.put("asLgUpdDt", new Date());
		         pay06d_insert.put("asSoNo",  params.get("AS_SO_NO")); 
		         pay06d_insert.put("asResultNo","");
		         pay06d_insert.put("asSoId",params.get("AS_SO_ID"));
		         pay06d_insert.put("asAdvPay","1");
		         pay06d_insert.put("r01","");
		            
		            int   reverse_PAY0006D_2setCnt = ASManagementListMapper.insert_Pay0006d(pay06d_insert);
				 //////////////////pay06d    2set end//////////////// 
			 }
         }
		 //////////////////pay06d    end //////////////////// 
		 
         
         //Reverse All AS Payment Transaction   Including Reverse Payment,because reverse payment can be partial amount
         List<EgovMap>  p7dList = ASManagementListMapper. getResult_PAY0007D(svc0004dmap); 
         if(null != p7dList && p7dList.size() >0){
        	 	 
        	 //////////////////pay07d   update //////////////// 
        	 int reverse_StateUpPAY0007D_cnt = ASManagementListMapper.reverse_StateUpPAY0007D(svc0004dmap);
        	 //////////////////pay07d   update //////////////// 
        	 
        	 
        	 //////////////////PAY0064D   SELECT //////////////// 
        	 List<EgovMap>  p64dList = ASManagementListMapper. getResult_PAY0064D(svc0004dmap); 
        	 //////////////////PAY0064D   			 //////////////// 
             if(null != p64dList && p64dList.size() >0){
            	 for(int i=0;i<p64dList.size(); i++){
            		 
            		 EgovMap p64dList_Map =p64dList.get(i);
            		 int trxTotAmt =  p64dList_Map.get("totAmt") ==null  ? 0 : Integer.parseInt((String)p64dList_Map.get("totAmt") );

                	 Map  PAY_DocNoMap =null;
                	 String PAYNO_REV =null;
                	 
                	 params.put("DOCNO", "82");
                	 PAY_DocNoMap = ASManagementListMapper.getASEntryDocNo(params); 		
                	 PAYNO_REV = String.valueOf(PAY_DocNoMap.get("asno"));
                	 
                	 EgovMap PAY0069DSEQMap = ASManagementListMapper.getPAY0069DSEQ(params); 
                     String PAY0069DSEQ = String.valueOf(PAY0069DSEQMap.get("seq"));
                     
                	 //////////////////PAY0069D   insert //////////////// 
                  	 EgovMap pay069d_insert = new EgovMap();              	
                  	 pay069d_insert.put("trxId", PAY0069DSEQ);
                  	 pay069d_insert.put("trxDt", new Date());
                  	 pay069d_insert.put("trxType", "101");
                  	 pay069d_insert.put("trxAmt", (-1 * trxTotAmt));
                  	 pay069d_insert.put("trxMtchNo", "");
                  	 
                     int insert_PAY0069D_cnt =ASManagementListMapper. insert_PAY0069D (pay069d_insert); 
                     //////////////////PAY0069D   out    //////////////// 
                     
                     
                     
                     
            		 
            	 }
             }
        	 
        	 
        	 
         }// p7dList eof 
         
         
         
         
         
		 
         
		 //reverse_SVC0005D
		 ASManagementListMapper.reverse_CURR_SVC0005D(svc0004dmap);
		 
		 int c=  ASManagementListMapper.insertSVC0004D(svc0004dmap);  
			
		 double AS_TOT_AMT =0;
		 AS_TOT_AMT = Double.parseDouble((String)svc0004dmap.get("AS_TOT_AMT"));
		
		
		LOGGER.debug("				Logic 1===> AS_TOT_AMT["+AS_TOT_AMT+"]");
		if(AS_TOT_AMT > 0){
		
			
			
			if(  Double.parseDouble((String)svc0004dmap.get("AS_WORKMNSH")) > 0 ){   //txtLabourCharge
				  
				    double txtLabourCharge  =  Double.parseDouble((String)svc0004dmap.get("AS_WORKMNSH"));
			        double t_SpareCharges = (txtLabourCharge *100/106);
					double t_SpareTaxes =    txtLabourCharge - t_SpareCharges ;
					
			     	LOGGER.debug("txtLabourCharge["+txtLabourCharge+"]");
			     	LOGGER.debug("t_SpareCharges===>["+t_SpareCharges+"]");
			     	LOGGER.debug("vewList  loop===>["+t_SpareTaxes+"]");

					 
					//setAsChargesTypeId 1261
					AsResultChargesViewVO vo_1261  =null;
					vo_1261 =  new AsResultChargesViewVO();
					vo_1261.setAsEntryId("");
					vo_1261.setAsChargesTypeId("1261");
					vo_1261.setAsChargeQty("1");
					vo_1261.setSparePartId("0");
					vo_1261.setSparePartCode((String)svc0004dmap.get("productCode"));
					vo_1261.setSparePartName((String)svc0004dmap.get("productName"));
					vo_1261.setSparePartSerial((String)svc0004dmap.get("serialNo"));
					vo_1261.setSpareCharges(Double.toString(t_SpareCharges) );   //
					vo_1261.setSpareTaxes(Double.toString(t_SpareTaxes));
					vo_1261.setSpareAmountDue(Double.toString(txtLabourCharge));   
					vo_1261.setGstRate("6");
					vo_1261.setGstCode("32");
					vewList.add(vo_1261);
			}
			
			
			boolean isTaxCode_0 =this.geGST_CHK(svc0004dmap) ; //1   0 구분 
		
			 
			 //isTaxCode  0
			if(isTaxCode_0){

				 //호출후 값 세팅 하기 
				 svc0004dmap.put("TaxCode", "39");
				 svc0004dmap.put("TaxRate", "0");
				 
            			 if(  Double.parseDouble((String)svc0004dmap.get("AS_FILTER_AMT")) > 0 ){   //txtFilterCharge
            				  if (addItemList.size() > 0) {  
            						for (int i = 0; i < addItemList.size(); i++) {
            							Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
            							Map<String, Object> iMap = new HashMap();
            							
            							String tempFilterTotal =String.valueOf( updateMap.get("filterTotal"));
            							double ft =Double.parseDouble(tempFilterTotal);
            							if( ft >0){
            							
            								    String filterCode ="";
            								    String filterName ="";
                								if(! "".equals(updateMap.get("filterDesc") )){
                									
                									String temp =(String)updateMap.get("filterDesc");
                									String[] animals = temp.split("-"); 
                									
                									if(animals.length>0){
                										filterCode = animals[0];
                										filterName = animals[1];
                									}
                								}
                								
                								
                								//setAsChargesTypeId 1261
                								AsResultChargesViewVO vo_filter  =null;
                								vo_filter =  new AsResultChargesViewVO();
                								vo_filter.setAsEntryId("");
                								vo_filter.setAsChargesTypeId("1262");
                								vo_filter.setAsChargeQty((String)updateMap.get("filterQty"));
                								vo_filter.setSparePartId((String)updateMap.get("filterID") );
                								vo_filter.setSparePartCode(filterCode);
                								vo_filter.setSparePartName(filterName);
                								vo_filter.setSparePartSerial("");
                								vo_filter.setSpareCharges(Double.toString(ft) );   //
                								vo_filter.setSpareTaxes("0");
                								vo_filter.setSpareAmountDue(Double.toString(ft));   
                								vo_filter.setGstRate("0");
                								vo_filter.setGstCode("0");
                								vewList.add(vo_filter);   //   view.GSTCode = ZRLocationID.ToString() == "0" ? ZRLocationID.ToString() : ZRLocationID.ToString();
                						}
            						}
            				  }
            			  }
			 
			 //tax 32 
			 }else {
				 
				 //호출후 값 세팅 하기 
				 svc0004dmap.put("TaxCode", "32");
				 svc0004dmap.put("TaxRate", "6");
				 
    				 if(  Double.parseDouble((String)svc0004dmap.get("AS_FILTER_AMT")) > 0 ){   //txtFilterCharge
    					 if (addItemList.size() > 0) {  
       						for (int i = 0; i < addItemList.size(); i++) {
       							Map<String, Object> updateMap = (Map<String, Object>) addItemList.get(i);
       							Map<String, Object> iMap = new HashMap();

    							String tempFilterTotal =String.valueOf( updateMap.get("filterTotal"));
    							double ft =Double.parseDouble(tempFilterTotal);
    							
       							if( ft >0){
       							
       								    String filterCode ="";
       								    String filterName ="";
           								if(! "".equals(updateMap.get("filterDesc") )){
           									
           									String temp =(String)updateMap.get("filterDesc");
           									String[] animals = temp.split("-"); 
           									   
           									if(animals.length>0){
           										filterCode = animals[0];
           										filterName = animals[1];
           									}
           								}
           								
           							    double t_SpareCharges = (ft *100/106);
           								double t_SpareTaxes =  ft - t_SpareCharges ;
           						
           								
           								
           								//setAsChargesTypeId 1261
           								AsResultChargesViewVO vo_filter32  =null;
           								vo_filter32 =  new AsResultChargesViewVO();
           								vo_filter32.setAsEntryId("");
           								vo_filter32.setAsChargesTypeId("1262");
           								vo_filter32.setAsChargeQty((String)updateMap.get("filterQty"));
           								vo_filter32.setSparePartId((String)updateMap.get("filterID") );
           								vo_filter32.setSparePartCode(filterCode);
           								vo_filter32.setSparePartName(filterName);
           								vo_filter32.setSparePartSerial("");
           								vo_filter32.setSpareCharges(Double.toString(t_SpareCharges) );   //
           								vo_filter32.setSpareTaxes("0");
           								vo_filter32.setSpareAmountDue(Double.toString(t_SpareTaxes));   
           								vo_filter32.setGstRate("6");
           								vo_filter32.setGstCode("32");
           								vewList.add(vo_filter32);   //   view.GSTCode = ZRLocationID.ToString() == "0" ? ZRLocationID.ToString() : ZRLocationID.ToString();
           						}
       						}
       				  }
       			  }
			}//isTaxCode_0  if eof 
			
			//InvoiceNum 채번 
			params.put("DOCNO", "128");
			invoiceDocNo = ASManagementListMapper.getASEntryDocNo(params); 		
			svc0004dmap.put("taxInvcRefNo", String.valueOf(invoiceDocNo.get("asno")))	;
			this.setPay31dData(vewList,svc0004dmap);
			this.setPay32dData(vewList,svc0004dmap) ;
			
			
			
			double labourCharges = 0;
			double labourTaxes = 0;
	        double labourAmountDue = 0;
	        double partCharges = 0;
	        double partTaxes = 0;
	        double partAmountDue = 0;
			 
	         
	     	if(vewList.size()>0){
				for(AsResultChargesViewVO vo :   vewList){
					if(vo.getAsChargesTypeId().equals("1261")){
						labourCharges  		+= Double.parseDouble((vo.getSpareCharges()));
						labourTaxes     		+= Double.parseDouble((vo.getSpareTaxes()));
						labourAmountDue     += Double.parseDouble((vo.getSpareAmountDue()));
					}else if(vo.getAsChargesTypeId().equals("1262")){
						partCharges  		+= Double.parseDouble((vo.getSpareCharges()));
						partTaxes     		+= Double.parseDouble((vo.getSpareTaxes()));
						partAmountDue    += Double.parseDouble((vo.getSpareAmountDue()));
					} 
				}
	     	}
	     	
	     	LOGGER.debug("vewList  loop===>");
	     	LOGGER.debug("					getAsChargesTypeId  1261 in===>");
	     	LOGGER.debug("											labourCharges["+labourCharges+"]");
	     	LOGGER.debug("											labourTaxes["+labourTaxes+"]");
	     	LOGGER.debug("											labourAmountDue["+labourAmountDue+"]");
	    	LOGGER.debug("					getAsChargesTypeId  1261  out===>");

	     	LOGGER.debug("					getAsChargesTypeId  1262 in===>");
	     	LOGGER.debug("											partCharges["+partCharges+"]");
	     	LOGGER.debug("											partTaxes["+partTaxes+"]");
	     	LOGGER.debug("											partAmountDue["+partAmountDue+"]");
	    	LOGGER.debug("					getAsChargesTypeId  1262  out===>");
	     	LOGGER.debug("vewList  loop===>");
	     	

	     	if (labourAmountDue > 0){
	     		this.setPay16dLabourData(vewList ,svc0004dmap);
	     	} 
	     	
	     	
	      	if (partAmountDue > 0){
	     		this.setPay16dPartData(vewList ,svc0004dmap);
	     	} 
	     	
	      	

	      	if(labourTaxes > 0){
				svc0004dmap.put("AS_WORKMNSH_TAX_CODE_ID", "32");  

			}else{
				svc0004dmap.put("AS_WORKMNSH_TAX_CODE_ID", "0");  
			}   
    		svc0004dmap.put("AS_WORKMNSH_TXS",Double.toString(labourTaxes));
		}
		
	
		EgovMap em = new EgovMap();
		
		
		
		return em;
	}
	
	
	public  int  setPay17dData(Map<String, Object> params){
		
		LOGGER.debug("									===> setPay17dData   out");	
		Map<String, Object>  pay17dMap = new HashMap() ;
	
     	EgovMap pay27d_insert = new EgovMap();
         	
       	 params.put("DOCNO", "112");
    	 Map  DocNoMap = ASManagementListMapper.getASEntryDocNo(params); 		
		
		pay17dMap.put("accInvVoidId"			,params.get("ACC_INV_VOID_ID")); 
		pay17dMap.put("accInvVoidRefNo"		,String.valueOf(DocNoMap.get("asno"))); 
		pay17dMap.put("accInvVoidInvcNo"		,params.get("ACC_INVOICE_NO")); 
		pay17dMap.put("accInvVoidInvcAmt"	,params.get("AS_TOT_AMT")); 
		pay17dMap.put("accInvVoidRem","AS Result Reversal."); 
		pay17dMap.put("accInvVoidStusId","1");
		pay17dMap.put("accInvVoidCrtUserId",params.get("updator") ); 
		pay17dMap.put("accInvVoidCrtDt",new Date());
		
		
		 //int a=  ASManagementListMapper.insert_Pay0017d(pay17dMap);

		
		return 0;
	}
	
	
	public  int  setPay18dData(Map<String, Object> params){
		
		LOGGER.debug("									===> pay18dMap   out");	
		Map<String, Object>  pay18dMap = new HashMap() ;
		 
		
		pay18dMap.put("accInvVoidId",params.get("ACC_INV_VOID_ID")); 
		pay18dMap.put("accInvVoidSubOrdId",params.get("AS_SO_ID")); 
		pay18dMap.put("accInvVoidSubBillId",params.get("ACC_BILL_ID")); 
		pay18dMap.put("accInvVoidSubBillAmt",params.get("AS_TOT_AMT")); 
		pay18dMap.put("accInvVoidSubCrditNote",params.get("accInvVoidSubCrditNote")); 
		pay18dMap.put("accInvVoidSubCrditNoteId",params.get("accInvVoidSubCrditNoteId")); 
		pay18dMap.put("accInvVoidSubRem","Result Reversal.");
		   
		
		 //int a=  ASManagementListMapper.insert_Pay0018d(pay18dMap);

		
		return 0;
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
