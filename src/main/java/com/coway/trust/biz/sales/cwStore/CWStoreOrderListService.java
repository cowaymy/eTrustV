package com.coway.trust.biz.sales.cwStore;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CWStoreOrderListService {
	List<EgovMap> selectCWStoreOrderList(Map<String, Object> params);
}
