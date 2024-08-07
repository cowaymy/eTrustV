package com.coway.trust.web.payment.cardpayment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.cardpayment.service.CardStatementService;
import com.coway.trust.biz.payment.cardpayment.service.CrcReconCRCStateService;
import com.coway.trust.biz.payment.otherpayment.service.BankStatementService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class CrcReconCRCStateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CrcReconCRCStateController.class);

	@Resource(name = "crcReconCRCStateService")
	private CrcReconCRCStateService crcReconCRCStateService ;

	/******************************************************
	 *  Payment Key-In & Credit Card Statement
	 *****************************************************/
	/**
	 *  Payment Key-In & Credit Card Statement 초기화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCrcReconCRCState.do")
	public String initUploadCardStatementList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/cardpayment/crcReconCRCState";
	}

	/**
	 * Payment Key-In & Credit Card Statement 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 * @return
	 */
	@RequestMapping(value = "/selectCrcReconCRCStateInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectPaymentDocMs(@RequestParam Map<String, Object> params, ModelMap model) {

		Map<String, Object> resultMap = new HashMap<String, Object>();

		List<EgovMap> mappingList = crcReconCRCStateService.selectCrcStatementMappingList(params);
		List<EgovMap> keyInList = crcReconCRCStateService.selectCrcKeyInList(params);
		List<EgovMap> stateList = crcReconCRCStateService.selectCrcStateList(params);

		resultMap.put("mappingList", mappingList);
		resultMap.put("keyInList", keyInList);
		resultMap.put("stateList", stateList);
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultMap);
	}

	/**
	 * Mapping List KnockOff 처리
	 * @param
	 * @param params
	 * @param model
	 * @return
	 * @return
	 */
	@RequestMapping(value = "/updCrcReconState.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updCrcReconState(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {

		ReturnMessage message = new ReturnMessage();
		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		boolean updateResult = crcReconCRCStateService.updCrcReconState(sessionVO.getUserId(), gridList);

		if(updateResult){
			message.setMessage("This Payment form has successfully been approved.");
		}

		// 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);

		return ResponseEntity.ok(message);
	}

	/**
	 * Mapping List Income 처리
	 * @param
	 * @param params
	 * @param model
	 * @return
	 * @return
	 */
	@RequestMapping(value = "/updIncomeCrcStatement", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updIncomeCrcStatement(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		ReturnMessage message = new ReturnMessage();
			int userId = sessionVO.getUserId();
			params.put("userId", userId);

			crcReconCRCStateService.updIncomeCrcStatement(params);

			// 조회 결과 리턴.
	    	message.setCode(AppConstants.SUCCESS);

			return ResponseEntity.ok(message);
		}


}
