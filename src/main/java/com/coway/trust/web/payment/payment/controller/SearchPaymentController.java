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
		resultMap.put("selectPaymentDetailView", selectPaymentDetailView);
		resultMap.put("selectPaymentDetailSlaveList", selectPaymentDetailSlaveList);
		if(orderProgressStatus != null){
			resultMap.put("orderProgressStatus", orderProgressStatus);
		}else{
			resultMap.put("orderProgressStatus", "");
		}
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultMap);
	}
	
	/**
	 * saveChanges
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveChanges", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveChanges(@RequestBody Map<String, Object> params, ModelMap model) {
		
        // 마스터조회
		EgovMap viewMaster = searchPaymentService.selectPayMaster(params);
		//마스터조회값
		String trNo = String.valueOf(viewMaster.get("trNo"));
		String brnchId = String.valueOf(viewMaster.get("brnchId"));
		String collMemId = String.valueOf(viewMaster.get("collMemId"));
		String allowComm = String.valueOf(viewMaster.get("allowComm"));
		String trIssuDt = String.valueOf(viewMaster.get("trIssuDt"));
		
		logger.debug("마스터조회값 trNo : {}", trNo);
		logger.debug("마스터조회값 brnchId : {}", brnchId);
		logger.debug("마스터조회값 collMemId : {}", collMemId);
		logger.debug("마스터조회값 allowComm : {}", allowComm);
		logger.debug("마스터조회값 trIssuDt : {}", trIssuDt);
		
		
	     //변경전 멤버코드, 브랜치코드 조회
	    Map idMap = new HashMap();
		idMap.put("edit_txtCollectorCode", String.valueOf(viewMaster.get("collMemId")));
		idMap.put("edit_branchId", String.valueOf(viewMaster.get("brnchId")));
	    EgovMap beforeMemCode = searchPaymentService.selectMemCode(idMap);
		EgovMap beforeBranchCode = searchPaymentService.selectBranchCode(idMap);
		
		
		String frMemCode = "";
		String frBranchCode = "";
		if(beforeMemCode !=null){
			frMemCode = String.valueOf(beforeMemCode.get("memCode"));
		}else{
			frMemCode = "";
		}
		
		if(beforeBranchCode != null){
			frBranchCode = String.valueOf(beforeBranchCode.get("code"));
		}else{
			frBranchCode = "";
		}
		
		
		//변경후 멤버코드, 브랜치코드 조회
		//EgovMap afterMemCode = searchPaymentService.selectMemCode(params);
		EgovMap afterBranchCode = searchPaymentService.selectBranchCode(params);
		String toMemCode = "";
		String toBranchCode = "";
		
		/*if(afterMemCode !=null){
			toMemCode = String.valueOf(afterMemCode.get("memCode"));
    	}else{
    		toMemCode = "";
    	}*/
    	
    	if(afterBranchCode != null){
    		toBranchCode = String.valueOf(afterBranchCode.get("code"));
    	}else{
    		toBranchCode = "";
    	}
		
		boolean HasChanges = false;
		Map trMap = new HashMap();
		Map branchMap = new HashMap();
		Map collectorMap = new HashMap();
		Map allowMap = new HashMap();
		Map updMap = new HashMap();
		
		//1127 : TR Number
		if(!trNo.equals(String.valueOf(params.get("edit_txtTRRefNo")))){
			HasChanges =true;
			
            String typeID = "1127";
            String payID = String.valueOf(params.get("hiddenPayId"));
            String valueFr = trNo;
            String valueTo = String.valueOf(params.get("edit_txtTRRefNo"));
            String refIDFr = "0";
            String refIDTo = "0";
            String createBy = "52366";
            
            trMap.put("typeID", typeID);
            trMap.put("payID", payID);
            trMap.put("valueFr", valueFr);
            trMap.put("valueTo", valueTo);
            trMap.put("refIDFr", refIDFr);
            trMap.put("refIDTo", refIDTo);
            trMap.put("createBy", createBy);
            
            searchPaymentService.saveChanges(trMap);
		}
		
		//1128 : Key-In Branch
		if(!brnchId.equals(String.valueOf(params.get("edit_branchId")))){
			HasChanges =true;
			
            String typeID = "1128";
            String payID = String.valueOf(params.get("hiddenPayId"));
            String valueFr = frBranchCode;
            String valueTo = toBranchCode;
            String refIDFr = brnchId;
            String refIDTo = String.valueOf(params.get("edit_branchId"));
            String createBy = "52366";
            
            branchMap.put("typeID", typeID);
            branchMap.put("payID", payID);
            branchMap.put("valueFr", valueFr);
            branchMap.put("valueTo", valueTo);
            branchMap.put("refIDFr", refIDFr);
            branchMap.put("refIDTo", refIDTo);
            branchMap.put("createBy", createBy);
            
            searchPaymentService.saveChanges(branchMap);
		}

		//1129 : Collector
		if(!collMemId.equals(collMemId)){//화면에서 받은 멤버아이디값과 마스터 collMemId와 비교
			HasChanges =true;
			
            String typeID = "1129";
            String payID = String.valueOf(params.get("hiddenPayId"));
            String valueFr = "100002";//공통 멤버조회 생기면 넣자! 변경전코드
            String valueTo = "100001";//공통 멤버조회 생기면 넣자! 변경후코드
            String refIDFr = collMemId;//마스터멤버아이디(변경전데이터)
            String refIDTo = collMemId;//인서트쳐야할 멤버아이디(변경후데이터)
            String createBy = "52366";
            
            collectorMap.put("typeID", typeID);
            collectorMap.put("payID", payID);
            collectorMap.put("valueFr", valueFr);
            collectorMap.put("valueTo", valueTo);
            collectorMap.put("refIDFr", refIDFr);
            collectorMap.put("refIDTo", refIDTo);
            collectorMap.put("createBy", createBy);
            
            searchPaymentService.saveChanges(collectorMap);
		}
		//1137 : Allow Commission
		if(!allowComm.equals(String.valueOf(params.get("allowComm")))){
			HasChanges =true;
			
            String typeID = "1137";
            String payID = String.valueOf(params.get("hiddenPayId"));
            String valueFr = allowComm.equals("0") ? "No":"Yes" ;
            String valueTo = String.valueOf(params.get("allowComm")).equals("0") ? "No":"Yes";
            String refIDFr = "0";
            String refIDTo = "0";
            String createBy = "52366";
            
            allowMap.put("typeID", typeID);
            allowMap.put("payID", payID);
            allowMap.put("valueFr", valueFr);
            allowMap.put("valueTo", valueTo);
            allowMap.put("refIDFr", refIDFr);
            allowMap.put("refIDTo", refIDTo);
            allowMap.put("createBy", createBy);
            
            searchPaymentService.saveChanges(allowMap);
		}
		
		//if(HasChanges){
			
			if(!trNo.equals(String.valueOf(params.get("edit_txtTRRefNo")))){
				updMap.put("trNo", String.valueOf(params.get("edit_txtTRRefNo")));
			}else{
				updMap.put("trNo", "");
			}
			
			if(!brnchId.equals(String.valueOf(params.get("edit_branchId")))){
				updMap.put("brnchId", String.valueOf(params.get("edit_branchId")));
			}else{
				updMap.put("brnchId", "");
			}
			
			if(!collMemId.equals(String.valueOf(params.get("edit_txtCollectorCode")))){
				updMap.put("collMemId", String.valueOf(params.get("edit_txtCollectorCode")));
			}else{
				updMap.put("collMemId", "");
			}
			
			if(!allowComm.equals(String.valueOf(params.get("allowComm")))){
				updMap.put("allowComm", String.valueOf(params.get("allowComm")));
			}else{
				updMap.put("allowComm", "");
			}
			
			if(!trIssuDt.equals(String.valueOf(params.get("edit_txtTRIssueDate")))){
				updMap.put("trIssueDate", String.valueOf(params.get("edit_txtTRIssueDate")));
			}else{
				updMap.put("trIssueDate", "");
			}
				
			updMap.put("payId", String.valueOf(params.get("hiddenPayId")));
			
			searchPaymentService.updChanges(updMap);
		//}
		
		
		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage("Payment successfully updated.");
		
		return ResponseEntity.ok(message);
	}
}
