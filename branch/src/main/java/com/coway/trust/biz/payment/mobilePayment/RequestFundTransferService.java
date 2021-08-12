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
public interface RequestFundTransferService {



	List<EgovMap> selectTicketStatusCode() throws Exception;



	ReturnMessage selectRequestFundTransferList(Map<String, Object> param) throws Exception;



    ReturnMessage selectOutstandingAmount(Map<String, Object> param) throws Exception;



    int saveRequestFundTransferArrpove(Map<String, Object> param) throws Exception;



    int saveRequestFundTransferReject(Map<String, Object> param) throws Exception;
}
