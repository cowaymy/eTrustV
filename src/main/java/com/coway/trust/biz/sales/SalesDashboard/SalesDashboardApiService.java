package com.coway.trust.biz.sales.SalesDashboard;

import com.coway.trust.api.mobile.sales.SalesDashboardApi.SalesDashboardApiDto;
import com.coway.trust.api.mobile.sales.SalesDashboardApi.SalesDashboardApiForm;

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
