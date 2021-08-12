package com.coway.trust.biz.sales.salesDashboardApi;

import com.coway.trust.api.mobile.sales.salesDashboardApi.SalesDashboardApiDto;
import com.coway.trust.api.mobile.sales.salesDashboardApi.SalesDashboardApiForm;

/**
 * @ClassName : SalesDashboardApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface SalesDashboardApiService {



    SalesDashboardApiDto selectSalesDashboard(SalesDashboardApiForm param) throws Exception;
}
