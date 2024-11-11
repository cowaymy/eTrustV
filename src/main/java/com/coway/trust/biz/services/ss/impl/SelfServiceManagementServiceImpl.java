package com.coway.trust.biz.services.ss.impl;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.customer.impl.CustomerMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.impl.HsManualMapper;
import com.coway.trust.biz.services.ss.SelfServiceManagementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("selfServiceManagementService")
public class SelfServiceManagementServiceImpl extends EgovAbstractServiceImpl implements SelfServiceManagementService {
  private static final Logger LOGGER = LoggerFactory.getLogger(SelfServiceManagementServiceImpl.class);

  @Value("${app.name}")
  private String appName;

  @Resource(name = "selfServiceManagementMapper")
  private SelfServiceManagementMapper selfServiceManagementMapper;

  @Autowired
  private MessageSourceAccessor messageSourceAccessor;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "hsManualMapper")
  private HsManualMapper hsManualMapper;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Resource(name = "customerMapper")
  private CustomerMapper customerMapper;

  // Define constants for codes
  private static final String SUCCESS_CODE = "000";
  private static final String ERROR_CODE = "999";
  private static final String WAREHOUSE_LOC_CODE = "2010"; // CJ KL_A
  // private static final String WAREHOUSE_LOC_ID = "1532";
  private static final String ERROR_MESSAGE_STOCK = "Insufficient stock available in warehouse (CJ KL_A). Please try again later when the stock is replenished.";
  private static final String ERROR_MESSAGE_SERIAL_USE = "This serial had been used.";

  @Override
  public List<EgovMap> selectSelfServiceJsonList(Map<String, Object> params) throws Exception {
    return selfServiceManagementMapper.selectSelfServiceJsonList(params);
  }

  @Override
  public List<EgovMap> selectSelfServiceFilterItmList(Map<String, Object> params) throws Exception {
    return selfServiceManagementMapper.selectSelfServiceFilterItmList(params);
  }

  @Override
  public Map<String, Object> saveSelfServiceResult(Map<String, Object> params) throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();
    Map<String, Object> locInfoEntry = new HashMap<>();

    try {
      // Step 1: Validate ssResultId
      BigDecimal ssResultId = validateSsResultId(params);

      // Step 2: Handle new or update scenarios
      if (BigDecimal.ZERO.equals(ssResultId)) {
        handleNewResultEntry(params, rtnMap, locInfoEntry);
      } else {
        updateExistingItems(params);
      }

      rtnMap.put("logError", SUCCESS_CODE);
      rtnMap.put("message", params.get("serviceNo"));
    } catch (Exception e) {
      handleException(params, rtnMap, e);
    }

    return rtnMap;
  }

  // Helper method to validate ssResultId
  private BigDecimal validateSsResultId(Map<String, Object> params) {
    String ssResultIdStr = Optional.ofNullable(params.get("ssResultId")).map(Object::toString).orElse("0");
    return new BigDecimal(ssResultIdStr);
  }

  private void handleNewResultEntry(Map<String, Object> params, Map<String, Object> rtnMap,
      Map<String, Object> locInfoEntry) throws Exception {
    List<Map<String, Object>> selfServiceItemGrid = (List<Map<String, Object>>) params.get("add");
    // Perform insertion and DHL shipment

    for (Map<String, Object> itemMap : selfServiceItemGrid) {
      // check stock quantity on warehouse
      if (!checkStockAvailability(itemMap, locInfoEntry)) {
        throw new Exception(ERROR_MESSAGE_STOCK + " " + itemMap.get("stkCode") + " - " + itemMap.get("stkDesc"));
      }
      // check serial used in SVC0145D
      EgovMap filter = selfServiceManagementMapper.checkFilterBarCodeNo(itemMap);
      if (filter != null && !filter.isEmpty()) {
        throw new Exception(ERROR_MESSAGE_SERIAL_USE + " " + filter.get("hsNo") + " - " + filter.get("serialNo"));
      } else {
        // do nothing.
      }
    }

    insertSelfServiceResult(params, selfServiceItemGrid);
    //prepareAndSendDHLShipment(params, rtnMap);
  }

  private boolean checkStockAvailability(Map<String, Object> itemMap, Map<String, Object> locInfoEntry)
      throws Exception {
    locInfoEntry.put("CT_CODE", WAREHOUSE_LOC_CODE);
    locInfoEntry.put("STK_CODE", itemMap.get("stkId"));
    EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);
    if (locInfo == null
        || Integer.parseInt(locInfo.get("availQty").toString()) < Integer.parseInt(itemMap.get("c1").toString())) {
      return false;
    }
    return true;
  }

  // Helper method to insert result into master and details
  private void insertSelfServiceResult(Map<String, Object> params, List<Map<String, Object>> selfServiceItemGrid)
      throws Exception {
    int selfServiceResultMasterSeq = selfServiceManagementMapper.getSeqSVC0144M();
    params.put("ssResultId", selfServiceResultMasterSeq);
    selfServiceManagementMapper.insertSelfServiceResultMaster(params);

    for (Map<String, Object> itemMap : selfServiceItemGrid) {
      int selfServiceResultDetailSeq = selfServiceManagementMapper.getSeqSVC0145D();
      itemMap.put("ssResultItmId", selfServiceResultDetailSeq);
      itemMap.put("ssResultId", selfServiceResultMasterSeq);
      itemMap.put("crtUsrId", params.get("crtUsrId"));
      selfServiceManagementMapper.insertSelfServiceResultDetail(itemMap);
    }
  }

  // Helper method to prepare and send DHL shipment
  private void prepareAndSendDHLShipment(Map<String, Object> params, Map<String, Object> rtnMap) throws Exception {
    EgovMap ssItmString = selfServiceManagementMapper.selectSelfServiceItmList(params);
    if (ssItmString == null)
      throw new Exception("Self-service item list is null.");

    EgovMap addrMap = customerMapper.selectCustomerViewMainAddress(params);
    if (addrMap == null)
      throw new Exception("Customer Main address information is null.");

    EgovMap cnctMap = customerMapper.selectCustomerViewMainContact(params);
    if (cnctMap == null)
      throw new Exception("Customer Main contact information is null.");

    Map<String, Object> dhlShipmentParam = createDhlShipmentParam(params, ssItmString, addrMap, cnctMap);
    EgovMap rtnData = commonService.createDhlShpt(dhlShipmentParam);

    if (!"200".equals(rtnData.get("status"))) {
      throw new Exception("DHL Shipment - ERRCODE : " + rtnData.get("status") + " - " + rtnData.get("message"));
    }
  }

  // Helper method to create DHL shipment parameters
  private Map<String, Object> createDhlShipmentParam(Map<String, Object> params, EgovMap ssItmString, EgovMap addrMap,
      EgovMap cnctMap) {
    Map<String, Object> tckInfo = new HashMap<>();
    tckInfo.put("tckNo", params.get("serviceNo"));
    tckInfo.put("itmDesc", ssItmString.get("itmList"));

    Map<String, Object> custInfo = new HashMap<>();
    custInfo.put("name", addrMap.get("name"));
    custInfo.put("addr1", addrMap.get("addrDtl"));
    custInfo.put("addr2",
        Optional.ofNullable(addrMap.get("street")).map(Object::toString).filter(s -> !s.trim().isEmpty()).orElse("-"));
    custInfo.put("addr3", addrMap.get("area"));
    custInfo.put("city", addrMap.get("city"));
    custInfo.put("state", addrMap.get("state"));
    custInfo.put("country", addrMap.get("iso"));
    custInfo.put("postCode", addrMap.get("postcode"));
    custInfo.put("phone", cnctMap.get("telM1"));
    custInfo.put("email", cnctMap.get("email"));

    Map<String, Object> dhlShipmentParam = new HashMap<>();
    dhlShipmentParam.put("tckInfo", Collections.singletonList(tckInfo));
    dhlShipmentParam.put("custInfo", Collections.singletonList(custInfo));

    return dhlShipmentParam;
  }

  // Helper method to update existing items
  private void updateExistingItems(Map<String, Object> params) {
    List<Map<String, Object>> updateSelfServiceItemGrid = (List<Map<String, Object>>) params.get("edit");
    for (Map<String, Object> itemMap : updateSelfServiceItemGrid) {
      itemMap.put("updUsrId", params.get("crtUsrId"));
      selfServiceManagementMapper.updateSelfServiceResultDetail(itemMap);
    }
  }

  // Helper method to handle exceptions
  private void handleException(Map<String, Object> params, Map<String, Object> rtnMap, Exception e) {
    selfServiceManagementMapper.rollbackSelfServiceResultMaster(params);
    selfServiceManagementMapper.rollbackSelfServiceResultDetail(params);
    rtnMap.put("logError", ERROR_CODE);
    rtnMap.put("message", e.getMessage());
  }

  @Override
  public List<EgovMap> getSelfServiceFilterList(Map<String, Object> params) throws Exception {
    return selfServiceManagementMapper.getSelfServiceFilterList(params);
  }

  @Override
  public List<EgovMap> getSelfServiceDelivryList(Map<String, Object> params) throws Exception {
    return selfServiceManagementMapper.getSelfServiceDelivryList(params);
  }

  @Override
  public List<EgovMap> getSelfServiceRtnItmDetailList(Map<String, Object> params) throws Exception {
    return selfServiceManagementMapper.getSelfServiceRtnItmDetailList(params);
  }

  @Override
  public List<EgovMap> getSelfServiceRtnItmList(Map<String, Object> params) throws Exception {
    return selfServiceManagementMapper.getSelfServiceRtnItmList(params);
  }

  @Override
  public EgovMap selectSelfServiceResultInfo(Map<String, Object> params) {
    return selfServiceManagementMapper.selectSelfServiceResultInfo(params);
  }

  public Map<String, Object> updateSelfServiceResultStatus(Map<String, Object> params) throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();
    try {
      selfServiceManagementMapper.updateHsMasterStatus(params);

      selfServiceManagementMapper.updateSsMasterStatus(params);

      // LOGISTIC CALL HERE
      rtnMap.put("logError", SUCCESS_CODE);
      rtnMap.put("message", "");

    } catch (Exception e) {
      rtnMap.put("logError", ERROR_CODE);
      rtnMap.put("message", e.getMessage());
    }
    return rtnMap;
  }

  @SuppressWarnings("unchecked")
  @Override
  public Map<String, Object> updateReturnGoodsQty(Map<String, Object> params) throws Exception {
    Map<String, Object> rtnMap = new HashMap<>();
    try {
      // Early validation
      if (params == null || params.get("rtnItmList") == null) {
        throw new IllegalArgumentException("Return item list is missing.");
      }

      List<Object> ssItemGrid = (List<Object>) params.get("rtnItmList");

      // Validate crtUsrId
      if (params.get("crtUsrId") == null) {
        throw new IllegalArgumentException("Creator user ID is missing.");
      }

      // Generate Return Master ID and Number
      String ssRtnNo = orderRegisterMapper.selectDocNo(203);
      if (ssRtnNo == null || ssRtnNo.isEmpty()) {
        throw new IllegalArgumentException("Unable to generate return number.");
      }

      int ssRtnMasterSeq = selfServiceManagementMapper.getSeqSVC0146M();
      if (ssRtnMasterSeq == 0) {
        throw new IllegalStateException("Failed to generate valid sequence for Return Master.");
      }

      params.put("ssRtnId", ssRtnMasterSeq);
      params.put("ssRtnNo", ssRtnNo);

      // Insert into Self Service Stock Return Master (SVC0146M)
      selfServiceManagementMapper.insertSelfServiceStockReturnMaster(params);

      // Insert Return Items Details
      for (int idx = 0; idx < ssItemGrid.size(); idx++) {
        Map<String, Object> itemMap = (Map<String, Object>) ssItemGrid.get(idx);

        int ssRtnDetailSeq = selfServiceManagementMapper.getSeqSVC0147D();
        itemMap.put("ssRtnItmId", ssRtnDetailSeq);
        itemMap.put("ssRtnId", ssRtnMasterSeq);
        itemMap.put("crtUsrId", params.get("crtUsrId"));

        // Insert item into details
        selfServiceManagementMapper.insertSelfServiceStockReturnDetail(itemMap);
      }

      // Placeholder for Logistics handling
      // insertLogisticsData(ssRtnNo, ssRtnMasterSeq); // Example method for logistics integration

      // Success response
      rtnMap.put("logError", SUCCESS_CODE);
      rtnMap.put("message", "Return goods quantity updated successfully.");

    } catch (IllegalArgumentException | IllegalStateException e) {
      // Specific exception handling for input validation errors
      LOGGER.error("Error during stock return processing: " + e.getMessage(), e);
      rtnMap.put("logError", ERROR_CODE);
      rtnMap.put("message", "Input validation failed: " + e.getMessage());

    } catch (Exception e) {
      // General exception handling for unexpected errors
      LOGGER.error("Unexpected error: " + e.getMessage(), e);
      rtnMap.put("logError", ERROR_CODE);
      rtnMap.put("message", "An error occurred: " + e.getMessage());

      // Rollback in case of failure
      selfServiceManagementMapper.rollbackSelfServiceReturnGoodsQty(params);
      selfServiceManagementMapper.rollbackSelfServiceReturnQty(params);
    }
    return rtnMap;
  }

}