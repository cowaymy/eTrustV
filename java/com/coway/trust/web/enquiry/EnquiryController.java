/**
 *
 */
package com.coway.trust.web.enquiry;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.enquiry.EnquiryService;
import com.coway.trust.biz.logistics.calendar.CalendarService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.CustomerLoginVO;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @author Low Kim Ching
 *
 */
@Controller
@RequestMapping(value = "/enquiry")
public class EnquiryController {

	 private static final Logger LOGGER = LoggerFactory.getLogger(EnquiryController.class);

	 @Resource(name = "EnquiryService")
	 private EnquiryService enquiryService;

	 @Autowired
	 private AdaptorService adaptorService;

	 @Autowired
	 private SessionHandler sessionHandler;

	 @Autowired
	 private MessageSourceAccessor messageAccessor;

	 @RequestMapping(value = "/trueaddress.do")
	 public String updateInstallationAddressHomePage(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {
		 model.addAttribute("exception", params.get("exception"));
		 return "enquiry/updateInstallationAddress";
	 }

	 @RequestMapping(value = "/selectCustomerInfo.do")
	 public String selectCustomerInfo(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception  {

		 SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
 		 params.put("custId", sessionVO.getCustId());

		 List<EgovMap> customerInfoList =  enquiryService.selectCustomerInfoList(params);

		 if(sessionVO.getCustId() != 0){
			 model.put("totalCnt", customerInfoList.size());
			 model.put("exception", params.get("exception"));
		 }else{
			 model.put("exception", "401");
		 }

		 return "enquiry/customerInfo";
	 }

	 public void insertErrorLog(Map<String, Object> params){
		 	enquiryService.insertErrorLog(params);
	 }


	 @RequestMapping(value = "/getCustomerLoginInfo.do")
	  public ResponseEntity<ReturnMessage> getCustomerLoginInfo(@RequestParam Map<String, Object> params ) throws Exception{

		 	ReturnMessage message = new ReturnMessage();

		 	try{

    			  int flag = 0, checkDuplicated = 0;

    			  //Checking whether params is null
    			  if(CommonUtils.isEmpty(params.get("nricPass"))){
    				    flag=1;
    					message.setCode(AppConstants.FAIL);
    					message.setMessage("NRIC / Passport Number cannot be empty.");
    					return ResponseEntity.ok(message);
    			  }

    			  if(CommonUtils.isEmpty(params.get("mobileNo"))){
    				    flag=1;
    					message.setCode(AppConstants.FAIL);
    					message.setMessage("Mobile Number cannot be empty.");
    					return ResponseEntity.ok(message);
    			  }

    			  EgovMap result = enquiryService.getCustomerLoginInfo(params);
    			  params.put("custId",  result!=null ?  result.get("custId") : 0);
    			  params.put("custName",  result!=null ?  result.get("name") : "");

    			  if(result ==null){
    				    message.setCode(AppConstants.FAIL);
    			    	message.setMessage("Your account is not found. Please try to login again.");
    			    	return ResponseEntity.ok(message);
    			  }

    			  if(!result.get("typeId").toString().equals("964")){
      				    message.setCode(AppConstants.FAIL);
      			    	message.setMessage("Only Individual Customer Type is allowed to login.");
      			    	return ResponseEntity.ok(message);
    			  }

    			  if(flag == 0){

    				    CustomerLoginVO custmoerLoginVO = enquiryService.getCustomerInfo(params);

    				    HttpSession session = sessionHandler.getCurrentSession();
    					session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create2(custmoerLoginVO));
    					message.setData(custmoerLoginVO);

    				  	enquiryService.updateLoginSession(params);
    	    			message.setCode(AppConstants.SUCCESS);
    	    			message.setMessage(messageAccessor.getMessage("enquiry.customerSuccessLogin"));
    	    			return ResponseEntity.ok(message);
    				  }

    			  return ResponseEntity.ok(message);
		 	  }
    		  catch(Exception e){

    			  Map<String, Object> errorParam = new HashMap<>();
    			  errorParam.put("pgmPath","/enquiry");
    			  errorParam.put("functionName", "getCustomerLoginInfo.do");
    			  errorParam.put("errorMsg",e.toString());
    			  enquiryService.insertErrorLog(errorParam);

    			  message.setCode(AppConstants.FAIL);
    		      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_ERROR));
    		      return ResponseEntity.ok(message);
    		  }
	  }


	 @Transactional
	 @RequestMapping(value = "/getCustomerInfo.do")
	  public ResponseEntity<ReturnMessage> getCustomerInfo(@RequestParam Map<String, Object> params, ModelMap model ) throws Exception{

    		 List<EgovMap> customerInfoList =  enquiryService.selectCustomerInfoList(params);

    		 ReturnMessage message = new ReturnMessage();
    		 message.setData(customerInfoList);

    		 return ResponseEntity.ok(message);
	 }


	 @RequestMapping(value = "/updateInstallationAddressInDetails.do")
	 public String updateInstallationAddressInDetails(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {

    		sessionVO = sessionHandler.getCurrentSessionInfo();
    		params.put("custId", sessionVO.getCustId());

    		List<EgovMap> customerInfoList =  enquiryService.selectCustomerInfoList(params);
    	    EgovMap getInfo = enquiryService.getCurrentPhoneNo(params);

    	    if(getInfo!=null && customerInfoList!=null){
    	    	model.put("chkService", customerInfoList.get(0).get("chkService").toString());
    	    	model.put("rentalStus", customerInfoList.get(0).get("rentalStus").toString());
        		model.put("orderNo", params.get("orderNo"));
        		model.put("orderId", customerInfoList.get(0).get("ordId").toString());
        		model.put("productDesc", customerInfoList.get(0).get("stkDesc").toString());
        		model.put("addrDtl", customerInfoList.get(0).get("instAddrDtl").toString());
        		model.put("street", customerInfoList.get(0).get("instStreet").toString());
        		model.put("mailPostCode", customerInfoList.get(0).get("instPostcode").toString());
        		model.put("mailCity", customerInfoList.get(0).get("instCity").toString());
        		model.put("mailState", customerInfoList.get(0).get("instState").toString());
        		model.put("mailCnty", customerInfoList.get(0).get("instCountry").toString());
        		model.put("mailCnty", customerInfoList.get(0).get("instCountry").toString());
        		model.put("mailCnty", customerInfoList.get(0).get("instCountry").toString());
        		model.put("phoneNo", getInfo.get("phoneNo"));
        		model.put("exception", sessionVO.getCustId() == 0 ? "401" : params.get("exception"));
    	    }
    	    else{
    	    	model.put("exception","401");
    	    }

    		return "enquiry/updateInstallationAddressInDetails";
	 }


	 @RequestMapping(value = "/selectMagicAddressComboList.do")
	 public ResponseEntity<List<EgovMap>> selectMagicAddressComboList(@RequestParam Map<String, Object> params) throws Exception {

	     	List<EgovMap> postList = enquiryService.selectMagicAddressComboList(params);

	     	return ResponseEntity.ok(postList);
	 }


	 @RequestMapping(value = "/getAreaId.do")
	 public ResponseEntity<EgovMap> getAreaId(@RequestParam Map<String, Object> params) throws Exception {

	     	EgovMap areaMap = enquiryService.getAreaId(params);

	     	return ResponseEntity.ok(areaMap);
	 }


	 @RequestMapping(value = "/searchMagicAddressPop.do")
	 public String searchMagicAddressPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    	    model.addAttribute("searchStreet", params.get("searchSt"));
    	    model.addAttribute("state", params.get("mState"));
    	    model.addAttribute("city", params.get("mCity"));
    	    model.addAttribute("postCode", params.get("mPostCd"));
    	    model.addAttribute("searchState", params.get("mState"));
    	    model.addAttribute("searchCity", params.get("mCity"));
    	    model.addAttribute("exception", sessionVO.getCustId() == 0 ? "401" : params.get("exception"));

    	    return "enquiry/customerMagicAddrPop";
	 }


	 @RequestMapping(value = "/searchMagicAddressPopJsonList.do", method = RequestMethod.GET)
	 public ResponseEntity<List<EgovMap>> searchMagicAddressPopJsonList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	     	List<EgovMap> searchMagicAddrList =  enquiryService.searchMagicAddressPop(params);

	        return ResponseEntity.ok(searchMagicAddrList);
	 }


	 @Transactional
	 @RequestMapping(value = "/getTacNo.do")
     public ResponseEntity<ReturnMessage> getTacNo(@RequestParam Map<String, Object> params, SessionVO sessionVO ) throws Exception{

		    ReturnMessage message = new ReturnMessage();

		    try{
    			 sessionVO = sessionHandler.getCurrentSessionInfo();
    		     params.put("custId", sessionVO.getCustId());

    		     EgovMap result = enquiryService.getCurrentPhoneNo(params);

    		     params.put("mobileNo", result.get("phoneNo"));
    			 int smsResultValue = enquiryService.getTacNo(params, sessionVO);

    			 if(smsResultValue > 0){
    				 message.setCode(AppConstants.SUCCESS);
    				 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    			 }
    			 else{
    				 message.setCode(AppConstants.FAIL);
    				 message.setMessage("The sms function is not available. Please wait and retry or contact Coway Careline 1-800-888-111. Thank you.");
    			 }

			  return ResponseEntity.ok(message);
		   }
		   catch(Exception e){

			  Map<String, Object> errorParam = new HashMap<>();
			  errorParam.put("pgmPath","/enquiry");
			  errorParam.put("functionName", "insertNewInstallationAddress.do");
			  errorParam.put("errorMsg",e.toString());
			  enquiryService.insertErrorLog(errorParam);

			  message.setCode(AppConstants.FAIL);
			  message.setMessage("Please wait and retry or contact Coway Careline 1-800-888-111. Thank you.");
		      return ResponseEntity.ok(message);
		  }
	  }

	 @Transactional
	 @RequestMapping(value = "/checkExistRequest.do")
     public ResponseEntity<ReturnMessage> checkExistRequest(@RequestParam Map<String, Object> params, SessionVO sessionVO ) throws Exception{

		    ReturnMessage message = new ReturnMessage();

		    try{
    			 sessionVO = sessionHandler.getCurrentSessionInfo();
    		     params.put("custId", sessionVO.getCustId());

    		     EgovMap checkExistRequest = enquiryService.checkExistRequest(params);

    		     message.setCode(AppConstants.SUCCESS);
    		     message.setData(checkExistRequest);
    			 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			  return ResponseEntity.ok(message);
		   }
		   catch(Exception e){

			  Map<String, Object> errorParam = new HashMap<>();
			  errorParam.put("pgmPath","/enquiry");
			  errorParam.put("functionName", "checkExistRequest.do");
			  errorParam.put("errorMsg",e.toString());
			  enquiryService.insertErrorLog(errorParam);

			  message.setCode(AppConstants.FAIL);
		      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_ERROR));
		      return ResponseEntity.ok(message);
		  }
	  }


	 @Transactional
	 @RequestMapping(value = "/verifyTacNo.do")
     public ResponseEntity<ReturnMessage> verifyTacNo(@RequestParam Map<String, Object> params, SessionVO sessionVO ) throws Exception{

		    ReturnMessage message = new ReturnMessage();
		    int flag =0;
		    try{

		    	sessionVO = sessionHandler.getCurrentSessionInfo();
	    	    params.put("custId", sessionVO.getCustId());

	    	    enquiryService.disabledPreviousRequest(params);

		    	EgovMap result = enquiryService.verifyTacNo(params);

		    	if(result.get("chkTac").toString().equals("1") && result.get("chkTime").toString().equals("1")){

		    		params.put("stusId", "1");
		    		params.put("remark", "Success to register.");
		    		int insResult = enquiryService.insertNewInstallationAddress(params);

		    		if(insResult>0){
		    			flag = 1;
		    		}
		    	}
		    	else{
		    		flag = result.get("chkTac").equals("0") ? 2 : 3;
		    		params.put("stusId", result.get("chkTac").equals("0") ? "21" : "6");
		    		params.put("remark", result.get("chkTac").equals("0") ? "Failed due to TAC number is not match." : "Rejected due to TAC Timeout");
		    		int insResult2 = enquiryService.insertNewInstallationAddress(params);
		    	}

		    	if(flag ==1){
		    		 message.setCode(AppConstants.SUCCESS);
    				 message.setMessage("Your request to update Installation Address is under revision. It will update within 3 working days. Thank you ");
    				 setEmailData(params);
		    	}
		    	else if(flag ==2){
		    		 message.setCode(AppConstants.FAIL);
   				     message.setMessage("Your TAC number is not valid. Please try again.");
		    	}
		    	else if(flag ==3){
		    		 message.setCode(AppConstants.FAIL);
  				     message.setMessage("Your TAC number is expired. Please try again.");
		    	}
		    	else{
		    		 message.setCode(AppConstants.FAIL);
    				 message.setMessage("Please try again or contact Coway Careline 1-800-888-111. Thank you.");
		    	}
		    	 return ResponseEntity.ok(message);
			}
		   catch(Exception e){

			  Map<String, Object> errorParam = new HashMap<>();
			  errorParam.put("pgmPath","/enquiry");
			  errorParam.put("functionName", "verifyTacNo.do");
			  errorParam.put("errorMsg",e.toString());
			  enquiryService.insertErrorLog(errorParam);

			  message.setCode(AppConstants.FAIL);
			  message.setMessage("Please try again or contact Coway Careline 1-800-888-111. Thank you.");
		      return ResponseEntity.ok(message);
		  }
	  }


	 private void setEmailData(Map<String, Object> params) {

		  EgovMap getEmailDetails = enquiryService.getEmailDetails(params);
		  List<String> emailList = Arrays.asList("callcenter@coway.com.my");
		  String street = getEmailDetails.get("street").equals("0") ? "" : getEmailDetails.get("street").toString() ;

		  Map<String, Object> emailDetail = new HashMap<String,Object>();
		  List<Map<String, Object>> emailDetailList = new ArrayList<Map<String,Object>>();
		  emailDetail.put("orderNo", getEmailDetails.get("orderNo").toString());
		  emailDetail.put("customerName", getEmailDetails.get("name").toString());
		  emailDetail.put("mobileNo", getEmailDetails.get("phoneNo").toString());
		  emailDetail.put("address", getEmailDetails.get("addrDtl").toString() + street + " " + getEmailDetails.get("area").toString());
		  emailDetail.put("postCode", getEmailDetails.get("postcode").toString());
		  emailDetail.put("city", getEmailDetails.get("city").toString());
		  emailDetail.put("state", getEmailDetails.get("state").toString());
		  emailDetail.put("requestDt", getEmailDetails.get("requestDt").toString());
		  emailDetail.put("email", emailList);
		  emailDetail.put("emailSubject", "Update Installation Address Request");

		 this.sendEmail(emailDetail);
	 }

	 private void sendEmail(Map<String, Object> params) {

		 try{
	    	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	    	List<Map<String, Object>> emailList =  (List<Map<String, Object>>) params.get("email");
	    	for(int i = 0 ;i< emailList.size();i++){
	            EmailVO email = new EmailVO();

	            String emailSubject = params.get("emailSubject").toString();

	            List<String> emailNo = new ArrayList<String>();

	            if (!"".equals(CommonUtils.nvl(emailList.get(i)))) {
	            	emailNo.add(CommonUtils.nvl(emailList.get(i)));
	            }

	            String content = "";
	            content += "<table style='border-collapse: collapse;width: 100%;'>";
	            content += "<tr><th colspan='2' style='background-color: #3BC3FF;padding: 12px;color: white;text-align: left'>Update Installation Address Request </th><tr>";
	            content +="<tr><td style='padding: 8px'>Full Name : </td>";
	            content +="<td>"+params.get("customerName").toString()+"</td></tr>";

	            content +="<tr><td style='padding: 8px'>Order No : </td>";
	            content +="<td>"+params.get("orderNo").toString()+"</td></tr>";

	            content +="<tr><td style='padding: 8px'>Mobile No : </td>";
	            content +="<td>"+params.get("mobileNo").toString()+"</td></tr>";

	            content +="<tr><td style='padding: 8px'>Address : </td>";
	            content +="<td>"+params.get("address").toString()+"</td></tr>";

	            content +="<tr><td style='padding: 8px'>Postcode : </td>";
	            content +="<td>"+params.get("postCode").toString()+"</td></tr>";

	            content +="<tr><td style='padding: 8px'>City : </td>";
	            content +="<td>"+params.get("city").toString()+"</td></tr>";

	            content +="<tr><td style='padding: 8px'>State : </td>";
	            content +="<td>"+params.get("state").toString()+"</td></tr>";

	            content +="<tr><td style='padding: 8px'>Request Dt : </td>";
	            content +="<td>"+params.get("requestDt").toString()+"</td></tr>";

	            email.setTo(emailNo);
	            email.setHtml(true);
	            email.setSubject(emailSubject);
	            email.setText(content);
	            adaptorService.sendEmail(email, false);
	    	}
		 }
		 	catch(Exception e){

			  Map<String, Object> errorParam = new HashMap<>();
			  errorParam.put("pgmPath","/enquiry");
			  errorParam.put("functionName", "sendEmail.do");
			  errorParam.put("errorMsg",e.toString());
			  enquiryService.insertErrorLog(errorParam);

		 	}
	    }

	 @RequestMapping(value = "/getSubmissionTimes.do", method = RequestMethod.GET)
	 public ResponseEntity<EgovMap> getSubmissionTimes(@RequestParam Map<String, Object> params, ModelMap model) {
	      EgovMap getSubmissionTimes = enquiryService.getSubmissionTimes(params);
	      return ResponseEntity.ok(getSubmissionTimes);
	 }
}
