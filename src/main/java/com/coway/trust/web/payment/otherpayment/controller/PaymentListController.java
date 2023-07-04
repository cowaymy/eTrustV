package com.coway.trust.web.payment.otherpayment.controller;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.payment.otherpayment.service.PaymentListService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class PaymentListController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PaymentListController.class);

	@Value("${web.resource.upload.file}")
    private String uploadDir;

	@Resource(name = "paymentListService")
	private PaymentListService paymentListService;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@Autowired
    private MessageSourceAccessor messageAccessor;

	/******************************************************
	 *  Payment List
	 *****************************************************/
	/**
	 *  Payment List 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initPaymentList.do")
	public String initPaymentList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/otherpayment/paymentList";
	}

	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectGroupPaymentList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectGroupPaymentList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
        // 조회.
        List<EgovMap> resultList = paymentListService.selectGroupPaymentList(params);

        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value="/validDCF")
	public ResponseEntity<Map<String, Object>> validDCF(@RequestParam Map<String, Object> params) {
		int count = paymentListService.invalidDCF(params);
		Map<String, Object> returnMap = new HashMap<String, Object>();

		if (count > 0) {
			returnMap.put("error", "DCF Invalid for ('AER', 'ADR', 'AOR', 'EOR')");
		} else {
			returnMap.put("success", true);
		}

		return ResponseEntity.ok(returnMap);
	}

	@RequestMapping(value="/validFT")
	public ResponseEntity<Map<String, Object>> validFT(@RequestParam Map<String, Object> params) {
		int count = paymentListService.invalidFT(params);
		Map<String, Object> returnMap = new HashMap<String, Object>();

		if (count > 0) {
			returnMap.put("error", "FT Invalid for 'EOR'");
		} else {
			returnMap.put("success", true);
		}

		return ResponseEntity.ok(returnMap);
	}

	/******************************************************
	 * Payment List - Request DCF
	 *****************************************************/
	/**
	 * Payment List - Request DCF 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/initRequestDCFPop.do")
	public String initRequestDCFPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("groupSeq", params.get("groupSeq"));
		LOGGER.debug("payment List params : {} ", params);

        // 조회.
        //List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);
        //model.put("paymentList", resultList);

		return "payment/otherpayment/requestDCFPop";
	}

	@RequestMapping(value= "/checkDCFPopValid.do")
	public ResponseEntity<Map<String, Object>> checkDCFPopValid(@RequestParam Map<String, Object> params) {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		if (paymentListService.invalidReverse(params) > 0) {
			returnMap.put("success", false);
			returnMap.put("message", "Payment has Active or Completed reverse request.");
			return ResponseEntity.badRequest().body(returnMap);
		} else {
			returnMap.put("success", true);
			returnMap.put("message", "Ok");
			return ResponseEntity.ok(returnMap);
		}
	}

	/**
	 * Payment List - Request DCF 대상 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPaymentListByGroupSeq.do")
	public ResponseEntity<List<EgovMap>> selectPaymentListByGroupSeq(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		//조회.
		List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}

	/**
	 * Payment List - Request DCF 대상 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRequestDCFByGroupSeq.do")
	public ResponseEntity<List<EgovMap>> selectRequestDCFByGroupSeq(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestDCFByGroupSeq(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}


	/**
	 * Payment List - Request DCF 정보 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectReqDcfInfo.do")
	public ResponseEntity<EgovMap> selectReqDcfInfo(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		//조회.
		EgovMap resultMap = paymentListService.selectReqDcfInfo(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultMap);
	}

	/**
	 * Payment List - Request DCF 대상 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/requestDCF.do", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> requestDCF(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);

		// 저장
		params.put("userId", sessionVO.getUserId());
    	EgovMap resultMap = paymentListService.requestDCF(params);

		// 조회 결과 리턴.
    	return ResponseEntity.ok(resultMap);

	}

	/******************************************************
	 * Payment List - Confirm DCF
	 *****************************************************/
	/**
	 * Payment List - Confirm DCF 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmDCF.do")
	public String initConfirmDCF(@RequestParam Map<String, Object> params, ModelMap model) {

		return "payment/otherpayment/confirmDCF";
	}

	/**
	 * Payment List - Request DCF 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRequestDCFList.do")
	public ResponseEntity<List<EgovMap>> selectRequestDCFList(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestDCFList(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}

	/**
	 * Payment List - Confirm DCF 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmDCFPop.do")
	public String initConfirmDCFPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("groupSeq", params.get("groupSeq"));
		model.put("reqNo", params.get("reqNo"));
		model.put("dcfStusId", params.get("dcfStusId"));

		LOGGER.debug("payment List params : {} ", params);

		return "payment/otherpayment/confirmDCFPop";
	}

	/**
	 * Payment List - Reject DCF 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/rejectDCF.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectDCF(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);
		// 저장
		params.put("userId", sessionVO.getUserId());
		paymentListService.rejectDCF(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);

	}

	/**
	 * Payment List - Approval DCF 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/approvalDCF.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> approvalDCF(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);
		//EgovMap resultList;
		Map<String, Object> returnMap = new HashMap<String, Object>();

		// 저장
		params.put("userId", sessionVO.getUserId());

		Map<String, Object> result = paymentListService.approvalDCF(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		if (result != null) {
			message.setMessage((String) result.get("error"));
		} else {
			List<EgovMap> resultMapList = (List<EgovMap>) params.get("p1"); //

			if (resultMapList.size() > 0) {
				// 프로시저 결과 Map
				returnMap = (Map<String, Object>) resultMapList.get(0);
			}
			message.setMessage("Saved Successfully");
		}

		//return ResponseEntity.ok(message);
		return ResponseEntity.ok(returnMap);

	}

	/**
	 * Payment List - Request FT 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initRequestFTPop.do")
	public String initRequestFTPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("groupSeq", params.get("groupSeq"));
		model.put("payId", params.get("payId"));
		model.put("appTypeId", params.get("appTypeId"));
		LOGGER.debug("payment List params : {} ", params);

        // 조회.
        //List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);
        //model.put("paymentList", resultList);

		return "payment/otherpayment/requestFTPop";
	}

	/**
	 * Payment List - Request FT 대상 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectFTOldData.do")
	public ResponseEntity<EgovMap> selectFTOldData(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);
		EgovMap returnMap = null;
		//조회.
		List<EgovMap> resultList = paymentListService.selectFTOldData(params);

		if (resultList != null && resultList.size() > 0) {
			returnMap = resultList.get(0);
		} else {
			returnMap = new EgovMap();
		}

		// 조회 결과 리턴.
		return ResponseEntity.ok(returnMap);
	}


	/**
	 * Request Fund Transfer
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/requestFT", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> requestFT(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {

		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		Map<String, Object> formInfo = new HashMap<String, Object> ();

		if(formList.size() > 0){
    		for(Object obj : formList){
    			Map<String, Object> map = (Map<String, Object>) obj;
    			formInfo.put((String)map.get("name"), map.get("value"));
    		}
    	}
		//User ID 세팅
		formInfo.put("userId", sessionVO.getUserId());
		// 저장
		EgovMap resultMap = paymentListService.requestFT(formInfo,gridList);
		// 조회 결과 리턴.
    	return ResponseEntity.ok(resultMap);
	}


	/******************************************************
	 * Payment List - Confirm Fund Transfer
	 *****************************************************/
	/**
	 * Payment List - Confirm FT 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmFT.do")
	public String initConfirmFT(@RequestParam Map<String, Object> params, ModelMap model) {

		return "payment/otherpayment/confirmFT";
	}

	/**
	 * Payment List - Request FT 리스트 조회
	 * @param paramsinitConfirmFTPopinitConfirmFTPop
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRequestFTList.do")
	public ResponseEntity<List<EgovMap>> selectRequestFTList(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestFTList(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}

	/**
	 * Payment List - Confirm FT 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmFTPop.do")
	public String initConfirmFTPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("ftReqId", params.get("ftReqId"));
		model.put("ftStusId", params.get("ftStusId"));
		model.put("payId", params.get("payId"));
		model.put("groupSeq", params.get("groupSeq"));

		LOGGER.debug("payment List params : {} ", params);

		return "payment/otherpayment/confirmFTPop";
	}

	/**
	 * Payment List - Request FT 상세정보 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectReqFTInfo.do")
	public ResponseEntity<EgovMap> selectReqFTInfo(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		//조회.
		EgovMap resultMap = paymentListService.selectReqFTInfo(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultMap);
	}

	/**
	 * Payment List - Reject FT 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/rejectFT.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectFT(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);
		// 저장
		params.put("userId", sessionVO.getUserId());
		paymentListService.rejectFT(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);

	}

	/**
	 * Payment List - Approval FT 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/approvalFT.do", method = RequestMethod.POST)
	public ResponseEntity<Boolean> approvalFT(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);

		// 저장
		params.put("userId", sessionVO.getUserId());
		if (paymentListService.approvalFT(params) == 0) {
			return ResponseEntity.ok(false);
		}
		return ResponseEntity.ok(true);

	}

	/* ********** 20230306 CELESTE - REQUEST REFUND [S] ********** */

	@RequestMapping(value="/validRefund" ,  method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> validRefund(@RequestBody Map<String, Object> params) throws IOException {

		Map<String, Object> returnMap = new HashMap<String, Object>();
		LOGGER.debug("params Parameters: " + params);

		/*List<Object> selectedGridList = (List<Object>)params.get("data");*/
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> selectedOrder = mapper.readValue(params.get("selectedOrder").toString(), new TypeReference<List<Map<String, Object>>>(){});

		LOGGER.debug("selectedGridList Parameters: " + selectedOrder);

		int[] groupSeq = null;
		String[] revStusId = null;
		String[] ftStusId = null;

		if(selectedOrder.size() > 0){
			groupSeq = new int[selectedOrder.size()];
			revStusId = new String[selectedOrder.size()];
			ftStusId = new String[selectedOrder.size()];
			for(int i = 0; selectedOrder.size() > i; i++){
				groupSeq[i] = Integer.parseInt(selectedOrder.get(i).get("groupSeq").toString());
				revStusId[i] = selectedOrder.get(i).get("revStusId").toString();
				ftStusId[i] = selectedOrder.get(i).get("ftStusId").toString();
			}
			params.put("groupSeq", groupSeq);
			params.put("type", "REF");

			for(Map<String,Object> map : selectedOrder) {
			    Map<String,Object> tempMap = new LinkedHashMap<String,Object>(map);
			    map.clear();
			    map.put("type","REF");
			    map.putAll(tempMap);
			}
		}

		LOGGER.debug("selectedGridList: " + selectedOrder);
		LOGGER.debug("params: " + params);
		LOGGER.debug("groupSeq: " + groupSeq);

		int invalidTypeCount = paymentListService.invalidRefund(params);
		int invalidStatus = paymentListService.invalidStatus(params);
		List<EgovMap> invalidTypeList = paymentListService.selectInvalidORType(params);

		if(invalidTypeCount > 0) {
			returnMap.put("error", "Refund is invalid for " + invalidTypeList);
		}
		else if(invalidStatus > 0) {
			returnMap.put("error", "Payment has Active or Completed Refund request.");
		}
		else {
			String allowFlgYN = validateAction(selectedOrder);
			if(allowFlgYN != null && allowFlgYN != "" && allowFlgYN.equals("N")){
				returnMap.put("error", "Not Allow to proceed with Refund. Please reselect. ");
			}
			else if(allowFlgYN != null && allowFlgYN != "" && allowFlgYN.equals("Y")){
				returnMap.put("success", true);
			}
		}

		return ResponseEntity.ok(returnMap);
	}

	public String validateAction(@RequestParam List<Map<String, Object>> selectedOrder){

		//Map<String, Object> returnMap = new HashMap<String, Object>();
		// 20230627 - ADD IN NEW CHECKING INCLUSIVE OF OR_TYPE/MODE_ID/BANK_CODE/BANK_STATEMENT/2018[S]
		String allowFlg = null;
		if(selectedOrder.size() > 0 ){
			for(int i = 0; selectedOrder.size() > i; i++){
				Map<String, Object> validationParams = new HashMap<String, Object>();
				validationParams.put("orType", selectedOrder.get(i).get("orType"));
				validationParams.put("payItmModeId", selectedOrder.get(i).get("payItmModeId"));
				validationParams.put("type", selectedOrder.get(i).get("type"));

				/*if(Integer.parseInt(selectedOrder.get(i).get("payData").toString()) < 2018){
					validationParams.put("bankAcc", "ETC");
					validationParams.put("bkCrcFlg", "N");
					allowFlg = paymentListService.selectAllowFlg(validationParams);

					if(allowFlg == null){
						allowFlg = "N";
						//returnMap.put("error", "Not Allow to proceed with Refund. Please reselect. ");
						break;
					}
					//else if(allowFlg != null && allowFlg != "" && allowFlg.equals("Y")){
						//returnMap.put("success", true);
					}
				} */
				if(selectedOrder.get(i).containsKey("payData")){
					if(Integer.parseInt(selectedOrder.get(i).get("payData").toString()) >= 2018) {
						validationParams.put("bankAcc", selectedOrder.get(i).get("bankAcc"));

						if((selectedOrder.get(i).get("bankStateMappingId") != null && selectedOrder.get(i).get("bankStateMappingId") != "") || (selectedOrder.get(i).get("crcStateMappingId") != null && selectedOrder.get(i).get("crcStateMappingId") != "")){
							if((selectedOrder.get(i).get("bankStateMappingDt") != null && selectedOrder.get(i).get("bankStateMappingDt") != "") || (selectedOrder.get(i).get("crcStateMappingDt") != null && selectedOrder.get(i).get("crcStateMappingDt") != "")){
								validationParams.put("bkCrcFlg", "Y");
							}
							else{ //not allow to proceed if statement mapping date is empty but statement mapping id is not null
								allowFlg = "N";
								break;
							}
						}
						else
						{
							validationParams.put("bkCrcFlg", "N");
						}

						allowFlg = paymentListService.selectAllowFlg(validationParams);
						if(allowFlg == null){
							allowFlg = "N";
							break;
						}else if(allowFlg.equals("N")){
							break;
						}
					}
					else{
						allowFlg = "Y"; //payment before 2018 no need to do validation checking, allow to proceed.
					}
				}
				else{
					allowFlg = "N";
					break;
				}
			}
		}

		return allowFlg;
	}
	// 20230627 - ADD IN NEW CHECKING INCLUSIVE OF OR_TYPE/MODE_ID/BANK_CODE/BANK_STATEMENT/2018[E]

	/*@RequestMapping(value="/validRefund" ,  method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> validRefund(@RequestParam Map<String, Object> params){

		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		LOGGER.debug("validRefund Parameters: " + params);
		LOGGER.debug("list Parameters: " + list);

		//CHECK OR NO TYPE THAT ALLOW TO PERFORM REFUND
		String[] groupSeqList = params.get("groupSeqList").toString().replace("\"","").split(",");
		params.put("selectedGroupSeqList", groupSeqList);
		int invalidTypeCount = paymentListService.invalidRefund(params);
		int invalidStatus = paymentListService.invalidStatus(params);
		List<EgovMap> invalidTypeList = paymentListService.selectInvalidRefundType(params);
		LOGGER.debug("invalidTypeList: " + invalidTypeList);

		if(invalidTypeCount > 0) {
			returnMap.put("error", "Refund is invalid for " + invalidTypeList);
		}
		else if(invalidStatus > 0) {
			returnMap.put("error", "Payment has Active or Completed Refund request.");
		}
		else {
			returnMap.put("success", true);
		}

		//CHECK RESERVE STATUS - BLOCK WHN STATUS = 1 OR 5
		List<String> revStusList = Arrays.asList(params.get("revStusList").toString().replace("\"", "").split(","));
		List<String> rfStusList = Arrays.asList(params.get("rfStusList").toString().replace("\"", "").split(","));
		//boolean invalidStatusCount = false;

		if(revStusList.contains("1") || revStusList.contains("5")) {
			returnMap.put("error",  "Payment Group Number has been Requested or Approved. Please reselect before request for Refund.");
		}
		else {
			//CHECK REFUND STATUS - BLOCK WHEN STATUS = 1 OR 5
			if(rfStusList.contains("1") || rfStusList.contains("5")) {
				returnMap.put("error", "This has already been Refund processing Requested / Approved. ");
			}
			else {
				returnMap.put("success", true);
			}
		}

		// CHECK TRANSACTION DATE : BEFORE 2018 + CSH/CHQ/ONL + BOR/WOR --> ALLOW TO REFUND
		String[] payDataList = params.get("payDataList").toString().replace("\"", "").split(",");
		String[] orTypeList = params.get("orTypeList").toString().replace("\"", "").split(",");
		String[] payItmModeIdList = params.get("payItmModeIdList").toString().replace("\"", "").split(",");

		Map<String, Object> validationParams = new HashMap<String, Object>();
		int yearParam = 2018;
		String allowRef = "N";

		if(payDataList.length != 0){
			for(int i=0; i<payDataList.length; i++){
				if(yearParam > Integer.parseInt(payDataList[i])) {
					validationParams.put("bankAccId", "ETC");
				}
				else {
					validationParams.put("bankAccId", payItmModeIdList[i]);
				}
			}
		}

		if(orTypeList.length != 0){
			for(int i=0; i<orTypeList.length; i++){
				validationParams.put("orType", orTypeList[i]);
			}
		}

		if(payItmModeIdList.length != 0){
			for(int i=0; i<payItmModeIdList.length; i++){
				validationParams.put("payItemModeId", payItmModeIdList[i]);
			}
		}

		List<String> payDataListStr = Arrays.asList(payDataList.toString().replace("\"", "").split(","));
		List<String> orTypeListStr = Arrays.asList(params.get("orTypeList").toString().replace("\"", "").split(","));
		List<String> payItmModeIdListStr = Arrays.asList(params.get("payItmModeIdList").toString().replace("\"", "").split(","));

		//CHECK TRANSACTION ID IS NOT EMPTY AND HAS BEEN RECONCILE
		List<String> trxIdList = Arrays.asList(params.get("bankStateIdList").toString().replace("\"", "").split(","));
		List<String> trxDtList = Arrays.asList(params.get("bankStateMappingDt").toString().replace("\"", "").split(","));
		List<String> crcIdList = Arrays.asList(params.get("crcStateIdList").toString().replace("\"", "").split(","));
		List<String> crcDtList = Arrays.asList(params.get("crcStateMappingDt").toString().replace("\"", "").split(","));
		if((trxIdList.contains("0") || trxIdList.contains(null)) && (crcIdList.contains("0") || crcIdList.contains(null))) {
//		if(trxIdList.contains("0") || trxIdList.contains(null) || trxDtList.contains("0") || trxDtList.contains(null)) {
			returnMap.put("error", "Empty Statement ID record(s) are not allow for Refund. Please reselect before request for Refund. ");
		}
		else {
			returnMap.put("success",  true);
		}

		//CHECK RESERVE STATUS - BLOCK WHN STATUS = 1 OR 5
		String[] activeStatus = {"1", "5"};

		if(Arrays.asList(revStusId).containsAll(Arrays.asList(activeStatus))){
			returnMap.put("error",  "Payment Group Number has been Requested or Approved. Please reselect before request for Refund.");
		}
		else {
			if(Arrays.asList(ftStusId).containsAll(Arrays.asList(activeStatus))) {
				returnMap.put("error", "This has already been Refund processing Requested / Approved. ");
			}
			else {
				returnMap.put("success", true);
			}
		}

		return ResponseEntity.ok(returnMap);
	}*/

	@RequestMapping(value = "/initRequestRefundPop.do")
	public String initRequestRefundPop(@RequestParam Map<String, Object> params, ModelMap model) throws IOException {

		LOGGER.debug("params: " + params);

		// Convert string to List<Map<String, Object>> - using JACKSON
		/*ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> selectedOrder2 = mapper.readValue(params.get("selectedOrder").toString(), new TypeReference<List<Map<String, Object>>>(){});*/

		/*List<String> groupSeq = Arrays.asList(params.get("groupSeqList").toString().replace("\"", "").split(","));
		List<String> trxId= Arrays.asList(params.get("bankStateIdList").toString().replace("\"", "").split(","));
		List<String> appTypeId= Arrays.asList(params.get("appTypeIdList").toString().replace("\"", "").split(","));*/

		model.put("groupSeq", params.get("groupSeqList").toString().replace("\"", ""));
		model.put("payId", params.get("payIdList").toString().replace("\"", ""));
		model.put("appTypeId", params.get("appTypeIdList").toString().replace("\"", ""));

		return "payment/otherpayment/requestRefundPop";
	}

	/* 	private static class Item {
        private int groupSeq;
        private int payId;
    } */

	 /* @RequestMapping(value = "/initRequestRefundPop.do")
	public String initRequestRefundPop(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params: " + params);

		Pattern pattern = Pattern.compile("\\[.*?\\]");
        Matcher matcher = pattern.matcher((CharSequence) params.get("data"));
        String json = "";
        if (matcher.find()) {
            json = matcher.group();
        }

		Gson gson = new Gson();
        Item[] items = gson.fromJson(json, Item[].class);

        // Extract the seq and payId values from each item in the array
        List<Integer> seqList = new ArrayList<>();
        List<Integer> payIdList = new ArrayList<>();
        for (Item item : items) {
            seqList.add(item.groupSeq);
            payIdList.add(item.payId);
        }

        // Print the results
        System.out.println("seqList: " + seqList);
        System.out.println("payIdList: " + payIdList);

        params.put("groupSeq", seqList);
        params.put("payId", payIdList);

        float totalAmt = 0;

         LOGGER.debug("params: " + params);
		 List<EgovMap> resultList = paymentListService.selectRefundOldData(params);
		 for(int i =0; i < resultList.size(); i++){
			 totalAmt += Float.parseFloat(resultList.get(i).get("totAmt").toString());
		 }

		 LOGGER.debug("TotalAmt" + totalAmt);
		 model.addAttribute("oldAmt", totalAmt);
		 model.addAttribute("resultList", new Gson().toJson(resultList));

		return "payment/otherpayment/requestRefundPop";
	}*/

	@RequestMapping(value = "/selectRefundOldData.do")
	public ResponseEntity<List<EgovMap>> selectRefundOldData(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		String[] groupSeq = params.get("groupSeq").toString().replace("\"","").split(",");
		String[] payId = params.get("payId").toString().replace("\"","").split(",");
		String[] appTypeId = params.get("appTypeId").toString().replace("\"","").split(",");

		params.put("groupSeq", groupSeq);
		params.put("payId", payId);
		params.put("appTypeId", appTypeId);
		List<EgovMap> resultList = paymentListService.selectRefundOldData(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/requestRefund", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> requestRefund(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) throws Exception {

		//List<EgovFormBasedFileVo> attchList = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "Billing & Collection" + File.separator + "paymentList", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        //LOGGER.debug("attchList.size : {}", attchList.size());

		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // Get Grid Data
		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // Get form object data
		List<Object> apprList = params.get("apprGridList"); // Get form object data of Approval

		LOGGER.debug("gridList : {} ", gridList);
		LOGGER.debug("formList : {} ", formList);
		LOGGER.debug("apprGridList : {} ", apprList);

		Map<String, Object> formInfo = new HashMap<String, Object> ();

		if(formList.size() > 0){
    		for(Object obj : formList){
    			Map<String, Object> map = (Map<String, Object>) obj;
    			formInfo.put((String)map.get("name"), map.get("value"));
    		}
    	}

        /*if (attchList.size() > 0) {
    		formInfo.put(CommonConstants.USER_ID, sessionVO.getUserId());
    		formInfo.put("attachmentList", attchList);
        	//paymentListService.insertAttachment(FileVO.createList(attchList), FileType.WEB_DIRECT_RESOURCE, formInfo);
        	formInfo.put("fileGroupKey", params.get("fileGroupKey"));
        }*/

		//User ID setting
		formInfo.put("userId", sessionVO.getUserId());
		formInfo.put("userName", sessionVO.getUserName());
		formInfo.put("branch", sessionVO.getUserBranchId());
		LOGGER.debug("formInfo : {} ", formInfo);
		LOGGER.debug("gridList : {} ", gridList);
		EgovMap resultMap = new EgovMap();
		// Save
		resultMap = paymentListService.requestRefund(formInfo, gridList, apprList);
		// Return query results.
    	return ResponseEntity.ok(resultMap);
	}

	  @RequestMapping(value = "/requestApprovalLineCreatePop.do")
	  public String requestApprovalLineCreatePop(@RequestParam Map<String, Object>params, ModelMap model) {

		  return "payment/otherpayment/requestApprovalLineCreatePop";
	  }

	@RequestMapping(value = "/requestRefundUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> requestRefundUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		LOGGER.debug("params =====================================>>  " + params);
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "payment" + File.separator + "paymentList", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		params.put("userId", sessionVO.getUserId());
		if(list.size() > 0) {
			paymentListService.insertAttachment(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
			List<EgovMap> fileInfo = webInvoiceService.selectAttachList(params.get("fileGroupKey").toString());
			if(fileInfo != null){
				params.put("atchFileId", fileInfo.get(0).get("atchFileId"));
			}
		}
		params.put("attachFiles", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
	}

	/******************************************************
	 * Payment List - Confirm Refund
	 *****************************************************/
	/**
	 * Payment List - Confirm Refund
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initConfirmRefund.do")
	public String initConfirmRefund(@RequestParam Map<String, Object> params, ModelMap model) {

		if(params.containsKey("clmNo")){
			model.put("reqNo", params.get("clmNo").toString());
		}

		return "payment/otherpayment/confirmRefund";
	}

	@RequestMapping(value = "/selectRequestRefundList.do")
	public ResponseEntity<List<EgovMap>> selectRequestRefundList(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("params : {} ", params);

		//조회.
		params.put("memCode", sessionVO.getUserMemCode());
		List<EgovMap> resultList = paymentListService.selectRequestRefundList(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/initConfirmRefundPop.do")
	public String initConfirmRefundPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("groupSeq", params.get("groupSeq").toString().replace("\"", ""));
		model.put("reqId", params.get("reqId").toString().replace("\"", ""));
		model.put("refStusId", params.get("refStusId").toString().replace("\"", ""));
		model.put("salesOrdNo", params.get("salesOrdNo").toString().replace("\"", ""));
		model.put("appvStus", params.get("appvStus"));

		LOGGER.debug("payment List params : {} ", params);

		return "payment/otherpayment/confirmRefundPop";
	}

	@RequestMapping(value = "/selectRequestRefundByGroupSeq.do")
	public ResponseEntity<List<EgovMap>> selectRequestRefundByGroupSeq(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		String[] groupSeq = params.get("groupSeq").toString().replace("\"","").split(",");

		params.put("groupSeq", groupSeq);

		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestRefundByGroupSeq(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectReqRefundInfo.do")
	public ResponseEntity<EgovMap> selectReqRefundInfo(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		String[] reqNo = params.get("reqNo").toString().replace("\"","").split(",");

		params.put("reqNo", reqNo);

		//조회.
		EgovMap resultMap = paymentListService.selectReqRefundInfo(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultMap);
	}

	//Refund Approval
	@RequestMapping(value = "/approvalRefund.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvalRefund(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);
		//EgovMap resultList;
		Map<String, Object> returnMap = new HashMap<String, Object>();

		// 저장
		params.put("userId", sessionVO.getUserId());
		params.put("memCode", sessionVO.getUserMemCode());
/*		String[] groupSeq = params.get("groupSeq").toString().replace("\"","").split(",");
		params.put("groupSeq", groupSeq);*/

		Map<String, Object> result = paymentListService.approvalRefund(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		if (result.get("success").toString().equals("success")) {
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(result.get("msg").toString());
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage((String) result.get("error"));
		}

		//return ResponseEntity.ok(message);
//		return ResponseEntity.ok(returnMap);

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/rejectRefund.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectRefund(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);
		// 저장

/*		List<Object> oldInfoGridList = (List<Object>) params.get("oldInfoGridList");
		for (int i = 0; i < oldInfoGridList.size(); i++) {
			Map<String, Object> oldInfoDet = (Map<String, Object>) oldInfoGridList.get(i);
			String appvPrcssNo = (String) oldInfoDet.get("appvPrcssNo");

			Map<String, Object> appvParam = new HashMap<String, Object>();
			appvParam.put("appvPrcssNo", appvPrcssNo);

			List<EgovMap> appvLineInfo = paymentListService.selectReqRefundApprovalItem(appvParam);
			List<String> appvLineUserId = new ArrayList<>();
            for(int a = 0; a < appvLineInfo.size(); a++) {
                EgovMap info = appvLineInfo.get(a);
                appvLineUserId.add(info.get("appvLineUserId").toString());
            }
		}*/

		params.put("userName",sessionVO.getUserName());
		params.put("userId", sessionVO.getUserId());
		paymentListService.rejectRefund(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/getAttachmentInfo1.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> getAttachmentInfo1(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		Map<String, Object> fileInfo = webInvoiceService.selectAttachmentInfo(params);

		return ResponseEntity.ok(fileInfo);
	}
	/* ********** 20230306 CELESTE - REQUEST REFUND [E] ********** */
}
