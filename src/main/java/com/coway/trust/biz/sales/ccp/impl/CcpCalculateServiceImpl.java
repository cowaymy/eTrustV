package com.coway.trust.biz.sales.ccp.impl;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.CcpCalculateService;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ccpCalculateService")
public class CcpCalculateServiceImpl extends EgovAbstractServiceImpl implements CcpCalculateService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCalculateServiceImpl.class);

	@Resource(name = "ccpCalculateMapper")
	private CcpCalculateMapper ccpCalculateMapper;

	@Value("${web.resource.upload.file}")
	private String webPath;

	@Autowired
    private FileService fileService;

	@Autowired
    private FileMapper fileMapper;

	@Override
	public List<EgovMap> getRegionCodeList(Map<String, Object> params) throws Exception {

		return ccpCalculateMapper.getRegionCodeList(params);
	}


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
		params.put("groupCode", params.get("editCcpId"));
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
		params.put("groupCode", params.get("ccpId"));
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


	@Override
	public EgovMap countCallEntry(Map<String, Object> params) throws Exception {

		return ccpCalculateMapper.countCallEntry(params);
	}


	@Override
	@Transactional
	public void calSave(Map<String, Object> params) throws Exception {

		List<EgovMap> ccpDesList = null;
		EgovMap desMap = null;
		EgovMap cancelMap = null;
		EgovMap itmMap = null;
		double totalOutstanding = 0;
		BigDecimal tempoVal = null;
		EgovMap accMap = null;
		String logseq = "";
		String InsSeq = "";
		String resultSeq = "";
		String callSeq = "";

		//1. Update CCP Decision <Update Data.CcpDecisionM>
		LOGGER.info("_________________________________________________________________________________________");
		LOGGER.info("_______________  // 1. Update CCP Decision <Update Data.CcpDecisionM> Start _________________________");
		LOGGER.info("_________________________________________________________________________________________");

		//params Tranlate  969// 970  > saveCustTypeId
		if(SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL.equals(String.valueOf(params.get("saveCustTypeId")))){  // 964
			params.put("saveCustTypeId", SalesConstants.CCP_SCHEME_TYPE_CODE_ID_ICS);
		}else{
			params.put("saveCustTypeId", SalesConstants.CCP_SCHEME_TYPE_CODE_ID_CCS);
		}

		ccpCalculateMapper.updateCcpDecision(params);

		LOGGER.info("_________________________________________________________________________________________");
		LOGGER.info("_______________ // 1. Update CCP Decision <Update Data.CcpDecisionM> End _________________________");
		LOGGER.info("_________________________________________________________________________________________");

		ccpDesList = ccpCalculateMapper.getCcpDecisionList(params);

		// 1. Update  <Data.CcpDecisionD>
		if(ccpDesList != null && ccpDesList.size() > 0){
			for (int idx = 0; idx < ccpDesList.size(); idx++) {
				desMap  = ccpDesList.get(idx);
				if(!(SalesConstants.CCP_ITM_STUS_UPD).equals(desMap.get("ccpItmStusId"))){
					desMap.put("ccpItmStusId", SalesConstants.CCP_ITM_STUS_UPD); // 8
					LOGGER.info("_________________________________________________________________________________________");
					LOGGER.info("_______________ // 2 -"+ idx +" Update  <Data.CcpDecisionD>Start _________________________");
					LOGGER.info("_________________________________________________________________________________________");
					ccpCalculateMapper.updateCcpDecisionStatus(desMap);
					LOGGER.info("_________________________________________________________________________________________");
					LOGGER.info("_______________ // 2 -"+ idx +" Update  <Data.CcpDecisionD> End _________________________");
					LOGGER.info("_________________________________________________________________________________________");
				}
			}
		}

		// 2. Insert <Data.CcpDecisionD>
		params.put("insCcpItmStusId", SalesConstants.CCP_ITM_STUS_INS); // 1
		//ord
		if(null != params.get("saveOrdUnit") && null != params.get("saveOrdCount") && null != params.get("saveOrdPoint")){

			params.put("insCcpScreEventId", params.get("saveOrdUnit"));
			params.put("insCcpItmScreUnit", params.get("saveOrdCount"));
			params.put("insCcpItmPointScre", params.get("saveOrdPoint"));
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 3 -1. Insert <Data.CcpDecisionD>  //ord  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
			ccpCalculateMapper.insertCcpDecision(params);
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 3 - 1. Insert <Data.CcpDecisionD>  //ord  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

		}
		//ros
		if(null != params.get("saveRosUnit") && null != params.get("saveRosCount") && null != params.get("saveRosPoint")){

			params.put("insCcpScreEventId", params.get("saveRosUnit"));
			params.put("insCcpItmScreUnit", params.get("saveRosCount"));
			params.put("insCcpItmPointScre", params.get("saveRosPoint"));
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 3 - 2. Insert <Data.CcpDecisionD>  //ros  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
			ccpCalculateMapper.insertCcpDecision(params);
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 3 - 2. Insert <Data.CcpDecisionD>  //ros  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

		}
		//sus
		if(null != params.get("saveSusUnit") && null != params.get("saveSusCount") && null != params.get("saveSusPoint")){

			params.put("insCcpScreEventId", params.get("saveSusUnit"));
			params.put("insCcpItmScreUnit", params.get("saveSusCount"));
			params.put("insCcpItmPointScre", params.get("saveSusPoint"));
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 3 -3 . Insert <Data.CcpDecisionD>  //sus  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
			ccpCalculateMapper.insertCcpDecision(params);
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 3 - 3. Insert <Data.CcpDecisionD>  //sus  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

		}
		//cust
		if(null != params.get("saveCustUnit") && null != params.get("saveCustCount") && null != params.get("saveCustPoint")){

			params.put("insCcpScreEventId", params.get("saveCustUnit"));
			params.put("insCcpItmScreUnit", params.get("saveCustCount"));
			params.put("insCcpItmPointScre", params.get("saveCustPoint"));
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 3 - 4. Insert <Data.CcpDecisionD>  //cust  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
			ccpCalculateMapper.insertCcpDecision(params);
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 3 - 4. Insert <Data.CcpDecisionD>  //cust  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");


		}

		if(!("0").equals(params.get("eRstatusEdit"))){
			LOGGER.info("_______________eRstatusEdit_______________");
			ccpCalculateMapper.updateCcpEresubmitStus(params);
		}

		// Cancel Selected
		/*####  Reject Status    Data.SalesOrderM  ####*/
		if( ("10").equals(params.get("rejectStatusEdit")) || ("17").equals(params.get("rejectStatusEdit")) || ("18").equals(params.get("rejectStatusEdit"))){

			//ordStusId
			params.put("ordStusId", SalesConstants.ORD_STATUS_UPD); // 10
			params.put("ordRem", SalesConstants.ORD_REM); //  "CCP Reject Cancel"
			params.put("syncChk", SalesConstants.ORD_SYNC_CHK); // 0
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 - Cancel - 1 Reject Status    Data.SalesOrderM  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
			ccpCalculateMapper.updateOrdStus(params);  // Condition if (salesorderM != null && salesorderM.SalesOrderID > 0)
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 - Cancel - 1 Reject Status    Data.SalesOrderM  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

			//ord Map

			cancelMap = ccpCalculateMapper.getCancelOrd(params);  //  Map 1
			itmMap = ccpCalculateMapper.getCancelItm(params);  //Map 2
			//Cancel Order

			LOGGER.info("################################################# APP_TYPE_ID :  " + cancelMap.get("appTypeId"));

			BigDecimal appTypeDecimal = null;
			appTypeDecimal = (BigDecimal)cancelMap.get("appTypeId");

			if(appTypeDecimal.intValue() == 66 ){
				//Rent
				accMap = ccpCalculateMapper.getAccRentLedgerAmt(params);  // if (updatesalesOrderM.AppTypeID == 66)

				if(accMap == null){
					totalOutstanding = 0;
				}else{
					tempoVal = (BigDecimal)accMap.get("rentAmt");
					totalOutstanding = tempoVal.doubleValue();
				}

			}else{
				//Trade
				accMap = ccpCalculateMapper.getAccTradeLedgerAmt(params); //  else
				if(accMap == null){
					totalOutstanding = 0;
				}else{
					tempoVal = (BigDecimal)accMap.get("tradeAmt");
					totalOutstanding = tempoVal.doubleValue();
				}
			}

			//Cancel Insert
			//params Set
			params.put("soReqStatusId", SalesConstants.SO_REQ_STATUS_ID);  // 32

			if(("4").equals(cancelMap.get("stusCodeId"))){
				params.put("soReqCurStatusId", SalesConstants.SO_REQ_CUR_STATUS_ID_SEC); //25
			}else{
				params.put("soReqCurStatusId", SalesConstants.SO_REQ_CUR_STATUS_ID); //24
			}

			params.put("soReqReasonId", SalesConstants.SO_REQ_REASON_ID); // 1996
			params.put("soReqPrevCallEntryId", SalesConstants.SO_REQ_PREV_CALL_ENTRY_ID); // 0
			params.put("soReqCurCallEntryId", SalesConstants.SO_REQ_CUR_CALL_ENTRY_ID); //0  //Need Update?

			if(itmMap.get("itmStkId") != null){
				params.put("soReqCurStkId", itmMap.get("itmStkId"));
			}else{
				params.put("soReqCurStkId", "0");
			}


			InsSeq = ccpCalculateMapper.crtSeqSAL0020D(); //Insert Sequence

			params.put("soReqSeq", InsSeq);
			params.put("soReqCurAppTypeId", "0");  //TODO ASIS Query Need Confirm
			params.put("soReqCurAmt", "0");  //TODO ASIS Query Need Confirm
			params.put("soReqCurPv", "0"); //TODO ASIS Query Need Confirm
			params.put("soReqCurRentAmt", "0"); //TODO ASIS Query Need Confirm
			params.put("soReqCancelTotalOutstanding", totalOutstanding);
			params.put("soReqCancelPenaltyAmt", SalesConstants.SO_REQ_CANCEL_PENALTY_AMT); //0
			params.put("soReqCancelObPeriod", SalesConstants.SO_REQ_CANCEL_OB_PERIOD); // 0
            params.put("soReqCancelIsUnderCoolPeriod", SalesConstants.SO_REQ_CANCEL_IS_UNDER_COOL_PERIOD); // 0
            params.put("soReqCancelRentalOutstanding", totalOutstanding);
            params.put("soReqCancelTotalUsePeriod", SalesConstants.SO_REQ_CANCEL_TOTAL_USE_PERIOD); // 0
            params.put("soReqNo", SalesConstants.SO_REQ_NO);
            params.put("soReqCancelAdjustmentAmt", SalesConstants.SO_REQ_CANCEL_ADJUSTMENT_AMT);
            params.put("soRequestor", SalesConstants.SO_REQ_REQUESTOR);
            params.put("soReqPreReturnDate", SalesConstants.DEFAULT_DATE);
            params.put("soReqRemark", SalesConstants.ORD_REM);

            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 - 2Cancel Reject Status    Data.SalesOrderM  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
            ccpCalculateMapper.insertOrderCancel(params); //Ins Cancel
            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 - 2Cancel Reject Status    Data.SalesOrderM  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

            //Call Entry Insert

            callSeq = ccpCalculateMapper.crtSeqCCR0006D();
            params.put("callEntrySeq", callSeq); //Seq
            params.put("callEntryTypeId", SalesConstants.CALL_ENTRY_TYPE_ID); // 259
            params.put("callEntryStusCodeId", SalesConstants.CALL_ENTRY_MASTER_STUS_CODE_ID); // 32
            params.put("callEntryMasterResultId", SalesConstants.CALL_ENTRY_MASTER_RESULT_ID); //0
            params.put("callEntryDocId", InsSeq);
            params.put("callEntryMasterIsWaitForCancel", SalesConstants.CALL_ENTRY_MASTER_IS_WAIT_FOR_CANCEL); // CallEntryMaster.IsWaitForCancel = false;
            params.put("callEntryMasterHappyCallerId", SalesConstants.CALL_ENTRY_MASTER_HAPPY_CALL_ID);  //CallEntryMaster.HappyCallerID = 0;

            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 -  3 Cancel Reject Status    Data.SalesOrderM  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
            ccpCalculateMapper.insertCallEntry(params); //Ins Entry
            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 - 3 Cancel Reject Status    Data.SalesOrderM  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

            //Call Result Insert

            resultSeq = ccpCalculateMapper.crtSeqCCR0007D();
            params.put("callResultSeq", resultSeq);
            params.put("callResultEntryId", callSeq);
            params.put("callResultCallStatusId", SalesConstants.CALL_RESULT_DETAILS_CALL_STATUS_ID);
            params.put("callResultCallFeedbackId", SalesConstants.CALL_RESULT_DETAILS_CALL_FEEDBACK_ID);
            params.put("callResultCallCtId", SalesConstants.CALL_RESULT_DETAILS_CALL_CT_ID);
            params.put("callResultCallRem", SalesConstants.CALL_RESULT_DETAILS_CALL_REM);
            params.put("callResultCrtByDept", SalesConstants.CALL_RESULT_DETAILS_CREATE_BY_DEPT);
            params.put("callResultCallHcId", SalesConstants.CALL_RESULT_DETAILS_CALL_HC_ID);
            params.put("callResultCallRosAmt", SalesConstants.CALL_RESULT_DETAILS_CALL_ROS_AMT);
            params.put("callResultCallSms", SalesConstants.CALL_RESULT_DETAILS_CALL_SMS);
            params.put("callResultCallSmsRem", SalesConstants.CALL_RESULT_DETAILS_CALL_SMS_REM);

            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 - 4 Cancel Reject Status    Data.SalesOrderM  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
            ccpCalculateMapper.insertCallResult(params); //Ins Result
            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 -  4Cancel Reject Status    Data.SalesOrderM  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

            //Call Entry Update
            params.put("updCallEntryResultId" , resultSeq);
            params.put("updCallEntryId", callSeq);

            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 -  5Cancel Reject Status    Data.SalesOrderM  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
            ccpCalculateMapper.updateCallEntryId(params); //Upd 1
            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 -  5Cancel Reject Status    Data.SalesOrderM  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

            //OrdRequest Update
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 -  6Cancel Reject Status    Data.SalesOrderM  Start _________________________");
			LOGGER.info("_______________ Params : " + params.toString());
            ccpCalculateMapper.updateOrderRequest(params); //Upd 2
            LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 -  6Cancel Reject Status    Data.SalesOrderM  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

			//log - Cancel > Select  10 , 17 , 18
            logseq = ccpCalculateMapper.crtSeqSAL0009D();
            params.put("logSeq", logseq);
			params.put("logProgId", SalesConstants.SALES_ORDER_LOG_PRGID_CANCEL); //13
			params.put("logRefId", SalesConstants.SALES_ORDER_REF_ID); // 0
			params.put("logIsLock", SalesConstants.SALES_ORDER_IS_LOCK_CANCEL); //0

			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 - 7 Cancel Reject Status    Data.SalesOrderM  Start _________________________");
			LOGGER.info("_________________________________________________________________________________________");
			ccpCalculateMapper.insertLog(params);
			LOGGER.info("_________________________________________________________________________________________");
			LOGGER.info("_______________ // 4 - 7 Cancel Reject Status    Data.SalesOrderM  End _________________________");
			LOGGER.info("_________________________________________________________________________________________");

		}// Cancel Selected End


		 //Approve Selected
		 if( ("5").equals(params.get("statusEdit")) || ("13").equals(params.get("statusEdit"))  || ("14").equals(params.get("statusEdit"))){

			 //TODO  Logic Change by eCash Process

			 EgovMap eCashMap = null;

			 eCashMap = ccpCalculateMapper.chkECash(params);  // ECASH = 0  -> MODE_ID != 131 .... CHANGED BY LEE 2018.01.15
			 LOGGER.info("auxAppType : " + (params.get("auxAppType")));
             LOGGER.info("payMode : " + (params.get("payMode")));
			 //if(eCashMap != null && Integer.parseInt(String.valueOf(eCashMap.get("ecash"))) == 0){
			   if(eCashMap != null || (params.get("auxAppType") != null && params.get("payMode") != null ) ){
				//Call Entry Insert
				 callSeq = ccpCalculateMapper.crtSeqCCR0006D();
	             params.put("callEntrySeq", callSeq); //Seq
	             params.put("callEntryTypeId", SalesConstants.CALL_ENTRY_TYPE_ID_APPROVED); // 257
	             params.put("callEntryStusCodeId", SalesConstants.CALL_ENTRY_MASTER_STUS_CODE_ID_APPROVED); // 1
	             params.put("callEntryMasterResultId", SalesConstants.CALL_ENTRY_MASTER_RESULT_ID); //0
	             params.put("callEntryDocId", params.get("saveOrdId"));
	             params.put("callEntryMasterIsWaitForCancel", SalesConstants.CALL_ENTRY_MASTER_IS_WAIT_FOR_CANCEL); // CallEntryMaster.IsWaitForCancel = false;
	             params.put("callEntryMasterHappyCallerId", SalesConstants.CALL_ENTRY_MASTER_HAPPY_CALL_ID);  //CallEntryMaster.HappyCallerID = 0;

	             LOGGER.info("_________________________________________________________________________________________");
	 			 LOGGER.info("_______________ // 4 - 1 //Approve Selected    Data.SalesOrderM  Start _________________________");
	 			 LOGGER.info("_________________________________________________________________________________________");
	             ccpCalculateMapper.insertCallEntry(params); //Ins Entry
	             LOGGER.info("_________________________________________________________________________________________");
	  			 LOGGER.info("_______________ // 4 - 1 //Approve Selected    Data.SalesOrderM  End _________________________");
	  			 LOGGER.info("_________________________________________________________________________________________");

				 //log Select Aprove
				 logseq = ccpCalculateMapper.crtSeqSAL0009D();
			 	 params.put("logSeq", logseq);
				 params.put("logProgId", SalesConstants.SALES_ORDER_LOG_PRGID_APPROVED); // 2
				 params.put("logRefId", SalesConstants.SALES_ORDER_REF_ID); // 0
				 params.put("logIsLock", SalesConstants.SALES_ORDER_IS_LOCK_APPROVED); // 1

				 LOGGER.info("_________________________________________________________________________________________");
		 		 LOGGER.info("_______________ // 4 - 2 //Approve Selected    Data.SalesOrderM  Start _________________________");
		 		 LOGGER.info("_________________________________________________________________________________________");
				 ccpCalculateMapper.insertLog(params);
				 LOGGER.info("_________________________________________________________________________________________");
		 		 LOGGER.info("_______________ // 4 - 2 //Approve Selected    Data.SalesOrderM  End _________________________");
		 		 LOGGER.info("_________________________________________________________________________________________");
			 }
 		}

	}//Impl End


	@Override
	public Map<String, Object> getResultRowForCTOSDisplayForCCPCalculation(Map<String, Object> params) throws Exception {

		EgovMap rtnMap = ccpCalculateMapper.getResultRowForCTOSDisplayForCCPCalculation(params);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(rtnMap != null){
			if(rtnMap.get("resultRaw") != null){
				/*___Return Path___*/
				String subPath = SalesConstants.FICO_CTOS_REPORT_SUBPATH;
				String fileName = SalesConstants.FICO_CTOS_REPORT_FILENAME;

				/*___Result Raw___*/
				String resultRaw = String.valueOf(rtnMap.get("resultRaw"));
				InputStream is = new ByteArrayInputStream(resultRaw.getBytes());
				StreamSource source = new StreamSource(is);  // raw_data xml data

				/*___Style Sheet___*/
				String rePaht = "";

				LOGGER.info("________________________________params : " + params.toString());
				if(SalesConstants.FICO_VIEW_TYPE.equals(params.get("viewType"))){
					rePaht = "template/stylesheet/fico_report.xsl";
					LOGGER.info("_______________________________ FICO VIEW " + params.get("viewType"));
				}else{
					rePaht = "template/stylesheet/ctos_report.xsl";
					LOGGER.info("_______________________________ CTOS_VIEW " + params.get("viewType"));
				}
				LOGGER.info("###################### Style Sheet Path :   " + rePaht);

				org.springframework.core.io.Resource resource = new ClassPathResource(rePaht);
				//trim
				rePaht.trim();

				if(rePaht.startsWith("/")){
					rePaht = rePaht.substring(1);
				}

				//StreamSource stylesource = new StreamSource("C:/works/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp3/wtpwebapps/etrust/WEB-INF/classes/template/stylesheet/ctos_report.xsl"); // xsl file...
				StreamSource stylesource = new StreamSource(resource.getFile()); // xsl file...
				TransformerFactory factory = TransformerFactory.newInstance();
				Transformer transformer = factory.newTransformer(stylesource);

				//String htPath = resourceLoader.getResource("resources/WebShare/"+subPath+"/"+fileName).getURI().getPath();
				String htPath = webPath+"/"+subPath+"/"+fileName;

				LOGGER.info("########################### HTML PATH : " + htPath);

				File file = new File(htPath);
				if(!file.getParentFile().exists()){
					LOGGER.info("######## Not Found File!!!!");
					//make dir
					file.getParentFile().mkdirs();
					// make file
					FileWriter fileWriter = new FileWriter(file);
					BufferedWriter out = new BufferedWriter(fileWriter);
					out.flush();
					out.close();
				}

				StreamResult result = new StreamResult(new File(htPath)); //result html
				transformer.transform(source, result);

				resultMap.put("webPath", webPath);
				resultMap.put("subPath", subPath);
				resultMap.put("fileName", fileName);
			}
		}
		return resultMap;
	}


	@Override
	public List<EgovMap> getCcpInstallationList(Map<String, Object> params) throws Exception {

		return ccpCalculateMapper.getCcpInstallationList(params);
	}


  @Override
  public  EgovMap getAux(Map<String, Object> params) {
    return ccpCalculateMapper.getAux(params);
  }

  	@Override
	public EgovMap selectCcpInfoByOrderId(Map<String, Object> params) throws Exception {

		return ccpCalculateMapper.selectCcpInfoByOrderId(params);
	}

  	@Override
    public List<EgovMap> ccpEresubmitNewConfirm(Map<String, Object> params) {
      return ccpCalculateMapper.ccpEresubmitNewConfirm(params);
    }

  	@Override
    public List<EgovMap> ccpEresubmitList(Map<String, Object> params) throws Exception{
        return ccpCalculateMapper.ccpEresubmitList(params);
      }

  	@Override
	public void ccpEresubmitNewSave(Map<String, Object> params) throws Exception {
  		ccpCalculateMapper.insertCcpEresubmitNewSave(params);
  	}

  	@Override
	public void updateCcpEresubmitAttach(Map<String, Object> params) throws Exception {
  		ccpCalculateMapper.updateCcpEresubmitAttach(params);
  	}

  	@Override
	public void updatePreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params.toString());
		LOGGER.debug("list.size : {}", list.size());
		String update = (String) params.get("update");
		String remove = (String) params.get("remove");
		String[] updateList = null;
		String[] removeList = null;
		if(!StringUtils.isEmpty(update)) {
			updateList = params.get("update").toString().split(",");
			LOGGER.debug("updateList.length : {}", updateList.length);
		}
		if(!StringUtils.isEmpty(remove)) {
			removeList = params.get("remove").toString().split(",");
			LOGGER.debug("removeList.length : {}", removeList.length);
		}
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			for(int i = 0; i < list.size(); i++) {
				if(updateList != null && i < updateList.length) {
					String atchFileId = updateList[i];
					fileService.changeFileUpdate(Integer.parseInt(String.valueOf(params.get("atchFileGrpId"))), Integer.parseInt(atchFileId), list.get(i), type, Integer.parseInt(String.valueOf(params.get("userId"))));
				}
				else {
					//int fileGroupId = (Integer.parseInt(params.get("atchFileGrpId").toString()));
					int fileGroupId = params.get("atchFileGrpId") != null ? params.get("atchFileGrpId").toString().equals("") ? 0 : (Integer.parseInt(params.get("atchFileGrpId").toString())) : 0 ;

					if(fileGroupId == 0){
						fileGroupId = fileMapper.selectFileGroupKey();
						params.put("atchFileGrpId", fileGroupId);
					}
					this.insertFile(fileGroupId, list.get(i), type,params, seqs.get(i));
				}
			}
		}
		if(removeList != null && removeList.length > 0){
			for(String id : removeList){
				LOGGER.info(id);
				String atchFileId = id;
				fileService.removeFileByFileId(type, Integer.parseInt(atchFileId));
			}
		}
	}

  	@Override
	public void insertPreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileMapper.selectFileGroupKey();
		AtomicInteger i = new AtomicInteger(0); // get seq key.

		list.forEach(r -> {this.insertFile(fileGroupKey, r, type, params, seqs.get(i.getAndIncrement()));});
		params.put("fileGroupKey", fileGroupKey);
	}

	public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params,String seq) {
        LOGGER.debug("insertFile :: Start");

        int atchFlId = ccpCalculateMapper.selectNextFileId();

        FileGroupVO fileGroupVO = new FileGroupVO();

        Map<String, Object> flInfo = new HashMap<String, Object>();
        flInfo.put("atchFileId", atchFlId);
        flInfo.put("atchFileName", flVO.getAtchFileName());
        flInfo.put("fileSubPath", flVO.getFileSubPath());
        flInfo.put("physiclFileName", flVO.getPhysiclFileName());
        flInfo.put("fileExtsn", flVO.getFileExtsn());
        flInfo.put("fileSize", flVO.getFileSize());
        flInfo.put("filePassword", flVO.getFilePassword());
        flInfo.put("fileUnqKey", params.get("claimUn"));
        flInfo.put("fileKeySeq", seq);

        ccpCalculateMapper.insertFileDetail(flInfo);

        fileGroupVO.setAtchFileGrpId(fileGroupKey);
        fileGroupVO.setAtchFileId(atchFlId);
        fileGroupVO.setChenalType(flType.getCode());
        fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
        fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));

        fileMapper.insertFileGroup(fileGroupVO);

        LOGGER.debug("insertFile :: End");
    }

	@Override
	public EgovMap selectCcpEresubmit(Map<String, Object> params) throws Exception {

		return ccpCalculateMapper.selectCcpEresubmit(params);
	}

	@Override
	  public int getMemberID(Map<String, Object> params) {
	      return ccpCalculateMapper.getMemberID(params);
	  }
}
