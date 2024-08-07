package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orgChartListMapper")
public interface OrgChartListMapper {
	List<EgovMap> selectOrgChartHpList(Map<String, Object> params);

	List<EgovMap> selectHpChildList(Map<String, Object> params);

	List<EgovMap> selectOrgChartCdList(Map<String, Object> params);

	List<EgovMap> getDeptTreeList(Map<String, Object> params);

	List<EgovMap> getGroupTreeList(Map<String, Object> params);

	List<EgovMap> selectCdChildList(Map<String, Object> params);

	List<EgovMap> selectOrgChartCtList(Map<String, Object> params);

	List<EgovMap> selectCtChildList(Map<String, Object> params);

	List<EgovMap> selectOrgChartDetList(Map<String, Object> params);


	String selectLastGroupCode(Map<String, Object> params);

	List<EgovMap> selectStatus();

	List<EgovMap> selectMemberName(Map<String, Object> params);


}
