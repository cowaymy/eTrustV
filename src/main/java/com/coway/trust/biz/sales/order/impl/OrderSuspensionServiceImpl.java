package com.coway.trust.biz.sales.order.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderSuspensionService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderSuspensionService")
public class OrderSuspensionServiceImpl extends EgovAbstractServiceImpl implements OrderSuspensionService{
	
	private static final Logger logger = LoggerFactory.getLogger(OrderSuspensionServiceImpl.class);

	@Resource(name = "orderSuspensionMapper")
	private OrderSuspensionMapper orderSuspensionMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param 
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderSuspensionList(Map<String, Object> params) {
		return orderSuspensionMapper.orderSuspensionList(params);
	}
	
	
	/**
	 * Suspension Information.
	 * 
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	@Override
	public EgovMap orderSuspendInfo(Map<String, Object> params) {
		return orderSuspensionMapper.orderSuspendInfo(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param 
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> suspendInchargePerson(Map<String, Object> params) {
		return orderSuspensionMapper.suspendInchargePerson(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param 
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> suspendCallResult(Map<String, Object> params) {
		return orderSuspensionMapper.suspendCallResult(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param 
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> callResultLog(Map<String, Object> params) {
		return orderSuspensionMapper.callResultLog(params);
	}
	
	
	@Override
	public void newSuspendResult(Map<String, Object> params) {
		String defaultDate = "1900-01-01 00:00:00";
		
		EgovMap newSuspendSearch1 = orderSuspensionMapper.newSuspendSearch1(params);
		
		Map<String, Object> saveParam = new HashMap<String, Object>();
		
		saveParam.put("callEntryId", newSuspendSearch1.get("callEntryId"));
		saveParam.put("callStusId", params.get("newSuspResultStus"));
//		saveParam.put("callDt", defaultDate);
//		saveParam.put("callActnDt", defaultDate);
		saveParam.put("callFdbckId", 0);
		saveParam.put("callCtId", 0);
		saveParam.put("callRem", params.get("newSuspResultRem"));
		//saveParam.put("callCrtUserId", params.get("userId"));
		saveParam.put("callCrtUserId", 999999);
		saveParam.put("callCrtUserIdDept", 0);
		saveParam.put("callHcId", 0);
		saveParam.put("callRosAmt", 0);
		saveParam.put("callSms", 0);
		saveParam.put("callSmsRem", " ");
		logger.info("##### Impl.getUserId() #####" +params.get("userId"));
		orderSuspensionMapper.insertCCR0007DSuspend(saveParam);
		
		EgovMap newSuspendSearch2 = orderSuspensionMapper.newSuspendSearch2(saveParam);
		saveParam.put("stusCodeId", newSuspendSearch2.get("stusCodeId"));
		saveParam.put("resultId", newSuspendSearch2.get("resultId"));
		//saveParam.put("updUserId", params.get("userId"));
		saveParam.put("updUserId", 999999);
		
		orderSuspensionMapper.updateCCR0006DSuspend(saveParam);
		
		saveParam.put("susId", params.get("susId"));
		
		orderSuspensionMapper.updateSAL0096DSuspend(saveParam);
	}
	
}
