package com.coway.trust.biz.sales.trBook.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.trBook.SalesTrBookRecvService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("salesTrBookRecvService")
public class SalesTrBookRecvServiceImpl  extends EgovAbstractServiceImpl implements SalesTrBookRecvService{

	private static final Logger logger = LoggerFactory.getLogger(SalesTrBookRecvServiceImpl.class);
	
	@Resource(name = "salesTrBookRecvMapper")
	private SalesTrBookRecvMapper salesTrBookRecvMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectTrBookRecvList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return salesTrBookRecvMapper.selectTrBookRecvList(params);
	}

	@Override
	public EgovMap selectTransitInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return salesTrBookRecvMapper.selectTransitInfo(params);
	}

	@Override
	public List<EgovMap> selectTransitList(Map<String, Object> params) {
		return salesTrBookRecvMapper.selectTransitList(params);
	}
	
}
