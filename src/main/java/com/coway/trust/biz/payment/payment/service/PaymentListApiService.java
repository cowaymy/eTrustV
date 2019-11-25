package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @ClassName : PaymentListApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 21.   KR-HAN        First creation
 * </pre>
 */
public interface PaymentListApiService{

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 21.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPaymentList(Map<String, Object> params);

}
