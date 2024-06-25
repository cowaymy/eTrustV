package com.coway.trust.web.supplement.payment;

import java.io.IOException;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.supplement.payment.service.SupplementBatchPaymentService;
import com.coway.trust.biz.supplement.payment.service.SupplementBatchPaymentVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/supplement/payment")
public class SupplementBatchPaymentController {

	private static final Logger logger = LoggerFactory.getLogger(SupplementBatchPaymentController.class);

	@Resource(name = "supplementBatchPaymentService")
	private SupplementBatchPaymentService supplementBatchPaymentService;

	@Autowired
	private CsvReadComponent csvReadComponent;

	/******************************************************
	 *  Batch Payment List
	 *****************************************************/
	/**
	 *  Batch Payment List
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/supplementPaymentList.do")
	public String initDailyCollection(@RequestParam Map<String, Object> params, ModelMap model) {
		return "supplement/payment/supplementBatchPaymentList";
	}

	/**
	 * selectBatchList
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectSupplementBatchPaymentList.do")
	public ResponseEntity<List<EgovMap>> selectSupplementBatchPaymentList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		String[] payMode = request.getParameterValues("payMode");
		String[] confirmStatus = request.getParameterValues("confirmStatus");
		String[] batchStatus = request.getParameterValues("batchStatus");
		List<String> confirmStatusList = new ArrayList<String>();

		if(confirmStatus.length > 0){
			for(int i=0 ; i < confirmStatus.length; i++){
				confirmStatusList.add(confirmStatus[i].toString());
			}
		}

		params.put("payMode", payMode);
		params.put("confirmStatus", confirmStatusList);
		params.put("batchStatus", batchStatus);
		List<EgovMap> batchList = supplementBatchPaymentService.selectBatchList(params);

		return ResponseEntity.ok(batchList);
	}

	/**
	 * selectBatchDetailInfo
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectSupplementBatchInfo", method = RequestMethod.GET)
	public ResponseEntity<Map> selectSupplementBatchInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		//DETAIL INFO
		EgovMap batchPaymentView = supplementBatchPaymentService.selectBatchPaymentView(params);
		//DETAIL LIST
		List<EgovMap> batchPaymentDetList = supplementBatchPaymentService.selectBatchPaymentDetList(params);
		//TOTAL VALID AMT
		EgovMap  totalValidAmt = supplementBatchPaymentService.selectTotalValidAmt(params);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("batchPaymentView", batchPaymentView);
		resultMap.put("batchPaymentDetList", batchPaymentDetList);
		resultMap.put("totalItem", batchPaymentDetList.size());
		resultMap.put("totalValidAmt", totalValidAmt);

     return ResponseEntity.ok(resultMap);
	}

	/**
	 * selectBatchPayItemList
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectBatchPayItemList", method = RequestMethod.GET)
	public ResponseEntity<Map> selectBatchPayItemList(@RequestParam Map<String, Object> params, ModelMap model) {
		//DETAIL LIST
		List<EgovMap> batchPaymentDetList = supplementBatchPaymentService.selectBatchPaymentDetList(params);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("batchPaymentDetList", batchPaymentDetList);

     return ResponseEntity.ok(resultMap);
	}

	/**
	 * updRemoveItem
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updRemoveItem.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updRemoveItem(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		int userId = sessionVO.getUserId();
		params.put("userId", userId);

		EgovMap paymentDs = supplementBatchPaymentService.selectBatchPaymentDs(params);
		int result = 0;

		if(paymentDs != null){
			params.put("batchId",paymentDs.get("batchId").toString());
			if(paymentDs.get("userRefNo") != null){
				params.put("userRefNo",paymentDs.get("userRefNo").toString());
			}

			result = supplementBatchPaymentService.updRemoveItem(params);
		}

		if(result > 0){
			message.setMessage("Payment item has been removed.");
			message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to remove payment item. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

	/**
	 * saveItemConfirm
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveConfirmBatch", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveItemConfirm(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		int userId = sessionVO.getUserId();
		params.put("userId", userId);
		int result = supplementBatchPaymentService.saveConfirmBatch(params);

		if(result > 0){
			message.setMessage("Batch payment has been confirmed.");
			message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to confirm this batch payment. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

	/**
	 * saveDeactivateBatch
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveDeactivateBatch", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> DeactivateBatch(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		int userId = sessionVO.getUserId();
		params.put("userId", userId);

		EgovMap  paymentMs = supplementBatchPaymentService.selectBatchPaymentMs(params);
		int result = 0;

		if(paymentMs != null){
			if(String.valueOf(paymentMs.get("batchStusId")).equals("1")){
				result = supplementBatchPaymentService.saveDeactivateBatch(params);
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

	/**
	 * CSV
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/csvFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvFileUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
	  int result = 0;
	  ReturnMessage message = new ReturnMessage();

		String payModeId = request.getParameter("payModeId");
		String cardModeIdPos = supplementBatchPaymentService.selectBatchPayCardModeId("POS");

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<SupplementBatchPaymentVO> vos = csvReadComponent.readCsvToList(multipartFile, true, SupplementBatchPaymentVO::create);

		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
		for (SupplementBatchPaymentVO vo : vos) {
  		  HashMap<String, Object> hm = new HashMap<String, Object>();
  			hm.put("disabled", 0);
  			hm.put("validStatusId", 1);
  			hm.put("validRemark", "");
  			hm.put("userOrderNo", vo.getOrderNo().trim());
  			hm.put("userTrNo", vo.getTrNo().trim());
  			hm.put("userRefNo", vo.getRefNo().trim());
  			hm.put("userAmount", vo.getAmount().trim());
  			hm.put("userBankAcc", vo.getBankAcc().trim());
  			hm.put("userChqNo", vo.getChqNo().trim());
  			hm.put("userIssueBank", vo.getIssueBank().trim());
  			hm.put("userRunningNo", vo.getRunningNo().trim());
  			hm.put("userEftNo", vo.getEftNo().trim());
  			hm.put("userRefDate_Month", vo.getRefDate_Month().trim());
  			hm.put("userRefDate_Day", vo.getRefDate_Day().trim());
  			hm.put("userRefDate_Year", vo.getRefDate_Year().trim());
  			hm.put("userBankChargeAmt", vo.getBankChargeAmt().trim());
  			hm.put("userBankChargeAcc", vo.getBankChargeAcc().trim());
  			hm.put("sysOrderId", 0);
  			hm.put("sysAppTypeId", 0);
  			hm.put("sysAmount", 0);
  			hm.put("sysBankAccId", 0);
  			hm.put("sysIssBankId", 0);
  			hm.put("sysRefDate", "1900/01/01");
  			hm.put("sysBCAmt", 0);
  			hm.put("sysBCAccId", 0);
  			hm.put("userRemark", vo.getUserRemark().trim());
  			hm.put("cardNo", vo.getCardNo());
  		  hm.put("creator", sessionVO.getUserId());
        hm.put("updator", sessionVO.getUserId());

        if("108".equals(payModeId) && vo.getCardMode().trim().equals("POS")){
  			  hm.put("cardModeId", cardModeIdPos);
  			} else {
  				hm.put("cardModeId", "");
  			}

  			hm.put("approvalCode", vo.getApprovalCode());

  			if(!vo.getTrDate().trim().equals("")){
  				hm.put("userTrDate", vo.getTrDate().trim());
  			}else{
  				hm.put("userTrDate", "1900/01/01");
  			}

  			hm.put("userCollectorCode", vo.getCollectorCode().trim());
  			hm.put("sysCollectorId", 0);

  			if(!vo.getPaymentType().trim().equals("")){
  				hm.put("paymentType", vo.getPaymentType().trim());
  			}else{
  				hm.put("paymentType", "");
  			}

  			hm.put("PaymentTypeId", 0);
  			if(!vo.getAdvanceMonth().trim().equals("")){
  				hm.put("advanceMonth", vo.getAdvanceMonth().trim());
  			}else{
  				hm.put("advanceMonth", 0);
  			}

  			if(!vo.getPaymentChnnl().isEmpty()){
  			  hm.put("paymentChnnl", vo.getPaymentChnnl().trim());
  			} else{
  			  hm.put("paymentChnnl", "");
  			}

  			detailList.add(hm);
		}

		Map<String, Object> master = new HashMap<String, Object>();
		master.put("payModeId", payModeId);
		master.put("batchStatusId", 1);
		master.put("confirmStatusId", 44);
		master.put("convertDate", "1900/01/01");
		master.put("convertBy", 0);
		master.put("paymentType", 577); // 577 - Point of Sales Payment , 48-Payment type (code master id)
		master.put("paymentRemark", "");
		master.put("paymentCustType", 1368);
		master.put("jomPay", request.getParameter("jomPay"));
		master.put("advance", request.getParameter("advance"));
		master.put("eMandate", request.getParameter("eMandate"));
		master.put("isBatch", 0);
		master.put("creator", sessionVO.getUserId());
    master.put("updator", sessionVO.getUserId());
    master.put("confirmDate", "1900/01/01");
    master.put("confirmBy", 0);

		result = supplementBatchPaymentService.saveBatchPaymentUpload(master, detailList);

    if (result > 0) {
      message.setMessage("Batch payment item(s) successfully uploaded.<br/> Batch ID : " + result);
    } else {
      message.setMessage("Failed to upload batch payment item(s). Please try again later.");
    }

		return ResponseEntity.ok(message);
	}
}
