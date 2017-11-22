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
}
