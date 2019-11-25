package com.coway.trust.biz.payment.mobilePayment;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestFundTransferService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface RequestRefundService {



	List<EgovMap> selectTicketStatusCode() throws Exception;



	ReturnMessage selectRequestRefundList(Map<String, Object> param) throws Exception;



    int saveRequestRefundArrpove(Map<String, Object> param) throws Exception;



    int saveRequestRefundReject(Map<String, Object> param) throws Exception;
}
