package com.coway.trust.biz.eAccounting.pettyCash.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.eAccounting.pettyCash.PettyCashService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("pettyCashService")
public class PettyCashServiceImpl implements PettyCashService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;
	
	@Resource(name = "pettyCashMapper")
	private PettyCashMapper pettyCashMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectCustodianList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectCustodianList(params);
	}

	@Override
	public String selectUserNric(int userId) {
		// TODO Auto-generated method stub
		return pettyCashMapper.selectUserNric(userId);
	}

	@Override
	public void insertCustodian(Map<String, Object> params) {
		// TODO Auto-generated method stub
		pettyCashMapper.insertCustodian(params);
	}
	
	

}
