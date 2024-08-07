package com.coway.trust.biz.common.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.coway.trust.AppConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
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
	@Cacheable(value = AppConstants.PERIODICAL_CACHE)
	public List<EgovMap> selectDailyCount(Map<String, Object> params) {
		LOGGER.debug("ServiceImple MainNotice Info");
		return mainNoticeMapper.selectDailyCount(params);
	}

	@Override
	@CacheEvict(value = AppConstants.PERIODICAL_CACHE, allEntries = true)
	public void removeCache() {
		LOGGER.debug("removeCache");
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

	@Override
    public List<EgovMap> getSalesOrgPerf(Map<String, Object> params) {
        LOGGER.debug("getSalesOrgPerf");
        return mainNoticeMapper.selectSalesOrgPerf(params);
    }

	@Override
	public List<EgovMap> getCustomerBday(Map<String, Object> params) {
	    return mainNoticeMapper.getCustomerBday(params);
	}

	 @Override
	  public List<EgovMap> getAccRewardPoints(Map<String, Object> params) {
	      return mainNoticeMapper.getAccRewardPoints(params);
	  }

	@Override
	public List<EgovMap> getHPBirthday(Map<String, Object> params) {
		Map<String, Object> pMap = new HashMap<String, Object>();
		pMap.put("roleId", params.get("roleId"));
		pMap.put("userId", params.get("userId"));
		pMap.put("isHmBday", params.get("isHmBday"));

		return mainNoticeMapper.getHPBirthday(pMap);
	}

}
