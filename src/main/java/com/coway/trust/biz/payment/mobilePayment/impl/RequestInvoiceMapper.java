package com.coway.trust.biz.payment.mobilePayment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestInvoiceMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 *          </pre>
 */
@Mapper("RequestInvoiceMapper")
public interface RequestInvoiceMapper {

	List<EgovMap> selectTicketStatusCode();

	List<EgovMap> selectInvoiceType();

	int selectRequestInvoiceCount(Map<String, Object> params);

	List<EgovMap> selectRequestInvoiceList(Map<String, Object> params);

	int saveRequestInvoiceArrpove(Map<String, Object> params);

	int saveRequestInvoiceReject(Map<String, Object> params);

	List<EgovMap> selectInvoiceDetails(Map<String, Object> param);
}
