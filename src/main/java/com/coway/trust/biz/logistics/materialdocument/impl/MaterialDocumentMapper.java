package com.coway.trust.biz.logistics.materialdocument.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("MaterialDocumentMapper")
public interface MaterialDocumentMapper {

	List<EgovMap> selectLocation(Map<String, Object> params);

	List<EgovMap> MaterialDocSearchList(Map<String, Object> params);

	List<EgovMap> MaterialDocMovementType(Map<String, Object> params);

	// 20191122 KR-OHK Serial List Add
	List<EgovMap> selectMaterialDocSerialList(Map<String, Object> params);

	List<EgovMap> MaterialDocSearchListUpTo(Map<String, Object> params);
}
