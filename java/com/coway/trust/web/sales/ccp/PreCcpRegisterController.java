package com.coway.trust.web.sales.ccp;

import com.coway.trust.config.ctos.client.xml.proxy.ws.RequestData;
import com.coway.trust.config.ctos.client.xml.proxy.ws.Proxy;
import com.coway.trust.config.ctos.client.xml.proxy.ws.StaxXMLReader;
import com.coway.trust.config.ctos.client.xml.proxy.ws.ResRequestVO;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.time.StopWatch;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
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
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderColorGridService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.google.common.base.Objects;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.EncryptionDecryptionService;
import com.coway.trust.biz.enquiry.EnquiryService;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.config.csv.CsvReadComponent;


@Controller
@RequestMapping(value = "/sales/ccp")
public class PreCcpRegisterController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PreCcpRegisterController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "preCcpRegisterService")
	private PreCcpRegisterService preCcpRegisterService;

	@Resource(name = "EnquiryService")
	private EnquiryService enquiryService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "encryptionDecryptionService")
	private EncryptionDecryptionService encryptionDecryptionService;

    @Autowired
    private CsvReadComponent csvReadComponent;

	@Autowired
	private AdaptorService adaptorService;

	@Value("${etrust.base.url}")
	private String etrustBaseUrl;

    @Autowired
    private SessionHandler sessionHandler;

    @Autowired
    private Proxy proxy;

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

    //@Transactional
    public boolean ctos(Map<String, Object> params){

        try
    	{
        	params.put("preccpSeq", params.get("id").toString().substring(6, params.get("id").toString().length()));
        	EgovMap getCustInfo = preCcpRegisterService.getCustInfo(params);

		    params.put("batchNo", "testing");
		    params.put("orderNo", "");
		    params.put("oldIc", "testing");
    		params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
    		params.put("customerName", getCustInfo.get("custName"));
    		params.put("customerNric", getCustInfo.get("custIc"));
        	preCcpRegisterService.insertNewCustomerInfo(params);

        	List <EgovMap> resultMapList = (List<EgovMap>) params.get("b2bData");
            String reqPayload = RequestData.PrepareRequest(params.get("batchNo").toString(),  params.get("orderNo").toString(), params.get("customerName").toString(), params.get("customerNric").toString(), params.get("oldIc").toString());

            byte[] bytes = proxy.request(reqPayload);

            String response = new String(bytes);
            int ficoScore = StaxXMLReader.getFicoScore(response);
            String bankRupt = StaxXMLReader.getBankruptcy(response);
            String confirmEntity = StaxXMLReader.getConfirmEntity(response);

            if(!confirmEntity.equals("0") && ficoScore == 0){
              ficoScore = 9999;
            }

            ResRequestVO resRequestVO = ResRequestVO.builder().custIc(params.get("customerNric").toString()).resultRaw(response)
                    .ficoScore(ficoScore).batchNo(params.get("batchNo").toString()).ctosDate(new Date()).bankRupt(bankRupt).confirmEntity(confirmEntity).build();

            Map<String, Object> param = BeanConverter.toMap(resRequestVO);
            param.put("ccrisId", resultMapList.get(0).get("ccrisId").toString());
            param.put("seq", params.get("preccpSeq"));
        	preCcpRegisterService.updateCcrisId(param);
        	preCcpRegisterService.updateCcrisScre(param);

        	return true;
    	}
        catch(Exception e){
        	 Map<String, Object> errorParam = new HashMap<>();
			  errorParam.put("pgmPath","/preccp");
			  errorParam.put("functionName", "ctos.do");
			  errorParam.put("errorMsg",CommonUtils.printStackTraceToString(e));
			  enquiryService.insertErrorLog(errorParam);
        	LOGGER.debug("selectCustomerScoring e{}" + CommonUtils.printStackTraceToString(e));
        	return false;
        }
    }

   @Transactional
   @RequestMapping(value = "/submitPreCcpSubmission.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> submitPreCcpSubmission(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

	    ReturnMessage message = new ReturnMessage();

    	try{
    		params.put("customerType", 7290);
    		params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());

    		if(sessionVO.getUserTypeId() != 1 && sessionVO.getUserTypeId() != 2 && sessionVO.getUserTypeId() != 7){
    			message.setCode(AppConstants.FAIL);
        		message.setMessage(messageAccessor.getMessage("preccp.invalidUser"));
        		return ResponseEntity.ok(message);
    		}

    		EgovMap getUserInfo = salesCommonService.getUserInfo(params);

    		if(getUserInfo == null){
    			message.setCode(AppConstants.FAIL);
        		message.setMessage(messageAccessor.getMessage("preccp.invalidUser"));
        		return ResponseEntity.ok(message);
    		}

    		params.put("orgCode", getUserInfo.get("orgCode"));
    		params.put("grpCode", getUserInfo.get("grpCode"));
    		params.put("deptCode", getUserInfo.get("deptCode"));

    		EgovMap chkQuota = preCcpRegisterService.chkQuota(params);

    		if(chkQuota == null || chkQuota.get("chkQuota").toString().equals("0")){
    			message.setCode(AppConstants.FAIL);
        		message.setMessage(messageAccessor.getMessage("preccp.quotaInsufficient"));
        		return ResponseEntity.ok(message);
    		}

    		params.put("tacNo", getRandomNumber(6));
	    	preCcpRegisterService.insertPreCcpSubmission(params);
	    	message.setCode(AppConstants.SUCCESS);
	    	message.setMessage(messageAccessor.getMessage("preccp.created"));
	    	return ResponseEntity.ok(message);
    	}
    	catch(Exception e){
    		message.setCode(AppConstants.FAIL);
    		message.setMessage(messageAccessor.getMessage("preccp.failCreated"));
    		return ResponseEntity.ok(message);
    	}
  }

   @RequestMapping(value="/chkExistCust.do", method=RequestMethod.GET)
   public ResponseEntity <ReturnMessage> chkExistCust(@RequestParam Map<String, Object>params) {

	   ReturnMessage message = new ReturnMessage();
	   EgovMap getExistCustomer = preCcpRegisterService.getExistCustomer(params);
	   EgovMap getRegisteredCust = preCcpRegisterService.getRegisteredCust(params);

	   message.setCode((getExistCustomer == null && getRegisteredCust ==null) ? AppConstants.FAIL : AppConstants.SUCCESS);
	   message.setMessage((getExistCustomer == null && getRegisteredCust ==null) ? messageAccessor.getMessage("preccp.newCust") : messageAccessor.getMessage("preccp.existCust")  );
	   return ResponseEntity.ok(message);
   }

   @RequestMapping(value="/chkDuplicated.do", method=RequestMethod.GET)
   public ResponseEntity <ReturnMessage> chkDuplicated(@RequestParam Map<String, Object>params){
	   ReturnMessage message = new ReturnMessage();
	   message.setData(preCcpRegisterService.chkDuplicated(params));
	   return ResponseEntity.ok(message);
   }

   @RequestMapping(value = "/selectSmsConsentHistory.do")
   public ResponseEntity<List<EgovMap>> selectSmsConsentHistory(@RequestParam Map<String, Object> params){
	   params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	   return ResponseEntity.ok(preCcpRegisterService.selectSmsConsentHistory(params));
   }

   public String getRandomNumber(int a){
       Random random = new Random();
       char[] chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".toCharArray();
       StringBuilder sb = new StringBuilder();

       for(int i=0; i<a; i++){
           int num = random.nextInt(a);
           sb.append(chars[num]);
       }

       return sb.toString();
   }

   @RequestMapping(value="/newCustomer.do")
   public String newCustomer(SessionVO sessionVO,  ModelMap model){

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

		params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memberType", getUserInfo.get("memberType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
		}

 	  return "sales/preccp/newCustomer";
   }

	@RequestMapping(value = "/consent")
	public String consent(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		model.put("d", params.get("d"));
		return "sales/preccp/consent";
	}

    @RequestMapping(value = "/checkStatus.do")
    public ResponseEntity<EgovMap> checkStatus(@RequestParam Map<String, Object> params){
	   return ResponseEntity.ok(preCcpRegisterService.checkStatus(params));
    }

	//@Transactional
	@RequestMapping(value = "/submitConsent.do", method = RequestMethod.POST)
	 public ResponseEntity<ReturnMessage> submitConsent(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage message = new ReturnMessage();
		int result =0;
		try{
		    boolean flag = ctos(params);
		    if(flag == true){
		    	 result = preCcpRegisterService.submitConsent(params);
		    	 preCcpRegisterService.updateCustomerScore(params);
		    }
			message.setCode(result > 0 ? AppConstants.SUCCESS : AppConstants.FAIL);
    		message.setMessage(result > 0 ? messageAccessor.getMessage("preccp.successConsent") : messageAccessor.getMessage("preccp.failConsent"));
		}
		catch(Exception e){
    		message.setCode(AppConstants.FAIL);
        	message.setMessage(e.getMessage());
		}
		return ResponseEntity.ok(message);
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

			if(getCustInfo.get("smsConsent").toString().equals("1")){
	    		message.setCode(AppConstants.FAIL);
	           	message.setMessage(messageAccessor.getMessage("preccp.existed"));
	           	return ResponseEntity.ok(message);
			}

	    	if(getCustInfo.get("smsCount").toString().equals("0") || compareResult.equals(1)){
	    	   	params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());

	    	   	String smsMessage ="";
    			smsMessage += "COWAY: Authorise Coway to check your credit standing for rental of a Coway appliance. Click ";
    			smsMessage +=  etrustBaseUrl + "/sales/ccp/consent?d=" + getCustInfo.get("tacNo").toString() + params.get("preccpSeq").toString();
    			smsMessage += ", check the box and submit. Thank you.";

           	    SmsVO sms = new SmsVO(349 , 7327);
           	    sms.setMessage(smsMessage);
           	    sms.setMobiles(getCustInfo.get("custMobileno").toString());

           	    SmsResult smsResult = adaptorService.sendSMS3(sms);

           	    params.put("smsId", smsResult.getSmsId());
           	    params.put("statusId", smsResult.getSmsStatus());
           	    params.put("failRsn", smsResult.getFailReason().toString());
           	    params.put("smsId", smsResult.getSmsId());
           	    params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());

           	    preCcpRegisterService.insertSmsHistory(params);

           	    if(smsResult.getSmsStatus() == 4){
	    	   		preCcpRegisterService.updateSmsCount(params);
           	    }

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

   @RequestMapping(value = "/selectPreCcpResult.do")
   public ResponseEntity<List<EgovMap>> selectPreCcpResult(@RequestParam Map<String, Object> params){
	   params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	   return ResponseEntity.ok(preCcpRegisterService.selectPreCcpResult(params));
   }

   @RequestMapping(value = "/selectViewHistory.do")
   public ResponseEntity<List<EgovMap>> selectViewHistory(@RequestParam Map<String, Object> params){
	   params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	   return ResponseEntity.ok(preCcpRegisterService.selectViewHistory(params));
   }

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

	@RequestMapping(value = "/quotaManagement.do")
	public String quotaManagement(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
		params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memberType", sessionVO.getUserTypeId());
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
		}
		return "sales/preccp/quotaManagement";
	}

	@RequestMapping(value="/uploadNewQuota.do")
	public String hpAwardHistoryNewUpload(ModelMap model, SessionVO sessionVO) throws Exception{
		return "sales/preccp/uploadNewQuota";
	}

	@Transactional
	@RequestMapping(value="/submitQuota.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> submitHpAwardHistory(MultipartHttpServletRequest request, SessionVO sessionVO) throws InvalidFormatException, IOException{
		Map<String, Object> response = new HashMap<String, Object>();

		try{
			List<Map<String, String>> result = csvReadComponent.readCsvToList(request.getFile("newUpload"), false, r -> {
				Map<String, String> result2 = new HashMap<String, String>();
				result2.put("managerCode", r.get(0).trim());
				result2.put("year", r.get(1).trim());
				result2.put("month", r.get(2).trim());
				result2.put("quota", r.get(3).trim());
				return result2;
			});

			Map<String, Object> x = new HashMap<String, Object>();
			x.put("managerCode", "Manager Code");
			x.put("year", "Year");
			x.put("month", "Month");
			x.put("quota", "Quota");
			if (!Objects.equal(result.get(0).toString(),  x.toString())){
				response.put("success", 0);
				response.put("msg", messageAccessor.getMessage("preccp.uploadFormatIncorrect"));
				return ResponseEntity.ok(response);
			}

			List<Map<String, Object>> csvData = result.subList(1, result.size()).stream().filter(r-> r.get("managerCode")!=null && r.get("year")!=null && r.get("month")!=null && r.get("quota")!=null).map(r->{
				Map<String, Object> csvRes = new HashMap<String, Object> ();
				csvRes.put("managerCode", r.get("managerCode").toString().trim());
				csvRes.put("year", Integer.parseInt(r.get("year").toString().trim()));
				csvRes.put("month", Integer.parseInt(r.get("month").toString().trim()));
				csvRes.put("quota", Integer.parseInt(r.get("quota").toString().trim()));
				return csvRes;
			}).collect(Collectors.toList());


			if(csvData.size()>0){
				Map <String, Object> param = new HashMap<String, Object>();
				param.put("userId", sessionVO.getUserId());
				param.put("year", csvData.get(0).get("year"));
				param.put("month", csvData.get(0).get("month"));

				EgovMap  chkUpload= preCcpRegisterService.chkUpload(param);
				EgovMap  chkPastMonth= preCcpRegisterService.chkPastMonth(param);

				if(chkUpload != null){
					response.put("success", 0);
					response.put("msg", "Please forfeit this batch " + chkUpload.get("batchId") + " before upload for this month quota.");
					return ResponseEntity.ok(response);
				}

				if(chkPastMonth!=null && chkPastMonth.get("chkPast").toString().equals("1")){
					response.put("success", 0);
					response.put("msg", "Unable to upload for past month quota");
					return ResponseEntity.ok(response);
				}

				int masterResult = 0 , detailsResult= 0 , batchId = 0;
				masterResult = preCcpRegisterService.insertQuotaMaster(param);

				for(Map<String, Object> details : csvData){
					details.put("userId", sessionVO.getUserId());
					detailsResult = preCcpRegisterService.insertQuotaDetails(details);
				}

				batchId = preCcpRegisterService.getCurrVal();
				param.put("id", batchId);
				preCcpRegisterService.updateQuotaMaster(param);
				preCcpRegisterService.updateCurrentOrgCode(param);

				response.put("success", masterResult >0 && detailsResult > 0 ? 1:0);
				response.put("msg", masterResult >0 && detailsResult > 0 ? messageAccessor.getMessage("preccp.uploadSuccess") : messageAccessor.getMessage("preccp.uploadFail"));
				return ResponseEntity.ok(response);

			}else{
				response.put("success", 0);
				response.put("msg", messageAccessor.getMessage("preccp.uploadNoData"));
				return ResponseEntity.ok(response);
			}
		}catch(Throwable e){
			response.put("success", 0);
			response.put("msg", messageAccessor.getMessage("preccp.uploadFormatIncorrect"));
			return ResponseEntity.ok(response);
		}
	}

	@RequestMapping(value="selectQuota.do")
	public ResponseEntity<List<EgovMap>>selectQuota(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(preCcpRegisterService.selectQuota(params));
	}

	@RequestMapping(value="/viewQuota.do")
	public String viewQuota(ModelMap model, SessionVO sessionVO, @RequestParam Map<String, Object> params) throws Exception{
		model.put("request", new Gson().toJson(preCcpRegisterService.selectQuotaDetails(params)));
		return "sales/preccp/viewQuota";
	}

	@RequestMapping(value="/forfeitQuota.do")
	public String forfeitQuota(ModelMap model, SessionVO sessionVO, @RequestParam Map<String, Object> params) throws Exception{
		model.put("batchId", params.get("batchId"));
		return "sales/preccp/forfeitQuota";
	}

   @Transactional
   @RequestMapping(value = "/confirmForfeit.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> confirmForfeit(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
	    params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	    int forfeitResult = 0, updForfeitRemarkResult = 0;
	    ReturnMessage message = new ReturnMessage();
	    try{
	    	forfeitResult = preCcpRegisterService.confirmForfeit(params);
	    	updForfeitRemarkResult = preCcpRegisterService.updateRemark(params);
	    	message.setCode(forfeitResult>0 && updForfeitRemarkResult > 0 ? AppConstants.SUCCESS : AppConstants.FAIL);
	   	    message.setMessage(forfeitResult >0 && updForfeitRemarkResult > 0 ? "Success to forfeit." : "Fail to forfeit.");
		    return ResponseEntity.ok(message);
	    }catch(Throwable e){
	    	message.setCode(AppConstants.FAIL);
	   	    message.setMessage("Fail to forfeit.\n Kindly please raise ticket with it:" + params);
		    return ResponseEntity.ok(message);
	    }
   }

	@RequestMapping(value="selectMonthList.do")
	public ResponseEntity<List<EgovMap>>selectMonthList(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(preCcpRegisterService.selectMonthList(params));
	}

	@RequestMapping(value="selectYearList.do")
	public ResponseEntity<List<EgovMap>>selectYearList(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(preCcpRegisterService.selectYearList(params));
	}

	@RequestMapping(value="selectViewQuotaDetails.do")
	public ResponseEntity<List<EgovMap>>selectViewQuotaDetails(SessionVO sessionVO, @RequestParam Map<String, Object> params){
		return ResponseEntity.ok(preCcpRegisterService.selectViewQuotaDetails(params));
	}

	@RequestMapping(value="/transferQuota.do")
	public String transferQuota(ModelMap model, SessionVO sessionVO, @RequestParam Map<String, Object> params) throws Exception{
		model.put("orgLvlList", new Gson().toJson(preCcpRegisterService.selectOrganizationLevel(params)));
		model.put("requestFrom", params);
		return "sales/preccp/transferQuota";
	}

   @Transactional
   @RequestMapping(value = "/updateTransferQuota.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateTransferQuota(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
	    params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	    int transferResult = 0;
	    ReturnMessage message = new ReturnMessage();
	    try{

	    	transferResult = preCcpRegisterService.confirmTransfer(params);
	    	if(transferResult == -99){
		    	message.setCode(AppConstants.FAIL);
		   	    message.setMessage("No enough quota to be transferred.");
			    return ResponseEntity.ok(message);
	    	}
	    	message.setCode(transferResult > 1 ? AppConstants.SUCCESS : AppConstants.FAIL);
	   	    message.setMessage(transferResult > 1 ? "Success to transfer." : "Fail to transfer.");
		    return ResponseEntity.ok(message);
	    }catch(Throwable e){
	    	message.setCode(AppConstants.FAIL);
	   	    message.setMessage("Fail to transfer.\n Kindly please raise ticket with it:" + params);
		    return ResponseEntity.ok(message);
	    }
   }
}