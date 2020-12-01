package com.coway.trust.biz.sales.royaltyCustomerListApi;

import java.util.List;

import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiForm;

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

	 RoyaltyCustomerListApiForm updateWsLoyaltyList (RoyaltyCustomerListApiForm param) throws Exception;

}
