package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("territoryManagementMapper")
public interface TerritoryManagementMapper {

	List<EgovMap> selectList(Map<String, Object> params);

	EgovMap  cody42Vaild(Map<String, Object> params);
	EgovMap  dream43Vaild(Map<String, Object> params);

	void insertCody(Map<String, Object> params);

	String selectRequestNo();

	List<EgovMap> selectTerritory(Map<String, Object> params);

	List<EgovMap> selectMagicAddress(Map<String, Object> params);

	List<EgovMap> select19M(Map<String, Object> params);

	void updateSYS0064M(EgovMap params);

	void updateORG0019M(EgovMap params);

	void updateORG0019MFlag(EgovMap params);

	void insertDreamServiceCenter(Map<String, Object> params);

	void insertSalesOffice(Map<String, Object> params);

	void updateSYS0064MDream(EgovMap params);

	void updateSYS0064MSO(EgovMap params);

	List<EgovMap> selectBranchCode(Map<String, Object> params);

	List<EgovMap> selectState(Map<String, Object> params);

	List<EgovMap> selectCurrentTerritory(Map<String, Object> params);

	void insertHomecareTechnician(Map<String, Object> params);

	void updateSYS0064MHT(EgovMap params);
}
