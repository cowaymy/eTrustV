package com.coway.trust.web.payment.invoice.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.invoice.service.InvoicePOService;
import com.coway.trust.biz.payment.invoice.service.InvoiceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class InvoicePOController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InvoicePOController.class);

	@Resource(name = "invoicePOService")
	private InvoicePOService invoicePOService;

	/**
	 * BillingMgnt 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingStatementPO.do")
	public String initInvoiceStatementManagement(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/billingStatementPo";
	}

	@RequestMapping(value = "/selectOrderBasicInfoByOrderId.do")
	public ResponseEntity<EgovMap> selectOrderBasicInfoByOrderId(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap orderBasicInfo = null;

		LOGGER.debug("params : {}", params);

		orderBasicInfo = invoicePOService.selectOrderBasicInfoByOrderId(params).get(0);

		return ResponseEntity.ok(orderBasicInfo);
	}

	@RequestMapping(value = "/selectHTOrderBasicInfoByOrderId.do")
	public ResponseEntity<EgovMap> selectHTOrderBasicInfoByOrderId(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap orderBasicInfo = null;

		LOGGER.debug("params : {}", params);

		orderBasicInfo = invoicePOService.selectHTOrderBasicInfoByOrderId(params).get(0);

		return ResponseEntity.ok(orderBasicInfo);
	}

	@RequestMapping(value = "/selectOrderDataByOrderId.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceStmtMgmtList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = null;

		LOGGER.debug("params : {}", params);

		list = invoicePOService.selectOrderDataByOrderId(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/disablePOEntry.do")
	public ResponseEntity<ReturnMessage> disablePOEntry(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		String message = "";
		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);

		int userId = sessionVO.getUserId();
		params.put("userId", userId);

		LOGGER.debug("params : {}", params);

		if(userId > 0){
			int result = invoicePOService.updateInvoiceStatement(params);
			if(result < 1){
				message = "No records found";
			}
		};

		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}

	@RequestMapping(value = "/selectInvoiceStatement.do")
	public ResponseEntity<ReturnMessage> selectInvoiceStatementByOrdId(@RequestParam Map<String, Object> params, ModelMap model) {
		String message = "";
		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);

		LOGGER.debug("params : {}", params);

		//List<EgovMap> result = invoicePOService.selectInvoiceStatementByOrdId(params);
		List<EgovMap> resultStart = invoicePOService.selectInvoiceStatementStart(params);
		List<EgovMap> resultEnd = invoicePOService.selectInvoiceStatementEnd(params);

	/*	if(result.size() > 0){
			message = "Invalid Period Range";
		}else*/

	if(resultStart.size() > 0){
          message = "Invalid Start Period Range";
      }else if(resultEnd.size() > 0){
        message = "Invalid End Period Range";
       }
		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}

	@RequestMapping(value = "/insertInvoiceStatement.do")
	public ResponseEntity<Map<String, Object>> insertInvoiceStatement(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("params : {}", params);

		params.put("userId", sessionVO.getUserId());
		invoicePOService.insertInvoicStatement(params);

		return ResponseEntity.ok(params);
	}
}
