package com.coway.trust.web.payment.otherpayment.controller;

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
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.payment.otherpayment.service.OtherPaymentService;
import com.coway.trust.biz.payment.payment.service.CommDeductionService;
import com.coway.trust.biz.payment.payment.service.CommDeductionVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.text.SimpleDateFormat;
import com.coway.trust.biz.sales.common.SalesCommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class OtherPaymentController {

	private static final Logger LOGGER = LoggerFactory.getLogger(OtherPaymentController.class);

	@Resource(name = "otherPaymentService")
	private OtherPaymentService otherPaymentService;

	  @Resource(name = "salesCommonService")
	  private SalesCommonService salesCommonService;




	/******************************************************
	 * Other Payment
	 *****************************************************/
	/**
	 * Other Payment 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initOtherPayment.do")
	public String CommissionDeduction(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		  String currentDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		    model.put("currentDay", currentDay);
			params.put("userTypeId", sessionVO.getUserTypeId());
			params.put("userId", sessionVO.getUserId());
			params.put("memId", sessionVO.getMemId());


		    if( sessionVO.getUserTypeId() == 2 ){
				//if( sessionVO.getUserTypeId() == 1){
		      EgovMap result =  salesCommonService.getUserInfo(params);

		      model.put("orgCode", result.get("orgCode"));
		      model.put("grpCode", result.get("grpCode"));
		      model.put("deptCode", result.get("deptCode"));
		      model.put("memCode", result.get("memCode"));

		       result =  otherPaymentService.getMemVaNo(params);

		       model.put("memVaNo", result.get("memVaNo"));
		    }

		return "payment/otherpayment/otherPayment";
	}

	/**
	 * Other Payment 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectBankStatementList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCommDeduction(@RequestParam Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params : {}", params);
        LOGGER.info("params : {}", params);

        List<EgovMap> resultList = otherPaymentService.selectBankStatementList(params);

        return ResponseEntity.ok(resultList);
     }

//	/**
//	 * Commission Deduction 조회
//	 * @param searchVO
//	 * @param params
//	 * @param model
//	 * @return
//	 */
//	@RequestMapping(value = "/selectCommDeduction.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> selectCommDeduction(@RequestParam Map<String, Object> params, ModelMap model) {
//
//        LOGGER.debug("params : {}", params);
//
//        List<EgovMap> resultList = commDeductionService.selectCommitionDeduction(params);
//
//        return ResponseEntity.ok(resultList);
//        }
//
//	/**
//	 * CSV 파일 저장
//	 * @param searchVO
//	 * @param params
//	 * @param model
//	 * @return
//	 */
//	@RequestMapping(value = "/csvUpload.do", method = RequestMethod.POST)
//	public ResponseEntity<ReturnMessage> csvUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
//		ReturnMessage mes = new ReturnMessage();
//		String message = "";
//
//		if(sessionVO.getUserId() > 0){
//    		Map<String, MultipartFile> fileMap = request.getFileMap();
//    		MultipartFile multipartFile = fileMap.get("csvFile");
//
//    		List<CommDeductionVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CommDeductionVO::create);
//
//    		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
//    		for (CommDeductionVO vo : vos) {
//    			LOGGER.debug("getOrderNo : {}, getmCode : {}, getAmount : {}, getPaidMonth : {} ", vo.getOrderNo(), vo.getmCode(), vo.getAmount(), vo.getPaidMonth());
//    			HashMap<String, Object> hm = new HashMap<String, Object>();
//    			hm.put("itemId", 0);
//    			hm.put("fileId", 0);
//    			hm.put("orderNo", vo.getOrderNo());
//    			hm.put("memberCode", vo.getmCode());
//    			hm.put("amount", vo.getAmount());
//    			hm.put("syncCompleted", false);
//    			hm.put("paidMonth", vo.getPaidMonth());
//    			list.add(hm);
//    		}
//
//    		Calendar oCalendar = Calendar.getInstance( );
//    		Date curdate = new Date();
//    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
//    		String today = sdf.format(curdate);
//
//    		int yyyy = oCalendar.get(oCalendar.YEAR);
//    		String yy = String.valueOf(yyyy).substring(2, 3);
//    		int mm = oCalendar.get(oCalendar.MONTH) + 1;
//    		int dd = oCalendar.get(oCalendar.DATE);
//
//    		Map<String, Object> m = new HashMap<String, Object>();
//
//    		m.put("fileName", multipartFile.getOriginalFilename());
//    		m.put("fileDate", today);
//    		m.put("fileRefNo", "COM" + yy + mm + dd);
//    		m.put("totalRecords", list.size());
//    		m.put("totalAmount", sumAmount(vos));
//    		m.put("fileStatus", 1);
//
//    		System.out.println("master : " + m);
//
//    		int result = this.commDeductionService.addBulkData(m, list);
//    		if(result > 0){
//        		File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
//        		multipartFile.transferTo(file);
//
//        		message = "Saved Successfully";
//    		}else{
//    			message = "Failed to save : Only one upload is allowed a day";
//    		}
//		}else{
//			message = "Your login session has expired. Please relogin to our system.";
//		}
//		mes.setCode(AppConstants.SUCCESS);
//    	mes.setMessage(message);
//
//		return ResponseEntity.ok(mes);
//	}
//
//	private int sumAmount(List<CommDeductionVO> list){
//		int sum = 0;
//		for(int i=0; i<list.size(); i++)
//			sum += list.get(i).getAmount();
//		return sum;
//	}
//
//	/**
//	 * PaymentResult 조회
//	 * @param params
//	 * @param model
//	 * @return
//	 */
//	@RequestMapping(value = "/loadPaymentResult.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> loadPaymentResult(@RequestParam Map<String, Object> params, ModelMap model) {
//
//        LOGGER.debug("params : {}", params);
//
//        List<EgovMap> logList = commDeductionService.selectCommitionDeduction(params);
//        System.out.println(logList.get(0));
//
//        List<EgovMap> resultList = commDeductionService.selectMasterView(logList.get(0));
//        for(int i=0; i<resultList.size(); i++){
//        	System.out.println(resultList.get(i));
//        }
//
//        return ResponseEntity.ok(resultList);
//	}
//
//	/**
//	 * RawItemsStatus 조회
//	 * @param params
//	 * @param model
//	 * @return
//	 */
//	@RequestMapping(value = "/loadRawItemsStatus.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> loadRawItemsStatus(@RequestParam Map<String, Object> params, ModelMap model) {
//
//        LOGGER.debug("params : {}", params);
//
//        List<EgovMap> logList = commDeductionService.selectLogDetail(params);
//
//        return ResponseEntity.ok(logList);
//	}
//
//	/**
//	 * PaymentResult에 대한 Detail 조회
//	 * @param params
//	 * @param model
//	 * @return
//	 */
//	@RequestMapping(value = "/selectDetailForPaymentResult.do", method = RequestMethod.GET)
//	public ResponseEntity<EgovMap> selectDetailForPaymentResult(@RequestParam Map<String, Object> params, ModelMap model) {
//
//        LOGGER.debug("params : {}", params);
//
//        List<EgovMap> list = commDeductionService.selectDetailForPaymentResult(params);
//
//        return ResponseEntity.ok(list.get(0));
//	}
//
//
//	/**
//	 * PaymentResult에 대한 Detail 조회
//	 * @param params
//	 * @param model
//	 * @return
//	 */
//	@RequestMapping(value = "/createPayment.do", method = RequestMethod.GET)
//	public ResponseEntity<ReturnMessage> createPayment(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
//		ReturnMessage mes = new ReturnMessage();
//		String message = "";
//        LOGGER.debug("params : {}", params);
//        int userId = sessionVO.getUserId();
//
//        if(userId > 0){
//        	EgovMap master = commDeductionService.selectCommitionDeduction(params).get(0);
//        	if("1".equals(String.valueOf(master.get("fileStus")))){
//        		master.put("userId", userId);
//        		commDeductionService.createPaymentProcedure(master);
//        		String reValue = String.valueOf(master.get("p1"));
//        		if(reValue.equals("1")){
//        			message = "Payment Items Created Successfully.";
//        		}else{
//        			message = "Failed to save.  Please try again later.";
//        		}
//        	}else{
//        		message = "Already Completed.";
//        	}
//        }else{
//        	message = "Your login session has expired. Please relogin to our system.";
//        }
//
//        mes.setCode(AppConstants.SUCCESS);
//    	mes.setMessage(message);
//
//    	return ResponseEntity.ok(mes);
//	}

    // 2018-06-07 - LaiKW - Pop up for Bank Statement Unknown Report - Start
    @RequestMapping(value = "/initGenUnknownReport.do")
    public String initGenUnknownReport(@RequestParam Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params : {}", params);
        model.put("PAY_MODE", (String) params.get("payMode"));

        return "payment/otherpayment/genUnknownReportPop";
    }
    // 2018-06-07 - LaiKW - Pop up for Bank Statement Unknown Report - End

}
