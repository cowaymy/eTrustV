package com.coway.trust.biz.services.tagMgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TagMgmtService {

	List<EgovMap> getTagStatus(Map<String, Object> params);
	

}
