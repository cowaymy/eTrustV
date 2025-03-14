package com.coway.trust.web.payment.govEInvoice.controller;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvoiceService;
import com.coway.trust.biz.payment.invoice.service.InvcNoBulkUploadVO;
import com.coway.trust.biz.payment.invoice.service.InvoiceService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.config.csv.CsvReadComponent;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment/einv")
public class GovEInvoiceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GovEInvoiceController.class);

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Resource(name = "govEInvoiceService")
	private GovEInvoiceService govEInvoiceService;

	/*@Resource(name = "invoiceService")
	private InvoiceService invoiceService;*/

	/**
	 * BillingMgnt 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initGovEInvoiceManagement.do")
	public String initEInvoiceManagement(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/govEInvoice/govEInvoiceList";
	}

	@RequestMapping(value = "/selectEInvStat.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectEInvStat(@RequestParam Map<String, Object> params) throws Exception {
	    List<EgovMap> codeList = govEInvoiceService.selectEInvStat(params);
	    return ResponseEntity.ok(codeList);
	  }

	@RequestMapping(value = "/selectEInvCommonCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectEInvCommonCode(@RequestParam Map<String, Object> params) throws Exception {
		List<EgovMap> codeList = govEInvoiceService.selectEInvCommonCode(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectEInvoiceList.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceStmtMgmtList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = null;

		LOGGER.debug("params : {}", params);

		list = govEInvoiceService.selectGovEInvoiceList(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/govEInvoiceNewPop.do")
	public String newInvoicePop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/govEInvoice/govEInvoiceNewPop";
	}

	@RequestMapping(value = "/govTaxInvoiceConsolidateNewPop.do")
	public String newGovTaxInvoiceConsolidatePop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/govEInvoice/govTaxInvoiceConsolidateNewPop";
	}

	@RequestMapping(value = "/govEInvoiceViewPop.do")
	public String viewInvoicePop(@RequestParam Map<String, Object> params, ModelMap model) {

		Map<String, Object> mainMap = govEInvoiceService.selectGovEInvoiceMain(params);
		model.addAttribute("data", mainMap);

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);
		model.addAttribute("today", today);
		return "payment/govEInvoice/govEInvoiceViewPop";
	}

	@RequestMapping(value = "/selectEInvoiceDetail.do")
	public ResponseEntity<List<EgovMap>> selectEInvoiceDetail(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = null;

		LOGGER.debug("params : {}", params);

		if(CommonUtils.nvl(params.get("invType")).equals("02") == false){
			list = govEInvoiceService.selectGovEInvoiceDetail(params);
		}
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/generateNewEInvClaim.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> generateNewEInvClaim(@RequestBody Map<String, ArrayList<Object>> params, Model model,
	      SessionVO sessionVO) {

	    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
	                                                                   // 가져오기
	    Map<String, Object> returnMap = new HashMap<String, Object>();
	    Map<String, Object> searchMap = null;
	    String returnCode = "";

	    // form 객체 값을 담을 Map
	    Map<String, Object> eInvClaim = new HashMap<String, Object>();

	    // form 객체 데이터 세팅
	    if (formList.size() > 0) {
	      formList.forEach(obj -> {
	        Map<String, Object> map = (Map<String, Object>) obj;
	        eInvClaim.put((String) map.get("name"), map.get("value"));
	      });
	    }
	    // 검색 파라미터 확인.(화면 Form객체 입력값)
	    LOGGER.debug("new_invoiceType : {}", eInvClaim.get("sInvType"));
	    LOGGER.debug("new_InvoiceDateMonth : {}", eInvClaim.get("namecrtsdt"));

	    // HasActiveBatch : 동일한 bankId, Claim Type 에 해당하는 active 건이 있는지 확인한다.
	    searchMap = new HashMap<String, Object>();
	    searchMap.put("invType", eInvClaim.get("sInvType"));
	    searchMap.put("invoicePeriod", eInvClaim.get("namecrtsdt"));
//	    searchMap.put("fromDate", eInvClaim.get("namecrtsdt"));
//	    searchMap.put("toDate", eInvClaim.get("sRqtendDt"));
	    searchMap.put("status", "1");

	    List<EgovMap> isActiveBatchList = govEInvoiceService.selectGovEInvoiceList(searchMap);

	    // Active인 배치가 있는 경우
	    if (isActiveBatchList.size() > 0) {
	      returnCode = "IS_BATCH";
	      returnMap = (Map<String, Object>) isActiveBatchList.get(0);
	    } else {

//	      String isCRC = "131".equals((String.valueOf(eInvClaim.get("sInvType")))) ? "1": "132".equals((String.valueOf(claim.get("new_claimType")))) ? "0" : "134";
//	      String inputDate = CommonUtils.changeFormat(String.valueOf(eInvClaim.get("new_debitDate")), "dd/MM/yyyy", "yyyyMMdd");
//	      String claimDay = CommonUtils.nvl(String.valueOf(eInvClaim.get("new_claimDay")));
//	      claim.put("new_cardType", cardType);
	    	searchMap.put("userId", sessionVO.getUserId());

	      govEInvoiceService.createEInvClaim(searchMap);

	      String resultStr = searchMap.get("p1").toString();

	      if ("999".equals(resultStr)) {
	          throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + resultStr + ":" + "New E-Invoice Error");
	      }

//	      if (resultMapList.size() > 0) {
	        // 프로시저 결과 Map
//	        returnMap = (Map<String, Object>) resultMapList.get(0);

	        // Calim Master 및 Detail 조회
	        // EgovMap claimMasterMap = claimService.selectClaimById(returnMap);
	        // List<EgovMap> claimDetailList =
	        // claimService.selectClaimDetailById(returnMap);

	        try {
	          // 파일 생성하기
	          // this.createClaimFileMain(claimMasterMap,claimDetailList);
	          returnCode = "FILE_OK";
	        } catch (Exception e) {
	          returnCode = "FILE_FAIL";
	        }
//	      }
//	    else {
//	        returnCode = "FAIL";
//	      }
	    }

	    // 결과 만들기.
	    ReturnMessage message = new ReturnMessage();
	    message.setCode(returnCode);
	    message.setData(returnMap);
	    message.setMessage("Enrollment successfully saved. \n Enroll ID : ");

	    return ResponseEntity.ok(message);

	  }

	@RequestMapping(value = "/generateNewTaxInvConsolidateClaim.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> generateNewTaxInvConsolidateClaim(@RequestBody Map<String, ArrayList<Object>> params, Model model,
	      SessionVO sessionVO) {

	    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
	                                                                   // 가져오기
	    Map<String, Object> returnMap = new HashMap<String, Object>();
	    Map<String, Object> searchMap = null;
	    String returnCode = "";

	    // form 객체 값을 담을 Map
	    Map<String, Object> eInvClaim = new HashMap<String, Object>();

	    // form 객체 데이터 세팅
	    if (formList.size() > 0) {
	      formList.forEach(obj -> {
	        Map<String, Object> map = (Map<String, Object>) obj;
	        eInvClaim.put((String) map.get("name"), map.get("value"));
	      });
	    }
	    // 검색 파라미터 확인.(화면 Form객체 입력값)
	    LOGGER.debug("new_invoiceType : {}", eInvClaim.get("sInvType"));
	    LOGGER.debug("new_InvoiceDateMonth : {}", eInvClaim.get("namecrtsdt"));

	    // HasActiveBatch : 동일한 bankId, Claim Type 에 해당하는 active 건이 있는지 확인한다.
	    searchMap = new HashMap<String, Object>();
	    searchMap.put("invType", eInvClaim.get("sInvType"));
	    searchMap.put("invBillType", eInvClaim.get("sInvBillType"));
	    searchMap.put("invMonth", eInvClaim.get("sRqtStartDt"));
	    searchMap.put("status", "1");

	    List<EgovMap> isActiveBatchList = govEInvoiceService.selectGovEInvoiceList(searchMap);

	    // Active인 배치가 있는 경우
	    if (isActiveBatchList.size() > 0) {
	      returnCode = "IS_BATCH";
	      returnMap = (Map<String, Object>) isActiveBatchList.get(0);
	    } else {

	    searchMap.put("userId", sessionVO.getUserId());

	    if(eInvClaim.get("sInvBillType").equals("01")){
		      govEInvoiceService.createTaxInvConsolidateClaim(searchMap);
	    }
	    else if(eInvClaim.get("sInvBillType").equals("02")){
		      govEInvoiceService.createTaxInvConsolidateClaimCNDN(searchMap);
	    }
	    else{
		    ReturnMessage message = new ReturnMessage();
		    message.setCode(AppConstants.FAIL);
		    message.setMessage("No Invoice Type is selected.");

		    return ResponseEntity.ok(message);
	    }

	      String resultStr = searchMap.get("p1").toString();

	      if ("999".equals(resultStr)) {
	          throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + resultStr + ":" + "New E-Invoice Error");
	      }

//	      if (resultMapList.size() > 0) {
	        // 프로시저 결과 Map
//	        returnMap = (Map<String, Object>) resultMapList.get(0);

	        // Calim Master 및 Detail 조회
	        // EgovMap claimMasterMap = claimService.selectClaimById(returnMap);
	        // List<EgovMap> claimDetailList =
	        // claimService.selectClaimDetailById(returnMap);

	        try {
	          // 파일 생성하기
	          // this.createClaimFileMain(claimMasterMap,claimDetailList);
	          returnCode = "FILE_OK";
	        } catch (Exception e) {
	          returnCode = "FILE_FAIL";
	        }
//	      }
//	    else {
//	        returnCode = "FAIL";
//	      }
	    }

	    // 결과 만들기.
	    ReturnMessage message = new ReturnMessage();
	    message.setCode(returnCode);
	    message.setData(returnMap);
	    message.setMessage("Enrollment successfully saved. \n Enroll ID : ");

	    return ResponseEntity.ok(message);

	  }

	@RequestMapping(value = "/saveEInvDeactivateBatch", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveEInvDeactivateBatch(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		int userId = sessionVO.getUserId();
		params.put("userId", userId);

		List<EgovMap>  paymentMs = govEInvoiceService.selectGovEInvoiceList(params);
		int result = 0;

		if(paymentMs != null){
			if(paymentMs.get(0).get("stsCode").toString().equals("1") || paymentMs.get(0).get("stsCode").toString().equals("104")){
				result = govEInvoiceService.saveEInvDeactivateBatch(params);
			}
		}

		if(result > 0){
			message.setMessage("Batch payment has been deactivated.");
			message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to deactivate this batch payment. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveEInvBatch.do")
	public ResponseEntity<ReturnMessage> saveEInvBatch(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		int result = 0;
		int userId = sessionVO.getUserId();
		params.put("userId", userId);

		result = govEInvoiceService.saveEInvBatch(params);

		if(result > 0){
			message.setMessage("Batch payment has been confirmed.");
			message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to confirmed this batch payment. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/govEInvoicePrepare.do")
	public void govEInvoicePrepare(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();

    	params.put("invType", "01"); //For E-Invoice Only
		resultValue = govEInvoiceService.prepareEInvClaim(params);

//		if(resultValue.get("status").equals("1")){
//			message.setMessage("Batch payment has been confirmed.");
//			message.setCode(AppConstants.SUCCESS);
//		}else{
//			message.setMessage("Failed to confirmed this batch payment. Please try again later.");
//			message.setCode(AppConstants.FAIL);
//		}

//		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/govEInvoiceSend.do")
	public void govEInvoiceSend(@RequestParam Map<String, Object> params, ModelMap model) {
		Map<String, Object> resultValue = new HashMap<String, Object>();

    	params.put("invType", "01"); //For E-Invoice Only
		resultValue = govEInvoiceService.sendEInvClaim(params);
	}

	@RequestMapping(value = "/govTaxInvPrepare.do")
	public ResponseEntity<ReturnMessage> govTaxInvPrepare(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();

    	params.put("invType", "02"); //For Consolidated Tax Invoice
		resultValue = govEInvoiceService.prepareEInvClaim(params);

		message.setMessage("Success");
		message.setCode(AppConstants.SUCCESS);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/govTaxInvoiceSend.do")
	public ResponseEntity<ReturnMessage> govTaxInvoiceSend(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		Map<String, Object> resultValue = new HashMap<String, Object>();

    	params.put("invType", "02"); //For Consolidated Tax Invoice
		resultValue = govEInvoiceService.sendEInvClaim(params);

		message.setMessage("Success");
		message.setCode(AppConstants.SUCCESS);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/checkStatusEInvClaim.do")
	public void checkStatusEInvClaim(@RequestParam Map<String, Object> params, ModelMap model) {
		Map<String, Object> resultValue = new HashMap<String, Object>();

    	params.put("invType", "01"); //For E-Invoice Only
		resultValue = govEInvoiceService.checkStatusEInvClaim(params);

	}

	@RequestMapping(value = "/checkStatusTaxInvClaim.do")
	public void checkStatusTaxInvClaim(@RequestParam Map<String, Object> params, ModelMap model) {
		Map<String, Object> resultValue = new HashMap<String, Object>();

    	params.put("invType", "02"); //For Consolidated Tax Invoice
		resultValue = govEInvoiceService.checkStatusEInvClaim(params);

	}

	@RequestMapping(value = "/dailyGenerateNewEInvClaim.do")
	  public ResponseEntity<ReturnMessage> dailyGenerateNewEInvClaim(@RequestParam Map<String, Object> params, Model model,
	      SessionVO sessionVO) {// 가져오기
	    Map<String, Object> returnMap = new HashMap<String, Object>();
	    Map<String, Object> searchMap = null;
	    String returnCode = "";

	    // 검색 파라미터 확인.(화면 Form객체 입력값)
	    LOGGER.debug("new_invoiceType : {}", params.get("sInvType"));
	    LOGGER.debug("new_InvoiceDateMonth : {}", params.get("namecrtsdt"));

	    // HasActiveBatch : 동일한 bankId, Claim Type 에 해당하는 active 건이 있는지 확인한다.
	    searchMap = new HashMap<String, Object>();
	    searchMap.put("invType", params.get("sInvType"));
	    searchMap.put("invoicePeriod", params.get("namecrtsdt"));
//	    searchMap.put("fromDate", eInvClaim.get("namecrtsdt"));
//	    searchMap.put("toDate", eInvClaim.get("sRqtendDt"));
	    searchMap.put("status", "1");

//	    List<EgovMap> isActiveBatchList = govEInvoiceService.selectGovEInvoiceList(searchMap);

	    // Active인 배치가 있는 경우
//	    if (isActiveBatchList.size() > 0) {
//	      returnCode = "IS_BATCH";
//	      returnMap = (Map<String, Object>) isActiveBatchList.get(0);
//	    } else {

//	      String isCRC = "131".equals((String.valueOf(eInvClaim.get("sInvType")))) ? "1": "132".equals((String.valueOf(claim.get("new_claimType")))) ? "0" : "134";
//	      String inputDate = CommonUtils.changeFormat(String.valueOf(eInvClaim.get("new_debitDate")), "dd/MM/yyyy", "yyyyMMdd");
//	      String claimDay = CommonUtils.nvl(String.valueOf(eInvClaim.get("new_claimDay")));
//	      claim.put("new_cardType", cardType);
	    	searchMap.put("userId", "349");

	      govEInvoiceService.createEInvClaimDaily(searchMap);

	      String resultStr = searchMap.get("p1").toString();

	      returnCode = resultStr;
//	      if ("999".equals(resultStr)) {
//	          throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + resultStr + ":" + "New E-Invoice Error");
//	      }

//	      if (resultMapList.size() > 0) {
	        // 프로시저 결과 Map
//	        returnMap = (Map<String, Object>) resultMapList.get(0);

	        // Calim Master 및 Detail 조회
	        // EgovMap claimMasterMap = claimService.selectClaimById(returnMap);
	        // List<EgovMap> claimDetailList =
	        // claimService.selectClaimDetailById(returnMap);

//	        try {
//	          // 파일 생성하기
//	          // this.createClaimFileMain(claimMasterMap,claimDetailList);
//	          returnCode = "FILE_OK";
//	        } catch (Exception e) {
//	          returnCode = "FILE_FAIL";
//	        }
//	      }
//	    else {
//	        returnCode = "FAIL";
//	      }
//	    }

	    // 결과 만들기.
	    ReturnMessage message = new ReturnMessage();
	    message.setCode(returnCode);
	    message.setData(returnMap);
	    message.setMessage("Enrollment successfully saved. \n Enroll ID : ");

	    return ResponseEntity.ok(message);

	  }

}
