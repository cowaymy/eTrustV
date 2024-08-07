package com.coway.trust.biz.payment.mobilePayment;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;

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
public interface RequestInvoiceService {



	List<EgovMap> selectTicketStatusCode() throws Exception;



	List<EgovMap> selectInvoiceType() throws Exception;



	ReturnMessage selectRequestInvoiceList(Map<String, Object> param) throws Exception;



    int saveRequestInvoiceArrpove(Map<String, Object> param, int userId) throws Exception;



    int saveRequestInvoiceReject(Map<String, Object> param, int userId) throws Exception;
}
