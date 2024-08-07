package com.coway.trust.biz.logistics.stockmovement;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StockMovementService {

  String insertStockMovementInfo(Map<String, Object> param);

  List<EgovMap> selectStockMovementNoList(Map<String, Object> params);

  List<EgovMap> selectStockMovementMainList(Map<String, Object> params);

  List<EgovMap> selectStockMovementDeliveryList(Map<String, Object> params);

  List<EgovMap> selectTolocationItemList(Map<String, Object> smap);

  int stockMovementItemDeliveryQty(Map<String, Object> params);

  Map<String, Object> selectStockMovementDataDetail(String param);

  void deleteDeliveryStockMovement(Map<String, Object> param);

  List<EgovMap> addStockMovementInfo(Map<String, Object> param);

  Map<String, Object> stockMovementReqDelivery(Map<String, Object> param);

  Map<String, Object> stockMovementReqDeliverySerial(Map<String, Object> param);

  List<EgovMap> selectStockMovementSerial(Map<String, Object> params);

  Map<String, Object> stockMovementDeliveryIssue(Map<String, Object> params);

  Map<String, Object> stockMovementDeliveryIssueSerial(Map<String, Object> params);

  List<EgovMap> selectStockMovementDeliverySerial(Map<String, Object> params);

  List<EgovMap> selectStockMovementMtrDocInfoList(Map<String, Object> params);

  void insertStockBooking(Map<String, Object> params);

  List<EgovMap> selectGetSerialDataCall(Map<String, Object> params);

  void deleteSmoNo(Map<String, Object> param);

  String selectDefToLocation(Map<String, Object> param);

  String defToLoc(Map<String, Object> param);

  List<EgovMap> SelectStockfromForecast(Map<String, Object> smap);

  String insertStockMovementbyForecast(Map<String, Object> param);

  String insertStockMovementForOnLoanUnit(Map<String, Object> param);

  int getASNo(Map<String, Object> params);

  int chkASNoExist(Map<String, Object> params);

  List<EgovMap> selectSmoIssueOutPop(Map<String, Object> smap); // KR OHK : SMO Serial Check Popup

  List<EgovMap> selectSmoIssueInPop(Map<String, Object> smap); // KR OHK : SMO Serial Check Popup

  List<EgovMap> selectSMOIssueInSerialGradeList(Map<String, Object> smap); // KR OHK :SMO Serial Grade List

}
