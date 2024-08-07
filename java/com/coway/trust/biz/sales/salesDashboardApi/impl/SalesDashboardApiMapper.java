package com.coway.trust.biz.sales.salesDashboardApi.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SalesDashboardApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("SalesDashboardApiMapper")
public interface SalesDashboardApiMapper {



    EgovMap selectSalesDashboard(Map<String, Object> param);
}
