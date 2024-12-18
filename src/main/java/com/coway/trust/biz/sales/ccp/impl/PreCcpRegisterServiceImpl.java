package com.coway.trust.biz.sales.ccp.impl;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.WhatappsApiService;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.PreCcpRegisterService;
import com.coway.trust.biz.sales.order.impl.OrderLedgerMapper;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;


@Service("preCcpRegisterService")
public class PreCcpRegisterServiceImpl extends EgovAbstractServiceImpl implements PreCcpRegisterService {

	private static final Logger LOGGER = LoggerFactory.getLogger(PreCcpRegisterServiceImpl.class);

	@Resource(name = "preCcpRegisterMapper")
	private PreCcpRegisterMapper preCcpRegisterMapper;

	@Resource(name = "orderLedgerMapper")
	private OrderLedgerMapper orderLedgerMapper;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private WhatappsApiService whatappsApiService;

	@Value("${watapps.api.button.pre.ccp.template}")
	 private String waApiBtnPreCCPTemplate;

	@Override
	@Transactional
	public int insertPreCcpSubmission(Map<String, Object> params) throws Exception {
	    int result= preCcpRegisterMapper.insertPreCcpSubmission(params);
	    return result;
	}

	@Override
	public EgovMap getExistCustomer(Map<String, Object> params) {
		return preCcpRegisterMapper.getExistCustomer(params);
	}

    @Override
	public List<EgovMap> searchOrderSummaryList(Map<String, Object> params) {
	    return preCcpRegisterMapper.searchOrderSummaryList(params);
	}

    @Override
    public Map<String, Object> insertNewCustomerInfo(Map<String, Object> params) {
		return preCcpRegisterMapper.insertNewCustomerInfo(params);
    }

    @Override
    public void updateCcrisScre(Map<String, Object> params) {
		 preCcpRegisterMapper.updateCcrisScre(params);
    }

    @Override
    public void updateCcrisId(Map<String, Object> params) {
		 preCcpRegisterMapper.updateCcrisId(params);
    }

    @Override
    public Map<String, Object> insertNewCustomerDetails(Map<String, Object> params) {
		return preCcpRegisterMapper.insertNewCustomerDetails(params);
    }

	@Override
	public EgovMap getPreccpResult(Map<String, Object> params) {
		return preCcpRegisterMapper.getPreccpResult(params);
	}

	@Override
	public List<EgovMap> getPreCcpRemark(Map<String, Object> params) {
	    return preCcpRegisterMapper.getPreCcpRemark(params);
	}

	@Override
	public List<EgovMap> getCustCredibility(Map<String, Object> params) {
		return preCcpRegisterMapper.getCustCredibility(params);
	}

	@Override
	public List<EgovMap> getExistCustChs(Map<String, Object> params) {
		return preCcpRegisterMapper.getExistCustChs(params);
	}

	@Override
	@Transactional
	public int editRemarkRequest(Map<String, Object> params) throws Exception {
	    int result= preCcpRegisterMapper.editRemarkRequest(params);
	    return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void editCCPRemark(Map<String, ArrayList<Object>> params, int userId){
	    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);
	    List<Object> updateExistCustList = params.get("updateExistCust");

	    // TODAY
	    Calendar calendar = Calendar.getInstance();
	    calendar.set(Calendar.HOUR_OF_DAY, 23);
	    calendar.set(Calendar.MINUTE, 59);
	    calendar.set(Calendar.SECOND, 59);
	    calendar.set(Calendar.MILLISECOND, 999);
	    Date today = calendar.getTime();

	    //TOMORROW
	    Calendar calendar1 = Calendar.getInstance();
	    calendar1.add(Calendar.DATE, 1);
	    calendar1.set(Calendar.HOUR_OF_DAY, 0);
	    calendar1.set(Calendar.MINUTE, 0);
	    calendar1.set(Calendar.SECOND, 0);
	    calendar1.set(Calendar.MILLISECOND, 0);
	    Date tomorrow = calendar1.getTime();

	    // FUTURE
	    Calendar calendar2 = Calendar.getInstance();
	    calendar2.set(Calendar.YEAR, 9999);
	    calendar2.set(Calendar.MONTH, 11);
	    calendar2.set(Calendar.DATE, 31);
	    calendar2.set(Calendar.HOUR_OF_DAY, 23);
	    calendar2.set(Calendar.MINUTE, 59);
	    calendar2.set(Calendar.SECOND, 59);
	    calendar2.set(Calendar.MILLISECOND, 999);
	    Date future = calendar2.getTime();

	    if(updateList != null){
	        updateList.forEach(r -> {
	          ((Map<String, Object>) r).put("userId", userId);

	          //=========================================
	    	  // EXISTING CUSTOMER CREDIBILITY
	    	  //=========================================
	          ((Map<String, Object>) r).put("oldEndDate", today);
	          preCcpRegisterMapper.editCCPRemark((Map<String, Object>) r);

	         //=========================================
	    	 // NEW EDITED CUSTOMER CREDIBILITY
	    	 //=========================================
	    	  ((Map<String, Object>) r).put("newStartDate", tomorrow);
	          ((Map<String, Object>) r).put("newEndDate", future);

	          //INSERT NEW EDITED RECORD
	          preCcpRegisterMapper.insertCCPRemark((Map<String, Object>) r);
	        });
	    }

	    if(updateExistCustList != null){
	    	updateExistCustList.forEach(r -> {
	    		((Map<String, Object>) r).put("userId", userId);

    	        //=========================================
    	    	// EXISTING CHS STUS
    	    	//=========================================
    	        // SET END DATE - OLD CHS STUS (today)
    	        ((Map<String, Object>) r).put("oldEndDate", today);
    	        preCcpRegisterMapper.editCCPRemark((Map<String, Object>) r);

    	        //=========================================
    	    	// NEW EDITED CHS STUS
    	    	//=========================================
    	    	((Map<String, Object>) r).put("newStartDate", tomorrow);
    	        ((Map<String, Object>) r).put("newEndDate", future);

    	        //INSERT NEW EDITED RECORD
    	        preCcpRegisterMapper.insertCCPRemark((Map<String, Object>) r);
	    	});
	    }
	}

	@Override
	public EgovMap getCustCreditInfo(Map<String, Object> params) {
		return preCcpRegisterMapper.getCustCreditInfo(params);
	}

	 @Override
	 public List<EgovMap> getExistUnitHist(Map<String, Object> params){
		 List<EgovMap> result = preCcpRegisterMapper.getExistUnitHist(params);

		 if(result != null){
			 result.forEach(r -> {
				 	orderLedgerMapper.getOderOutsInfo((Map<String, Object>) r);

				 	List<EgovMap> data = (List<EgovMap>) r.get("p1");
				 	r.put("ordTotOtstnd", data.get(0).get("ordTotOtstnd"));
				 	r.put("ordOtstndMth", data.get(0).get("ordOtstndMth"));
				 	r.put("ordUnbillAmt", data.get(0).get("ordUnbillAmt"));
				 	r.put("totPnaltyChrg", data.get(0).get("totPnaltyChrg"));
		    	});
		 }

		 return result;
	 }

	 @Override
	 public List<EgovMap> getNewProdElig(Map<String, Object> params){
		 return preCcpRegisterMapper.getNewProdElig(params);
	 }

	@Override
	@Transactional
	public int insertRemarkRequest(Map<String, Object> params)  {
	    int result= preCcpRegisterMapper.insertRemarkRequest(params);
	    return result;
	}

	@Override
	public EgovMap chkDuplicated(Map<String, Object> params) {
		return preCcpRegisterMapper.chkDuplicated(params);
	}

	@Override
	public EgovMap getRegisteredCust(Map<String, Object> params) {
		return preCcpRegisterMapper.getRegisteredCust(params);
	}

	@Override
	public List<EgovMap> selectSmsConsentHistory(Map<String, Object> params){
		return preCcpRegisterMapper.selectSmsConsentHistory(params);
	}

	@Override
	public void updateSmsCount(Map<String, Object> params){
		preCcpRegisterMapper.updateSmsCount(params);
	}

	@Override
	public EgovMap chkSendSmsValidTime(Map<String, Object> params) {
		return preCcpRegisterMapper.chkSendSmsValidTime(params);
	}

	@Override
	public int resetSmsConsent(){
		return preCcpRegisterMapper.resetSmsConsent();
	}

	@Override
	public EgovMap chkSmsResetFlag(){
		return preCcpRegisterMapper.chkSmsResetFlag();
	}

	@Override
	public void updateResetFlag(Map<String, Object> params){
		preCcpRegisterMapper.updateResetFlag(params);
	}

	@Override
	public EgovMap getCustInfo(Map<String, Object> params){
		return preCcpRegisterMapper.getCustInfo(params);
	}

	@Override
	public void insertSmsHistory(Map<String, Object> params){
		preCcpRegisterMapper.insertSmsHistory(params);
	}

	@Override
	public int submitConsent(Map<String, Object> params){
		return preCcpRegisterMapper.submitConsent(params);
	}

	@Override
	public void updateCustomerScore(Map<String, Object> params){
		preCcpRegisterMapper.updateCustomerScore(params);
	}

	@Override
	public EgovMap checkStatus(Map<String, Object> params){
		return preCcpRegisterMapper.checkStatus(params);
	}

	@Override
	public List<EgovMap> selectPreCcpResult(Map<String, Object> params){
		return preCcpRegisterMapper.selectPreCcpResult(params);
	}

	@Override
	public List<EgovMap> selectViewHistory(Map<String, Object> params){
		return preCcpRegisterMapper.selectViewHistory(params);
	}

	@Override
	public int insertQuotaMaster(Map<String, Object>params){
		return preCcpRegisterMapper.insertQuotaMaster(params);
	}

	@Override
	public int getCurrVal(){
		return preCcpRegisterMapper.getCurrVal();
	}

	@Override
	public int insertQuotaDetails(Map<String, Object>params){
		return preCcpRegisterMapper.insertQuotaDetails(params);
	}

	@Override
	public void updateQuotaMaster(Map<String, Object> params){
		preCcpRegisterMapper.updateQuotaMaster(params);
	}

	@Override
	public void updateCurrentOrgCode(Map<String, Object> params){
		preCcpRegisterMapper.updateCurrentOrgCode(params);
	}

	@Override
	public List<EgovMap> selectQuota(Map<String, Object> params){
		return preCcpRegisterMapper.selectQuota(params);
	}

	@Override
	public List<EgovMap> selectQuotaDetails(Map<String, Object> params){
		return preCcpRegisterMapper.selectQuotaDetails(params);
	}

	@Override
	public int confirmForfeit(Map<String, Object> params){
		return preCcpRegisterMapper.confirmForfeit(params);
	}

	@Override
	public int updateRemark(Map<String, Object> params){
		return preCcpRegisterMapper.updateRemark(params);
	}

	@Override
	public EgovMap chkUpload(Map<String, Object> params){
		return preCcpRegisterMapper.chkUpload(params);
	}

	@Override
	public EgovMap chkPastMonth(Map<String, Object> params){
		return preCcpRegisterMapper.chkPastMonth(params);
	}

	@Override
	public EgovMap chkQuota(Map<String, Object> params){
		return preCcpRegisterMapper.chkQuota(params);
	}

	@Override
	public List<EgovMap> selectYearList(Map<String, Object> params){
		return preCcpRegisterMapper.selectYearList(params);
	}

	@Override
	public List<EgovMap> selectMonthList(Map<String, Object> params){
		return preCcpRegisterMapper.selectMonthList(params);
	}

	@Override
	public List<EgovMap> selectViewQuotaDetails(Map<String, Object> params){
		return preCcpRegisterMapper.selectViewQuotaDetails(params);
	}

	@Override
	public List<EgovMap> selectOrganizationLevel(Map<String, Object> params){
		return preCcpRegisterMapper.selectOrganizationLevel(params);
	}

	@Override
	public int confirmTransfer(Map<String, Object> params){

		int transferOut = 0 , transferIn = 0;

		List<Map<String,Object>> chkList = (List<Map<String, Object>>) params.get("editList");
		int sum = chkList.stream().map(d -> Integer.parseInt(d.get("transferQuota").toString())).collect(Collectors.summingInt(Integer::intValue));
		params.put("chkQuota", sum);
		EgovMap chkAvailableQuota = preCcpRegisterMapper.chkAvailableQuota(params);
		if(chkAvailableQuota.get("balance").toString().equals("0")){
			return -99;
		}

		for(Map<String,Object> editDetails : (List<Map<String,Object>>) params.get("editList")){

			int linkId = preCcpRegisterMapper.getSeqSAL0356D();
			//Transfer Out
			Map<String, Object> editMap = new HashMap<String, Object>();
			editMap.put("orgCode", params.get("orgCode"));
			editMap.put("grpCode", params.get("grpCode"));
			editMap.put("transferQuota", Integer.parseInt(editDetails.get("transferQuota").toString()) * -1);
			editMap.put("year", params.get("year"));
			editMap.put("month", params.get("month"));
			editMap.put("userId", params.get("userId"));
			editMap.put("linkId", linkId);
			transferOut = preCcpRegisterMapper.confirmTransfer(editMap);

			//Received
			editDetails.put("year", params.get("year"));
			editDetails.put("month", params.get("month"));
			editDetails.put("userId", params.get("userId"));
			editDetails.put("linkId", linkId);
			transferIn = preCcpRegisterMapper.confirmTransfer(editDetails);
		}

		return (transferOut + transferIn);
	}

	@Override
	public EgovMap currentUser(Map<String, Object> params){
		return preCcpRegisterMapper.currentUser(params);
	}

	@Override
	public int getSeqSAL0343D(){
		return preCcpRegisterMapper.getSeqSAL0343D();
	}

	@Override
	public EgovMap chkSmsResult(Map<String, Object> params){
		return preCcpRegisterMapper.chkSmsResult(params);
	}

	@Override
	public EgovMap checkNewCustomerResult(Map<String, Object> params){
		return preCcpRegisterMapper.checkNewCustomerResult(params);
	}

	@Override
	public EgovMap chkAvailableQuota(Map<String, Object> params){
		return preCcpRegisterMapper.chkAvailableQuota(params);
	}

	@Transactional
	@Override
	public ReturnMessage sendWhatsApp(Map<String, Object> params) {

		ReturnMessage message = new ReturnMessage();

		try {

			EgovMap chkTime = chkSendSmsValidTime(params);
			BigDecimal defaultValidTime = new BigDecimal("5"),
					latestSendSmsTime = new BigDecimal(chkTime.get("chkTime").toString());
			;
			Integer compareResult = latestSendSmsTime.compareTo(defaultValidTime);
			EgovMap getCustInfo = getCustInfo(params);

			if (getCustInfo.get("smsConsent").toString().equals("1")) {
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage("preccp.existed"));
				return message;
			}

			if (getCustInfo.get("smsCount").toString().equals("0") || compareResult.equals(1)) {

				String telno = getCustInfo.get("custMobileno").toString();
				String templateName = waApiBtnPreCCPTemplate;
				String payload = "=" + getCustInfo.get("tacNo").toString() + params.get("preccpSeq").toString();
				String path = "sales/ccp/consent";
				String imageUrl = "https://iili.io/dxKWRkJ.jpg";

				Map<String, Object> param = new HashMap<>();
				param.put("telno", telno);
				param.put("templateName", templateName);
				param.put("language", AppConstants.LANGUAGE_EN);
				param.put("payload", payload);
				param.put("path", path);
				param.put("imageUrl", imageUrl);

				Map<String, Object> waResult = whatappsApiService.setWaTemplateConfiguration(param);

				if (waResult.get("status").toString() == "00") {
					updateSmsCount(params);
				}
				message.setCode(waResult.get("status") == "00" ? AppConstants.SUCCESS : AppConstants.FAIL);
				message.setMessage(waResult.get("status") == "00" ? messageAccessor.getMessage("preccp.doneWhatsApp")
						: messageAccessor.getMessage("preccp.failWhatsApp"));
				return message;

			} else {
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage("preccp.retryWhatsApp"));
				return message;
			}
		} catch (Exception e) {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage("preccp.failWhatsApp"));
			return message;
		}

	}
}