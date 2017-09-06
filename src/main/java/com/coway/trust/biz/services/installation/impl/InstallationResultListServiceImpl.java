package com.coway.trust.biz.services.installation.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.TransferController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("installationResultListService")
public class InstallationResultListServiceImpl extends EgovAbstractServiceImpl implements InstallationResultListService{
	private static final Logger logger = LoggerFactory.getLogger(TransferController.class);
	@Resource(name = "installationResultListMapper")
	private InstallationResultListMapper installationResultListMapper;
	
	@Override
	public List<EgovMap> selectApplicationType() {
		return installationResultListMapper.selectApplicationType();
	}
	
	@Override
	public List<EgovMap> selectInstallStatus() {
		return installationResultListMapper.selectInstallStatus();
	}
	
	@Override
	public List<EgovMap> installationResultList(Map<String, Object> params) {
		List<EgovMap> installationList = null;
		logger.debug("params : {}", params);
		if( ! CommonUtils.isEmpty(params.get("dscCode")) && ! CommonUtils.isEmpty(params.get("customerName"))
				|| ! CommonUtils.isEmpty(params.get("dscCode")) && ! CommonUtils.isEmpty(params.get("customerIc"))
				|| ! CommonUtils.isEmpty(params.get("dscCode")) && ! CommonUtils.isEmpty(params.get("sirimNo"))
				|| ! CommonUtils.isEmpty(params.get("dscCode")) && ! CommonUtils.isEmpty(params.get("serialNo"))
		)
		{
			installationList = installationResultListMapper.installationResultList2(params);
		}else{
			installationList = installationResultListMapper.installationResultList(params);
		}
		return installationList;
	}

	@Override
	public EgovMap getInstallResultByInstallEntryID(Map<String, Object> params) {
		return installationResultListMapper.getInstallResultByInstallEntryID(params);
	}
	
	@Override
	public EgovMap getOrderInfo(Map<String, Object> params) {
		return installationResultListMapper.getOrderInfo(params);
	}
	
	@Override
	public EgovMap getcustomerInfo(Object cust_id) {
		return installationResultListMapper.getcustomerInfo(cust_id);
	}

	
	@Override
	public EgovMap getCustomerAddressInfo(Map<String, Object> params) {
		return installationResultListMapper.getCustomerAddressInfo(params);
	}
	
	@Override
	public EgovMap getCustomerContractInfo(Map<String, Object> params) {
		return installationResultListMapper.getCustomerContractInfo(params);
	}
	
	@Override
	public EgovMap getInstallationBySalesOrderID(Map<String, Object> params) {
		return installationResultListMapper.getInstallationBySalesOrderID(params);
	}
	
	@Override
	public EgovMap getInstallContactByContactID(Map<String, Object> params) {
		return installationResultListMapper.getInstallContactByContactID(params);
	}
	
	
	@Override
	public EgovMap getSalesOrderMBySalesOrderID(Map<String, Object> params) {
		return installationResultListMapper.getSalesOrderMBySalesOrderID(params);
	}
	
	@Override
	public EgovMap getMemberFullDetailsByMemberIDCode(Map<String, Object> params) {
		return installationResultListMapper.getMemberFullDetailsByMemberIDCode(params);
	}
	
	@Override
	public List<EgovMap> selectViewInstallation(Map<String, Object> params) {
		return installationResultListMapper.selectViewInstallation(params);
	}
	
	@Override
	public EgovMap selectCallType(Map<String, Object> params) {
		return installationResultListMapper.selectCallType(params);
	}
	
	@Override
	public EgovMap getOrderExchangeTypeByInstallEntryID(Map<String, Object> params) {
		return installationResultListMapper.getOrderExchangeTypeByInstallEntryID(params);
	}
	
}
