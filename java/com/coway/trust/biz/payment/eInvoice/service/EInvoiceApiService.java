package com.coway.trust.biz.payment.eInvoice.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : EInvoiceApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 2.   KR-HAN        First creation
 * </pre>
 */
public interface EInvoiceApiService{


	 /**
	 * selectBillGroupList
	 * @Author KR-HAN
	 * @Date 2019. 10. 2.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillGroupList(Map<String, Object> params);

	 /**
	 * selectEInvoiceDetail
	 * @Author KR-HAN
	 * @Date 2019. 10. 2.
	 * @param params
	 * @return
	 */
	EgovMap selectEInvoiceDetail(Map<String, Object> params);

	 /**
	 * saveEInvoiceBillType
	 * @Author KR-HAN
	 * @Date 2019. 11. 17.
	 * @param params
	 * @throws Exception
	 */
	void saveEInvoiceBillType(Map<String, Object> params) throws Exception;


}
