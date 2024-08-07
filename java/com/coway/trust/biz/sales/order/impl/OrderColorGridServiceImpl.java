package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderColorGridService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderColorGridService")
public class OrderColorGridServiceImpl extends EgovAbstractServiceImpl implements OrderColorGridService{

	private static final Logger logger = LoggerFactory.getLogger(OrderColorGridServiceImpl.class);

	@Resource(name = "orderColorGridMapper")
	private OrderColorGridMapper orderColorGridMapper;

	public List<EgovMap> colorGridList(Map<String, Object> params) {
		return orderColorGridMapper.colorGridList(params);
	}

	public List<EgovMap> colorGridCmbProduct() {
		return orderColorGridMapper.colorGridCmbProduct();
	}

	public String  getMemID(Map<String, Object> params) {
		return orderColorGridMapper.getMemID(params);
	}

}
