package com.coway.trust.biz.sales.ccp.impl;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

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
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.PreCcpRegisterService;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import com.coway.trust.cmmn.model.SessionVO;


@Service("preCcpRegisterService")
public class PreCcpRegisterServiceImpl extends EgovAbstractServiceImpl implements PreCcpRegisterService {

	private static final Logger LOGGER = LoggerFactory.getLogger(PreCcpRegisterServiceImpl.class);

	@Resource(name = "preCcpRegisterMapper")
	private PreCcpRegisterMapper preCcpRegisterMapper;


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
	@Transactional
	public int editRemarkRequest(Map<String, Object> params) throws Exception {
	    int result= preCcpRegisterMapper.editRemarkRequest(params);
	    return result;
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


}