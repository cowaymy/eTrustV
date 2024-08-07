package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderLedgerService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderLedgerService")
public class OrderLedgerServiceImpl  extends EgovAbstractServiceImpl implements OrderLedgerService{

	private static final Logger logger = LoggerFactory.getLogger(OrderLedgerServiceImpl.class);
	
	@Resource(name = "orderLedgerMapper")
	private OrderLedgerMapper orderLedgerMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	public EgovMap selectOrderLedgerView(Map<String, Object> params) {
		return orderLedgerMapper.selectOrderLedgerView(params);
	}
	public EgovMap selectInsInfo(Map<String, Object> params) {
		return orderLedgerMapper.selectInsInfo(params);
	}
	public EgovMap selectMailInfo(Map<String, Object> params) {
		return orderLedgerMapper.selectMailInfo(params);
	}
	public EgovMap selectSalesInfo(Map<String, Object> params) {
		return orderLedgerMapper.selectSalesInfo(params);
	}
	@Override
	public List<EgovMap> getOderLdgr(Map<String, Object> params) {
		orderLedgerMapper.getOderLdgr(params);
				
		return (List<EgovMap>) params.get("p1");
	}
	@Override
	public List<EgovMap> getOderLdgr2(Map<String, Object> params) {
		orderLedgerMapper.getOderLdgr2(params);
		
		return (List<EgovMap>) params.get("p1");
	}
	@Override
	public List<EgovMap> getOderOutsInfo(Map<String, Object> params) {
		 orderLedgerMapper.getOderOutsInfo(params);
		
		 return (List<EgovMap>) params.get("p1");
	}
	@Override
	public List<EgovMap> selectAgreInfo(Map<String, Object> params) {
		return orderLedgerMapper.selectAgreInfo(params);		
	}
	@Override
	public List<EgovMap> selectPaymentDetailViewCndn(Map<String, Object> param) {
		return orderLedgerMapper.selectPaymentDetailViewCndn(param);
	}
	@Override
	public List<EgovMap> selectPaymentDetailView(Map<String, Object> param) {
		return orderLedgerMapper.selectPaymentDetailView(param);
	}
	@Override
	public EgovMap selectPayInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderLedgerMapper.selectPayInfo(params);
	}
	
}
