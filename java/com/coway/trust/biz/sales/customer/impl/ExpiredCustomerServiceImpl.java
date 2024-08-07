package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.customer.ExpiredCustomerService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("expiredCustomerService")
public class ExpiredCustomerServiceImpl extends EgovAbstractServiceImpl implements ExpiredCustomerService {

	@Resource(name = "expiredCustomerMapper")
	private ExpiredCustomerMapper expiredCustomerMapper;

	  @Override
	  public List<EgovMap> selectExpiredCustomerList(Map<String, Object> params) {

		  return expiredCustomerMapper.selectExpiredCustomerList(params);
	  }
}
