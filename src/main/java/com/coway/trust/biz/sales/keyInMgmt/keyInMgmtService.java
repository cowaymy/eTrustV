package com.coway.trust.biz.sales.keyInMgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface keyInMgmtService {

	int saveKeyInId(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId);

	List<EgovMap> selectKeyinMgmtList(Map<String, Object> params);

	List<EgovMap> searchKeyinMgmtList(Map<String, Object> params);


}
