package com.coway.trust.biz.payment.invoiceApi;

import java.util.List;

import com.coway.trust.api.mobile.payment.invoiceApi.InvoiceApiDto;
import com.coway.trust.api.mobile.payment.invoiceApi.InvoiceApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : InvoiceApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface InvoiceApiService {



	List<EgovMap> selectInvoiceList(InvoiceApiForm param) throws Exception;



    List<EgovMap> selectRequestInvoiceList(InvoiceApiForm param) throws Exception;



    List<InvoiceApiDto> saveRequestInvoice(List<InvoiceApiDto> param) throws Exception;



    InvoiceApiDto saveRequestAdvanceInvoice(InvoiceApiDto param) throws Exception;
}
