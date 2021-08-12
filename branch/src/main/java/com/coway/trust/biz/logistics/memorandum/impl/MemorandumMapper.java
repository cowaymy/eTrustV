package com.coway.trust.biz.logistics.memorandum.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("memoMapper")
public interface MemorandumMapper {
	List<EgovMap> selectMemoRandumList(Map<String, Object> params);

	void memoSave(Map<String, Object> params);

	void memoUpdate(Map<String, Object> params);

	Map<String, Object> selectMemoRandumData(Map<String, Object> params);

	void memoDelete(Map<String, Object> params);
}
