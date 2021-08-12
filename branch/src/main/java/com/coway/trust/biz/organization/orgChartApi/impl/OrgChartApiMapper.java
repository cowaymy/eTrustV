package com.coway.trust.biz.organization.orgChartApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrgChartApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 5.   KR-JAEMJAEM:)        First creation
 * </pre>
 */
@Mapper("OrgChartApiMapper")
public interface OrgChartApiMapper {



    EgovMap selectOrg(Map<String, Object> params);



	List<EgovMap> selectOrgChart(Map<String, Object> params);



}
