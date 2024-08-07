package com.coway.trust.biz.logistics.pointofsales;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/10/2019    ONGHC      1.0.1       - AMEND FOR LATEST CHANGES
 *********************************************************************************************/

public interface PointOfSalesService {
  List<EgovMap> getTrxTyp(Map<String, Object> params);

  List<EgovMap> PosSearchList(Map<String, Object> params);

  List<EgovMap> posItemList(Map<String, Object> params);

  List<EgovMap> selectTypeList(Map<String, Object> params);

  List<EgovMap> selectAdjRsn(Map<String, Object> params);

  List<EgovMap> getRqstLocLst(Map<String, Object> params);

  List<EgovMap> selectPointOfSalesSerial(Map<String, Object> params);

  // List<EgovMap> selectPosReqNoList(Map<String, Object> params);

  String insertPosInfo(Map<String, Object> params);

  String insertGiInfo(Map<String, Object> params);

  Map<String, Object> PosDataDetail(String param);

  List<EgovMap> selectSerial(Map<String, Object> params);

  void insertStockBooking(Map<String, Object> params);

  List<EgovMap> selectMaterialDocList(Map<String, Object> params);

  int selectOtherReqChk(Map<String, Object> params);

  void deleteStoNo(Map<String, Object> param);

  EgovMap selectAttachmentInfo(Map<String, Object> params);

  // KR-OHK Serial add
  List<EgovMap> selectReqItemList(String taskType, String params);

  // KR-OHK Serial add
  String insertGiInfoSerial(Map<String, Object> params);

  // KR-OHK Serial add
  void deleteStoNoSerial(Map<String, Object> param);
}
