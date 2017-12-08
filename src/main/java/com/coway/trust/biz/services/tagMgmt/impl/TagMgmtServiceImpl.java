package com.coway.trust.biz.services.tagMgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.servicePlanning.HolidayService;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("tagMgmtService")
public class TagMgmtServiceImpl implements TagMgmtService {

	private static final Logger logger = LoggerFactory.getLogger(HolidayService.class);
	
	@Resource(name = "tagMgmtMapper")
	private TagMgmtMapper tagMgmtMapper;

	@Override
	public List<EgovMap> getTagStatus(Map<String, Object> params) {
		
		return tagMgmtMapper.selectTagStatus(params);
	}
	
	
}
