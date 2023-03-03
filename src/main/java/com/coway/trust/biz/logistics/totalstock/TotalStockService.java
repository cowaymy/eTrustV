package com.coway.trust.biz.logistics.totalstock;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TotalStockService {

	List<EgovMap> totStockSearchList(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectCDCList(Map<String, Object> params);

	List<EgovMap> selectTotalDscList(Map<String, Object> params);

}
