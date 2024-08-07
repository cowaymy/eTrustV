package com.coway.trust.biz.sales.royaltyCustomerListApi;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiFormDto;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiDto;
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


	 // List<EgovMap> selectWsLoyaltyList() throws Exception;

	List<EgovMap> selectWsLoyaltyList (RoyaltyCustomerListApiForm param);

	// RoyaltyCustomerListApiForm updateWsLoyaltyList (RoyaltyCustomerListApiForm param) throws Exception; //666

	 RoyaltyCustomerListApiDto updateWsLoyaltyList(RoyaltyCustomerListApiDto param) throws Exception;

	//Map<String, Object> selectWaterPurifierResultDetailList(Map<String, Object> params);

	List<EgovMap> waterPurifierResult(RoyaltyCustomerListApiForm param);

}
