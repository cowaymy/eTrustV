package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpCTOSB2BMapper")
public interface CcpCTOSB2BMapper {


	List<EgovMap> selectCTOSB2BList(Map<String, Object> params);

	List<EgovMap> getCTOSDetailList(Map<String, Object> params);

	EgovMap getResultRowForCTOSDisplay(Map<String, Object> params);

	int  savePromoB2BUpdate(Map<String, Object> params);

	int  savePromoB2BUpdate2(Map<String, Object> params);

	int  savePromoCHSUpdate(Map<String, Object> params);

	int  savePromoCHSUpdate2(Map<String, Object> params);

	Map<String, Object> getReuploadB2B(Map<String, Object> param);

	EgovMap getCurrentTower(Map<String, Object> params)throws Exception;

	int updateCurrentTower(Map<String, Object> params);

	List<EgovMap> selectAgeGroupList(Map<String, Object> params);

	int updateAgeGroup(Map<String, Object> params);

	EgovMap getCurrentAgeGroup(Map<String, Object> params)throws Exception;
}
