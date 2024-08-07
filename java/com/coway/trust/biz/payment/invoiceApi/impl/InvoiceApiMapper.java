package com.coway.trust.biz.payment.invoiceApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : InvoiceApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("InvoiceApiMapper")
public interface InvoiceApiMapper {



	List<EgovMap> selectInvoiceList(Map<String, Object> params);



    List<EgovMap> selectAdvanceInvoiceList(Map<String, Object> params);



    List<EgovMap> selectRequestInvoiceList(Map<String, Object> params);



    int selectRequestInvoiceStusCheck(Map<String, Object> params);



    int selectRequestAdvanceInvoiceCheck(Map<String, Object> params);



    int insertPay0300D(Map<String, Object> params);



    int insertPay0301D(Map<String, Object> params);
}
