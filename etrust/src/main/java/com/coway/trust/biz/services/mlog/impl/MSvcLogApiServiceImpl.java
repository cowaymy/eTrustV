package com.coway.trust.biz.services.mlog.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("MSvcLogApiService")
public class MSvcLogApiServiceImpl extends EgovAbstractServiceImpl implements MSvcLogApiService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "MSvcLogApiMapper")
	private MSvcLogApiMapper MSvcLogApiMapper;
	
	@Override
	public List<EgovMap> getHeartServiceJobList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getHeartServiceJobList(params);
	}

	@Override
	public List<EgovMap> getAfterServiceJobList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MSvcLogApiMapper.getAfterServiceJobList(params);
	}

	@Override
	public List<EgovMap> heartServiceResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}
	
	
	
	
	
	
	
	
	
}
