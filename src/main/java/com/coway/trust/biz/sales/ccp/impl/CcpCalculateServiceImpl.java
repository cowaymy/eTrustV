package com.coway.trust.biz.sales.ccp.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.ccp.CcpCalculateService;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ccpCalculateService")
public class CcpCalculateServiceImpl implements CcpCalculateService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCalculateServiceImpl.class);
	
	@Resource(name = "ccpCalculateMapper")
	private CcpCalculateMapper ccpCalculateMapper;

	
	@Override
	public List<EgovMap> selectDscCodeList() throws Exception {
		
		return ccpCalculateMapper.selectDscCodeList();
	}
	

	@Override
	public List<EgovMap> selectReasonCodeFbList() throws Exception {
		
		return ccpCalculateMapper.selectReasonCodeFbList();
	}


	@Override
	public List<EgovMap> selectCalCcpListAjax(Map<String, Object> params) throws Exception {
		
		return ccpCalculateMapper.selectCalCcpListAjax(params);
	}


	@Override
	public EgovMap getLatestOrderLogByOrderID(Map<String, Object> params) throws Exception {
		
		EgovMap prgMap = null;
		prgMap = ccpCalculateMapper.getPrgId(params);
	
	    return prgMap;
			
	}


	@Override
	public List<EgovMap> getOrderUnitList(Map<String, Object> params) throws Exception {
		
		return ccpCalculateMapper.getOrderUnitList(params);
	}


	@Override
	public EgovMap getCalViewEditField(Map<String, Object> params) throws Exception {
		
		//variable
		EgovMap fieldMap = new EgovMap(); //return
		EgovMap unitSelMap =  null;
		List<EgovMap> countList = null;
		EgovMap pointMap = null;
		
		int orderSelValue = 0;
		
		BigDecimal tempBigDecimal = null;
		
		double orderUnitPoint = 0;
		double rosUnitPoint = 0;
		double susUnitPoint = 0;
		double custUnitPoint = 0;
		
		double resultTotPoint = 0;
		
		if(params.get("ccpMasterId").equals("1")){   //////////////////////// //Company ////////////////////////////////////////////
			
			/*  ######  Order Unit ######  */
			// 1. order Count
			countList = ccpCalculateMapper.countOrderUnit(params);
			fieldMap.put("ordUnitCount", countList.size()); 
			
			// 2. order select value
			params.put("unitCount", countList.size());
			params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID_ORD); //212
			params.put("ctgyMstId", SalesConstants.CATEGORY_MASTER_ID_COMPANY); //2
			unitSelMap = ccpCalculateMapper.comboUnitSelectValue(params);
			fieldMap.put("ordUnitSelVal", unitSelMap.get("screEventId"));
			
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			orderSelValue = tempBigDecimal.intValue();
			
			// 3. order unit point
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			params.put("orderUnit", tempBigDecimal.intValue());
			pointMap = ccpCalculateMapper.getScorePointByEventID(params);
			fieldMap.put("orderUnitPoint", pointMap.get("screEventPoint"));
			
			orderUnitPoint = Double.parseDouble(String.valueOf(pointMap.get("screEventPoint")));
			
			/*  ######  ROS Month ######  */
			double rentAmt = 0;
			double totalRos = 0;
			double tempSumVal = 0;
			int rosResultValue = 0;
			
			//  1. ros Count
			rentAmt = ccpCalculateMapper.getScoreEventTotalRental(params); //param : custId
			
			if(rentAmt > 0){
				totalRos = ccpCalculateMapper.getScoreEventTotalRos(params); //param : custId
			}
			
			if(rentAmt == 0 && totalRos == 0){
				fieldMap.put("rosCount", rosResultValue);
			}else{
				
				tempSumVal = (double)totalRos / rentAmt;
				rosResultValue = (int) Math.round(tempSumVal); // ASIS : double s = Math.Round(before1, 0, MidpointRounding.AwayFromZero);
				fieldMap.put("rosCount", rosResultValue);
			}
			
			// 2. ros Select Value
			params.put("unitCount", rosResultValue);
			params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID_ROS); //213
			unitSelMap = ccpCalculateMapper.comboUnitSelectValue(params);
			fieldMap.put("rosUnitSelVal", unitSelMap.get("screEventId"));
			
			// 3. ros unit Point
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			params.put("orderUnit", tempBigDecimal.intValue());
			pointMap = ccpCalculateMapper.getScorePointByEventID(params); // 109
			fieldMap.put("rosUnitPoint", pointMap.get("screEventPoint"));
			
			rosUnitPoint =  Double.parseDouble(String.valueOf(pointMap.get("screEventPoint")));
			
			
			/*  ######  SUSPENTION AND TERMINATION ######  */
			
			// 1. sus Count
			List<EgovMap> susList = null;
			susList = ccpCalculateMapper.getScoreEventSuspension(params); //param: custId
			
			double iTotalUnbill = 0;
            double iTotalTer = 0;
            double iTotal = 0;
			EgovMap stsMap = null;
			/*EgovMap instMap = null;*/
			
			for (int idx = 0; idx < susList.size(); idx++) {
				
				params.put("tempOrdId", susList.get(idx).get("salesOrdId"));
				stsMap = ccpCalculateMapper.rentalSchemeStatusByOrdId(params);
				
				if(stsMap.get("stusCodeId").equals(SalesConstants.RENTAL_STATUS_SUS)){ //SUS
					
					/*instMap = ccpCalculateMapper.rentalInstNoByOrdId(params);
					instMap.get("rentInstNo"); // 42 */
					
					iTotalUnbill = iTotalUnbill +1 ;
				}else if(stsMap.get("stusCodeId").equals(SalesConstants.RENTAL_STATUS_TER)){ // TER
					iTotalTer = 0;
				}
			}// Loop End
			
			iTotal = iTotalUnbill + iTotalTer;
			int resultVal = (int)iTotal; //result
			fieldMap.put("susUnitCount", resultVal);
			
			// 2. sus SelectValue
			params.put("unitCount", resultVal);
			params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID_SUS); //216
			unitSelMap = ccpCalculateMapper.comboUnitSelectValue(params);
			fieldMap.put("susUnitSelVal", unitSelMap.get("screEventId"));
			
			// 3. sus Unit Point
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			params.put("orderUnit", tempBigDecimal.intValue());
			pointMap = ccpCalculateMapper.getScorePointByEventID(params);
			fieldMap.put("susUnitPoint", pointMap.get("screEventPoint"));
			
			susUnitPoint =  Double.parseDouble(String.valueOf(pointMap.get("screEventPoint")));
			
			// Existing Customer
			// 1. customer Count
			
			if(orderSelValue > 0){  //Order Unit
				
				if(rosResultValue <= 0){ // this.lblAvgROSDetail.Text
					
					EgovMap custInstMap = null;
					custInstMap = ccpCalculateMapper.getScoreEventExistCust(params); //param : custId
					if(custInstMap == null){
						fieldMap.put("custUnitCount", "0");
						params.put("unitCount", "0");
					}else{
						fieldMap.put("custUnitCount", custInstMap.get("rentInstNo")); //RENT_INST_NO
						params.put("unitCount", custInstMap.get("rentInstNo"));
					}
					
				}else{
					
					fieldMap.put("custUnitCount", "0");
					params.put("unitCount", "0");
				}
				
			}else{
				
				fieldMap.put("custUnitCount", "0");
				params.put("unitCount", "0");
				
			}
			// 2. customer SelectValue
			params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID_CUST); //210
			unitSelMap = ccpCalculateMapper.comboUnitSelectValue(params);
			fieldMap.put("custUnitSelVal", unitSelMap.get("screEventId"));
			
			// 3. customer Unit Point
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			params.put("orderUnit", tempBigDecimal.intValue());
			pointMap = ccpCalculateMapper.getScorePointByEventID(params);
			fieldMap.put("custUnitPoint", pointMap.get("screEventPoint"));
			
			custUnitPoint =  Double.parseDouble(String.valueOf(pointMap.get("screEventPoint")));
			
		}else{//////////////////////// //Individual ////////////////////////////////////////////
			
			
			/*  ######  Order Unit ######  */
			// 1. order Count
			countList = ccpCalculateMapper.countOrderUnit(params);
			fieldMap.put("ordUnitCount", countList.size()); 
			
			// 2. order select value
			params.put("unitCount", countList.size());
			params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID_ORD); //212
			params.put("ctgyMstId", SalesConstants.CATEGORY_MASTER_ID_INDIVIDUAL); //1
			unitSelMap = ccpCalculateMapper.comboUnitSelectValue(params);
			fieldMap.put("ordUnitSelVal", unitSelMap.get("screEventId"));
			
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			orderSelValue = tempBigDecimal.intValue();
			
			// 3. order unit point
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			params.put("orderUnit", tempBigDecimal.intValue());
			pointMap = ccpCalculateMapper.getScorePointByEventID(params);
			fieldMap.put("orderUnitPoint", pointMap.get("screEventPoint"));
			
			orderUnitPoint =  Double.parseDouble(String.valueOf(pointMap.get("screEventPoint")));
			
			/*  ######  ROS Month ######  */
			double rentAmt = 0;
			double totalRos = 0;
			double tempSumVal = 0;
			int rosResultValue = 0;
			
			//  1. ros Count
			rentAmt = ccpCalculateMapper.getScoreEventTotalRental(params); //param : custId
			
			if(rentAmt > 0){
				totalRos = ccpCalculateMapper.getScoreEventTotalRos(params); //param : custId
			}
			
			if(rentAmt == 0 || totalRos == 0){
				fieldMap.put("rosCount", rosResultValue);
			}else{
				
				tempSumVal = (double)totalRos / rentAmt;
				rosResultValue = (int) Math.round(tempSumVal); // ASIS : double s = Math.Round(before1, 0, MidpointRounding.AwayFromZero);
				fieldMap.put("rosCount", rosResultValue);
			}
			
			// 2. ros Select Value
			params.put("unitCount", rosResultValue);
			params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID_ROS); //213
			unitSelMap = ccpCalculateMapper.comboUnitSelectValue(params);
			fieldMap.put("rosUnitSelVal", unitSelMap.get("screEventId"));
			
			// 3. ros unit Point
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			params.put("orderUnit", tempBigDecimal.intValue());
			pointMap = ccpCalculateMapper.getScorePointByEventID(params); // 109
			fieldMap.put("rosUnitPoint", pointMap.get("screEventPoint"));
			
			rosUnitPoint =  Double.parseDouble(String.valueOf(pointMap.get("screEventPoint")));
			
			/*  ######  SUSPENTION AND TERMINATION ######  */
			
			// 1. sus Count
			List<EgovMap> susList = null;
			susList = ccpCalculateMapper.getScoreEventSuspension(params); //param: custId
			
			double iTotalUnbill = 0;
            double iTotalTer = 0;
            double iTotal = 0;
			EgovMap stsMap = null;
			/*EgovMap instMap = null;*/
			
			for (int idx = 0; idx < susList.size(); idx++) {
				
				params.put("tempOrdId", susList.get(idx).get("salesOrdId"));
				stsMap = ccpCalculateMapper.rentalSchemeStatusByOrdId(params);
				
				if(stsMap.get("stusCodeId").equals(SalesConstants.RENTAL_STATUS_SUS)){ //SUS
					
					/*instMap = ccpCalculateMapper.rentalInstNoByOrdId(params);
					instMap.get("rentInstNo"); // 42 */
					
					iTotalUnbill = iTotalUnbill +1 ;
				}else if(stsMap.get("stusCodeId").equals(SalesConstants.RENTAL_STATUS_TER)){ // TER
					iTotalTer = 0;
				}
			}// Loop End
			
			iTotal = iTotalUnbill + iTotalTer;
			int resultVal = (int)iTotal; //result
			fieldMap.put("susUnitCount", resultVal);
			
			// 2. sus SelectValue
			params.put("unitCount", resultVal);
			params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID_SUS); //216
			unitSelMap = ccpCalculateMapper.comboUnitSelectValue(params);
			fieldMap.put("susUnitSelVal", unitSelMap.get("screEventId"));
			
			// 3. sus Unit Point
			tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			params.put("orderUnit", tempBigDecimal.intValue());
			pointMap = ccpCalculateMapper.getScorePointByEventID(params);
			fieldMap.put("susUnitPoint", pointMap.get("screEventPoint"));
			
			susUnitPoint = Double.parseDouble(String.valueOf(pointMap.get("screEventPoint")));
			
			// Existing Customer
			// 1. customer Count
			
			if(orderSelValue > 0){  //Order Unit
				
				if(rosResultValue <= 0){ // this.lblAvgROSDetail.Text
					
					EgovMap custInstMap = null;
					custInstMap = ccpCalculateMapper.getScoreEventExistCust(params); //param : custId
					if(custInstMap == null){
						fieldMap.put("custUnitCount", "0");
						params.put("unitCount", "0");
					}else{
						fieldMap.put("custUnitCount", custInstMap.get("rentInstNo")); //RENT_INST_NO
						params.put("unitCount", custInstMap.get("rentInstNo"));
					}
					
				}else{
					fieldMap.put("custUnitCount", "0");
					params.put("unitCount", "0");
				}
			}else{
				fieldMap.put("custUnitCount", "0");
				params.put("unitCount", "0");
			}
			// 2. customer SelectValue
			params.put("ctgyTyId", SalesConstants.CATEGORY_TYPE_ID_CUST); //210
			unitSelMap = ccpCalculateMapper.comboUnitSelectValue(params);
			fieldMap.put("custUnitSelVal", unitSelMap.get("screEventId"));
			
			// 3. customer Unit Point
		//	tempBigDecimal = (BigDecimal)unitSelMap.get("screEventId");
			params.put("orderUnit", orderSelValue); // orderSelValue  // tempBigDecimal.intValue()
			pointMap = ccpCalculateMapper.getScorePointByEventID(params);
			fieldMap.put("custUnitPoint", pointMap.get("screEventPoint"));
			
			custUnitPoint =  Double.parseDouble(String.valueOf(pointMap.get("screEventPoint")));
			
		} // If Else End
		
		resultTotPoint = orderUnitPoint + rosUnitPoint + susUnitPoint + custUnitPoint; //TOT
		
		fieldMap.put("totUnitPoint", resultTotPoint);
		
		return fieldMap;
	}


	@Override
	public List<EgovMap> getCcpStusCodeList() throws Exception {
		
		return ccpCalculateMapper.getCcpStusCodeList();
	}


	@Override
	public List<EgovMap> getLoadIncomeRange(Map<String, Object> params) throws Exception {
		
		// 1. param : custId  Check
		LOGGER.info("########## getLoadIncomeRange `s   params : " + params.toString());
		// 2 . basic Query
		EgovMap ccpInfoMap = null;
		ccpInfoMap = ccpCalculateMapper.getCcpByCcpId(params);
		
		// 3. Params Setting
		if(ccpInfoMap == null){ 
			params.put("rentPayModeId", "0");
			params.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); //individual
		}else{
			params.put("rentPayModeId", ccpInfoMap.get("modeId"));
			
			BigDecimal schemeTypeId = (BigDecimal)ccpInfoMap.get("ccpSchemeTypeId");
			
			if(schemeTypeId.intValue() == 1){
				params.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_COMPANY); //company
			}else{
				params.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); //individual
			}
		}
		
		return ccpCalculateMapper.getIncomeRangeList(params);
	}


	@Override
	public Map<String, Object> selectLoadIncomeRange(Map<String, Object> params) throws Exception {
		
		Map<String, Object> incMap = new HashMap<String, Object>();
		
		EgovMap ccpInfoMap = null;
		ccpInfoMap = ccpCalculateMapper.getCcpByCcpId(params);
		
		if(ccpInfoMap == null){ 
			incMap.put("rentPayModeId", "0");
			incMap.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); //individual
		}else{
			incMap.put("rentPayModeId", ccpInfoMap.get("modeId"));
			
			BigDecimal schemeTypeId = (BigDecimal)ccpInfoMap.get("ccpSchemeTypeId");
			
			if(schemeTypeId.intValue() == 1){
				incMap.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_COMPANY); //company
			}else{
				incMap.put("applicantTypeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); //individual
			}
		}
		
		return incMap;
	}


	@Override
	public EgovMap selectCcpInfoByCcpId(Map<String, Object> params) throws Exception {
		
		return ccpCalculateMapper.selectCcpInfoByCcpId(params);
	}


	@Override
	public EgovMap selectSalesManViewByOrdId(Map<String, Object> params) throws Exception {
		
		return ccpCalculateMapper.selectSalesManViewByOrdId(params);
	}


	@Override
	public List<EgovMap> getCcpRejectCodeList() throws Exception {
		
		return ccpCalculateMapper.getCcpRejectCodeList();
	}
	
}
