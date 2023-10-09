package com.coway.trust.biz.logistics.mlog.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.logistics.audit.InputBarcodeListForm;
import com.coway.trust.api.mobile.logistics.audit.InputBarcodePartsForm;
import com.coway.trust.api.mobile.logistics.audit.InputNonBarcodeForm;
import com.coway.trust.api.mobile.logistics.audit.InputNonBarcodePartsForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryReqTransferDForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryReqTransferMForm;
import com.coway.trust.api.mobile.logistics.recevie.ConfirmReceiveMForm;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockReqDForm;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockReqMForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiDForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiMForm;
import com.coway.trust.biz.logistics.mlog.MlogApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.PreconditionException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("MlogApiService")
public class MlogApiServiceImpl extends EgovAbstractServiceImpl implements MlogApiService {

  private final Logger logger = LoggerFactory.getLogger(this.getClass());
  @Resource(name = "MlogApiMapper")
  private MlogApiMapper MlogApiMapper;

  @Override
  public List<EgovMap> getRDCStockList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getRDCStockList(params);
  }

  @Override
  public List<EgovMap> getStockbyHolderList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getStockbyHolderList(params);
  }

  @Override
  public List<EgovMap> getCommonQty(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getCommonQty(params);
  }

  @Override
  public List<EgovMap> getCt_CodyList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getCt_CodyList(params);
  }

  @Override
  public List<EgovMap> getInventoryOverallStock(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getInventoryOverallStock(params);
  }

  @Override
  public List<EgovMap> getAllStockList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getAllStockList(params);
  }

  @Override
  public List<EgovMap> getInventoryStockByHolder(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getInventoryStockByHolder(params);
  }

  @Override
  public List<EgovMap> StockReceiveList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.StockReceiveList(params);
  }

  @Override
  public List<EgovMap> selectStockReceiveSerial(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.selectStockReceiveSerial(params);
  }

  @Override
  public List<EgovMap> selectStockReceiveSerialScan(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.selectStockReceiveSerialScan(params);
  }

  @Override
  public List<EgovMap> getMyStockList(Map<String, Object> params) {
    // TODO Auto-generated method stub

    // String serialRequireChkYn = MlogApiMapper.getSerialRequireChkYn(params);
    //
    // if("Y".equals(serialRequireChkYn)){
    // return MlogApiMapper.getMyStockListScan(params);
    // } else{
    // return MlogApiMapper.getMyStockList(params);
    // }

    return MlogApiMapper.getMyStockList(params);
  }

  @Override
  public List<EgovMap> getReturnPartsSearch(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getReturnPartsSearch(params);
  }

  @Override
  public List<EgovMap> getReturnPartsSearchScan(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getReturnPartsSearchScan(params);
  }

  @Override
  public List<EgovMap> getAlternativeFilterMList() {
    // TODO Auto-generated method stub
    return MlogApiMapper.getAlternativeFilterMList();
  }

  @Override
  public List<EgovMap> getAlternativeFilterDList() {
    // TODO Auto-generated method stub
    return MlogApiMapper.getAlternativeFilterDList();
  }

  @Override
  public List<EgovMap> getItemBankLocationList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getItemBankLocationList(params);
  }

  @Override
  public List<EgovMap> getItemBankItemList() {
    // TODO Auto-generated method stub
    return MlogApiMapper.getItemBankItemList();
  }

  @Override
  public List<EgovMap> getItemBankResultList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getItemBankResultList(params);
  }

  @Override
  public List<EgovMap> getCommonReqHeader(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getCommonReqHeader(params);
  }

  @Override
  public List<EgovMap> getCommonReqParts(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getCommonReqParts(params);
  }

  @Override
  public List<EgovMap> getCommonReqPartsScan(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getCommonReqPartsScan(params);
  }

  @Override
  public List<EgovMap> getAuditStockResultDetail(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getAuditStockResultDetail(params);
  }

  @Override
  public List<EgovMap> getStockTransferReqStatusMList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getStockTransferReqStatusMList(params);
  }

  @Override
  public List<EgovMap> getStockTransferReqStatusDList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getStockTransferReqStatusDList(params);
  }

  @Override
  public List<EgovMap> getNonBarcodeM(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getNonBarcodeM(params);
  }

  @Override
  public List<EgovMap> getNonBarcodeDList(String invenAdjustLocId) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getNonBarcodeDList(invenAdjustLocId);
  }

  @Override
  public List<EgovMap> getBarcodeDList(String invenAdjustLocId) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getBarcodeDList(invenAdjustLocId);
  }

  @Override
  public List<EgovMap> getBarcodeCList(String invenAdjustLocId) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getBarcodeCList(invenAdjustLocId);
  }

  @Override
  public List<EgovMap> getUsedPartsList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getUsedPartsList(params);
  }

  @Override
  public List<EgovMap> getMiscPartList() {
    // TODO Auto-generated method stub
    return MlogApiMapper.getMiscPartList();
  }

  @Override
  public List<EgovMap> getFilterNotChangeList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getFilterNotChangeList(params);
  }

  @Override
  public List<EgovMap> getFilterChangeList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getFilterChangeList(params);
  }

  @Override
  public List<EgovMap> getUserFilterList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getUserFilterList(params);
  }

  @Override
  public List<EgovMap> getInventoryOnHandStock(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getInventoryOnHandStock(params);
  }

  @Override
  public List<EgovMap> getInventoryOnHandStockNoSerial(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getInventoryOnHandStockNoSerial(params);
  }

  /**
   * 현창배 추가
   */

  @Override
  public List<EgovMap> getStockAuditResult(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getStockAuditResult(params);
  }

  @Override
  public List<EgovMap> getStockPriceList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getStockPriceList(params);
  }

  /**
   * 인서트 추가
   */

  @Override
  public void saveInvenReqTransfer(InventoryReqTransferMForm inventoryReqTransferMForm) {
    /* 2017-11-30 김덕호 위원 채번 변경 요청 */
    // String seq1 = MlogApiMapper.selectStockMovementSeq();
    // String headtitle = "SMO";
    String seq1 = MlogApiMapper.selectStockMovementSeq();
    logger.debug("seq1    값 : {}", seq1);
    Map<String, Object> insMap = new HashMap();
    insMap.put("userId", inventoryReqTransferMForm.getUserId());
    insMap.put("requestDate", inventoryReqTransferMForm.getRequestDate());
    insMap.put("smType", inventoryReqTransferMForm.getSmType());
    insMap.put("targetLocation", inventoryReqTransferMForm.getTargetLocation());
    // insMap.put("reqno", headtitle + seq1);
    insMap.put("reqno", seq1);

    logger.debug("insMap ?    값 : {}", insMap);

    MlogApiMapper.insStockMovementHead(insMap);

    List<InventoryReqTransferDForm> list = inventoryReqTransferMForm.getInventoryReqTransferDetail();
    InventoryReqTransferDForm form = null;

    for (int i = 0; i < list.size(); i++) {
      form = list.get(i);
      insMap.put("partsCode", form.getPartsCode());
      insMap.put("partsId", form.getPartsId());
      insMap.put("requestQty", form.getRequestQty());
      insMap.put("partsName", form.getPartsName());

      MlogApiMapper.insStockMovementDetail(insMap);

    }

    MlogApiMapper.insertStockBooking(insMap);

  }

  @Override
  public Map<String, Object> selectStockMovementSerial(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.selectStockMovementSerial(params);
  }

  @Override
  public Map<String, Object> selectDelvryGRcmplt(String delNo) {
    // TODO Auto-generated method stub
    return MlogApiMapper.selectDelvryGRcmplt(delNo);
  }

  @Override
  public void stockMovementReqDelivery(List<StockTransferConfirmGiMForm> stockTransferConfirmGiMForm) {
    /* 2017-11-30 김덕호 위원 채번 변경 요청 */
    String deliSeq = MlogApiMapper.selectDeliveryStockMovementSeq();
    Map<String, Object> insMap = new HashMap();
    // 2. insert ,54 , 55 , 61 ,56update start
    for (int i = 0; i < stockTransferConfirmGiMForm.size(); i++) {
      StockTransferConfirmGiMForm scgmf = stockTransferConfirmGiMForm.get(i);
      insMap.put("delno", deliSeq);
      insMap.put("itmcd", scgmf.getPartsCode());
      insMap.put("itmname", scgmf.getPartsName());
      insMap.put("reqstno", scgmf.getSmoNo());
      insMap.put("requestQty", scgmf.getRequestQty());
      insMap.put("userId", scgmf.getUserId());
      insMap.put("gtype", scgmf.getReqStatus());
      insMap.put("giptdate", MlogApiMapper.dateParsing(scgmf.getRequestDate()));

      // 55 insert
      MlogApiMapper.insertDeliveryStockMovementDetail(insMap);

      List<StockTransferConfirmGiDForm> list = scgmf.getStockTransferConfirmGiDetail();

      for (int j = 0; j < list.size(); j++) {

        StockTransferConfirmGiDForm scgdf = list.get(j);
        // 61insert
        insMap.put("serial", scgdf.getSerialNo());

        MlogApiMapper.insertMovementSerial(insMap);

      }

      if (i == 0) {
        System.out.println("i ???  :  " + i);
        MlogApiMapper.insertDeliveryStockMovement(insMap);
        MlogApiMapper.updateRequestMovement(insMap);
      }
    }
    int userLoc = MlogApiMapper.getUserLocId(insMap);
    String[] delvcd = { deliSeq };
    insMap.put("parray", delvcd);
    insMap.put("userId", userLoc);
    // insMap.put("userId", params.get("userId"));
    // formMap.put("prgnm", params.get("prgnm"));
    insMap.put("refdocno", "");
    insMap.put("salesorder", "");

    logger.debug("insMap    값 : {}", insMap);

    MlogApiMapper.StockMovementIssue(insMap);

  }

  @Override
  public void stockMovementReqDeliveryScan(List<StockTransferConfirmGiMForm> stockTransferConfirmGiMForm) {
    /* 2017-11-30 김덕호 위원 채번 변경 요청 */
    String deliSeq = MlogApiMapper.selectDeliveryStockMovementSeq();
    Map<String, Object> insMap = new HashMap();
    // 2. insert 55, 54 , update 47 start
    logger.info("++++ stockMovementReqDeliveryScan stockTransferConfirmGiMForm ::" + stockTransferConfirmGiMForm.toString());
    for (int i = 0; i < stockTransferConfirmGiMForm.size(); i++) {
      StockTransferConfirmGiMForm scgmf = stockTransferConfirmGiMForm.get(i);

      // logger.debug("++++ stockMovementReqDeliveryScan scgmf ::" + scgmf.) );

      insMap.put("delno", deliSeq);
      insMap.put("itmcd", scgmf.getPartsCode());
      insMap.put("itmname", scgmf.getPartsName());
      insMap.put("reqstno", scgmf.getSmoNo());
      insMap.put("requestQty", scgmf.getRequestQty());
      insMap.put("userId", scgmf.getUserId());
      insMap.put("gtype", scgmf.getReqStatus());
      insMap.put("giptdate", MlogApiMapper.dateParsing(scgmf.getRequestDate()));
      insMap.put("gipfdate", MlogApiMapper.dateParsing(scgmf.getRequestDate())); // 추가
      insMap.put("reqstNoItm", scgmf.getSmoNoItem());

      // LOG0055D insert
      MlogApiMapper.insertDeliveryStockMovementDetail(insMap);

      List<StockTransferConfirmGiDForm> list = scgmf.getStockTransferConfirmGiDetail();

      if (i == 0) {
        System.out.println("i ???  :  " + i);
        // LOG0054M insert
        MlogApiMapper.insertDeliveryStockMovement(insMap);

        // LOG0047M update
        MlogApiMapper.updateRequestMovement(insMap);
      }
    }
    int userLoc = MlogApiMapper.getUserLocId(insMap);
    String[] delvcd = { deliSeq };
    insMap.put("parray", delvcd);
    insMap.put("userId", userLoc);
    // insMap.put("userId", params.get("userId"));
    // formMap.put("prgnm", params.get("prgnm"));
    insMap.put("refdocno", "");
    insMap.put("salesorder", "");

    logger.debug("insMap    값 : {}", insMap);

    MlogApiMapper.StockMovementIssueScan(insMap);

    logger.debug("++++ stockMovementReqDeliveryScan StockMovementIssueScan insMap 값 : {}", insMap);

    String rdata = (String) insMap.get("rdata");
    String rcode = "";
    String rmsg = "";

    // System.out.println("++++ insMap ::" + insMap.toString() );
    // System.out.println("++++ rdata ::" + rdata.toString() );

    if (rdata != null && rdata.indexOf("∈") > 0) {
      rcode = (String) rdata.split("∈")[0];
      rmsg = (String) rdata.split("∈")[1];
    }
    if (!rcode.equals("000")) {
      throw new PreconditionException(AppConstants.FAIL, rmsg);
    }

    // Barcode Save Procedure call
    Map<String, Object> receiveMapBarcode = new HashMap();
    receiveMapBarcode.put("reqstNo", "");
    receiveMapBarcode.put("delvryNo", deliSeq);
    receiveMapBarcode.put("userId", userLoc);
    receiveMapBarcode.put("ioType", "O");

    // HLTANG 202111 - filter scan barcode
    receiveMapBarcode.put("reqstNo", stockTransferConfirmGiMForm.get(0).getSmoNo());
    receiveMapBarcode.put("zIoType", "O");
    // update status 'D' to 'C'
    SessionVO sessionVo = new SessionVO();
    sessionVo.setUserId(Integer.valueOf(userLoc));

    try {
      saveSerialNo(receiveMapBarcode, sessionVo);
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    // HLTANG 202111 - filter scan barcode end

    MlogApiMapper.LogisticBarcodeSave(receiveMapBarcode);

    logger.debug("++++ stockMovementReqDeliveryScan LogisticBarcodeSave receiveMapBarcode 값 : {}", receiveMapBarcode);

    String errcode = (String) receiveMapBarcode.get("errcode");
    String errmsg = (String) receiveMapBarcode.get("errmsg");
    if (!errcode.equals("000")) {
      throw new PreconditionException(AppConstants.FAIL, errmsg);
    }

  }

  @Override
  public String stockMovementCommonCancle(Map<String, Object> params) {

    Map<String, Object> cancleMap = new HashMap();
    cancleMap.put("userId", params.get("userId"));
    cancleMap.put("giptdate", params.get("requestDate"));
    cancleMap.put("smoNo", params.get("smoNo"));
    cancleMap.put("gtype", params.get("reqStatus"));

    String test = MlogApiMapper.StockMovementReqstChk(cancleMap);

    if (test != null && !"".equals(test)) { // 일반 요청 상태
      return "18";
    }

    String delvryNo = MlogApiMapper.StockMovementDelvryNo(cancleMap); // in : smo / out : delvry_no

    if (delvryNo == null || "".equals(delvryNo)) { // 일반 요청 상태
      MlogApiMapper.StockMovementReqstCancel(cancleMap);
    }

    return delvryNo;

  }

  @Override
  public void stockMovementConfirmReceive(ConfirmReceiveMForm confirmReceiveMForm) {

    Map<String, Object> receiveMap = new HashMap();
    receiveMap.put("userId", confirmReceiveMForm.getUserId());

    // receiveMap.put("gipfdate", confirmReceiveMForm.getRequestDate());
    // receiveMap.put("giptdate", confirmReceiveMForm.getRequestDate());
    receiveMap.put("gtype", confirmReceiveMForm.getReqStatus());

    String[] delvcd = new String[1];
    delvcd[0] = confirmReceiveMForm.getSmoNo();

    int userLoc = MlogApiMapper.getUserLocId(receiveMap);

    receiveMap.put("parray", delvcd);
    receiveMap.put("userId", userLoc);
    // formMap.put("prgnm", params.get("prgnm"));
    receiveMap.put("refdocno", "");
    receiveMap.put("salesorder", "");
    receiveMap.put("giptdate", MlogApiMapper.dateParsing(confirmReceiveMForm.getRequestDate()));
    logger.debug("stockMovementConfirmReceive receiveMap : {}", receiveMap);

    MlogApiMapper.StockMovementIssue(receiveMap);

  }

  @Override
  public void stockMovementConfirmReceiveScan(ConfirmReceiveMForm confirmReceiveMForm) {

    Map<String, Object> receiveMap = new HashMap();
    receiveMap.put("userId", confirmReceiveMForm.getUserId());

    // receiveMap.put("gipfdate", confirmReceiveMForm.getRequestDate());
    // receiveMap.put("giptdate", confirmReceiveMForm.getRequestDate());
    receiveMap.put("gtype", confirmReceiveMForm.getReqStatus());

    String[] delvcd = new String[1];
    delvcd[0] = confirmReceiveMForm.getSmoNo();

    int userLoc = MlogApiMapper.getUserLocId(receiveMap);

    receiveMap.put("parray", delvcd);
    receiveMap.put("userId", userLoc);
    // formMap.put("prgnm", params.get("prgnm"));
    receiveMap.put("refdocno", "");
    receiveMap.put("salesorder", "");
    receiveMap.put("gipfdate", MlogApiMapper.dateParsing(confirmReceiveMForm.getRequestDate())); // 추가
    receiveMap.put("giptdate", MlogApiMapper.dateParsing(confirmReceiveMForm.getRequestDate()));
    logger.debug("stockMovementConfirmReceiveScan receiveMap : {}", receiveMap);

    // HLTANG 202111 - filter scan barcode
    receiveMap.put("reqstNo", confirmReceiveMForm.getSmoNo());
    receiveMap.put("zIoType", "I");
    // update status 'D' to 'C'
    SessionVO sessionVo = new SessionVO();
    sessionVo.setUserId(Integer.valueOf(userLoc));

    try {
      saveSerialNo(receiveMap, sessionVo);
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    // HLTANG 202111 - filter scan barcode end

    MlogApiMapper.StockMovementIssueScan(receiveMap);

    String rdata = (String) receiveMap.get("rdata");
    String rcode = "";
    String rmsg = "";

    if (rdata != null && rdata.indexOf("∈") > 0) {
      rcode = (String) rdata.split("∈")[0];
      rmsg = (String) rdata.split("∈")[1];
    }

    if (!rcode.equals("000")) {
      throw new PreconditionException(AppConstants.FAIL, rmsg);
    }

    // Barcode Save Procedure call
    Map<String, Object> receiveMapBarcode = new HashMap();
    receiveMapBarcode.put("reqstNo", "");
    receiveMapBarcode.put("delvryNo", confirmReceiveMForm.getSmoNo());
    receiveMapBarcode.put("userId", userLoc);
    receiveMapBarcode.put("ioType", "I");

    MlogApiMapper.LogisticBarcodeSave(receiveMapBarcode);

    String errcode = (String) receiveMapBarcode.get("errcode");
    String errmsg = (String) receiveMapBarcode.get("errmsg");

    if (!errcode.equals("000")) {
      throw new PreconditionException(AppConstants.FAIL, errmsg);
      // throw new ApplicationException(AppConstants.FAIL, errmsg);
    }

  }

  @Override
  public void inputNonBarcode(InputNonBarcodeForm inputNonBarcodeForm) {
    // TODO Auto-generated method stub
    List<InputNonBarcodePartsForm> list = inputNonBarcodeForm.getInputNonBarcodePartsForm();
    for (int i = 0; i < list.size(); i++) {
      InputNonBarcodePartsForm form = list.get(i);
      Map<String, Object> setmap = new HashMap();
      setmap.put("userId", inputNonBarcodeForm.getUserId());
      setmap.put("invenAdjustNo", form.getInvenAdjustNo());
      setmap.put("partsCode", form.getPartsCode());
      setmap.put("partsId", form.getPartsId());
      setmap.put("invenAdjustNoItem", form.getInvenAdjustNoItem());
      setmap.put("countedQty", form.getCountedQty());

      MlogApiMapper.updateNonBarcodeQty(setmap);
    }
  }

  @Override
  public void inputBarcode(List<InputBarcodePartsForm> inputBarcodePartsForm) {

    for (int i = 0; i < inputBarcodePartsForm.size(); i++) {
      InputBarcodePartsForm form = inputBarcodePartsForm.get(i);
      Map<String, Object> setmap = new HashMap();
      setmap.put("userId", form.getUserId());
      setmap.put("invenAdjustNo", form.getInvenAdjustNo());
      setmap.put("partsCode", form.getPartsCode());
      setmap.put("partsId", form.getPartsId());
      setmap.put("invenAdjustNoItem", form.getInvenAdjustNoItem());
      setmap.put("countedQty", form.getCountedQty());

      logger.debug("setmapS1111111 : {}", setmap);

      MlogApiMapper.updateBarcodeQty(setmap);

      List<InputBarcodeListForm> serialList = form.getInputBarcodeListForm();
      for (int j = 0; j < serialList.size(); j++) {
        InputBarcodeListForm sForm = serialList.get(j);
        // Map<String, Object> setmapS = new HashMap();
        // setmap.put("userId", form.getUserId());
        setmap.put("serialNo", sForm.getSerialNo());
        // setmap.put("invenAdjustNoItem", form.getInvenAdjustNoItem());

        // logger.debug("setmapS222222 : {}", setmapS);
        // logger.debug("getSerialNo????? : {}", sForm.getSerialNo());

        MlogApiMapper.insertBarcode(setmap);
      }

    }
  }

  @Override
  public void returnOnHandStockReq(ReturnOnHandStockReqMForm returnOnHandStockReqMForm) {

    logger.info("++++ returnOnHandStockReq returnOnHandStockReqScan  {}", returnOnHandStockReqMForm);

    /* 2017-11-30 김덕호 위원 채번 변경 요청 */
    String seq = MlogApiMapper.selectStockMovementSeq();
    String deliSeq = MlogApiMapper.selectDeliveryStockMovementSeq();
    String headtitle = "SMO";
    String gtype = "GI";
    Map<String, Object> returnMap = new HashMap();
    // returnMap.put("reqno", headtitle + seq);
    returnMap.put("reqno", seq);
    returnMap.put("userId", returnOnHandStockReqMForm.getUserId());
    returnMap.put("giptdate", returnOnHandStockReqMForm.getRequestDate());
    returnMap.put("smType", returnOnHandStockReqMForm.getSmType());
    returnMap.put("targetLocation", returnOnHandStockReqMForm.getTargetLocation());

    String whLocId = MlogApiMapper.selectWhLocId(returnMap);
    returnMap.put("rcivCdcRdc", whLocId);

    int userLoc = MlogApiMapper.getUserLocId(returnMap);

    logger.info("++++ returnOnHandStockReq receiveMap    값 : {}", returnMap);

    MlogApiMapper.insStockMovementHeads(returnMap);

    List<ReturnOnHandStockReqDForm> list = returnOnHandStockReqMForm.getReturnOnHandStockReqDetail();

    ReturnOnHandStockReqDForm form = null;
    Map<String, Object> insMap = new HashMap();

    for (int i = 0; i < list.size(); i++) {

      form = list.get(i);

      // insMap.put("reqno", headtitle + seq);
      insMap.put("reqno", seq);
      insMap.put("partsCode", form.getPartsCode());
      insMap.put("partsId", form.getPartsId());
      insMap.put("requestQty", form.getRequestQty());
      insMap.put("serialNo", form.getSerialNo());
      insMap.put("partsName", form.getPartsName());
      insMap.put("userId", returnOnHandStockReqMForm.getUserId());

      // logger.debug("reqno 값 : {}", headtitle + seq);
      // logger.debug("partsCode 값 : {}", insMap.get("partsCode"));
      // logger.debug("partsId 값 : {}", insMap.get("partsId"));
      // logger.debug("requestQty 값 : {}", insMap.get("requestQty"));
      // logger.debug("serialNo 값 : {}", insMap.get("serialNo"));
      // logger.debug("partsName 값 : {}", insMap.get("partsName"));

      MlogApiMapper.insStockMovementDetail(insMap);

      // 2. insert ,54 , 55 , 61 ,56update start

      insMap.put("delno", deliSeq);
      insMap.put("itmcd", insMap.get("partsCode"));
      insMap.put("itmname", insMap.get("partsName"));
      insMap.put("reqstno", insMap.get("reqno"));

      // logger.debug("partsCode 값 : {}", insMap.get("partsCode"));
      // logger.debug("partsId 값 : {}", insMap.get("partsId"));
      // logger.debug("requestQty 값 : {}", insMap.get("requestQty"));
      // logger.debug("serialNo 값 : {}", insMap.get("serialNo"));
      // logger.debug("partsName 값 : {}", insMap.get("partsName"));

      // 55 insert
      MlogApiMapper.insertDeliveryStockMovementDetail(insMap);

      if (form.getSerialNo() != null && form.getSerialNo() != "") {
        // 61insert
        insMap.put("serial", insMap.get("serialNo"));
        MlogApiMapper.insertMovementSerial(insMap);
      }

      // if (i == 0) {
      // MlogApiMapper.insertDeliveryStockMovement(insMap);
      // MlogApiMapper.updateRequestMovement(insMap);
      // }
    }

    MlogApiMapper.insertDeliveryStockMovement(insMap);
    MlogApiMapper.updateRequestMovement(insMap);

    String[] delvcd = new String[1];
    delvcd[0] = deliSeq;

    logger.debug("delvcd    값 : {}", delvcd);
    insMap.put("parray", delvcd);
    insMap.put("userId", userLoc);
    // insMap.put("userId", params.get("userId"));
    // formMap.put("prgnm", params.get("prgnm"));
    insMap.put("refdocno", "");
    insMap.put("salesorder", "");
    insMap.put("gtype", gtype);
    // insMap.put("giptdate", returnOnHandStockReqMForm.getRequestDate());
    insMap.put("giptdate", MlogApiMapper.dateParsing(returnOnHandStockReqMForm.getRequestDate()));

    MlogApiMapper.StockMovementIssue(insMap);

    logger.debug("insMap    값 : {}", insMap);

  }

  @Override
  public void returnOnHandStockReqScan(ReturnOnHandStockReqMForm returnOnHandStockReqMForm) {

    logger.info("++++ returnOnHandStockReqScan returnOnHandStockReqScan  {}", returnOnHandStockReqMForm);

    /* 2017-11-30 김덕호 위원 채번 변경 요청 */
    // create SMO no
    String seq = MlogApiMapper.selectStockMovementSeq();
    // create Delivery no
    String deliSeq = MlogApiMapper.selectDeliveryStockMovementSeq();
    String headtitle = "SMO";
    String gtype = "GI";
    Map<String, Object> returnMap = new HashMap();
    // returnMap.put("reqno", headtitle + seq);

    returnMap.put("reqno", seq);
    returnMap.put("userId", returnOnHandStockReqMForm.getUserId());
    returnMap.put("giptdate", returnOnHandStockReqMForm.getRequestDate());
    returnMap.put("smType", returnOnHandStockReqMForm.getSmType());
    returnMap.put("targetLocation", returnOnHandStockReqMForm.getTargetLocation());

    String whLocId = MlogApiMapper.selectWhLocId(returnMap);
    returnMap.put("rcivCdcRdc", whLocId);

    int userLoc = MlogApiMapper.getUserLocId(returnMap);

    logger.info("++++ returnOnHandStockReq receiveMap    값 : {}", returnMap);

    // 1. LOG0047M insert
    MlogApiMapper.insStockMovementHeads(returnMap);

    List<ReturnOnHandStockReqDForm> list = returnOnHandStockReqMForm.getReturnOnHandStockReqDetail();

    ReturnOnHandStockReqDForm form = null;
    Map<String, Object> insMap = new HashMap();
    Map<String, Object> itmMap = new HashMap();

    String scanNo = "";
    for (int i = 0; i < list.size(); i++) {

      form = list.get(i);

      System.out.println("++++ list.get(" + i + ") ::" + list.get(i));
      System.out.println("++++ form ::" + form.toString());

      itmMap.put("reqno", seq);
      itmMap.put("partsCode", form.getPartsCode());
      int itmChk = MlogApiMapper.selectSMDitmExist(itmMap);
      System.out.println("++++ form.getSerialNo() ::" + String.valueOf(form.getSerialNo()));
      System.out.println("++++ itmChk ::" + String.valueOf(itmChk));
      if (itmChk > 0) {
        itmMap.put("requestQty", String.valueOf(form.getRequestQty()));
        MlogApiMapper.updateRequestMovementQty(itmMap);

        itmMap.put("delno", deliSeq);
        MlogApiMapper.updateDeliveryMovementQty(itmMap);

        insMap.put("reqno", seq);
        insMap.put("partsCode", form.getPartsCode());
        insMap.put("partsId", form.getPartsId());
        insMap.put("requestQty", form.getRequestQty());
        insMap.put("serialNo", form.getSerialNo());
        insMap.put("partsName", form.getPartsName());
        insMap.put("userId", returnOnHandStockReqMForm.getUserId());

        insMap.put("delno", deliSeq);
        insMap.put("itmcd", insMap.get("partsCode"));
        insMap.put("itmname", insMap.get("partsName"));
        insMap.put("reqstno", insMap.get("reqno"));
      } else {
        // insMap.put("reqno", headtitle + seq);
        insMap.put("reqno", seq);
        insMap.put("partsCode", form.getPartsCode());
        insMap.put("partsId", form.getPartsId());
        insMap.put("requestQty", form.getRequestQty());
        insMap.put("serialNo", form.getSerialNo());
        insMap.put("partsName", form.getPartsName());
        insMap.put("userId", returnOnHandStockReqMForm.getUserId());

        // logger.debug("reqno 값 : {}", headtitle + seq);
        // logger.debug("partsCode 값 : {}", insMap.get("partsCode"));
        // logger.debug("partsId 값 : {}", insMap.get("partsId"));
        // logger.debug("requestQty 값 : {}", insMap.get("requestQty"));
        // logger.debug("serialNo 값 : {}", insMap.get("serialNo"));
        // logger.debug("partsName 값 : {}", insMap.get("partsName"));

        // 2. LOG0048D insert
        MlogApiMapper.insStockMovementDetail(insMap);

        System.out.println("++++ insMap.toString() ::" + insMap.toString());

        insMap.put("delno", deliSeq);
        insMap.put("itmcd", insMap.get("partsCode"));
        insMap.put("itmname", insMap.get("partsName"));
        insMap.put("reqstno", insMap.get("reqno"));

        // logger.debug("partsCode 값 : {}", insMap.get("partsCode"));
        // logger.debug("partsId 값 : {}", insMap.get("partsId"));
        // logger.debug("requestQty 값 : {}", insMap.get("requestQty"));
        // logger.debug("serialNo 값 : {}", insMap.get("serialNo"));
        // logger.debug("partsName 값 : {}", insMap.get("partsName"));

        // 55 insert
        // 3. LOG0055D merge
        MlogApiMapper.insertDeliveryStockMovementDetail(insMap);
      }

      if (form.getSerialNo() != null && form.getSerialNo() != "") {
        // scan info

        Map<String, Object> outScanMap = new HashMap();
        outScanMap.put("scanNo", scanNo);
        outScanMap.put("serial", insMap.get("serialNo"));
        outScanMap.put("reqstNo", seq);
        outScanMap.put("delvryNo", deliSeq);
        outScanMap.put("ioType", "O");
        outScanMap.put("userId", userLoc);

        outScanMap.put("fromLocCode", whLocId);
        outScanMap.put("toLocCode", returnOnHandStockReqMForm.getTargetLocation());

        // 4. SP_LOGISTIC_BARCODE_SCAN call
        // MlogApiMapper.LogisticBarcodeScan(outScanMap);
        MlogApiMapper.LogisticBarcodeScanUsum(outScanMap);

        // HLTANG 202111 - filter scan barcode
        // outScanMap.put("reqstNo", stockTransferConfirmGiMForm.get(0).getSmoNo());
        outScanMap.put("zIoType", "O");
        // update status 'D' to 'C'
        SessionVO sessionVo = new SessionVO();
        sessionVo.setUserId(Integer.valueOf(userLoc));

        try {
          saveSerialNo(outScanMap, sessionVo);
        } catch (Exception e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
        }
        // HLTANG 202111 - filter scan barcode end

        String errcodeScan = (String) outScanMap.get("errcode");
        String errmsgScan = (String) outScanMap.get("errmsg");
        if (!errcodeScan.equals("000")) {
          throw new PreconditionException(AppConstants.FAIL, errmsgScan);
        }

        scanNo = (String) outScanMap.get("outScanNo");
      }

    }

    // 5. LOG0054M insert
    MlogApiMapper.insertDeliveryStockMovement(insMap);

    // 6. LOG0047M update
    MlogApiMapper.updateRequestMovement(insMap);

    String[] delvcd = new String[1];
    delvcd[0] = deliSeq;

    logger.debug("delvcd    값 : {}", delvcd);
    insMap.put("parray", delvcd);
    insMap.put("userId", userLoc);
    // insMap.put("userId", params.get("userId"));
    // formMap.put("prgnm", params.get("prgnm"));
    insMap.put("refdocno", "");
    insMap.put("salesorder", "");
    insMap.put("gtype", gtype);
    // insMap.put("giptdate", returnOnHandStockReqMForm.getRequestDate());
    insMap.put("giptdate", MlogApiMapper.dateParsing(returnOnHandStockReqMForm.getRequestDate()));
    insMap.put("gipfdate", MlogApiMapper.dateParsing(returnOnHandStockReqMForm.getRequestDate())); // 추가

    // 7. SP_LOGISTIC_DELIVERY_SERIAL call
    MlogApiMapper.StockMovementIssueScan(insMap);

    logger.debug("insMap    값 : {}", insMap);

    String rdata = (String) insMap.get("rdata");
    String rcode = "";
    String rmsg = "";
    if (rdata != null && rdata.indexOf("∈") > 0) {
      rcode = (String) rdata.split("∈")[0];
      rmsg = (String) rdata.split("∈")[1];
    }
    if (!rcode.equals("000")) {
      throw new PreconditionException(AppConstants.FAIL, rmsg);
    }

    // Barcode Save Procedure call
    Map<String, Object> receiveMapBarcode = new HashMap();
    receiveMapBarcode.put("reqstNo", seq);
    receiveMapBarcode.put("delvryNo", deliSeq);
    receiveMapBarcode.put("userId", userLoc);
    receiveMapBarcode.put("ioType", "O");

    // 8. SP_LOGISTIC_BARCODE_SAVE call
    MlogApiMapper.LogisticBarcodeSave(receiveMapBarcode);

    String errcode = (String) receiveMapBarcode.get("errcode");
    String errmsg = (String) receiveMapBarcode.get("errmsg");
    if (!errcode.equals("000")) {
      throw new PreconditionException(AppConstants.FAIL, errmsg);
    }

  }

  /* Woongjin Jun */
  @Override
  public List<EgovMap> getStockHCPriceList(Map<String, Object> params) {
    return MlogApiMapper.getStockHCPriceList(params);
  }
  /* Woongjin Jun */

  /* Woongjin Han */
  @Override
  public List<EgovMap> getStockTransferReqStatusDListScan(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getStockTransferReqStatusDListScan(params);
  }
  /* Woongjin Han */

  public void saveSerialNo(Map<String, Object> params, SessionVO sessionVo) throws Exception { // HLTANG 202111 - filter barcode scan
    List<EgovMap> grListmain = MlogApiMapper.selectSerialInfo(params);

    Map<String, Object> mainMap = null;
    for (Object obj : grListmain) {
      mainMap = (Map<String, Object>) obj;
      MlogApiMapper.updateDeliveryGrDetail(mainMap);// log0099m
      MlogApiMapper.updateDeliveryGrMain(mainMap);// log0100m

      List<EgovMap> grList1 = MlogApiMapper.selectDeliveryGrHist(mainMap);
      Map<String, Object> oMap = null;
      for (EgovMap info : grList1) {
        oMap = new HashMap<String, Object>();
        oMap.put("updUserId", sessionVo.getUserId());
        oMap.put("crtUserId", sessionVo.getUserId());
        oMap.put("serialNo", info.get("serialNo").toString());
        oMap.put("seq", info.get("seq").toString());
        oMap.put("ioType", mainMap.get("ioType"));

        MlogApiMapper.updateDeliveryGrHist(oMap);// log0101h
      }
    }
  }

  @Override
  public List<EgovMap> getHiCareInventory(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return MlogApiMapper.getHiCareInventory(params);
  }

  @Override
  public Map<String, Object> getSMOCntList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    logger.debug("getSMOCntList   getSMOCntList : {}", params.toString());
    Map<String, Object> mainMap = new HashMap();
    int recCnt = MlogApiMapper.getSMOReceiveCntList(params);
    int moveCnt = MlogApiMapper.getSMOMoveOutCntList(params);

    logger.debug("getSMOCntList   recCnt : {}", recCnt);
    logger.debug("getSMOCntList   moveCnt : {}", moveCnt);
    mainMap.put("toRecCnt", recCnt);
    mainMap.put("toMoveOutCnt", moveCnt);

    return mainMap;
  }

  @Override
  public List<EgovMap> getOnHandStkSerialList(Map<String, Object> params) {
    return MlogApiMapper.getOnHandStkSerialList(params);
  }

  @Override
  public List<EgovMap> getAllMember(Map<String, Object> params) {
    return MlogApiMapper.getAllMember(params);
  }

  @Override
  public List<EgovMap> getCodyAvaFilterList(Map<String, Object> params) {
    return MlogApiMapper.getCodyAvaFilterList(params);
  }


}
