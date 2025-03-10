package com.coway.trust.biz.sales.cwStore.impl; 

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("cwStoreOrderListMapper")
public interface CWStoreOrderListMapper {
	List<EgovMap> selectCWStoreOrderList (Map<String, Object> params);
}
