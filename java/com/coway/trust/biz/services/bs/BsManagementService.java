package com.coway.trust.biz.services.bs;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BsManagementService {

	List<EgovMap> selectBsManagementList(Map<String, Object> params);

	List<EgovMap> selectBsStateList(Map<String, Object> params);

	List<EgovMap> selectAreaList(Map<String, Object> params);

}
