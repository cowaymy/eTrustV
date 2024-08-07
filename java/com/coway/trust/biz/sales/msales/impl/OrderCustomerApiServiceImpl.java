package com.coway.trust.biz.sales.msales.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.sales.registerCustomer.RegCustomerForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.msales.OrderCustomerApiService;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("OrderCustomerApiService")
public class OrderCustomerApiServiceImpl extends EgovAbstractServiceImpl implements OrderCustomerApiService{

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "OrderCustomerApiMapper")
	private OrderCustomerApiMapper orderCustomerApiMapper;
	
	@Autowired
	private LoginMapper loginMapper;
	
	@Override
	public EgovMap orderCustInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return orderCustomerApiMapper.orderCustInfo(params);
	}
	
	@Override
	public void insertCustomer(RegCustomerForm regCustomerForm){
		
		Map<String, Object> params =  RegCustomerForm.createMap(regCustomerForm);
		
		params.put("_USER_ID", regCustomerForm.getLoginUserName());
		
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		
		int custIdSeq = orderCustomerApiMapper.custIdSeq(); 
		params.put("crtUserId", loginVO.getUserId());
		params.put("custIdSeq", custIdSeq);
		orderCustomerApiMapper.insertCustomer(params);
		orderCustomerApiMapper.insertContactInfo(params);
		orderCustomerApiMapper.insertCareContactInfo(params);
		
	}
}
