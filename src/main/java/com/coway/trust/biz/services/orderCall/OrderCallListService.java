package com.coway.trust.biz.services.orderCall;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 31/01/2019    ONGHC      1.0.1       - Restructure File
 *********************************************************************************************/

public interface OrderCallListService {
  List<EgovMap> selectOrderCall(Map<String, Object> params);

  EgovMap getOrderCall(Map<String, Object> params);

  Map<String, Object> insertCallResult(Map<String, Object> params, SessionVO sessionVO);

  Map<String, Object> insertCallResult_2(Map<String, Object> params, SessionVO sessionVO);

  List<EgovMap> selectCallStatus();

  List<EgovMap> selectCallLogTransaction(Map<String, Object> params);

  List<EgovMap> getstateList();

  List<EgovMap> getAreaList(Map<String, Object> params);

  EgovMap selectCdcAvaiableStock(Map<String, Object> params);

  EgovMap selectRdcStock(Map<String, Object> params);

  EgovMap getRdcInCdc(Map<String, Object> params);

  List<EgovMap> selectProductList();

  List<EgovMap> selectCallLogTyp();

  List<EgovMap> selectCallLogSta();

  List<EgovMap> selectCallLogSrt();

  int chkRcdTms(Map<String, Object> params);

  int selRcdTms(Map<String, Object> params);

  Map<String, Object> insertCallResultSerial(Map<String, Object> params, SessionVO sessionVO);

  List<EgovMap> selectPromotionList();

//  void sendSms(Map<String, Object> smsList);
//
//  Map<String, Object> callLogSendSMS(Map<String, Object> params, SessionVO sessionVO);
}
