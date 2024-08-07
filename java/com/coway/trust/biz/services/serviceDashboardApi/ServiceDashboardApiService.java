package com.coway.trust.biz.services.serviceDashboardApi;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.serviceDashboardApi.ServiceDashboardApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName :
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface ServiceDashboardApiService {

	List<EgovMap> selectCsStatusDashboard(ServiceDashboardApiForm param);

}
