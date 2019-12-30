/**
 *
 */
package com.coway.trust.biz.logistics.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CCDReportService.java
 * @Description : selectActualPaymentTypeSummaryReportJsonList
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 30.   KR-HAN        First creation
 * </pre>
 */
public interface CCDReportService {

	 /**
	 * selectCustomerTypeNPayChannelReporJsonList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @return
	 */
	Map<String, Object> selectCustomerTypeNPayChannelReporJsonList(Map<String, Object> params);

	 /**
	 * selectIssuerBankReportJsonList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectIssuerBankReportJsonList(Map<String, Object> params);

	 /**
	 * selectActualPaymentTypeSummaryReportJsonList
	 * @Author KR-HAN
	 * @Date 2019. 12. 30.
	 * @param params
	 * @return
	 */
	Map<String, Object> selectActualPaymentTypeSummaryReportJsonList(Map<String, Object> params);

}
