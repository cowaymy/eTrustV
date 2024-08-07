package com.coway.trust.biz.sales.ccp.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.sales.ccp.CcpRentMemShipService;
import com.coway.trust.biz.sales.order.impl.OrderDetailMapper;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ccpRentMemShipService")
public class CcpRentMemShipServiceImpl extends EgovAbstractServiceImpl implements CcpRentMemShipService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpRentMemShipServiceImpl.class);
	
	@Resource(name = "ccpRentMemShipMapper")
	private CcpRentMemShipMapper ccpRentMemShipMapper;
	
	@Resource(name = "orderDetailMapper")
	private OrderDetailMapper orderDetailMapper;
	
	@Resource(name = "ccpAgreementMapper")
	private CcpAgreementMapper ccpAgreementMapper;

	
	@Override
	public List<EgovMap> getBranchCodeList() throws Exception {
		
		return ccpRentMemShipMapper.getBranchCodeList();
	}

	
	@Override
	public List<EgovMap> getReasonCodeList() throws Exception {
		
		return ccpRentMemShipMapper.getReasonCodeList();
	}


	@Override
	public List<EgovMap> selectCcpRentListSearchList(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectCcpRentListSearchList(params);
	}


	@Override
	public EgovMap selectServiceContract(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectServiceContract(params);
	}


	@Override
	public Map<String, Object> selectServiceContactBillingInfo(Map<String, Object> params) throws Exception {
		
		 int currentSchedule = 0;
         int billSchedule = 0;
         int unbillMth = 0;
         
         BigDecimal unbillAmt = null;
         BigDecimal monthlyFee = null;
         BigDecimal outstanding = null;
		
         BigDecimal tempBdc = null;
         //return 
         Map<String, Object> resultMap = new HashMap<String, Object>();
         
		//1. qryBill
		EgovMap billMap = null;
		billMap = ccpRentMemShipMapper.selectOutstandingUnbill(params);
		EgovMap scheduleMap = null;
		scheduleMap = ccpRentMemShipMapper.selectServiceSchedule(params);
		
		if(scheduleMap != null){
			
			tempBdc = (BigDecimal)scheduleMap.get("srvPaySchdulNo"); // 3 
			 currentSchedule = tempBdc.intValue();
			 
			monthlyFee = (BigDecimal) scheduleMap.get("srvPaySchdulAmt");   // 75      
		}
		
		//Init
		tempBdc = null;
		tempBdc = (BigDecimal)billMap.get("srvLdgrCntrctSchdulNo");
		billSchedule = tempBdc.intValue();
		if(currentSchedule > 0){
			unbillMth = currentSchedule - billSchedule;
			if (unbillMth > 0){
                
				unbillAmt = monthlyFee.multiply(new BigDecimal(unbillMth));
				
			}
		}
		
		//2. Outstanding
		outstanding = ccpRentMemShipMapper.getOutstandingAmount(params);
		
		
		resultMap.put("unbillAmt", unbillAmt);
		resultMap.put("outstanding", outstanding);
		resultMap.put("currentSchedule", currentSchedule);
		resultMap.put("monthlyFee", monthlyFee);
		
		return resultMap;
	}


	@Override
	public EgovMap selectOrderInfo(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectOrderInfo(params);
	}


	@Override
	public EgovMap selectOrderInfoInstallation(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectOrderInfoInstallation(params);
	}


	@Override
	public EgovMap selectSrvMemConfigInfo(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectSrvMemConfigInfo(params);
	}


	@Override
	public EgovMap selectPaySetInfo(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectPaySetInfo(params);
	}


	@Override
	public EgovMap selectCustThridPartyInfo(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectCustThridPartyInfo(params);
	}


	@Override
	public List<EgovMap> selectPaymentList(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectPaymentList(params);
	}


	@Override
	public List<EgovMap> selectCallLogList(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectCallLogList(params);
	}


	@Override
	public EgovMap selectOrderMailingInfoByOrderID(Map<String, Object> params) throws Exception {
		
		return orderDetailMapper.selectOrderMailingInfoByOrderID(params);
	}


	@Override
	public EgovMap confirmationInfoByContractID(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.confirmationInfoByContractID(params);
	}


	@Override
	public EgovMap selectCustBasicInfo(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectCustBasicInfo(params);
	}


	@Override
	public EgovMap selectContactPerson(Map<String, Object> params) throws Exception {
		
		return ccpRentMemShipMapper.selectContactPerson(params);
	}


	@Override
	@Transactional
	public void insUpdConfrimResult(Map<String, Object> params) throws Exception {
		
		EgovMap subMap = null;
		EgovMap srvIdMap = null;
		EgovMap srvStatusMap = null;
		List<EgovMap> subList = null;
		List<EgovMap>  srvIdList = null;
		EgovMap orderInfoMap = null;
		
		//1.Update ServiceContractConfirmation
		LOGGER.info("############## 1. Update ServiceContractConfirmation Start");
		ccpRentMemShipMapper.updMembershipInfo(params);
		LOGGER.info("############## 1. End Service");
		
		//2.UPDATE ServiceContract_Sub TABLE
		
		if("5".equals(params.get("updMemStatus"))){
			LOGGER.info("############## updMemStatus = 5");
			//Approve
			
			//1. Select  SAL0078D `s Contract ID
			subMap = ccpRentMemShipMapper.selectContractSub(params); //  GET  (Contract ID) OF SAL0078D  // 1318 > 1317 가져오고
			params.put("subContractId", subMap.get("cntrctId")); //params Set 
			params.put("rentalStus", SalesConstants.CONTRACT_RENTAL_STATUS_APPROVE);
			
			//2. Update Contract SUB 
			LOGGER.info("############## 5 : First Update Start");
			ccpRentMemShipMapper.updateContractSub(params);
			LOGGER.info("############## 5 : First Update End");
			if("965".equals(params.get("updCustTypeId"))){ //hidden Value
				LOGGER.info("############## 5 : > 965");
				
				srvIdMap = ccpRentMemShipMapper.getSrvContractId(params); // SrvPrdContractID 가지고 있음 // SRV_PRD_ID 을 가져옴
				
				if(srvIdMap != null){
					//2-1. Update 
					params.put("srvPrdId", srvIdMap.get("srvPrdId"));  // 1195933 을 가져옴
					params.put("srvPrdRem", SalesConstants.SRV_PRD_REM);
					LOGGER.info("############## 5 : > 965 > 2-1 Update Start");
					ccpRentMemShipMapper.updateSrvContractSub(params);
					LOGGER.info("############## 5 : > 965 > 2-1 Update End");
				}
				
				
				srvStatusMap = ccpRentMemShipMapper.getSrvCntrcStatus(params);
				if(srvStatusMap != null){
					params.put("srvCntrctStusId", SalesConstants.SRV_CNTRCT_STUSID); //4
					LOGGER.info("############## 5 : > 965 > 2-2 Update Start");
					ccpRentMemShipMapper.updateServiceContract(params);
					LOGGER.info("############## 5 : > 965 > 2-2 Update End");
					
				}
				
			}
			
			
		}else if("10".equals(params.get("updMemStatus"))){
			LOGGER.info("############## 10");
			//Cancel
			//1.Select
			srvStatusMap = ccpRentMemShipMapper.getSrvCntrcStatus(params);
			if(srvStatusMap != null){
				// 2-1 . Update
				LOGGER.info("############## 10 > 2-1 update Start");
				ccpRentMemShipMapper.updateServiceContractCancel(params);
				LOGGER.info("############## 10 > 2-1 update End");
			}
			
			// 2-2 . Update
			subList = ccpRentMemShipMapper.selectContractSubList(params); //  GET  (Contract ID) OF SAL0078D  // 1318 > 1317 가져오고
			if(subList != null && subList.size() > 0){
				
				for (int idx = 0; idx < subList.size(); idx++) {
					//params Set 
					
					params.put("subContractId", subList.get(idx).get("cntrctId")); 
					params.put("rentalStus", SalesConstants.CONTRACT_RENTAL_STATUS_CANCEL);
					LOGGER.info("############## 10 > 2-2 update Start" + idx);
					ccpRentMemShipMapper.updateContractSubCancel(params);
					LOGGER.info("############## 10 > 2-2 update End" + idx);
				}
				
			}
			
			// 2-3. Update
			srvIdList = ccpRentMemShipMapper.getSrvContractIdList(params);
			if(srvIdList != null && srvIdList.size() > 0){
				
				for (int idx = 0; idx < srvIdList.size(); idx++) {
					
					params.put("srvPrdId", srvIdList.get(idx).get("srvPrdId"));  // 1195933 을 가져옴
					params.put("srvPrdStusIdentify", SalesConstants.SRV_PRD_STUS_IDENTIFY);
					LOGGER.info("############## 10 > 2-3 update Start" + idx);
					ccpRentMemShipMapper.updateSrvContractSubCancel(params);
					LOGGER.info("############## 10 > 2-3 update End" + idx);
				}
				
			}
			
			//2-4 Insert
			//Doc Set
			//Sales Order Set  
			params.put("srvCntrctOrdId", srvStatusMap.get("srvCntrctOrdId"));
			orderInfoMap = ccpRentMemShipMapper.getSalesOrderInfo(params); 
			
			//ParamsSet
			String docNo = "";
			params.put("docNoId", SalesConstants.RENT_MEM_CODEID);
	    	docNo = ccpAgreementMapper.getDocNo(params); //docNo
	    	params.put("docNo", docNo);
	    	params.put("updPckgId", srvStatusMap.get("srvCntrctPckgId"));
	    	params.put("updCntrctStkId", orderInfoMap.get("itmStkId"));
	    	params.put("updTrmnatStusId", SalesConstants.TRMNAT_STUS_ID);
	    	params.put("updReasonId", SalesConstants.TRMNAT_REASON_ID);
	    	params.put("updRejectRem", SalesConstants.TRMNAT_REM);
	    	params.put("updObligtPriod", SalesConstants.TRMNAT_OBLIGATION_PERIOD);
	    	params.put("updCntrctSubPriod", SalesConstants.TRMNAT_CONTRACT_SUB_PERIOD);
	    	params.put("updCntrctRental", srvStatusMap.get("srvCntrctRental"));
	    	params.put("updPnalty", SalesConstants.TRMNAT_PENALTY);
			//Insert
	    	
			LOGGER.info("############## 2-4 . Last Insert Start");
			ccpRentMemShipMapper.insertServiceContractTerminations(params);
			LOGGER.info("############## 2-4 . Last Insert End");
			
		}// end 10
		
		//3 INSERT INTO ServiceContractConfirmLog TABLE (Insert Msg)
		LOGGER.info("############## 3. INSERT INTO ServiceContractConfirmLog TABLE (Insert Msg) Start");
		ccpRentMemShipMapper.insertMessageLog(params);
		LOGGER.info("############## 3. End Service");
		
	}
}
