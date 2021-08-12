package com.coway.trust.biz.common.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.ReportBatchService;

@Service("reportBatchService")
public class ReportBatchServiceImpl implements ReportBatchService {

	@Autowired
	private ReportBatchMapper reportBatchMapper;

	@SuppressWarnings("unchecked")
	@Override
	@CacheEvict(value = AppConstants.LEFT_MENU_CACHE, allEntries = true)
	public void insertLog(Map<String, Object> params) {
	  reportBatchMapper.insertLog(params);
	}
}
