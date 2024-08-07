package com.coway.trust.biz.homecare.po;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcDeliveryGrSearchPopService {

	// main List 조회
	public List<EgovMap> selectDeliveryGrSearchPop(Map<String, Object> params) throws Exception;

}