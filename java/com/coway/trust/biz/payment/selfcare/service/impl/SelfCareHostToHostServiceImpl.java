package com.coway.trust.biz.payment.selfcare.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.selfcare.service.SelfCareHostToHostService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("selfCareHostToHostService")
public class SelfCareHostToHostServiceImpl extends EgovAbstractServiceImpl implements SelfCareHostToHostService{
	private static final Logger LOGGER = LoggerFactory.getLogger(SelfCareHostToHostServiceImpl.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "selfCareHostToHostMapper")
	private SelfCareHostToHostMapper selfCareHostToHostMapper;

	@Override
	public List<EgovMap> getSelfCareTransactionList(Map<String,Object> params){
		return selfCareHostToHostMapper.getSelfCareTransactionList(params);
	}

	@Override
	public List<EgovMap> getSelfCareTransactionDetails(Map<String,Object> params){
		return selfCareHostToHostMapper.getSelfCareTransactionDetails(params);
	}

	@Override
	public List<EgovMap> getSelfcareBatchDetailReport(Map<String,Object> params){
		return selfCareHostToHostMapper.getSelfcareBatchDetailReport(params);
	}
}
