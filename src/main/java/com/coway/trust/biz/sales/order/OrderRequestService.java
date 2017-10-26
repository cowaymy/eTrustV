/**
 * 
 */
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface OrderRequestService {

	List<EgovMap> selectResnCodeList();

	EgovMap selectOrderLastRentalBillLedger1(Map<String, Object> params);

	ReturnMessage requestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception ;

}
