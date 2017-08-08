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
import com.coway.trust.biz.payment.payment.service.PayDHistoryVO;
import com.coway.trust.biz.payment.payment.service.PayDVO;
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
	
	/**
	 * SearchPayment PaymentItem 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectPaymentItem", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPaymentItem( @RequestParam Map<String, Object> params, ModelMap model) {
		//검색 파라미터 확인.(화면 Form객체 입력값)
        logger.debug("payItemId : {}", params.get("payItemId"));        

		List<EgovMap> resultList = searchPaymentService.selectPaymentItem(Integer.parseInt(params.get("payItemId").toString()));
		logger.debug("result : {}", resultList.get(0));
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
	 * PaymentDetailViewer 조회
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
		List<EgovMap> selectPaymentDetailView = searchPaymentService.selectPaymentDetailView(params);
		
		//selectPaymentDetailSlaveList
		List<EgovMap> selectPaymentDetailSlaveList = searchPaymentService.selectPaymentDetailSlaveList(params);
		
		//selectPaymentItemIsPassRecon
		EgovMap paymentItemIsPassRecon = searchPaymentService.selectPaymentItemIsPassRecon(params);
		
		Map resultMap = new HashMap();
		resultMap.put("viewMaster", viewMaster);
		resultMap.put("selectPaymentDetailView", selectPaymentDetailView);
		resultMap.put("selectPaymentDetailSlaveList", selectPaymentDetailSlaveList);
		if(orderProgressStatus != null){
			resultMap.put("orderProgressStatus", orderProgressStatus);
		}else{
			resultMap.put("orderProgressStatus", "");
		}
		
		int passReconSize = 0;
		if(paymentItemIsPassRecon != null){
			passReconSize = paymentItemIsPassRecon.size();
			resultMap.put("passReconSize", passReconSize);
		}else{
			resultMap.put("passReconSize", passReconSize);
		}
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultMap);
	}
	
	/**
	 * PaymentDetail 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/savePaymentDetail", method = RequestMethod.GET)
	public ResponseEntity<Map> savePaymentDetail(@RequestParam Map<String, Object> params, ModelMap model) {
	
		int userId = 12345;
		
		PayDVO payDet = new PayDVO();
		
		//TODO 파라미터값 수정 필요
		String refNo = params.get("referenceNo").toString();
		String refDate = params.get("refDate").toString();
		String remark = params.get("remark").toString();
		String runNo = params.get("runNo").toString();
		String EFTNo = "";
		int payItemId = Integer.parseInt(params.get("payItemId").toString());
		
		System.out.println(refNo);
		System.out.println(refDate);
		System.out.println(remark);
		System.out.println(runNo);
		System.out.println(EFTNo);
		System.out.println(payItemId);
		
		
		
		//switch(payItemId){
		//case 
		//}
		
		payDet = this.getSaveData_PayDet(payItemId, userId, refNo, 0, refDate, remark, "", "", 0, runNo, EFTNo, 0);

		EgovMap qryDet = searchPaymentService.selectPaymentDetail(payItemId).get(0);
		System.out.println("qryDet1 : " + searchPaymentService.selectPaymentDetail(payItemId).get(0));
		System.out.println("qryDET : " + qryDet);
		//searchPaymentService.insertPayHistory(payDet, qryDet);
		List<PayDHistoryVO> list = setHistoryList(payDet, qryDet);
		
		//TODO insert payDHistory테이블 필요함 추후에 for문 삭제 필요
		for(int i=0; i<list.size(); i++){
			System.out.println(list.get(i).toString());
		}
		
		if(list.size() > 0){
			
		}
		
		System.out.println("qryitemRefNo : " + qryDet.get("payItmRefNo"));
		
		System.out.println("result : " + qryDet.toString());
		
		return ResponseEntity.ok(null);
	}
	
	private List<PayDHistoryVO> setHistoryList(PayDVO payDet, EgovMap qryDet){
		List<PayDHistoryVO> list = new ArrayList();
		
		//1130 : Ref Number
		if(qryDet.get("payItmRefNo") != payDet.getPayItemRefNo()){
			PayDHistoryVO his = new PayDHistoryVO();
			
			his.setHistoryId(0);
			his.setTypeId(1130);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(qryDet.get("payItmRefNo").toString());
			his.setValueTo(payDet.getPayItemRefNo());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}
		
		//1131 : Ref Date
		//CommonUtils.getDiffDate(payDet.getPayItemRefDate(), qryDet.get("payItmRefDate").toString(), format)
		System.out.println("payItemRefDate : " + qryDet.get("payItmRefDt") + ", " + payDet.getPayItemRefDate());
		if(qryDet.get("payItmRefDt") != payDet.getPayItemRefDate()){
			PayDHistoryVO his = new PayDHistoryVO();
			
			his.setHistoryId(0);
			his.setTypeId(1131);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			if(!CommonUtils.isEmpty(qryDet.get("payItmRefDt"))){
				if(CommonUtils.getDiffDate(qryDet.get("payItmRefDt").toString(), "1900-01-01", "YYYY-MM-DD") != 0){
					his.setValueFr(qryDet.get("payItemRefDt").toString());
				}else{
					his.setValueFr("");
				}
			}else{
				his.setValueFr("");
			}
			
			if(!CommonUtils.isEmpty(payDet.getPayItemRefDate())){
				if(CommonUtils.getDiffDate(payDet.getPayItemRefDate(), "01/01/1900", "DD/MM/YYYY") != 0){
					his.setValueTo(payDet.getPayItemRefDate());
				}else{
					his.setValueTo("");
				}
			}else{
				his.setValueTo("");
			}
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}
		
		//1132 : Remark
		if(qryDet.get("payItmRem") != payDet.getPayItemRefNo()){
			PayDHistoryVO his = new PayDHistoryVO();
			
			his.setHistoryId(0);
			his.setTypeId(1132);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(qryDet.get("payItmRem").toString());
			his.setValueTo(payDet.getPayItemRemark());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}
		
		
		if(qryDet.get("payItmModeId").equals(106) || qryDet.get("payItmModeId").equals(107) || qryDet.get("payItmModeId").equals(108)){
			if(qryDet.get("payItmIssuBankId").toString() != String.valueOf(payDet.getPayItemIssuedBankId())){
				PayDHistoryVO his = new PayDHistoryVO();
				
				String qryBankFr = searchPaymentService.selectBankCode(qryDet.get("payItmIssuBankId").toString());
				String qryBankTo = searchPaymentService.selectBankCode(String.valueOf(payDet.getPayItemIssuedBankId()));
				
				his.setHistoryId(0);
				his.setTypeId(1133);
				his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
				his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
				if(qryBankFr != null){
					his.setValueFr(qryBankFr);
				}else{
					his.setValueFr("");
				}
				if(qryBankTo != null){
					his.setValueTo(qryBankTo);
				}else{
					his.setValueTo("");
				}
				
				if(qryDet.get("payItmIssuBankId").toString() != null){
					his.setRefIdFr(Integer.parseInt(qryDet.get("payItmIssuBankId").toString()));
				}else{
					his.setRefIdFr(0);
				}
				his.setRefIdTo(payDet.getPayItemIssuedBankId());
				his.setCreateAt(payDet.getUpdated());
				his.setCreateBy(payDet.getUpdator());
				list.add(his);
			}
		}
		
		if(Integer.parseInt(qryDet.get("payItmModeId").toString()) == 107){
			//1134 : CrcHolder
			if(qryDet.get("payItmCcHolderName") == null){
				qryDet.put("payItmCcHolderName", "");
			}
			
			//Sting.valueOf(qryDet.get("payItmCcHolderName"));
			
			if(qryDet.get("payItmCcHolderName").toString() != payDet.getPayItemCCHolderName().toString()){
				PayDHistoryVO his = new PayDHistoryVO();
				
				his.setHistoryId(0);
				his.setTypeId(1134);
				his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
				his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
				his.setValueFr(qryDet.get("payItmCcHolderName").toString());
				his.setValueTo(payDet.getPayItemCCHolderName());
				his.setRefIdFr(0);
				his.setRefIdTo(0);
				his.setCreateAt(payDet.getUpdated());
				his.setCreateBy(payDet.getUpdator());
				list.add(his);
			}
		}
		
		//1135 : Crc Expiry
		if(qryDet.get("payItmCcExprDt") == null){
			qryDet.put("payItmCcExprDt", "");
		}
		if(qryDet.get("payItmCcExprDt").toString() != payDet.getPayItemCCExpiryDate()){
			PayDHistoryVO his = new PayDHistoryVO();
			his.setHistoryId(0);
			his.setTypeId(1135);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(qryDet.get("payItmCcExprDt").toString());
			his.setValueTo(payDet.getPayItemCCExpiryDate());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}
		
		//1136 : Crc Type
		if(qryDet.get("payItmCcExprDt").toString() != payDet.getPayItemCCExpiryDate()){
			PayDHistoryVO his = new PayDHistoryVO();
			
			String qryTypeFr = searchPaymentService.selectCodeDetail(qryDet.get("payItmCcTypeId").toString());
			String qryTypeTo = searchPaymentService.selectCodeDetail(String.valueOf(payDet.getPayItemCCTypeId()));
			
			his.setHistoryId(0);
			his.setTypeId(1136);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			if(qryTypeFr != null){
				his.setValueFr(qryTypeFr);
			}else{
				his.setValueFr("");
			}
			
			if(qryTypeTo != null){
				his.setValueTo(qryTypeTo);
			}else{
				his.setValueTo("");
			}
			
			if(qryDet.get("payItmCcTypeId").toString() != null){
				his.setRefIdFr(Integer.parseInt(qryDet.get("payItmCcTypeId").toString()));
			}else{
				his.setRefIdFr(0);
			}
			his.setRefIdTo(payDet.getPayItemCCTypeId());
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}
		
		//1196 : Running Number
		if(qryDet.get("payItmRunngNo") == null){
			qryDet.put("payItmRunngNo", "");
		}
		String currentRunNo = qryDet.get("payItmRunngNo").toString() != null ? qryDet.get("payItmRunngNo").toString() : "";
		if(currentRunNo != payDet.getPayItemRunningNo()){
			PayDHistoryVO his = new PayDHistoryVO();
			his.setHistoryId(0);
			his.setTypeId(1196);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(currentRunNo);
			his.setValueTo(payDet.getPayItemRunningNo());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}
		
		//1197 : EFT Number
		if(qryDet.get("payItmEftNo") == null){
			qryDet.put("payItmEftNo", "");
		}
		String currentEFT = qryDet.get("payItmEftNo").toString() != null ? qryDet.get("payItmEftNo").toString() : "";
		if(currentRunNo != payDet.getPayItemRunningNo()){
			PayDHistoryVO his = new PayDHistoryVO();
			his.setHistoryId(0);
			his.setTypeId(1197);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			his.setValueFr(currentEFT);
			his.setValueTo(payDet.getPayItemEFTNo());
			his.setRefIdFr(0);
			his.setRefIdTo(0);
			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			list.add(his);
		}
		
		//1242 : Card Type
		System.out.println("############################payItmCardTypeId : " + qryDet.get("payItmCardTypeId").toString());
		int currentCardTypeId = qryDet.get("payItmCardTypeId").toString() != null ? Integer.parseInt(qryDet.get("payItmCardTypeId").toString()) : 0;
		if(currentCardTypeId != payDet.getPayItemCardTypeId()){
			PayDHistoryVO his = new PayDHistoryVO();
			
			String qryTypeFr = searchPaymentService.selectCodeDetail(qryDet.get("payItmCardTypeId").toString());
			String qryTypeTo = searchPaymentService.selectCodeDetail(String.valueOf(payDet.getPayItemCardTypeId()));
			
			his.setHistoryId(0);
			his.setTypeId(1242);
			his.setPayId(Integer.parseInt(qryDet.get("payId").toString()));
			his.setPayItemId(Integer.parseInt(qryDet.get("payItmId").toString()));
			if(qryTypeFr != null){
				his.setValueFr(qryTypeFr);
			}else{
				his.setValueFr("");
			}
			if(qryTypeTo != null){
				his.setValueTo(qryTypeTo);
			}else{
				his.setValueTo("");
			}
			
			if(qryDet.get("payItmCardTypeId").toString() != null)
			{
				his.setRefIdFr(Integer.parseInt(qryDet.get("payItmCardTypeId").toString()));
			}
			his.setRefIdTo(payDet.getPayItemCardTypeId());

			his.setCreateAt(payDet.getUpdated());
			his.setCreateBy(payDet.getUpdator());
			
			list.add(his);
		}
		
		return list;
	}
	
	private PayDVO getSaveData_PayDet(int payItemId, int userId, String refNo, int issuedBankId, String refDate, String remark, String crcHolderName, String crcExpiryDate, int crcTypeId, String runNo, String EFTNo, int cardTypeId){
		
		PayDVO payDet = new PayDVO();
		
		payDet.setPayItemId(payItemId);
		payDet.setPayItemRefNo(refNo);
		payDet.setPayItemIssuedBankId(issuedBankId);
		payDet.setPayItemRefDate(refDate);
		payDet.setPayItemRemark(remark);
		payDet.setPayItemCCHolderName(crcHolderName);
		payDet.setPayItemCCExpiryDate(crcExpiryDate);
		payDet.setPayItemCCTypeId(crcTypeId);
		payDet.setUpdated(CommonUtils.getNowDate());
		payDet.setUpdator(userId);
		payDet.setPayItemRunningNo(runNo);
		payDet.setPayItemEFTNo(EFTNo);
		payDet.setPayItemCardTypeId(cardTypeId);
		
		return payDet;
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
		String trNo = "";
		String brnchId = "";
		String collMemId = "";
		String allowComm = "";
		String trIssuDt = "";
		
		if(viewMaster != null){
			trNo = String.valueOf(viewMaster.get("trNo"));
			brnchId = String.valueOf(viewMaster.get("brnchId"));
			collMemId = String.valueOf(viewMaster.get("collMemId"));
			allowComm = String.valueOf(viewMaster.get("allowComm"));
			trIssuDt = String.valueOf(viewMaster.get("trIssuDt"));
		}
		
		logger.debug("마스터조회값 trNo : {}", trNo);
		logger.debug("마스터조회값 brnchId : {}", brnchId);
		logger.debug("마스터조회값 collMemId : {}", collMemId);
		logger.debug("마스터조회값 allowComm : {}", allowComm);
		logger.debug("마스터조회값 trIssuDt : {}", trIssuDt);

		Map trMap = new HashMap();
		Map branchMap = new HashMap();
		Map collectorMap = new HashMap();
		Map allowMap = new HashMap();
		Map updMap = new HashMap();
		
		//1127 : TR Number
		if(!trNo.equals(String.valueOf(params.get("edit_txtTRRefNo")))){
			
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
			
			Map frBranchIdMap = new HashMap();
			Map toBranchIdMap = new HashMap();
			String frBranchCode = "";
			String toBranchCode = "";
			frBranchIdMap.put("edit_branchId", brnchId);
			toBranchIdMap.put("edit_branchId", String.valueOf(params.get("edit_branchId")));
			EgovMap frCodeMap = searchPaymentService.selectBranchCode(frBranchIdMap);
			EgovMap toCodeMap = searchPaymentService.selectBranchCode(toBranchIdMap);
			
			if(frCodeMap != null){
				frBranchCode = String.valueOf(frCodeMap.get("code"));
			}else{
				frBranchCode = "";
			}
			
			if(toCodeMap != null){
				toBranchCode = String.valueOf(toCodeMap.get("code"));
			}else{
				toBranchCode = "";
			}
			
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
		if(!collMemId.equals(String.valueOf(params.get("collMemId")))){
			
			Map frMemberIdMap = new HashMap();
			Map toMemberIdMap = new HashMap();
			String frMemberCode = "";
			String toMemberCode = "";
			frMemberIdMap.put("edit_txtCollectorId", collMemId);
			toMemberIdMap.put("edit_txtCollectorId", String.valueOf(params.get("edit_txtCollectorId")));
			EgovMap frCodeMap = searchPaymentService.selectMemCode(frMemberIdMap);
			EgovMap toCodeMap = searchPaymentService.selectMemCode(toMemberIdMap);
			
			if(frCodeMap != null){
				frMemberCode = String.valueOf(frCodeMap.get("memCode"));
			}else{
				frMemberCode = "";
			}
			
			if(toCodeMap != null){
				toMemberCode = String.valueOf(toCodeMap.get("memCode"));
			}else{
				toMemberCode = "";
			}
			
            String typeID = "1129";
            String payID = String.valueOf(params.get("hiddenPayId"));
            String valueFr = frMemberCode;//변경전 멤버코드
            String valueTo = toMemberCode;//공통 멤버조회 생기면 넣자! 변경후 멤버코드
            String refIDFr = collMemId;//마스터멤버아이디(변경전데이터)
            String refIDTo = String.valueOf(params.get("edit_txtCollectorId"));//인서트쳐야할 멤버아이디(변경후데이터)
            String createBy = "52366";
            
            collectorMap.put("typeID", typeID);
            collectorMap.put("payID", payID);
            collectorMap.put("valueFr", valueFr);
            collectorMap.put("valueTo", valueTo);
            collectorMap.put("refIDFr", refIDFr);
            collectorMap.put("refIDTo", refIDTo);
            collectorMap.put("createBy", createBy);
            
            //searchPaymentService.saveChanges(collectorMap); 멤버조회 공통생성되면 그때붙이자
		}
		//1137 : Allow Commission
		if(!allowComm.equals(String.valueOf(params.get("allowComm")))){
			
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
		
		updMap.put("payId", String.valueOf(params.get("hiddenPayId")));
		if(!trNo.equals(String.valueOf(params.get("edit_txtTRRefNo")))){
			updMap.put("trNo", String.valueOf(params.get("edit_txtTRRefNo")));
		}else{
			updMap.put("trNo", "");
		}
			
		if(!brnchId.equals(String.valueOf(params.get("edit_branchId")))){
			updMap.put("brnchId", String.valueOf(params.get("edit_branchId")));
			
			EgovMap payD = searchPaymentService.selectPayDs(params);
			
			EgovMap glRoute = searchPaymentService.selectGlRoute(payD);
			
			if(glRoute != null){
				glRoute.put("brnchId", String.valueOf(params.get("edit_branchId")));
				searchPaymentService.updGlReceiptBranchId(glRoute);//PAY0009D 테이블 GL_RECIPT_BRNCH_ID 업데이트
			}
			
		}else{
			updMap.put("brnchId", "");
		}
		
		if(!collMemId.equals(String.valueOf(params.get("edit_txtCollectorCode")))){
			//updMap.put("collMemId", String.valueOf(params.get("edit_txtCollectorId"))); todo 입력받은 COLL_MEM_ID 로 업데이트쳐야됨
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
		searchPaymentService.updChanges(updMap);//변경값들 마스터테이블에 업데이트.
		
		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage("Payment successfully updated.");
		
		return ResponseEntity.ok(message);
	}
}
