package com.coway.trust.web.payment.refund.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.refund.service.BatchRefundService;
import com.coway.trust.biz.payment.refund.service.BatchRefundVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BatchRefundController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BatchRefundController.class);

	@Resource(name = "batchRefundService")
	private BatchRefundService batchRefundService;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@RequestMapping(value = "/batchRefund.do")
	public String batchRefund(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/refund/batchRefund";
	}

	@RequestMapping(value = "/selectBatchRefundList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBatchRefundList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);

		String[] payMode = request.getParameterValues("payMode");
		String[] batchStus = request.getParameterValues("batchStus");
		String[] cnfmStus = request.getParameterValues("cnfmStus");

		params.put("payMode", payMode);
		params.put("batchStus", batchStus);
		params.put("cnfmStus", cnfmStus);

		List<EgovMap> list = batchRefundService.selectBatchRefundList(params);

		LOGGER.debug("list =====================================>>  " + list.toString());
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/batchRefundViewPop.do")
	public String batchRefundViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);

		EgovMap bRefundInfo = batchRefundService.selectBatchRefundInfo(params);

		model.addAttribute("bRefundInfo", bRefundInfo);
		model.addAttribute("bRefundItem", new Gson().toJson(bRefundInfo.get("bRefundItem")));
		return "payment/refund/batchRefundViewPop";
	}

	@RequestMapping(value = "/batchRefundUploadPop.do")
	public String batchRefundUploadPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/refund/batchRefundUploadPop";
	}

	@RequestMapping(value = "/selectAccNoList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAccNoList(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> list = batchRefundService.selectAccNoList(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/bRefundCsvFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> bRefundCsvFileUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
		ReturnMessage message = new ReturnMessage();
		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<BatchRefundVO> vos = csvReadComponent.readCsvToList(multipartFile, true, BatchRefundVO::create);

		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
		String accNo = request.getParameter("accNo");
		for (BatchRefundVO vo : vos) {

			HashMap<String, Object> hm = new HashMap<String, Object>();

			hm.put("disabled", 0);
			hm.put("creator", sessionVO.getUserId());
			hm.put("updator", sessionVO.getUserId());
			hm.put("validStatusId", 1);
			hm.put("validRemark", "");
			hm.put("salesOrdId", 0);
			hm.put("worNo", vo.getWorNo().trim());
			hm.put("amt", vo.getAmount().trim());
			hm.put("payMode", "");
			hm.put("payTypeId", 0);
			hm.put("bankAccId", accNo);
			hm.put("issBankId", 0);
			hm.put("chqNo", vo.getChqNo().trim());
			hm.put("refNo", vo.getRefNo().trim());
			hm.put("ccHolderName", "");
			hm.put("ccNo", "");
			hm.put("refundRemark", vo.getRemark().trim());
			hm.put("refDateMonth", "");
			hm.put("refDateDay", "");
			hm.put("refDateYear", "");
			hm.put("payItemId", 0);

			detailList.add(hm);
		}

		Map<String, Object> master = new HashMap<String, Object>();
		String payMode = request.getParameter("payMode");
		String remark = request.getParameter("remark");

		master.put("refundModeId", payMode);
		master.put("batchStatusId", 1);
		master.put("confirmStatusId", 44);
		master.put("creator", sessionVO.getUserId());
		master.put("updator", sessionVO.getUserId());
		master.put("confirmDate", "1900/01/01");
		master.put("confirmBy", 0);
		master.put("convertDate", "1900/01/01");
		master.put("convertBy", 0);
		master.put("batchRefundType", 97);
		master.put("batchRefundRemark", remark != null ? remark : "");
		master.put("batchRefundCustType", 1368);

		int result = batchRefundService.saveBatchRefundUpload(master, detailList);
		if(result > 0){
    		//File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
    		//multipartFile.transferTo(file);

    		message.setMessage("Batch refund item(s) successfully uploaded.<br />Batch ID : "+result);
    		message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to upload batch refund item(s). Please try again later.");
			message.setCode(AppConstants.FAIL);
		}


		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/batchRefundConfirmPop.do")
	public String batchRefundConfirmPop(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug("params =====================================>>  " + params);

		EgovMap bRefundInfo = batchRefundService.selectBatchRefundInfo(params);

		model.addAttribute("bRefundInfo", bRefundInfo);
		model.addAttribute("bRefundItem", new Gson().toJson(bRefundInfo.get("bRefundItem")));
		return "payment/refund/batchRefundConfirmPop";
	}

	@RequestMapping(value = "/batchRefundDeactivate.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> batchRefundDeactivate(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		Map<String, Object> master = new HashMap<String, Object>();
		String batchId = (String) params.get("batchId");

		master.put("batchId", batchId);
		master.put("refundModeId", 0);
		master.put("batchStatusId", 8);
		master.put("confirmStatusId", 8);
		master.put("creator", 0);
		master.put("created", "1900/01/01");
		master.put("updator", sessionVO.getUserId());
		master.put("confirmDate", "1900/01/01");
		master.put("confirmBy", 0);
		master.put("convertDate", "1900/01/01");
		master.put("convertBy", 0);

		int result = batchRefundService.batchRefundDeactivate(master);
		if(result > 0){
    		//File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
    		//multipartFile.transferTo(file);

    		message.setMessage("Batch refund has been deactivated.");
    		message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to deactivate this batch refund. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}


		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/batchRefundConfirm.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> batchRefundConfirm(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		Map<String, Object> master = new HashMap<String, Object>();
		String batchId = (String) params.get("batchId");

		master.put("batchId", batchId);
		master.put("refundModeId", 0);
		master.put("batchStatusId", 1);
		master.put("confirmStatusId", 77);
		master.put("creator", 0);
		master.put("created", "1900/01/01");
		master.put("updator", sessionVO.getUserId());
		master.put("confirmBy", sessionVO.getUserId());
		master.put("convertDate", "1900/01/01");
		master.put("convertBy", 0);

		master.put("userId", sessionVO.getUserId());

		int result = batchRefundService.batchRefundConfirm(master, true);
		if(result > 0){
    		message.setMessage("Batch refund has been confirmed.");
    		message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to confirm this batch refund. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}


		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/batchRefundItemDisab.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> batchRefundItemDisab(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		Map<String, Object> master = new HashMap<String, Object>();
		String detId = (String) params.get("detId");

		master.put("detId", detId);
		master.put("disabled", 1);
		master.put("updator", sessionVO.getUserId());

		int result = batchRefundService.batchRefundItemDisab(master);
		if(result > 0){
    		//File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
    		//multipartFile.transferTo(file);

			EgovMap bRefundInfo = batchRefundService.selectBatchRefundInfo(params);

    		message.setMessage("Refund item has been removed.");
    		message.setData(bRefundInfo);
    		message.setCode(AppConstants.SUCCESS);
		}else{
			message.setMessage("Failed to remove refund item. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}


		return ResponseEntity.ok(message);
	}


}
