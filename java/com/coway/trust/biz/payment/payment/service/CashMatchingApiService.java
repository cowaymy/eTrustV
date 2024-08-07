package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.payment.cashMatching.CashMatchingForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CashMatchingApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 19.   KR-HAN        First creation
 * </pre>
 */
public interface CashMatchingApiService{

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 19.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCashMatching(Map<String, Object> params);

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 19.
	 * @param cashMatchingForm
	 * @return
	 * @throws Exception
	 */
	int saveCashMatching(List<CashMatchingForm> cashMatchingForm) throws Exception;
}
