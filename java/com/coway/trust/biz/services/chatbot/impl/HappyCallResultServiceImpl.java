package com.coway.trust.biz.services.chatbot.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.chatbot.HappyCallResultService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("happyCallResultService")
public class HappyCallResultServiceImpl implements HappyCallResultService{

	private static final Logger LOGGER = LoggerFactory.getLogger(HappyCallResultServiceImpl.class);

	@Resource(name = "happyCallResultMapper")
	private HappyCallResultMapper happyCallResultMapper;


	@Override
	public List<EgovMap> selectHappyCallType() {
		// TODO Auto-generated method stub
		return happyCallResultMapper.selectHappyCallType();
	}

	@Override
    public List<EgovMap> selectHappyCallResultList(Map<String, Object> params) {
		LOGGER.debug("selectHappyCallResultList=====================================>>  " + params);
		if(params.get("isAc") != null && params.get("isAc").equals("1")){
			params.put("memTyp", "3"); // ACI = memType = 3
		}
        return happyCallResultMapper.selectHappyCallResultList(params);
    }

	@Override
	public List<EgovMap> selectHappyCallResultHistList(Map<String, Object> params) {
		LOGGER.debug("selectHappyCallResultHistList=====================================>>  " + params);
		if(params.get("isAc") != null && params.get("isAc").equals("1")){
			params.put("memTyp", "3"); // ACI = memType = 3
		}
		return happyCallResultMapper.selectHappyCallResultHistList(params);
	}

	@Override
	public EgovMap getUserInfo(Map<String, Object> params) {
		LOGGER.debug("getUserInfo=====================================>>  " + params);
		return happyCallResultMapper.getUserInfo(params);
	}

}
