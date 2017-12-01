package com.coway.trust.web.payment.payment.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
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
import com.coway.trust.biz.payment.payment.service.BatchPaymentOutService;
import com.coway.trust.biz.payment.payment.service.BatchPaymentOutVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;

@Controller
@RequestMapping(value = "/payment")
public class BatchPaymentOutController {
	
	private static final Logger logger = LoggerFactory.getLogger(BatchPaymentController.class);
	
	@Resource(name = "batchPaymentOutService")
	private BatchPaymentOutService batchPaymentOutService;
	
	@Autowired
	private CsvReadComponent csvReadComponent;

	/******************************************************
	 *  Batch Payment List(Internal Staff) 
	 *****************************************************/	
	/**
	 *  Batch Payment List(Internal Staff) 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBatchPaymentList_internalStaff.do")
	public String initDailyCollection(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/payment/batchPaymentList_internalStaff";
	}
	
	/**
	 * CSV 파일 저장
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/csvOutrightFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvFileUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
		ReturnMessage message = new ReturnMessage();
		
		Calendar oCalendar = Calendar.getInstance( );
		int year = oCalendar.get(oCalendar.YEAR);
		int month = oCalendar.get(oCalendar.MONTH) + 1;
		int day = oCalendar.get(oCalendar.DATE);
		
		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<BatchPaymentOutVO> vos = csvReadComponent.readCsvToList(multipartFile, true, BatchPaymentOutVO::create);
		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
		
		if(vos.size() > 300){
			message.setMessage("Cannot more then 300 transaction in single file");
		}else{
			
			for (BatchPaymentOutVO vo : vos) {
				//Detail setting
				HashMap<String, Object> hm = new HashMap<String, Object>();
				
				hm.put("disabled", 0);
				hm.put("creator", sessionVO.getUserId());
				hm.put("updator", sessionVO.getUserId());
				hm.put("validStatusId", 1);
				hm.put("validRemark", "");
				hm.put("userOrderNo", vo.getOrderNo().trim());
				hm.put("userTrNo", "");
				hm.put("userRefNo", "");
				hm.put("userAmount", vo.getAmount().trim());
				hm.put("userBankAcc", "2210/001");
				hm.put("userChqNo", "");
				hm.put("userIssueBank", "");
				hm.put("userRunningNo", "");
				hm.put("userEftNo", "");
				hm.put("userRefDate_Month", month);
				hm.put("userRefDate_Day", day);
				hm.put("userRefDate_Year", year);
				hm.put("userBankChargeAmt", "");
				hm.put("userBankChargeAcc", "");
				hm.put("sysOrderId", 0);
				hm.put("sysAppTypeId", 0);
				hm.put("sysAmount", 0);
				hm.put("sysBankAccId", 0);
				hm.put("sysIssBankId", 0);
				hm.put("sysRefDate", "1900/01/01");
				hm.put("sysBCAmt", 0);
				hm.put("sysBCAccId", 0);
				hm.put("paymentType", "OUT");
				hm.put("PaymentTypeId", 165);
				hm.put("userTrDate", "1900/01/01");
				hm.put("userCollectorCode", "");
				hm.put("sysCollectorId", 0);
				hm.put("advanceMonth", 0);
				
				//Ben - 2016-10-17 - Batach Payment Enhancement
				/*if(!vo.getPaymentType().trim().equals("")){
					hm.put("paymentType", vo.getPaymentType().trim());
				}else{
					hm.put("paymentType", "");
				}
				
				hm.put("PaymentTypeId", 0);
				if(!vo.getAdvanceMonth().trim().equals("")){
					hm.put("advanceMonth", vo.getAdvanceMonth().trim());
				}else{
					hm.put("advanceMonth", 0);
				}*/
				
				detailList.add(hm);
			}
			
			//Master setting
			Map<String, Object> master = new HashMap<String, Object>();
			String payModeId = request.getParameter("payModeId");
			
			master.put("payModeId", payModeId);
			master.put("batchStatusId", 1);
			master.put("confirmStatusId", 44);
			master.put("creator", sessionVO.getUserId());
			master.put("updator", sessionVO.getUserId());
			master.put("confirmDate", "1900/01/01");
			master.put("confirmBy", 0);
			master.put("convertDate", "1900/01/01");
			master.put("convertBy", 0);
			master.put("paymentType", 96);
			master.put("paymentRemark", "SALARY CONTRA ON OUTRIGHT");
			master.put("paymentCustType", 1369);
			
			int result = batchPaymentOutService.saveBatchPaymentOutUpload(master, detailList);
			if(result > 0){
	    		//File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
	    		//multipartFile.transferTo(file);
	    		
	    		message.setMessage("Batch payment item(s) successfully uploaded.<br />Batch ID : "+result);
			}else{
				message.setMessage("Failed to upload batch payment item(s). Please try again later.");
			}
		}

		return ResponseEntity.ok(message);
	}
	
}
