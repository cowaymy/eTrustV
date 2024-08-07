package com.coway.trust.web.payment.billing.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.payment.billing.service.BillingMgmtService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.common.excel.download.ExcelDownloadFormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BillingMgmtController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BillingMgmtController.class);
	
	@Resource(name = "billingRentalService")
	private BillingMgmtService billingRentalService;
	
	@Autowired
	private LargeExcelService largeExcelService;
	
	/**
	 * BillingMgnt 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingMgmt.do")
	public String initBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/billingMgmt";
	}
	
	@RequestMapping(value = "/selectBillingMgmtList.do")
	public ResponseEntity<List<EgovMap>> selectBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {	
		List<EgovMap> list = null;
		
		LOGGER.debug("params : {}", params);
		
		if( params.get("year") != null && !("".equals(String.valueOf(params.get("year")))) && params.get("month") != null && !("".equals(String.valueOf(params.get("month")))) ){
			list = billingRentalService.selectBillingMgnt(params);
		}
		return ResponseEntity.ok(list);
	}
		
	/**
	 * Billing Result 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingResult.do")
	public String initBillingResult(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("taskId", String.valueOf(params.get("taskId")));
		return "payment/billing/billingResult";
	}
	
	/**
	 * Billing Result 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingResultPop.do")
	public String initBillingResultPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("taskId", String.valueOf(params.get("taskId")));
		return "payment/billing/billingResultPop";
	}
	
		
	@RequestMapping(value = "/selectBillingResultList.do")
	public ResponseEntity<Map<String, Object>> selectBillingResult(@RequestParam Map<String, Object> params, ModelMap model) {	
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		EgovMap master = billingRentalService.selectBillingMaster(params);		
		List<EgovMap> detail = billingRentalService.selectBillingDetail(params);
		int totalRowCount = billingRentalService.selectBillingDetailCount(params);
		
		result.put("master", master);
		result.put("detail", detail);
		result.put("totalRowCount", totalRowCount);

		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/selectBillingResultListPaging.do")
	public ResponseEntity<Map<String, Object>> selectBillingResultListPaging(@RequestParam Map<String, Object> params, ModelMap model) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		List<EgovMap> detail = billingRentalService.selectBillingDetail(params);		
		result.put("detail", detail);		

		return ResponseEntity.ok(result);
	}
	
	/**
	 * MonthlyRawDatat초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initMonthlyRawData.do")
	public String initMonthlyRawData(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/monthlyBillRawData";
	}
	
	/**
	 * MonthlyRawDatat 카운트 조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/countMonthlyRawData.do")
	public ResponseEntity<Integer> countMonthlyRawData(@RequestParam Map<String, Object> params, ModelMap model) {
		
		int cnt = billingRentalService.countMonthlyRawData(params);
		return ResponseEntity.ok(cnt);
	}	
	
	

	@RequestMapping(value = "/selectMonthlyRawDataExcelList.do")
	public void selectAdjustmentExcelList(HttpServletRequest request, HttpServletResponse response) {
		
		ExcelDownloadHandler downloadHandler = null;
		
		try {
            
            Map<String, Object> map = new HashMap<String, Object>();
    		map.put("year", request.getParameter("year") == null ? "1900" :  request.getParameter("year"));
    		map.put("month", request.getParameter("month") == null ? "01" :  request.getParameter("month"));		
    		
    		String[] columns;
            String[] titles;
			
            columns = new String[] { "accBillRefDt","accBillRefNo","accBillOrdNo","modeNm","accBillSchdulPriod","accBillNetAmt", "accBillTxsAmt"};            
            titles = new String[] {"ACC BILL REF DATE","ACC BILL REFNO","ACC BILL ORDER_NO","MODE NAME","ACC BILL SCHEDUL PERIOD","ACC BILL NET AMOUNT","ACC BILL TXS AMOUNT" };     
	             
			downloadHandler = getExcelDownloadHandler(response, "MonthlyBillRawData.xlsx", columns, titles);			
			largeExcelService.downloadMonthlyBillRawData(map, downloadHandler);
			
		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}
	}
	
	private ExcelDownloadHandler getExcelDownloadHandler(HttpServletResponse response, String fileName,
			String[] columns, String[] titles) {
		ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(fileName, columns, titles);
		return new ExcelDownloadHandler(excelDownloadVO, response);
	}
	
	
	
	@RequestMapping(value = "/createBills.do")
	public ResponseEntity<ReturnMessage> createBills(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
		
		LOGGER.debug("params_#### : {}", params);
		
		String message = "";
		
		ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		int year = Integer.parseInt(String.valueOf(params.get("year")));
		int month = Integer.parseInt(String.valueOf(params.get("month")));
		int userId = sessionVO.getUserId();
		
		Calendar curDate = Calendar.getInstance();
		int curYear = curDate.get(curDate.YEAR);
		int curMonth = curDate.get(curDate.MONTH) + 1;
		
		map.put("year", year);
		map.put("month", month);
		map.put("userId", userId);
		
		
		//System.out.println("today : " + curDate + ", curYear : " + curYear + ", curMonth : " + curMonth);
		int result = 0;
		if(curYear < year){
			billingRentalService.callEaryBillProcedure(map);
			result = Integer.parseInt(String.valueOf(map.get("p1")));
		}else if(curYear == year){
			if(curMonth < month){
				billingRentalService.callEaryBillProcedure(map);
				result = Integer.parseInt(String.valueOf(map.get("p1")));
			}else{
				billingRentalService.callBillProcedure(map);
				result = Integer.parseInt(String.valueOf(map.get("p1")));
			}
		}
		
		System.out.println("result : " + result);
		if(result < 1){
			message="Stopped With Errors.";
		}else{
			message = "Billing Task Completed Successfully.";
		}
		msg.setMessage(message);
		return ResponseEntity.ok(msg);
	}
	
	@RequestMapping(value = "/getExistBill.do")
	public ResponseEntity<Integer> getExistBill(@RequestParam Map<String, Object> params, ModelMap model) {	
		int value= 0;
		
		LOGGER.debug("params : {}", params);
		
		value = billingRentalService.getExistBill(params);
		
		return ResponseEntity.ok(value);
	}
	
	@RequestMapping(value = "/confirmAlltBill.do")
	public ResponseEntity<Integer> confirmAllBills(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {	
		int value= -1;
		
		params.put("userId", sessionVO.getUserId());
		LOGGER.debug("params : {}", params);
		
		if(String.valueOf(params.get("type")).equals("EARLY BILL")){
			billingRentalService.confirmEarlyBills(params);
			value=Integer.parseInt(String.valueOf(params.get("p1")));
		}else{
			billingRentalService.confirmBills(params);
			value=Integer.parseInt(String.valueOf(params.get("p1")));
		}
		
		System.out.println("######value : " + value);
		
		return ResponseEntity.ok(value);
	}
}
