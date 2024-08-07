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

/******************************************************************
 * DATE              PIC            VERSION        COMMENT
 *--------------------------------------------------------------------------------------------
 * 23/04/2020    ONGHC          1.0.1           - Add checkDefectByReason
 ******************************************************************/

public interface OrderRequestService {

  List<EgovMap> selectResnCodeList(Map<String, Object> params);

  List<EgovMap> selectCodeList(Map<String, Object> params);

  EgovMap selectOrderLastRentalBillLedger1(Map<String, Object> params);

  ReturnMessage requestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception;

  ReturnMessage cboPckReqCanOrd(Map<String, Object> params, SessionVO sessionVO) throws Exception;

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

  // BY KV order installation no yet complete (CallLog Type - 257, CCR0001D -
  // 20, SAL00046 - Active )
  EgovMap validOCRStus(Map<String, Object> params);

  EgovMap validOCRStus2(Map<String, Object> params);

  // BY KV -order cancellation no yet complete sal0020d
  EgovMap validOCRStus3(Map<String, Object> params);

  // By KV -order cancellation complete sal0020d ; log0038d active
  EgovMap validOCRStus4(Map<String, Object> params);

  Integer chkCboSal(Map<String, Object> params);

  Integer chkSalStat(Map<String, Object> params);

  Integer checkDefectByReason(Map<String, Object> params);

}
