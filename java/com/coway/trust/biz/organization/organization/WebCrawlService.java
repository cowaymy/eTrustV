package com.coway.trust.biz.organization.organization;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface WebCrawlService {


	public List<EgovMap> selectWebCrawlList(Map<String, Object> params);

	void updateLinkStatus(Map<String, Object> params);
}
