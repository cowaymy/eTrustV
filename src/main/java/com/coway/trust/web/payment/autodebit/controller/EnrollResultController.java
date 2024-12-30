package com.coway.trust.web.payment.autodebit.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.autodebit.service.CsvFormatVO;
import com.coway.trust.biz.payment.autodebit.service.EnrollResultService;
import com.coway.trust.biz.payment.autodebit.service.EnrollmentUpdateDVO;
import com.coway.trust.biz.payment.autodebit.service.EnrollmentUpdateMVO;
import com.coway.trust.biz.payment.eMandate.service.DdCsvFormatVO;
import com.coway.trust.biz.payment.eMandate.service.EMandateEnrollmentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class EnrollResultController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EnrollResultController.class);

	@Resource(name = "enrollResultService")
	private EnrollResultService enrollResultService;

	@Resource(name = "eMandateEnrollmentService")
	private EMandateEnrollmentService eMandateService;

	/******************************************************
	 * enrollmentResultList
	 *****************************************************//*
	*//**
	 * enrollmentResultList초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initEnrollmentResultList.do")
	public String initEnrollmentResultList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/enrollmentResultList";
	}

	/**
	 * EnrollResult조회
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectResultList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSalesList(
				 @RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);

        List<EgovMap> resultList = enrollResultService.selectEnrollmentResultrList(params);

        return ResponseEntity.ok(resultList);
	}

	/**
	 * EnrollResultNew업로드
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> uploadFile(
			@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		String message = "";

		LOGGER.debug("DD-UPLOAD: " + params.toString());

		// 결과 만들기.
    	ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
    	msg.setMessage(message );

    	int userId = sessionVO.getUserId();

		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    	List<Object> typeList = params.get("type");
    	String type = "";

    	if (typeList != null && !typeList.isEmpty()) {
    		type = typeList.get(0) == null ? "" : typeList.get(0).toString();
    	}

    	if (type.equalsIgnoreCase("DD")){
    		LOGGER.debug("DD-TYPE: " + type);

    		Map<String, Object> formInfo = new HashMap<String, Object> ();
        	if(formList.size() > 0){
        		for(Object obj : formList){
        			Map<String, Object> map = (Map<String, Object>) obj;
        			formInfo.put((String)map.get("name"), map.get("value"));
        		}

        		if(userId > 0)
        		{
        			List<DdCsvFormatVO> csvList = new ArrayList();
        			if(gridList.size() > 0){
        				for(int i=0; i<gridList.size(); i++){
                    		Map<String, Object> map = (Map<String, Object>) gridList.get(i);

                    		//첫번째 값이 없으면 skip
            				if(map.get("0") == null || String.valueOf(map.get("0")).equals("") || String.valueOf(map.get("0")).trim().length() < 1 ){
            					continue;
            				}

            				try{
            					// DD paperless upload
                        			csvList.add(new DdCsvFormatVO(
                    	    				map.get("0").toString(), // payment ID
                    	    				map.get("1").toString(), // Type
                    	    				map.get("2").toString(), // Account No
                    	    				map.get("3").toString(), // Account Type
                    	    				map.get("4").toString(), // Account Holder
                    	    				map.get("5").toString(), // Issue Bank
                    	    				CommonUtils.nvl(map.get("6").toString()), // Start Date
                    	    				CommonUtils.nvl(map.get("7").toString()), // Reject Date
                    	    				CommonUtils.nvl(map.get("8").toString()), // Reject Code
                    	    				CommonUtils.nvl(map.get("9").toString()))); // Status

                        		} catch(Exception e){
                        			message = "Failed to read CSV. Please ensure all the data in your CSV are correct before upload.";
                        			msg.setMessage(message );
                        			e.printStackTrace();
                        			return ResponseEntity.ok(msg);
                        		}
                    		} // for...

            				List<EnrollmentUpdateDVO> enrollDList = null;

            				try{
            					 enrollDList = bindDDEnrollItemList(csvList, userId);
            				} catch (Exception e){
            					message = "Failed to convert CSV. Please ensure all the data in your CSV are correct before upload.";
                    			msg.setMessage(message );
                    			e.printStackTrace();
                    			return ResponseEntity.ok(msg);
            				}

            				if(formInfo.get("updateType").toString() != null && !formInfo.get("updateType").toString().equals("")){
                        		if(enrollDList != null && enrollDList.size() > 0){
                        			EnrollmentUpdateMVO enrollMaster = getEnrollMaster(enrollDList, formInfo, userId);
                        			if(enrollMaster != null){
                            			List<EgovMap> result = enrollResultService.saveNewEnrollment(enrollMaster, enrollDList, Integer.parseInt(formInfo.get("updateType").toString()), type);

                            			if(result.size() > 0){
                                			message = "DD Enrollment information successfully updated.<br>";
                                			message += "Update Batch ID : " + result.get(0).get("enrlUpdId") + "<br>";
                                			message += "Total Update : " + result.get(0).get("totUpDt") + "<br>";
                                			message += "Total Success : " + result.get(0).get("totSucces")+ "<br>";
                                			message += "Total Failed : " + result.get(0).get("totFail")+ "";
                                		}

                        			} else{
                        				message = "Failed to update enrollment result.\n Please try again later.\n";
                        			}
                        		}else{
                        			message = "You must select your CSV file.\n";
                        		}

            				}else{
                        		message =  "You must select the update type.\n";
            				}

        				} else{ // if(gridList.size() <= 0)
                    		message = "No item found in your CSV.\nEnrollment update is unnecessary.";
                    	}

        			} else{ // if(userId <= 0)
            			message = "Your login session was expired. Please relogin to our system.\n";
            		}
        		} // if(formList.size() > 0)

    	} else { // Non DD enrollment result upload
        	Map<String, Object> formInfo = new HashMap<String, Object> ();
        	if(formList.size() > 0){
        		for(Object obj : formList){
        			Map<String, Object> map = (Map<String, Object>) obj;
        			formInfo.put((String)map.get("name"), map.get("value"));
        		}

        		if(userId > 0)
        		{
        			List<CsvFormatVO> csvList = new ArrayList();

        			if(gridList.size() > 0){
        				for(int i=0; i<gridList.size(); i++){
                    		Map<String, Object> map = (Map<String, Object>) gridList.get(i);

                    		//첫번째 값이 없으면 skip
            				if(map.get("0") == null || String.valueOf(map.get("0")).equals("") || String.valueOf(map.get("0")).trim().length() < 1 ){
            					continue;
            				}

                    		try{
                        		if(CommonUtils.isNumCheck(map.get("1").toString()) &&
                        				CommonUtils.isNumCheck(map.get("2").toString())&&
                        				CommonUtils.isNumCheck(map.get("3").toString())){

                        			csvList.add(new CsvFormatVO(
                    	    				map.get("0").toString(),
                    	    				Integer.parseInt(map.get("1").toString()),
                    	    				Integer.parseInt(map.get("2").toString()),
                    	    				Integer.parseInt(map.get("3").toString()),
                    	    				map.get("4").toString()));
                        		}
                        		else{
                        			message = "Failed to read CSV. Please ensure all the data in your CSV are correct before upload.";
                        			msg.setMessage(message );
                        			return ResponseEntity.ok(msg);
                        		}
                    		}catch(Exception e){
                    			e.printStackTrace();
                    		}
                    	}

        				List<EnrollmentUpdateDVO> enrollDList = bindEnrollItemList(csvList, userId);

        				if(formInfo.get("updateType").toString() != null && !formInfo.get("updateType").toString().equals("")){
                    		if(enrollDList.size() > 0){
                    			EnrollmentUpdateMVO enrollMaster = getEnrollMaster(enrollDList, formInfo, userId);
                    			if(enrollMaster != null){
                        			List<EgovMap> result = enrollResultService.saveNewEnrollment(enrollMaster, enrollDList, Integer.parseInt(formInfo.get("updateType").toString()));

                        			if(result.size() > 0){
                            			message = "Enrollment information successfully updated.<br>";
                            			message += "Update Batch ID : " + result.get(0).get("enrlUpdId") + "<br>";
                            			message += "Total Update : " + result.get(0).get("totUpDt") + "<br>";
                            			message += "Total Success : " + result.get(0).get("totSucces")+ "<br>";
                            			message += "Total Failed : " + result.get(0).get("totFail")+ "";
                            		}

                    			} else{
                    				message = "Failed to update enrollment result.\n Please try again later.\n";
                    			}
                    		}else{
                    			message = "You must select your CSV file.\n";
                    		}

        				}else{
                    		message =  "You must select the update type.\n";
        				}
        			}else{
                		message = "No item found in your CSV.\nEnrollment update is unnecessary.";
                	}

        		}else{
        			message = "Your login session was expired. Please relogin to our system.\n";

        		}
        	}
    	}

    	msg.setMessage(message);
        return ResponseEntity.ok(msg);
	}

	/**
	 * EnrollResultView
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectEnrollmentInfo", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectEnrollmentInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		int enrollment = Integer.parseInt(params.get("enrollId").toString());
		Map<String, Object> map = new HashMap<String, Object>();
		map = enrollResultService.selectEnrollmentInfo(enrollment);

        return ResponseEntity.ok(map);
	}

	private EnrollmentUpdateMVO getEnrollMaster(List<EnrollmentUpdateDVO> enrollDList, Map<String, Object> formInfo, int userId){
		EnrollmentUpdateMVO enrollMaster = new EnrollmentUpdateMVO();

		enrollMaster.setEnrollUpdateId(0);
		enrollMaster.setTypeId(Integer.parseInt(formInfo.get("updateType").toString()));
        enrollMaster.setCreated(CommonUtils.getNowDate() + CommonUtils.getNowTime());
        enrollMaster.setCreator(userId);
        enrollMaster.setTotalUpdate(enrollDList.size());
        enrollMaster.setTotalSuccess(0);
        enrollMaster.setTotalFail(0);

		return enrollMaster;
	}

	private List<EnrollmentUpdateDVO> bindEnrollItemList(List<CsvFormatVO> csvList, int userId){
		List<EnrollmentUpdateDVO> list = new ArrayList();
		long diffDays = CommonUtils.getDiffDate("20160701");
		if(csvList.size() > 0){
   		for(CsvFormatVO csv : csvList){
    			String contractNOrderNo = csv.getOrderNo();
    			String svmContractNo = "";
    			String orderNo = "";
    			//String paymentId = "";

    			if (contractNOrderNo.length() > 7)
    			{
    				for (int i = 0; i < 7; i++)
                    {
                        svmContractNo += contractNOrderNo.charAt(i);
                    }
        			if (contractNOrderNo.length() < 7 && diffDays >= 0){
        				 for (int i = 7; i < 14; i++)
                         {
                             orderNo += contractNOrderNo.charAt(i);
                         }
        			}else
                    {
                        for (int i = 8; i < 14; i++)
                        {
                            orderNo += contractNOrderNo.charAt(i);
                        }
                    }

    			}else{
    				 if (contractNOrderNo.length() < 7 && diffDays >= 0)
                     {
                         orderNo = "0" + contractNOrderNo;
                     } else
                     {
                         orderNo = contractNOrderNo;
                     }
    			}

    			EnrollmentUpdateDVO enroll = new EnrollmentUpdateDVO();
    			enroll.setEnrollUpdateDetId(0);
    			enroll.setEnrollUpdateId(0);
    			enroll.setStatusCodeId(1);
    			enroll.setOrderNo(orderNo.trim());
    			enroll.setSalesOrderId(0);
    			enroll.setAppTypeId(0);
    			enroll.setInputMonth(String.valueOf(csv.getMonth()));
    			enroll.setInputDay(String.valueOf(csv.getDay()));
    			enroll.setInputYear(String.valueOf(csv.getYear()));
    			enroll.setResultDate("01-01-1990");
    			enroll.setCreated(CommonUtils.getNowDate() + CommonUtils.getNowTime());
    			enroll.setCreator(userId);
    			enroll.setMessage(svmContractNo.trim().equals("")? "" : svmContractNo.trim());
    			enroll.setInputRejectCode(!(csv.getRejectCode().trim() == null || csv.getRejectCode().trim().equals(""))?csv.getRejectCode() : "");
    			enroll.setRejectCodeId(0);
    			enroll.setServiceContractId(0);
    			//enroll.setDdPaymentId(paymentId); // Added for eMandate-paperless by Hui Ding, 25/08/2023
    			list.add(enroll);

    		}
		}
		return list;
	}

	private List<EnrollmentUpdateDVO> bindDDEnrollItemList(List<DdCsvFormatVO> csvList, int userId) throws Exception{
		List<EnrollmentUpdateDVO> list = new ArrayList();

		try {
    		if(csvList.size() > 0){
       		for(DdCsvFormatVO csv : csvList){

       			SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));
       			Calendar c = Calendar.getInstance();
       			c.setTime(df.parse(csv.getStartDate()));

       			String orderNo = null;
       			String submitDate = null;
       			// get dd-paperless enrollment info
       			Map<String, Object> ddEnroll = eMandateService.getEnrollInfoByPaymentId(csv.getPaymentId());
       			if (ddEnroll != null) {
       				orderNo = ddEnroll.get("salesOrdNo").toString();
       				submitDate = ddEnroll.get("submitDate") != null ? CommonUtils.getFormattedString("yyyyMMdd", (Date)ddEnroll.get("submitDate")) : null;
       				System.out.println(submitDate);
       			}

       			if (CommonUtils.nvl(orderNo) == null){
       				continue;
       			} else {

        			EnrollmentUpdateDVO enroll = new EnrollmentUpdateDVO();
        			enroll.setEnrollUpdateDetId(0);
        			enroll.setEnrollUpdateId(0);
        			enroll.setStatusCodeId(1);
        			enroll.setOrderNo(orderNo);
        			enroll.setSalesOrderId(0);
        			enroll.setAppTypeId(0);
        			enroll.setInputMonth(String.valueOf(c.get(Calendar.MONTH)+1));
        			enroll.setInputDay(String.valueOf(c.get(Calendar.DAY_OF_MONTH)));
        			enroll.setInputYear(String.valueOf(c.get(Calendar.YEAR)));
        			enroll.setResultDate("01-01-1990");
        			enroll.setCreated(CommonUtils.getNowDate() + CommonUtils.getNowTime());
        			enroll.setCreator(userId);
        			//enroll.setMessage(svmContractNo.trim().equals("")? "" : svmContractNo.trim());
        			enroll.setInputRejectCode(!(csv.getRejectCode().trim() == null || csv.getRejectCode().trim().equals(""))?csv.getRejectCode() : "");
        			enroll.setRejectCodeId(0);
        			enroll.setServiceContractId(0);
        			enroll.setDdPaymentId(csv.getPaymentId()); // Added for eMandate-paperless by Hui Ding, 25/08/2023
        			enroll.setSubmitDate(submitDate);

        			// Added for eMandate-paperless bug fixes by Hui Ding - ticket no: #24033069
        			if (csv.getAccNo() == null){
        				enroll.setMessage("Account Number is required.");
        				enroll.setStatusCodeId(21);
        				continue;
        			} else {
        				enroll.setAccNo(csv.getAccNo().trim());
        			}

        			if (csv.getAccHolder() == null){
        				enroll.setMessage("Account Holder is required.");
        				enroll.setStatusCodeId(21);
        				continue;
        			} else {
        				enroll.setAccHolder(csv.getAccHolder().trim());
        			}

        			if (csv.getAccType() == null){
        				enroll.setMessage("Account Type is required.");
        				enroll.setStatusCodeId(21);
        				continue;
        			} else {
        				if (csv.getAccType().trim().equalsIgnoreCase("Saving Account")) {
        					enroll.setAccType("125");
        				} else if (csv.getAccType().trim().equalsIgnoreCase("Current Account")) {
        					enroll.setAccType("126");
        				} else {
        					enroll.setMessage("Invalid Account Type.");
            				enroll.setStatusCodeId(21);
            				continue;
        				}

        			}

        			if (csv.getIssueBank() == null){
        				enroll.setMessage("Issue Bank is required.");
        				enroll.setStatusCodeId(21);
        				continue;
        			} else {
        				EgovMap bank = enrollResultService.selectBankCode(csv.getIssueBank().trim());
        				if (bank != null && bank.get("bankId") != null) {
        					enroll.setIssueBank(bank.get("bankId").toString());
        				} else {
        					enroll.setMessage("Invalid Issue Bank.");
        					enroll.setStatusCodeId(21);
        					continue;
        				}
        			}

        			enroll.setStartDate(csv.getStartDate());
        			enroll.setRejectDate(csv.getRejectDate());

        			list.add(enroll);

        		}
       		}
    		}
		} catch(Exception e){
			throw e;
		}
		return list;
	}

	   @RequestMapping(value = "/selectAutoDebitDeptUserId", method = RequestMethod.GET)
       public ResponseEntity<List<EgovMap>> selectAutoDebitDeptUserId( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		   LOGGER.debug("selectAutoDebitDeptUserId - params : " + params);
           List<EgovMap>selectAutoDebitDeptUserIdList = enrollResultService.selectAutoDebitDeptUserId(params);

           return ResponseEntity.ok(selectAutoDebitDeptUserIdList);
       }
}


/*if (contractNOrderNo.length() >= 16){ // added for DD enrollment result upload, Hui Ding, 10/08/2023
	paymentId = contractNOrderNo;

	// get order no from payment id
	orderNo = eMandateService.getOrderIdByPaymentId(paymentId);
	if (CommonUtils.nvl(orderNo) == null){
		continue;
	}
}*/
