package com.coway.trust.web.payment.payment.controller;

import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.web.servlet.ModelAndView;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.SampleApplication;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.payment.service.PayDHistoryVO;
import com.coway.trust.biz.payment.payment.service.PayDVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByOrganizationVO;
import com.coway.trust.biz.payment.payment.service.SearchPaymentService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;
import com.googlecode.mp4parser.h264.Debug;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class SearchPaymentController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SearchPaymentController.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "accessMonitoringService")
	private AccessMonitoringService accessMonitoringService;

	@Resource(name = "searchPaymentService")
	private SearchPaymentService searchPaymentService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

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

	/******************************************************
	 * Search Payment  View Details POPUP
	 *****************************************************/
	/**
	 * SearchPayment View Details 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initSearchPaymentViewPop.do")
	public String initSearchPaymentViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callPrgm", params.get("callPrgm"));
		model.addAttribute("payId", params.get("payId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		return "payment/payment/searchPaymentViewPop";
	}

	/******************************************************
	 * Search Payment  Edit Details POPUP
	 *****************************************************/
	/**
	 * SearchPayment Edit Details 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initSearchPaymentEditPop.do")
	public String initSearchPaymentEditPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callPrgm", params.get("callPrgm"));
		model.addAttribute("payId", params.get("payId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		return "payment/payment/searchPaymentEditPop";
	}

	/******************************************************
	 * Search Payment  Edit Basic info POPUP
	 *****************************************************/
	/**
	 * SearchPayment Edit Details 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initSearchPaymentEditBasicPop.do")
	public String initSearchPaymentEditBasicPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callPrgm", params.get("callPrgm"));
		model.addAttribute("payId", params.get("payId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		return "payment/payment/searchPaymentEditBasicPop";
	}

	/******************************************************
	 * Search Payment  View History POPUP
	 *****************************************************/
	/**
	 * SearchPayment View History 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initViewHistoryPop.do")
	public String initViewHistoryPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("payId", params.get("payId"));
		return "payment/payment/viewHistoryPop";
	}

	/******************************************************
	 * Search Payment  View Detail History POPUP
	 *****************************************************/
	/**
	 * SearchPayment View Detail History 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initDetailHistoryPop.do")
	public String initDetailHistoryPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("payItemId", params.get("payItemId"));
		return "payment/payment/detailHistoryPop";
	}

	/******************************************************
	 * Search Payment  Item Edit Cheque POPUP
	 *****************************************************/
	/**
	 * SearchPayment Item Edit Cheque 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initItemEditChequePop.do")
	public String initItemEditChequePop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("payItemId", params.get("payItemId"));
		return "payment/payment/itemEditChequePop";
	}

	/**
	 * SearchPayment Order List(Master Grid) 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectOrderList", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOrderList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {

    	//Log down user search params
        SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
    	requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/initSearchPayment.do/");
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

        // 조회.

        List<EgovMap> resultList = searchPaymentService.selectOrderList(params);
        int totalRowCount = searchPaymentService.selectOrderListCount(params);
//        List<EgovMap> resultList_OrNo = searchPaymentService.selectOrderList_OrNo(params);


//        if(resultList_OrNo != null  && params.get("trxId") != null && !params.get("trxId").toString().equalsIgnoreCase("")){
//        	params.put("mtchIDList", resultList_OrNo);
//        	 List<EgovMap> resultList2 = searchPaymentService.selectOrderList_aNoOrNo(params);
//             resultList.addAll(resultList2);
//        }

        Map<String, Object> result = new HashMap<String, Object>();


		result.put("resultList", resultList);
		result.put("totalRowCount", totalRowCount);

		return ResponseEntity.ok(result);
	}

	/**
	 * SearchPayment Order List(Master Grid) 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectOrderListPaging", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOrderListPaging(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {
    	//Log down user search params
        SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
    	requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/initSearchPayment.do/");
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

        // 조회.
        List<EgovMap> resultList = searchPaymentService.selectOrderList(params);

        Map<String, Object> result = new HashMap<String, Object>();
		result.put("resultList", resultList);

		return ResponseEntity.ok(result);
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
        LOGGER.debug("payId22 : {}", params);

        String payItemAmt = searchPaymentService.selectPayItmAmt(params);

        LOGGER.debug("payItemAmt : {}", payItemAmt);

        params.put("payItemAmt", payItemAmt);

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


        List<EgovMap> result = searchPaymentService.selectPayIdFromPayItemId(params);
        params.put("payId", String.valueOf(result.get(0).get("payId")));
        LOGGER.debug("payItemId : {}", params);
        LOGGER.debug("payId : {}", result);

        String payItemAmt = searchPaymentService.selectPayItmAmt(params);

	    params.put("payItemAmt", payItemAmt);


		List<EgovMap> resultList = searchPaymentService.selectPaymentItem(params);
		LOGGER.debug("result : {}", resultList.get(0));
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}

	/******************************************************
	 * Search Payment (RC By Sales)
	 *****************************************************/
	/**
	 * SearchPayment초기 화면
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
     * RentalCollectionByBSNew초기화 화면
     * @param params
     * @param model
     * @return
     */
    @RequestMapping(value = "/initRentalCollectionByBSNew.do")
    public String initRentalCollectionByBSNew(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
  	    if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
    		sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){

            params.put("userId", sessionVO.getUserId());
            EgovMap result =  salesCommonService.getUserInfo(params);

            model.put("orgCode", result.get("orgCode"));
            model.put("grpCode", result.get("grpCode"));
            model.put("deptCode", result.get("deptCode"));
            model.put("memCode", result.get("memCode"));
        }
        return "payment/payment/rentalCollectionByBSNew";
    }

	/**
     * RentalCollectionByBS   조회
     * @param searchVO
     * @param params
     * @param model
     * @return
     */
    @RequestMapping(value = "/selectRentalCollectionByBSNewList", method = RequestMethod.GET)
    public ResponseEntity<List<RentalCollectionByBSSearchVO>> selectRentalCollectionByBSNewList(@ModelAttribute("searchVO")RentalCollectionByBSSearchVO searchVO
                , @RequestParam Map<String, Object> params, ModelMap model) {

        // 조회.
        List<RentalCollectionByBSSearchVO> resultList = searchPaymentService.searchRentalCollectionByBSNewList(searchVO);

        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
    }

	/**
	 * SearchMaster 조회
	 * @param SearchVO
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
	 * @param SearchVO
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
	 * @param SearchVO
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

		String payItemAmt = searchPaymentService.selectPayItmAmt(params);

	    params.put("payItemAmt", payItemAmt);

		//selectPaymentDetailView
		List<EgovMap> selectPaymentDetailView = searchPaymentService.selectPaymentDetailView(params);

		//selectPaymentDetailSlaveList
		List<EgovMap> selectPaymentDetailSlaveList = searchPaymentService.selectPaymentDetailSlaveList(params);

		//selectPaymentItemIsPassRecon
		List<EgovMap> paymentItemIsPassRecon = searchPaymentService.selectPaymentItemIsPassRecon(params);

		Map<String, Object> resultMap = new HashMap<String, Object>();
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
	 * PaymentCash 저장
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCash", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveCash(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {


		int userId = sessionVO.getUserId();
		String message = "";

		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);

		if(userId > 0){
		PayDVO payDet = new PayDVO();
    		LOGGER.debug("params : {}", params);
    		boolean valid = true;

    		String refNo = String.valueOf(params.get("txtReferenceNoCa")).trim();
    		String refDate = String.valueOf(params.get("txtRefDateCa")).trim();
    		String remark = String.valueOf(params.get("tareaRemarkCa")).trim();
    		String runNo = String.valueOf(params.get("txtRunNoCa")).trim();
    		String eftNo = "";
    		int payItemId = Integer.parseInt(params.get("payItemId").toString());

    		if(refNo.length() > 20){
    			valid = false;
    			message += "* Reference number cannot exceed length of 20.<br>";
    		}

    		if(!valid){
    			msg.setMessage(message);
    			return ResponseEntity.ok(msg);
    		}

    		payDet = this.getSaveDataPayDet(payItemId, userId, refNo, 0, refDate, remark, "", "", 0, runNo, eftNo, 0);

    		boolean result = searchPaymentService.doEditPaymentDetails(payDet);

    		if(result)
				message = "Payment item successfully updated.";
			else
				message = "Failed to Update. Please try again later.";
		}else{
			message = "Your login session has expired. Please relogin to our system.";
		}

		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}

	/**
	 * PaymentCreditCard 저장
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCreditCard", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveCreditCard(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		int userId = sessionVO.getUserId();
		String message = "";

		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);

		boolean result = false;
		boolean valid = true;

		if(userId > 0){
			LOGGER.debug("params : {}", params);
			PayDVO payDet = new PayDVO();

			int payItemId = Integer.parseInt(String.valueOf(params.get("payItemIdCC")).trim());

			boolean isAOR = checkOrNoIsAorType(String.valueOf(payItemId));

			String refNo = String.valueOf(params.get("txtRefNoCC")).trim();
			String refDate = "01/01/1900";
			if(!(String.valueOf(params.get("txtRefDateCC")).trim().equals("")))
				refDate = String.valueOf(params.get("txtRefDateCC")).trim();
			String remark = String.valueOf(params.get("tareaRemarkCC")).trim();
			int issuedBankId = 0;
			int tempIssued = String.valueOf(params.get("cmbIssuedBankCC")).trim().equals("") ? -1 :  Integer.parseInt(String.valueOf(params.get("cmbIssuedBankCC")).trim());
			if(tempIssued > -1){
				issuedBankId = tempIssued;
			}

			String crcHolderName = String.valueOf(params.get("txtCCHolderName")).trim();
			int cardTypeId = 0;
			int tempCardType = String.valueOf(params.get("cmbCardTypeCC")).trim().equals("") ? -1 :  Integer.parseInt(String.valueOf(params.get("cmbCardTypeCC")).trim());
			if(tempCardType > -1){
				cardTypeId =tempCardType;
			}
			int crcTypeId = 0;
			int tempCrcType = String.valueOf(params.get("cmbCreditCardTypeCC")).trim().equals("") ||
					String.valueOf(params.get("cmbCreditCardTypeCC")).trim().equals("null") ? -1 :  Integer.parseInt(String.valueOf(params.get("cmbCreditCardTypeCC")).trim());
			if(tempCrcType > -1){
				crcTypeId = tempCrcType;
			}
			String crcExpiryDate = "";
			if(!String.valueOf(params.get("txtCCExpiry")).trim().equals("")){
				String expiryDate = String.valueOf(params.get("txtCCExpiry")).trim();
				String temp[] = expiryDate.split("/");
				crcExpiryDate = temp[1] + "/" + temp[2].substring(2, 4);
			}

			String runNo = String.valueOf(params.get("txtRunningNoCC")).trim();
			String eFTNo = "";

			//validation check
			if(tempIssued <= -1){
				valid = false;
				message += "* Please select the issued bank.<br/>";
			}
			if(tempCardType <= -1){
				valid = false;
				message += "* Please select the card type<br />";
			}
			if(!isAOR)
			{
				if(String.valueOf(params.get("cmbCardTypeCC")).trim().equals("1241") &&String.valueOf(params.get("txtCCHolderName")).trim().equals("")){
					valid = false;
					message += "* Please key in the credit card holder.<br />";
				}
				if(String.valueOf(params.get("txtCCExpiry")).trim().equals("")){
					valid = false;
					message += "* Please select the credit card expiry date. <br/>";
				}
				if(tempCrcType <= -1){
					valid = false;
					message += "* Please select the credit card type. <br />";
				}else{
					if(String.valueOf(params.get("txtCrcNo")).trim().startsWith("5")){
						if(!(String.valueOf(params.get("cmbCreditCardTypeCC")).trim().equals("111"))){
							valid = false;
							message += "* Invalid credit card type.<br />";
						}
					}
					else if(String.valueOf(params.get("txtCrcNo")).trim().startsWith("4")){
						if(!(String.valueOf(params.get("cmbCreditCardTypeCC")).trim().equals("112"))){
							valid = false;
							message += "* Invalid credit card type. <br />";
						}
					}
				}
			}
			if(!(refNo.equals(""))){
				if(refNo.length() > 20){
					valid = false;
					message += "* Reference number cannot cxceed length of 20. <br />";
				}
			}

			if(!valid){
				msg.setMessage(message);
    			return ResponseEntity.ok(msg);
			}


			payDet = this.getSaveDataPayDet(payItemId, userId, refNo, issuedBankId, refDate, remark, crcHolderName, crcExpiryDate, crcTypeId, runNo, eFTNo, cardTypeId);

			result = searchPaymentService.doEditPaymentDetails(payDet);

			if(result)
				message = "Payment item successfully updated.";
			else
				message = "Failed to Update. Please try again later.";
		}else{
			message = "Your login session has expired. Please relogin to our system.";
		}

		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}

	/**
	 * PaymentCheque 저장
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCheque", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveCheque(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		int userId = sessionVO.getUserId();
		String message="";

		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);

		LOGGER.debug("params : {}", params);
		int payItemId = Integer.parseInt(params.get("payItemIdCh").toString());

		if(userId > 0){
			PayDVO payDet = new PayDVO();
			String refNo = String.valueOf(params.get("txtRefNumberCh")).trim();
			String refDate = "01/01/1900";
			if(!(String.valueOf(params.get("txtRefDateCh")).trim().equals(""))){
				refDate = String.valueOf(params.get("txtRefDateCh")).trim();
			}
			String remark = String.valueOf(params.get("tareaRemarkCh")).trim();
			int issuedBankId =0;
			int tempIssued = String.valueOf(params.get("sIssuedBankCh")).trim().equals("") ? -1 : Integer.parseInt(String.valueOf(params.get("sIssuedBankCh")).trim());
			if(tempIssued > -1){
				issuedBankId = tempIssued;
			}
			String runNo = String.valueOf(params.get("txtRunNoCh")).trim();
			String eFTNo = "";

			boolean valid = true;
			if(tempIssued <= -1){
				valid = false;
				message += "* Please select the issued bank. <br/>";
			}

			if(String.valueOf(params.get("chequeNoCh")).trim().equals("")){
				valid = false;
				message += "* Please key in the cheque number.<br />";
			}

			if(refNo.trim().length() > 20){
				valid = false;
				message += "* Reference number cannot exceed length of 20.<br />";
			}

			if(!valid){
				msg.setMessage(message);
    			return ResponseEntity.ok(msg);
			}
			payDet = this.getSaveDataPayDet(payItemId, userId, refNo, issuedBankId, refDate, remark, "", "", 0, runNo, eFTNo, 0);
			boolean result = searchPaymentService.doEditPaymentDetails(payDet);

			if(result)
				message = "Payment item successfully updated.";
			else
				message = "Failed to Update. Please try again later.";
		}else{
			message = "Your login session has expired. Please relogin to our system.";
		}
		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}

	/**
	 * PaymentCheque 저장
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveOnline", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveOnline(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		int userId = sessionVO.getUserId();
		String message = "";

		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);

		LOGGER.debug("params : {}", params);
		int payItemId = Integer.parseInt(params.get("payItemIdOn").toString());


		if(userId > 0){
			PayDVO payDet = new PayDVO();

			String refNo = String.valueOf(params.get("txtRefNoOn")).trim();
			String refDate = "01/01/1900";
			if(!(String.valueOf(params.get("txtRefDateOn")).trim().equals(""))){
				refDate = String.valueOf(params.get("txtRefDateOn")).trim();
			}
			String remark = String.valueOf(params.get("tareaRemarkOn")).trim();
			int issuedBankId = 0;
			int tempIssued = String.valueOf(params.get("cmbIssuedBankOn")).trim().equals("") ? -1 : Integer.parseInt(String.valueOf(params.get("cmbIssuedBankOn")).trim());
			if(tempIssued > -1){
				issuedBankId = tempIssued;
			}
			String runNo = String.valueOf(params.get("txtRunNoOn")).trim();
			String eFTNo = String.valueOf(params.get("txtEFTNoOn")).trim();

			boolean valid = true;

			if(tempIssued <= -1){
				valid = false;
				message += "* Please select the issued bank.<br />";
			}

			if(!(refNo.equals(""))){
				if(refNo.length() > 20){
					valid = false;
					message += "* Reference number cannot exceed length of 20.<br/>";
				}
			}

			if(!valid){
				msg.setMessage(message);
    			return ResponseEntity.ok(msg);
			}

			payDet = this.getSaveDataPayDet(payItemId, userId, refNo, issuedBankId, refDate, remark, "", "", 0, runNo, eFTNo, 0);
			boolean result = searchPaymentService.doEditPaymentDetails(payDet);

			if(result)
				message = "Payment item successfully updated.";
			else
				message = "Failed to Update. Please try again later.";
		}else{
			message = "Your login session has expired. Please relogin to our system.";
		}
		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}

	private boolean checkOrNoIsAorType(String payItemId){
		boolean isAor = false;

		String worno = String.valueOf(searchPaymentService.checkORNoIsAORType(payItemId));

		if(!(worno.equals("null")))
			isAor = true;
		else
			isAor = false;

		return isAor;
	}

	private PayDVO getSaveDataPayDet(int payItemId, int userId, String refNo, int issuedBankId, String refDate, String remark, String crcHolderName, String crcExpiryDate, int crcTypeId, String runNo, String eftNo, int cardTypeId){

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
		payDet.setPayItemEFTNo(eftNo);
		payDet.setPayItemCardTypeId(cardTypeId);

		return payDet;
	}

	/**
	 * saveChanges
	 * @param SearchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveChanges", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveChanges(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
		int userId = sessionVO.getUserId();

        // 마스터조회
		EgovMap viewMaster = searchPaymentService.selectPayMaster(params);

		//마스터조회값
		String trNo = "";
		String brnchId = "";
		String collMemId = "";
		String allowComm = "";
		String trIssuDt = "";

		//화면에서 넘어온값
		String hiddenCollMemId = params.get("edit_txtCollectorId").equals("0") ?  "0" : String.valueOf(params.get("edit_txtCollectorId"));
		String btnAllowComm = params.get("btnAllowComm") != null ? "1" : "0"  ;

		if(viewMaster != null){
			trNo = viewMaster.get("trNo") != null ? String.valueOf(viewMaster.get("trNo")) : ""  ;
			brnchId = viewMaster.get("brnchId") != null ? String.valueOf(viewMaster.get("brnchId")) : "" ;
			collMemId = viewMaster.get("collMemId") != null ? String.valueOf(viewMaster.get("collMemId")) : "" ;
			allowComm = viewMaster.get("allowComm") != null ? String.valueOf(viewMaster.get("allowComm")) : "";
			trIssuDt = viewMaster.get("trIssuDt") != null ? String.valueOf(viewMaster.get("trIssuDt")) : "" ;
		}

		LOGGER.debug("마스터조회값 trNo : {}", trNo);
		LOGGER.debug("마스터조회값 brnchId : {}", brnchId);
		LOGGER.debug("마스터조회값 collMemId : {}", collMemId);
		LOGGER.debug("마스터조회값 allowComm : {}", allowComm);
		LOGGER.debug("마스터조회값 trIssuDt : {}", trIssuDt);
		LOGGER.debug("params===="+params);
		LOGGER.debug("hiddenCollMemId===="+hiddenCollMemId);
		LOGGER.debug("btnAllowComm===="+btnAllowComm);
		Map<String, Object> trMap = new HashMap<String, Object>();
		Map<String, Object> branchMap = new HashMap<String, Object>();
		Map<String, Object> collectorMap = new HashMap<String, Object>();
		Map<String, Object> allowMap = new HashMap<String, Object>();
		Map<String, Object> updMap = new HashMap<String, Object>();

		//1127 : TR Number
		if(!trNo.equals(String.valueOf(params.get("edit_txtTRRefNo")).trim())){

            String typeID = "1127";
            String payID = String.valueOf(params.get("hiddenPayId"));
            String valueFr = trNo;
            String valueTo = String.valueOf(params.get("edit_txtTRRefNo")).trim();
            String refIDFr = "0";
            String refIDTo = "0";
            int createBy = userId;

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
		if(params.get("hiddenBranchId") != null && !brnchId.equals(String.valueOf(params.get("edit_branchId")))){

			Map<String, Object> frBranchIdMap = new HashMap<String, Object>();
			Map<String, Object> toBranchIdMap = new HashMap<String, Object>();
			String frBranchCode = "";
			String toBranchCode = "";
			frBranchIdMap.put("edit_branchId", brnchId);
			toBranchIdMap.put("edit_branchId", String.valueOf(params.get("hiddenBranchId")));
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
            String refIDTo = String.valueOf(params.get("hiddenBranchId"));
            int createBy = userId;


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
		if(!collMemId.equals(hiddenCollMemId)){

			Map<String, Object> frMemberIdMap = new HashMap<String, Object>();
			Map<String, Object> toMemberIdMap = new HashMap<String, Object>();
			String frMemberCode = "";
			String toMemberCode = "";
			frMemberIdMap.put("edit_txtCollectorId", collMemId);
			toMemberIdMap.put("edit_txtCollectorId", hiddenCollMemId);
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
            String valueTo = toMemberCode;//변경후 멤버코드
            String refIDFr = collMemId;//마스터멤버아이디(변경전데이터)
            String refIDTo = hiddenCollMemId;//인서트쳐야할 멤버아이디(변경후데이터)
            int createBy = userId;

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
		if(!allowComm.equals(btnAllowComm)){

            String typeID = "1137";
            String payID = String.valueOf(params.get("hiddenPayId"));
            String valueFr = allowComm.equals("0") ? "No":"Yes" ;
            String valueTo = btnAllowComm.equals("0") ? "No":"Yes";
            String refIDFr = "0";
            String refIDTo = "0";
            int createBy = userId;

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
		updMap.put("trNo", String.valueOf(params.get("edit_txtTRRefNo")).trim());

		/*
		if(trNo.equals(String.valueOf(params.get("edit_txtTRRefNo")).trim())){
			updMap.put("trNo", "");
		}else {
			updMap.put("trNo", String.valueOf(params.get("edit_txtTRRefNo")).trim());
		}
		*/

		updMap.put("brnchId", String.valueOf(params.get("hiddenBranchId")));

		List<EgovMap> payD = searchPaymentService.selectPayDs(params);

		EgovMap hm = null;
		EgovMap glRoute = null;
		if(payD.size() > 0){
			for (int i=0; i< payD.size() ; i++) {
				hm = (EgovMap) payD.get(i);

				glRoute = searchPaymentService.selectGlRoute(String.valueOf(hm.get("payItmId")));

				if(glRoute != null){
					Map<String, Object> glRouteMap = new HashMap<String, Object>();
					glRouteMap.put("brnchId", String.valueOf(params.get("hiddenBranchId")));
					glRouteMap.put("id", String.valueOf(glRoute.get("id")));
					searchPaymentService.updGlReceiptBranchId(glRouteMap);//PAY0009D 테이블 GL_RECIPT_BRNCH_ID 업데이트
				}
			}
		}

		/*
		if(params.get("edit_branchId") != null && !brnchId.equals(String.valueOf(params.get("edit_branchId")))){
			updMap.put("brnchId", String.valueOf(params.get("edit_branchId")));

			List<EgovMap> payD = searchPaymentService.selectPayDs(params);

			EgovMap hm = null;
			EgovMap glRoute = null;
			if(payD.size() > 0){
				for (int i=0; i< payD.size() ; i++) {
					hm = (EgovMap) payD.get(i);

					glRoute = searchPaymentService.selectGlRoute(String.valueOf(hm.get("payItmId")));

					if(glRoute != null){
						Map<String, Object> glRouteMap = new HashMap<String, Object>();
						glRouteMap.put("brnchId", String.valueOf(params.get("edit_branchId")));
						glRouteMap.put("id", String.valueOf(glRoute.get("id")));
						searchPaymentService.updGlReceiptBranchId(glRouteMap);//PAY0009D 테이블 GL_RECIPT_BRNCH_ID 업데이트
					}
				}
			}


		}else{
			updMap.put("brnchId", "");
		}
		*/

		updMap.put("collMemId", hiddenCollMemId);

		/*
		if(collMemId.equals(hiddenCollMemId)){
			updMap.put("collMemId", "");
		} else{
			updMap.put("collMemId", hiddenCollMemId);
		}
		*/

		updMap.put("allowComm", btnAllowComm);

		/*
		if(!allowComm.equals(btnAllowComm)){
			updMap.put("allowComm", btnAllowComm);
		}else{
			updMap.put("allowComm", "");
		}
		*/

		String trIssueDate = CommonUtils.nvl(params.get("edit_txtTRIssueDate")).equals("") ? "01/01/1900" : CommonUtils.nvl(params.get("edit_txtTRIssueDate"));
		updMap.put("trIssueDate", trIssueDate);
		/*
        if(!trIssuDt.equals(CommonUtils.nvl(params.get("edit_txtTRIssueDate")))){
			updMap.put("trIssueDate", trIssueDate);
		}else{
			updMap.put("trIssueDate", "");
		}
		*/
		searchPaymentService.updChanges(updMap);//변경값들 마스터테이블에 업데이트.

		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage("Payment successfully updated.");

		return ResponseEntity.ok(message);
	}

	/******************************************************
	 * RentalCollectionByBS(Aging Month)
	 *****************************************************/
	/**
	 * RentalCollectionByBS초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initRCByBSAgingMonth.do")
	public String initRCByBSAgingMonth(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

		return "payment/payment/rentalCollectionByBSAgingMonth";
	}

	/**
	 * RentalCollectionByBS(Aging Month)   조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRCByBSAgingMonthList", method = RequestMethod.GET)
	public ResponseEntity<List<RentalCollectionByBSSearchVO>> selectRCByBSAgingMonthList(@ModelAttribute("searchVO")RentalCollectionByBSSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

        // 조회.
        List<RentalCollectionByBSSearchVO> resultList = searchPaymentService.searchRCByBSAgingMonthList(searchVO);

        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}

	/**
     * RentalCollectionByBS초기화 화면
     * @param params
     * @param model
     * @return
     */
    @RequestMapping(value = "/initRCByBSAgingMonthNew.do")
    public String initRCByBSAgingMonthNew(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    	  if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
    		  sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){

            params.put("userId", sessionVO.getUserId());
            EgovMap result =  salesCommonService.getUserInfo(params);

            model.put("orgCode", result.get("orgCode"));
            model.put("grpCode", result.get("grpCode"));
            model.put("deptCode", result.get("deptCode"));
            model.put("memCode", result.get("memCode"));
        }

        return "payment/payment/rentalCollectionByBSAgingMonthNew";
    }

    /**
     * RentalCollectionByBS(Aging Month)   조회
     * @param searchVO
     * @param params
     * @param model
     * @return
     */
    @RequestMapping(value = "/selectRCByBSAgingMonthNewList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectRCByBSAgingMonthNewList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        // 조회.
        List<EgovMap> resultList = searchPaymentService.searchRCByBSAgingMonthNewList(params);

        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
    }

	@RequestMapping(value = "/initRCByOrganization.do")
	public String initRCByOrganization(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

		return "payment/payment/rentalCollectionByOrganization";
	}

	@RequestMapping(value = "/selectRCByOrganizationList", method = RequestMethod.GET)
	public ResponseEntity<List<RentalCollectionByOrganizationVO>> selectRCByOrganizationList(@ModelAttribute("searchVO")RentalCollectionByOrganizationVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {

        // 조회.
        List<RentalCollectionByOrganizationVO> resultList = searchPaymentService.searchRCByOrganizationList(searchVO);

        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}

	/**
     * RentalCollectionByCS
     * @param params
     * @param model
     * @return
     */
    @RequestMapping(value = "/initRentalCollectionByCS.do")
    public String initRentalCollectionByCS(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
  	  	if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
    		sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){

            params.put("userId", sessionVO.getUserId());
            EgovMap result =  salesCommonService.getUserInfo(params);

            model.put("orgCode", result.get("orgCode"));
            model.put("grpCode", result.get("grpCode"));
            model.put("deptCode", result.get("deptCode"));
            model.put("memCode", result.get("memCode"));
        }
        return "payment/payment/rentalCollectionByCS";
    }

    /**
     * RentalCollectionByBS초기화 화면
     * @param params
     * @param model
     * @return
     */
    @RequestMapping(value = "/initRCByCSAgingMonth.do")
    public String initRCByCSAgingMonth(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    	if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7 ||
            sessionVO.getUserTypeId() == 5758 || sessionVO.getUserTypeId() == 6672){

            params.put("userId", sessionVO.getUserId());
            EgovMap result =  salesCommonService.getUserInfo(params);

            model.put("orgCode", result.get("orgCode"));
            model.put("grpCode", result.get("grpCode"));
            model.put("deptCode", result.get("deptCode"));
            model.put("memCode", result.get("memCode"));
        }

        return "payment/payment/rentalCollectionByCSAgingMonth";
    }

}
