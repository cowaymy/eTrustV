package com.coway.trust.biz.cmm.dashboard;

import java.util.List;

import com.coway.trust.api.mobile.cmm.dashboard.CommissionApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CommissionApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface CommissionApiService {



    List<EgovMap> selectCommissionDashboard(CommissionApiForm param) throws Exception;
}
