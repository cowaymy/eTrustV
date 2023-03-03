package com.coway.trust.biz.logistics.totalstock.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("TotalStockMapper")
public interface TotalStockMapper {

	List<EgovMap> totStockSearchList(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectCDCList(Map<String, Object> params);

	List<EgovMap> selectTotalDscList(Map<String, Object> params);

}
