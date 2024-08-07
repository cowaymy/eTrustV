package com.coway.trust.biz.enquiry.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.enquiry.EnquiryService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.CustomerLoginVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("EnquiryService")
public class EnquiryServiceImpl implements EnquiryService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EnquiryServiceImpl.class);

	@Autowired
	private AdaptorService adaptorService;

    @Resource(name = "EnquiryMapper")
    private EnquiryMapper enquiryMapper;

    @Override
	public EgovMap getCustomerLoginInfo(Map<String, Object> params){
		return enquiryMapper.getCustomerLoginInfo(params);
	}

    @Override
	public void updateLoginSession(Map<String, Object> params){
		 enquiryMapper.updateLoginSession(params);
	}

    @Override
	public void insertErrorLog(Map<String, Object> params){
		 enquiryMapper.insertErrorLog(params);
	}

    @Override
	public int checkDuplicatedLoginSession(Map<String, Object> params){
		return enquiryMapper.checkDuplicatedLoginSession(params);
	}

	@Override
	public CustomerLoginVO getCustomerInfo(Map<String, Object> params) {
		CustomerLoginVO customerLoginVO = enquiryMapper.getCustomerInfo(params);
		return customerLoginVO;
	}

	@Override
	public List<EgovMap> selectCustomerInfoList(Map<String, Object> params) {
		return enquiryMapper.selectCustomerInfoList(params);
	}

	@Override
	public List<EgovMap> selectMagicAddressComboList(Map<String, Object> params) throws Exception {
	    // State
	    if (params.get("state") == null && params.get("city") == null && params.get("postcode") == null) {
	      params.put("colState", "1");
	    }
	    // City
	    if (params.get("state") != null && params.get("city") == null && params.get("postcode") == null) {
	      params.put("colCity", "1");
	    }
	    // Post Code
	    if (params.get("state") != null && params.get("city") != null && params.get("postcode") == null) {
	      params.put("colPostCode", "1");
	    }
	    // Area
	    if (params.get("state") != null && params.get("city") != null && params.get("postcode") != null) {
	      params.put("colArea", "1");
	    }
	    return enquiryMapper.selectMagicAddressComboList(params);
	 }

	 @Override
	 public EgovMap getAreaId(Map<String, Object> params) throws Exception {
	    return enquiryMapper.getAreaId(params);
	 }

	 @Override
	 public List<EgovMap> searchMagicAddressPop(Map<String, Object> params) {
	    return enquiryMapper.searchMagicAddressPop(params);
	 }

	 @Override
	 public int insertNewInstallationAddress(Map<String, Object> params){
	    return enquiryMapper.insertNewInstallationAddress(params);
	 }

	 @Override
	 public int getTacNo(Map<String, Object> params, SessionVO sessionVO) {
	     int smsResultValue = 0;
		 String smsMessage = "";

		 try{
			        String tacNumber = getRandomNumber(6);

			        params.put("tacNo", tacNumber);
			        int result = enquiryMapper.updateTacInfo(params);

			        if(result > 0){
			        	//SMS for customer need to verify throught TAC first before request to update
	    			    smsMessage = "COWAY: Confidential! Never share your temporary TAC.Password: " + tacNumber + ". Kindly keyin your TAC to update your new installation address for Order : " + params.get("orderNo").toString();

	           	        Map<String, Object> smsList = new HashMap<>();
	                    smsList.put("userId", 349);
	                    smsList.put("smsType", 7239);
	                    smsList.put("smsMessage", smsMessage);
	                    smsList.put("smsMobileNo", params.get("mobileNo").toString());

	                    sendSms(smsList);

	                    smsResultValue =1;
			        }else{

			        }

			    }catch(Exception e){
    			    	Map<String, Object> errorParam = new HashMap<>();
    					errorParam.put("pgmPath","/enquiry");
    					errorParam.put("functionName", "getTacNo.do");
    					errorParam.put("errorMsg",e.toString());
    					enquiryMapper.insertErrorLog(errorParam);
			    }finally{

			    }

			return smsResultValue;
	  }

	 @Override
	  public void sendSms(Map<String, Object> smsList){
    	    int userId = 349;
    	    SmsVO sms = new SmsVO(userId , 7239);

    	    sms.setMessage(smsList.get("smsMessage").toString());
    	    sms.setMobiles(smsList.get("smsMobileNo").toString());
    	    //send SMS
    	    SmsResult smsResult = adaptorService.sendSMS(sms);
	  }

	 @Override
	   public EgovMap getCurrentPhoneNo(Map<String, Object> params){
			return enquiryMapper.getCurrentPhoneNo(params);
	  }

	 @Override
	   public EgovMap checkExistRequest(Map<String, Object> params){
			return enquiryMapper.checkExistRequest(params);
	  }


     public String getRandomNumber(int a){
         Random random = new Random();
         char[] chars = "1234567890".toCharArray();
         StringBuilder sb = new StringBuilder();

         for(int i=0; i<a; i++){
             int num = random.nextInt(a);
             sb.append(chars[num]);
         }

         return sb.toString();
     }

     @Override
	   public EgovMap verifyTacNo(Map<String, Object> params){
			return enquiryMapper.verifyTacNo(params);
	  }

     @Override
 	   public void disabledPreviousRequest(Map<String, Object> params){
 		 enquiryMapper.disabledPreviousRequest(params);
 	}

     @Override
	   public EgovMap getEmailDetails(Map<String, Object> params){
			return enquiryMapper.getEmailDetails(params);
	  }

     @Override
	   public EgovMap getSubmissionTimes(Map<String, Object> params){
			return enquiryMapper.getSubmissionTimes(params);
	  }

}
