package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderSuspensionMapper")
public interface OrderSuspensionMapper {

	List<EgovMap> orderSuspensionList(Map<String, Object> params);
	
	EgovMap orderSuspendInfo(Map<String, Object> params);
	
	List<EgovMap> suspendInchargePerson(Map<String, Object> params);
	
	EgovMap reAssignIncharge(Map<String, Object> params);
	
	void updateSusInchargePerson(Map<String, Object> params);
	
	EgovMap reAssignSusUserId(Map<String, Object> params);
	
	List<EgovMap> suspendCallResult(Map<String, Object> params);
	
	List<EgovMap> callResultLog(Map<String, Object> params);
	
	/************************** New Suspend Result ****************************/
	EgovMap newSuspendSearch1(Map<String, Object> params);
	int insertCCR0007DSuspend(Map<String, Object> params);
	EgovMap newSuspendSearch2(Map<String, Object> params);
	int updateCCR0006DSuspend(Map<String, Object> params);
	int updateSAL0096DSuspend(Map<String, Object> params);
	void spInsertOrderReactiveFees(Map<String, Object> params);
	int updateAmtSAL0096D(Map<String, Object> params);
}
