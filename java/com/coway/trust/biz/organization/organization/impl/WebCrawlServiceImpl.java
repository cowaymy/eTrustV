package com.coway.trust.biz.organization.organization.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.WebCrawlService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.WebCrawlController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("webCrawlService")
public class WebCrawlServiceImpl extends EgovAbstractServiceImpl implements WebCrawlService{
	@Resource(name = "webCrawlMapper")
	WebCrawlMapper webCrawlMapper;

	@Override
	public List<EgovMap> selectWebCrawlList(Map<String, Object> params) {
		System.out.print("heyy");
		System.out.print(params);
		return webCrawlMapper.selectWebCrawlList(params);
	}

	@Override
	public void updateLinkStatus(Map<String, Object> params) {
		int updated = 0;
		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);

		int updator =  (int) params.get("updator");
    	if (updateItemList.size() > 0) {
			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
				updateMap.put("updator", updator);
				System.out.print(updateMap);
				webCrawlMapper.updateLinkStatus(updateMap); ;
			}
		}

	}

}
