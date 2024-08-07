package com.coway.trust.biz.logistics.pointofsales.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/10/2019    ONGHC      1.0.1       - AMEND FOR LATEST CHANGES
 *********************************************************************************************/

@Mapper("PointOfSalesMapper")
public interface PointOfSalesMapper {

  List<EgovMap> getTrxTyp(Map<String, Object> params);

  List<EgovMap> PosSearchList(Map<String, Object> params);

  List<EgovMap> posItemList(Map<String, Object> params);

  List<EgovMap> selectTypeList(Map<String, Object> params);

  List<EgovMap> selectAdjRsn(Map<String, Object> params);

  List<EgovMap> getRqstLocLst(Map<String, Object> params);

  List<EgovMap> selectPointOfSalesSerial(Map<String, Object> params);

  String selectPosSeq();

  void insOtherReceiptHead(Map<String, Object> params);

  void insRequestItem(Map<String, Object> params);

  void insertSerial(Map<String, Object> params);

  void updateReqstStus(Map<String, Object> params);

  void GIRequestIssue(Map<String, Object> formMap);

  void GICancelIssue(Map<String, Object> formMap);

  Map<String, Object> selectPosHead(String param);

  List<EgovMap> selectPosItem(String param);

  List<EgovMap> selectPosToItem(Map<String, Object> params);

  List<EgovMap> selectSerial(Map<String, Object> params);

  void insertStockBooking(Map<String, Object> params);

  List<EgovMap> selectMaterialDocList(Map<String, Object> params);

  int selectOtherReqChk(String reqno);

  int selectOtherReqCancleChk(String reqno);

  void updateStockHead(String reqstono);

  void deleteStockDelete(String reqstono);

  void deleteStockBooking(String reqstono);

  EgovMap selectAttachmentInfo(Map<String, Object> params);

  List<EgovMap> selectReqItemList(String param);

  void SP_LOGISTIC_BARCODE_SAVE_OGOI(Map<String, Object> params);

  void SP_LOGISTIC_BARCODE_DEL_OGOI(Map<String, Object> params);

  void SP_LOGISTIC_BARCODE_REVS_OGOI(Map<String, Object> params);

 }
