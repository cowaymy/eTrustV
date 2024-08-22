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
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.biz.payment.otherpayment.service.PaymentListService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.PageAuthVO;
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
	private CommonPaymentService commonPaymentService;

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
		params.put("groupSeq", params.get("groupSeq").toString().split(""));

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

		// CELESTE [26/07/2024] PROJECT ID: 7084993469 - [Enhancement] New AFR affected current process [S]

		/*if (count > 0) {
		returnMap.put("error", "FT Invalid for 'EOR'");
		} */

		if (count > 0) {
			String remark = "FT is only valid for (";
			params.put("type", "FT");
			List<EgovMap> invalidTypeList = paymentListService.selectInvalidORCodeNm(params);

			for(int i = 0; i < invalidTypeList.size(); i++){
				EgovMap invalidTypeCode = invalidTypeList.get(i);
				String invalidORNm = invalidTypeCode.get("code").toString();

				remark += invalidORNm + ", ";
			}
			remark = remark.replaceAll(", $", "") + ")";
			returnMap.put("error", remark);
		}

    	// CELESTE [26/07/2024] PROJECT ID: 7084993469 - [Enhancement] New AFR affected current process [E]
		else {
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

		model.put("groupSeq", params.get("groupSeqList").toString().replace("\"", ""));
		LOGGER.debug("payment List params : {} ", params);

        // 조회.
        //List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);
        //model.put("paymentList", resultList);

		return "payment/otherpayment/requestDCFPop";
	}

	@RequestMapping(value = "/initRequestDCFPopOld.do")
	public String initRequestDCFPopOld(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("groupSeq", params.get("groupSeq").toString().replace("\"", ""));
		LOGGER.debug("payment List params : {} ", params);

		// 조회.
		//List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);
		//model.put("paymentList", resultList);

		return "payment/otherpayment/requestDCFPopOld";
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

		String[] groupSeqList = params.get("groupSeq").toString().replace("\"","").split(",");
		params.put("groupSeq", groupSeqList);

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

		String[] groupSeqList = params.get("groupSeq").toString().replace("\"","").split(",");
		params.put("groupSeq", groupSeqList);
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

		if(params.containsKey("clmNo")){
			model.put("reqNo", params.get("clmNo").toString());
		}
		return "payment/otherpayment/confirmDCF";
	}

	/**
	 * Payment List - Request DCF 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRequestDCFList.do")
	public ResponseEntity<List<EgovMap>> selectRequestDCFList(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("params : {} ", params);

		//조회.
		params.put("memCode", sessionVO.getUserMemCode());
		params.put("memUserId", sessionVO.getUserId());
		params.put("adminRole", params.get("pageAuthFuncUserDefine4").toString());
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

		model.put("groupSeq", params.get("groupSeqList").toString().replace("\"", ""));
		model.put("reqNo", params.get("reqNo"));
		model.put("reqNo", params.get("dcfReqIdList").toString().replace("\"", ""));
		model.put("dcfStusId", params.get("dcfStusIdList").toString().replace("\"", ""));
		model.put("dcfReqType", params.get("dcfReqTypeList").toString().replace("\"", ""));

		LOGGER.debug("payment List params : {} ", params);

		return "payment/otherpayment/confirmDCFPop";
	}

	@RequestMapping(value = "/initConfirmNewDCFPop.do")
	public String initConfirmNewDCFPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("groupSeq", params.get("groupSeqList").toString().replace("\"", ""));
		model.put("dcfReqNo", params.get("dcfReqIdList").toString());
		model.put("dcfStusId", params.get("dcfStusIdList").toString().replace("\"", ""));
		model.put("dcfReqType", params.get("dcfReqTypeList").toString().replace("\"", ""));

		LOGGER.debug("payment List params : {} ", params);

		return "payment/otherpayment/confirmNewDCFPop";
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
		try{
		LOGGER.error("PaymentAA params Parameters: " + params);

		/*List<Object> selectedGridList = (List<Object>)params.get("data");*/
		ObjectMapper mapper = new ObjectMapper();

		LOGGER.error("PaymentAAA params Parameters 2: " + params.get("selectedOrder").toString());

		List<Map<String, Object>> selectedOrder = mapper.readValue(params.get("selectedOrder").toString(), new TypeReference<List<Map<String, Object>>>(){});
		LOGGER.error("PaymentAAAA params Parameters 3: " + selectedOrder);

		int[] groupSeq = null;
		String[] revStusId = null;
		String[] ftStusId = null;
		String[] revStusNm = null;
		String[] payId = null;

		if(selectedOrder.size() > 0){
			groupSeq = new int[selectedOrder.size()];
			revStusId = new String[selectedOrder.size()];
			ftStusId = new String[selectedOrder.size()];
			revStusNm = new String[selectedOrder.size()];
			payId = new String[selectedOrder.size()];
			for(int i = 0; selectedOrder.size() > i; i++){
				groupSeq[i] = Integer.parseInt(selectedOrder.get(i).get("groupSeq").toString());
				revStusId[i] = selectedOrder.get(i).get("revStusId").toString();
				ftStusId[i] = selectedOrder.get(i).get("ftStusId").toString();
				revStusNm[i] = selectedOrder.get(i).containsKey("revStusNm") ? selectedOrder.get(i).get("revStusNm").toString() : null;
				payId[i] = selectedOrder.get(i).containsKey("payId") ? selectedOrder.get(i).get("payId").toString() : null;
			}
			params.put("groupSeq", groupSeq);
			params.put("revStusId", revStusId);
			params.put("ftStusId", ftStusId);
			params.put("revStusNm", revStusNm);
			params.put("payId", payId);
			params.put("type", "REF");

			for(Map<String,Object> map : selectedOrder) {
			    Map<String,Object> tempMap = new LinkedHashMap<String,Object>(map);
			    map.clear();
			    map.put("type","REF");
			    map.putAll(tempMap);
			}
		}

		LOGGER.error("PaymentAA selectedGridList: " + selectedOrder);
		LOGGER.error("PaymentAA params: " + params);
		LOGGER.error("PaymentAA groupSeq: " + groupSeq);

		int invalidTypeCount = paymentListService.invalidRefund(params);
		int invalidStatus = paymentListService.invalidStatus(params);
		List<EgovMap> invalidTypeList = paymentListService.selectInvalidORType(params);

		/*if(invalidTypeCount > 0) {
			returnMap.put("error", "Refund is invalid for " + invalidTypeList);
		}*/
		// CELESTE [26/07/2024] PROJECT ID: 7084993469 - [Enhancement] New AFR affected current process [S]

		/*if (invalidTypeCount > 0) {
			returnMap.put("error", "DCF Invalid for ('AER', 'ADR', 'AOR', 'EOR', 'AFR')");
	    }*/

		if (invalidTypeCount > 0) {
			String remark = "Refund is only valid for (";
			List<EgovMap> invalidTypeListNm = paymentListService.selectInvalidORCodeNm(params);

			for(int i = 0; i < invalidTypeListNm.size(); i++){
				EgovMap invalidTypeCode = invalidTypeListNm.get(i);
				String invalidORNm = invalidTypeCode.get("code").toString();

				remark += invalidORNm + ", ";
			}
			remark = remark.replaceAll(", $", "") + ")";
			returnMap.put("error", remark);

    	// CELESTE [26/07/2024] PROJECT ID: 7084993469 - [Enhancement] New AFR affected current process [E]
		}
		else if((Arrays.asList(revStusId).contains("1") || Arrays.asList(revStusId).contains("5")) && (Arrays.asList(ftStusId).contains("1") || Arrays.asList(ftStusId).contains("5"))){
			returnMap.put("error", "Payment Group Number has already been Requested or Approved. Please reselect before Request Refund");
		}
		else if(Arrays.asList(revStusNm).contains("Refund") ){
			returnMap.put("error", "Payment Group Number has already been Refunded. Please reselect before Request Refund");
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
		LOGGER.error("PaymentAA complete: " + groupSeq);
		} catch (Exception e){
			e.printStackTrace();
			LOGGER.error("PaymentAA EXCEPTION HANDLER: " + e.toString());
		}

		return ResponseEntity.ok(returnMap);

	}

	@RequestMapping(value="/validRefund1" ,  method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> validRefund1(@RequestBody Map<String, Object> params) throws IOException {


		Map<String, Object> returnMap = new HashMap<String, Object>();
		try{
		LOGGER.error("PaymentAA params Parameters: " + params);

		/*List<Object> selectedGridList = (List<Object>)params.get("data");*/
		ObjectMapper mapper = new ObjectMapper();

		LOGGER.error("PaymentAAA params Parameters 2: " + params.get("selectedOrder").toString());

		List<Map<String, Object>> selectedOrder = Arrays.asList(mapper.readValue(params.get("selectedOrder").toString(),Map[].class));
		LOGGER.error("PaymentAAAA params Parameters 3: " + selectedOrder);

//		List<Map<String, Object>> selectedOrder2 = mapper.readValue(params.get("selectedOrder").toString(), new TypeReference<List<Map<String, Object>>>(){});

		LOGGER.error("PaymentAA selectedGridList Parameters: " + selectedOrder);

		int[] groupSeq = null;
		String[] revStusId = null;
		String[] ftStusId = null;
		String[] revStusNm = null;
		String[] payId = null;

		if(selectedOrder.size() > 0){
			groupSeq = new int[selectedOrder.size()];
			revStusId = new String[selectedOrder.size()];
			ftStusId = new String[selectedOrder.size()];
			revStusNm = new String[selectedOrder.size()];
			payId = new String[selectedOrder.size()];
			for(int i = 0; selectedOrder.size() > i; i++){
				groupSeq[i] = Integer.parseInt(selectedOrder.get(i).get("groupSeq").toString());
				revStusId[i] = selectedOrder.get(i).get("revStusId").toString();
				ftStusId[i] = selectedOrder.get(i).get("ftStusId").toString();
				revStusNm[i] = selectedOrder.get(i).containsKey("revStusNm") ? selectedOrder.get(i).get("revStusNm").toString() : null;
				payId[i] = selectedOrder.get(i).containsKey("payId") ? selectedOrder.get(i).get("payId").toString() : null;
			}
			params.put("groupSeq", groupSeq);
			params.put("revStusId", revStusId);
			params.put("ftStusId", ftStusId);
			params.put("revStusNm", revStusNm);
			params.put("payId", payId);
			params.put("type", "REF");

			for(Map<String,Object> map : selectedOrder) {
			    Map<String,Object> tempMap = new LinkedHashMap<String,Object>(map);
			    map.clear();
			    map.put("type","REF");
			    map.putAll(tempMap);
			}
		}

		LOGGER.error("PaymentAA selectedGridList: " + selectedOrder);
		LOGGER.error("PaymentAA params: " + params);
		LOGGER.error("PaymentAA groupSeq: " + groupSeq);

		int invalidTypeCount = paymentListService.invalidRefund(params);
		int invalidStatus = paymentListService.invalidStatus(params);
		List<EgovMap> invalidTypeList = paymentListService.selectInvalidORType(params);

		if(invalidTypeCount > 0) {
			returnMap.put("error", "Refund is invalid for " + invalidTypeList);
		}
		else if((Arrays.asList(revStusId).contains("1") || Arrays.asList(revStusId).contains("5")) && (Arrays.asList(ftStusId).contains("1") || Arrays.asList(ftStusId).contains("5"))){
			returnMap.put("error", "Payment Group Number has already been Requested or Approved. Please reselect before Request Refund");
		}
		else if(Arrays.asList(revStusNm).contains("Refund") ){
			returnMap.put("error", "Payment Group Number has already been Refunded. Please reselect before Request Refund");
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
		LOGGER.error("PaymentAA complete: " + groupSeq);
		} catch (Exception e){
			e.printStackTrace();
			LOGGER.error("PaymentAA EXCEPTION HANDLER: " + e.toString());
		}

		return ResponseEntity.ok(returnMap);

	}

	public String validateAction(@RequestParam List<Map<String, Object>> selectedOrder){

		//Map<String, Object> returnMap = new HashMap<String, Object>();
		// 20230627 - ADD IN NEW CHECKING INCLUSIVE OF OR_TYPE/MODE_ID/BANK_CODE/BANK_STATEMENT/2018[S]
		EgovMap allowFlg = null;
		String allowReq = null;
		if(selectedOrder.size() > 0 ){
			for(int i = 0; selectedOrder.size() > i; i++){
				Map<String, Object> validationParams = new HashMap<String, Object>();
				validationParams.put("orType", selectedOrder.get(i).get("orType"));
				validationParams.put("payItmModeId", selectedOrder.get(i).get("payItmModeId"));
				validationParams.put("type", selectedOrder.get(i).get("type"));

				if(selectedOrder.get(i).containsKey("payData")){
					if(Integer.parseInt(selectedOrder.get(i).get("payData").toString()) >= 2018) {
						validationParams.put("bankAcc", selectedOrder.get(i).get("bankAcc"));

						allowFlg = paymentListService.selectAllowFlg(validationParams);

						if(allowFlg != null && allowFlg.get("allow").toString().equals("Y")){
							if(allowFlg.get("flg").toString().equals("Y")){
								if((selectedOrder.get(i).get("bankStateMappingId") != null && selectedOrder.get(i).get("bankStateMappingId") != "") || (selectedOrder.get(i).get("crcStateMappingId") != null && selectedOrder.get(i).get("crcStateMappingId") != "")){
									allowReq = "Y";
	    						}
	    						else
	    						{
	    							allowReq = "N";
	    							break;
	    						}
							}else{
								allowReq = "Y";
							}

						}
						else{
							allowReq = "N";
							break;
						}

					}
					else{
						allowReq = "Y"; //payment before 2018 no need to do validation checking, allow to proceed.
					}
				}
				else{
					allowReq = "N";
					break;
				}
			}
		}

		return allowReq;
	}

	/*public String validateAction(@RequestParam List<Map<String, Object>> selectedOrder){

		//Map<String, Object> returnMap = new HashMap<String, Object>();
		// 20230627 - ADD IN NEW CHECKING INCLUSIVE OF OR_TYPE/MODE_ID/BANK_CODE/BANK_STATEMENT/2018[S]
		String allowFlg = null;
		if(selectedOrder.size() > 0 ){
			for(int i = 0; selectedOrder.size() > i; i++){
				Map<String, Object> validationParams = new HashMap<String, Object>();
				validationParams.put("orType", selectedOrder.get(i).get("orType"));
				validationParams.put("payItmModeId", selectedOrder.get(i).get("payItmModeId"));
				validationParams.put("type", selectedOrder.get(i).get("type"));

				if(Integer.parseInt(selectedOrder.get(i).get("payData").toString()) < 2018){
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
				}
				if(selectedOrder.get(i).containsKey("payData")){
					if(Integer.parseInt(selectedOrder.get(i).get("payData").toString()) >= 2018) {
						validationParams.put("bankAcc", selectedOrder.get(i).get("bankAcc"));

						if((selectedOrder.get(i).get("bankStateMappingId") != null && selectedOrder.get(i).get("bankStateMappingId") != "") || (selectedOrder.get(i).get("crcStateMappingId") != null && selectedOrder.get(i).get("crcStateMappingId") != "")){
							//if((selectedOrder.get(i).get("bankStateMappingDt") != null && selectedOrder.get(i).get("bankStateMappingDt") != "") || (selectedOrder.get(i).get("crcStateMappingDt") != null && selectedOrder.get(i).get("crcStateMappingDt") != "")){
							validationParams.put("bkCrcFlg", "Y");
//							}
//							else{ //not allow to proceed if statement mapping date is empty but statement mapping id is not null
//								allowFlg = "N";
//								break;
//							}
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
	}*/
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
	  public String requestApprovalLineCreatePop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) {
		  model.put("loginUser", sessionVO.getUserMemCode());
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
	public ResponseEntity<List<EgovMap>> selectRequestRefundList(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO, PageAuthVO pageAuthVO) {
		LOGGER.debug("params : {} ", params);

		//조회.
		params.put("memCode", sessionVO.getUserMemCode());
		params.put("adminRole", params.get("pageAuthFuncUserDefine4").toString());
		//LOGGER.debug("adminRole: ", params.get("pageAuthFuncUserDefine4"));
		//params.put("roleId", sessionVO.getRoleId());
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
		//model.put("reqNo", params.get("reqNo"));

		LOGGER.debug("payment List params : {} ", params);

		return "payment/otherpayment/confirmRefundPop";
	}

	@RequestMapping(value = "/selectRequestRefundByGroupSeq.do")
	public ResponseEntity<List<EgovMap>> selectRequestRefundByGroupSeq(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		String[] groupSeq = params.get("groupSeq").toString().replace("\"","").split(",");
		String[] reqNo = params.get("reqNo").toString().replace("\"","").split(",");

		params.put("groupSeq", groupSeq);
		params.put("reqNo", reqNo);

		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestRefundByGroupSeq(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectReqRefundInfo.do")
	public ResponseEntity<EgovMap> selectReqRefundInfo(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("params : {} ", params);

		//String[] reqNo = params.get("reqNo").toString().replace("\"","").split(",");

		params.put("reqNo", params.get("reqNo"));
		//params.put("reqId", reqNo[0]);
		params.put("memCode", sessionVO.getUserMemCode());

		LOGGER.debug("params : {} ", params);

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

	/** BOI - DCF **/
//	@RequestMapping(value="/validDCF2", method = RequestMethod.GET)
//	public ResponseEntity<Map<String, Object>> validDCF2(@RequestParam Map<String, Object> params) throws IOException{
//		Map<String, Object> returnMap = new HashMap<String, Object>();
//
//
//		String[] groupSeqList = params.get("groupSeqList").toString().replace("\"","").split(",");
//		params.put("groupSeq", groupSeqList);
//		//CHECK OR NO TYPE - ONLY WOR, OR, BOR ALLOW TO PERFORM DCF
//		int countInvalidType = paymentListService.invalidDCF(params);
//		//CHECK RESERVE STATUS - BLOCK WHN STATUS = 1 AND 5
//		int countInvalidStatus = paymentListService.invalidStatus(params);
//
//		if (countInvalidType > 0) {
//			returnMap.put("error", "DCF Invalid for ('AER', 'ADR', 'AOR', 'EOR')");
//		} else  if (countInvalidStatus > 0) {
//			returnMap.put("error", "Payment has Active or Completed reverse request.");
//		} else {
//			returnMap.put("success", true);
//		}
//
//		return ResponseEntity.ok(returnMap);
//	}

	@RequestMapping(value="/validDCF2", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> validDCF2(@RequestBody Map<String, Object> params) throws JsonParseException, JsonMappingException, IOException{
		Map<String, Object> returnMap = new HashMap<String, Object>();

		try{
    		LOGGER.error("VALIDDCF2 params Parameters: " + params);

    		ObjectMapper mapper = new ObjectMapper();

    		List<Map<String, Object>> selectedOrder = mapper.readValue(params.get("selectedOrder").toString(), new TypeReference<List<Map<String, Object>>>(){});

    		LOGGER.error("VALIDDCF2 params Parameters IN LIST OBJECT: " + selectedOrder.toString());
    		int[] groupSeq = null;
    		String[] revStusId = null;
    		String[] ftStusId = null;
    		String[] revStusNm = null;

    		if(selectedOrder.size() > 0){
    			groupSeq = new int[selectedOrder.size()];
    			revStusId = new String[selectedOrder.size()];
    			ftStusId = new String[selectedOrder.size()];
    			revStusNm = new String[selectedOrder.size()];

    			for(int i = 0; selectedOrder.size() > i; i++){
    				groupSeq[i] = Integer.parseInt(selectedOrder.get(i).get("groupSeq").toString());
    				revStusId[i] = selectedOrder.get(i).get("revStusId").toString();
    				ftStusId[i] = selectedOrder.get(i).get("ftStusId").toString();
    				revStusNm[i] = selectedOrder.get(i).containsKey("revStusNm") ? selectedOrder.get(i).get("revStusNm").toString() : null;
    			}
    			params.put("groupSeq", groupSeq);
    			params.put("type", "DCF");

    			for(Map<String,Object> map : selectedOrder) {
    			    Map<String,Object> tempMap = new LinkedHashMap<String,Object>(map);
    			    map.clear();
    			    map.put("type","DCF");
    			    map.putAll(tempMap);
    			}
    		}

    		//CHECK OR NO TYPE - ONLY WOR, OR, BOR ALLOW TO PERFORM DCF
    		int invalidTypeCount = paymentListService.invalidDCF(params);
    		//CHECK RESERVE STATUS - BLOCK WHN STATUS = 1 AND 5
    		int invalidStatus = paymentListService.invalidStatus(params);

    		// CELESTE [26/07/2024] PROJECT ID: 7084993469 - [Enhancement] New AFR affected current process [S]

    		/*if (invalidTypeCount > 0) {
				returnMap.put("error", "DCF Invalid for ('AER', 'ADR', 'AOR', 'EOR', 'AFR')");
		    }*/

    		if (invalidTypeCount > 0) {
    			String remark = "DCF is only valid for (";
    			List<EgovMap> invalidTypeList = paymentListService.selectInvalidORCodeNm(params);

    			for(int i = 0; i < invalidTypeList.size(); i++){
    				EgovMap invalidTypeCode = invalidTypeList.get(i);
    				String invalidORNm = invalidTypeCode.get("code").toString();

    				remark += invalidORNm + ", ";
    			}
    			remark = remark.replaceAll(", $", "") + ")";
    			returnMap.put("error", remark);

        	// CELESTE [26/07/2024] PROJECT ID: 7084993469 - [Enhancement] New AFR affected current process [E]

    		} else if((Arrays.asList(revStusId).contains("1") || Arrays.asList(revStusId).contains("5")) &&
    				(Arrays.asList(ftStusId).contains("1") || Arrays.asList(ftStusId).contains("5")) ){
    			returnMap.put("error", "Payment Group Number has already been Requested or Approved. Please reselect before Request DCF.");
    		}else if(Arrays.asList(revStusNm).contains("Refund")){
    			returnMap.put("error", "Payment Group Number has already been Refunded. Please reselect before Request DCF.");
    		}else  if (invalidStatus > 0) {
    			returnMap.put("error", "Payment has Active or Completed reverse request.");
    		} else {
    			String allowFlgYN = validateAction(selectedOrder);
    			if(allowFlgYN != null && allowFlgYN != "" && allowFlgYN.equals("N")){
    				returnMap.put("error", "Not Allow to proceed with DCF. Please reselect. ");
    			}
    			else if(allowFlgYN != null && allowFlgYN != "" && allowFlgYN.equals("Y")){
    				returnMap.put("success", true);
    			}
    		}

    		} catch (Exception e){
    			e.printStackTrace();
        		LOGGER.error("VALIDDCF2 EXCEPTION HANDLER: " + e.toString());
    		}
		return ResponseEntity.ok(returnMap);
	}

	@RequestMapping(value = "/selectReqDcfNewInfo.do", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> selectReqDcfNewInfo(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO ) {
		LOGGER.debug("params : {} ", params);

		params.put("memCode", sessionVO.getUserMemCode());

		//조회.
		EgovMap resultMap = paymentListService.selectReqDcfNewInfo(params);

		String remark = "[" + resultMap.get("reqstDt") + "], [Raised by: " + resultMap.get("dcfCrtUserNm") + "]: " + resultMap.get("reqRemark") + "\n";

		params.put("appvNo", resultMap.get("appvPrcssNo"));
		List<EgovMap> approvalList = paymentListService.selectReqDcfNewAppv(params);

		for(int i = 0; i < approvalList.size(); i++){
			EgovMap appvInfo = approvalList.get(i);
			String appvStus = appvInfo.get("appvStus").toString();
			String appvDt = appvInfo.containsKey("appvDt") ? appvInfo.get("appvDt").toString() : "";
			String appvNm = appvInfo.get("appvLineUserName").toString();
			String appvRem = appvInfo.containsKey("appvRem") ? appvInfo.get("appvRem").toString() : "";

			if(appvStus.equals("R") || appvStus.equals("T")){
				remark += "Pending by:" + appvNm + "\n";
			}else if(appvStus.equals("A")){
				remark += "[" + appvDt + "], [Approved by:" + appvNm + "]: " + appvRem + "\n";
			}else if(appvStus.equals("J")){
				remark += "[" + appvDt + "], [Rejected by:" + appvNm + "]: " + appvRem + "\n";
			}
		}

		resultMap.put("remark", remark);

		EgovMap selectReqDcfAppvDetails = paymentListService.selectDcfInfo(params);

		String allowAppvFlg = "N";
		if(selectReqDcfAppvDetails !=null){
			if(selectReqDcfAppvDetails.get("appvLineUserId").toString().equals(sessionVO.getUserMemCode().toString())){
				allowAppvFlg = "Y";
			}
		}


		resultMap.put("allowAppvFlg", allowAppvFlg);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultMap);
	}

	@RequestMapping(value = "/selectRequestNewDCFByGroupSeq.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectRequestNewDCFByGroupSeq(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params : {} ", params);

		//조회.
		List<EgovMap> resultList = paymentListService.selectRequestNewDCFByGroupSeq(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/requestDcfFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> requestDcfFileUpdate(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		ReturnMessage message = new ReturnMessage();

    	// DCF Validation
		message = requestDcfValidation(params);

		if(message.getCode().equals(AppConstants.SUCCESS)){
			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
					File.separator + "payment" + File.separator + "paymentList", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

			LOGGER.debug("list.size : {}", list.size());

        	params.put(CommonConstants.USER_ID, sessionVO.getUserId());
        	params.put("keyInBranch", sessionVO.getUserBranchId());
        	params.put("userName", sessionVO.getUserName());

        	// INSERT
        	if(list.size() > 0){
            	paymentListService.insertRequestDcfAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);

        		List<EgovMap> fileInfo = webInvoiceService.selectAttachList(params.get("fileGroupKey").toString());
        		if(fileInfo != null){
         			params.put("atchFileId", fileInfo.get(0).get("atchFileId"));
        		}
        	}
        	params.put("attachFiles", list);

        	// INSERT DCF INFO
        	EgovMap resultMap = paymentListService.requestDCF2(params);

    		message.setCode(AppConstants.SUCCESS);
    		message.setData(params);
    		message.setMessage("DCF request has been submitted with Request No: DCF" + resultMap.get("reqId").toString());
		}

		return ResponseEntity.ok(message);

	}

	public ReturnMessage requestDcfValidation(@RequestParam Map<String, Object> params)throws JsonParseException, JsonMappingException, IOException{
		ReturnMessage message = new ReturnMessage();
		ObjectMapper mapper = new ObjectMapper();

		Map<String, Object> dcfInfoResult = mapper.readValue(params.get("dcfInfo").toString(), new TypeReference<Map<String, Object>>(){});
    	String[] groupSeqList = dcfInfoResult.get("groupSeq").toString().split(",");
		params.put("groupSeq", groupSeqList);

		List<Map<String, Object>> selectedOrder = mapper.readValue(params.get("oldRequestDcfGrid").toString(), new TypeReference<List<Map<String, Object>>>(){});
		String[] revStusId = null;
		String[] ftStusId = null;
		String[] revStusNm = null;

		if(selectedOrder.size() > 0){
			revStusId = new String[selectedOrder.size()];
			ftStusId = new String[selectedOrder.size()];
			revStusNm = new String[selectedOrder.size()];

			for(int i = 0; selectedOrder.size() > i; i++){
				revStusId[i] = selectedOrder.get(i).get("revStusId").toString();
				ftStusId[i] = selectedOrder.get(i).get("ftStusId").toString();
				revStusNm[i] = selectedOrder.get(i).containsKey("revStusNm") ? selectedOrder.get(i).get("revStusNm").toString() : null;
			}
			params.put("type", "DCF");

			for(Map<String,Object> map : selectedOrder) {
			    Map<String,Object> tempMap = new LinkedHashMap<String,Object>(map);
			    map.clear();
			    map.put("type","DCF");
			    map.putAll(tempMap);
			}
		}

		// Start validation
		if (paymentListService.invalidDCF(params) > 0) {
			message.setCode(AppConstants.FAIL);
			message.setData(params);
			message.setMessage("DCF Invalid for ('AER', 'ADR', 'AOR', 'EOR')");
			return message;

		}  else if((Arrays.asList(revStusId).contains(1) || Arrays.asList(revStusId).contains(5)) &&
				(Arrays.asList(ftStusId).contains(1) || Arrays.asList(ftStusId).contains(5)) ){
			message.setCode(AppConstants.FAIL);
			message.setData(params);
			message.setMessage("Payment Group Number has already been Requested or Approved. Please reselect before Request DCF.");
			return message;

		}else if(Arrays.asList(revStusNm).contains("Refund")){
			message.setCode(AppConstants.FAIL);
			message.setData(params);
			message.setMessage("Payment Group Number has already been Refunded. Please reselect before Request DCF.");
			return message;

		} else if (paymentListService.invalidStatus(params) > 0) {
			message.setCode(AppConstants.FAIL);
			message.setData(params);
			message.setMessage("Payment has Active or Completed reverse request.");
			return message;

		} else {

			String allowFlgYN = validateAction(selectedOrder);
			if(allowFlgYN != null && allowFlgYN != "" && allowFlgYN.equals("N")){
				message.setCode(AppConstants.FAIL);
				message.setData(params);
				message.setMessage("Not Allow to proceed with DCF. Please reselect. ");
				return message;

			}else{

        		// DCF Info Validation
        		if(dcfInfoResult.get("reason").toString().isEmpty() && dcfInfoResult.get("reason").equals("")){
        			message.setCode(AppConstants.FAIL);
        			message.setData(params);
        			message.setMessage("* No Reason Selected");
        			return message;
        		}

        		if(dcfInfoResult.get("attachmentFileTxt").toString().isEmpty() && dcfInfoResult.get("attachmentFileTxt").equals("")){
        			message.setCode(AppConstants.FAIL);
        			message.setData(params);
        			message.setMessage("Attachment is required");
        			return message;
        		}

        		if(Double.parseDouble(dcfInfoResult.get("oldTotalAmtTxt").toString().replace(",", "")) <= 0.00){
        			message.setCode(AppConstants.FAIL);
        			message.setData(params);
        			message.setMessage("* Total amount is less than zero");
        			return message;
        		}

        		if(dcfInfoResult.get("remark").toString().isEmpty() && dcfInfoResult.get("remark").equals("")){
        			message.setCode(AppConstants.FAIL);
        			message.setData(params);
        			message.setMessage("Input Remark");
        			return message;
        		}

        		if(dcfInfoResult.get("remark").toString().length() > 400){
        			message.setCode(AppConstants.FAIL);
        			message.setData(params);
        			message.setMessage("* Please input the Remark below or less than 400 bytes.");
        			return message;
        		}

        		List<Map<String, Object>> oldRequestDcfGridResult = mapper.readValue(params.get("oldRequestDcfGrid").toString(), new TypeReference<List<Map<String, Object>>>(){});
        		if(oldRequestDcfGridResult.size() <= 0 ){
        			message.setCode(AppConstants.FAIL);
        			message.setData(params);
        			message.setMessage("Please select order to perform request DCF");
        			return message;
        		}

        		if(dcfInfoResult.get("rekeyStus").toString().isEmpty() && dcfInfoResult.get("rekeyStus").equals("")){
        			message.setCode(AppConstants.FAIL);
        			message.setData(params);
        			message.setMessage("Please select Rekey-in status");
        			return message;

        		} else if (dcfInfoResult.get("rekeyStus").toString().equals("1")) {
        			 //	 New DCF Order
        	 	     if(Double.parseDouble(dcfInfoResult.get("newTotalAmtTxt").toString().replace(",", "")) <= 0.00){
        	 	    	message.setCode(AppConstants.FAIL);
        				message.setData(params);
        				message.setMessage("* Total amount is less than zero");
        				return message;
        	 	     }

        	 	    List<Map<String, Object>> newRequestDcfGridResult = mapper.readValue(params.get("newRequestDcfGrid").toString(), new TypeReference<List<Map<String, Object>>>(){});
        	 	    if(newRequestDcfGridResult.size() <= 0){
        	 	    	message.setCode(AppConstants.FAIL);
        				message.setData(params);
        				message.setMessage("Please select Order for new DCF request");
        	 	    	return message;
        	 	    }

        	 	    // DCF Payment Info Validation
        	 	    String dcfPayType = dcfInfoResult.get("payType").toString();
        	 	    if(dcfPayType.isEmpty() && dcfPayType.equals("")){
        	 	    	message.setCode(AppConstants.FAIL);
        				message.setData(params);
        				message.setMessage("Please select Payment Type");
        				return message;

        	 	    }else if(dcfPayType.equals("105")){ // Cash

        	 	    	Map<String, Object> cashPayInfoFormResult = mapper.readValue(params.get("cashPayInfoForm").toString(), new TypeReference<Map<String, Object>>(){});

        	 	    	if(Double.parseDouble(cashPayInfoFormResult.get("cashTotalAmtTxt").toString().replace(",", "")) <= 0.00){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Amount");
        					return message;
        	 	    	}else if(Double.parseDouble(cashPayInfoFormResult.get("cashTotalAmtTxt").toString().replace(",", "")) > 200000.00){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("Amount exceed RM 200000");
        					return message;
        	 	    	}


        	 	    	if(cashPayInfoFormResult.get("cashBankType").toString().isEmpty() && cashPayInfoFormResult.get("cashBankType").equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Bank Type");
        					return message;
        	 	    	}else if(cashPayInfoFormResult.get("cashBankType").toString().equals("2730")){
        	 	    		if(cashPayInfoFormResult.get("cashVAAcc").toString().isEmpty() && cashPayInfoFormResult.get("cashVAAcc").toString().equals("")){
        	 	    			message.setCode(AppConstants.FAIL);
        						message.setData(params);
        						message.setMessage("* No VA Account");
        						return message;
        	 	    		}
        	 	    	}else {
        	 	    		if(cashPayInfoFormResult.get("cashBankAcc").toString().isEmpty() && cashPayInfoFormResult.get("cashBankAcc").toString().equals("")){
        	 	    			message.setCode(AppConstants.FAIL);
        						message.setData(params);
        						message.setMessage("* No Bank Account Selected");
        						return message;
        	 	    		}
        	 	    	}

        	 	    	if(cashPayInfoFormResult.get("cashTrxDate").toString().isEmpty() && cashPayInfoFormResult.get("cashTrxDate").toString().equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* Transaction Date is empty");
        					return message;
        	 	    	}

        	 	    	if(cashPayInfoFormResult.get("cashSlipNo").toString().isEmpty() && cashPayInfoFormResult.get("cashSlipNo").toString().equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Slip No");
        					return message;
        	 	    	}

        	 	    	if(!cashPayInfoFormResult.get("cashTrxId").toString().isEmpty()){
        	 	    		Map<String, Object> data = new HashMap<>();
        	 	    		data.put("trxId", cashPayInfoFormResult.get("cashTrxId"));
        	 	    		data.put("amt", cashPayInfoFormResult.get("cashTotalAmtTxt"));

        	 	    		ResponseEntity<ReturnMessage> result = checkBankStateMapStus(data);

        	 	    		if(!result.getBody().toString().equals("PASS")){
            					return result.getBody();
        	 	    		}
        	 	    	}

        	 	    } else if(dcfPayType.equals("106")){ // Cheque

        	 	    	Map<String, Object> chequePayInfoFormResult = mapper.readValue(params.get("chequePayInfoForm").toString(), new TypeReference<Map<String, Object>>(){});

        	 	    	if(Double.parseDouble(chequePayInfoFormResult.get("chequeTotalAmtTxt").toString().replace(",", "")) <= 0.00){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Amount");
        					return message;
        	 	    	}else if(Double.parseDouble(chequePayInfoFormResult.get("chequeTotalAmtTxt").toString().replace(",", "")) > 200000.00){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("Amount exceed RM 200000");
        					return message;
        	 	    	}

        	 	    	if(chequePayInfoFormResult.get("chequeBankType").toString().isEmpty() && chequePayInfoFormResult.get("chequeBankType").equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Bank Type");
        					return message;
        	 	    	} else if(chequePayInfoFormResult.get("chequeBankType").toString().equals("2730")){
        	 	    		if(chequePayInfoFormResult.get("chequeVAAcc").toString().isEmpty() && chequePayInfoFormResult.get("chequeVAAcc").toString().equals("")){
        	 	    			message.setCode(AppConstants.FAIL);
        						message.setData(params);
        						message.setMessage("* No VA Account");
        						return message;
        	 	    		}
        	 	    	}else {
        	 	    		if(chequePayInfoFormResult.get("chequeBankAcc").toString().isEmpty() && chequePayInfoFormResult.get("chequeBankAcc").toString().equals("")){
        	 	    			message.setCode(AppConstants.FAIL);
        						message.setData(params);
        						message.setMessage("* No Bank Account Selected");
        						return message;
        	 	    		}
        	 	    	}

        	 	    	if(chequePayInfoFormResult.get("chequeTrxDate").toString().isEmpty() && chequePayInfoFormResult.get("chequeTrxDate").toString().equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* Transaction Date is empty");
        					return message;
        	 	    	}

        	 	    	if(chequePayInfoFormResult.get("chequeSlipNo").toString().isEmpty() && chequePayInfoFormResult.get("chequeSlipNo").toString().equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Slip No");
        					return message;
        	 	    	}

        	 	     	if(!chequePayInfoFormResult.get("chequeTrxId").toString().isEmpty()){
        	 	    		Map<String, Object> data = new HashMap<>();
        	 	    		data.put("trxId", chequePayInfoFormResult.get("chequeTrxId"));
        		    		data.put("amt", chequePayInfoFormResult.get("chequeTotalAmtTxt"));

        	 	    		ResponseEntity<ReturnMessage> result = checkBankStateMapStus(data);

        	 	    		if(!result.getBody().toString().equals("PASS")){
            					return result.getBody();
        	 	    		}
        	 	    	}

        	 	    }else if(dcfPayType.equals("107")){ // Credit Card

        	 	    	Map<String, Object> creditPayInfoFormResult = mapper.readValue(params.get("creditPayInfoForm").toString(), new TypeReference<Map<String, Object>>(){});

        	 	    	if(creditPayInfoFormResult.get("creditCardType").toString().isEmpty() && creditPayInfoFormResult.get("creditCardType").toString().equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Card Type");
        					return message;
        	 	    	}

        	 	    	if(Double.parseDouble(creditPayInfoFormResult.get("creditTotalAmtTxt").toString().replace(",", "")) <= 0.00){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Amount");
        					return message;
        	 	    	}else if(Double.parseDouble(creditPayInfoFormResult.get("creditTotalAmtTxt").toString().replace(",", "")) > 200000.00){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("Amount exceed RM 200000");
        					return message;
        	 	    	}

        	 	    	if(creditPayInfoFormResult.get("creditCardMode").toString().isEmpty() && creditPayInfoFormResult.get("creditCardMode").toString().equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No CRC Mode");
        					return message;

        	 	    	}

        	 	    	// Credit card brand
        	 	    	if(creditPayInfoFormResult.get("creditCardBrand").toString().isEmpty() && creditPayInfoFormResult.get("creditCardBrand").equals("")){
        	 	    		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No CRC Brand");
        					return message;

        	             }else{

        	 	 	        // Card No
        	 	 	   	    if(creditPayInfoFormResult.get("creditCardNo1").equals("") ||
        	         	 	   	creditPayInfoFormResult.get("creditCardNo2").equals("") ||
        	                     creditPayInfoFormResult.get("creditCardNo3").equals("")  ||
        	                     creditPayInfoFormResult.get("creditCardNo4").equals("")){
        	     	 	   	    message.setCode(AppConstants.FAIL);
        	     				message.setData(params);
        	     				message.setMessage("* No CRC No");
        	     				return message;

        	 	 	   	    }else{
        	 	 	   	      int cardNo1Size = creditPayInfoFormResult.get("creditCardNo1").toString().length();
        	 	 	   	      int cardNo2Size = creditPayInfoFormResult.get("creditCardNo2").toString().length();
        	 	 	   	      int cardNo3Size = creditPayInfoFormResult.get("creditCardNo3").toString().length();
        	 	 	   	      int cardNo4Size = creditPayInfoFormResult.get("creditCardNo4").toString().length();
        	 	 	   	      int cardNoAllSize = cardNo1Size  + cardNo2Size + cardNo3Size + cardNo4Size;

        	 	 	   	      if(cardNoAllSize != 16){
        	 	 	   	    	message.setCode(AppConstants.FAIL);
        	 					message.setData(params);
        	 					message.setMessage("* Invalid CRC No.");
        	 					return message;
        	 	 	   	      }
        	 	 	   	    }

        	 	    	    int crcType = Integer.parseInt(creditPayInfoFormResult.get("creditCardBrand").toString());
        	 	    	    int cardNo1st1Val = Integer.parseInt((creditPayInfoFormResult.get("creditCardNo1").toString()).substring(0,1));
        	 	    	    int cardNo1st2Val = Integer.parseInt((creditPayInfoFormResult.get("creditCardNo1").toString()).substring(0,2));
        	 	    	    int cardNo1st4Val = Integer.parseInt((creditPayInfoFormResult.get("creditCardNo1").toString()).substring(0,4));

        	 	    	    if(cardNo1st1Val == 4){
        	 	    	    	if(crcType !=112){
        	 	    	    		message.setCode(AppConstants.FAIL);
        	 	    	    		message.setData(params);
        	 	    	    		message.setMessage("* Invalid credit card type");
        	 	    	    		return message;
        	 	    	    	}
        	 	    	    }

        	 	    	    if((cardNo1st2Val >= 51 && cardNo1st2Val <= 55) || (cardNo1st4Val >= 2221 && cardNo1st4Val <= 2720)){
        	 	    	    	if(crcType != 111){
        	 	    	    		message.setCode(AppConstants.FAIL);
        	     					message.setData(params);
        	     					message.setMessage("* Invalid credit card type");
        	     					return message;
        	                     }
        	                 }
        	             }

        	 	   	      // Approval No
        	 	          if(creditPayInfoFormResult.get("creditApprNo").toString().isEmpty() && creditPayInfoFormResult.get("creditApprNo").equals("")){
        	 	        	  message.setCode(AppConstants.FAIL);
        	 	        	  message.setData(params);
        	 	        	  message.setMessage("* No Approval Number");
        	 	        	  return message;
        	 	          }else{

        	 	              int appValSize = creditPayInfoFormResult.get("creditApprNo").toString().length();
        	 	              if(appValSize != 6){
        	 	            	  message.setCode(AppConstants.FAIL);
        	 	            	  message.setData(params);
        	 	            	  message.setMessage("* Invalid approval No length");
        	 	            	  return message;
        	 	              }
        	 	          }

        	 	          //Issue Bank 체크
        	 	          if(creditPayInfoFormResult.get("creditIssueBank").toString().isEmpty() && creditPayInfoFormResult.get("creditIssueBank").equals("")){
        	 	        	 message.setCode(AppConstants.FAIL);
        						message.setData(params);
        						message.setMessage("* No Issue Bank Selected");
        						return message;
        	 	          }


        	 	         // Expiry date
        	 	       	 if(creditPayInfoFormResult.get("creditExpiryMonth").equals("") || creditPayInfoFormResult.get("creditExpiryYear").equals("")){
        	 	       		message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No CRC Expiry Date");
        					return message;
        	 		     }else{
        	 		         int expiry1Size = creditPayInfoFormResult.get("creditExpiryMonth").toString().length();
        	 		         int expiry2Size = creditPayInfoFormResult.get("creditExpiryYear").toString().length();

        	 		         int expiryAllSize = expiry1Size  + expiry2Size;

        	 		         if(expiryAllSize != 4){
        	 		        	message.setCode(AppConstants.FAIL);
        						message.setData(params);
        						message.setMessage("* Invalid CRC Expiry Date");
        						return message;
        	 		         }

        	 		         if(Integer.parseInt(creditPayInfoFormResult.get("creditExpiryMonth").toString()) > 12){
        	 		        	message.setCode(AppConstants.FAIL);
        						message.setData(params);
        						message.setMessage("* Invalid CRC Expiry Date");
        						return message;
        	 		         }
        	 		     }

        	 		    //Merchant Bank 체크
        	 		    if(creditPayInfoFormResult.get("creditMerchantBank").toString().isEmpty() && creditPayInfoFormResult.get("creditMerchantBank").equals("")){
        	 		    	message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Merchant Bank Selected");
        					return message;
        	 		    }

        	 		    //Transaction Date 체크
        	 		    if(creditPayInfoFormResult.get("creditTrxDate").toString().isEmpty() && creditPayInfoFormResult.get("creditTrxDate").equals("")){
        	 		    	message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* Transaction Date is empty");
        					return message;
        	 		    }

        	 		    Map<String,Object> data = new HashMap<>();
        	 		    data.put("keyInApprovalNo", creditPayInfoFormResult.get("creditApprNo"));
        	 		    data.put("keyInAmount", creditPayInfoFormResult.get("creditTotalAmtTxt"));
        	 		    data.put("keyInTrDate", creditPayInfoFormResult.get("creditTrxDate"));
        	 		    data.put("keyInMerchantBank", creditPayInfoFormResult.get("creditMerchantBank"));
        	 		    data.put("keyInCardNo1", creditPayInfoFormResult.get("creditCardNo1"));
        	 		    data.put("keyInCardNo2", creditPayInfoFormResult.get("creditCardNo2"));
        	 		    data.put("keyInCardNo4", creditPayInfoFormResult.get("creditCardNo4"));

        	 		    EgovMap result = commonPaymentService.checkBatchPaymentExist(data);
        	 		    if(result != null){
        	 		    	message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("Payment has been uploaded.");
        					return message;
        	 		    }

        	 	    }else if(dcfPayType.equals("108")){    //Online

        	 	    	Map<String, Object> onlinePayInfoFormResult = mapper.readValue(params.get("onlinePayInfoForm").toString(), new TypeReference<Map<String, Object>>(){});

        	 	    	String onlineBankType = onlinePayInfoFormResult.get("onlineBankType").toString();
        	 	        String onlineVAAccount = onlinePayInfoFormResult.get("onlineVAAcc").toString();
        	 	        String onlineBankAcc = onlinePayInfoFormResult.get("onlineBankAcc").toString();

        	 	        if(Double.parseDouble(onlinePayInfoFormResult.get("onlineTotalAmtTxt").toString().replace(",", "")) <= 0.00 ){
        	 	            message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("* No Amount");
        					return message;
        	 	        } else if(Double.parseDouble(onlinePayInfoFormResult.get("onlineTotalAmtTxt").toString().replace(",", "")) > 200000.00 ){
        	 	        	message.setCode(AppConstants.FAIL);
        					message.setData(params);
        					message.setMessage("Amount exceed RM 200000");
        					return message;
        	 	        }

        	 	       	//BankCharge Amount는 Billing 금액의 5%를 초과할수 없다
        	 	        double bcAmt4Limit = 0.00;
        	 	        double payAmt4Limit = 0.00;

        	 	        if(!onlinePayInfoFormResult.get("onlineBankChgAmt").toString().isEmpty() && !onlinePayInfoFormResult.get("onlineBankChgAmt").equals("")) {
        	 	            bcAmt4Limit = Double.parseDouble(onlinePayInfoFormResult.get("onlineBankChgAmt").toString().replace(",", ""));
        	 	            payAmt4Limit = Double.parseDouble(dcfInfoResult.get("newTotalAmtTxt").toString().replace(",", ""));

        	 	            if ((payAmt4Limit * 0.05 ) < bcAmt4Limit) {
        	 	                message.setCode(AppConstants.FAIL);
        						message.setData(params);
        						message.setMessage("Bank Charge Amount can not exceed 5% of Amount.");
        						return message;
        	 	            }
        	 	        }

        	 	        if(onlinePayInfoFormResult.get("onlineTrxDate").toString().isEmpty() && onlinePayInfoFormResult.get("onlineTrxDate").equals("")){
        	                 message.setCode(AppConstants.FAIL);
        	                 message.setData(params);
        	                 message.setMessage("* Transaction Date is empty");
        	                 return message;
        	             }

        	 	        if(onlineBankType.equals("2730")){
        	 	             if(onlineVAAccount.equals("")){
        	 	                 message.setCode(AppConstants.FAIL);
        	 	                 message.setData(params);
        	 	                 message.setMessage("* No VA Account");
        	 	                 return message;
        	 	             }

        	 	         }else{
        	 	             if(onlinePayInfoFormResult.get("onlineBankAcc").toString().isEmpty() && onlinePayInfoFormResult.get("onlineBankAcc").equals("")){
        	 	                 message.setCode(AppConstants.FAIL);
        	 	                 message.setData(params);
        	 	                 message.setMessage("* No Bank Account Selected");
        	 	                 return message;
        	 	             }

        	 	             if(onlineBankType.equals("2728")) {
        	 	                 if(onlinePayInfoFormResult.get("onlineEFT").toString().isEmpty() && onlinePayInfoFormResult.get("onlineEFT").equals("")) {
        	 	                     message.setCode(AppConstants.FAIL);
        	 	                     message.setData(params);
        	 	                     message.setMessage("* No EFT/JomPayRef");
        	 	                     return message;
        	 	                 }
        	 	             }
        	 	         }

        	 	     	if(!onlinePayInfoFormResult.get("onlineTrxId").toString().isEmpty()){
        	 	    		Map<String, Object> data = new HashMap<>();
        	 	    		data.put("trxId", onlinePayInfoFormResult.get("onlineTrxId"));
        		    		data.put("amt", onlinePayInfoFormResult.get("onlineTotalAmtTxt"));

        	 	    		ResponseEntity<ReturnMessage> result = checkBankStateMapStus(data);

        	 	    		if(!result.getBody().toString().equals("PASS")){
            					return result.getBody();
        	 	    		}
        	 	    	}
        	 	    }
        		}

        		// Approval Validation
        		List<Map<String, Object>> apprGridListResult = mapper.readValue(params.get("apprGridList").toString(), new TypeReference<List<Map<String, Object>>>(){});
        		if(apprGridListResult.size() > 0) {
        			if(!apprGridListResult.get(0).containsKey("memCode")){
            			message.setCode(AppConstants.FAIL);
            			message.setData(params);
            			message.setMessage("Please enter the User ID of Line");
            			return message;
        			}
        		}else {
        			message.setCode(AppConstants.FAIL);
        			message.setData(params);
        			message.setMessage("Please enter the User ID of Line");
        			return message;
        		}
    		}
		}

		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return message;
	}

	@RequestMapping(value = "/rejectNewDCF.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> rejectNewDCF(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);
		// 저장
		String[] groupSeqList = params.get("groupSeq").toString().replace("\"","").split(",");
		params.put("groupSeq", groupSeqList);

		params.put("userId", sessionVO.getUserId());
		params.put("userMemCode", sessionVO.getUserMemCode());
		paymentListService.rejectNewDCF(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/approvalNewDCF.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> approvalNewDCF(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws JsonParseException, JsonMappingException, IOException {

		LOGGER.debug("params : {} ", params);
		//EgovMap resultList;
		Map<String, Object> returnMap = new HashMap<String, Object>();

		// 저장
		params.put("userId", sessionVO.getUserId());
		params.put("userMemCode", sessionVO.getUserMemCode());

		String[] groupSeq = params.get("groupSeq").toString().replace("\"","").split(",");
		params.put("groupSeq", groupSeq);

		Map<String, Object> result = paymentListService.approvalNewDCF(params);
		LOGGER.debug("result : {} ", result);
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		if (result != null && result.size() > 0) {
			returnMap.put("message", result.get("message").toString());
		}

		return ResponseEntity.ok(returnMap);

	}

	  @RequestMapping(value = "/requestDCFOrderSearchPop.do")
	  public String requestDCFOrderSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("appTypeId", 1);

	    return "payment/otherpayment/requestDCFOrderSearchPop";
	  }

	  @RequestMapping(value = "/checkBankStateMapStus.do", method = RequestMethod.GET)
	  public ResponseEntity<ReturnMessage> checkBankStateMapStus(@RequestParam Map<String, Object> params) {
		  EgovMap result = paymentListService.checkBankStateMapStus(params);

		  ReturnMessage message = new ReturnMessage();


		  if(result == null){
    		  message.setCode(AppConstants.FAIL);
    		  message.setMessage("This item is an invalid transaction ID.");
    		  return ResponseEntity.ok(message);
    	  }else{
    		  if(result.get("othKeyinStusId").toString().equals("4")){
    			  message.setCode(AppConstants.FAIL);
        		  message.setMessage("This item has already been confirmed payment.");
        		  return ResponseEntity.ok(message);
    		  }

    		  if(Double.parseDouble(result.get("fTrnscCrditAmt").toString().replace(",", "")) != Double.parseDouble(params.get("amt").toString().replace(",", ""))){
    			  message.setCode(AppConstants.FAIL);
        		  message.setMessage("Transaction amount and new DCF amount are not the same.");
        		  return ResponseEntity.ok(message);
    		  }
    	  }

		  message.setCode(AppConstants.SUCCESS);
		  message.setMessage("PASS");
		  return ResponseEntity.ok(message);
	  }
	  /** [END] BOI - DCF **/

	  @RequestMapping(value = "/selectRefundCodeList.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params, ModelMap model) {
			LOGGER.debug("params =====================================>>  " + params);

			List<EgovMap> codeList = paymentListService.selectRefundCodeList(params);

			return ResponseEntity.ok(codeList);
		}

	  @RequestMapping(value = "/selectBankListCode.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectBankCode(Model model) {

			List<EgovMap> bankCodeList = paymentListService.selectBankListCode();

			return ResponseEntity.ok(bankCodeList);
		}
}
