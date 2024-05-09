package com.coway.trust.biz.services.as.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.services.RegistrationConstants;
import com.coway.trust.api.mobile.services.as.ASFailJobRequestDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.ServiceApiASDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.DecimalFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ServiceApiHSDetailServiceImpl.java
 * @Description : Mobile Heart Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 20.   Jun             First creation
 * 2020. 02. 26.   ONGHC        Amend asResultProc to add PSI and LPM
 */
@Service("serviceApiASDetailService")
public class ServiceApiASDetailServiceImpl extends EgovAbstractServiceImpl implements ServiceApiASDetailService {
	private static final Logger logger = LoggerFactory.getLogger(ServiceApiASDetailServiceImpl.class);

	@Resource(name = "ASManagementListService")
	private ASManagementListService ASManagementListService;

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	@Override
	public ResponseEntity<AfterServiceResultDto> asResultProc(Map<String, Object> insApiresult) throws Exception {
		String transactionId = "";
		String serviceNo = "";

	    Calendar cal = Calendar.getInstance();

	    StringBuffer today2 = new StringBuffer();
	    today2.append(String.format("%02d", cal.get(cal.DATE)));
	    today2.append(String.format("%02d", cal.get(cal.MONTH) + 1));
	    today2.append(String.format("%04d", cal.get(cal.YEAR)));

	    String toSetlDt = today2.toString();

	    Date todate = new Date();
	    Calendar today1 = Calendar.getInstance();

	    SimpleDateFormat transFormat = new SimpleDateFormat("dd-mm-yyyy");
	    SimpleDateFormat transFormatYY = new SimpleDateFormat("yyyymmdd");
	    SimpleDateFormat transFormat1 = new SimpleDateFormat("ddmmyyyy");
	    SimpleDateFormat transFormatHH = new SimpleDateFormat("HHmmss");

	    String ddMMCurDate = transFormat.format(new Date());
	    String curDate = transFormatYY.format(new Date());
	    String curTime = transFormatHH.format(new Date());

	    logger.info("++++ asResultProc insApiresult", insApiresult);


	    transactionId = String.valueOf(insApiresult.get("transactionId"));
		serviceNo = String.valueOf(insApiresult.get("serviceNo"));

        // SVC0001D CHECK IF MEM_CODE AND MEM_CODE ARE THE SAME
        int asResultMemId = ASManagementListService.asResultSync(insApiresult);

        if (asResultMemId > 0) {
        	// RESULT CHECK HS IS ACTIVE
        	int isAsCnt = ASManagementListService.isAsAlreadyResult(insApiresult);

        	// IF THERE IS NO RESULT
        	if (isAsCnt == 0) {
        		Map<String, Object> afterServiceDetail = null;

        		List<Map<String, Object>> paramsDetail = AfterServiceResultDetailForm.createMaps((List<AfterServiceResultDetailForm>) insApiresult.get("partList"));

        		logger.debug("### AS PART INFO : " + paramsDetail.toString());

        		List<Map<String, Object>> paramsDetailCvt = new ArrayList<Map<String, Object>>();

        		double totPrc = 0.00;

        		logger.debug("### AS PART SIZE : " + paramsDetail.size());
        		for (int x = 0; x < paramsDetail.size(); x++) {
        			// CHECKING STOCK
        			if (!("".equals(CommonUtils.nvl(paramsDetail.get(x).get("filterCode").toString())))) {
        				Map<String, Object> locInfoEntry = new HashMap<String, Object>();
        				locInfoEntry.put("CT_CODE", CommonUtils.nvl(insApiresult.get("userId").toString()));
        				locInfoEntry.put("STK_CODE", CommonUtils.nvl(paramsDetail.get(x).get("filterCode").toString()));

        				EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);

        				logger.debug("LOC. INFO. : {}" + locInfo);
        				if (locInfo != null) {
        					if(Integer.parseInt(locInfo.get("availQty").toString()) < 1){
        						// FAIL CT NOT ENOUGH STOCK
        						MSvcLogApiService.updateASErrStatus(transactionId);

        						Map<String, Object> m = new HashMap();
        						m.put("APP_TYPE", "AS");
        						m.put("SVC_NO", insApiresult.get("serviceNo"));
        						m.put("ERR_CODE", "03");
        						m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] STOCK FOR [" + paramsDetail.get(x).get("filterCode").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString());
        						m.put("TRNSC_ID", transactionId);

        						MSvcLogApiService.insert_SVC0066T(m);

        						String procTransactionId = transactionId;
        						String procName = "AfterService";
        						String procKey = serviceNo;
        						String procMsg = "PRODUCT STOCK UNAVAILABLE";
        						String errorMsg = "[API] [" + insApiresult.get("userId") + "] STOCK FOR [" + paramsDetail.get(x).get("filterCode").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString();
        						throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        					}
        				}
        				else {
        					// FAIL CT NOT ENOUGH STOCK
        					MSvcLogApiService.updateASErrStatus(transactionId);

        					Map<String, Object> m = new HashMap();
        					m.put("APP_TYPE", "AS");
        					m.put("SVC_NO", insApiresult.get("serviceNo"));
        					m.put("ERR_CODE", "03");
        					m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] STOCK FOR [" + paramsDetail.get(x).get("filterCode").toString() + "] IS UNAVAILABLE. ");
        					m.put("TRNSC_ID", transactionId);

        					MSvcLogApiService.insert_SVC0066T(m);

        					String procTransactionId = transactionId;
    						String procName = "AfterService";
    						String procKey = serviceNo;
    						String procMsg = "PRODUCT STOCK UNAVAILABLE";
    						String errorMsg = "[API] [" + insApiresult.get("userId") + "] STOCK FOR [" + paramsDetail.get(x).get("filterCode").toString() + "] IS UNAVAILABLE. ";
    						throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        				}
        			}

        			Map<String, Object> map = new HashMap<String, Object>();

        			map.put("filterDesc", "API");
        			if (paramsDetail.get(x).get("filterCode") == null || "".equals(paramsDetail.get(x).get("filterCode"))) {
        				map.put("filterID", paramsDetail.get(x).get("filterCode"));
        			}
        			else {
        				map.put("filterID", paramsDetail.get(x).get("filterCode"));
        			}

        			if (paramsDetail.get(x).get("exchangeId") == null) {
        				map.put("filterExCode", 0);
        			}
        			else {
        				map.put("filterExCode", paramsDetail.get(x).get("exchangeId"));
        			}

        			if (paramsDetail.get(x).get("filterChangeQty") == null) {
        				map.put("filterQty", 0);
        			}
        			else {
        				map.put("filterQty", String.valueOf(paramsDetail.get(x).get("filterChangeQty")));
        			}

        			if (paramsDetail.get(x).get("salesPrice") == null) {
        				map.put("filterPrice", 0);
        			}
        			else {
        				map.put("filterPrice", paramsDetail.get(x).get("salesPrice"));
        			}

        			int foc = CommonUtils.intNvl(paramsDetail.get(x).get("chargesFoc"));

        			if (foc == 1) {
        				map.put("filterType", "FOC");
        			}
        			else {
        				map.put("filterType", String.valueOf(paramsDetail.get(x).get("chargesFoc")));
        			}

        			if (paramsDetail.get(x).get("filterBarcdSerialNo") == null) {
        				map.put("srvFilterLastSerial", "");
        			}
        			else {
        				map.put("srvFilterLastSerial", paramsDetail.get(x).get("filterBarcdSerialNo"));
        			}

        			int qty = Integer.parseInt(String.valueOf(paramsDetail.get(x).get("filterChangeQty")));
        			double filterPrice = Double.parseDouble(String.valueOf(paramsDetail.get(x).get("salesPrice")));

        			double amt = 0.00;

        			if (foc == 0) {
        				amt = qty * filterPrice;
        				totPrc = totPrc + amt;
        			}

        			map.put("filterRemark", "");
        			map.put("filterTotal", amt);

        			map.put("retSmoSerialNo", "");
        			map.put("isSmo", "N");
        			map.put("isSerialReplace", "N");

        			logger.debug("### AS PART : " + map.toString());

        			paramsDetailCvt.add(map);
        		}

        		/*
        		 * Map<String , Object> paramsFilter = paramsDetail.get(i);
        		 * paramsDetail.get(i).put("filterType",
        		 * String.valueOf(paramsDetail.get(i).get("partsType")));
        		 * paramsDetail.get(i).put("filterDesc", "API");
        		 *
        		 * if(paramsDetail.get(i).get("filterCode")== null ||
        		 * "".equals(paramsDetail.get(i).get("filterCode"))){
        		 * paramsDetail.get(i).put("filterExCode", 0); }else{
        		 * paramsDetail.get(i).put("filterExCode",
        		 * paramsDetail.get(i).get("filterCode")); }
        		 *
        		 * if(paramsDetail.get(i).get("filterChangeQty")==null){
        		 * paramsDetail.get(i).put("filterQty", 0); }else{
        		 * paramsDetail.get(i).put("filterQty",
        		 * String.valueOf(paramsDetail.get(i).get("filterChangeQty"))); }
        		 *
        		 * if(paramsDetail.get(i).get("salesPrice")==null){
        		 * paramsDetail.get(i).put("filterPrice", 0); }else{
        		 * paramsDetail.get(i).put("filterPrice",
        		 * paramsDetail.get(i).get("salesPrice")); }
        		 *
        		 * paramsDetail.get(i).put("filterRemark", "");
        		 * paramsDetail.get(i).put("filterID",
        		 * paramsDetail.get(i).get("filterCode") );
        		 * paramsDetail.get(i).put("filterTotal", "1");
        		 */

        		Map<String, Object> params = insApiresult;
        		logger.debug("### AS PARAM [BEFORE]: " + params.toString());

        		Map<String, Object> getAsBasic = MSvcLogApiService.getAsBasic(params);

        		if (getAsBasic.get("asSoId") != null) {
        			params.put("AS_SO_ID", String.valueOf(getAsBasic.get("asSoId")));
        		}
        		else {
        			params.put("AS_SO_ID", "");
        		}

        		if (getAsBasic.get("userId") != null) {
        			params.put("AS_CT_ID", String.valueOf(getAsBasic.get("userId")));
        		}
        		else {
        			params.put("AS_CT_ID", "");
        		}

        		params.put("AS_RESULT_STUS_ID", '4');

        		// params.put("AS_FAIL_RESN_ID", getAsBasic.get("as_failResnId"));
        		params.put("AS_REN_COLCT_ID", 0);

        		if (getAsBasic.get("asCmms") != null) {
        			params.put("AS_CMMS", String.valueOf(getAsBasic.get("asCmms")));
        		}
        		else {
        			params.put("AS_CMMS", "0");
        		}

        		if (getAsBasic.get("asBrnchId") != null) {
        			params.put("AS_BRNCH_ID", String.valueOf(getAsBasic.get("asBrnchId")));
        		}
        		else {
        			params.put("AS_BRNCH_ID", "");
        		}

        		if (getAsBasic.get("asWhId") != null) {
        			params.put("AS_WH_ID", String.valueOf(getAsBasic.get("asWhId")));
        		}
        		else {
        			params.put("AS_WH_ID", "");
        		}

        		if (getAsBasic.get("asMalfuncId") != null) {
        			params.put("AS_MALFUNC_ID", String.valueOf(getAsBasic.get("asMalfuncId")));
        		}
        		else {
        			params.put("AS_MALFUNC_ID", "");
        		}

        		if (getAsBasic.get("asMalfuncResnId") != null) {
        			params.put("AS_MALFUNC_RESN_ID", String.valueOf(getAsBasic.get("asMalfuncResnId")));
        		}
        		else {
        			params.put("AS_MALFUNC_RESN_ID", "");
        		}

        		params.put("AS_DEFECT_GRP_ID", 0);
        		params.put("AS_DEFECT_PART_GRP_ID", 0);
        		params.put("AS_ACSRS_AMT", 0);
        		params.put("AS_FILTER_AMT", totPrc);

        		double totamt = 0.00;
        		try {
        			totamt = Double.parseDouble(String.valueOf(insApiresult.get("labourCharge")));
        		}
        		catch (Exception e) {
        			totamt = 0.00;
        		}

        		params.put("AS_TOT_AMT", totPrc + totamt);
        		params.put("AS_RESULT_IS_SYNCH", 0);
        		params.put("AS_RCALL", 0);

        		if (getAsBasic.get("asResultStockUse") != null) {
        			params.put("AS_RESULT_STOCK_USE", String.valueOf(getAsBasic.get("asResultStockUse")));
        		}
        		else {
        			params.put("AS_RESULT_STOCK_USE", "");
        		}

        		params.put("AS_RESULT_TYPE_ID", 457);
        		params.put("AS_RESULT_IS_CURR", 1);
        		params.put("AS_RESULT_MTCH_ID", 0);
        		params.put("AS_RESULT_NO_ERR", "");
        		params.put("AS_ENTRY_POINT", 0);
        		params.put("AS_WORKMNSH_TAX_CODE_ID", 0);
        		params.put("AS_WORKMNSH_TXS", 0);
        		params.put("AS_RESULT_MOBILE_ID", 0);

        		if (!"".equals(getAsBasic.get("asResultNo"))) {
        			params.put("AS_RESULT_NO", String.valueOf(getAsBasic.get("asResultNo")));
        		}
        		else {
        			params.put("AS_RESULT_NO", "");
        		}

        		if (getAsBasic.get("asResultId") != null) {
        			params.put("AS_RESULT_ID", String.valueOf(getAsBasic.get("asResultId")));
        		}
        		else {
        			params.put("AS_RESULT_ID", "");
        		}

        		if (getAsBasic.get("asno") != null) {
        			params.put("AS_NO", String.valueOf(getAsBasic.get("asno")));
        		}
        		else {
        			params.put("AS_NO", "");
        		}

        		params.put("HC_REM", " ");

        		// 004
        		if (getAsBasic.get("asId") != null) {
        			params.put("AS_ENTRY_ID", String.valueOf(getAsBasic.get("asId")));
        		}
        		else {
        			params.put("AS_ENTRY_ID", "");
        		}

        		if (insApiresult.get("serviceNo") != null) {
        			params.put("AS_NO", String.valueOf(insApiresult.get("serviceNo")));
        		}
        		else {
        			params.put("AS_NO", "");
        		}

        		if (insApiresult.get("defectTypeId") != null) {
        			params.put("AS_DEFECT_TYPE_ID", String.valueOf(insApiresult.get("defectTypeId")));
        		}
        		else {
        			params.put("AS_DEFECT_TYPE_ID", "");
        		}

        		if (insApiresult.get("defectId") != null) {
        			params.put("AS_DEFECT_ID", String.valueOf(insApiresult.get("defectId")));
        		}
        		else {
        			params.put("AS_DEFECT_ID", "");
        		}

        		if (insApiresult.get("defectPartId") != null) {
        			params.put("AS_DEFECT_PART_ID", String.valueOf(insApiresult.get("defectPartId")));
        		}
        		else {
        			params.put("AS_DEFECT_PART_ID", "");
        		}

        		if (insApiresult.get("defectDetailReasonId") != null) {
        			params.put("AS_DEFECT_DTL_RESN_ID", String.valueOf(insApiresult.get("defectDetailReasonId")));
        		}
        		else {
        			params.put("AS_DEFECT_DTL_RESN_ID", "");
        		}

        		if (insApiresult.get("solutionReasonId") != null) {
        			params.put("AS_SLUTN_RESN_ID", String.valueOf(insApiresult.get("solutionReasonId")));
        		}
        		else {
        			params.put("AS_SLUTN_RESN_ID", "");
        		}

        		// params.put("AS_SETL_DT", todate2);
        		params.put("AS_SETL_DT", toSetlDt);
        		params.put("AS_SETL_TM", curTime);

        		if (insApiresult.get("labourCharge") != null) {
        			params.put("AS_WORKMNSH", String.valueOf(insApiresult.get("labourCharge")));
        		}
        		else {
        			params.put("AS_WORKMNSH", "");
        		}

        		params.put("AS_RESULT_REM", insApiresult.get("resultRemark"));
                params.put("AS_PSI", insApiresult.get("psiRcd"));
                params.put("AS_LPM", insApiresult.get("lpmRcd"));
                params.put("AS_UNMATCH_REASON", insApiresult.get("asUnmatchReason"));
                params.put("REWORK_PROJ", insApiresult.get("reworkProj"));
                params.put("WATER_SRC_TYPE", insApiresult.get("waterSrcType"));
                params.put("NTU", insApiresult.get("ntu"));
                params.put("INST_ACCS", insApiresult.get("instAccs"));
                params.put("INST_ACCS_VAL", insApiresult.get("instAccsVal"));
                //params.put("CHK_INSTALL_ACC", insApiresult.get("chkInstallAcc"));

        		if (insApiresult.get("inHouseRepairRemark") != null) {
        			params.put("IN_HUSE_REPAIR_REM", String.valueOf(insApiresult.get("inHouseRepairRemark")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_REM", "");
        		}

        		if (insApiresult.get("inHouseRepairReplacementYN") != null) {
        			params.put("IN_HUSE_REPAIR_REPLACE_YN", String.valueOf(insApiresult.get("inHouseRepairReplacementYN")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_REPLACE_YN", "");
        		}

        		Date inHouseRepairPromisedDate;
        		String inHouseRepairPromisedDate1 = "";

        		if (!"".equals(insApiresult.get("inHouseRepairPromisedDate"))) {
        			inHouseRepairPromisedDate = transFormatYY.parse(String.valueOf(insApiresult.get("inHouseRepairPromisedDate")));
        			inHouseRepairPromisedDate1 = transFormat1.format(inHouseRepairPromisedDate);
        		}

        		params.put("IN_HUSE_REPAIR_PROMIS_DT", inHouseRepairPromisedDate1);// asTransLogs

        		if (insApiresult.get("inHouseRepairProductGroupCode") != null) {
        			params.put("IN_HUSE_REPAIR_GRP_CODE", String.valueOf(insApiresult.get("inHouseRepairProductGroupCode")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_GRP_CODE", "");
        		}

        		if (insApiresult.get("inHouseRepairProductCode") != null) {
        			params.put("IN_HUSE_REPAIR_PRODUCT_CODE", String.valueOf(insApiresult.get("inHouseRepairProductCode")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_PRODUCT_CODE", "");
        		}

        		if (insApiresult.get("inHouseRepairSerialNo") != null) {
        			params.put("IN_HUSE_REPAIR_SERIAL_NO", String.valueOf(insApiresult.get("inHouseRepairSerialNo")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_SERIAL_NO", "");
        		}

        		params.put("RESULT_CUST_NAME", insApiresult.get("resultCustName"));// asTransLogs

        		if (insApiresult.get("resultIcMobileNo") != null) {
        			params.put("RESULT_MOBILE_NO", String.valueOf(insApiresult.get("resultIcMobileNo")));
        		}
        		else {
        			params.put("RESULT_MOBILE_NO", "");
        		}

        		if (insApiresult.get("resultReportEmailNo") != null) {
        			params.put("RESULT_REP_EMAIL_NO", String.valueOf(insApiresult.get("resultReportEmailNo")));
        		}
        		else {
        			params.put("RESULT_REP_EMAIL_NO", "");
        		}

        		if (insApiresult.get("resultAcceptanceName") != null) {
        			params.put("RESULT_ACEPT_NAME", String.valueOf(insApiresult.get("resultAcceptanceName")));
        		}
        		else {
        			params.put("RESULT_ACEPT_NAME", "");
        		}

        		params.put("SGN_DT", insApiresult.get("signData")); // asTransLogs

        		params.put("SERIAL_REQUIRE_CHK_YN", String.valueOf( insApiresult.get("serialRequireChkYn")));

        		// INST. ACCS LIST START
                List<Map<String, Object>> paramsDetailInstAccLst = AfterServiceResultDetailForm.createMaps((List<AfterServiceResultDetailForm>) insApiresult.get("installAccList"));
                logger.debug("### INST ACCS LIST INFO : " + paramsDetailInstAccLst.toString());
                //List lstStr = null;
                List<String> lstStr = new ArrayList<>();
                for (Map<String, Object> accLst : paramsDetailInstAccLst) {

                	logger.debug("accLst : " + accLst.size());
                  if (accLst != null) {
                    lstStr.add(String.valueOf(accLst.get("insAccPartId")));
                    logger.debug("### insAccPartIdT : " + String.valueOf(accLst.get("insAccPartId")));
                  }
                }
                logger.debug("### INST ACCS LIST SIZE : " + lstStr.size());

                params.put("instAccLst", lstStr); // remind of param instAccLst or
                // INST. ACCS LIST END

        		logger.debug("### AS PARAM [AFTER]: ", params);

        		Map<String, Object> asResultInsert = new HashMap();
        		asResultInsert.put("asResultM", params);
        		asResultInsert.put("updator", getAsBasic.get("updUsrId"));
        		asResultInsert.put("add", paramsDetailCvt); // FILTER LIST
        		asResultInsert.put("mobileYn", "Y");

        		logger.debug("### AS INSERT : " + asResultInsert.toString());

        		try {
        			EgovMap rtnValue = ASManagementListService.asResult_insert(asResultInsert);
        			if (null != rtnValue) {
        				HashMap spMap = (HashMap) rtnValue.get("spMap");
        				logger.debug("spMap :" + spMap.toString());
        				if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
        					rtnValue.put("logerr", "Y");
        				}

        				logger.debug("++++ String.valueOf( insApiresult.get('serialRequireChkYn')) ::" + String.valueOf( insApiresult.get("serialRequireChkYn")) );

    					if("Y".equals(  String.valueOf( insApiresult.get("serialRequireChkYn")) )){
            				// KR_HAN ADD
            				// SP_SVC_BARCODE_SAVE
            				params.put("scanSerial", String.valueOf(insApiresult.get("scanSerial")));
        					params.put("salesOrdId", String.valueOf(getAsBasic.get("salesOrdId")));
        					params.put("reqstNo", String.valueOf(rtnValue.get("asNo")));
        					params.put("delvryNo", null);
        					params.put("callGbn", "AS");
        					params.put("mobileYn", "Y");
        					params.put("userId", spMap.get("USERID").toString() );
        					params.put("pErrcode", "");
        					params.put("pErrmsg", "");
        					MSvcLogApiService.SP_SVC_BARCODE_SAVE(params);

        					logger.debug("+++ SP_SVC_BARCODE_SAVE params ::" + params.toString());

        					if (!"000".equals(params.get("pErrcode"))) {
        						String procTransactionId = transactionId;
        						String procName = "AfterService";
        						String procKey = serviceNo;
        						String procMsg = "Failed to Barcode Save";
        						String errorMsg = "[API] " + params.get("pErrmsg");
        						throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
    						}

        					spMap.put("pErrcode", "");
        					spMap.put("pErrmsg", "");
            				servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

            				String errCode = (String)spMap.get("pErrcode");
  	                	  	String errMsg = (String)spMap.get("pErrmsg");

  	                	  	logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCode);
  	                	  	logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsg);

  	                	  	// pErrcode : 000  = Success, others = Fail
  	                	  	if (!"000".equals(errCode)) {
  	                	  		throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
  	                	  	}
    					}else{
    						// SP_SVC_LOGISTIC_REQUEST COMMIT STRING DELETE
        					servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
    					}
        			}

        			if (RegistrationConstants.IS_INSERT_AS_LOG) {
        				MSvcLogApiService.updateSuccessASStatus(transactionId);
        			}
        		}
        		catch (Exception e) {
        			String procTransactionId = transactionId;
        			String procName = "AfterService";
        			String procKey = serviceNo;
        			String procMsg = "Failed to Save";
        			String errorMsg = "[API] " + e.toString();
        			throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        		}

        		// RESULT UPDATE TO STATE Y IN PRESENCE
        	}
        	else {
        		if (RegistrationConstants.IS_INSERT_AS_LOG) {
        			MSvcLogApiService.updateSuccessASStatus(transactionId);
        		}
        	}
        }
        else {
        	String procTransactionId = transactionId;
			String procName = "AfterService";
			String procKey = serviceNo;
			String procMsg = "NoTarget Data";
			String errorMsg = "[API] [" + insApiresult.get("userId") + "] IT IS NOT ASSIGNED CODY CODE.";
			throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        }

        logger.debug("==================================[MB]AFTER SERVICE RESULT - END - ====================================");
	    return ResponseEntity.ok(AfterServiceResultDto.create(transactionId));
	}

	@Override
	public ResponseEntity<ASFailJobRequestDto> asFailJobRequestProc(Map<String, Object> params) throws Exception {
		String serviceNo = String.valueOf(params.get("serviceNo"));

		MSvcLogApiService.insertAsFailJobResult(params);
	    MSvcLogApiService.upDatetAsFailJobResultM(params);

    	return ResponseEntity.ok(ASFailJobRequestDto.create(serviceNo));
	}

	@Override
	public ResponseEntity<AfterServiceResultDto> asDtResultProc(Map<String, Object> insApiresult) throws Exception {
		String transactionId = "";
		String serviceNo = "";

	    Calendar cal = Calendar.getInstance();

	    StringBuffer today2 = new StringBuffer();
	    today2.append(String.format("%02d", cal.get(cal.DATE)));
	    today2.append(String.format("%02d", cal.get(cal.MONTH) + 1));
	    today2.append(String.format("%04d", cal.get(cal.YEAR)));

	    String toSetlDt = today2.toString();

	    Date todate = new Date();
	    Calendar today1 = Calendar.getInstance();

	    SimpleDateFormat transFormat = new SimpleDateFormat("dd-mm-yyyy");
	    SimpleDateFormat transFormatYY = new SimpleDateFormat("yyyymmdd");
	    SimpleDateFormat transFormat1 = new SimpleDateFormat("ddmmyyyy");
	    SimpleDateFormat transFormatHH = new SimpleDateFormat("HHmmss");

	    String ddMMCurDate = transFormat.format(new Date());
	    String curDate = transFormatYY.format(new Date());
	    String curTime = transFormatHH.format(new Date());

	    transactionId = String.valueOf(insApiresult.get("transactionId"));
		serviceNo = String.valueOf(insApiresult.get("serviceNo"));

        // SVC0001D CHECK IF MEM_CODE AND MEM_CODE ARE THE SAME
        int asResultMemId = ASManagementListService.asResultSync(insApiresult);

        if (asResultMemId > 0) {
        	// RESULT CHECK HS IS ACTIVE
        	int isAsCnt = ASManagementListService.isAsAlreadyResult(insApiresult);

        	// IF THERE IS NO RESULT
        	if (isAsCnt == 0) {
        		Map<String, Object> afterServiceDetail = null;

        		String userId = MSvcLogApiService.getUseridToMemid(insApiresult); // SELECT MEM_ID FROM ORG0001D WHERE mem_code = #{userId}
        		List<Map<String, Object>> paramsDetail = AfterServiceResultDetailForm.createMaps((List<AfterServiceResultDetailForm>) insApiresult.get("partList"));

        		logger.debug("### AS PART INFO : " + paramsDetail.toString());

        		List<Map<String, Object>> paramsDetailCvt = new ArrayList<Map<String, Object>>();

        		double totPrc = 0.00;

        		logger.debug("### AS PART SIZE : " + paramsDetail.size());
        		for (int x = 0; x < paramsDetail.size(); x++) {
        			// CHECKING STOCK
        			if (!("".equals(CommonUtils.nvl(paramsDetail.get(x).get("filterCode").toString())))) {
        				Map<String, Object> locInfoEntry = new HashMap<String, Object>();
        				locInfoEntry.put("CT_CODE", CommonUtils.nvl(insApiresult.get("userId").toString()));
        				locInfoEntry.put("STK_CODE", CommonUtils.nvl(paramsDetail.get(x).get("filterCode").toString()));

        				EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);

        				logger.debug("LOC. INFO. : {}" + locInfo);
        				if (locInfo != null) {
        					if(Integer.parseInt(locInfo.get("availQty").toString()) < 1){
        						Map<String, Object> m = new HashMap();
        						m.put("APP_TYPE", "AS");
        						m.put("SVC_NO", insApiresult.get("serviceNo"));
        						m.put("ERR_CODE", "03");
        						m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] STOCK FOR [" + paramsDetail.get(x).get("filterCode").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString());
        						m.put("TRNSC_ID", transactionId);

        						MSvcLogApiService.insert_SVC0066T(m);

        						String procTransactionId = transactionId;
        						String procName = "AfterService";
        						String procKey = serviceNo;
        						String procMsg = "PRODUCT STOCK UNAVAILABLE";
        						String errorMsg = "[API] [" + insApiresult.get("userId") + "] STOCK FOR [" + paramsDetail.get(x).get("filterCode").toString() + "] IS UNAVAILABLE. " + locInfo.get("availQty").toString();
        						throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        					}
        				}
        				else {
        					Map<String, Object> m = new HashMap();
        					m.put("APP_TYPE", "AS");
        					m.put("SVC_NO", insApiresult.get("serviceNo"));
        					m.put("ERR_CODE", "03");
        					m.put("ERR_MSG", "[API] [" + insApiresult.get("userId") + "] STOCK FOR [" + paramsDetail.get(x).get("filterCode").toString() + "] IS UNAVAILABLE. ");
        					m.put("TRNSC_ID", transactionId);

        					MSvcLogApiService.insert_SVC0066T(m);

        					String procTransactionId = transactionId;
    						String procName = "AfterService";
    						String procKey = serviceNo;
    						String procMsg = "PRODUCT STOCK UNAVAILABLE";
    						String errorMsg = "[API] [" + insApiresult.get("userId") + "] STOCK FOR [" + paramsDetail.get(x).get("filterCode").toString() + "] IS UNAVAILABLE. ";
    						throw new BizException("03", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        				}
        			}

        			Map<String, Object> map = new HashMap<String, Object>();

        			map.put("filterDesc", "API");
        			if (paramsDetail.get(x).get("filterCode") == null || "".equals(paramsDetail.get(x).get("filterCode"))) {
        				map.put("filterID", paramsDetail.get(x).get("filterCode"));
        			}
        			else {
        				map.put("filterID", paramsDetail.get(x).get("filterCode"));
        			}

        			if (paramsDetail.get(x).get("exchangeId") == null) {
        				map.put("filterExCode", 0);
        			}
        			else {
        				map.put("filterExCode", paramsDetail.get(x).get("exchangeId"));
        			}

        			if (paramsDetail.get(x).get("filterChangeQty") == null) {
        				map.put("filterQty", 0);
        			}
        			else {
        				map.put("filterQty", String.valueOf(paramsDetail.get(x).get("filterChangeQty")));
        			}

        			if (paramsDetail.get(x).get("salesPrice") == null) {
        				map.put("filterPrice", 0);
        			}
        			else {
        				map.put("filterPrice", paramsDetail.get(x).get("salesPrice"));
        			}

        			int foc = CommonUtils.intNvl(paramsDetail.get(x).get("chargesFoc"));

        			if (foc == 1) {
        				map.put("filterType", "FOC");
        			}
        			else {
        				map.put("filterType", String.valueOf(paramsDetail.get(x).get("chargesFoc")));
        			}

        			if (paramsDetail.get(x).get("filterBarcdSerialNo") == null) {
        				map.put("srvFilterLastSerial", "");
        			}
        			else {
        				map.put("srvFilterLastSerial", paramsDetail.get(x).get("filterBarcdSerialNo"));
        			}

        			int qty = Integer.parseInt(String.valueOf(paramsDetail.get(x).get("filterChangeQty")));
        			double filterPrice = Double.parseDouble(String.valueOf(paramsDetail.get(x).get("salesPrice")));

        			double amt = 0.00;

        			if (foc == 0) {
        				amt = qty * filterPrice;
        				totPrc = totPrc + amt;
        			}

        			map.put("filterRemark", "");
        			map.put("filterTotal", amt);

        			if (paramsDetail.get(x).get("retSmoSerialNo") != null) {
        				map.put("retSmoSerialNo", paramsDetail.get(x).get("retSmoSerialNo"));
        			}
        			else {
        				map.put("retSmoSerialNo", "");
        			}

        			if (paramsDetail.get(x).get("isSmo") != null) {
        				map.put("isSmo", paramsDetail.get(x).get("isSmo"));
        			}
        			else {
        				map.put("isSmo", "N");
        			}

        			if (paramsDetail.get(x).get("isSerialReplace") != null) {
        				map.put("isSerialReplace", paramsDetail.get(x).get("isSerialReplace"));
        			}
        			else {
        				map.put("isSerialReplace", "N");
        			}

        			logger.debug("### AS PART : " + map.toString());

        			paramsDetailCvt.add(map);
        		}

        		/*
        		 * Map<String , Object> paramsFilter = paramsDetail.get(i);
        		 * paramsDetail.get(i).put("filterType",
        		 * String.valueOf(paramsDetail.get(i).get("partsType")));
        		 * paramsDetail.get(i).put("filterDesc", "API");
        		 *
        		 * if(paramsDetail.get(i).get("filterCode")== null ||
        		 * "".equals(paramsDetail.get(i).get("filterCode"))){
        		 * paramsDetail.get(i).put("filterExCode", 0); }else{
        		 * paramsDetail.get(i).put("filterExCode",
        		 * paramsDetail.get(i).get("filterCode")); }
        		 *
        		 * if(paramsDetail.get(i).get("filterChangeQty")==null){
        		 * paramsDetail.get(i).put("filterQty", 0); }else{
        		 * paramsDetail.get(i).put("filterQty",
        		 * String.valueOf(paramsDetail.get(i).get("filterChangeQty"))); }
        		 *
        		 * if(paramsDetail.get(i).get("salesPrice")==null){
        		 * paramsDetail.get(i).put("filterPrice", 0); }else{
        		 * paramsDetail.get(i).put("filterPrice",
        		 * paramsDetail.get(i).get("salesPrice")); }
        		 *
        		 * paramsDetail.get(i).put("filterRemark", "");
        		 * paramsDetail.get(i).put("filterID",
        		 * paramsDetail.get(i).get("filterCode") );
        		 * paramsDetail.get(i).put("filterTotal", "1");
        		 */

        		Map<String, Object> params = insApiresult;
        		logger.debug("### AS PARAM [BEFORE]: " + params.toString());

        		Map<String, Object> getAsBasic = MSvcLogApiService.getAsBasic(params);

        		if (getAsBasic.get("asSoId") != null) {
        			params.put("AS_SO_ID", String.valueOf(getAsBasic.get("asSoId")));
        		}
        		else {
        			params.put("AS_SO_ID", "");
        		}

        		if (getAsBasic.get("userId") != null) {
        			params.put("AS_CT_ID", String.valueOf(getAsBasic.get("userId")));
        		}
        		else {
        			params.put("AS_CT_ID", "");
        		}

        		params.put("AS_RESULT_STUS_ID", '4');

        		// params.put("AS_FAIL_RESN_ID", getAsBasic.get("as_failResnId"));
        		params.put("AS_REN_COLCT_ID", 0);

        		if (getAsBasic.get("asCmms") != null) {
        			params.put("AS_CMMS", String.valueOf(getAsBasic.get("asCmms")));
        		}
        		else {
        			params.put("AS_CMMS", "0");
        		}

        		if (getAsBasic.get("asBrnchId") != null) {
        			params.put("AS_BRNCH_ID", String.valueOf(getAsBasic.get("asBrnchId")));
        		}
        		else {
        			params.put("AS_BRNCH_ID", "");
        		}

        		if (getAsBasic.get("asWhId") != null) {
        			params.put("AS_WH_ID", String.valueOf(getAsBasic.get("asWhId")));
        		}
        		else {
        			params.put("AS_WH_ID", "");
        		}

        		if (getAsBasic.get("asMalfuncId") != null) {
        			params.put("AS_MALFUNC_ID", String.valueOf(getAsBasic.get("asMalfuncId")));
        		}
        		else {
        			params.put("AS_MALFUNC_ID", "");
        		}

        		if (getAsBasic.get("asMalfuncResnId") != null) {
        			params.put("AS_MALFUNC_RESN_ID", String.valueOf(getAsBasic.get("asMalfuncResnId")));
        		}
        		else {
        			params.put("AS_MALFUNC_RESN_ID", "");
        		}

        		params.put("AS_DEFECT_GRP_ID", 0);
        		params.put("AS_DEFECT_PART_GRP_ID", 0);
        		params.put("AS_ACSRS_AMT", 0);
        		params.put("AS_FILTER_AMT", totPrc);

        		double totamt = 0.00;
        		try {
        			totamt = Double.parseDouble(String.valueOf(insApiresult.get("labourCharge")));
        		}
        		catch (Exception e) {
        			totamt = 0.00;
        		}

        		params.put("AS_TOT_AMT", totPrc + totamt);
        		params.put("AS_RESULT_IS_SYNCH", 0);
        		params.put("AS_RCALL", 0);

        		if (getAsBasic.get("asResultStockUse") != null) {
        			params.put("AS_RESULT_STOCK_USE", String.valueOf(getAsBasic.get("asResultStockUse")));
        		}
        		else {
        			params.put("AS_RESULT_STOCK_USE", "");
        		}

        		params.put("AS_RESULT_TYPE_ID", 457);
        		params.put("AS_RESULT_IS_CURR", 1);
        		params.put("AS_RESULT_MTCH_ID", 0);
        		params.put("AS_RESULT_NO_ERR", "");
        		params.put("AS_ENTRY_POINT", 0);
        		params.put("AS_WORKMNSH_TAX_CODE_ID", 0);
        		params.put("AS_WORKMNSH_TXS", 0);
        		params.put("AS_RESULT_MOBILE_ID", 0);

        		if (!"".equals(getAsBasic.get("asResultNo"))) {
        			params.put("AS_RESULT_NO", String.valueOf(getAsBasic.get("asResultNo")));
        		}
        		else {
        			params.put("AS_RESULT_NO", "");
        		}

        		if (getAsBasic.get("asResultId") != null) {
        			params.put("AS_RESULT_ID", String.valueOf(getAsBasic.get("asResultId")));
        		}
        		else {
        			params.put("AS_RESULT_ID", "");
        		}

        		if (getAsBasic.get("asno") != null) {
        			params.put("AS_NO", String.valueOf(getAsBasic.get("asno")));
        		}
        		else {
        			params.put("AS_NO", "");
        		}

        		params.put("HC_REM", " ");

        		// 004
        		if (getAsBasic.get("asId") != null) {
        			params.put("AS_ENTRY_ID", String.valueOf(getAsBasic.get("asId")));
        		}
        		else {
        			params.put("AS_ENTRY_ID", "");
        		}

        		if (insApiresult.get("serviceNo") != null) {
        			params.put("AS_NO", String.valueOf(insApiresult.get("serviceNo")));
        		}
        		else {
        			params.put("AS_NO", "");
        		}

        		if (insApiresult.get("defectTypeId") != null) {
        			params.put("AS_DEFECT_TYPE_ID", String.valueOf(insApiresult.get("defectTypeId")));
        		}
        		else {
        			params.put("AS_DEFECT_TYPE_ID", "");
        		}

        		if (insApiresult.get("defectId") != null) {
        			params.put("AS_DEFECT_ID", String.valueOf(insApiresult.get("defectId")));
        		}
        		else {
        			params.put("AS_DEFECT_ID", "");
        		}

        		if (insApiresult.get("defectPartId") != null) {
        			params.put("AS_DEFECT_PART_ID", String.valueOf(insApiresult.get("defectPartId")));
        		}
        		else {
        			params.put("AS_DEFECT_PART_ID", "");
        		}

        		if (insApiresult.get("defectDetailReasonId") != null) {
        			params.put("AS_DEFECT_DTL_RESN_ID", String.valueOf(insApiresult.get("defectDetailReasonId")));
        		}
        		else {
        			params.put("AS_DEFECT_DTL_RESN_ID", "");
        		}

        		if (insApiresult.get("solutionReasonId") != null) {
        			params.put("AS_SLUTN_RESN_ID", String.valueOf(insApiresult.get("solutionReasonId")));
        		}
        		else {
        			params.put("AS_SLUTN_RESN_ID", "");
        		}

        		// params.put("AS_SETL_DT", todate2);
        		params.put("AS_SETL_DT", toSetlDt);
        		params.put("AS_SETL_TM", curTime);

        		if (insApiresult.get("labourCharge") != null) {
        			params.put("AS_WORKMNSH", String.valueOf(insApiresult.get("labourCharge")));
        		}
        		else {
        			params.put("AS_WORKMNSH", "");
        		}

        		params.put("AS_RESULT_REM", insApiresult.get("resultRemark"));
        		params.put("PARTNER_CODE", insApiresult.get("partnerCode"));

        		if (insApiresult.get("inHouseRepairRemark") != null) {
        			params.put("IN_HUSE_REPAIR_REM", String.valueOf(insApiresult.get("inHouseRepairRemark")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_REM", "");
        		}

        		if (insApiresult.get("inHouseRepairReplacementYN") != null) {
        			params.put("IN_HUSE_REPAIR_REPLACE_YN", String.valueOf(insApiresult.get("inHouseRepairReplacementYN")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_REPLACE_YN", "");
        		}

        		Date inHouseRepairPromisedDate;
        		String inHouseRepairPromisedDate1 = "";

        		if (!"".equals(insApiresult.get("inHouseRepairPromisedDate"))) {
        			inHouseRepairPromisedDate = transFormatYY.parse(String.valueOf(insApiresult.get("inHouseRepairPromisedDate")));
        			inHouseRepairPromisedDate1 = transFormat1.format(inHouseRepairPromisedDate);
        		}

        		params.put("IN_HUSE_REPAIR_PROMIS_DT", inHouseRepairPromisedDate1);// asTransLogs

        		if (insApiresult.get("inHouseRepairProductGroupCode") != null) {
        			params.put("IN_HUSE_REPAIR_GRP_CODE", String.valueOf(insApiresult.get("inHouseRepairProductGroupCode")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_GRP_CODE", "");
        		}

        		if (insApiresult.get("inHouseRepairProductCode") != null) {
        			params.put("IN_HUSE_REPAIR_PRODUCT_CODE", String.valueOf(insApiresult.get("inHouseRepairProductCode")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_PRODUCT_CODE", "");
        		}

        		if (insApiresult.get("inHouseRepairSerialNo") != null) {
        			params.put("IN_HUSE_REPAIR_SERIAL_NO", String.valueOf(insApiresult.get("inHouseRepairSerialNo")));
        		}
        		else {
        			params.put("IN_HUSE_REPAIR_SERIAL_NO", "");
        		}

        		params.put("RESULT_CUST_NAME", insApiresult.get("resultCustName"));// asTransLogs

        		if (insApiresult.get("resultIcMobileNo") != null) {
        			params.put("RESULT_MOBILE_NO", String.valueOf(insApiresult.get("resultIcMobileNo")));
        		}
        		else {
        			params.put("RESULT_MOBILE_NO", "");
        		}

        		if (insApiresult.get("resultReportEmailNo") != null) {
        			params.put("RESULT_REP_EMAIL_NO", String.valueOf(insApiresult.get("resultReportEmailNo")));
        		}
        		else {
        			params.put("RESULT_REP_EMAIL_NO", "");
        		}

        		if (insApiresult.get("resultAcceptanceName") != null) {
        			params.put("RESULT_ACEPT_NAME", String.valueOf(insApiresult.get("resultAcceptanceName")));
        		}
        		else {
        			params.put("RESULT_ACEPT_NAME", "");
        		}

        		params.put("SGN_DT", insApiresult.get("signData")); // asTransLogs

        		params.put("SERIAL_REQUIRE_CHK_YN", "Y"); // HomeCare Chk "Y"

        		// INST. ACCS LIST START
                List<Map<String, Object>> paramsDetailInstAccLst = AfterServiceResultDetailForm.createMaps((List<AfterServiceResultDetailForm>) insApiresult.get("installAccList"));
                logger.debug("### INST ACCS LIST INFO : " + paramsDetailInstAccLst.toString());
                //List lstStr = null;
                List<String> lstStr = new ArrayList<>();
                for (Map<String, Object> accLst : paramsDetailInstAccLst) {

                	logger.debug("accLst : " + accLst.size());
                  if (accLst != null) {
                    lstStr.add(String.valueOf(accLst.get("insAccPartId")));
                    logger.debug("### insAccPartIdT : " + String.valueOf(accLst.get("insAccPartId")));
                  }
                }
                logger.debug("### INST ACCS LIST SIZE : " + lstStr.size());

                params.put("instAccLst", lstStr); // remind of param instAccLst or
                // INST. ACCS LIST END


        		logger.debug("### AS PARAM [AFTER]: ", params);

        		Map<String, Object> asResultInsert = new HashMap();
        		asResultInsert.put("asResultM", params);
        		asResultInsert.put("updator", getAsBasic.get("updUsrId"));
        		asResultInsert.put("add", paramsDetailCvt); // FILTER LIST
        		asResultInsert.put("mobileYn", "Y");

        		logger.debug("### AS INSERT : " + asResultInsert.toString());

        		try {
        			EgovMap rtnValue = ASManagementListService.asResult_insert(asResultInsert);
        			if (null != rtnValue) {
        				HashMap spMap = (HashMap) rtnValue.get("spMap");
        				logger.debug("spMap :" + spMap.toString());
        				if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
        					rtnValue.put("logerr", "Y");
        				}

        				params.put("scanSerial", String.valueOf(insApiresult.get("scanSerial")));
    					params.put("salesOrdId", String.valueOf(getAsBasic.get("salesOrdId")));
    					params.put("reqstNo", String.valueOf(rtnValue.get("asNo")));
    					params.put("delvryNo", null);
    					params.put("callGbn", "AS");
    					params.put("mobileYn", "Y");
    					params.put("userId", userId);
    					params.put("pErrcode", "");
    					params.put("pErrmsg", "");
    					MSvcLogApiService.SP_SVC_BARCODE_SAVE(params);

    					if (!"000".equals(params.get("pErrcode"))) {
    						String procTransactionId = transactionId;
    						String procName = "AfterService";
    						String procKey = serviceNo;
    						String procMsg = "Failed to Barcode Save";
    						String errorMsg = "[API] " + params.get("pErrmsg");
    						throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
						}

    					spMap.put("pErrcode", "");
    					spMap.put("pErrmsg", "");
        				servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

        				if (!"000".equals(params.get("pErrcode"))) {
    						String procTransactionId = transactionId;
    						String procName = "AfterService";
    						String procKey = serviceNo;
    						String procMsg = "Failed to Barcode Save";
    						String errorMsg = "[API] " + params.get("pErrmsg");
    						throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
						}
        			}
        		}
        		catch (Exception e) {
        			String procTransactionId = transactionId;
        			String procName = "AfterService";
        			String procKey = serviceNo;
        			String procMsg = "Failed to Save";
        			String errorMsg = "[API] " + e.toString();
        			throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        		}

        		// RESULT UPDATE TO STATE Y IN PRESENCE
        	}
        	else {
        		// Insert Log Adapter. So Delete Log
//        		if (RegistrationConstants.IS_INSERT_AS_LOG) {
//        			MSvcLogApiService.updateSuccessASStatus(transactionId);
//        		}
        	}
        }
        else {
        	String procTransactionId = transactionId;
			String procName = "AfterService";
			String procKey = serviceNo;
			String procMsg = "NoTarget Data";
			String errorMsg = "[API] [" + insApiresult.get("userId") + "] IT IS NOT ASSIGNED CODY CODE.";
			throw new BizException("01", procTransactionId, procName, procKey, procMsg, errorMsg, null);
        }

        logger.debug("==================================[MB]AFTER SERVICE RESULT - END - ====================================");
	    return ResponseEntity.ok(AfterServiceResultDto.create(transactionId));
	}
}
