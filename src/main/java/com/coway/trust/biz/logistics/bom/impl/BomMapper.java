package com.coway.trust.biz.logistics.bom.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("bomMapper")
public interface BomMapper {

	List<EgovMap> selectCdcList(Map<String, Object> params);

	List<EgovMap> selectBomList(Map<String, Object> params);

	List<EgovMap> materialInfo(Map<String, Object> params);

	List<EgovMap> selectCodeList(Map<String, Object> params);
	
	void modifyLeadTmOffset(Map<String, Object> params);

}
