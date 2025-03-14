package com.coway.trust.biz.api.impl;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ChatbotCallLogApiService;
import com.coway.trust.biz.api.vo.chatbotCallLog.CallLogAppointmentReqForm;
import com.coway.trust.biz.api.vo.chatbotCallLog.CallLogAppointmentRespDto;
import com.coway.trust.biz.api.vo.chatbotCallLog.CallLogAppointmentRespDto.CallLogAppointmentDate;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("chatbotCallLogApiService")
public class ChatbotCallLogApiServiceImpl extends EgovAbstractServiceImpl implements ChatbotCallLogApiService {

	private int cbtApiUserId = 7;

    @Resource(name = "chatbotCallLogApiMapper")
    private ChatbotCallLogApiMapper chatbotCallLogApiMapper;

    @Resource(name = "CommonApiMapper")
    private CommonApiMapper commonApiMapper;

    @Resource(name = "servicesLogisticsPFCService")
    private ServicesLogisticsPFCService servicesLogisticsPFCService;

     @Resource(name = "servicesLogisticsPFCMapper")
     private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

     @Value("${etrust.base.url}")
     private String etrustBaseUrl;

	@Override
	public CallLogAppointmentRespDto reconfirmCustomerDetail(CallLogAppointmentReqForm params,
			HttpServletRequest request) throws Exception {
	    String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
	    StopWatch stopWatch = new StopWatch();
		CallLogAppointmentRespDto resultValue = new CallLogAppointmentRespDto();

		try{
    	    stopWatch.reset();
    	    stopWatch.start();

    	    EgovMap authorize = this.verifyBasicAuth(request);

			if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
				apiUserId = authorize.get("apiUserId").toString();
				cbtApiUserId = Integer.parseInt(authorize.get("apiUserId").toString());
			}
			else{
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
				resultValue.setMessage("Unauthorized.");
				return resultValue;
			}

			params.setStatusCode(44);
			int isExist = chatbotCallLogApiMapper.checkIfCallLogEntryAppointmentValid(params);

			if (isExist == 0) {
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
				resultValue.setMessage("Order not found.");
				return resultValue;
			}

			EgovMap updateParam = new EgovMap();
			updateParam.put("requestId", params.getRequestId());
			updateParam.put("ordNo", params.getOrderNo());
			updateParam.put("stusCodeId", 134);
			updateParam.put("waRemarks", "The order details is incorrect during WA verification. Sales person please follow up with customer.");

			chatbotCallLogApiMapper.updateCBT0007MStatus(updateParam);
//			chatbotCallLogApiMapper.updateCCR0006DStatus(updateParam);

			EgovMap searchParam = new EgovMap();
			searchParam.put("callEntryId", params.getRequestId());
			searchParam.put("salesOrdNo", params.getOrderNo());
			EgovMap appointmentDtl = chatbotCallLogApiMapper.selectCallLogCbtOrderInfo(searchParam);

			//INSERT CALLLOG RESULT
			String maxId = "";
			int callStusId = 19; // Recall
			int feedbackStusId = 1615; // FB24- Awaiting CPE/RFD
			Map<String, Object> callEntry = new HashMap<String, Object>();
			// Map<String, Object> callMaster = new HashMap<String, Object>();
			Map<String, Object> callDetails = new HashMap<String, Object>();
			Map<String, Object> maxIdValueParam = new EgovMap();

			callDetails.put("callEntryId", CommonUtils.nvl(appointmentDtl.get("callEntryId")));
			callDetails.put("callStatusId", callStusId);
			callDetails.put("callCallDate", CommonUtils.nvl(appointmentDtl.get("callDt")));
			callDetails.put("callActionDate", "");
			callDetails.put("callFeedBackId", feedbackStusId);
			callDetails.put("callCTId",  null);
			callDetails.put("callRemark", "The order details is incorrect during WA verification. Sales person please follow up with customer");
			callDetails.put("callCreateBy", 349);
			callDetails.put("callCreateAt", new Date());
			callDetails.put("callCreateByDept", 0);
			callDetails.put("callHCID", 0);
			callDetails.put("callROSAmt", 0);
			callDetails.put("callSMS", false);
			callDetails.put("CallSMSRemark", "");
			chatbotCallLogApiMapper.insertCallResult(callDetails);

			maxIdValueParam.put("value", "callResultId");
			maxIdValueParam.put("callEntryId", CommonUtils.nvl(appointmentDtl.get("callEntryId")));
			maxId = chatbotCallLogApiMapper.selectMaxId(maxIdValueParam);

			callEntry.put("callEntryId", CommonUtils.nvl(appointmentDtl.get("callEntryId")));
			callEntry.put("stusCodeId", callStusId);
			callEntry.put("resultId", maxId);
			callEntry.put("callDt", CommonUtils.nvl(appointmentDtl.get("callDt")));
			callEntry.put("updDt", new Date());
			callEntry.put("updUserId", 349);
			callEntry.put("waStusCodeId", 134); // Incorrect detail
			callEntry.put("waRemarks", "The order details is incorrect during WA verification. Sales person please follow up with customer");

			chatbotCallLogApiMapper.updateCallEntry(callEntry);
			//

			resultValue.setSuccess(true);
			resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_SUCCESS);
		}
		catch (Exception ex){
			resultValue.setSuccess(false);
			resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_UNEXPECTED);
			resultValue.setMessage("Unexpected Error Occurs.");
		}
		finally{
		    stopWatch.stop();
		    respTm = stopWatch.toString();
		    Map<String,Object> apiParam = new HashMap();
		    apiParam.put("success", resultValue.isSuccess());
		    apiParam.put("statusCode", resultValue.getStatusCode());
		    apiParam.put("message", resultValue.getMessage());
		    apiParam.put("reqParam", CommonUtils.nvl(reqParam));
		    apiParam.put("ipAddr", CommonUtils.getClientIp(request));
		    apiParam.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
		    apiParam.put("respTm", CommonUtils.nvl(respTm));
		    apiParam.put("apiUserId", CommonUtils.nvl(apiUserId));

		    this.rtnRespMsg(apiParam);
		}

		return resultValue;
	}

	@Override
	public CallLogAppointmentRespDto getAppointmentDateDetail(CallLogAppointmentReqForm params, HttpServletRequest request) throws Exception {
	    String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
	    StopWatch stopWatch = new StopWatch();
		CallLogAppointmentRespDto resultValue = new CallLogAppointmentRespDto();

		try{
    	    stopWatch.reset();
    	    stopWatch.start();

    	    EgovMap authorize = this.verifyBasicAuth(request);

			if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
				apiUserId = authorize.get("apiUserId").toString();
				cbtApiUserId = Integer.parseInt(authorize.get("apiUserId").toString());
			}
			else{
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
				resultValue.setMessage("Unauthorized.");
				return resultValue;
			}

			params.setStatusCode(44);
			int isExist = chatbotCallLogApiMapper.checkIfCallLogEntryAppointmentValid(params);

			if (isExist == 0) {
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
				resultValue.setMessage("Order not found.");
				return resultValue;
			}

			EgovMap orderParam = new EgovMap();
			orderParam.put("salesOrdNo", params.getOrderNo());
			orderParam.put("callEntryId", params.getRequestId());
			EgovMap orderInfo = chatbotCallLogApiMapper.selectCallLogCbtOrderInfo(orderParam);

			if (orderInfo == null) {
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
				resultValue.setMessage("Call Log not found.");
				return resultValue;
			}

			if (orderInfo.get("waStusCodeId").toString().equals("44")
					&& orderInfo.get("stusCodeId").toString().equals("1")) {
				orderParam.put("salesOrdId", CommonUtils.nvl(orderInfo.get("salesOrdId")));
				orderParam.put("hcIndicator", CommonUtils.nvl(orderInfo.get("hcIndicator")));
				orderParam.put("productCat", CommonUtils.nvl(orderInfo.get("stockCatCode")));

				if(CommonUtils.nvl(orderInfo.get("hcIndicator")).equals("N")){
					orderParam.put("type", "6665"); // HA TYPE
				}
				else{
					if(CommonUtils.nvl(orderInfo.get("brnchId")).equals("43")){
						orderParam.put("type", "7321"); // HC-AC TYPE
					}
					else{
						orderParam.put("type", "6666"); // HC TYPE
					}
				}

				List<EgovMap> allocationResult = chatbotCallLogApiMapper.selectAvailAllocationList(orderParam);

				if (allocationResult.size() > 0) {
					List<CallLogAppointmentDate> appointmentDates = new ArrayList();
					for (int i = 0; i < allocationResult.size(); i++) {
						CallLogAppointmentDate aptDate = new CallLogAppointmentDate();
						aptDate.setAptDate(CommonUtils.nvl(allocationResult.get(i).get("aptDate")));
						aptDate.setCapacity(Integer.parseInt(CommonUtils.nvl(allocationResult.get(i).get("capacity"))));

						appointmentDates.add(aptDate);
					}

					resultValue.setCallLogAppointmentDates(appointmentDates);
					resultValue.setSuccess(true);
					resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_SUCCESS);
				} else {
					resultValue.setSuccess(false);
					resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
					resultValue.setMessage("No appointment available.");
				}
			} else {
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
				resultValue.setMessage("Order not found.");
			}

			return resultValue;
		}
		catch (Exception ex){
			resultValue.setSuccess(false);
			resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_UNEXPECTED);
			resultValue.setMessage("Unexpected Error Occurs.");
		}
		finally{
		    stopWatch.stop();
		    respTm = stopWatch.toString();
		    Map<String,Object> apiParam = new HashMap();
		    apiParam.put("success", resultValue.isSuccess());
		    apiParam.put("statusCode", resultValue.getStatusCode());
		    apiParam.put("message", resultValue.getMessage());
		    apiParam.put("reqParam", CommonUtils.nvl(reqParam));
		    apiParam.put("ipAddr", CommonUtils.getClientIp(request));
		    apiParam.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
		    apiParam.put("respTm", CommonUtils.nvl(respTm));
		    apiParam.put("apiUserId", CommonUtils.nvl(apiUserId));

		    this.rtnRespMsg(apiParam);
		}
	    return resultValue;
	}

	@Override
	public CallLogAppointmentRespDto confirmAppointment(CallLogAppointmentReqForm params, HttpServletRequest request)
			throws Exception {
	    String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
	    StopWatch stopWatch = new StopWatch();
		CallLogAppointmentRespDto resultValue = new CallLogAppointmentRespDto();

		try{
    	    stopWatch.reset();
    	    stopWatch.start();

    	    EgovMap authorize = this.verifyBasicAuth(request);

			if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
				apiUserId = authorize.get("apiUserId").toString();
				cbtApiUserId = Integer.parseInt(authorize.get("apiUserId").toString());
			}
			else{
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
				resultValue.setMessage("Unauthorized.");
				return resultValue;
			}

			params.setStatusCode(44);
			int isExist = chatbotCallLogApiMapper.checkIfCallLogEntryAppointmentValid(params);

			if (isExist == 0) {
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
				resultValue.setMessage("Order not found.");
				return resultValue;
			}

			EgovMap orderParam = new EgovMap();
			orderParam.put("salesOrdNo", params.getOrderNo());
			orderParam.put("callEntryId", params.getRequestId());
			// Call Entry Info
			EgovMap orderInfo = chatbotCallLogApiMapper.selectCallLogCbtOrderInfo(orderParam);

			if (orderInfo == null) {
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
				resultValue.setMessage("Call Log not found.");
				return resultValue;
			}

			if (CommonUtils.nvl(orderInfo.get("waStusCodeId")).equals("44")
					&& CommonUtils.nvl(orderInfo.get("stusCodeId")).equals("1")) {

				if(CommonUtils.nvl(orderInfo.get("rental")).equals("Y")){
					if(params.getTncFlag() != 1){
						resultValue.setSuccess(false);
						resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
						resultValue.setMessage("TnC not checked.");
						return resultValue;
					}
				}

				//Check Stock Availability before proceed
 				orderParam.put("productCode", CommonUtils.nvl(orderInfo.get("stkCode")));
				orderParam.put("itmStkId", CommonUtils.nvl(orderInfo.get("itmStkId")));

				if(CommonUtils.nvl(orderInfo.get("hcIndicator")).equals("Y")){
					orderParam.put("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
					orderParam.put("productCat", CommonUtils.nvl(orderInfo.get("stockCatCode")));
				}

				EgovMap rdcStock = chatbotCallLogApiMapper.selectRdcStock(orderParam);
				if (rdcStock == null || Integer.parseInt(CommonUtils.nvl2(rdcStock.get("availQty"),"0")) == 0) {
//					EgovMap updateParam = new EgovMap();
//					updateParam.put("requestId", params.getRequestId());
//					updateParam.put("ordNo", params.getOrderNo());
//					updateParam.put("stusCodeId", 134);
//					updateParam.put("waRemarks","Whatsapp Appointment lack of stock to proceed.");
//
//					chatbotCallLogApiMapper.updateCBT0007MStatus(updateParam);
//					chatbotCallLogApiMapper.updateCCR0006DStatus(updateParam);

					resultValue.setSuccess(false);
					resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NO_STOCK);
					resultValue.setMessage("Not enough stock to proceed.");
					return resultValue;
				}

				// Using appointment date, get an CTID
				orderParam.put("salesOrdId", CommonUtils.nvl(orderInfo.get("salesOrdId")));
				if(CommonUtils.nvl(orderInfo.get("hcIndicator")).equals("N")){
					orderParam.put("type", "6665"); // HA TYPE
				}
				else{
					if(CommonUtils.nvl(orderInfo.get("brnchId")).equals("43")){
						orderParam.put("type", "7321"); // HC-AC TYPE
					}
					else{
						orderParam.put("type", "6666"); // HC TYPE
					}
				}
				orderParam.put("appointmentDate", params.getAptDate());
				orderParam.put("hcIndicator", CommonUtils.nvl(orderInfo.get("hcIndicator")));
				orderParam.put("productCat", CommonUtils.nvl(orderInfo.get("stockCatCode")));

				EgovMap firstAvailUser = chatbotCallLogApiMapper.selectFirstAvailAllocationUser(orderParam);

				if (firstAvailUser == null) {
					resultValue.setSuccess(false);
					resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
					resultValue.setMessage("No allocation slot available on the date.");
					return resultValue;
				}

				if(CommonUtils.nvl(orderInfo.get("hcIndicator")).equals("N")){
					resultValue = this.confirmAppointmentHAHC(params,firstAvailUser,orderInfo,false,true);
				}
				else{
					//get AUX order and check stock availability before proceed
					EgovMap auxOrderParam = new EgovMap();
					auxOrderParam.put("salesOrdId", CommonUtils.nvl(orderInfo.get("salesOrdId")));
					EgovMap auxOrderInfo = chatbotCallLogApiMapper.selectAuxCallLogCbtOrderInfo(auxOrderParam);
					if(auxOrderInfo != null){
						auxOrderParam.put("salesOrdNo", CommonUtils.nvl(auxOrderInfo.get("salesOrdNo")));
						auxOrderParam.put("productCode", CommonUtils.nvl(auxOrderInfo.get("stkCode")));
						auxOrderParam.put("itmStkId", CommonUtils.nvl(auxOrderInfo.get("itmStkId")));
						if(CommonUtils.nvl(auxOrderInfo.get("hcIndicator")).equals("Y")){
							auxOrderParam.put("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
							auxOrderParam.put("productCat", CommonUtils.nvl(auxOrderInfo.get("stockCatCode")));
						}

						EgovMap auxRdcStock = chatbotCallLogApiMapper.selectRdcStock(auxOrderParam);
						if (auxRdcStock == null || Integer.parseInt(CommonUtils.nvl2(auxRdcStock.get("availQty"),"0")) == 0) {
							resultValue.setSuccess(false);
							resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NO_STOCK);
							resultValue.setMessage("Not enough aux stock to proceed.");
							return resultValue;
						}
					}

					//Main order
					resultValue = this.confirmAppointmentHAHC(params,firstAvailUser,orderInfo,true,true);

					if(auxOrderInfo != null){
						if(resultValue.getStatusCode() == AppConstants.RESPONSE_CODE_INTERNAL_SUCCESS){
							resultValue = this.confirmAppointmentHAHC(params,firstAvailUser,auxOrderInfo,true,false);
						}
					}
				}
			} else {
				resultValue.setSuccess(false);
				resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_NOT_FOUND);
				resultValue.setMessage("Order not found.");
			}
		}
		catch (Exception ex){
			resultValue.setSuccess(false);
			resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_UNEXPECTED);
			resultValue.setMessage("Unexpected Error Occurs.");
		}
		finally{
		    stopWatch.stop();
		    respTm = stopWatch.toString();
		    Map<String,Object> apiParam = new HashMap();
		    apiParam.put("success", resultValue.isSuccess());
		    apiParam.put("statusCode", resultValue.getStatusCode());
		    apiParam.put("message", resultValue.getMessage());
		    apiParam.put("reqParam", CommonUtils.nvl(reqParam));
		    apiParam.put("ipAddr", CommonUtils.getClientIp(request));
		    apiParam.put("prgPath", StringUtils.defaultString(request.getRequestURI()));
		    apiParam.put("respTm", CommonUtils.nvl(respTm));
		    apiParam.put("apiUserId", CommonUtils.nvl(apiUserId));

		    this.rtnRespMsg(apiParam);
		}

		return resultValue;
	}

	public void rtnRespMsg(Map<String, Object> param) {
		Map<String, Object> params = new HashMap<>();

		params.put("respCde", param.get("statusCode"));
		params.put("errMsg", param.get("message"));
		params.put("reqParam", param.get("reqParam").toString());
		params.put("ipAddr", param.get("ipAddr"));
		params.put("prgPath", param.get("prgPath"));
		params.put("respTm", param.get("respTm"));
		params.put("respParam", param.containsKey("respParam") ? param.get("respParam").toString().length() >= 4000 ? param.get("respParam").toString().substring(0,4000) : param.get("respParam").toString() : "");
      	params.put("apiUserId", param.get("apiUserId") );

      	commonApiMapper.insertApiAccessLog(params);
	}

	public EgovMap getDocNo(String docNoId) {
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = chatbotCallLogApiMapper.selectDocNo(docNoId);
		String prefix = "";

		if (Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp) {

			if (selectDocNo.get("c2") != null) {
				prefix = (String) selectDocNo.get("c2");
			} else {
				prefix = "";
			}
			docNo = prefix.trim() + (String) selectDocNo.get("c1");
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}

	public String getNextDocNo(String prefixNo, String docNo) {
		String nextDocNo = "";
		int docNoLength = 0;
		if (prefixNo != null && prefixNo != "") {
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		} else {
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0" + docNoLength + "d", nextNo);
		return nextDocNo;
	}

	public EgovMap verifyBasicAuth(HttpServletRequest request){

		String code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

		String userName = request.getHeader("userName");
		String key = request.getHeader("key");

		EgovMap reqPrm = new EgovMap();
		reqPrm.put("userName", userName);
		reqPrm.put("key", key);

		EgovMap access = new EgovMap();
		access = chatbotCallLogApiMapper.checkAccess(reqPrm);

		if(access == null){
			code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
			message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
		}else{
			code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
			message = AppConstants.RESPONSE_DESC_SUCCESS;

			apiUserId = access.get("apiUserId").toString();
			sysUserId = access.get("sysUserId").toString();
			reqPrm.put("apiUserId", apiUserId);
			reqPrm.put("sysUserId", sysUserId);
		}

		reqPrm.put("code", code);
		reqPrm.put("message", message);

		return reqPrm;
	}

    private CallLogAppointmentRespDto confirmAppointmentHAHC(CallLogAppointmentReqForm params,EgovMap firstAvailUser,EgovMap orderInfo,boolean isHC,boolean updateAppointment){
		CallLogAppointmentRespDto resultValue = new CallLogAppointmentRespDto();

		Map<String, Object> installMaster = new HashMap<String, Object>();
		Map<String, Object> logPram = new HashMap<String, Object>();

		boolean stat = false;
		String pType = "";
		String pPrgm = "";
		String stockGrade = "A"; // only new installation so new stock

		EgovMap installNo = new EgovMap();
		installNo = getDocNo("9");
		String nextDocNo = getNextDocNo("INS", installNo.get("docNo").toString());
		installNo.put("nextDocNo", nextDocNo);

		chatbotCallLogApiMapper.updateDocNo(installNo);

		int callEntId = 0;
		if (orderInfo.get("callEntryId") != null) {
			callEntId = Integer.parseInt(orderInfo.get("callEntryId").toString());
		}

		// TO_DO INSTALLMASTER PARAM NEED TO BE SET
		// IF installMaster NOT EMPTY AND INSIDE installMaster CONTAIN CALL ENTRY ID
		if (installMaster != null && callEntId > 0) {
			// PRE INSERT INSTALL ENTRY
			installMaster.put("installEntryId", chatbotCallLogApiMapper.installEntryIdSeq());
			installMaster.put("installEntryNo", installNo.get("docNo"));
			installMaster.put("salesOrderId", CommonUtils.nvl(orderInfo.get("salesOrdId")));
			installMaster.put("statusCodeId", 1);
			installMaster.put("CTID", CommonUtils.nvl(firstAvailUser.get("ct")));
			installMaster.put("installDate", params.getAptDate());
			installMaster.put("appDate", params.getAptDate());
			installMaster.put("callEntryId", CommonUtils.nvl(orderInfo.get("callEntryId")));
			installMaster.put("installStkId", CommonUtils.intNvl(orderInfo.get("itmStkId")));
			installMaster.put("installResultId", 0);
			installMaster.put("created", new Date());
			installMaster.put("creator", 349);
			installMaster.put("allowComm", false);
			installMaster.put("isTradeIn", false);
			installMaster.put("CTGroup", CommonUtils.nvl(firstAvailUser.get("ctSubGrp")));
			installMaster.put("updated", new Date());
			installMaster.put("updator", 349);
			installMaster.put("revId", 0);
			installMaster.put("stock", stockGrade);

			if(isHC){
	            if ("ACI".equals(CommonUtils.nvl(orderInfo.get("stockCatCode")))) {
	            	  try{
	            			BitMatrix bitMatrix = new MultiFormatWriter().encode(etrustBaseUrl+"/homecare/services/install/getAcInstallationInfo.do?insNo="+installNo.get("docNo"), BarcodeFormat.QR_CODE, 200, 200);

	                  		ByteArrayOutputStream bos = new ByteArrayOutputStream();
	                  		MatrixToImageWriter.writeToStream(bitMatrix, "png", bos);
	                  		installMaster.put("insQr", bos.toByteArray());
	            	  }catch(Exception e){
	            	  }
	            }
			}

			chatbotCallLogApiMapper.insertInstallEntry(installMaster);
		}

		pType = "OD01";
		pPrgm = "OCALL";

		logPram.put("ORD_ID", installMaster.get("installEntryNo"));
		logPram.put("RETYPE", "SVO");
		logPram.put("P_TYPE", pType);
		logPram.put("P_PRGNM", pPrgm);

		logPram.put("USERID", 349);

		if(isHC == false){
			//HA
			servicesLogisticsPFCService.SP_LOGISTIC_REQUEST(logPram);
		}
		else{
			//HC
			servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
		}

		logPram.put("P_RESULT_TYPE", "IN");
		logPram.put("P_RESULT_MSG", logPram.get("p1"));

		if (!"000".equals(logPram.get("p1"))) {
			stat = false;
			// REMOVE INSTALL ENTRY
			if (installMaster != null && callEntId > 0) {
				// PRE INSERT INSTALL ENTRY
				chatbotCallLogApiMapper.deleteInstallEntry(installMaster);
			}
		} else {
			stat = true;
			if(isHC == false){
				//HA
				servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(logPram);
			}
			else{
				//HC
	        	servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(logPram);
			}
		}

		if(stat){
  			String maxId = "";
  			int callStusId = 20; // Ready To Install
  			int feedbackStusId = 225; // FB01-Ready for DO
  			Map<String, Object> callEntry = new HashMap<String, Object>();
  			// Map<String, Object> callMaster = new HashMap<String, Object>();
  			Map<String, Object> callDetails = new HashMap<String, Object>();
  			Map<String, Object> maxIdValueParam = new EgovMap();

  			callDetails.put("callEntryId", CommonUtils.nvl(orderInfo.get("callEntryId")));
  			callDetails.put("callStatusId", callStusId);
  			callDetails.put("callCallDate", CommonUtils.nvl(orderInfo.get("callDt")));
  			callDetails.put("callActionDate", params.getAptDate());
  			callDetails.put("callFeedBackId", feedbackStusId);
  			callDetails.put("callCTId", CommonUtils.nvl(firstAvailUser.get("ct")));
  			callDetails.put("callRemark", "");
  			callDetails.put("callCreateBy", 349);
  			callDetails.put("callCreateAt", new Date());
  			callDetails.put("callCreateByDept", 0);
  			callDetails.put("callHCID", 0);
  			callDetails.put("callROSAmt", 0);
  			callDetails.put("callSMS", false);
  			callDetails.put("CallSMSRemark", "");
  			chatbotCallLogApiMapper.insertCallResult(callDetails);

  			maxIdValueParam.put("value", "callResultId");
  			maxIdValueParam.put("callEntryId", CommonUtils.nvl(orderInfo.get("callEntryId")));
  			maxId = chatbotCallLogApiMapper.selectMaxId(maxIdValueParam);

  			callEntry.put("callEntryId", CommonUtils.nvl(orderInfo.get("callEntryId")));
  			callEntry.put("salesOrdId", CommonUtils.nvl(orderInfo.get("salesOrdId")));
  			callEntry.put("typeId", CommonUtils.nvl(orderInfo.get("typeId")));
  			callEntry.put("stusCodeId", callStusId);
  			callEntry.put("resultId", maxId);
  			callEntry.put("docId", CommonUtils.nvl(orderInfo.get("docId")));
  			callEntry.put("crtUserId", CommonUtils.nvl(orderInfo.get("crtUserId")));
  			callEntry.put("crtDt", CommonUtils.nvl(orderInfo.get("crtDt")));
//  			callEntry.put("callDt", CommonUtils.nvl(orderInfo.get("callDt")));
  			callEntry.put("isWaitForCancl", CommonUtils.nvl(orderInfo.get("isWaitForCancl")));
  			callEntry.put("happyCallerId", CommonUtils.nvl(orderInfo.get("happyCallerId")));
  			callEntry.put("updDt", new Date());
  			callEntry.put("updUserId", 349);
  			callEntry.put("oriCallDt", CommonUtils.nvl(orderInfo.get("oriCallDt")));
  			callEntry.put("waRemarks","Whatsapp appointment confirmed.");
  			callEntry.put("waStusCodeId", 4); // Complete WA

  			chatbotCallLogApiMapper.updateCallEntry(callEntry);

  			if(updateAppointment){
    			EgovMap updateParam = new EgovMap();
    			updateParam.put("requestId", params.getRequestId());
    			updateParam.put("ordNo", params.getOrderNo());
    			updateParam.put("stusCodeId", 4);
    			updateParam.put("waRemarks","Whatsapp appointment confirmed.");
    			chatbotCallLogApiMapper.updateCBT0007MStatus(updateParam);
			}

			if (callEntId > 0) {
				EgovMap salesEntry = chatbotCallLogApiMapper.selectOrderEntry(CommonUtils.nvl(orderInfo.get("salesOrdNo")));
				if (salesEntry != null) {
					if (salesEntry.get("cpntId") != null && !salesEntry.get("cpntId").toString().equals("")) {
						if (Integer.parseInt(salesEntry.get("cpntId").toString()) > 0) {
							salesEntry.put("callEntryId", callEntry.get("callEntryId").toString());
							salesEntry.put("CTID", firstAvailUser.get("ct"));
							salesEntry.put("CTgroup", firstAvailUser.get("ctSubGrp"));
							chatbotCallLogApiMapper.updateASEntry(salesEntry);
						}
					}
				}
			}

			Map<String, Object> orderLogList = new HashMap<String, Object>();
		    orderLogList.put("logId", 0);
		    orderLogList.put("salesOrderId", CommonUtils.nvl(orderInfo.get("salesOrdId")));
		    orderLogList.put("progressId", 4);
		    orderLogList.put("logDate", new Date());
		    orderLogList.put("refId", installMaster.get("installEntryId").toString());
		    orderLogList.put("isLock", true);
		    orderLogList.put("logCreator", 349);
		    orderLogList.put("logCreated", new Date());
		    chatbotCallLogApiMapper.insertSalesOrderLog(orderLogList);

			resultValue.setSuccess(true);
			resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_SUCCESS);
			resultValue.setMessage("Appointment Confirmed.");
		}
		else{
  			// REMOVE INSTALL ENTRY
  			if (installMaster != null && callEntId > 0) {
  				// PRE INSERT INSTALL ENTRY
  				chatbotCallLogApiMapper.deleteInstallEntry(installMaster);
  			}

  			resultValue.setSuccess(false);
  			resultValue.setStatusCode(AppConstants.RESPONSE_CODE_INTERNAL_FAILED);
  			resultValue.setMessage("Appointment Confirm Failed.");
		}

		return resultValue;
    }
}
