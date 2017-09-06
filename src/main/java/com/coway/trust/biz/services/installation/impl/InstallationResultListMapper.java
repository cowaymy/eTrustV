package com.coway.trust.biz.services.installation.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("installationResultListMapper")
public interface InstallationResultListMapper {

	List<EgovMap> selectApplicationType();
	
	List<EgovMap>  selectInstallStatus();
	
	List<EgovMap>  installationResultList(Map<String, Object> params);

	List<EgovMap> installationResultList2(Map<String, Object> params);
	
	EgovMap getInstallResultByInstallEntryID(Map<String, Object> params);
	
	EgovMap getOrderInfo(Map<String, Object> params);
	
	EgovMap getcustomerInfo(Object cust_id);
	
	EgovMap getCustomerAddressInfo(Map<String, Object> params);
	
	EgovMap getCustomerContractInfo(Map<String, Object> params);
	
	EgovMap getInstallationBySalesOrderID(Map<String, Object> params);
	
	EgovMap getInstallContactByContactID(Map<String, Object> params);
	
	EgovMap getSalesOrderMBySalesOrderID(Map<String, Object> params);
	
	EgovMap getMemberFullDetailsByMemberIDCode(Map<String, Object> params);
	
	List<EgovMap>  selectViewInstallation(Map<String, Object> params);
	
	EgovMap selectCallType(Map<String, Object> params);
	
	EgovMap getOrderExchangeTypeByInstallEntryID(Map<String, Object> params);
}
