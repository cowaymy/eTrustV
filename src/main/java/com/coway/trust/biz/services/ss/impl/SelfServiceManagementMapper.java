package com.coway.trust.biz.services.ss.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("selfServiceManagementMapper")
public interface SelfServiceManagementMapper {

  List<EgovMap> selectSelfServiceJsonList(Map<String, Object> params);

  List<EgovMap> selectSelfServiceFilterItmList(Map<String, Object> params);

  int getSeqSVC0144M();

  int getSeqSVC0145D();

  int getSeqSVC0146M();

  int getSeqSVC0147D();

  void insertSelfServiceResultMaster(Map<String, Object> params);

  void insertSelfServiceResultDetail(Map<String, Object> params);

  void updateSelfServiceResultDetail(Map<String, Object> params);

  void insertSelfServiceStockReturnMaster(Map<String, Object> params);

  void insertSelfServiceStockReturnDetail(Map<String, Object> params);

  void updateSelfServiceStockReturnDetail(Map<String, Object> params);

  int rollbackSelfServiceResultMaster( Map<String, Object> params );

  int rollbackSelfServiceResultDetail( Map<String, Object> params );

  int rollbackSelfServiceReturnGoodsQty( Map<String, Object> params );

  int rollbackSelfServiceReturnQty( Map<String, Object> params );

  List<EgovMap> getSelfServiceFilterList(Map<String, Object> params);

  List<EgovMap> getSelfServiceDelivryList(Map<String, Object> params);

  List<EgovMap> getSelfServiceRtnItmDetailList(Map<String, Object> params);

  List<EgovMap> getSelfServiceRtnItmList(Map<String, Object> params);

  EgovMap checkFilterBarCodeNo(Map<String, Object> params);

  EgovMap selectSelfServiceResultInfo(Map<String, Object> params);

  EgovMap selectSelfServiceItmList( Map<String, Object> params );

  void updateHsMasterStatus(Map<String, Object> params);

  void updateSsMasterStatus(Map<String, Object> params);

  void updateHsResultStatus(Map<String, Object> params);

  int saveValidation(Map<String, Object> params);

  List<EgovMap> ssFailReasonList(Map<String, Object> params);

  Map<String, Object> SP_LOGISTIC_BARCODE_SCAN_SS_VALIDATE(Map<String, Object> param);

  Map<String, Object> SP_LOGISTIC_SS_SAVE(Map<String, Object> param);

  Map<String, Object> SP_LOGISTIC_SS_EDIT(Map<String, Object> param);

  boolean checkIfDataExists(Map<String, Object> setmap);

}