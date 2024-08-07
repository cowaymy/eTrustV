package com.coway.trust.web.payment.otherpayment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.otherpayment.service.AdvPaymentMatchService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class AdvPaymentMatchController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdvPaymentMatchController.class);

	@Resource(name = "advPaymentMatchService")
	private AdvPaymentMatchService advPaymentMatchService;

	/******************************************************
	 *  Advance Payment Matching
	 *****************************************************/
	/**
	 * Advance Payment Matching - 초기화
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdvPaymentMatch.do")
	public String initAdvPaymentMatch(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/otherpayment/advPaymentMatch";
	}

	/**
	 *  Advance Payment Matching - 초기화 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPaymentMatchList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectPaymentMatchList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		Map<String, Object> resultMap = new HashMap<String, Object>();

		List<EgovMap> keyInList = advPaymentMatchService.selectAdvKeyInList(params);
		List<EgovMap> stateList = advPaymentMatchService.selectBankStateMatchList(params);

		resultMap.put("keyInList", keyInList);
		resultMap.put("stateList", stateList);

		// 조회 결과 리턴.
        return ResponseEntity.ok(resultMap);
	}

	/**
	 *  Advance Payment Matching - Key In 정보 상세보기 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initDetailGrpPaymentPop.do")
	public String initRequestDCFPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("groupSeq", params.get("groupSeq"));
		LOGGER.debug("payment List params : {} ", params);

		return "payment/otherpayment/advPaymentMatchPop";
	}

	/**
	 * Advance Payment Matching - Mapping 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveAdvPaymentMapping.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAdvPaymentMapping(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);
		String groupSeq = params.get("groupSeq").toString();
		String groupSeqArr[];
		if(groupSeq.contains(",")) {
		    groupSeqArr = groupSeq.split(",");
		    params.put("groupSeqArr", groupSeqArr);
		}

		// 저장
		params.put("userId", sessionVO.getUserId());
		advPaymentMatchService.saveAdvPaymentMapping(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);

	}

	/******************************************************
	 * Payment List - Request DCF
	 *****************************************************/
	/**
	 * Payment List - Request DCF 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initReqDCFWithAppvPop.do")
	public String initReqDCFWithAppvPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("groupSeq", params.get("groupSeq"));
		LOGGER.debug("payment List params : {} ", params);

        // 조회.
        //List<EgovMap> resultList = paymentListService.selectPaymentListByGroupSeq(params);
        //model.put("paymentList", resultList);

		return "payment/otherpayment/requestDCFWithAppvPop";
	}



	/**
	 * Advance Payment Matching - Reverse 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/requestDCFWithAppv.do", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> requestDCFWithAppv(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);

		// 저장
		params.put("userId", sessionVO.getUserId());
    	EgovMap resultMap = advPaymentMatchService.requestDCFWithAppv(params);

		// 조회 결과 리턴.
    	return ResponseEntity.ok(resultMap);

	}

	/**
	 * Advance Payment Matching - Debtor 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveAdvPaymentDebtor.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAdvPaymentDebtor(
			@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params : {} ", params);

		// 저장
		params.put("userId", sessionVO.getUserId());
		params.put("groupSeq", params.get("debtorGroupSeq"));
		params.put("fTrnscId", 0);
		params.put("accCode", 0);

		advPaymentMatchService.saveAdvPaymentDebtor(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);

	}

	 @RequestMapping(value = "/selectJompayMatchList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectJompayMatchList(@RequestParam Map<String, Object> params, ModelMap model) {

	    List<EgovMap> keyInList = advPaymentMatchService.selectJompayMatchList(params);

	    return ResponseEntity.ok(keyInList);
	  }

	 @RequestMapping(value = "/saveJompayAutoMap.do", method = RequestMethod.POST)
	  public ResponseEntity<EgovMap> saveJompayAutoMap(@RequestBody Map<String, Object> params, SessionVO sessionVO) {

	    LOGGER.debug("params : {} ", params.get("fileId"));

	    params.put("userId", sessionVO.getUserId());
	    EgovMap keyInList = advPaymentMatchService.saveJompayPaymentMapping(params);

	    return ResponseEntity.ok(keyInList);

	  }

  @RequestMapping(value = "/selectAdvanceMatchList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAdvanceMatchList(@RequestParam Map<String, Object> params,
      ModelMap model) {

    LOGGER.debug("==== selectAdvanceMatchList ===== params : {} ", params.get("batchId"));

    List<EgovMap> keyInList = advPaymentMatchService.selectAdvanceMatchList(params);

    return ResponseEntity.ok(keyInList);
  }

  @RequestMapping(value = "/saveAdvanceAutoMap.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> saveAdvanceAutoMap(@RequestBody Map<String, Object> params, SessionVO sessionVO) {

    LOGGER.debug("==== saveAdvanceAutoMap ===== params : {} ", params.get("batchId"));

    params.put("userId", sessionVO.getUserId());
    EgovMap keyInList = advPaymentMatchService.saveAdvancePaymentMapping(params);

    return ResponseEntity.ok(keyInList);

  }

}
