package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : UnpaidCustomerApiService.java
 * @Description : UnpaidCustomerApiService
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 8.   KR-HAN        First creation
 * </pre>
 */
public interface UnpaidCustomerApiService{

	 /**
	 * selectUnpaidCustomerList
	 * @Author KR-HAN
	 * @Date 2019. 11. 8.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectUnpaidCustomerList(Map<String, Object> params);

	 /**
	 * selectUnpaidCustomerDetailList
	 * @Author KR-HAN
	 * @Date 2019. 11. 8.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectUnpaidCustomerDetailList(Map<String, Object> params);

}
