package com.coway.trust.web.payment.billing.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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
import com.coway.trust.biz.payment.billing.service.AdvBillingBatchService;
import com.coway.trust.biz.payment.billing.service.AdvBillingBatchVO;
import com.coway.trust.biz.payment.payment.service.CommDeductionService;
import com.coway.trust.biz.payment.payment.service.CommDeductionVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class AdvBillingBatchController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdvBillingBatchController.class);
	
	@Resource(name = "advBillingBatchService")
	private AdvBillingBatchService advBillingBatchService;
	
	@Autowired
	private CsvReadComponent csvReadComponent;
	
	
	/******************************************************
	 * Commission Deduction  
	 *****************************************************/	
	/**
	 * Advanced Billing Batch초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdvBillingBatch.do")
	public String CommissionDeduction(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/advancedBillingBatch";
	}
	
	/**
	 * Advanced Billing Batch 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectBillingBatch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCommDeduction(@RequestParam Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params : {}", params);
        
        List<EgovMap> resultList = advBillingBatchService.selectBillingBatch(params);

        for(EgovMap em : resultList){
        	System.out.println("em : " + em);
        }
        return ResponseEntity.ok(resultList);
        }
	
	/**
	 * CSV 파일 저장
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/batchCsvUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
		int userId = sessionVO.getUserId();
		
		ReturnMessage mes = new ReturnMessage();
		String message = "";
		System.out.println("file : " + request.getFileMap());
		
		if(userId > 0){
    		Map<String, MultipartFile> fileMap = request.getFileMap();
    		MultipartFile multipartFile = fileMap.get("csvFile");
    		String remark = request.getParameter("remark");
    		if(fileMap != null){
    			Map<String, Object> advbillbatchM = new HashMap<String, Object>();
    			List<Map<String, Object>> advbillbatchD = new ArrayList<Map<String, Object>>();
    			
    			advbillbatchM = this.getSaveDataAccAdvanceBillBatch(userId, remark);
    			List<AdvBillingBatchVO> tmp = csvReadComponent.readCsvToList(multipartFile, true, AdvBillingBatchVO::create);
    			advbillbatchD = this.getSaveDataAccAdvanceBillBatchSub(userId, tmp);
    			
    			String strTmp = this.validRequiredFieldDetail(advbillbatchD);
    			
    			if(strTmp.equals("")){
    				
    				if(advBillingBatchService.doSaveBatchAdvBilling(advbillbatchM, advbillbatchD)){
    					System.out.println("path : " + advbillbatchM.get("advBillBatchUrl"));
    					
    					File file = new File(String.valueOf(advbillbatchM.get("advBillBatchUrl")));
    					multipartFile.transferTo(file);
    					
    					message = "Batch advance billing successfully saved.";
    				}else{
    					message = "Failed to save. Please try again later.";
    				}
    			}else{
    				message = strTmp;
    			}
    		}else{
    			message = "* Please select your csv file.";
    		}
		}
		
		mes.setCode(AppConstants.SUCCESS);
    	mes.setMessage(message);
		
		return ResponseEntity.ok(mes);
	}
	
	private String validRequiredFieldDetail(List<Map<String, Object>> list){
		boolean valid = true;
		int countError = 0;
		String message = "";
		
		for(Map<String, Object> map : list){
			boolean re = advBillingBatchService.isCheckOrderNoIsExistAndRentalType(String.valueOf(map.get("accBatchItemOrderNo")));
			if (!re){
				countError += 1;
				continue;
			}
		}
		
		if(countError > 0){
			valid = false;
			message = "* "+countError+ " orders not in rental type or invalid orders no.<br /> Please reupload again. <br />";
		}
		
		return message;
	}
	
	private Map<String, Object> getSaveDataAccAdvanceBillBatch(int userId, String remark){
		Map<String, Object> advbillbatchM = new HashMap<String, Object>();
		
		Date curdate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyyhhmm");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		
		String fileName = userId + "_" + sdf.format(curdate)+ "_AdvanceBillBatch.csv";
		String path = "C:\\works\\workspace\\etrust\\src\\main\\webapp\\resources\\WebShare\\payment\\billing\\BatchRentalBill\\";
		
		advbillbatchM.put("advBillBatchUrl", path + fileName);
		advbillbatchM.put("advBillBatchRefNo", "");
		advbillbatchM.put("advBillBatchRemark", remark);
		advbillbatchM.put("advBillBatchTotal", 0);
		advbillbatchM.put("advBillBatchStatusId", 1);
		advbillbatchM.put("advBillBatchCreated", sdf2.format(curdate));
		advbillbatchM.put("advBillBatchUpdated", sdf2.format(curdate));
		advbillbatchM.put("advBillBatchCreator", userId);
		advbillbatchM.put("advBillBatchUpdator", userId);
		advbillbatchM.put("advBillBatchTotalDiscount", 0);
		
		return advbillbatchM;
	}
	
	private List<Map<String, Object>> getSaveDataAccAdvanceBillBatchSub(int userId, List<AdvBillingBatchVO> list){
		List<Map<String, Object>> advbillbatchList = new ArrayList<Map<String, Object>>();
		Date curdate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		
		for(AdvBillingBatchVO abb : list){
			Map<String, Object> det = new HashMap<String, Object>();
			
			det.put("accBatchItemId", 0);
			det.put("accBillBatchId", 0);
			det.put("accBatchItemOrderNo", abb.getOrderNo());
			det.put("accBatchItemOrderId", 0);
			det.put("accBatchItemBillStart", abb.getTaxInvoiceFr());
			det.put("accBatchItemBillEnd", abb.getTaxInvoiceTo());
			det.put("accBatchItemBillAmount", 0);
			det.put("accBatchItemBillDiscount", abb.getDiscount());
			det.put("accBatchItemStatus", 1);
			det.put("accBatchItemRemark", "");
			det.put("accBatchItemUpdated", sdf.format(curdate));
			det.put("accBatchItemUpdator", userId);
			
			advbillbatchList.add(det);
		}
		
		return advbillbatchList;
	}
	
	/**
	 * Advanced Billing Batch 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectBatchMasterInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectBatchMasterInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		Map<String, Object> result = new HashMap<String, Object>();
        LOGGER.debug("params : {}", params);
        
        EgovMap master = advBillingBatchService.selectBatchMasterInfo(params);
        List<EgovMap> detail = advBillingBatchService.selectBatchDetailInfo(params);
        
        master.put("totalItem", detail.size());
        int total = 0;
        int fail = 0;
        for(EgovMap em : detail){
        	if(Integer.parseInt(String.valueOf(em.get("accBatchItmStus"))) == 4)
        		total++;
        	else if(Integer.parseInt(String.valueOf(em.get("accBatchItmStus"))) == 21)
        		fail++;
        }
        master.put("totalSuccess", total);
        master.put("totalFail", fail);
        
        result.put("master", master);
        result.put("detail", detail);
        return ResponseEntity.ok(result);
        }
	
	/**
	 * Status에 따른 Advanced Billing Batch 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectBatchDetailByStatus.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBatchDetailByStatus(@RequestParam Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params : {}", params);

        String statusId = String.valueOf(params.get("statusId"));
        if(Integer.parseInt(statusId) < 1)
        	params.put("statusId", "");
        
        List<EgovMap> result = advBillingBatchService.selectBatchDetailInfo(params);
        
        return ResponseEntity.ok(result);

        }
	
	/**
	 * doDeactivate
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/doDeactivateAdvanceBillBatach.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> doDeactivateAdvanceBillBatach(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		int userId = sessionVO.getUserId();
		
		Date curdate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		
		params.put("userId", userId);
		params.put("today", sdf.format(curdate));
        LOGGER.debug("params : {}", params);
        
        ReturnMessage mes = new ReturnMessage();
		String message = "";
		
		if(userId > 0){
			if(advBillingBatchService.doDeactivateAdvanceBillBatach(params)){
				message = "This conversion batch has been deactivated.";
			}else{
				message = "Failed to deactivate this conversion batch.";
			}
		}else{
			message = "Your login session was expired. Please relogin to our system.";
		}
        mes.setCode(AppConstants.SUCCESS);
    	mes.setMessage(message);
    	
        return ResponseEntity.ok(mes);
	}
	
	/**
	 * updBillBatchUpload
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updBillBatchUpload.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updBillBatchUpload(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        
        ReturnMessage mes = new ReturnMessage();
		String message = "";
		
		boolean resultMes = advBillingBatchService.updBillBatchUpload(params);
		
		if(resultMes){
			message = "<b>This conversion batch has been approved.</b>";
		}else{
			message = "<b>Failed to approve this conversion batch.<br />Please try again later.</b>";
		}
        mes.setCode(AppConstants.SUCCESS);
    	mes.setMessage(message);
    	
        return ResponseEntity.ok(mes);
	}
}
