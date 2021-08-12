package com.coway.trust.biz.homecare.po;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcItemSearchPopService {

	// main List 조회
	public List<EgovMap> selectHcItemSearch(Map<String, Object> params) throws Exception;
}
