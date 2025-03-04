package com.coway.trust.biz.logistics.mlog.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("MlogApiMapper")
public interface MlogApiMapper {

  // List<EgovMap> getNonBarcodeList(Map<String, Object> params);

  // List<EgovMap> getBarcodeList(Map<String, Object> params);

  // List<StrockMovementVoForMobile> getStockRequestStatusHeader(Map<String, Object> params);

  // List<StrockMovementVoForMobile> getRequestStatusParts(Map<String, Object> setMap);

  List<EgovMap> getRDCStockList(Map<String, Object> params);

  List<EgovMap> getStockbyHolderList(Map<String, Object> params);

  List<EgovMap> getCommonQty(Map<String, Object> params);

  List<EgovMap> getCt_CodyList(Map<String, Object> params);

  List<EgovMap> getInventoryOverallStock(Map<String, Object> params);

  List<EgovMap> getAllStockList(Map<String, Object> params);

  List<EgovMap> getInventoryStockByHolder(Map<String, Object> params);

  List<EgovMap> StockReceiveList(Map<String, Object> params);

  List<EgovMap> selectStockReceiveSerial(Map<String, Object> params);

  List<EgovMap> selectStockReceiveSerialScan(Map<String, Object> params);

  String getSerialRequireChkYn(Map<String, Object> params);

  List<EgovMap> getMyStockList(Map<String, Object> params);

  List<EgovMap> getMyStockListScan(Map<String, Object> params);

  List<EgovMap> getReturnPartsSearch(Map<String, Object> params);

  List<EgovMap> getReturnPartsSearchScan(Map<String, Object> params);

  List<EgovMap> getAlternativeFilterMList();

  List<EgovMap> getAlternativeFilterDList();

  List<EgovMap> getItemBankLocationList(Map<String, Object> params);

  List<EgovMap> getItemBankItemList();

  List<EgovMap> getItemBankResultList(Map<String, Object> params);

  List<EgovMap> getCommonReqHeader(Map<String, Object> params);

  List<EgovMap> getCommonReqParts(Map<String, Object> params);

  List<EgovMap> getCommonReqPartsScan(Map<String, Object> params);

  List<EgovMap> getAuditStockResultDetail(Map<String, Object> params);

  List<EgovMap> getStockTransferReqStatusMList(Map<String, Object> params);

  List<EgovMap> getStockTransferReqStatusDList(Map<String, Object> params);

  List<EgovMap> getNonBarcodeM(Map<String, Object> params);

  List<EgovMap> getNonBarcodeDList(String invenAdjustLocId);

  List<EgovMap> getBarcodeDList(String invenAdjustLocId);

  List<EgovMap> getBarcodeCList(String invenAdjustLocId);

  List<EgovMap> getUsedPartsList(Map<String, Object> params);

  List<EgovMap> getMiscPartList();

  List<EgovMap> getFilterNotChangeList(Map<String, Object> params);

  List<EgovMap> getFilterChangeList(Map<String, Object> params);

  List<EgovMap> getUserFilterList(Map<String, Object> params);

  List<EgovMap> getInventoryOnHandStock(Map<String, Object> params);

  List<EgovMap> getInventoryOnHandStockNoSerial(Map<String, Object> params);

  List<EgovMap> getStockAuditResult(Map<String, Object> params);

  List<EgovMap> getStockPriceList(Map<String, Object> params);

  String selectStockMovementSeq();

  String selectDeliveryStockMovementSeq();

  void insStockMovementHead(Map<String, Object> fMap);

  void insStockMovementDetail(Map<String, Object> fMap);

  void insertStockBooking(Map<String, Object> fMap);

  void insertDeliveryStockMovementDetail(Map<String, Object> tmpMap);

  void insertMovementSerial(Map<String, Object> tmpMap);

  void insertDeliveryStockMovement(Map<String, Object> tmpMap);

  void updateRequestMovement(Map<String, Object> tmpMap);

  Map<String, Object> selectStockMovementSerial(Map<String, Object> params);

  void StockMovementIssue(Map<String, Object> formMap);

  void StockMovementIssueScan(Map<String, Object> formMap);

  void LogisticBarcodeSave(Map<String, Object> formMap);

  void LogisticBarcodeScan(Map<String, Object> formMap);

  void updateNonBarcodeQty(Map<String, Object> setmap);

  void updateBarcodeQty(Map<String, Object> setmap);

  void insertBarcode(Map<String, Object> setmap);

  String StockMovementDelvryNo(Map<String, Object> receiveMap);

  void StockMovementIssueCancel(Map<String, Object> receiveMap);

  void StockMovementReqstCancel(Map<String, Object> receiveMap);

  List<EgovMap> getDeliveryNo(Map<String, Object> receiveMap);

  void insStockMovementHeads(Map<String, Object> fMap);

  int getUserLocId(Map<String, Object> receiveMap);

  String dateParsing(String param);

  Map<String, Object> selectDelvryGRcmplt(String delNo);

  String StockMovementReqstChk(Map<String, Object> reqmap);

  String selectWhLocId(Map<String, Object> tmpMap);

  void LogisticBarcodeScanUsum(Map<String, Object> formMap);

  List<EgovMap> getStockHCPriceList(Map<String, Object> params);

  List<EgovMap> getStockTransferReqStatusDListScan(Map<String, Object> params);

  public List<EgovMap> selectSerialInfo(Map<String, Object> obj);

  public List<EgovMap> selectSerialInfoMul(Map<String, Object> obj) throws Exception;

  public void updateDeliveryGrDetail(Map<String, Object> obj);

  public void updateDeliveryGrMain(Map<String, Object> obj);

  public List<EgovMap> selectDeliveryGrHist(Map<String, Object> obj);

  public void updateDeliveryGrHist(Map<String, Object> obj);

  int selectSMDitmExist(Map<String, Object> obj);

  void updateRequestMovementQty(Map<String, Object> tmpMap);

  void updateDeliveryMovementQty(Map<String, Object> tmpMap);

  public List<EgovMap> getHiCareInventory(Map<String, Object> params);

  int getSMOReceiveCntList(Map<String, Object> params);

  int getSMOMoveOutCntList(Map<String, Object> params);

  public List<EgovMap> getOnHandStkSerialList(Map<String, Object> params);

  public List<EgovMap> getAllMember(Map<String, Object> params);

  public List<EgovMap> getCodyAvaFilterList(Map<String, Object> params);

}
