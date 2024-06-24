package com.coway.trust.biz.homecare.services.install.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.services.install.HcInstallResultListService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.installation.impl.InstallationResultListMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hcInstallResultListService")
public class HcInstallResultListServiceImpl extends EgovAbstractServiceImpl implements HcInstallResultListService {

  private static final Logger logger = LoggerFactory.getLogger(HcInstallResultListServiceImpl.class);

  @Resource(name = "installationResultListService")
  private InstallationResultListService installationResultListService;

  @Resource(name = "hcInstallResultListMapper")
  private HcInstallResultListMapper hcInstallResultListMapper;

  @Resource(name = "hcOrderListService")
  private HcOrderListService hcOrderListService;

  @Resource(name = "installationResultListMapper")
  private InstallationResultListMapper installationResultListMapper;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private AdaptorService adaptorService;

  /**
   * Insert Installation Result
   *
   * @Author KR-JIN
   * @param params
   * @param sessionVO
   * @return
   * @throws ParseException
   * @see com.coway.trust.biz.homecare.services.install.HcInstallResultListService#insertInstallationResultSerial(java.util.Map,
   *      com.coway.trust.cmmn.model.SessionVO)
   */
  @Override
  public ReturnMessage hcInsertInstallationResultSerial(Map<String, Object> params1, SessionVO sessionVO)
      throws Exception {
    ReturnMessage message = new ReturnMessage();
    String rmsg = "";

    Map<String, Object> params = (Map<String, Object>)params1.get("installForm");
    List<String> installAccList = (List<String>) params1.get("installAccList");

    ReturnMessage rtnMsg = insertInstallationResultSerial(params, sessionVO);

    if ("99".equals(rtnMsg.getCode())) {
      throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMsg.getMessage()));
    }
    rmsg = rtnMsg.getMessage();

    EgovMap installRsult = installationResultListService.getInstallResultByInstallEntryID(params);

      if (params.get("chkInstallAcc") != null && (params.get("chkInstallAcc").toString().equals("on") || params.get("chkInstallAcc").toString().equals("Y"))){
        try {
          insertHcInstallationAccessories(installAccList,installRsult,sessionVO.getUserId());
        } catch (Exception e) {
          logger.error("An error occurred during insertion of installation accessories.", e);
        }
      }

    // another order -- Frame Order Search.
    // params.put("ordNo",
    // CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
    // EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);

    Map<String, Object> oMap = new HashMap<String, Object>();
    oMap.put("salesOrdNo", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
    EgovMap hcOrder = hcInstallResultListMapper.selectFrmOrdNo(oMap);

    Map<String, Object> hcSubmitOrdStatus = hcInstallResultListMapper.selectSubmitStatusOrd(oMap);

    if(hcOrder != null && hcSubmitOrdStatus != null && hcSubmitOrdStatus.get("soCurStusId").toString().equals("25")){
    	hcOrder = null;
    }

    if (hcOrder != null) {
      hcOrder.put("anoOrdNo", (String) hcOrder.get("salesOrdNo"));
    }

    if (hcOrder != null && !"".equals(CommonUtils.nvl(hcOrder.get("anoOrdNo")))) { // hava another order
      params.put("anoOrdNo", CommonUtils.nvl(hcOrder.get("anoOrdNo")));

      EgovMap anotherOrder = hcInstallResultListMapper.getAnotherInstallInfo(params);
      params.put("installEntryId", CommonUtils.nvl(anotherOrder.get("installEntryId")));
      params.put("hidSalesOrderId", CommonUtils.nvl(anotherOrder.get("salesOrdId")));
      params.put("hiddeninstallEntryNo", CommonUtils.nvl(anotherOrder.get("installEntryNo")));
      params.put("rcdTms", CommonUtils.nvl(anotherOrder.get("rcdTms")));
      params.put("hidEntryId", CommonUtils.nvl(anotherOrder.get("installEntryId")));
      // frame serial use.
      params.put("serialNo", CommonUtils.nvl(params.get("frmSerialNo")));
      params.put("hidSerialRequireChkYn", CommonUtils.nvl(params.get("hidFrmSerialChkYn")));

      /* hidden input Start - KR-JIN */
      EgovMap callType = installationResultListService.selectCallType(anotherOrder);

      if (callType != null) {
        params.put("hidCallType", callType.get("typeId"));
      }

      EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);

      if (installResult != null) {
        params.put("hidCustomerId", installResult.get("custId"));
        params.put("hidSirimNo", installResult.get("sirimNo"));  // hidSerialNo
        params.put("hidStockIsSirim", installResult.get("isSirim"));
        params.put("hidStockGrade", installResult.get("stkGrad"));
        params.put("hidSirimTypeId", installResult.get("stkCtgryId"));
        params.put("hidAppTypeId", installResult.get("codeId"));
        params.put("hidProductId", installResult.get("installStkId"));
        params.put("hidCustAddressId", installResult.get("custAddId"));
        params.put("hidCustContactId", installResult.get("custCntId"));
        params.put("hiddenBillId", installResult.get("custBillId"));
        params.put("hiddenCustomerPayMode", installResult.get("codeName"));
        params.put("hidTaxInvDSalesOrderNo", installResult.get("salesOrdNo"));
        params.put("hidTradeLedger_InstallNo", installResult.get("installEntryNo"));
      }

      EgovMap stock = installationResultListService.getStockInCTIDByInstallEntryIDForInstallationView(installResult);

      if (stock != null) {
        params.put("hidActualCTMemCode", stock.get("memCode"));
        params.put("hidActualCTId", stock.get("movToLocId"));
      }

      EgovMap sirimLoc = installationResultListService.getSirimLocByInstallEntryID(installResult);

      if (sirimLoc != null) {
        params.put("hidSirimLoc", sirimLoc.get("whLocCode"));
      }

      EgovMap orderInfo = new EgovMap();
      if (installResult.get("codeid1").toString().equals("258")) { // PRODUCT
                                                                   // EXCHANGE
        orderInfo = installationResultListService.getOrderExchangeTypeByInstallEntryID(params);
      } else { // NEW PRODUCT INSTALLATION
        orderInfo = installationResultListService.getOrderInfo(params);
      }

      if (orderInfo != null) {
        params.put("hidCategoryId", orderInfo.get("stkCtgryId"));

        if (CommonUtils.intNvl(callType.get("typeId")) == 258) {
          params.put("hidPromotionId", orderInfo.get("c8"));
          params.put("hidPriceId", orderInfo.get("c11"));
          params.put("hiddenOriPriceId", orderInfo.get("c11"));
          params.put("hiddenOriPrice", orderInfo.get("c12"));
          params.put("hiddenOriPV", orderInfo.get("c13"));
          params.put("hiddenProductItem", orderInfo.get("c7"));
          params.put("hidPERentAmt", orderInfo.get("c17"));
          params.put("hidPEDefRentAmt", orderInfo.get("c18"));
          params.put("hidInstallStatusCodeId", orderInfo.get("c19"));
          params.put("hidPEPreviousStatus", orderInfo.get("c20"));
          params.put("hidDocId", orderInfo.get("docId"));
          params.put("hidOldPrice", orderInfo.get("c15"));
          params.put("hidExchangeAppTypeId", orderInfo.get("c21"));
        } else {
          params.put("hidPromotionId", orderInfo.get("c2"));
          params.put("hidPriceId", orderInfo.get("itmPrcId"));
          params.put("hiddenOriPriceId", orderInfo.get("itmPrcId"));
          params.put("hiddenOriPrice", orderInfo.get("c5"));
          params.put("hiddenOriPV", orderInfo.get("c6"));
          params.put("hiddenCatogory", orderInfo.get("codename1"));
          params.put("hiddenProductItem", orderInfo.get("stkDesc"));
          params.put("hidPERentAmt", orderInfo.get("c7"));
          params.put("hidPEDefRentAmt", orderInfo.get("c8"));
          params.put("hidInstallStatusCodeId", orderInfo.get("c9"));
        }
      }
      /* customerContractInfo */
      // hiddenCustomerType
      // hidCustomerContact
      // hidInatallation_ContactPerson

      /* customerInfo */
      // hidCustomerName

      /* installation */
      // hidInstallation_AddDtl
      // hidInstallation_AreaID
      // hiddenInstallPostcode
      // hiddenInstallStateName

      if (installResult.get("codeid1").toString().equals("257")) {
        params.put("hidOutright_Price", orderInfo.get("c5"));
      }
      if (installResult.get("codeid1").toString().equals("258")) {
        params.put("hidOutright_Price", orderInfo.get("c12"));
      }

      int promotionId = 0;
      if ("258".equals(CommonUtils.nvl(installResult.get("codeid1")))) {
        promotionId = CommonUtils.intNvl(orderInfo.get("c8"));
      } else {
        promotionId = CommonUtils.intNvl(orderInfo.get("c2"));
      }

      EgovMap promotionView = new EgovMap();
      List<EgovMap> CheckCurrentPromo = installationResultListService.checkCurrentPromoIsSwapPromoIDByPromoID(promotionId);

      if (CheckCurrentPromo.size() > 0) {
        promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(promotionId, CommonUtils.intNvl(installResult.get("installStkId")), true);
      } else {
        if (promotionId != 0) {
          promotionView = installationResultListService.getAssignPromoIDByCurrentPromoIDAndProductID(promotionId, CommonUtils.intNvl(installResult.get("installStkId")), false);
        } else {
          promotionView.put("promoId", "0");
          promotionView.put("promoPrice", CommonUtils.nvl(params.get("codeId")) == "258" ? CommonUtils.nvl(orderInfo.get("c15")) : CommonUtils.nvl(orderInfo.get("c5")));
          promotionView.put("promoPV", CommonUtils.nvl(params.get("codeId")) == "258" ? CommonUtils.nvl(orderInfo.get("c16")) : CommonUtils.nvl(orderInfo.get("c6")));
          promotionView.put("swapPromoId", "0");
          promotionView.put("swapPromoPV", "0");
          promotionView.put("swapPormoPrice", "0");
        }
      }

      params.put("hidPromoId", promotionView.get("promoId"));
      params.put("hidPromoPrice", promotionView.get("promoPrice"));
      params.put("hidPromoPV", promotionView.get("promoPV"));
      params.put("hidSwapPromoId", promotionView.get("swapPromoId"));
      params.put("hidSwapPromoPrice", promotionView.get("swapPormoPrice"));
      params.put("hidSwapPromoPV", promotionView.get("swapPromoPV"));
      /* hidden input End - KR-JIN */

      rtnMsg = insertInstallationResultSerial(params, sessionVO);
      if ("99".equals(rtnMsg.getCode())) {
        throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMsg.getMessage()));
      }
      rmsg = rtnMsg.getMessage();
    }

    message.setCode(AppConstants.SUCCESS);
    if (StringUtils.isBlank(rmsg)) {
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setMessage(rmsg);
    }

    return message;
  }

  /**
   * Select Homecare Installation List
   *
   * @Author KR-SH
   * @Date 2019. 12. 20.
   * @param params
   * @return
   * @see com.coway.trust.biz.homecare.services.install.HcInstallResultListService#hcInstallationListSearch(java.util.Map)
   */
  @Override
  public List<EgovMap> hcInstallationListSearch(Map<String, Object> params) {
    return hcInstallResultListMapper.hcInstallationListSearch(params);
  }

  /**
   * assign DT OrderList
   */
  @Override
  public List<EgovMap> assignCtOrderList(Map<String, Object> params) throws Exception {
    List<EgovMap> list = hcInstallResultListMapper.assignCtOrderList(params);
    for (EgovMap map : list) {
      // put aux info
      map.put("stusCodeId", 1);
      EgovMap frmInfo = selectFrmInfo(map);
      if (frmInfo != null) {
        map.put("frmStkCode", frmInfo.get("stockCode"));
        map.put("frmSerialChk", frmInfo.get("serialChk"));
        map.put("frmSalesOrdNo", frmInfo.get("salesOrdNo"));
        map.put("frmInstallEntryNo", frmInfo.get("installEntryNo"));
      } else {
        map.put("frmStkCode", "");
        map.put("frmSerialChk", "N");
        map.put("frmSalesOrdNo", "");
        map.put("frmInstallEntryNo", "");
      }
    }
    return list;
  }

  @Override
  public Map<String, Object> updateAssignCTSerial(Map<String, Object> params) throws Exception {
    List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
    Map<String, Object> resultValue = new HashMap<String, Object>();
    List<String> successList = new ArrayList<String>();
    List<String> failList = new ArrayList<String>();

    if (updateItemList.size() > 0) {

      for (int i = 0; i < updateItemList.size(); i++) {
        Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
        updateMap.put("updator", params.get("updator"));

        assignCt(updateMap, successList, failList);

        // one more AUX
        if (StringUtils.isNotBlank((String) updateMap.get("frmSalesOrdNo"))
            && (updateMap.get("frmInstallEntryNo").toString()).length() > 0) {
          updateMap.put("salesOrdNo", updateMap.get("frmSalesOrdNo"));
          updateMap.put("installEntryNo", updateMap.get("frmInstallEntryNo"));
          String sChk = StringUtils.isBlank((String) updateMap.get("frmSerialChk")) ? "N" : (String) updateMap.get("frmSerialChk");
          updateMap.put("serialChk", sChk);
          updateMap.put("serialRequireChkYn", sChk);
          assignCt(updateMap, successList, failList);
        }

        /*
         * // one more AUX EgovMap sMap =
         * hcInstallResultListMapper.selectFrmOrdNo(updateMap); if(sMap != null
         * && StringUtils.isNotBlank((String)sMap.get("salesOrdNo")) ){
         * sMap.put("stusCodeId", 1); // active EgovMap eMap =
         * hcInstallResultListMapper.selectFrmInstNO(sMap);
         *
         * updateMap.put("salesOrdNo", eMap.get("salesOrdNo"));
         * updateMap.put("installEntryNo", eMap.get("installEntryNo"));
         * updateMap.put("serialChk", "N"); updateMap.put("serialRequireChkYn",
         * "N"); assignCt(updateMap, successList, failList); }
         */
      }
    }
    resultValue.put("successCnt", successList.size());
    resultValue.put("successList", successList);
    resultValue.put("failCnt", failList.size());
    resultValue.put("failList", failList);

    logger.debug("resultValue : {}", resultValue);
    return resultValue;

  }

  private void assignCt(Map<String, Object> updateMap, List<String> successList, List<String> failList)
      throws Exception {

    // 180312 select now assigned CT (previous)
    // Compare View & DB
    String prevCt_db = installationResultListMapper.selectPrevAssignCt(updateMap);
    String prevCt_view = String.valueOf(updateMap.get("ctId"));
    String newCt = String.valueOf(updateMap.get("insstallCtId"));

    // Only do when View & DB matching
    if (prevCt_db.equals(prevCt_view)) {

      // Can't transfer to myself
      if (newCt.equals(prevCt_view)) {
        failList.add(updateMap.get("installEntryNo").toString());
        // logger.debug("Fail Reason >> Transfer to myself : " + newCt + " / " +
        // prevCt_view);
      } else {
        // Transfer 실행 여부 제어 로직 추가 (프로시저 호출)
        // 프로시저 호출하여 그 결과에 따라 updateAssignCT 실행
        // Transfer 불가능한 경우, 메시지창을 띄워 알려줌
        String procResult;
        ///////////////////////// 물류 호출//////////////////////
        Map<String, Object> transProc = null;
        transProc = new HashMap<String, Object>();
        transProc.put("SVONO", updateMap.get("installEntryNo"));
        // transProc.put("F_CT", prevCt );
        transProc.put("F_CT", prevCt_view); // updateMap.get("ctId")
        transProc.put("T_CT", updateMap.get("insstallCtId"));
        transProc.put("P_PRGNM", "TRNSFR");
        transProc.put("P_SERIAL_NO", updateMap.get("serialNo"));
        transProc.put("P_USER", "9999999999");

        logger.debug("Transfer 물류 호출 PRAM ===> " + transProc.toString());

        if ("Y".equals(updateMap.get("serialChk")) && "Y".equals(updateMap.get("serialRequireChkYn"))) {
          String delvryGrCmpltYn = installationResultListMapper.selectDelvryGrCmpltYn(updateMap);

          if ("N".equals(delvryGrCmpltYn)) {
            throw new ApplicationException(AppConstants.FAIL, "NOT RECEIPT DATA [ INS Number ::" + updateMap.get("installEntryNo") + " ]");
          }

          servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_TRANS_SERIAL(transProc);
        } else {
          servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_TRANS(transProc);
        }

        procResult = transProc.get("p1").toString().substring(0, 3);

        logger.debug("Transfer 물류 호출 결과 ===> " + procResult);
        ///////////////////////// 물류 호출 END //////////////////////

        if (!procResult.equals("000")) {
          throw new ApplicationException(AppConstants.FAIL, "ERROR Code::" + procResult + ", INS Number :: " + updateMap.get("installEntryNo"));
        }

        if (procResult.equals("000")) {
          installationResultListMapper.updateAssignCT(updateMap);
          successList.add(updateMap.get("installEntryNo").toString());
        } else {
          failList.add(updateMap.get("installEntryNo").toString());
        }
      }
    } else {

      failList.add(updateMap.get("installEntryNo").toString());
      logger.debug("Fail Reason >> View & DB CT info not matching : " + prevCt_db + " / " + prevCt_view);
    }
  }

  public int hcEditInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception {
    int resultValue = installationResultListService.editInstallationResultSerial(params, sessionVO);
    List<String> installAccList = (List<String>) params.get("installAccList");
    params.put("installEntryId", params.get("entryId"));
    EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);
    // disable old installation accessories
    installationResultListMapper.disbleInstallAccWithInstallEntryId(params);
    if (params.get("chkInstallAcc") != null && (params.get("chkInstallAcc").toString().equals("on") || params.get("chkInstallAcc").toString().equals("Y"))){
      try {
        insertHcInstallationAccessories(installAccList,installResult,sessionVO.getUserId());
      } catch (Exception e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }

    // check AUX
    if (resultValue > 0) {
      Map<String, Object> oMap = new HashMap<String, Object>();
      oMap.put("salesOrdNo", params.get("hidSalesOrderNo"));
      EgovMap sMap = hcInstallResultListMapper.selectFrmOrdNo(oMap);

      // one more AUX
      if (sMap != null && StringUtils.isNotBlank((String) sMap.get("salesOrdNo"))) {
        sMap.put("stusCodeId", 4); // Completed
        EgovMap eMap = hcInstallResultListMapper.selectFrmInstNO(sMap);
        params.put("entryId", eMap.get("installEntryId"));
        params.put("hidSalesOrderId", eMap.get("salesOrdId"));
        params.put("hidSalesOrderNo", eMap.get("salesOrdNo"));
        params.put("hidInstallEntryNo", eMap.get("installEntryNo"));
        // frame serial use.
        params.put("serialNo", CommonUtils.nvl(params.get("frmSerialNo")));
        params.put("hidSerialNo", CommonUtils.nvl(params.get("hidFrmSerialNo")));
        params.put("hidSerialRequireChkYn", CommonUtils.nvl(params.get("hidFrmSerialChkYn")));

        // SAL0047D.RESULT_ID
        EgovMap rMap = hcInstallResultListMapper.selectResultId(eMap);
        params.put("resultId", rMap.get("resultId"));

        int result = installationResultListService.editInstallationResultSerial(params, sessionVO);
        resultValue += result;
      }
    } else {
      throw new ApplicationException(AppConstants.FAIL, "Failed to update installation result. Please try again later.");
    }
    return resultValue;
  }

  /**
   * Copy from existing installationResult. runInstSp() call ~ change.
   *
   * @Author KR-JIN
   * @Date Jan 13, 2020
   * @param params
   * @param sessionVO
   * @return
   * @throws Exception
   */
  private ReturnMessage insertInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO)
      throws Exception {
    Map<String, Object> resultValue = new HashMap<String, Object>();
    ReturnMessage message = new ReturnMessage();
    Map<String, Object> smsResultValue = new HashMap<String, Object>();

    if (sessionVO != null) {
       int noRcd = installationResultListService.chkRcdTms(params);

      if (noRcd == 1) {
         EgovMap installResult = installationResultListService.getInstallResultByInstallEntryID(params);

        params.put("EXC_CT_ID", installResult.get("ctId"));

        Map<String, Object> locInfoEntry = new HashMap<String, Object>();
        locInfoEntry.put("CT_CODE", installResult.get("ctMemCode"));
        locInfoEntry.put("STK_CODE", installResult.get("installStkId"));

        // logger.debug("LOC. INFO. ENTRY : {}" + locInfoEntry);

        EgovMap locInfo = (EgovMap) servicesLogisticsPFCMapper.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);
        // logger.debug("LOC. INFO. : {}" + locInfo);

        if (locInfo == null) {
          message.setCode("99");
          message.setMessage("Fail to update result. [lack of stock]");
        } else {
          if (Integer.parseInt(locInfo.get("availQty").toString()) < 1) {
            message.setCode("99");
            message.setMessage("Fail to update result. [lack of stock]");
          } else {
            EgovMap validMap = installationResultListService.validationInstallationResult(params);
            int resultCnt = ((BigDecimal) validMap.get("resultCnt")).intValue();

            if (resultCnt > 0) {
              message.setMessage("Record already exist. Please refer ResultID : " + validMap.get("resultId") + ".");
            } else {
              // RUN SP AND WAIT FOR RESULT BEFORE INSERT AND UPDATE
              resultValue = runInstSp(params, sessionVO, "1");
            }

            if (null != resultValue) {
              HashMap spMap = (HashMap) resultValue.get("spMap");
              // logger.debug("spMap :" + spMap.toString());

              if (!"000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))
                  && !"741".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) { // FAIL
                resultValue.put("logerr", "Y");
                message.setCode("99");
                message.setMessage("Error Encounter. Please Contact Administrator. Error Code(INS1): " + spMap.get("P_RESULT_MSG").toString());
              } else { // SUCCESS
                if ("000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) {
                  servicesLogisticsPFCMapper.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

                  String errCode = (String) spMap.get("pErrcode");
                  String errMsg = (String) spMap.get("pErrmsg");

                  logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCode);
                  logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsg);

                  // pErrcode : 000 = Success, others = Fail
                  if (!"000".equals(errCode)) {
                    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
                  }
                }
                String ordStat = installationResultListService.getSalStat(params);

                if (!"1".equals(ordStat)) {
                   if (params.get("hidCallType").equals("258")) {
                    int exgCode = installationResultListService.chkExgRsnCde(params);
                    // SKIP SOEXC009 - EXCHANGE (WITHOUT RETURN)
                    if (exgCode == 0) { // PEX EXCHANGE CODE NOT IN THE LIST
                      if (Integer.parseInt(params.get("installStatus").toString()) == 4) {
                        // RUN SP AND WAIT FOR RESULT BEFORE INSERT AND UPDATE
                       resultValue = runInstSp(params, sessionVO, "2");

                        if (null != resultValue) {
                          spMap = (HashMap) resultValue.get("spMap");
                          logger.debug("spMap :" + spMap.toString());

                          if (!"000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))
                              && !"".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) { // FAIL
                            resultValue.put("logerr", "Y");
                            message.setCode("99");
                            message.setMessage("Error Encounter. Please Contact Administrator. Error Code(INS2): " + spMap.get("P_RESULT_MSG").toString());
                          } else {
                            servicesLogisticsPFCMapper.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

                            String errCode = (String) spMap.get("pErrcode");
                            String errMsg = (String) spMap.get("pErrmsg");

                            logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCode);
                            logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsg);

                            // pErrcode : 000 = Success, others = Fail
                            if (!"000".equals(errCode)) {
                              throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
                            }
                          }
                        }
                      }
                    }
                  }
                }
              //  resultValue = Save_2(true, params, sessionVO);
               resultValue = installationResultListService.insertInstallationResult_2(params, sessionVO);

                message.setCode("1");
                message.setData("Y");
                String msg = "";
                if (Integer.parseInt(params.get("installStatus").toString()) == 21) {
                  msg = "Installation No. (" + resultValue.get("installEntryNo") + ") successfully updated to " + resultValue.get("value") + ". Please proceed to Calllog function.";
                } else {
              	  msg = "Installation No. (" + resultValue.get("installEntryNo") + ") successfully updated to " + resultValue.get("value") + ".";

                  message.setMessage(resultValue.get("value") + " to " + resultValue.get("installEntryNo"));
                }

                // KR-OHK Barcode Save Start
                if ("Y".equals(params.get("hidSerialRequireChkYn"))) {
                  Map<String, Object> setmap = new HashMap();
                  setmap.put("serialNo", params.get("serialNo"));
                  setmap.put("salesOrdId", params.get("hidSalesOrderId"));
                  setmap.put("reqstNo", params.get("hiddeninstallEntryNo"));
                  setmap.put("callGbn", "INSTALL");
                  setmap.put("mobileYn", "N");
                  setmap.put("userId", sessionVO.getUserId());

                  servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmap);

                  String errCode = (String) setmap.get("pErrcode");
                  String errMsg = (String) setmap.get("pErrmsg");

                  logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE ERROR CODE : " + errCode);
                  logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE ERROR MSG: " + errMsg);

                  // pErrcode : 000 = Success, others = Fail
                  if (!"000".equals(errCode)) {
                    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
                  }
                }// KR-OHK Barcode Save Start

                String chksms = "";
                if (CommonUtils.nvl(params.get("chkSms")).equals("on") || CommonUtils.nvl(params.get("chkSms")).equals("Y") ){
              	  chksms = "Y";
                }else{
              	  chksms = "N";
                }

                params.put("chkSms", chksms);
                params.put("ctCode", CommonUtils.nvl(installResult.get("ctMemCode")));
                params.put("salesOrderNo", CommonUtils.nvl(installResult.get("salesOrdNo")));
                params.put("creator", sessionVO.getUserId());

	          	  try{
	          		 smsResultValue = hcInstallationSendSMS(CommonUtils.nvl(params.get("hidAppTypeId").toString()), params);

	          	  }catch (Exception e){
	          		  logger.info("===smsResultValue111===" + smsResultValue.toString());
	          	  }

	          	  if(CommonUtils.nvl(smsResultValue.get("smsLogStat")) == "3"){
	          		    msg += "</br> Failed to send SMS to " + CommonUtils.nvl(params.get("custMobileNo")).toString();
	          	  }

  	          	logger.info("===hpChkSMS===" + CommonUtils.nvl(params.get("checkSend")).toString());
  	           logger.info("===hpChkSMS===" + CommonUtils.nvl(params.get("hpMsg")).toString());

  	         	  try{
  		       		   smsResultValue = hcInstallationSendHPSMS(params);
  		       	  }catch (Exception e){
  		       		  logger.info("===smsResultValue111===" + smsResultValue.toString());
  		       	  }

  		       	  if(CommonUtils.nvl(smsResultValue.get("smsLogStat")) == "3"){
  		       		    msg += "</br> Failed to send SMS to " + CommonUtils.nvl(params.get("custMobileNo")).toString();
  		       	  }
              }
            }
          }
        }
      } else {
        message.setMessage("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
        message.setCode("99");
      }
    }
    return message;

  }

  private Map<String, Object> runInstSp(Map<String, Object> params, SessionVO sessionVO, String no)
      throws ParseException {
    Map<String, Object> resultValue = new HashMap<String, Object>();
    Map<String, Object> logPram = null;
    String p_ordID = "";
    String retype = "";
    String p_type = "";
    String p_Pgrnm = "";

    if (sessionVO != null) {
      if ("2".equals(no)) { //
        if (params.get("hidCallType").equals("258")) { // PRODUCT EXCHANGE
                                                       // RETURN OLD STOCK
                                                       // REQUEST
          p_ordID = installationResultListMapper.getINSNo(params);
          logger.debug("== Param :: " + params.toString());
          installationResultListMapper.updateExchangeEntryCt(params);

          logger.debug("== PREV. INSTALLATION NO :: " + p_ordID);
          if (Integer.parseInt(params.get("installStatus").toString()) == 4) { // COMPLETE
            retype = "SVO";
            p_type = "OD55"; // ORDER EXCHANGE FROM CUSTOMER
            p_Pgrnm = "PEXRTN";
          }
        }
      } else if ("3".equals(no)) {
        if (params.get("hidCallType").equals("258")) { // PRODUCT EXCHANGE
                                                       // RETURN OLD STOCK
                                                       // RESULT
          p_ordID = installationResultListMapper.getINSNo(params);
          logger.debug("== PREV. INSTALLATION NO :: " + p_ordID);
          if (Integer.parseInt(params.get("installStatus").toString()) == 4) { // COMPLETE
            retype = "COMPLET";
            p_type = "OD55";
            p_Pgrnm = "PEXCOM";
          } else if (Integer.parseInt(params.get("installStatus").toString()) == 21) { // FAIL
            retype = "SVO";
            p_type = "OD56";
            p_Pgrnm = "PEXCAN";
          }
        }
      } else {
        if (params.get("hidCallType").equals("258")) { // PRODUCT EXCHANGE
          // TO CHECK ORDER STATUS
          String ordStat = installationResultListMapper.getSalStat(params);
          logger.debug("== SALES ORDER STATUS :: " + ordStat);
          if ("1".equals(ordStat)) {
            if (Integer.parseInt(params.get("installStatus").toString()) == 4) { // COMPLETE
              p_ordID = params.get("hiddeninstallEntryNo").toString();
              retype = "COMPLET";
              p_type = "OD01";
              p_Pgrnm = "INSCOM";
            } else if (Integer.parseInt(params.get("installStatus").toString()) == 21) { // FAIL
              p_ordID = params.get("hiddeninstallEntryNo").toString();
              retype = "SVO";
              p_type = "OD02";
              p_Pgrnm = "INSCAN";
            }
          } else {
            if (Integer.parseInt(params.get("installStatus").toString()) == 4) { // COMPLETE
              p_ordID = params.get("hiddeninstallEntryNo").toString();
              retype = "COMPLET";
              p_type = "OD53";
              p_Pgrnm = "PEXCOM";
            } else if (Integer.parseInt(params.get("installStatus").toString()) == 21) { // FAIL
              p_ordID = params.get("hiddeninstallEntryNo").toString();
              retype = "SVO";
              p_type = "OD54";
              p_Pgrnm = "PEXCAN";
            }
          }
        } else { // NEW INSTALLATION
          if (Integer.parseInt(params.get("installStatus").toString()) == 4) { // COMPLETE
            p_ordID = params.get("hiddeninstallEntryNo").toString();
            retype = "COMPLET";
            p_type = "OD01";
            p_Pgrnm = "INSCOM";
          } else if (Integer.parseInt(params.get("installStatus").toString()) == 21) { // FAIL
            p_ordID = params.get("hiddeninstallEntryNo").toString();
            retype = "SVO";
            p_type = "OD02";
            p_Pgrnm = "INSCAN";
          }
        }
      }

      logPram = new HashMap<String, Object>();
      logPram.put("ORD_ID", p_ordID);
      logPram.put("RETYPE", retype);
      logPram.put("P_TYPE", p_type);
      logPram.put("P_PRGNM", p_Pgrnm);
      logPram.put("USERID", sessionVO.getUserId());

      logger.debug("============================runInstSp================================");
      logger.debug("INSTALLATION SP PARAM = " + logPram.toString());

      servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);

      // if (!"000".equals(logPram.get("p1"))) {
      if(logPram.get("p1") != null && !"000".equals(logPram.get("p1"))) {
        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1") + ":" + "INSTALLATION Result Error");
      }
      // KR-OHK Serial check add end

      logPram.put("P_RESULT_TYPE", "IN");
      logPram.put("P_RESULT_MSG", logPram.get("p1"));

      logger.debug("INSTALLATION RESULT SP ===>" + logPram);
      logger.debug("============================runInstSp================================");
      resultValue.put("spMap", logPram);
    }
    return resultValue;
  }

  @Override
  public EgovMap selectFrmInfo(Map<String, Object> params) throws Exception {
    EgovMap sMap = hcInstallResultListMapper.selectFrmOrdNo(params);
    if (sMap != null && StringUtils.isNotBlank((String) sMap.get("salesOrdNo"))) {
      sMap.put("stusCodeId", params.get("stusCodeId"));
      return hcInstallResultListMapper.selectFrmSerialInfo(sMap);
    }
    return null;
  }

  @Override
  public String selectFrmSerial(Map<String, Object> params) throws Exception {
    String str = hcInstallResultListMapper.selectFrmSerial(params);
    return StringUtils.isBlank(str) ? "" : str;
  }

  //Added by keyi HC Fail INS 20220120
  @Override
  public int hcFailInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws Exception {
    int resultValue = hcInstallResultListMapper.updateInstallResultFail(params);

 // check AUX
    if (resultValue > 0) {
      Map<String, Object> oMap = new HashMap<String, Object>();
      oMap.put("salesOrdNo", params.get("hidSalesOrderNo"));
      EgovMap sMap = hcInstallResultListMapper.selectFrmOrdNo(oMap);

      // one more AUX
      if (sMap != null && StringUtils.isNotBlank((String) sMap.get("salesOrdNo"))) {
        sMap.put("stusCodeId", 21); // Failed
        EgovMap eMap = hcInstallResultListMapper.selectFrmInstNO(sMap);
        params.put("entryId", eMap.get("installEntryId"));
        params.put("hidSalesOrderId", eMap.get("salesOrdId"));
        params.put("hidSalesOrderNo", eMap.get("salesOrdNo"));
        params.put("hidInstallEntryNo", eMap.get("installEntryNo"));
        // frame serial use.
        params.put("serialNo", CommonUtils.nvl(params.get("frmSerialNo")));
        params.put("hidSerialNo", CommonUtils.nvl(params.get("hidFrmSerialNo")));
        params.put("hidSerialRequireChkYn", CommonUtils.nvl(params.get("hidFrmSerialChkYn")));

        // SAL0047D.RESULT_ID
        EgovMap rMap = hcInstallResultListMapper.selectResultId(eMap);
        params.put("resultId", rMap.get("resultId"));

      }
    } else {
      throw new ApplicationException(AppConstants.FAIL, "Failed to update installation result. Please try again later.");
    }

    hcInstallResultListMapper.updateInstallResultFail(params);
    hcInstallResultListMapper.updateInstallEntryEdit(params);

    return resultValue;
  }

  @Override
  public EgovMap getFileID(Map<String, Object> params) { ///FileXXX
    return installationResultListMapper.getFileID(params);
  }

  public int updateInstallFileKey(Map<String, Object> params, SessionVO sessionVO) throws Exception {
	    String allowCom = String.valueOf(params.get("allwcom"));
	    String istrade = String.valueOf(params.get("trade"));
	    String isreqsms = String.valueOf(params.get("reqsms"));
	    String resultId = String.valueOf(params.get("resultId"));

	    Map<String, Object> locInfoEntry = new HashMap<String, Object>();
	    params.put("userId", sessionVO.getUserId());
  		params.put("resultId", CommonUtils.nvl(params.get("resultId")));
  		params.put("StkId", CommonUtils.nvl(params.get("hidStkId")));
  		params.put("SalesOrderId", CommonUtils.nvl(params.get("hidSalesOrderId")));
  		params.put("installDt", CommonUtils.nvl(params.get("installdt")));
  		locInfoEntry.put("userId", sessionVO.getUserId());
  		params.put("installEntryId", CommonUtils.nvl(params.get("installEntryId")));

  		 EgovMap installResult = getFileID (params); ///FileXXX
  		 EgovMap locInfo = (EgovMap) installationResultListMapper.getFileID(locInfoEntry);

  		 logger.debug("LOC. INFO. : {}" + locInfo);
  		 params.put("atchFileGrpId", locInfo.get("atchFileGrpId"));

  		 logger.debug("File RESULT :{}" + installResult);
  		 logger.debug("params ================================>>  " + params);

	//	 params.put("EXC_CT_ID", installResult.get("ctId"));


	    if (allowCom.equals("on")) {
	      params.put("allowCom", 1);
	    } else {
	      params.put("allowCom", 0);
	    }
	    if (istrade.equals("on")) {
	      params.put("istrade", 1);
	    } else {
	      params.put("istrade", 0);
	    }
	    if (isreqsms.equals("on")) {
	      params.put("isreqsms", 1);
	    } else {
	      params.put("isreqsms", 0);
	    }

	    logger.debug("resultId: " + resultId);

	    int resultValue = installationResultListMapper.updateInstallFileKey(params);

	    //Update InstallFIle Key for Frame Ins
	    logger.debug("hcOrder: " + params.toString());
	    Map<String, Object> oMap = new HashMap<String, Object>();
	    oMap.put("salesOrdNo", CommonUtils.nvl(params.get("SalesOrderNo")));
	    EgovMap hcOrder = hcInstallResultListMapper.selectFrmOrdNo(oMap);

	    if (hcOrder != null) {
	      //hcOrder.put("anoOrdNo", (String) hcOrder.get("salesOrdNo"));

	      if (!"".equals(CommonUtils.nvl(hcOrder.get("salesOrdNo")))) {
	    	  EgovMap hcIns = hcInstallResultListMapper.selectFrmInstInfo(hcOrder);

	    	  if (hcIns != null) {
	    		  params.put("resultId", CommonUtils.nvl(hcIns.get("resultId"))); //Frame Result ID
		  	      logger.debug("hcIns: " + params.toString());

	    		  if (!"".equals(CommonUtils.nvl(params.get("resultId")))) {
	    	    	  resultValue = installationResultListMapper.updateInstallFileKey(params);
	    		  }
	    	  }
		  }
	    }

	    return resultValue;
	  }

  @Override
	public Map<String, Object> hcInstallationSendSMS(String ApptypeID, Map<String, Object> installResult) {
		Map<String, Object> smsResultValue = new HashMap<String, Object>();
		String smsMessage = "";
		smsResultValue.put("smsLogStat", "0");//if success

		logger.debug("================HCINSMS111================");
		logger.debug("ApptypeID===" + ApptypeID);
		logger.debug("InstallationResult====" + installResult.toString());
		logger.debug("InstallationResult====" + CommonUtils.nvl(installResult.get("userId")).toString());
		logger.debug("InstallationResult====" + CommonUtils.nvl(installResult.get("CTID")).toString());

		 if(CommonUtils.nvl(installResult.get("userId")).toString() != ""){ //from Mobile
			 installResult.put("ctCode", installResult.get("userId"));
		 }

		 if(CommonUtils.nvl(installResult.get("CTID")).toString() != ""){//from Mobile
			 installResult.put("creator", installResult.get("CTID"));
		 }

		// INSERT SMS FOR APPOINTMENT - KAHKIT - 2021/11/19
		 if(installResult.get("chkSms").equals("Y")){ //IF SMS CHECKBOX IS CHECKED
			 logger.debug("================HCINSMS444================");
			 if((ApptypeID.equals("66") || ApptypeID.equals("67") || ApptypeID.equals("68") || ApptypeID.equals("5764")) //APPY_TYPE = RENTAL/OUTRIGHT/INSTALLMENT
			    		&& (CommonUtils.nvl(installResult.get("custType")).equals("Individual") || CommonUtils.nvl(installResult.get("customerType")).equals("964")))  //IF CUST_TYPE = INDIVIDUAL(WEB) || CUST_TYPE = 964 (MOBILE)
			    {
				 logger.debug("================HCINSMS================");

			    	if(installResult.get("installStatus").toString().equals("4")){ //COMPLETE
				    	smsMessage = "COWAY: Order " + installResult.get("salesOrderNo").toString() + " , pemasangan telah diselesaikan oleh Technician. Sila nilaikan kualiti perkhidmatan di bit.ly/CowayHCIns" ;
			    	}else{ //FAIL
			    	      smsMessage = "COWAY: Order " + installResult.get("salesOrderNo").toString() +" , janji temu anda utk pemasangan produk TIDAK BERJAYA. Sebarang pertanyaan, sila hubungi 1800-888-111.";
			    	}
			    }
		 }

	    Map<String, Object> smsList = new HashMap<>();
	    smsList.put("userId", installResult.get("creator"));
	    smsList.put("smsType", 975);
	    smsList.put("smsMessage", smsMessage);
	    smsList.put("smsMobileNo", installResult.get("custMobileNo").toString());

		try{
		    if(smsMessage != "")
		    {
		    	logger.debug("================SENDSMS111================");
		    	sendSms(smsList);
		    }
		}catch(Exception e){
			logger.info("Fail to send SMS to " + installResult.get("custMobileNo").toString());
	    	smsResultValue.put("smsLogStat", "3");//if fail
		}finally{
			logger.info("===resultValueFail===" + smsResultValue.toString()); //when failed to send sms
		}

		logger.info("===resultValue===" + smsResultValue.toString());
		return smsResultValue;
	}

  @Override
	public Map<String, Object> hcInstallationSendHPSMS(Map<String, Object> installResult) {
		Map<String, Object> smsResultValue = new HashMap<String, Object>();
		String smsMessage = "";
		String hpPhone = CommonUtils.nvl(installResult.get("hpPhoneNo").toString());
		smsResultValue.put("smsLogStat", "0");//if success

		logger.debug("================HPINSMS111================");
		logger.debug("InstallationResult====" + installResult.toString());

		 if(installResult.get("checkSend").equals("on") || installResult.get("checkSend").equals("Y")){ //IF HP SMS CHECKBOX IS CHECKED
			 logger.debug("================HPINSMS444================");
			 smsMessage = installResult.get("hpMsg").toString();
		 }

		 hpPhone = hpPhone.replaceAll("[\\-\\+\\.\\^:,]","");
		 logger.debug("hpPhone===" + hpPhone);

	    Map<String, Object> smsList = new HashMap<>();
	    smsList.put("userId", installResult.get("hpMemId"));
	    smsList.put("smsType", 975);
	    smsList.put("smsMessage", smsMessage);
	    smsList.put("smsMobileNo", hpPhone);
	    //smsList.put("smsMobileNo", "0175977998");

		try{
		    if(smsMessage != "")
		    {
		    	logger.debug("================HPSENDSMS111================");
		    	sendSms(smsList);
		    }
		}catch(Exception e){
			logger.info("Fail to send HP SMS to " + hpPhone);
	    	smsResultValue.put("smsLogStat", "3");//if fail
		}finally{
			logger.info("===resultValueFail===" + smsResultValue.toString()); //when failed to send sms
		}

		logger.info("===resultValue===" + smsResultValue.toString());
		return smsResultValue;
	}

	  @Override
	  public void sendSms(Map<String, Object> smsList){
	    int userId = Integer.parseInt(smsList.get("userId").toString());
	    SmsVO sms = new SmsVO(userId, 975);

	    sms.setMessage(smsList.get("smsMessage").toString());
	    sms.setMobiles(smsList.get("smsMobileNo").toString());
	    //send SMS
	    logger.debug("================HPSENDSMS222================");
	    logger.debug("smsList===" + smsList.toString());
	    SmsResult smsResult = adaptorService.sendSMS(sms);
	  }

	@Override
	public EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params) {
		logger.debug("================select HP Info================");
		EgovMap resultMap = null;
		try{
			 resultMap = hcInstallResultListMapper.selectOrderSalesmanViewByOrderID(params);
		}
		catch(Exception e){
			logger.info("Fail to get HP info to " + e.getMessage());
		}

		logger.debug("================select HP Info1================");
		logger.debug("===resultMap===" + resultMap.toString());
		return resultMap;
	}

	@Override
	public EgovMap selectFailReason(Map<String, Object> params) {
		logger.debug("================select fail reason================");
		EgovMap resultMap = null;
		try{
			 resultMap = hcInstallResultListMapper.selectFailReason(params);
		}
		catch(Exception e){
			logger.info("Fail to get fail reason === " + e.getMessage());
		}

		logger.debug("================select fail reason================");
		logger.debug("===resultMap===" + resultMap.toString());
		return resultMap;
	}

	@Override
	public List<EgovMap> selectFailChild(Map<String, Object> params) {
	    return hcInstallResultListMapper.selectFailChild(params);
	}

	@Override
	public void insertPreIns(Map<String, Object> p) {
		hcInstallResultListMapper.insertPreIns(p);
	}

	@Override
	public EgovMap selectInstallationInfo(Map<String, Object> params) {
	    return hcInstallResultListMapper.selectInstallationInfo(params);
	}

	@Override
	public List<EgovMap> selectPreInstallationRecord(Map<String, Object> params) {
	    return hcInstallResultListMapper.selectPreInstallationRecord(params);
	}

	@Override
	public void updateSVC0136DAutoPreComStatus(Map<String, Object> params) {
	    hcInstallResultListMapper.updateSVC0136DAutoPreComStatus(params);
	}

	public String getOutdoorAcStkCode(Map<String, Object> params){
	    return hcInstallResultListMapper.getOutdoorAcStkCode(params);
	}

	public void insertHcInstallationAccessories (List<String> installAccList , EgovMap installResult, int userId){
    try {

      if (!installAccList.isEmpty()){
        logger.info("### addInstallAccList : " + installAccList.toString());

        installResult.put("entryId", installResult.get("installEntryId"));
        EgovMap entry = installationResultListMapper.selectEntry_2(installResult);

        for (String installAcc : installAccList) {
              // insert into SVC0140D - Installation Accessories Listing table
              EgovMap param = new EgovMap();
              param.put("resultNo", entry.get("installEntryNo"));
              param.put("resultSoId", entry.get("salesOrdId"));
              param.put("insAccPartId", installAcc);
              param.put("remark", "Add installation accessories through eTrust - INS");
              param.put("crtUserId", userId);

              installationResultListMapper.insertInstallationAccessories(param);
          }
        }
    } catch (Exception e) {
      logger.error("An error occurred during insertion of installation accessories.", e);
        }
    }
}
