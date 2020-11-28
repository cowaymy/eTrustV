package com.coway.trust.biz.sales.royaltyCustomerListApi;

import java.util.List;


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
public interface RoyaltyCustomerListApiService {


	 List<EgovMap> selectWsLoyaltyList() throws Exception;

}
