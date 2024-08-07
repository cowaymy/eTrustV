package com.coway.trust.biz.logistics.replenishment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ReplenishmentMapper")
public interface ReplenishmentMapper {
	Map<String, Object> excelDataSearch(Map<String, Object> params);

	void relenishmentSave(Map<String, Object> params);

	List<EgovMap> selectSearchList(Map<String, Object> params);

	List<EgovMap> searchListRdc(Map<String, Object> params);

	List<EgovMap> searchAutoCTList(Map<String, Object> params);

	List<EgovMap> PopCheck(Map<String, Object> params);

	String selectStockMovementSeq();

	void insStockMovementDetail(Map<String, Object> map);

	void insStockMovementHead(Map<String, Object> map);

	List<EgovMap> searchListMaster(Map<String, Object> params);

	void relenishmentSaveMsCt(Map<String, Object> updMap);

	List<EgovMap> searchListMasterDsc(Map<String, Object> params);
}
