package com.coway.trust.web.payment.payment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.SampleApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;
import com.coway.trust.biz.payment.payment.service.SearchPaymentService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class SearchPaymentController {

	private static final Logger logger = LoggerFactory.getLogger(SearchPaymentController.class);

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "searchPaymentService")
	private SearchPaymentService searchPaymentService;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/******************************************************
	 * Search Payment  
	 *****************************************************/	
	/**
	 * SearchPayment초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initSearchPayment.do")
	public String initSearchPayment(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/payment/searchPayment";
	}
	
	/**
	 * SearchPayment Order List(Master Grid) 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectOrderList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

		//검색 파라미터 확인.(화면 Form객체 입력값)
        logger.debug("orderNo : {}", params.get("orderNo"));
        logger.debug("payDate1 : {}", params.get("payDate1"));
        logger.debug("payDate2 : {}", params.get("payDate2"));
        logger.debug("applicationType : {}", params.get("applicationType"));
        logger.debug("orNo : {}", params.get("orNo"));
        logger.debug("poNo : {}", params.get("poNo"));
        
        // 조회.
        List<EgovMap> resultList = searchPaymentService.selectOrderList(params);
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * SearchPayment Payment List(Slave Grid) 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPaymentList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPaymentList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

		//검색 파라미터 확인.(화면 Form객체 입력값)
        logger.debug("payId : {}", params.get("payId"));        
        
        // 조회.
        List<EgovMap> resultList = searchPaymentService.selectPaymentList(params);
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * Search Payment (RC By Sales) 
	 *****************************************************/	
	/**
	 * SearchPayment초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initRentalCollectionBySales.do")
	public String initRentalCollectionBySales(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/payment/rentalCollectionBySales";
	}
	
	/**
	 * SearchPayment Payment List(Slave Grid) 조회
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectSalesList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSalesList(
				 @RequestParam Map<String, Object> params, ModelMap model) {

        List<EgovMap> resultList = searchPaymentService.selectSalesList(params);
 
        return ResponseEntity.ok(resultList);
	}
	
	/******************************************************
	 * RentalCollectionByBS  
	 *****************************************************/	
	/**
	 * RentalCollectionByBS초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initRentalCollectionByBS.do")
	public String initRentalCollectionByBS(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/payment/rentalCollectionByBS";
	}
	
	/**
	 * RentalCollectionByBS   조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRentalCollectionByBSList", method = RequestMethod.GET)
	public ResponseEntity<List<RentalCollectionByBSSearchVO>> selectRentalCollectionByBSList(@ModelAttribute("searchVO")RentalCollectionByBSSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {
        
        // 조회.
        List<RentalCollectionByBSSearchVO> resultList = searchPaymentService.searchRentalCollectionByBSList(searchVO);
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * SearchMaster 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value="selectViewHistoryList")
	public ResponseEntity<List<EgovMap>> selectViewHistoryList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> result = null;
		String payId = params.get("payId").toString();
		
		try {
			if(CommonUtils.isNumCheck(payId)){
				result = searchPaymentService.selectViewHistoryList(Integer.parseInt(payId));
			}
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		return ResponseEntity.ok(result);
	}
	
	/**
	 * SearchDetail 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value="selectDetailHistoryList")
	public ResponseEntity<List<EgovMap>> selectDetailHistoryList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> result = null;
		String payItemId = params.get("payItemId").toString();
		
		try {
			if(CommonUtils.isNumCheck(payItemId)){
				result = searchPaymentService.selectDetailHistoryList(Integer.parseInt(payItemId));
			}
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		return ResponseEntity.ok(result);
	}
	
	/**
	 * PaymentDetailViewer   조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPaymentDetailViewer", method = RequestMethod.GET)
	public ResponseEntity<Map> selectPaymentDetailViewer(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("payId : {}", params.get("payId"));
		
        // 마스터조회
		EgovMap viewMaster = searchPaymentService.selectPaymentDetailViewer(params);
		
		//주문진행상태 조회
		EgovMap orderProgressStatus = searchPaymentService.selectOrderProgressStatus(params);
		
		//selectPaymentDetailView
		EgovMap selectPaymentDetailView = searchPaymentService.selectPaymentDetailView(params);
		
		//selectPaymentDetailSlaveList
		EgovMap selectPaymentDetailSlaveList = searchPaymentService.selectPaymentDetailSlaveList(params);
		
		Map resultMap = new HashMap();
		resultMap.put("viewMaster", viewMaster);
		resultMap.put("orderProgressStatus", orderProgressStatus);
		resultMap.put("selectPaymentDetailView", selectPaymentDetailView);
		resultMap.put("selectPaymentDetailSlaveList", selectPaymentDetailSlaveList);
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultMap);
	}
}
