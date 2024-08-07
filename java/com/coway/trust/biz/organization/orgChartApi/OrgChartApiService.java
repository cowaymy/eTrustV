package com.coway.trust.biz.organization.orgChartApi;

import java.util.List;

import com.coway.trust.api.mobile.organization.orgChartApi.OrgChartApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrgChartApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface OrgChartApiService {



	List<EgovMap> selectOrgChart(OrgChartApiForm param) throws Exception;
}
