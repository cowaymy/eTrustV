
package com.coway.trust.biz.payment.report.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CCDReportMapper.java
 * @Description : CCDReportMapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 30.   KR-HAN        First creation
 * </pre>
 */
@Mapper("ccdReportMapper")
public interface CCDReportMapper {

	Integer selectLastDay(Map<String, Object> params);

	List<EgovMap> selectCustomerTypeNPayChannelReportJsonList1(Map<String, Object> params);

	List<EgovMap> selectCustomerTypeNPayChannelReportJsonList2(Map<String, Object> params);

	List<EgovMap> selectCustomerTypeNPayChannelReportJsonList3(Map<String, Object> params);

	List<EgovMap> selectCustomerTypeNPayChannelReportJsonList4(Map<String, Object> params);

	List<EgovMap> selectIssuerBankReportJsonList(Map<String, Object> params);

	List<EgovMap> selectActualPaymentTypeSummaryOrderCountReportJsonList(Map<String, Object> params);

	List<EgovMap> selectActualPaymentTypeSummaryAmoutReportJsonList(Map<String, Object> params);

}
