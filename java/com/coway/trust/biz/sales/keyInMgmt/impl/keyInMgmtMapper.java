package com.coway.trust.biz.sales.keyInMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("keyInMgmtMapper")
public interface keyInMgmtMapper {

	int deleteKeyInId(Map<String, Object> params);

	int updateKeyInId(Map<String, Object> params);

	List<EgovMap> searchKeyinMgmtList(Map<String, Object> params);

	EgovMap selectDocNo(String docNoId);

	void updateDocNo(Map<String, Object> requestNo);

	public int uploadKeyInMgmt(Map<String, Object> params);

}
