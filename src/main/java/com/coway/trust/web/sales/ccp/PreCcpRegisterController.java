package com.coway.trust.web.sales.ccp;

//import com.coway.trust.config.ctos.client.xml.proxy.ws.RequestData;
//import com.coway.trust.config.ctos.client.xml.proxy.ws.Proxy;
//import com.coway.trust.config.ctos.client.xml.proxy.ws.StaxXMLReader;
//import com.coway.trust.config.ctos.client.xml.proxy.ws.ResRequestVO;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;

import com.coway.trust.biz.sales.ccp.PreCcpRegisterService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.EncryptionDecryptionService;
import com.coway.trust.cmmn.model.SmsResult;


@Controller
@RequestMapping(value = "/sales/ccp")
public class PreCcpRegisterController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PreCcpRegisterController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "preCcpRegisterService")
	private PreCcpRegisterService preCcpRegisterService;

	@Resource(name = "encryptionDecryptionService")
	private EncryptionDecryptionService encryptionDecryptionService;

	@Autowired
	private AdaptorService adaptorService;

	@Value("${etrust.base.url}")
	private String etrustBaseUrl;

    @Autowired
    private SessionHandler sessionHandler;

//    @Autowired
//    private Proxy proxy;

	@RequestMapping(value = "/initPreCcpRegisterList.do")
	public String initPreCcpRegisterList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		return "sales/ccp/preCcpRegisterList";
	}


	@RequestMapping(value="/checkPreCcpResult.do", method=RequestMethod.GET)
	public ResponseEntity <EgovMap> checkPreCcpResult(@RequestParam Map<String, Object>params, SessionVO sessionVO) throws Exception {

		EgovMap getExistCustomer= preCcpRegisterService.getExistCustomer(params);

		if(getExistCustomer != null){
			getExistCustomer.put("customerType", 7289);
			getExistCustomer.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
			int result = preCcpRegisterService.insertPreCcpSubmission(getExistCustomer);
		}

		return ResponseEntity.ok(getExistCustomer);
	}

	@RequestMapping(value = "/preCcpOrderSummary.do")
	public String preCcpOrderSummary(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("custId", params.get("custId"));
		return "sales/ccp/preCcpOrderSummary";
	}

    @RequestMapping(value = "/searchOrderSummaryList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> searchOrderSummaryList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        List<EgovMap> orderSummaryList = preCcpRegisterService.searchOrderSummaryList(params);

        return ResponseEntity.ok(orderSummaryList);
    }


//    Pre-CCP Phase 2 still in development
//    public boolean ctos(Map<String, Object> params){
//
//        try
//    	{
//		    params.put("batchNo", "testing");
//		    params.put("orderNo", "");
//		    params.put("oldIc", "testing");
//
//        	preCcpRegisterService.insertNewCustomerInfo(params);
//        	List <EgovMap> resultMapList = (List<EgovMap>) params.get("b2bData");
//            String reqPayload = RequestData.PrepareRequest(params.get("batchNo").toString(), params.get("customerName").toString(), params.get("customerNric").toString(), params.get("oldIc").toString());
//
//            byte[] bytes = proxy.request(reqPayload);
//
//            String response = new String(bytes);
//            int ficoScore = StaxXMLReader.getFicoScore(response);
//            String bankRupt = StaxXMLReader.getBankruptcy(response);
//            String confirmEntity = StaxXMLReader.getConfirmEntity(response);
//
//            if(!confirmEntity.equals("0") && ficoScore == 0){
//              ficoScore = 9999;
//            }
//
//            ResRequestVO resRequestVO = ResRequestVO.builder().custIc(params.get("customerNric").toString()).resultRaw(response)
//                    .ficoScore(ficoScore).batchNo(params.get("batchNo").toString()).ctosDate(new Date()).bankRupt(bankRupt).confirmEntity(confirmEntity).build();
//
//            Map<String, Object> param = BeanConverter.toMap(resRequestVO);
//            param.put("ccrisId", resultMapList.get(0).get("ccrisId").toString());
//            param.put("seq", params.get("seq"));
//        	preCcpRegisterService.updateCcrisScre(param);
//        	preCcpRegisterService.updateCcrisId(param);
//        	return true;
//    	}
//        catch(Exception e){
//        	LOGGER.debug("selectCustomerScoring e{}" + CommonUtils.printStackTraceToString(e));
//        	return false;
//        }
//    }


//	@RequestMapping(value = "/preCcpSubmissionRegister.do")
//	public String preCcpSubmissionRegister(@RequestParam Map<String, Object> params, ModelMap model) {
//		return "sales/ccp/preCcpSubmissionRegister";
//	}


   @Transactional
   @RequestMapping(value = "/submitPreCcpSubmission.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> submitPreCcpSubmission(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

	    ReturnMessage message = new ReturnMessage();

    	try{
    		params.put("customerType", 7290);
    		params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	    	preCcpRegisterService.insertPreCcpSubmission(params);
	    	message.setCode(AppConstants.SUCCESS);
	    	message.setMessage(messageAccessor.getMessage("preccp.created"));
	    	return ResponseEntity.ok(message);
//	    	List <EgovMap> resultMapList = (List<EgovMap>) params.get("preccpData");
//	    	params.put("seq", resultMapList.get(0).get("preccpId").toString());
//		    flag = ctos(params);
    	}
    	catch(Exception e){
    		message.setCode(AppConstants.FAIL);
    		message.setMessage(messageAccessor.getMessage("preccp.failCreated"));
    		return ResponseEntity.ok(message);
    	}
  }

   @RequestMapping(value="/chkExistCust.do", method=RequestMethod.GET)
   public ResponseEntity <ReturnMessage> chkExistCust(@RequestParam Map<String, Object>params) {

	   EgovMap getExistCustomer = preCcpRegisterService.getExistCustomer(params);
	   EgovMap getRegisteredCust = preCcpRegisterService.getRegisteredCust(params);
	   ReturnMessage message = new ReturnMessage();
	   message.setCode((getExistCustomer == null && getRegisteredCust ==null) ? AppConstants.FAIL : AppConstants.SUCCESS);
	   message.setMessage((getExistCustomer == null && getRegisteredCust ==null) ? messageAccessor.getMessage("preccp.newCust") : messageAccessor.getMessage("preccp.existCust")  );
	   return ResponseEntity.ok(message);
   }

   @RequestMapping(value="/chkDuplicated.do", method=RequestMethod.GET)
   public ResponseEntity <ReturnMessage> chkDuplicated(@RequestParam Map<String, Object>params){
	   EgovMap chkDuplicated = preCcpRegisterService.chkDuplicated(params);
	   ReturnMessage message = new ReturnMessage();
	   message.setData(chkDuplicated);
	   return ResponseEntity.ok(message);
   }

   @RequestMapping(value = "/selectSmsConsentHistory.do")
   public ResponseEntity<List<EgovMap>> selectSmsConsentHistory(@RequestParam Map<String, Object> params){
	   params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	   return ResponseEntity.ok(preCcpRegisterService.selectSmsConsentHistory(params));
   }

   @Transactional
   @RequestMapping(value = "/sendSms.do")
   public ResponseEntity<ReturnMessage> sendSms(@RequestParam Map<String, Object> params){

	   ReturnMessage message = new ReturnMessage();

	   	try{
		   	EgovMap chkTime = preCcpRegisterService.chkSendSmsValidTime(params);
		   	BigDecimal defaultValidTime = new BigDecimal("5"), latestSendSmsTime =new BigDecimal(chkTime.get("chkTime").toString());;
		   	Integer compareResult = latestSendSmsTime.compareTo(defaultValidTime);

			EgovMap getCustInfo = preCcpRegisterService.getCustInfo(params);

	    	if(getCustInfo.get("smsCount").toString().equals("0") || compareResult.equals(1)){
	    	   	params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());

	    	   	String smsMessage ="";
    			smsMessage += "RM0 COWAY: Authorise Coway to check your credit standing for rental of a Coway appliance. Click ";
    			smsMessage +=  etrustBaseUrl + "/sales/ccp/consent?key=" + encryptionDecryptionService.encrypt(params.get("preccpSeq").toString(), "preccp");
    			smsMessage += ", check the box and submit. Thank you.";

    			LOGGER.debug("===========>"+ encryptionDecryptionService.encrypt(params.get("preccpSeq").toString(), ""));

           	    SmsVO sms = new SmsVO(349 , 7327);
           	    sms.setMessage(smsMessage);
           	    sms.setMobiles(getCustInfo.get("custMobileno").toString());
//
           	    SmsResult smsResult = adaptorService.sendSMS2(sms);
//
//           	    params.put("smsId", smsResult.getSmsId());
//           	    params.put("statusId", smsResult.getSmsStatus());
//           	    params.put("failRsn", smsResult.getFailReason().toString());
//           	    params.put("smsId", smsResult.getSmsId());
//           	    params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
//
//           	    preCcpRegisterService.insertSmsHistory(params);
//
//           	    if(smsResult.getSmsStatus() == 4){
//	    	   		preCcpRegisterService.updateSmsCount(params);
//           	    }
//
    	   		message.setCode(smsResult.getSmsStatus() == 4 ? AppConstants.SUCCESS : AppConstants.FAIL);
	           	message.setMessage(smsResult.getSmsStatus() == 4 ? messageAccessor.getMessage("preccp.doneSms") : messageAccessor.getMessage("preccp.failSms"));
	           	return ResponseEntity.ok(message);

	    	}
	    	else{
	    		message.setCode(AppConstants.FAIL);
	           	message.setMessage(messageAccessor.getMessage("preccp.retrySms"));
	           	return ResponseEntity.ok(message);
	    	}
	   	}
	   	catch(Exception e){
	   		message.setCode(AppConstants.FAIL);
           	message.setMessage(messageAccessor.getMessage("preccp.failSms"));
           	return ResponseEntity.ok(message);
	   	}
   }


   @RequestMapping(value="/newCustomer.do")
   public String newCustomer(SessionVO sessionVO){

	   String  chkDate = preCcpRegisterService.chkSmsResetFlag().get("chkDate").toString(),
			      chkResetSmsFlag =preCcpRegisterService.chkSmsResetFlag().get("resetFlag").toString();

	   Map<String, Object> params = new HashMap<String, Object>();

	   if(chkResetSmsFlag.equals("1") && chkResetSmsFlag.equals("1")){
		   params.put("flag",0);
		   preCcpRegisterService.updateResetFlag(params);
	   }

	   if(chkResetSmsFlag.equals("0")){
		   if(preCcpRegisterService.resetSmsConsent() >=1){
			   params.put("flag",1);
			   preCcpRegisterService.updateResetFlag(params);
		   }
	   }

 	  return "sales/preccp/newCustomer";
   }

//   @RequestMapping(value = "/preCcpSubmissionRegisterResult.do")
//	public String preCcpSubmissionRegisterResult(@RequestParam Map<String, Object> params, ModelMap model) {
//		model.put("preccpResult", params);
//		return "sales/ccp/preCcpSubmissionRegisterResult";
//  }



@RequestMapping(value = "/preCcpEditRemark.do")
	public String preCcpEditRemark(@RequestParam Map<String, Object> params, ModelMap model) {
	    int result = preCcpRegisterService.insertRemarkRequest(params);
		return "sales/ccp/preCcpEditRemark";
   }

   @RequestMapping(value = "/preCcpEditRemarkDetails.do")
	public String preCcpEditRemarkDetails(@RequestParam Map<String, Object> params, ModelMap model) {
	    model.put("remarkDetails", preCcpRegisterService.getPreCcpRemark(params).get(0));
		return "sales/ccp/preCcpEditRemarkDetails";
   }

   @RequestMapping(value = "/getPreCcpRemark.do", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> getPreCcpRemark(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

       List<EgovMap> preCcpRemarkList = preCcpRegisterService.getPreCcpRemark(params);

       return ResponseEntity.ok(preCcpRemarkList);
   }

   @Transactional
   @RequestMapping(value = "/editRemarkRequest.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editRemarkRequest(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

	    params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	    ReturnMessage message = new ReturnMessage();
	    boolean flag=true;

	    try{
	    	int result = preCcpRegisterService.editRemarkRequest(params);
	    	flag = result > 0 ? true : false;
	    }catch(Exception e){
	    	flag=false;
	    }

    	message.setCode(flag==true ? AppConstants.SUCCESS : AppConstants.FAIL);
   	    message.setMessage(flag==true ? "Success to update remark" : "Fail to update remark");

	    return ResponseEntity.ok(message);
  }

}