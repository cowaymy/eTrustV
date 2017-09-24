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

import com.coway.trust.biz.sales.order.OrderExchangeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderExchangeService")
public class OrderExchangeServiceImpl extends EgovAbstractServiceImpl implements OrderExchangeService {
	
	private static final Logger logger = LoggerFactory.getLogger(OrderExchangeServiceImpl.class);
	
	@Resource(name = "orderExchangeMapper")
	private OrderExchangeMapper orderExchangeMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
		
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderExchangeList(Map<String, Object> params) {
		return orderExchangeMapper.orderExchangeList(params); 
	}
	
	
	/**
	 * Exchange Information. - Product Exchange Type
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoProduct(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoProduct(params);
	}


	/**
	 * Exchange Information. - Product Exchange Type
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoOwnershipFr(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoOwnershipFr(params);
	}
	
	
	/**
	 * Exchange Information. - Product Exchange Type
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap exchangeInfoOwnershipTo(Map<String, Object> params) {
		return orderExchangeMapper.exchangeInfoOwnershipTo(params);
	}
	
	
	@Override
	public void saveCancelReq(Map<String, Object> params) {
		
		EgovMap firstSearchForCancel = orderExchangeMapper.firstSearchForCancel(params);
		EgovMap secondSearchForCancel = orderExchangeMapper.secondSearchForCancel(params);
		
		logger.info("##### save soExchgId #####" +params.get("soExchgIdDetail"));
		logger.info("##### save soExchgRem #####" +params.get("soExchgRem"));
		logger.info("##### save salesOrderId #####" +params.get("salesOrderId"));
		logger.info("##### save soExchgNwCallEntryId #####" +secondSearchForCancel.get("soExchgNwCallEntryId"));//SO_EXCHG_NW_CALL_ENTRY_ID
		//orderExchangeMapper.updateStusSAL0004D(params);
		
		Map<String, Object> drdExchgMt = new HashMap<String, Object>();
		drdExchgMt.put("soExchgStusId", 10);
		drdExchgMt.put("soExchgUpdUserId", 999999);
		drdExchgMt.put("soExchgRem", "");
		drdExchgMt.put("soExchgRem", "");
		logger.info("##### 2222244444444 soCurStusId #####" +secondSearchForCancel.get("soCurStusId"));
		if(Integer.parseInt(secondSearchForCancel.get("soCurStusId").toString()) == 24){
			logger.info("##### 2222244444444 soCurStusId #####" +secondSearchForCancel.get("soCurStusId"));
		}
		
		
	}
		
}
