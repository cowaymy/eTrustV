package com.coway.trust.biz.services.orderCall.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 31/01/2019    ONGHC      1.0.1       - Restructure File
 *********************************************************************************************/

@Mapper("orderCallListMapper")
public interface OrderCallListMapper {

  List<EgovMap> selectOrderCall(Map<String, Object> params);

  EgovMap getOrderCall(Map<String, Object> params);

  EgovMap selectCallEntry(Map<String, Object> params);

  EgovMap selectOrderEntry(String orderNo);

  void insertCallResult(Map<String, Object> params);

  void updateCallEntry(Map<String, Object> params);

  void insertInstallEntry(Map<String, Object> params);

  void deleteInstallEntry(Map<String, Object> params);

  void updateASEntry(Map<String, Object> params);

  void insertSalesOrderLog(Map<String, Object> params);

  void insertSalesVerification(Map<String, Object> params);

  void updateSalesVerification(Map<String, Object> params);

  List<EgovMap> selectCallStatus();

  String selectMaxId(Map<String, Object> params);

  List<EgovMap> selectCallLogTransaction(Map<String, Object> params);

  List<EgovMap> getstateList();

  List<EgovMap> getAreaList(Map<String, Object> params);

  EgovMap selectCdcAvaiableStock(Map<String, Object> params);

  EgovMap selectRdcStock(Map<String, Object> params);

  EgovMap getRdcInCdc(Map<String, Object> params);

  EgovMap getSalesVerification(Map<String, Object> params);

  List<EgovMap> selectProductList();

  List<EgovMap> selectCallLogTyp();

  List<EgovMap> selectCallLogSta();

  List<EgovMap> selectCallLogSrt();

  int chkRcdTms(Map<String, Object> params);

  int selRcdTms(Map<String, Object> params);

  int installEntryIdSeq();

  List<EgovMap> selectPromotionList();

}
