package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.MainNoticeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("MainNoticeService")
public class MainNoticeServiceImpl extends EgovAbstractServiceImpl implements MainNoticeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MainNoticeServiceImpl.class);

	@Resource(name = "MainNoticeMapper")
	private MainNoticeMapper mainNoticeMapper;

	@Override
	public List<EgovMap> selectDailyCount(Map<String, Object> params) {
		LOGGER.debug("ServiceImple MainNotice Info");
		return mainNoticeMapper.selectDailyCount(params);
	}

	@Override
	public List<EgovMap> getMainNotice(Map<String, Object> params) {
		LOGGER.debug("getMainNotice");
		return mainNoticeMapper.selectMainNotice(params);
	}

	@Override
	public List<EgovMap> getTagStatus(Map<String, Object> params) {
		return mainNoticeMapper.selectTagStatus(params);
	}

	@Override
	public List<EgovMap> getDailyPerformance(Map<String, Object> params) {
		return mainNoticeMapper.selectDailyPerformance(params);
	}

}
