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

	List<EgovMap> selectResnCodeList(Map<String, Object> params);

	EgovMap selectOrderLastRentalBillLedger1(Map<String, Object> params);

	ReturnMessage requestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception ;

	EgovMap selectCompleteASIDByOrderIDSolutionReason(Map<String, Object> params);

	ReturnMessage requestProductExchange(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	List<EgovMap> selectSalesOrderSchemeList(Map<String, Object> params);

	EgovMap selectSchemePriceSettingByPromoCode(Map<String, Object> params);

	List<EgovMap> selectSchemePartSettingBySchemeIDList(Map<String, Object> params);

	ReturnMessage requestSchmConv(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	EgovMap selectValidateInfo(Map<String, Object> params);

	EgovMap selectOrderSimulatorViewByOrderNo(Map<String, Object> params);

	ReturnMessage requestApplicationExchange(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	ReturnMessage requestOwnershipTransfer(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	EgovMap selectValidateInfoSimul(Map<String, Object> params);

	EgovMap selectObligtPriod(Map<String, Object> params);

	EgovMap selectPenaltyAmt(Map<String, Object> params);

	EgovMap checkeAutoDebitDeduction(Map<String, Object> params);

}
