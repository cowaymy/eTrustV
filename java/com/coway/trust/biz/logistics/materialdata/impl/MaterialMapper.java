package com.coway.trust.biz.logistics.materialdata.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("mstMapper")
public interface MaterialMapper {
	List<EgovMap> selectStockMstList(Map<String, Object> params);
	
	List<EgovMap> selectMaterialMstItemList(Map<String, Object> params);
	
	EgovMap selectNonItemType();
	
	void updateMaterialItemType(Map<String, Object> params);
	void insertMaterialItemType(Map<String, Object> params);
	void deleteMaterialItemType(Map<String, Object> params);
	int materialItmIdSeq();
	int materialItemTypeSeq();
}
