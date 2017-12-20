package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.GuardianOfComplianceService;
import com.coway.trust.web.organization.organization.ComplianceCallLogController;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("guardianOfComplianceService")
public class GuardianOfComplianceServiceImpl extends EgovAbstractServiceImpl implements GuardianOfComplianceService{
	private static final Logger logger = LoggerFactory.getLogger(ComplianceCallLogController.class);
	@Resource(name = "guardianOfComplianceMapper")
	GuardianOfComplianceMapper guardianOfComplianceMapper;
	@Resource(name = "memberListMapper")
	MemberListMapper memberListMapper;
	
	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> selectGuardianofComplianceList(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectGuardianofComplianceList(params);
	}
	 
	@Override
	public EgovMap  saveGuardian(Map<String, Object> params) {
		
		EgovMap saveView = new EgovMap();	
		
		guardianOfComplianceMapper.saveGuardian(params);
		
		saveView.put("success", true); 
		//saveView.put("massage", messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_SUCC)); 
		
		return saveView;
	}

	@Override
	public List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectSalesOrdNoInfo(params);
	}
	
	@Override
	public EgovMap selectGuardianofComplianceInfo(Map<String, Object> params) {
		return guardianOfComplianceMapper.selectGuardianofComplianceInfo(params);
	}
}
