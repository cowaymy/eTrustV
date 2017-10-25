package com.coway.trust.web.payment.document.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.document.service.FinanceMgmtService;
import com.coway.trust.biz.payment.payment.service.CommDeductionService;
import com.coway.trust.biz.payment.payment.service.CommDeductionVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class FinanceMgmtController {

	private static final Logger LOGGER = LoggerFactory.getLogger(FinanceMgmtController.class);
	
	@Resource(name = "financeMgmtService")
	private FinanceMgmtService financeMgmtService;

	
	/******************************************************
	 * FinanceManagement
	 *****************************************************/	
	/**
	 * Finance Management초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initFinanceMgmt.do")
	public String CommissionDeduction(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/document/financeMgmt";
	}
	
	/**
	 * Finance Management Receive List 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectReceiveList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectReceiveList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {

       
        String[] online = request.getParameterValues("rOnline");
        String[] batchStatus = request.getParameterValues("rBatchStatus");
        String[] itemStatus = request.getParameterValues("rItemStatus");
        params.put("rOnline", online);
        params.put("rBatchStatus", batchStatus);
        params.put("rItemStatus", itemStatus);
        
        LOGGER.debug("----params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectReceiveList(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Credit Card 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCreditCardList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCreditCardList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		 String[] online = request.getParameterValues("cOnline");
		 params.put("cOnline", online);
        LOGGER.debug("params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectCreditCardList(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Credit Card 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDocItemPaymentItem.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocItemPaymentItem(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectDocItemPaymentItem(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Log 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectLogItemPaymentItem.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLogItemPaymentItem(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectLogItemPaymentItem(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Doc Batch 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPayDocBatchById.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPayDocBatchById(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("params : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectPayDocBatchById(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Credit Card 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDocItemPaymentItem2.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocItemPaymentItem2(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("params2 : {}", params);
        
        List<EgovMap> list = financeMgmtService.selectDocItemPaymentItem2(params);

        return ResponseEntity.ok(list);
	}
	
	/**
	 * Finance Management Credit Card 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveReceiveList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> saveReceiveList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        LOGGER.debug("##params : {}", params);
        
        return ResponseEntity.ok(null);
	}
}
