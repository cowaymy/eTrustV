package com.coway.trust.biz.services.bs;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HsManualService {

	List<EgovMap> selectHsManualList(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectCtList(Map<String, Object> params);

	List<EgovMap> getCdList(Map<String, Object> params);

	List<EgovMap> getCdUpMemList(Map<String, Object> params);

}
