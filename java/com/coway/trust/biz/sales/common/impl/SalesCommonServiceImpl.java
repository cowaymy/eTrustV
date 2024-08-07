package com.coway.trust.biz.sales.common.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.common.SalesCommonService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("salesCommonService")
public class SalesCommonServiceImpl extends EgovAbstractServiceImpl implements SalesCommonService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SalesCommonServiceImpl.class);

	@Resource(name = "salesCommonMapper")
	private SalesCommonMapper salesCommonMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 */
	@Override
	public EgovMap getUserInfo(Map<String, Object> params) {

		return salesCommonMapper.getUserInfo(params);
	}

	@Override
	public EgovMap getUserBranchType(Map<String, Object> params) {
		return salesCommonMapper.getUserBranchType(params);
	}


}
