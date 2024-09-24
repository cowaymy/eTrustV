package com.coway.trust.biz.services.installation.impl;

import static com.coway.trust.AppConstants.EMAIL_SUBJECT;
import static com.coway.trust.AppConstants.EMAIL_TEXT;
import static com.coway.trust.AppConstants.EMAIL_TO;
import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_CLIENT_DOCUMENT;
import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspectj.apache.bcel.classfile.Constant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.ReportBatchService;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.logistics.stocks.impl.StockMapper;
import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
import com.coway.trust.biz.sales.mambership.impl.MembershipConvSaleMapper;
import com.coway.trust.biz.sales.mambership.impl.MembershipRentalQuotationMapper;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ASManagementListMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.CRJavaHelper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;
import com.coway.trust.util.ReportUtils;
import com.coway.trust.web.common.ReportController;
import com.coway.trust.web.common.ReportController.ViewType;
import com.coway.trust.web.common.visualcut.ReportBatchController;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.web.services.installation.InstallationResultListController;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ParameterFieldController;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT -------------------------------------------------------------------------------------------- 31/01/2019 ONGHC 1.0.1 - Restructure File 05/03/2019 ONGHC 1.0.2 - Add Param to isExchange 06/03/2019 ONGHC 1.0.3 - Create getSalStat 18/03/2019 ONGHC 1.0.4 - Set Previous INS number for OD55 27/03/2019 ONGHC 1.0.5 - To Update and Insert LOG0038D and LOG0039D 04/04/2019 ONGHC 1.0.6 - Amend insertInstallation_2 29/04/2019 ONGHC 1.0.7 - Create chkExgRsnCde 18/07/2019 ONGHC 1.0.8 - Amend runInstSp 18/10/2019 ONGHC 1.0.9 - Amend insertInstallationResult to Cater Mobile Product Exchange 14/02/2020 ONGHC 1.0.10 - Amend Save_2 to add PSI information 26/02/2020 ONGHC 1.0.11 - Amend Save_2 to add LPM information 02/06/2020 ONGHC 1.0.12 - Amend runInstSp to add condition for SP_LOGISTIC_REQUEST return param 01/07/2020 ONGHC 1.0.13 - Amend updateAssignCTSerial and updateAssignCT 01/07/2020 ONGHC 1.0.13 - Amend Save_2
 *
 *********************************************************************************************/

@Service("installationResultListService")
public class InstallationResultListServiceImpl extends EgovAbstractServiceImpl
    implements InstallationResultListService {
  private static final Logger logger = LoggerFactory.getLogger(InstallationResultListController.class);

  @Autowired
  private AdaptorService adaptorService;

  @Resource(name = "installationResultListMapper")
  private InstallationResultListMapper installationResultListMapper;

  @Resource(name = "memberListMapper")
  private MemberListMapper memberListMapper;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Resource(name = "membershipConvSaleMapper")
  private MembershipConvSaleMapper membershipConvSaleMapper;

  @Resource(name = "installationReversalMapper")
  private InstallationReversalMapper installationReversalMapper;

  @Resource(name = "membershipRentalQuotationMapper")
  private MembershipRentalQuotationMapper membershipRentalQuotationMapper;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "ASManagementListMapper")
  private ASManagementListMapper ASManagementListMapper;

  @Resource(name = "ASManagementListService")
  private ASManagementListService asMgmtListService;

  @Resource(name = "stockMapper")
  private StockMapper stockMapper;

  @Override
  public List<EgovMap> selectInstallationType() {
    return installationResultListMapper.selectInstallationType();
  }

  @Override
  public List<EgovMap> selectApplicationType() {
    return installationResultListMapper.selectApplicationType();
  }

  @Override
  public List<EgovMap> selectInstallStatus() {
    return installationResultListMapper.selectInstallStatus();
  }

  @Override
  public List<EgovMap> failParent() {
    return installationResultListMapper.failParent();
  }

  @Override
  public List<EgovMap> adapterUsed() {
    return installationResultListMapper.adapterUsed();
  }

  @Override
  public List<EgovMap> boosterUsed() {
    return installationResultListMapper.boosterUsed();
  }

  @Override
  public List<EgovMap> instChkLst() {
    return installationResultListMapper.instChkLst();
  }

  /* KV- DSC Code */
  @Override
  public List<EgovMap> selectDscCode() {
    return installationResultListMapper.selectDscCode();
  }

  @Override
  public List<EgovMap> installationResultList(Map<String, Object> params) {
    List<EgovMap> installationList = null;
    logger.debug("params : {}", params);
    if (!CommonUtils.isEmpty(params.get("dscCode")) && !CommonUtils.isEmpty(params.get("customerName"))
        || !CommonUtils.isEmpty(params.get("dscCode")) && !CommonUtils.isEmpty(params.get("customerIc"))
        || !CommonUtils.isEmpty(params.get("dscCode")) && !CommonUtils.isEmpty(params.get("sirimNo"))
        || !CommonUtils.isEmpty(params.get("dscCode")) && !CommonUtils.isEmpty(params.get("serialNo"))) {
      // installationList =
      // installationResultListMapper.installationResultList2(params);
      installationList = installationResultListMapper.installationResultList(params);
    } else {
      installationList = installationResultListMapper.installationResultList(params);
    }
    return installationList;
  }

  @Override
  public EgovMap getInstallResultByInstallEntryID(Map<String, Object> params) {
    return installationResultListMapper.getInstallResultByInstallEntryID(params);
  }

  @Override
  public EgovMap getFileID(Map<String, Object> params) { ///FileXXX
    return installationResultListMapper.getFileID(params);
  }

  @Override
  public EgovMap getOrderInfo(Map<String, Object> params) {
    return installationResultListMapper.getOrderInfo(params);
  }

  // @Override
  // public EgovMap getcustomerInfo(Object cust_id) {
  // return installationResultListMapper.getcustomerInfo(cust_id);
  // }
  //

  @Override
  public EgovMap getcustomerInfo(Map<String, Object> params) {
    return installationResultListMapper.getcustomerInfo(params);
  }

  @Override
  public EgovMap getCustomerAddressInfo(Map<String, Object> params) {
    return installationResultListMapper.getCustomerAddressInfo(params);
  }

  @Override
  public EgovMap getCustomerContractInfo(Map<String, Object> params) {
    return installationResultListMapper.getCustomerContractInfo(params);
  }

  @Override
  public EgovMap getInstallationBySalesOrderID(Map<String, Object> params) {
    return installationResultListMapper.getInstallationBySalesOrderID(params);
  }

  @Override
  public EgovMap getInstallContactByContactID(Map<String, Object> params) {
    return installationResultListMapper.getInstallContactByContactID(params);
  }

  @Override
  public EgovMap getSalesOrderMBySalesOrderID(Map<String, Object> params) {
    return installationResultListMapper.getSalesOrderMBySalesOrderID(params);
  }

  @Override
  public EgovMap getMemberFullDetailsByMemberIDCode(Map<String, Object> params) {
    return installationResultListMapper.getMemberFullDetailsByMemberIDCode(params);
  }

  @Override
  public List<EgovMap> selectViewInstallation(Map<String, Object> params) {
    return installationResultListMapper.selectViewInstallation(params);
  }

  @Override
  public EgovMap selectCallType(Map<String, Object> params) {
    return installationResultListMapper.selectCallType(params);
  }

  @Override
  public EgovMap getOrderExchangeTypeByInstallEntryID(Map<String, Object> params) {
    return installationResultListMapper.getOrderExchangeTypeByInstallEntryID(params);
  }

  @Override
  public List<EgovMap> selectFailReason(Map<String, Object> params) {
    return installationResultListMapper.selectFailReason(params);
  }

  @Override
  public EgovMap getStockInCTIDByInstallEntryIDForInstallationView(Map<String, Object> params) {
    return installationResultListMapper.getStockInCTIDByInstallEntryIDForInstallationView(params);
  }

  @Override
  public EgovMap getSirimLocByInstallEntryID(Map<String, Object> params) {
    return installationResultListMapper.getSirimLocByInstallEntryID(params);
  }

  @Override
  public List<EgovMap> checkCurrentPromoIsSwapPromoIDByPromoID(int promotionId) {
    return installationResultListMapper.checkCurrentPromoIsSwapPromoIDByPromoID(promotionId);
  }

  @Override
  public List<EgovMap> selectSalesPromoMs(int promotionId) {
    return installationResultListMapper.selectSalesPromoMs(promotionId);
  }

  @Override
  public int insResultSync(Map<String, Object> params) {
    return installationResultListMapper.insResultSync(params);
  }

  /*
   * @Override public EgovMap getPromoPriceAndPV(int promotionId, int productId) { return installationResultListMapper.getPromoPriceAndPV(param); }
   */

  @Override
  public EgovMap getAssignPromoIDByCurrentPromoIDAndProductID(int promotionId, int productId, boolean flag) {
    EgovMap resultView = new EgovMap();
    List<EgovMap> list = null;
    logger.debug("promotionId : {}", promotionId);
    logger.debug("productId : {}", productId);
    Map<String, Object> param = new HashMap<String, Object>();
    param.put("promotionId", promotionId);
    param.put("productId", productId);
    if (flag) {
      logger.debug("11111111111");
      list = installationResultListMapper.selectSalesPromoMs(promotionId);
      EgovMap swapView = installationResultListMapper.getPromoPriceAndPV(param);

      if (list.size() > 0) {
        param.put("promotionId", Integer.parseInt(list.get(0).get("promoMtchId").toString()));
        resultView.put("promoId", list.get(0).get("promoMtchId"));
      } else {
        param.put("promotionId", "0");
        resultView.put("promoId", "0");
      }

      param.put("productId", productId);
      EgovMap defaultView = installationResultListMapper.getPromoPriceAndPV(param);
      logger.debug("22222" + swapView);
      resultView.put("swapPormoPrice", CommonUtils.nvl(swapView.get("promoItmPrc")));
      resultView.put("swapPromoPV", CommonUtils.nvl(swapView.get("promoItmPv")));

      if (null != defaultView) {
        resultView.put("promoPrice", CommonUtils.nvl(defaultView.get("promoItmPrc")));
        resultView.put("promoPV", CommonUtils.nvl(defaultView.get("promoItmPv")));

      } else {
        resultView.put("promoPrice", "0");
        resultView.put("promoPV", "0");
      }

    } else {
      logger.debug("22222222222222");
      list = installationResultListMapper.selectSalesPromoMs(promotionId);
      if (list.size() > 0) {
        logger.debug("3333333333333");
        param.put("promotionId", Integer.parseInt(list.get(0).get("promoId").toString()));
        param.put("productId", productId);
        EgovMap swapView = installationResultListMapper.getPromoPriceAndPV(param);

        param.put("promotionId", promotionId);
        param.put("productId", productId);
        EgovMap defaultView = installationResultListMapper.getPromoPriceAndPV(param);

        resultView.put("swapPromoId", Integer.parseInt(list.get(0).get("promoId").toString()));
        resultView.put("promoId", promotionId);

        if (null != swapView) {
          resultView.put("swapPormoPrice", CommonUtils.nvl(swapView.get("promoItmPrc")));
          resultView.put("swapPromoPV", CommonUtils.nvl(swapView.get("promoItmPv")));
        }

        if (null != defaultView) {
          resultView.put("promoPrice", CommonUtils.nvl(defaultView.get("promoItmPrc")));
          resultView.put("promoPV", CommonUtils.nvl(defaultView.get("promoItmPv")));
        }

      } else {
        logger.debug("444444444444444");
        param.put("promotionId", promotionId);
        param.put("productId", productId);
        EgovMap defaultView = installationResultListMapper.getPromoPriceAndPV(param);
        logger.debug("defaultView : {}", defaultView);
        resultView.put("swapPromoId", promotionId);

        if (null != defaultView) {
          resultView.put("swapPormoPrice", CommonUtils.nvl(defaultView.get("promoItmPrc")));
          resultView.put("swapPromoPV", CommonUtils.nvl(defaultView.get("promoItmPv")));
        }

        resultView.put("promoId", 0);
        resultView.put("promoPrice", 0);
        resultView.put("promoPV", 0);
      }
    }
    return resultView;
  }

  @Override
  public EgovMap selectViewDetail(Map<String, Object> params) {
    EgovMap resultMap = new EgovMap();
    EgovMap assignCt = new EgovMap();
    List<EgovMap> installStatus = installationResultListMapper.selectInstallStatus();
    EgovMap installationInfo = new EgovMap();
    installationInfo = installationResultListMapper.selectInstallation(params);

    if (installationInfo != null && Integer.parseInt(installationInfo.get("installEntryId").toString()) > 0) {
      assignCt = installationResultListMapper.selectAssignCt(params);
      if (assignCt != null) {
        installationInfo.put("c1", assignCt.get("memCode"));
        installationInfo.put("c2", assignCt.get("memId"));
        installationInfo.put("c3", assignCt.get("name"));
        installationInfo.put("c4", assignCt.get("nric"));
        installationInfo.put("c5", assignCt.get("whLocId"));
      }
    }
    EgovMap doComplete = installationResultListMapper.selectDoComplete(params);
    if (doComplete != null) {
      installationInfo.put("c7", 1);
      installationInfo.put("C9", doComplete.get("movFromLocId"));
      installationInfo.put("C10", doComplete.get("whLocCode"));
    } else {
      installationInfo.put("c7", 0);
      installationInfo.put("C9", 0);
      installationInfo.put("C10", "");
    }

    EgovMap exchangeInfo = installationResultListMapper.selectExchangeInfo(params);

    exchangeInfo.put("soExchgOldPrc",
        exchangeInfo.get("soExchgOldPrc").toString().equals("") ? "0" : exchangeInfo.get("soExchgOldPrc").toString());
    exchangeInfo.put("soExchgOldPv",
        exchangeInfo.get("soExchgOldPv").toString().equals("") ? "0" : exchangeInfo.get("soExchgOldPv").toString());
    exchangeInfo.put("soExchgOldRentAmt", exchangeInfo.get("soExchgOldRentAmt").toString().equals("") ? "0"
        : exchangeInfo.get("soExchgOldRentAmt").toString());
    exchangeInfo.put("soExchgNwPrc",
        exchangeInfo.get("soExchgNwPrc").toString().equals("") ? "0" : exchangeInfo.get("soExchgNwPrc").toString());
    exchangeInfo.put("soExchgNwPv",
        exchangeInfo.get("soExchgNwPv").toString().equals("") ? "0" : exchangeInfo.get("soExchgNwPv").toString());
    exchangeInfo.put("soExchgNwRentAmt", exchangeInfo.get("soExchgNwRentAmt").toString().equals("") ? "0"
        : exchangeInfo.get("soExchgNwRentAmt").toString());

    logger.debug("===================================selectViewDetail=====================================");
    logger.debug("INSTALLATION INFO. : {}", installationInfo);
    logger.debug("ASSIGN CT : {}", assignCt);
    logger.debug("DO COMPLETE : {}", doComplete);
    logger.debug("EXCHANGE INFO. : {}", exchangeInfo);

    resultMap.put("installationInfo", installationInfo);
    resultMap.put("assignCt", assignCt);
    resultMap.put("doComplete", doComplete);
    resultMap.put("exchangeInfo", exchangeInfo);

    EgovMap basicInfo = installationResultListMapper.selectBasicInfo(params);
    EgovMap tabInstallationInfo = installationResultListMapper.selectinstallationInfo(params);
    EgovMap progressInfo = installationResultListMapper.selectProgressInfo(params);
    EgovMap maillingInfo = installationResultListMapper.selectMailingInfo(params);

    logger.debug("BASIC INFO. : {}", basicInfo);
    logger.debug("TAB INSTALLATION INFO. : {}", tabInstallationInfo);
    logger.debug("PROGRESS INFO. : {}", progressInfo);
    logger.debug("MAILING INFO. : {}", maillingInfo);
    logger.debug("===================================selectViewDetail=====================================");

    resultMap.put("basicInfo", basicInfo);
    resultMap.put("tabInstallationInfo", tabInstallationInfo);
    resultMap.put("progressInfo", progressInfo);
    resultMap.put("maillingInfo", maillingInfo);
    resultMap.put("installStatus", installStatus);

    return resultMap;
  }

  public boolean insertInstallationProductExchange(Map<String, Object> params, SessionVO sessionVO)
      throws ParseException {

    boolean success = false;
    List<EgovMap> sirimList = null;
    EgovMap installResult = this.saveDataInstallResult(params, sessionVO);
    if (Integer.parseInt(params.get("status").toString()) == 4 && (!CommonUtils.isEmpty(params.get("sirimNo")))) {
      // sirimList = saveDataSirim(params,sessionVO);
    }
    if (doSaveInstallResult(installResult, sirimList, sessionVO)) {

    }

    return false;

  }

  private boolean doSaveInstallResult(EgovMap installResult, List<EgovMap> sirimList, SessionVO sessionVO)
      throws ParseException {
    String maxId = ""; // 각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
    SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy", Locale.getDefault(Locale.Category.FORMAT));
    EgovMap maxIdValue = new EgovMap();
    EgovMap entry = installationResultListMapper.selectEntry(installResult);
    EgovMap exchange = installationResultListMapper.selectExchange(installResult);
    EgovMap salesOrderM = installationResultListMapper.selectSalesOrderM(installResult);
    logger.debug("entry : {}", entry);
    logger.debug("exchange : {}", exchange);
    logger.debug("salesOrderM : {}", salesOrderM);

    if (entry != null && Integer.parseInt(entry.get("installEntryId").toString()) > 0 && exchange != null
        && Integer.parseInt(exchange.get("soExchgId").toString()) > 0 && salesOrderM != null
        && Integer.parseInt(salesOrderM.get("salesOrdId").toString()) > 0) {
      if (entry.get("stusCodeId").toString().equals("1") && exchange.get("soExchgStusId").toString().equals("1")) {
        if ((int) installResult.get("statusCodeId") == 4)// {
          installResult.put("adjAmount", exchange.get("soExchgOldPrc"));
        maxIdValue.put("value", "resultId");
        installationResultListMapper.insertInstallResult(installResult);

        maxId = installationResultListMapper.selectMaxId(maxIdValue);
        logger.debug("maxId : {}", maxId);
        entry.put("stusCodeId", installResult.get("statusCodeId"));
        entry.put("installDate", installResult.get("installDate"));
        entry.put("installResultId", maxId);
        entry.put("updated", installResult.get("created"));
        entry.put("updator", installResult.get("creator"));
        installationResultListMapper.updateInstallEntry(entry);

        int orderProgressId = 0;
        boolean orderProgressIsLook = false;
        int orderProgressRefId = 0;
        if ((int) installResult.get("statusCodeId") == 4) {

          Map<String, Object> happyCall = new HashMap<String, Object>();
          // happyCall.put("HCID", 0);
          happyCall.put("HCSOID", salesOrderM.get("salesOrdId"));
          happyCall.put("HCCallEntryId", 0);
          happyCall.put("HCTypeNo", entry.get("installEntryNo"));
          happyCall.put("HCTypeId", 508);
          happyCall.put("HCStatusId", 33);
          happyCall.put("HCRemark", "");
          happyCall.put("HCCommentTypeId", 0);

          happyCall.put("HCCommentGId", 0);
          happyCall.put("HCCommentSId", 0);
          happyCall.put("HCCommentDId", 0);
          happyCall.put("creator", sessionVO.getUserId());
          happyCall.put("created", new Date());
          happyCall.put("updator", sessionVO.getUserId());
          happyCall.put("updated", new Date());
          happyCall.put("HCNoService", false);
          happyCall.put("HCLock", false);
          happyCall.put("HCCloseId", 0);
          logger.debug("happyCall : {}", happyCall);
          installationResultListMapper.insertHappyCall(happyCall);

          /*
           * //complete if(sirimList != null && sirimList.size() > 0){ for(int i = 0; i< sirimList.size(); i++){ //installationResultListMapper.insertSirim(sirimList.get(i)); } }
           *
           * if((int) exchange.get("soCurStusId") != 25 && (int) exchange.get("soCurStusId") != 26){ //membership int pacId = 0; if((int)salesOrderM.get("appTypeId") == 66){ pacId = 4; }else if((int)salesOrderM.get("appTypeId") == 67 && (int)salesOrderM.get("appTypeId") == 68 && (int)salesOrderM.get("appTypeId") == 142){ pacId = 3; }else if((int)salesOrderM.get("appTypeId") == 144){ pacId = 10; }else{ pacId = 2; } entry.put("pacId", pacId); EgovMap pacSetting = installationResultListMapper.selectPac(entry);
           *
           * int membershipDuration = 0; int membershipFreq = 0; int membershipBSQty = 0;
           *
           * if(pacSetting != null){ membershipDuration = pacSetting.get("srvMemDur") != null ? (int)pacSetting.get("srvMemDur") : 0; membershipFreq = pacSetting.get("srvMemItmPriod") != null ? (int)pacSetting.get("srvMemItmPriod") : 0;
           *
           * if(membershipDuration > 0 && membershipFreq > 0){ membershipBSQty = ((membershipDuration / 12) * (12 / membershipFreq)); } } Calendar calendar = Calendar.getInstance();
           *
           * Calendar startDate = getFirstDayOfMonth(calendar); Calendar endDate=getLastDayOfMonth(calendar);
           *
           * EgovMap membershipNo = getDocNo("12"); int MembershipDocID = 12; String nextDocNo =getNextDocNo("SM",membershipNo.get("docNo").toString()); membershipNo.put("nextDocNo", nextDocNo);
           *
           * logger.debug("membershipNo : {}", membershipNo);
           *
           * //memberListServiceImpl.updateDocNo(membershipNo);
           *
           * EgovMap membership = new EgovMap();
           *
           * membership.put("srvMemId", 0); membership.put("srvMemQuotId", 0); membership.put("srvSalesOrderId", salesOrderM.get("salesOrdId")); membership.put("srvMemNo", membershipNo.get("docNo").toString()); membership.put("srvMemBillNo", ""); membership.put("srvMemPacId", pacId); membership.put("srvMemPacAmt", 0); membership.put("srvMemBSAmt", 0); membership.put("srvMemPV",0); membership.put("srvFreq",membershipFreq); membership.put("srvStartDate",startDate);//수정 membership.put("srvExpireDate",endDate);//수정 membership.put("srvDuration",membershipDuration); membership.put("srvStatusCodeId",4); membership.put("srvRemark",""); membership.put("srvCreateAt",new Date()); membership.put("srvCreateBy",installResult.get("creator")); membership.put("srvUpdateAt",new Date()); membership.put("srvUpdateBy",installResult.get("creator")); membership.put("srvMemBS12Amt",0); membership.put("srvMemIsSynch",false); membership.put("srvMemSalesMemId",0);
           * membership.put("srvMemCustCntId",salesOrderM.get("custCntId")); membership.put("srvMemQty",0); membership.put("SrvBSQty",membershipBSQty); membership.put("srvMemPromoId",0); membership.put("srvMemPVMonth",0); membership.put("srvMemPVYear",0); membership.put("srvMemIsManual",false); membership.put("srvMemBranchId",sessionVO.getUserBranchId()); membership.put("srvMemPacPromoId",0);
           *
           * logger.debug("membership : {}", membership); //installationResultListMapper.insertMemberShip(membership);
           *
           * //2016 Air Puifier Promotion - Free 1-Yr Outright Membership if((int) exchange.get("soExchgNwPromoId") == 31330 || (int) exchange.get("soExchgNwPromoId") == 31331 || (int) exchange.get("soExchgNwPromoId") == 31332 ||(int) exchange.get("soExchgNwPromoId") == 31333 || (int) exchange.get("soExchgNwPromoId") == 31371 || (int) exchange.get("soExchgNwPromoId") == 31372 || (int) exchange.get("soExchgNwPromoId") == 31373 || (int) exchange.get("soExchgNwPromoId") == 31374 ) {
           *
           * EgovMap memNoFree = getDocNoNumber("12"); updateDocNoNumber("12");
           *
           * Calendar srvStartDate = endDate;//.add(calendar.DATE,1 ); srvStartDate.add(calendar.DATE,1 ); Calendar srvExpireDate = startDate;//.add(calendar.MONTH, 12) srvExpireDate.add(calendar.MONTH, 12); membership.put("srvMemNo", memNoFree.get("docNo")); membership.put("srvMemPacId", 19); membership.put("srvStartDate",srvStartDate);//수정해야함 membership.put("srvExpireDate",srvExpireDate);//수정해야함 membership.put("srvDuration", 12);//수정해야함
           *
           * //installationResultListMapper.insertMemberShip(membership);
           *
           *
           * }
           *
           * EgovMap list = installationResultListMapper.selectList(salesOrderM);
           *
           * if((int) salesOrderM.get("appTypeId") == 66){
           *
           *
           * Date salesDate = df.parse(list.get("salesDt").toString()); Date SalesGSTcutOffDate = df.parse("04/01/2015" );
           *
           * if(salesDate.compareTo(SalesGSTcutOffDate) == -1){ Map<String, Object> rentLedger = new HashMap<String, Object>(); rentLedger.put("rentRunId", 0); rentLedger.put("rentId", 0); rentLedger.put("rentSOId", salesOrderM.get("salesOrdId")); rentLedger.put("rentDocNo", entry.get("installEntryId")); rentLedger.put("rentDocTypeId",161); rentLedger.put("rentDateTime", new Date()); rentLedger.put("rentAmount", exchange.get("soExchgNwPrc")); rentLedger.put("rentBatchNo", ""); rentLedger.put("rentInstNo", 0); rentLedger.put("rentUpdateBy", sessionVO.getUserId()); rentLedger.put("rentUpdateAt", new Date()); rentLedger.put("rentIsSync", false); rentLedger.put("rentBillRunningTotal", 0); rentLedger.put("R01", 0); rentLedger.put("R02", ""); logger.debug("rentLedger : {}", rentLedger); //insert문 추가
           *
           * Map<String, Object> orderbill = new HashMap<String, Object>(); orderbill.put("accBillTaskId", 0); orderbill.put("accBillRefDate", new Date()); orderbill.put("accBillRefNo", "1000"); orderbill.put("accBillOrderId", salesOrderM.get("salesOrdId")); orderbill.put("accBillOrderNo", salesOrderM.get("salesOrdNo")); orderbill.put("accBillTypeId", 1159); orderbill.put("accBillModeId",1158); orderbill.put("accBillScheduleId",0); orderbill.put("accBillSchedulePeriod",0); orderbill.put("accBillAdjustmentId",0); orderbill.put("accBillScheduleAmount",(int)exchange.get( "soExchgNwPrc")); orderbill.put("accBillAdjustmentAmount",0); orderbill.put("accBillTaxesAmount",(int)exchange.get( "soExchgNwPrc") - (int)exchange.get("soExchgNwPrc") * 100/106); orderbill.put("accBillNetAmount",(int)exchange.get("soExchgNwPrc")) ; orderbill.put("accBillStatus",1); orderbill.put("accBillRemark",entry.get("installEntryNo")); orderbill.put("accBillCreateAt", new Date()); orderbill.put("accBillCreateBy",
           * sessionVO.getUserId()); orderbill.put("accBillGroupId",0); orderbill.put("accBillTaxRate",6); orderbill.put("accBillTaxCodeId",32); logger.debug("orderbill : {}" , orderbill); //쿼리 추가
           *
           * if(list != null){ EgovMap invoiceNum = new EgovMap(); if(list.get("typeId").toString() == "965"){ //Soo Modified Form GST 2015-01-05
           *
           * invoiceNum = getDocNoNumber("120"); //memberListServiceImpl.updateDocNoNumber("120");
           *
           * rentLedger.put("rentDocNo", invoiceNum.get("docNo")); //쿼리추가
           *
           * orderbill.put("accBillRemark", invoiceNum.get("docNo")); //쿼리 추가
           *
           * Map<String, Object> taxInvoiceM = new HashMap<String, Object>(); taxInvoiceM.put("taxInvoiceRefNo", invoiceNum.get("docNo")); taxInvoiceM.put("taxInvoiceRefDate", new Date()); taxInvoiceM.put("taxInvoiceGroupId", (int)list.get("custBillId")); taxInvoiceM.put("taxInvoiceGroupNo", list.get("salesOrdId")); taxInvoiceM.put("taxInvoiceGroupNo", list.get("salesOrdId")); taxInvoiceM.put("taxInvoiceCustName", list.get("name")); taxInvoiceM.put("taxInvoiceContactPerson", list.get("name1")); taxInvoiceM.put("taxInvoiceAddress1", list.get("add1")); taxInvoiceM.put("taxInvoiceAddress2", list.get("add2")); taxInvoiceM.put("taxInvoiceAddress3", list.get("add3")); taxInvoiceM.put("taxInvoiceAddress4", list.get("add4")); taxInvoiceM.put("taxInvoicePostCode", list.get("postCode")); taxInvoiceM.put("taxInvoiceStateName", list.get("name2")); taxInvoiceM.put("taxInvoiceCountry", list.get("name3")); taxInvoiceM.put("taxInvoiceMonth",new Date().getMonth()); taxInvoiceM.put("taxInvoiceYear",new
           * Date().getYear()); taxInvoiceM.put("taxInvoiceStatusId",1); taxInvoiceM.put("taxInvoiceTaskId",0); taxInvoiceM.put("taxInvoiceCreated",new Date()); taxInvoiceM.put("taxInvoiceRemark",entry.get("installEntryNo")); taxInvoiceM.put("taxInvoiceCharges",exchange.get("soExchgNwPrc")); taxInvoiceM.put("taxInvoiceOverdue",0); taxInvoiceM.put("taxInvoiceAmountDue",exchange.get("soExchgNwPrc")) ; taxInvoiceM.put("taxInvoiceType",1267); taxInvoiceM.put("taxInvoiceCreator",sessionVO.getUserId());
           *
           * logger.debug("taxInvoiceM : {}", taxInvoiceM); //쿼리추가
           *
           * Map<String, Object> taxInvoiceD = new HashMap<String, Object>(); taxInvoiceD.put("taxInvoiceId", "위 쿼리에서 가져와야함"); taxInvoiceD.put("invoiceItemOrderNo", list.get("salesOrdNo")); taxInvoiceD.put("invoiceItem_PONo", ""); taxInvoiceD.put("invoiceItemGSTRate", 6); taxInvoiceD.put("invoiceItemGSTTaxes", (int)exchange.get("soExchgNwPrc") - (int)exchange.get("soExchgNwPrc") * 100/106); taxInvoiceD.put("invoiceItemRentalFee", (int)exchange.get("soExchgNwPrc")); taxInvoiceD.put("invoiceItemHandlingFee", 0); taxInvoiceD.put("invoiceItemHandlingFeeTaxes", 0); taxInvoiceD.put("invoiceItemProductCategories", list.get("codeDesc")); taxInvoiceD.put("invoiceItemProductModel", list.get("stkDesc")); taxInvoiceD.put("invoiceItemProductSerialNo", installResult.get("serialNo")); taxInvoiceD.put("invoiceItemAdd1", list.get("add11")); taxInvoiceD.put("invoiceItemAdd2", list.get("add21")); taxInvoiceD.put("invoiceItemAdd3", list.get("add31")); taxInvoiceD.put("invoiceItemPostCode",
           * list.get("postCode1")); taxInvoiceD.put("invoiceItemStateName", list.get("name4")); taxInvoiceD.put("invoiceItemCountry", list.get("name5")); taxInvoiceD.put("invoiceItemInstallationDate", installResult.get("installDate")); taxInvoiceD.put("invoiceItemInstallmentNo",0); taxInvoiceD.put("invoiceItemInstallmentPeriod",new Date()); taxInvoiceD.put("invoiceItemPayMode",list.get("description1"));
           *
           * logger.debug("taxInvoiceD : {}", taxInvoiceD); //쿼리추가
           *
           * }else{ invoiceNum =getDocNoNumber("120"); updateDocNoNumber("120");
           *
           * rentLedger.put("rentDocNo", invoiceNum.get("docNo")); //쿼리추가
           *
           * orderbill.put("accBillRemark", invoiceNum.get("docNo")); //쿼리 추가
           *
           * Map<String, Object> taxInvoiceM = new HashMap<String, Object>(); taxInvoiceM.put("taxInvoiceRefNo", invoiceNum.get("docNo")); taxInvoiceM.put("taxInvoiceRefDate", new Date()); taxInvoiceM.put("taxInvoiceGroupId", (int)list.get("custBillId")); taxInvoiceM.put("taxInvoiceGroupNo", list.get("salesOrdId")); taxInvoiceM.put("taxInvoiceCustName", list.get("name")); taxInvoiceM.put("taxInvoiceContactPerson", list.get("name1")); taxInvoiceM.put("taxInvoiceAddress1", list.get("add1")); taxInvoiceM.put("taxInvoiceAddress2", list.get("add2")); taxInvoiceM.put("taxInvoiceAddress3", list.get("add3")); taxInvoiceM.put("taxInvoiceAddress4", list.get("add4")); taxInvoiceM.put("taxInvoicePostCode", list.get("postCode")); taxInvoiceM.put("taxInvoiceStateName", list.get("name2")); taxInvoiceM.put("taxInvoiceCountry", list.get("name3")); taxInvoiceM.put("taxInvoiceMonth",new Date().getMonth()); taxInvoiceM.put("taxInvoiceYear",new Date().getYear()); taxInvoiceM.put("taxInvoiceStatusId",1);
           * taxInvoiceM.put("taxInvoiceTaskId",0); taxInvoiceM.put("taxInvoiceCreated",new Date()); taxInvoiceM.put("taxInvoiceRemark",entry.get("installEntryNo")); taxInvoiceM.put("taxInvoiceCharges",exchange.get("soExchgNwPrc")); taxInvoiceM.put("taxInvoiceOverdue",0); taxInvoiceM.put("taxInvoiceAmountDue",exchange.get("soExchgNwPrc")) ; taxInvoiceM.put("taxInvoiceType",1268); taxInvoiceM.put("taxInvoiceCreator",sessionVO.getUserId());
           *
           * logger.debug("taxInvoiceM : {}", taxInvoiceM); //쿼리추가
           *
           * Map<String, Object> taxInvoiceD = new HashMap<String, Object>(); taxInvoiceD.put("taxInvoiceId", "위 쿼리에서 가져와야함"); taxInvoiceD.put("invoiceItemOrderNo", list.get("salesOrdNo")); taxInvoiceD.put("invoiceItem_PONo", ""); taxInvoiceD.put("invoiceItemGSTRate", 6); taxInvoiceD.put("invoiceItemGSTTaxes", (int)exchange.get("soExchgNwPrc") - (int)exchange.get("soExchgNwPrc") * 100/106); taxInvoiceD.put("invoiceItemRentalFee", (int)exchange.get("soExchgNwPrc")); taxInvoiceD.put("invoiceItemHandlingFee", 0); taxInvoiceD.put("invoiceItemHandlingFeeTaxes", 0); taxInvoiceD.put("invoiceItemProductCategories", list.get("codeDesc")); taxInvoiceD.put("invoiceItemProductModel", list.get("stkDesc")); taxInvoiceD.put("invoiceItemProductSerialNo", installResult.get("serialNo")); taxInvoiceD.put("invoiceItemAdd1", list.get("add11")); taxInvoiceD.put("invoiceItemAdd2", list.get("add21")); taxInvoiceD.put("invoiceItemAdd3", list.get("add31")); taxInvoiceD.put("invoiceItemPostCode",
           * list.get("postCode1")); taxInvoiceD.put("invoiceItemStateName", list.get("name4")); taxInvoiceD.put("invoiceItemCountry", list.get("name5")); taxInvoiceD.put("invoiceItemInstallationDate", installResult.get("installDt")); taxInvoiceD.put("invoiceItemInstallmentNo",0); taxInvoiceD.put("invoiceItemInstallmentPeriod",new Date()); taxInvoiceD.put("invoiceItemPayMode",list.get("description1"));
           *
           * logger.debug("taxInvoiceD : {}", taxInvoiceD); //쿼리추가 } } }
           *
           * EgovMap rentScheme = if(rentScheme != null){ rentScheme.put("renSchDate", new Date()); rentScheme.put("statusCodeID","REG"); rentScheme.put("IsSync",false); //쿼리 추가 }
           *
           * } else if((int)salesOrderM.get("appTypeId") == 67 || (int)salesOrderM.get("appTypeId") == 68){ double outRightPreBill = getOutRightPreBill(salesOrderM); double outRightBalance = (int)exchange.get("soExchgNwPrc") - outRightPreBill;
           *
           * if((int)exchange.get("soExchgNwPrc") > outRightPreBill){ int taxCodeId = 0; int taxRate = 0;
           *
           * int zrLocationId = (int)getZRLocationId(salesOrderM); int RLCertificateID = (int)getRSCertificateID(salesOrderM);
           *
           * if(zrLocationId != 0){ taxCodeId = 39; taxRate = 0; }else{ if(RLCertificateID != 0){ taxCodeId = 28; taxRate = 0; }else{ taxCodeId = 32; taxRate = 6; } }
           *
           * Map<String, Object> orderbill = new HashMap<String, Object>(); orderbill.put("accBillTaskId", 0); orderbill.put("accBillRefDate", new Date()); orderbill.put("accBillRefNo", "1000"); orderbill.put("accBillOrderId", salesOrderM.get("salesOrdId")); orderbill.put("accBillOrderNo", salesOrderM.get("salesOrdNo")); orderbill.put("accBillTypeId", 1159); orderbill.put("accBillModeId",1164); orderbill.put("accBillScheduleId",0); orderbill.put("accBillSchedulePeriod",0); orderbill.put("accBillAdjustmentId",0); orderbill.put("accBillScheduleAmount",(int)exchange.get( "soExchgNwPrc")); orderbill.put("accBillAdjustmentAmount",0); if(taxRate > 0){ orderbill.put("accBillTaxesAmount",(int)exchange.get( "soExchgNwPrc") - (int)exchange.get("soExchgNwPrc") * 100/106); }else{ orderbill.put("accBillTaxesAmount",0); } orderbill.put("accBillNetAmount",outRightBalance); orderbill.put("accBillStatus",1); orderbill.put("accBillRemark",entry.get("installEntryNo")); orderbill.put("accBillCreateAt",
           * new Date()); orderbill.put("accBillCreateBy", sessionVO.getUserId()); orderbill.put("accBillGroupId",0); orderbill.put("accBillTaxRate",taxRate); orderbill.put("accBillTaxCodeId",taxCodeId); orderbill.put("accBillAcctConversion", 0); orderbill.put("accBillContractId", 0); logger.debug( "orderbill : {}", orderbill); installationResultListMapper.insertAccOrderBill(orderbill); //쿼리
           *
           * EgovMap invoiceNum =getDocNoNumber("119"); updateDocNoNumber("119");
           *
           * orderbill.put("accBillRemark", invoiceNum.get("docNo")); installationResultListMapper.updateBillRem(orderbill);
           *
           * Map<String, Object> taxInvocieOutright = new HashMap<String, Object>(); taxInvocieOutright.put("taxInvoiceRefNo", invoiceNum.get("docNo")); taxInvocieOutright.put("taxInvoiceRefDate", new Date()); taxInvocieOutright.put("taxInvoiceCustName", list.get("name")); taxInvocieOutright.put("taxInvoiceContactPerson", list.get("name1")); taxInvocieOutright.put("taxInvoiceAddress1", list.get("add1")); taxInvocieOutright.put("taxInvoiceAddress2", list.get("add2")); taxInvocieOutright.put("taxInvoiceAddress3", list.get("add3")); taxInvocieOutright.put("taxInvoiceAddress4", list.get("add4")); taxInvocieOutright.put("taxInvoicePostCode", list.get("postCode")); taxInvocieOutright.put("taxInvoiceStateName", list.get("name2")); taxInvocieOutright.put("taxInvoiceCountry", list.get("name3")); taxInvocieOutright.put("taxInvoiceTaskID",0); taxInvocieOutright.put("taxInvoiceCreated",new Date()); taxInvocieOutright.put("taxInvoiceRemark",entry.get( "installEntryNo")); if(taxRate > 0){
           * taxInvocieOutright.put("taxInvoiceCharges",new DecimalFormat("0.00").format(outRightBalance * 100 / 106)); }else{ taxInvocieOutright.put("taxInvoiceCharges",new DecimalFormat("0.00").format(outRightBalance)); } taxInvocieOutright.put("taxInvoiceOverdue",0); taxInvocieOutright.put("taxInvoiceAmountDue",new DecimalFormat("0.00").format(outRightBalance));
           *
           * logger.debug("taxInvocieOutright : {}", taxInvocieOutright); //installationResultListMapper.insertTaxInvocieOutright( taxInvocieOutright);
           *
           *
           * Map<String, Object> taxInvocieOutrightD = new HashMap<String, Object>(); taxInvocieOutrightD.put("taxInvoiceID", "바로 위 테이블에서 값가져오야함"); taxInvocieOutrightD.put("invoiceItemOrderNo", list.get("salesOrdNo")); taxInvocieOutrightD.put("invoiceItem_PONo", ""); taxInvocieOutrightD.put("invoiceItemGSTRate", taxRate); if(taxRate > 0){ taxInvocieOutrightD.put("invoiceItemGSTTaxes", new DecimalFormat("0.00").format((int)entry.get("soExchgNwPrc") - (int)entry.get("soExchgNwPrc"))); }else{ taxInvocieOutrightD.put("invoiceItemGSTTaxes",0); } taxInvocieOutrightD.put("invoiceItemAmountDue", outRightBalance); taxInvocieOutrightD.put("invoiceItemRentalFee", (int)taxInvocieOutrightD.get("invoiceItemAmountDue") - (int)taxInvocieOutrightD.get("invoiceItemGSTTaxes")); taxInvocieOutrightD.put("invoiceItemProductCategories",list.get( "codeDesc")); taxInvocieOutrightD.put("invoiceItemProductModel", list.get("stkDesc")); taxInvocieOutrightD.put("invoiceItemProductSerialNo",installResult.
           * get("sirialNo")); taxInvocieOutrightD.put("invoiceItemAdd1",list.get("add11")); taxInvocieOutrightD.put("invoiceItemAdd2",list.get("add21")); taxInvocieOutrightD.put("invoiceItemAdd3",list.get("add31")); taxInvocieOutrightD.put("invoiceItemPostCode",list.get("postCode1") ); taxInvocieOutrightD.put("invoiceItemStateName", list.get("name4")); taxInvocieOutrightD.put("invoiceItemCountry",list.get("name5"));
           *
           * logger.debug("taxInvocieOutrightD : {}", taxInvocieOutrightD); //installationResultListMapper.insertTaxInvocieOutrightD( taxInvocieOutrightD);
           *
           *
           * Map<String, Object> tradeLedger = new HashMap<String, Object>(); tradeLedger.put("tradeRunID", 0); tradeLedger.put("tradeID", 0); tradeLedger.put("tradeSOID", salesOrderM.get("salesOrdId")); tradeLedger.put("tradeDocNo", invoiceNum.get("docNo")); tradeLedger.put("tradeDocTypeID", 164); tradeLedger.put("tradeDateTime", new Date()); tradeLedger.put("tradeAmount", (double)outRightBalance); tradeLedger.put("tradeBatchNo", ""); tradeLedger.put("tradeInstNo", 0); tradeLedger.put("tradeUpdateBy", installResult.get("creator")); tradeLedger.put("tradeUpdateAt", new Date()); tradeLedger.put("tradeIsSync", false); logger.debug( "tradeLedger : {}", tradeLedger); //installationResultListMapper.insertTradeLedger(tradeLedger);
           *
           * } }
           *
           * //CONFIG Map<String, Object> config = new HashMap<String, Object>(); config.put("srvConfigId", 0); config.put("srvSOId", salesOrderM.get("salesOrdId")); config.put("srvCodyId",0); config.put("srvPreviousDate",installResult.get("installDate")); config.put("srvRemark",""); config.put("srvBSGen",true); config.put("srvCreateAt",new Date()); config.put("srvCreateBy",sessionVO.getUserId()); config.put("srvUpdateAt",new Date()); config.put("srvUpdateBy",sessionVO.getUserId()); config.put("srvStatusId",1); config.put("srvBSWeek",0); logger.debug("config : {}", config); //installationResultListMapper.insertConfig(config);
           *
           * for(int i=279; i<=281;i++){ Map<String, Object> configSet = new HashMap<String, Object>(); configSet.put("srvSettId", 0); configSet.put("srvConfigId", "위에 쿼리에 시퀀스 가져와야힘"); configSet.put("srvSettTypeID", i); configSet.put("srvSettStatusID", 1); configSet.put("srvSettRemark", ""); configSet.put("srvSettCreateAt", new Date()); configSet.put("srvSettCreateBy", sessionVO.getUserId()); logger.debug("configSet : {}", configSet); //installationResultListMapper.insertConfigSet(configSet); }
           *
           * Map<String, Object> configPeriod = new HashMap<String, Object>(); configPeriod.put("srvPrdId", 0); configPeriod.put("srvConfigId", "위에위에 테이블 시퀀스"); configPeriod.put("srvMembershipId", 0); configPeriod.put("srvPrdStartDate", startDate); configPeriod.put("srvPrdExpireDate", endDate); configPeriod.put("srvPrdDuration", membershipDuration); configPeriod.put("srvPrdStatusID", 1); configPeriod.put("srvPrdRemark", ""); configPeriod.put("srvPrdCreateAt", new Date()); configPeriod.put("srvPrdCreateBy", sessionVO.getUserId()); configPeriod.put("SrvPrdUpdateAt", new Date()); configPeriod.put("srvPrdUpdateBy", sessionVO.getUserId()); logger.debug("configPeriod : {}", configPeriod); //installationResultListMapper.insertConfigPeriod(configPeriod);
           *
           * //2016 Air Purifier Promotion = Free 1-Yr Outright Membership if((int) exchange.get("soExchgNwPromoId") == 31330 || (int) exchange.get("soExchgNwPromoId") == 31331 || (int) exchange.get("soExchgNwPromoId") == 31332 ||(int) exchange.get("soExchgNwPromoId") == 31333 || (int) exchange.get("soExchgNwPromoId") == 31371 || (int) exchange.get("soExchgNwPromoId") == 31372 || (int) exchange.get("soExchgNwPromoId") == 31373 || (int) exchange.get("soExchgNwPromoId") == 31374 ) { configPeriod.put("srvPrdStartDate", configPeriod.get("srvPrdExpireDate")); configPeriod.put("srvPrdExpireDate", configPeriod.get("srvPrdStartDate")); //쿼리추가 }
           *
           * List<EgovMap> filter = installationResultListMapper.selectFilter(entry);
           *
           * if(filter != null && filter.size() > 0){ for(int i=0; i<filter.size(); i++){ Map<String, Object> configFilter = new HashMap<String, Object>(); configFilter.put("srvFilterId", 0); configFilter.put("srvConfigId",config.get("시퀀스") ); configFilter.put("srvFilterStkId", filter.get(i).get(("bomPartId")) != null ? filter.get(i).get(("bomPartId")) : 0 ); configFilter.put("srvFilterPeriod", filter.get(i).get("bomPartPriod")); configFilter.put("srvFilterPrvChgDate",(Date)installResult.get( "installDate")); configFilter.put("srvFilterStatusId",1); configFilter.put("srvFilterRemark",""); configFilter.put("srvFilterCreateAt",new Date()); configFilter.put("srvFilterCreateBy",sessionVO.getUserId()); configFilter.put("srvFilterUpdateAt",new Date()); configFilter.put("srvFilterUpdateBy",sessionVO.getUserId()); logger.debug("configFilter : {}", configFilter); //installationResultListMapper.insertConfigFilter(configFilter); } } }else{ //qryCurrentConfig 여기있는곳 }
           *
           * EgovMap salesDet = installationResultListMapper.selectSalesDet(salesOrderM); if(salesDet != null){ salesDet.put("itemStkId", entry.get("installStkId")); salesDet.put("itemPrice", exchange.get("soExchgNwPrc")); salesDet.put("itemPV", exchange.get("soExchgNwPv")); salesDet.put("itemPriceId", exchange.get("soExchgNwPrcId")); salesDet.put("updated", new Date()); salesDet.put("updator", installResult.get("creator")); logger.debug("salesDet : {}", salesDet); //installationResultListMapper.updateSalesDet(salesDet); }
           *
           * salesOrderM.put("statusCodeId", 4); salesOrderM.put("updated", new Date()); salesOrderM.put("updator", installResult.get("creator")); salesOrderM.put("promoId", exchange.get("soExchgNwPromoId")); salesOrderM.put("totalAmt", exchange.get("soExchgNwPrc")); salesOrderM.put("totalPV", exchange.get("soExchgNwPv")); if((int)salesOrderM.get("appTypeId") == 66) { if(df.parse(salesOrderM.get("salesDt").toString()).compareTo(df. parse("08/01/2014")) == 1 || df.parse(salesOrderM.get("salesDt").toString()).compareTo(df.parse( "08/01/2014")) == 0){ salesOrderM.put("mthRentAmt", exchange.get("soExchgNwRentAmt")); salesOrderM.put("defRentAmt", exchange.get("soExchgNwDefRentAmt")); } } logger.debug( "salesOrderM : {}", salesOrderM); //installationResultListMapper.updateSalesOrderM(salesOrderM);
           *
           * exchange.put("soExchgNwStkId", entry.get("installStkId")); exchange.put("soExchgStatusId", 4); exchange.put("soExchgUpdateAt", new Date()); exchange.put("soExchgUpdateBy", sessionVO.getUserId()); logger.debug("exchange : {}", exchange); //installationResultListMapper.updateExchange(exchange);
           *
           * Map<String, Object> happyCall = new HashMap<String, Object>(); happyCall.put("HCID", 0); happyCall.put("HCSOID", salesOrderM.get("salesOrdId")); happyCall.put("HCCallEntryId", 0); happyCall.put("HCTypeNo", entry.get("installEntryNo")); happyCall.put("HCTypeId", 508); happyCall.put("HCStatusId", 33); happyCall.put("HCRemark", ""); happyCall.put("HCCommentTypeId", 0); happyCall.put("HCCommentGId", 0); happyCall.put("HCCommentSId", 0); happyCall.put("HCCommentDId", 0); happyCall.put("creator", sessionVO.getUserId()); happyCall.put("created", new Date()); happyCall.put("updator", sessionVO.getUserId()); happyCall.put("updated", new Date()); happyCall.put("HCNoService", false); happyCall.put("HCLock", false); happyCall.put("HCCloseId", 0); logger.debug("happyCall : {}", happyCall); //installationResultListMapper.insertHappyCall(happyCall);
           *
           * EgovMap mobWH = installationResultListMapper.selectMobWh(installResult);
           *
           * Map<String, Object> card = new HashMap<String, Object>(); card.put("SRCardID", 0); card.put("locationId", mobWH.get("whLocId")); card.put("stockId", entry.get("installStkId")); card.put("entryDate", new Date()); card.put("typeId", 463); card.put("refNo", entry.get("installEntryNo")); card.put("salesOrderId", salesOrderM.get("salesOrdId")); card.put("itemNo", 1); card.put("sourceId", 477); card.put("projectId", 0); card.put("batchNo", 0); card.put("Qty", -1); card.put("currId", 479); card.put("currRate", -1); card.put("cost", 0); card.put("price", 0); card.put("remark", ""); card.put("serialNo", ""); card.put("installNo", entry.get("installEntryNo")); card.put("costDate", new Date()); card.put("appTypeId", salesOrderM.get("appTypeId")); card.put("stkGrade", "A"); card.put("installFail", false); card.put("isSynch", false); card.put("entryMethodId", 0); card.put("origin", ""); logger.debug( "card : {}", card); //installationResultListMapper.insertRecordCard(card);
           *
           * orderProgressIsLook = false; orderProgressId = 5; orderProgressRefId = 0;
           */
        } else {
          // FAIL
          Map<String, Object> callEntry = new HashMap<String, Object>();
          callEntry.put("callEntryId", 0);
          callEntry.put("salesOrderId", salesOrderM.get("salesOrdId"));
          callEntry.put("typeId", 258);
          callEntry.put("statusCodeId", 1);
          callEntry.put("resultId", 0);
          callEntry.put("docId", exchange.get("soExchgId"));
          callEntry.put("creator", sessionVO.getUserId());
          callEntry.put("created", new Date());
          callEntry.put("callDate", installResult.get("nextCallDate"));
          callEntry.put("isWaitForCancel", false);
          callEntry.put("happyCallerId", 0);
          callEntry.put("updated", new Date());
          callEntry.put("updator", sessionVO.getUserId());
          callEntry.put("oriCallDate", installResult.get("nextCallDate"));

          logger.debug("callEntry : {}", callEntry);
          installationResultListMapper.insertCallEntry(callEntry);

          maxIdValue.put("value", "callEntryId");
          maxId = installationResultListMapper.selectMaxId(maxIdValue);

          Map<String, Object> callResult = new HashMap<String, Object>();
          callResult.put("callResultId", 0);
          callResult.put("callEntryId", maxId);
          callResult.put("callStatusId", 1);
          callResult.put("callCallDate", installResult.get("nextCallDate").toString());
          callResult.put("callActionDate", "01/01/1900");
          callResult.put("callFeedBackId", 0);
          callResult.put("callCTID", 0);
          callResult.put("callRemark", installResult.get("remark"));
          callResult.put("callCreateBy", sessionVO.getUserId());
          callResult.put("callCreateAt", new Date());
          callResult.put("callCreateByDept", 0);
          callResult.put("callHCID", 0);
          callResult.put("callROSAmt", 0);
          callResult.put("callSMS", false);
          callResult.put("callSMSRemark", "");

          logger.debug("callResult : {}", callResult);
          installationResultListMapper.insertCallResult(callResult);

          maxIdValue.put("value", "callResultId");
          maxId = installationResultListMapper.selectMaxId(maxIdValue);
          maxIdValue.put("value", "callEntryId");
          maxId = installationResultListMapper.selectMaxId(maxIdValue);

          callEntry.put("resultId", maxId);
          callEntry.put("callEntryId", maxId);
          installationResultListMapper.updateCallEntry(callEntry);

          /*
           * EgovMap DO = installationResultListMapper.selectDO(entry); if((int)DO.get("movStusId") == 4){ Map<String, Object> mov = new HashMap<String, Object>(); mov.put("movId", 0); mov.put("installEntryId", entry.get("installEntryId")); mov.put("movFromLocId", DO.get("movToLocId")); mov.put("movToLocId", 0); mov.put("movTypeId", 262); mov.put("movStatusId", 1); mov.put("movConfirm", 0); mov.put("movCreateAt", new Date()); mov.put("movCreateBy", sessionVO.getUserId()); mov.put("movUpdateAt", new Date()); mov.put("movUpdateBy", sessionVO.getUserId()); mov.put("stkCrdPost", false); mov.put("stkCrdPostDate", "1900-01-01"); mov.put("stkCrdPostToWebOnTime", true);
           *
           * logger.debug("mov : {}", mov); //installationResultListMapper.insertMovement(mov);//프로시저 호출로 수정******* }else if((int)DO.get("movStusId") == 1){ DO.put("movStusId", 8); DO.put("movUpdateAt", new Date()); DO.put("movUpdateBy",sessionVO.getUserId()); //쿼리 }
           */

          exchange.put("soExchgNwCallEntryId", callEntry.get("callEntryId"));
          exchange.put("soExchgUpdateAt", new Date());
          exchange.put("soExchgUpdateBy", sessionVO.getUserId());

          logger.debug("exchange : {}", exchange);
          installationResultListMapper.updateSalesOrderExchange(exchange);

        }

        // }
      }
    }
    return true;
  }

  private double getOutRightPreBill(Map<String, Object> params) {
    int result = 0;
    List<EgovMap> outRightPreBill = installationResultListMapper.selectOutRightPreBill(params);

    if (outRightPreBill != null) {
      for (int i = 0; i < outRightPreBill.size(); i++) {

        result += (int) outRightPreBill.get(i).get("tradeAmt");

      }
    }
    return result;

  }

  private double getRSCertificateID(Map<String, Object> params) {
    int result = 0;
    List<EgovMap> list = installationResultListMapper.selectRSCertificateID(params);

    if (list != null) {
      result = (int) list.get(0).get("eurcId");
    }
    return result;

  }

  private Calendar getFirstDayOfMonth(Calendar calendar) {
    calendar.set(calendar.YEAR, calendar.MONTH, 1);
    return calendar;
  }

  private Calendar getLastDayOfMonth(Calendar calendar) {
    Calendar a = getFirstDayOfMonth(calendar);
    a.getActualMaximum(a.MONTH);

    return a;
  }

  private double getZRLocationId(Map<String, Object> params) {
    int result = 0;
    // List<EgovMap> outRightPreBill =
    // installationResultListMapper.selectZRLocation(params);

    /*
     * if(outRightPreBill != null){ for(int i = 0; i< outRightPreBill.size(); i++){
     *
     * result += (int)outRightPreBill.get(i).get("tradeAmt");
     *
     * } }
     */
    return 0;

  }

  private List<EgovMap> saveDataSirim(Map<String, Object> params, SessionVO sessionVO) {
    List<EgovMap> sirimList = null;

    EgovMap sirim1 = new EgovMap();
    sirim1.put("sirimId", 0);
    sirim1.put("sirimNo", params.get("sirimNo").toString().trim());
    sirim1.put("sirimTypeId", Integer.parseInt(params.get("hiddenInstallStkCategoryId").toString()));
    sirim1.put("sirimLoc", Integer.parseInt(params.get("hiddenDOWarehouseCode").toString()));
    sirim1.put("sirimQty", -1);
    sirim1.put("sirimDocNo", "");
    sirim1.put("sirimRemark", "");
    sirim1.put("sirimCreateAt", new Date());
    // sirim1.put("sirimCreateBy" sessionVO.getUserId());
    sirim1.put("sirimSyncCheck", false);
    sirim1.put("sirimEntryPoint", 1);
    sirim1.put("sirimAfterWebSys", true);
    logger.debug("sirim1 : {}", sirim1);
    sirimList.add(sirim1);

    EgovMap sirim2 = new EgovMap();
    sirim2.put("sirimId", 0);
    sirim2.put("sirimNo", params.get("sirimNo").toString().trim());
    sirim2.put("sirimTypeId", Integer.parseInt(params.get("hiddenInstallStkCategoryId").toString()));
    sirim2.put("sirimLoc", params.get("hiddenInstallNo").toString().trim());
    sirim2.put("sirimQty", 0);
    sirim2.put("sirimDocNo", "");
    sirim2.put("sirimRemark", "");
    sirim2.put("sirimCreateAt", new Date());
    // sirim2.put("sirimCreateBy" sessionVO.getUserId());
    sirim2.put("sirimSyncCheck", false);
    sirim2.put("sirimEntryPoint", 1);
    sirim2.put("sirimAfterWebSys", true);
    logger.debug("sirim2 : {}", sirim2);
    sirimList.add(sirim2);

    return sirimList;

  }

  private EgovMap saveDataInstallResult(Map<String, Object> params, SessionVO sessionVO) {

    int statusId = Integer.parseInt(params.get("status").toString());
    String sirimNo = "";
    String serialNo = "";
    int failId = 0;
    String nextCallDate = "01/01/1900";
    boolean allowComm = false;
    boolean inTradeIn = false;
    boolean reqSms = false;
    String refNo1 = "";
    String refNo2 = "";

    if (statusId == 4) {
      sirimNo = params.get("sirimNo").toString();
      serialNo = params.get("serialNo").toString();
      allowComm = params.get("checkCommission") != null ? true : false;
      inTradeIn = params.get("checkTrade") != null ? true : false;
      reqSms = params.get("reqSms") != null ? true : false;
      refNo1 = params.get("refNo1").toString();
      refNo2 = params.get("refNo2").toString();
    } else {
      failId = Integer.parseInt(params.get("failReason").toString());
      nextCallDate = params.get("nextCallDate").toString();
    }
    EgovMap installResult = new EgovMap();

    installResult.put("resultID", 0);
    installResult.put("entryId", params.get("hiddenInstallEntryId"));
    installResult.put("statusCodeId", statusId);
    installResult.put("CTID", Integer.parseInt(params.get("hiddenAssignCTMemId").toString().trim()));
    installResult.put("installDate", params.get("acInstallDate"));
    installResult.put("remark", params.get("remark").toString().trim());
    installResult.put("GLPost", 0);
    installResult.put("creator", sessionVO.getUserId());
    installResult.put("created", new Date());
    installResult.put("sirimNo", sirimNo);
    installResult.put("serialNo", serialNo);
    installResult.put("failId", failId);
    installResult.put("nextCallDate", nextCallDate);

    installResult.put("allowComm", allowComm == true ? "1" : "0");
    installResult.put("inTradeIn", inTradeIn == true ? "1" : "0");
    installResult.put("reqSms", reqSms == true ? "1" : "0");

    installResult.put("docRefNo1", refNo1);
    installResult.put("docRefNo2", refNo2);
    installResult.put("updated", new Date());
    installResult.put("updator", sessionVO.getUserId());
    installResult.put("adjAmount", 0);
    logger.debug("installResult : {}", installResult);
    return installResult;

  }

  public EgovMap getDocNo(String docNoId) {
    int tmp = Integer.parseInt(docNoId);
    String docNo = "";
    EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
    logger.debug("selectDocNo : {}", selectDocNo);
    String prefix = "";

    if (Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp) {

      if (selectDocNo.get("c2") != null) {
        prefix = (String) selectDocNo.get("c2");
      } else {
        prefix = "";
      }
      docNo = prefix.trim() + (String) selectDocNo.get("c1");
      // prefix = (selectDocNo.get("c2")).toString();
      logger.debug("prefix : {}", prefix);
      selectDocNo.put("docNo", docNo);
      selectDocNo.put("prefix", prefix);
    }
    return selectDocNo;
  }

  public EgovMap getDocNoNumber(String docNoId) {
    int tmp = Integer.parseInt(docNoId);
    String docNo = "";
    EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
    logger.debug("selectDocNo : {}", selectDocNo);

    if (docNoId.equals("130") && Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp) {
      docNo = (String) selectDocNo.get("c2") + (String) selectDocNo.get("c1");
      logger.debug("docNo : {}", docNo);
      selectDocNo.put("docNo", docNo);
    }
    return selectDocNo;
  }

  public void updateDocNoNumber(String docNoId) {// 코드값에 따라 자리수 다르게
    EgovMap selectDocNoNumber = memberListMapper.selectDocNo(docNoId);
    logger.debug("selectDocNoNumber : {}", selectDocNoNumber);
    int nextDocNoNumber = Integer.parseInt((String) selectDocNoNumber.get("c1")) + 1;
    String nextDocNo = "";
    if (docNoId.equals("145") || docNoId.equals("12")) {
      nextDocNo = String.format("%07d", nextDocNoNumber);
    } else {// 130일때,120일때,119일때
      nextDocNo = String.format("%08d", nextDocNoNumber);
    }
    selectDocNoNumber.put("nextDocNo", nextDocNo);
    logger.debug("selectDocNoNumber last : {}", selectDocNoNumber);
    memberListMapper.updateDocNo(selectDocNoNumber);
  }

  public String getNextDocNo(String prefixNo, String docNo) {
    String nextDocNo = "";
    int docNoLength = 0;
    System.out.println("!!!" + prefixNo);
    if (prefixNo != null && prefixNo != "") {
      docNoLength = docNo.replace(prefixNo, "").length();
      docNo = docNo.replace(prefixNo, "");
    } else {
      docNoLength = docNo.length();
    }

    int nextNo = Integer.parseInt(docNo) + 1;
    nextDocNo = String.format("%0" + docNoLength + "d", nextNo);
    logger.debug("nextDocNo : {}", nextDocNo);
    return nextDocNo;
  }

  @Override
  public Map<String, Object> runInstSp(Map<String, Object> params, SessionVO sessionVO, String no)
      throws ParseException {
    Map<String, Object> resultValue = new HashMap<String, Object>();
    Map<String, Object> logPram = null;
    String p_ordID = "";
    String retype = "";
    String p_type = "";
    String p_Pgrnm = "";

    if (sessionVO != null) {
      if ("2".equals(no)) { //
        if (params.get("hidCallType").equals("258")) { // PRODUCT EXCHANGE RETURN OLD STOCK REQUEST
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
        if (params.get("hidCallType").equals("258")) { // PRODUCT EXCHANGE RETURN OLD STOCK RESULT
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

      // KR-OHK Serial check add start
      if ("Y".equals(params.get("hidSerialRequireChkYn"))) {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
      } else {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
      }

      // if(!"000".equals(logPram.get("p1"))) {
      if (logPram.get("p1") != null && !"000".equals(logPram.get("p1"))) {
        throw new ApplicationException(AppConstants.FAIL,
            "[ERROR]" + logPram.get("p1") + ":" + "INSTALLATION Result Error");
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

  @SuppressWarnings("unchecked")
  @Override
  public Map<String, Object> insertInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
    Map<String, Object> resultValue = new HashMap<String, Object>();
    Map<String, Object> resultValue2 = new HashMap<String, Object>();

    if (sessionVO != null) {
      // RUN SP AND WAIT FOR RESULT BEFORE INSERT AND UPDATE
      resultValue = this.runInstSp(params, sessionVO, "1");

      if (null != resultValue) {
        HashMap<String, Object> spMap = (HashMap<String, Object>) resultValue.get("spMap");
        logger.debug("spMap :" + spMap.toString());

        if (!"000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG"))) && !"741".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) { // FAIL
          resultValue.put("logerr", "Y");
          throw new ApplicationException(AppConstants.FAIL, "FAIL");
        } else { // SUCCESS
          if ("000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) {
            spMap.put("pErrcode", "");
            spMap.put("pErrmsg", "");

            servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

            if (!"000".equals(spMap.get("pErrcode"))) {
              throw new ApplicationException(AppConstants.FAIL, "FAIL");
            }
          }
          String ordStat = this.getSalStat(params);

          if (!"1".equals(ordStat)) {
            if (params.get("hidCallType").equals("258")) {
              int exgCode = this.chkExgRsnCde(params);
              // SKIP SOEXC009 - EXCHANGE (WITHOUT RETURN)
              if (exgCode == 0) { // PEX EXCHANGE CODE NOT IN THE LIST
                if (Integer.parseInt(params.get("installStatus").toString()) == 4) {
                  // RUN SP AND WAIT FOR RESULT BEFORE INSERT AND UPDATE
                  resultValue = this.runInstSp(params, sessionVO, "2");

                  if (null != resultValue) {
                    spMap = (HashMap<String, Object>) resultValue.get("spMap");
                    logger.debug("spMap :" + spMap.toString());

                    if (!"000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG"))) && !"".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) { // FAIL
                      resultValue.put("logerr", "Y");
                      throw new ApplicationException(AppConstants.FAIL, "FAIL");
                    } else {
                      spMap.put("pErrcode", "");
                      spMap.put("pErrmsg", "");

                      servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

                      if (!"000".equals(spMap.get("pErrcode"))) {
                        throw new ApplicationException(AppConstants.FAIL, "FAIL");
                      }
                    }
                  }
                }
              }
            }
          }

          logger.debug("PARAM :" + params.toString());
          resultValue2 = Save_2(true, params, sessionVO);

          List<String> installAccList = (List<String>) params.get("instAccLst");
          EgovMap installResult = new EgovMap();

          installResult.put("installEntryId", CommonUtils.nvl(params.get("installEntryId")).toString());
          installResult.put("salesOrdId", CommonUtils.nvl(params.get("hidSalesOrderId")).toString());
          installResult.put("mobileYn", CommonUtils.nvl(params.get("mobileYn")).toString());

          logger.debug("mobileYn ====>> " +  params.get("mobileYn").toString());

          if (resultValue2.get("value") != null && resultValue2.get("value").equals("Completed")){

        	  logger.debug("chkInstallAcc ====>> " + params.get("chkInstallAcc").toString());

          	  if (params.get("chkInstallAcc") != null && (params.get("chkInstallAcc").toString().equals("on") || params.get("chkInstallAcc").toString().equals("Y"))){
          	    try {
                  insertInstallationAccessories(installAccList,installResult,sessionVO.getUserId());
                } catch (Exception e) {
                  // TODO Auto-generated catch block
                  e.printStackTrace();
                }
          	  }
            }
        }
      }
    } else {
      throw new ApplicationException(AppConstants.FAIL, "Fail");
    }

    return resultValue;
  }

  @Override
  public Map<String, Object> insertInstallationResult_2(Map<String, Object> params, SessionVO sessionVO)
      throws ParseException {
    Map<String, Object> resultValue = new HashMap<String, Object>();
    if (sessionVO != null) {
      resultValue = Save_2(true, params, sessionVO);
    }
    return resultValue;
  }

  private Map<String, Object> Save(boolean isfreepromo, Map<String, Object> params, SessionVO sessionVO)
      throws ParseException {

    boolean isBillAvb = false;

    Map<String, Object> resultValue = new HashMap<String, Object>();
    Map<String, Object> callEntry = new HashMap<String, Object>();
    Map<String, Object> callResult = new HashMap<String, Object>();
    Map<String, Object> orderLog = new HashMap<String, Object>();
    Map<String, Object> TaxinvoiceCompany = new HashMap<String, Object>();
    Map<String, Object> taxInvoiceCompanySub = new HashMap<String, Object>();
    Map<String, Object> AccTradeLedger = new HashMap<String, Object>();
    Map<String, Object> AccOrderBill = new HashMap<String, Object>();
    Map<String, Object> taxInvoiceOutright = new HashMap<String, Object>();
    Map<String, Object> taxInvoiceOutrightSub = new HashMap<String, Object>();
    Map<String, Object> salesOrderM = new HashMap<String, Object>();

    int statusId = Integer.parseInt(CommonUtils.nvl(params.get("installStatus")).toString());//
    String sirimNo = CommonUtils.nvl(params.get("sirimNo").toString()) != ""
        ? CommonUtils.nvl(params.get("sirimNo")).toString().toUpperCase() : "";
    String serialNo = CommonUtils.nvl(params.get("serialNo")).toString();
    int failId = CommonUtils.nvl(params.get("failReason")) != ""
        ? Integer.parseInt(CommonUtils.nvl(params.get("failReason")).toString()) : 0;
    String nextCallDate = CommonUtils.nvl(params.get("nextCallDate")).toString();
    boolean allowComm = CommonUtils.nvl(params.get("checkCommission")) != "" ? true : false;
    boolean inTradeIn = CommonUtils.nvl(params.get("checkTrade")) != "" ? true : false;
    boolean reqSms = CommonUtils.nvl(params.get("reqSms")) != "" ? true : false;
    String refNo1 = CommonUtils.nvl(params.get("refNo1"));
    String refNo2 = CommonUtils.nvl(params.get("refNo2"));
    String nextDateCall = (String) CommonUtils.nvl(params.get("nextCallDate"));
    String ApptypeID = CommonUtils.nvl(params.get("hidAppTypeId")).toString();
    String strOutrightTotalPrice = CommonUtils.nvl(params.get("hidOutright_Price"));
    String callTypeId = CommonUtils.nvl(params.get("hidCallType"));

    Map<String, Object> tradeamount = new HashMap<String, Object>();
    tradeamount.put("TRADE_SO_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
    Map<?, ?> outRightAmount35d = installationResultListMapper.getTradeAmount(tradeamount); // 35d
                                                                                      // amt

    Map<String, Object> ordTamtPram = new HashMap<String, Object>();

    String t_hidEntryId = "";
    if (null == CommonUtils.nvl(params.get("hidEntryId")).toString()) {
      t_hidEntryId = CommonUtils.nvl(params.get("installEntryId")).toString();
    } else {
      t_hidEntryId = CommonUtils.nvl(params.get("hidEntryId")).toString();
    }

    ordTamtPram.put("INSTALL_ENTRY_ID", t_hidEntryId);

    EgovMap ordInfo = installationResultListMapper.getOrderByInstallEntryID(ordTamtPram);

    String tAmt = "0"; // String.valueOf( CommonUtils.intNvl(
                       // outRightAmount.get("SUMTRADE_AMT")));

    if (null != ordInfo) {
      tAmt = String.valueOf(CommonUtils.intNvl(ordInfo.get("totAmt"))); //
    }

    double outright35dAmount = Double
        .parseDouble(String.valueOf(CommonUtils.intNvl(outRightAmount35d.get("SUMTRADE_AMT"))));

    double outrightTotalPrice = Double.parseDouble(tAmt == "" ? "0" : tAmt);
    double outrightBalance = outrightTotalPrice - outright35dAmount;

    logger.debug("outrightTotalPrice : " + outrightTotalPrice + ", outright35dAmount : " + outright35dAmount
        + ", outrightBalance :" + outrightBalance);
    params.put("outrightTotalPrice", outrightTotalPrice);
    params.put("outright35dAmount", outright35dAmount);
    params.put("outrightBalance", outrightBalance);

    double outrightSubProcessing = 0;
    double outrightSubBalance = 0;

    // get outright refno
    Map<String, Object> invoiceNum = new HashMap<String, Object>();
    invoiceNum.put("DocNo", "119");
    String invoiceNo = installationResultListMapper.getInvoiceNum(invoiceNum);
    // set Date params
    Date today = new Date();
    Calendar cal = Calendar.getInstance();
    cal.setTime(today);

    int month = cal.get(Calendar.MONTH);

    EgovMap installResult = new EgovMap();

    installResult.put("resultID", 0);
    installResult.put("entryId", Integer.parseInt(CommonUtils.nvl(params.get("hidEntryId")).toString()));
    installResult.put("statusCodeId", Integer.parseInt(CommonUtils.nvl(params.get("installStatus")).toString()));
    installResult.put("CTID", Integer.parseInt(CommonUtils.nvl(params.get("CTID")).toString()));
    installResult.put("installDate", CommonUtils.nvl(params.get("installDate")));
    installResult.put("remark", CommonUtils.nvl(params.get("remark")).toString().trim());
    installResult.put("GLPost", 0);
    installResult.put("creator", sessionVO.getUserId());
    installResult.put("created", new Date());
    installResult.put("sirimNo", sirimNo);
    installResult.put("serialNo", serialNo);
    installResult.put("failId", failId);
    installResult.put("nextCallDate", nextCallDate);

    installResult.put("allowComm", allowComm == true ? "1" : "0");
    installResult.put("inTradeIn", inTradeIn == true ? "1" : "0");
    installResult.put("reqSms", reqSms == true ? "1" : "0");

    installResult.put("docRefNo1", refNo1);
    installResult.put("docRefNo2", refNo2);
    installResult.put("updated", new Date());
    installResult.put("updator", sessionVO.getUserId());
    installResult.put("adjAmount", 0);
    logger.debug("installResult : {}", installResult);

    // update salesorderM status(SAL0001D)
    // if (callTypeId.equals("258")){
    //
    // }else{
    salesOrderM.put("salesOrdId", CommonUtils.nvl(params.get("hidSalesOrderId")).toString());
    salesOrderM.put("statusCodeId", CommonUtils.nvl(params.get("installStatus")).toString().equals("4") ? 4 : 1);
    // }

    /////////////////////// add by jgkim get addr //////////////////
    // PAY0033D
    EgovMap addrM = null;
    // PAY0034D
    EgovMap addrD = null;

    addrM = installationResultListMapper.getUsePAY0033D_addr(params);
    addrD = installationResultListMapper.getUsePAY0034D_addr(params);
    logger.debug("Prepared addrM:{}", addrM);
    logger.debug("Prepared addrD:{}", addrD);
    /////////////////////// add by hgham get taxRate //////////////////

    /////////////////////// add by hgham get taxRate //////////////////
    // int TAXRATE =0;

    // params.put("srvSalesOrderId", CommonUtils.nvl(
    // params.get("hidSalesOrderId")).toString());
    // TAXRATE = membershipConvSaleMapper.getTaxRate(params);
    // 2018-03-08 수정

    String zeroRatYn = "Y";
    String eurCertYn = "Y";

    params.put("srvSalesOrderId", params.get("hidSalesOrderId"));

    int zeroRat = membershipRentalQuotationMapper.selectGSTZeroRateLocation(params);
    int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(params);

    /*
     * GST Rate - Amended By Kit int filter_TAXRATE =6; int filter_TAXCODE =32;
     */
    int filter_TAXRATE = 0;
    int filter_TAXCODE = 32;

    // FILTER

    if (zeroRat > 0) {
      filter_TAXRATE = 0;
      filter_TAXCODE = 39;
    }

    if (EURCert > 0) {
      filter_TAXRATE = 0;
      filter_TAXCODE = 28;
    }

    logger.debug("zeroRat ==========================>>  " + zeroRatYn);
    logger.debug("EURCert ==========================>>  " + eurCertYn);

    /////////////////////// add by hgham get taxRate //////////////////

    if (ApptypeID.equals("66")) {

      int salesDt = CommonUtils.intNvl(ordInfo.get("salesDt"));
      int salesGSTcutOffDate = CommonUtils.intNvl(CommonUtils.getNowDate());

      if (salesDt < salesGSTcutOffDate) {

        //// GST do Not 2년 전부터 안했다고 함.
      }
    } else if (ApptypeID.equals("67") || ApptypeID.equals("68") || ApptypeID.equals("1412")) {

      /////////////////////////////// 고객 정보 및 주소 추가
      /////////////////////////////// /////////////////////////////////////////
      EgovMap custInfoMap = new EgovMap();
      // EgovMap micgAddres = new EgovMap();

      params.put("SALES_ORD_NO", params.get("hidTaxInvDSalesOrderNo"));
      custInfoMap = installationResultListMapper.getCustInfo(params);
      // custInfoMap = installationResultListMapper.getMAddressInfo(params);

      /////////////////////////////// 고객 정보 및 주소 추가
      /////////////////////////////// /////////////////////////////////////////

      if (ApptypeID.equals("1412")) {
        if (outright35dAmount > 200) {
          outrightSubProcessing = 0;
          outrightSubBalance = outrightTotalPrice - outright35dAmount;
        } else {
          outrightSubProcessing = (200 - outright35dAmount);
          outrightSubBalance = outrightTotalPrice - (outright35dAmount + (200 - outright35dAmount));
        }
      }

      if (outrightTotalPrice > outright35dAmount) {

        isBillAvb = true;

        ///////////////////////////// PAY0039D////////////////////////////////////////////
        Map<String, Object> accTRXMinus = new HashMap<String, Object>();
        accTRXMinus.put("TRXItemNo", 1);
        accTRXMinus.put("TRXGLAccID", 166);
        accTRXMinus.put("TRXGLDept", "0");
        accTRXMinus.put("TRXProject", "");
        accTRXMinus.put("TRXFinYear", 0);
        accTRXMinus.put("TRXPeriod", 0);
        accTRXMinus.put("TRXSourceTypeID", 389);
        accTRXMinus.put("TRXDocTypeID", 409);
        accTRXMinus.put("TRXNo", CommonUtils.nvl(params.get("hidEntryId")).toString());
        accTRXMinus.put("TRXDocNo", params.get("hidTradeLedger_InstallNo"));
        accTRXMinus.put("TRXCustBillID", CommonUtils.nvl(params.get("hidSalesOrderId")));
        accTRXMinus.put("TRXChequeNo", "");
        accTRXMinus.put("TRXCRCardSlip", "");
        accTRXMinus.put("TRXBisNo", "");
        accTRXMinus.put("TRXReconDate", new Date());
        accTRXMinus.put("TRXRemark", CommonUtils.nvl(params.get("msgRemark")));
        accTRXMinus.put("TRXCurrID", "RM");
        accTRXMinus.put("TRXCurrRate", 1);
        accTRXMinus.put("TRXAmount", -outrightBalance);
        accTRXMinus.put("TRXAmountRM", -outrightBalance);
        accTRXMinus.put("TRXIsSynch", 0);
        installationReversalMapper.addAccTRXes(accTRXMinus);

        Map<String, Object> accTRXPlus = new HashMap<String, Object>();
        accTRXPlus.put("TRXItemNo", 2);
        accTRXPlus.put("TRXGLAccID", 38);
        accTRXPlus.put("TRXGLDept", "0");
        accTRXPlus.put("TRXProject", "");
        accTRXPlus.put("TRXFinYear", 0);
        accTRXPlus.put("TRXPeriod", 0);
        accTRXPlus.put("TRXSourceTypeID", 389);
        accTRXPlus.put("TRXDocTypeID", 409);
        accTRXPlus.put("TRXNo", CommonUtils.nvl(params.get("hidEntryId")).toString());
        accTRXPlus.put("TRXDocNo", params.get("hidTradeLedger_InstallNo"));
        accTRXPlus.put("TRXCustBillID", CommonUtils.nvl(params.get("hidSalesOrderId")));
        accTRXPlus.put("TRXChequeNo", "");
        accTRXPlus.put("TRXCRCardSlip", "");
        accTRXPlus.put("TRXBisNo", "");
        accTRXPlus.put("TRXReconDate", new Date());
        accTRXPlus.put("TRXRemark", CommonUtils.nvl(params.get("msgRemark")));
        accTRXPlus.put("TRXCurrID", "RM");
        accTRXPlus.put("TRXCurrRate", 1);
        accTRXPlus.put("TRXAmount", outrightBalance);
        accTRXPlus.put("TRXAmountRM", outrightBalance);
        accTRXPlus.put("TRXIsSynch", 0);
        installationReversalMapper.addAccTRXes(accTRXPlus);
        ///////////////////////////// PAY0039D////////////////////////////////////////////

        ///////////////////////////// PAY0033D////////////////////////////////////////////
        String TAX_INVC_ID = installationResultListMapper.getPAY0033D_SEQ(invoiceNum);

        // Insert TaxinvoiceOutright
        taxInvoiceOutright.put("hidSalesOrderId", CommonUtils.nvl(params.get("hidSalesOrderId")));
        taxInvoiceOutright.put("TAX_INVC_ID", TAX_INVC_ID);
        taxInvoiceOutright.put("TAX_INVC_REF_NO", invoiceNo);
        taxInvoiceOutright.put("TAX_INVC_REF_DT", CommonUtils.getNowDate());
        taxInvoiceOutright.put("TAX_INVC_CUST_NAME", CommonUtils.nvl(custInfoMap.get("customer")));
        taxInvoiceOutright.put("TAX_INVC_CNTC_PERSON", CommonUtils.nvl(custInfoMap.get("contact")));
        // set address
        taxInvoiceOutright.put("TAX_INVC_ADDR1", CommonUtils.nvl(addrM.get("taxInvcAddr1")));
        taxInvoiceOutright.put("TAX_INVC_ADDR2", CommonUtils.nvl(addrM.get("taxInvcAddr2")));
        taxInvoiceOutright.put("TAX_INVC_ADDR3", "");
        taxInvoiceOutright.put("TAX_INVC_ADDR4", "");
        taxInvoiceOutright.put("TAX_INVC_POST_CODE", CommonUtils.nvl(addrM.get("taxInvcPostCode")));
        taxInvoiceOutright.put("TAX_INVC_STATE_NAME", CommonUtils.nvl(addrM.get("taxInvcStateName")));
        taxInvoiceOutright.put("TAX_INVC_CNTY", CommonUtils.nvl(addrM.get("taxInvcCnty")));
        taxInvoiceOutright.put("TAX_INVC_TASK_ID", 0);
        taxInvoiceOutright.put("TAX_INVC_CRT_DT", CommonUtils.getNowDate());
        taxInvoiceOutright.put("TAX_INVC_REM", params.get("hidTradeLedger_InstallNo"));

        if (filter_TAXRATE > 0) {
          taxInvoiceOutright.put("TAX_INVC_CHRG", outrightBalance * 100 / 106);
        } else {
          taxInvoiceOutright.put("TAX_INVC_CHRG", outrightBalance);
        }

        taxInvoiceOutright.put("TAX_INVC_OVERDU", 0);
        taxInvoiceOutright.put("TAX_INVC_AMT_DUE", outrightBalance);
        taxInvoiceOutright.put("TAX_INVC_PO_NO", "");
        taxInvoiceOutright.put("AREA_ID", CommonUtils.nvl(params.get("hidInstallation_AreaID")));
        taxInvoiceOutright.put("ADDR_DTL", CommonUtils.nvl(params.get("hidInstallation_AddDtl")));
        taxInvoiceOutright.put("STREET", "");
        logger.debug("Prepared TaxinvoiceOutright:{}", taxInvoiceOutright);
        ///////////////////////////// PAY0033D////////////////////////////////////////////

        ///////////////////////////// PAY0034D////////////////////////////////////////////
        if (ApptypeID.equals("1412")) {

          taxInvoiceOutrightSub.put("TAX_INVC_ID", TAX_INVC_ID);
          taxInvoiceOutrightSub.put("INVC_ITM_ORD_NO", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
          taxInvoiceOutrightSub.put("INVC_ITM_PO_NO", "");
          taxInvoiceOutrightSub.put("INVC_ITM_GST_RATE", filter_TAXRATE);

          if (filter_TAXRATE > 0) {
            taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS",
                Double.toString(outrightBalance - (outrightBalance * 100 / 106)));
            taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE", Double.toString(outrightBalance * 100 / 106));
            taxInvoiceOutrightSub.put("INVC_ITM_FEES_GST_TXS",
                outrightSubProcessing - (outrightSubProcessing * 100 / 106));
            taxInvoiceOutrightSub.put("INVC_ITM_FEES_CHRG", Double.toString(outrightSubProcessing * 100 / 106));
          } else {
            taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", "0");
            // taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE",
            // outrightSubBalance);
            taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE", outrightBalance);
            taxInvoiceOutrightSub.put("INVC_ITM_FEES_GST_TXS", "0");
            taxInvoiceOutrightSub.put("INVC_ITM_FEES_CHRG", outrightSubProcessing);
          }

          double a = (outrightBalance - (outrightBalance * 100 / 106));
          double b = (outrightBalance * 100 / 106);

          taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE", Double.toString(a + b));
          taxInvoiceOutrightSub.put("INVC_ITM_FEES_AMT_DUE", outrightSubProcessing);
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_CTGRY", CommonUtils.nvl(params.get("hidCategoryId")));
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_MODEL", "");
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_SERIAL_NO", CommonUtils.nvl((params.get("hidSerialNo"))));
          // set address
          taxInvoiceOutrightSub.put("INVC_ITM_ADD1", CommonUtils.nvl(addrD.get("invcItmAdd1")));
          taxInvoiceOutrightSub.put("INVC_ITM_ADD2", CommonUtils.nvl(addrD.get("invcItmAdd2")));
          taxInvoiceOutrightSub.put("INVC_ITM_ADD3", "");
          taxInvoiceOutrightSub.put("INVC_ITM_POST_CODE", CommonUtils.nvl(addrD.get("invcItmPostCode")));
          taxInvoiceOutrightSub.put("INVC_ITM_STATE_NAME", CommonUtils.nvl(addrD.get("invcItmStateName")));
          taxInvoiceOutrightSub.put("INVC_ITM_CNTY", CommonUtils.nvl(addrD.get("invcItmCnty")));

          taxInvoiceOutrightSub.put("AREA_ID", CommonUtils.nvl(params.get("hidInstallation_AreaID")));
          taxInvoiceOutrightSub.put("ADDR_DTL", CommonUtils.nvl(params.get("hidInstallation_AddDtl")));
          taxInvoiceOutrightSub.put("STREET", "");
          logger.debug("Prepared taxInvoiceOutrightSub: ", taxInvoiceOutrightSub);

        } else {

          taxInvoiceOutrightSub.put("TAX_INVC_ID", TAX_INVC_ID);
          taxInvoiceOutrightSub.put("INVC_ITM_ORD_NO", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
          taxInvoiceOutrightSub.put("INVC_ITM_PO_NO", "");
          taxInvoiceOutrightSub.put("INVC_ITM_GST_RATE", filter_TAXRATE);

          if (filter_TAXRATE > 0) {
            taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS",
                Double.toString(outrightBalance - (outrightBalance * 100 / 106)));
            taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE", outrightBalance * 100 / 106);

          } else {
            taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", "0");
            // taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE",
            // outrightSubBalance);
            taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE", outrightBalance);
          }

          double a = (outrightBalance - (outrightBalance * 100 / 106));
          double b = (outrightBalance * 100 / 106);
          taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE", Double.toString(a + b));

          // taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE",outrightSubBalance);
          taxInvoiceOutrightSub.put("INVC_ITM_FEES_AMT_DUE", "0");
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_CTGRY", CommonUtils.nvl(custInfoMap.get("codeDesc")));
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_MODEL", CommonUtils.nvl(custInfoMap.get("stkDesc")));
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_SERIAL_NO", CommonUtils.nvl((params.get("hidSerialNo"))));
          // set address
          taxInvoiceOutrightSub.put("INVC_ITM_ADD1", CommonUtils.nvl(addrD.get("invcItmAdd1")));
          taxInvoiceOutrightSub.put("INVC_ITM_ADD2", CommonUtils.nvl(addrD.get("invcItmAdd2")));
          taxInvoiceOutrightSub.put("INVC_ITM_ADD3", "");
          taxInvoiceOutrightSub.put("INVC_ITM_POST_CODE", CommonUtils.nvl(addrD.get("invcItmPostCode")));
          taxInvoiceOutrightSub.put("INVC_ITM_STATE_NAME", CommonUtils.nvl(addrD.get("invcItmStateName")));
          taxInvoiceOutrightSub.put("INVC_ITM_CNTY", CommonUtils.nvl(addrD.get("invcItmCnty")));

          taxInvoiceOutrightSub.put("AREA_ID", CommonUtils.nvl(params.get("hidInstallation_AreaID")));
          taxInvoiceOutrightSub.put("ADDR_DTL", CommonUtils.nvl(params.get("hidInstallation_AddDtl")));
          taxInvoiceOutrightSub.put("STREET", "");
          logger.debug("Prepared taxInvoiceOutrightSub: ", taxInvoiceOutrightSub);
        }
        ///////////////////////////// PAY0034D////////////////////////////////////////////

        AccTradeLedger.put("TRADE_RUN_ID", 0);
        AccTradeLedger.put("TRADE_ID", 0);
        AccTradeLedger.put("TRADE_SO_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
        AccTradeLedger.put("TRADE_DOC_NO", invoiceNo); // params.get("hidTradeLedger_InstallNo"));
        AccTradeLedger.put("TRADE_DOC_TYPE_ID", 164);
        AccTradeLedger.put("TRADE_DT_TM", CommonUtils.getNowDate());
        AccTradeLedger.put("TRADE_AMT", outrightBalance);
        AccTradeLedger.put("TRADE_BATCH_NO", "");
        AccTradeLedger.put("TRADE_INST_NO", 0);
        AccTradeLedger.put("TRADE_UPD_USER_ID", sessionVO.getUserId());
        AccTradeLedger.put("TRADE_UPD_DT", CommonUtils.getNowDate());
        AccTradeLedger.put("TRADE_IS_SYNC", 0);
        AccTradeLedger.put("R01", 0);
        logger.debug("Prepared AccTradeLedger: ", AccTradeLedger);

        ///////////////////////////// PAY0016D////////////////////////////////////////////
        AccOrderBill.put("ACC_BILL_ID", 0);
        AccOrderBill.put("ACC_BILL_TASK_ID", 0);
        AccOrderBill.put("ACC_BILL_REF_DT", CommonUtils.getNowDate());
        AccOrderBill.put("ACC_BILL_REF_NO", "1000");
        AccOrderBill.put("ACC_BILL_ORD_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
        AccOrderBill.put("ACC_BILL_ORD_NO", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")).toString());
        AccOrderBill.put("ACC_BILL_TYPE_ID", 1159);
        AccOrderBill.put("ACC_BILL_MODE_ID", 1164);
        AccOrderBill.put("ACC_BILL_SCHDUL_ID", 0);
        AccOrderBill.put("ACC_BILL_SCHDUL_PRIOD", 0);
        AccOrderBill.put("ACC_BILL_ADJ_ID", 0);
        AccOrderBill.put("ACC_BILL_SCHDUL_AMT", outrightBalance);
        AccOrderBill.put("ACC_BILL_ADJ_AMT", 0);
        AccOrderBill.put("ACC_BILL_NET_AMT", outrightBalance);
        AccOrderBill.put("ACC_BILL_STUS", 1);

        if (null != params.get("hidTradeLedger_InstallNo")) {
          AccOrderBill.put("ACC_BILL_REM", invoiceNo);
        } else {
          AccOrderBill.put("ACC_BILL_REM", " ");
        }

        AccOrderBill.put("ACC_BILL_CRT_DT", CommonUtils.getNowDate());
        AccOrderBill.put("ACC_BILL_CRT_USER_ID", sessionVO.getUserId());
        AccOrderBill.put("ACC_BILL_GRP_ID", 0);
        AccOrderBill.put("ACC_BILL_TAX_CODE_ID", filter_TAXCODE);
        AccOrderBill.put("ACC_BILL_TAX_RATE", filter_TAXRATE);

        if (filter_TAXRATE == 6) {
          AccOrderBill.put("ACC_BILL_TXS_AMT", Double.toString(outrightBalance - (outrightBalance * 100 / 106)));
        } else {
          AccOrderBill.put("ACC_BILL_TXS_AMT", 0);
        }

        AccOrderBill.put("ACC_BILL_ACCT_CNVR", 0);
        AccOrderBill.put("ACC_BILL_CNTRCT_ID", 0);
        logger.debug("prepared AccOrderBill: ", AccOrderBill);
        ///////////////////////////// PAY0016D////////////////////////////////////////////

      }

    }

    // //FAIL
    if (params.get("installStatus").toString().equals("21")) {
      // FAIL
      callEntry.put("callEntryId", 0);
      callEntry.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
      callEntry.put("typeId", Integer.parseInt(params.get("hidCallType").toString()));
      callEntry.put("statusCodeId", 19);
      callEntry.put("resultId", 0);
      callEntry.put("docId", CommonUtils.nvl(params.get("hidDocId")));
      callEntry.put("creator", sessionVO.getUserId());
      callEntry.put("created", new Date());
      callEntry.put("callDate", nextDateCall);
      callEntry.put("isWaitForCancel", false);
      callEntry.put("happyCallerId", 0);
      callEntry.put("updated", new Date());
      callEntry.put("updator", sessionVO.getUserId());
      callEntry.put("oriCallDate", nextDateCall);

      logger.debug("callEntry1111 : {}", callEntry);
      // installationResultListMapper.insertCallEntry(callEntry);

      callResult.put("callResultId", 0);
      callResult.put("callEntryId", 0);
      callResult.put("callStatusId", 19);
      callResult.put("callCallDate", nextDateCall);
      callResult.put("callActionDate", "01/01/1900");
      callResult.put("callFeedBackId", 0);
      callResult.put("callCTID", 0);
      callResult.put("callRemark", installResult.get("remark"));
      callResult.put("callCreateBy", sessionVO.getUserId());
      callResult.put("callCreateAt", new Date());
      callResult.put("callCreateByDept", 0);
      callResult.put("callHCID", 0);
      callResult.put("callROSAmt", 0);
      callResult.put("callSMS", false);
      callResult.put("callSMSRemark", "");

      logger.debug("callResultJInmu : {}", callResult);
      // installationResultListMapper.insertCallResult(callResult);

      // callEntry.put("resultId", "위에 쿼리 시퀀스");
      // installationResultListMapper.updateCallEntry(callEntry);

      orderLog.put("LogID", 0);
      orderLog.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
      orderLog.put("progressId", Integer.parseInt(params.get("hidCallType").toString()) == 257 ? 2 : 3);
      orderLog.put("logDate", new Date());
      orderLog.put("refId", 0);
      orderLog.put("isLock", 0);
      orderLog.put("logCreator", sessionVO.getUserId());
      orderLog.put("logCreated", new Date());

      logger.debug("orderLog : {}", orderLog);
      // installationResultListMapper.insertOrderLog(orderLog);
    }

    if (Integer.parseInt(CommonUtils.nvl(params.get("installStatus")).toString()) == 4) {
      resultValue.put("value", "Completed");

      orderLog.put("LogID", 0);
      orderLog.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
      orderLog.put("progressId", 5);
      orderLog.put("logDate", new Date());
      orderLog.put("refId", 0);
      orderLog.put("isLock", 0);
      orderLog.put("logCreator", sessionVO.getUserId());
      orderLog.put("logCreated", new Date());

    } else {
      resultValue.put("value", "Fail");
    }
    resultValue.put("installEntryNo", CommonUtils.nvl(params.get("hiddeninstallEntryNo")));

    //////////////////////////// insertInstallation
    //////////////////////////// ////////////////////////////////
    insertInstallation(statusId, ApptypeID, installResult, callEntry, callResult, orderLog, TaxinvoiceCompany,
        AccTradeLedger, AccOrderBill, taxInvoiceOutright, taxInvoiceOutrightSub, salesOrderM, isBillAvb);

    //////////////////////////// insertInstallation
    //////////////////////////// ////////////////////////////////

    //////////////////////// 물류 호출 add by hgham/////////////////////////////
    Map<String, Object> logPram = null;
    if (Integer.parseInt(params.get("installStatus").toString()) == 4) {
      ///////////////////////// 물류 호출//////////////////////
      logPram = new HashMap<String, Object>();
      logPram.put("ORD_ID", params.get("hiddeninstallEntryNo"));
      logPram.put("RETYPE", "COMPLET");
      logPram.put("P_TYPE", "OD01");
      logPram.put("P_PRGNM", "INSCOM");
      logPram.put("USERID", sessionVO.getUserId());

      logger.debug("install 물류 호출 PRAM ===>" + logPram.toString());
      servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
      logPram.put("P_RESULT_TYPE", "IN");
      logPram.put("P_RESULT_MSG", logPram.get("p1"));
      logger.debug("install 물류 호출 결과 ===>" + logPram);
      ///////////////////////// 물류 호출 END //////////////////////

    } else if (Integer.parseInt(params.get("installStatus").toString()) == 21) {

      ///////////////////////// 물류 호출//////////////////////
      logPram = new HashMap<String, Object>();
      logPram.put("ORD_ID", params.get("hiddeninstallEntryNo"));
      logPram.put("RETYPE", "SVO");
      logPram.put("P_TYPE", "OD02");
      logPram.put("P_PRGNM", "INSCAN");
      logPram.put("USERID", sessionVO.getUserId());

      logger.debug("install 물류  CANCEL 호출 PRAM ===>" + logPram.toString());
      servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
      logPram.put("P_RESULT_TYPE", "IN");
      logPram.put("P_RESULT_MSG", logPram.get("p1"));
      logger.debug("install 물류 CANCEL  호출 결과 ===>");
      ///////////////////////// 물류 호출 END //////////////////////
    }
    resultValue.put("spMap", logPram);
    //////////////////////// 물류 호출 add by hgham/////////////////////////////

    return resultValue;
  }

  private Map<String, Object> Save_2(boolean isfreepromo, Map<String, Object> params, SessionVO sessionVO) throws ParseException {
    boolean isBillAvb = false;

    Map<String, Object> resultValue = new HashMap<String, Object>();
    Map<String, Object> callEntry = new HashMap<String, Object>();
    Map<String, Object> callResult = new HashMap<String, Object>();
    Map<String, Object> orderLog = new HashMap<String, Object>();
    Map<String, Object> TaxinvoiceCompany = new HashMap<String, Object>();
    Map<String, Object> taxInvoiceCompanySub = new HashMap<String, Object>();
    Map<String, Object> AccTradeLedger = new HashMap<String, Object>();
    Map<String, Object> AccOrderBill = new HashMap<String, Object>();
    Map<String, Object> taxInvoiceOutright = new HashMap<String, Object>();
    Map<String, Object> taxInvoiceOutrightSub = new HashMap<String, Object>();
    Map<String, Object> salesOrderM = new HashMap<String, Object>();

    String sirimNo = CommonUtils.nvl(params.get("sirimNo").toString()) != "" ? CommonUtils.nvl(params.get("sirimNo")).toString().toUpperCase() : "";
    String serialNo = CommonUtils.nvl(params.get("serialNo")).toString();
    String nextCallDate = CommonUtils.nvl(params.get("nextCallDate")).toString();
    String refNo1 = CommonUtils.nvl(params.get("refNo1"));
    String refNo2 = CommonUtils.nvl(params.get("refNo2"));
    String nextDateCall = (String) CommonUtils.nvl(params.get("nextCallDate"));
    String ApptypeID = CommonUtils.nvl(params.get("hidAppTypeId")).toString();
    String strOutrightTotalPrice = CommonUtils.nvl(params.get("hidOutright_Price"));
    String callTypeId = CommonUtils.nvl(params.get("hidCallType"));
    int statusId = Integer.parseInt(CommonUtils.nvl(params.get("installStatus")).toString());
    int failId = CommonUtils.nvl(params.get("failReason")) != "" ? Integer.parseInt(CommonUtils.nvl(params.get("failReason")).toString()) : 0;
    boolean allowComm = CommonUtils.nvl(params.get("checkCommission")) != "" ? true : false;
    boolean inTradeIn = CommonUtils.nvl(params.get("checkTrade")) != "" ? true : false;
    boolean reqSms = CommonUtils.nvl(params.get("reqSms")) != "" ? true : false;

    Map<String, Object> tradeamount = new HashMap<String, Object>();
    tradeamount.put("TRADE_SO_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
    Map<?, ?> outRightAmount35d = installationResultListMapper.getTradeAmount(tradeamount);

    Map<String, Object> ordTamtPram = new HashMap<String, Object>();

    String t_hidEntryId = "";
    if (null == CommonUtils.nvl(params.get("hidEntryId")).toString()) {
      t_hidEntryId = CommonUtils.nvl(params.get("installEntryId")).toString();
    } else {
      t_hidEntryId = CommonUtils.nvl(params.get("hidEntryId")).toString();
    }

    ordTamtPram.put("INSTALL_ENTRY_ID", t_hidEntryId);

    EgovMap ordInfo = installationResultListMapper.getOrderByInstallEntryID(ordTamtPram);

    String tAmt = "0";

    if (null != ordInfo) {
      tAmt = String.valueOf(CommonUtils.intNvl(ordInfo.get("totAmt"))); //
    }

    double outright35dAmount = Double.parseDouble(String.valueOf(CommonUtils.intNvl(outRightAmount35d.get("SUMTRADE_AMT"))));
    double outrightTotalPrice = Double.parseDouble(tAmt == "" ? "0" : tAmt);
    double outrightBalance = outrightTotalPrice - outright35dAmount;

    logger.debug("outrightTotalPrice : " + outrightTotalPrice + ", outright35dAmount : " + outright35dAmount + ", outrightBalance :" + outrightBalance);
    params.put("outrightTotalPrice", outrightTotalPrice);
    params.put("outright35dAmount", outright35dAmount);
    params.put("outrightBalance", outrightBalance);

    double outrightSubProcessing = 0;
    double outrightSubBalance = 0;

    // GET OUTRIGHT REF.NO.
    Map<String, Object> invoiceNum = new HashMap<String, Object>();
    invoiceNum.put("DocNo", "119");

    String invoiceNo = installationResultListMapper.getInvoiceNum(invoiceNum);

    // GET CURRENT DATE TIME
    Date today = new Date();
    Calendar cal = Calendar.getInstance();
    cal.setTime(today);
    int month = cal.get(Calendar.MONTH);

    EgovMap installResult = new EgovMap();

    installResult.put("resultID", 0);
    installResult.put("salesOrdId", CommonUtils.nvl(params.get("hidSalesOrderId")).toString());
    installResult.put("entryId", Integer.parseInt(CommonUtils.nvl(params.get("hidEntryId")).toString()));
    installResult.put("statusCodeId", Integer.parseInt(CommonUtils.nvl(params.get("installStatus")).toString()));
    installResult.put("CTID", Integer.parseInt(CommonUtils.nvl(params.get("CTID")).toString()));
    installResult.put("installDate", CommonUtils.nvl(params.get("installDate")));
    installResult.put("remark", CommonUtils.nvl(params.get("remark")).toString().trim());
    installResult.put("GLPost", 0);
    installResult.put("creator", sessionVO.getUserId());
    installResult.put("created", new Date());
    installResult.put("sirimNo", sirimNo);
    installResult.put("serialNo", serialNo);
    installResult.put("nextCallDate", nextCallDate);
    installResult.put("allowComm", allowComm == true ? "1" : "0");
    installResult.put("inTradeIn", inTradeIn == true ? "1" : "0");
    installResult.put("reqSms", reqSms == true ? "1" : "0");
    installResult.put("docRefNo1", refNo1);
    installResult.put("docRefNo2", refNo2);
    installResult.put("updated", new Date());
    installResult.put("updator", sessionVO.getUserId());
    installResult.put("adjAmount", 0);
    installResult.put("psi", CommonUtils.nvl(params.get("psiRcd")).toString());
    installResult.put("lpm", CommonUtils.nvl(params.get("lpmRcd")).toString());
    installResult.put("volt", CommonUtils.nvl(params.get("volt")).toString());
    installResult.put("tds", CommonUtils.nvl(params.get("tds")).toString());
    installResult.put("roomTemp", CommonUtils.nvl(params.get("roomTemp")).toString());
    installResult.put("waterSourceTemp", CommonUtils.nvl(params.get("waterSourceTemp")).toString());
    installResult.put("adptUsed", CommonUtils.nvl(params.get("adptUsed")).toString());
    installResult.put("competitor", CommonUtils.nvl(params.get("competitor")).toString());
    installResult.put("competitorBrand", CommonUtils.nvl(params.get("competitorBrand")).toString());

    if (CommonUtils.nvl(params.get("mobileYn")).toString().equals("Y") ){
      installResult.put("ntu", CommonUtils.nvl(params.get("ntu")).toString());
    } else{
      installResult.put("ntu", CommonUtils.nvl(SalesConstants.STATUS_COMPLETED).toString().equals(CommonUtils.nvl(params.get("installStatus")).toString()) ? CommonUtils.nvl(params.get("ntuCom")).toString() : CommonUtils.nvl(params.get("ntuFail")).toString());
    }

    installResult.put("boosterPump", CommonUtils.nvl(params.get("boosterPump")).toString());
    installResult.put("aftPsi", CommonUtils.nvl(params.get("aftPsi")).toString());
    installResult.put("aftLpm", CommonUtils.nvl(params.get("aftLpm")).toString());
    installResult.put("atchFileGrpId", CommonUtils.nvl(params.get("fileGroupKey")).toString());
    installResult.put("turbLvl", CommonUtils.nvl(params.get("turbLvl")).toString());

    // Added by keyi 20220727 Water Source Type Dropdown mobile
    installResult.put("waterSrcType", CommonUtils.nvl(params.get("waterSrcType")).toString());

    // mobile trigger SMS - ALEX
    installResult.put("resultIcMobileNo", CommonUtils.nvl(params.get("resultIcMobileNo")).toString());
    installResult.put("userId", CommonUtils.nvl(params.get("userId")).toString());

    installResult.put("smsMobileNo", CommonUtils.nvl(params.get("hidCustomerContact")).toString());
    installResult.put("ctCode", CommonUtils.nvl(params.get("ctCode")).toString());
    installResult.put("CTID", Integer.parseInt(CommonUtils.nvl(params.get("CTID")).toString()));
    installResult.put("dtPairId", CommonUtils.nvl(params.get("dtPairCode")).toString());

    // installResult.put("failId", CommonUtils.nvl(params.get("failChild")).toString());
    // installResult.put("failLct", CommonUtils.nvl(params.get("failParent")).toString());

    installResult.put("failId", CommonUtils.nvl(params.get("failReasonCode")).toString());
    installResult.put("failLct", CommonUtils.nvl(params.get("failLocCde")).toString());

    installResult.put("instChklstCheckBox", ("Y".equals(CommonUtils.nvl(params.get("instChklstCheckBox")).toString())) ? "Y" : "N");
    installResult.put("instNoteChk", ("Y".equals(CommonUtils.nvl(params.get("instNoteChk")).toString())) ? "Y" : "N");
    installResult.put("failDeptChk", ("Y".equals(CommonUtils.nvl(params.get("failDeptChk")).toString())) ? "Y" : "N");

    // Added by keyi installation note phase1 20220401
    installResult.put("ownerCode", CommonUtils.nvl(params.get("ownerCode")).toString());
    installResult.put("resultCustName", CommonUtils.nvl(params.get("resultCustName")).toString());
    installResult.put("resultIcMobileNo", CommonUtils.nvl(params.get("resultIcMobileNo")).toString());
    installResult.put("resultReportEmailNo", CommonUtils.nvl(params.get("resultReportEmailNo")).toString());
    installResult.put("resultAcceptanceName", CommonUtils.nvl(params.get("resultAcceptanceName")).toString());

    // Added by Keyi Installation SMS 202206
    //  if(!CommonUtils.nvl(params.get("chkSms")).toString().equals(null)){
    //    installResult.put("chkSMS", CommonUtils.nvl(params.get("chkSms")).toString());
    //  }else{
    //    installResult.put("chkSMS", "N");
    //  }

    installResult.put("custType", CommonUtils.nvl(params.get("custType")).toString());
    installResult.put("custTypeMobile", CommonUtils.nvl(params.get("customerType")).toString());
    // installResult.put("custMobileNo", CommonUtils.nvl(params.get("custMobileNo")).toString());
    installResult.put("salesOrderNo", CommonUtils.nvl(params.get("salesOrderNo")).toString());

    if (!CommonUtils.nvl(params.get("ctMemCode")).toString().equals(null)) {
      installResult.put("ctCode", CommonUtils.nvl(params.get("ctMemCode")).toString());
    } else {
      installResult.put("ctCode", CommonUtils.nvl(params.get("ctCode")).toString());
    }

    installResult.put("dismantle", params.get("hidDismantle"));//Dismantle
    installResult.put("tPipe", params.get("totalPipe"));//Total Copper Pipe
    installResult.put("tWire", params.get("totalWire"));//Total Wire
    installResult.put("gasPreBIns", params.get("gaspreBefIns"));//Before Installation
    installResult.put("gasPreAIns", params.get("gaspreAftIns"));//After Installation

    installResult.put("signData", params.get("signData"));
    installResult.put("dispComm", params.get("dispComm"));

//    if(!CommonUtils.nvl(params.get("checkSend")).toString().equals(null)){
//		installResult.put("checkSend", CommonUtils.nvl(params.get("checkSend")).toString());
//	}else{
//		installResult.put("checkSend", "N");
//	}

    logger.debug("========================INS SMS PARAM===========================");
    logger.debug("INS SMS PARAM : {}", params.toString());
    logger.debug("========================INS SMS PARAM===========================");

    logger.debug("========================INSTALLATION RESULT PRM===========================");
    logger.debug("INSTALLATION RESULT : {}", installResult);
    logger.debug("========================INSTALLATION RESULT PRM===========================");

    salesOrderM.put("salesOrdId", CommonUtils.nvl(params.get("hidSalesOrderId")).toString());
    salesOrderM.put("statusCodeId", CommonUtils.nvl(params.get("installStatus")).toString().equals("4") ? 4 : 1);

    // PAY0033D - OUTRIGHT SALES INVOICE - REPORT DISPLAY DATA.
    EgovMap addrM = null;
    // PAY0034D - OUTRIGHT SALES INVOICE DETAILS - REPORT DISPLAY DATA.
    EgovMap addrD = null;

    addrM = installationResultListMapper.getUsePAY0033D_addr(params);
    addrD = installationResultListMapper.getUsePAY0034D_addr(params);

    logger.debug("========================OUTRIGHT SALES INVOICE PRM===========================");
    logger.debug("addrM [PAY0033D] :{}", addrM);
    logger.debug("addrD [PAY0034D] :{}", addrD);
    logger.debug("========================OUTRIGHT SALES INVOICE PRM===========================");

    String zeroRatYn = "Y";
    String eurCertYn = "Y";

    params.put("srvSalesOrderId", params.get("hidSalesOrderId"));

    int zeroRat = membershipRentalQuotationMapper.selectGSTZeroRateLocation(params);
    int EURCert = membershipRentalQuotationMapper.selectGSTEURCertificate(params);

    /*
     * GST RATE Amended By Kit int filter_TAXRATE = 6; int filter_TAXCODE =32;
     */
    int filter_TAXRATE = 0;
    int filter_TAXCODE = 32;

    // FILTER
    if (zeroRat > 0) {
      filter_TAXRATE = 0;
      filter_TAXCODE = 39;
    }

    if (EURCert > 0) {
      filter_TAXRATE = 0;
      filter_TAXCODE = 28;
    }

    /*
     * APPLICATION TYPE -------------------------------- 66 - RENTAL 67 - OUTRIGHT 68 - INSTALLMENT 1412 - OUTRIGHT PLUS
     */

    if (ApptypeID.equals("66")) {
      int salesDt = CommonUtils.intNvl(ordInfo.get("salesDt"));
      int salesGSTcutOffDate = CommonUtils.intNvl(CommonUtils.getNowDate());
      if (salesDt < salesGSTcutOffDate) {
        // GST DO NOT 2년 전부터 안했다고 함.
      }
    } else if (ApptypeID.equals("67") || ApptypeID.equals("68") || ApptypeID.equals("1412")) {

      // ADD CUSTOMER INFORMATION AND ADDRESS
      EgovMap custInfoMap = new EgovMap();
      // EgovMap micgAddres = new EgovMap();

      params.put("SALES_ORD_NO", params.get("hidTaxInvDSalesOrderNo"));
      custInfoMap = installationResultListMapper.getCustInfo(params);
      // custInfoMap = installationResultListMapper.getMAddressInfo(params);

      if (ApptypeID.equals("1412")) { // OUTRIGHT PLUS
        if (outright35dAmount > 200) {
          outrightSubProcessing = 0;
          outrightSubBalance = outrightTotalPrice - outright35dAmount;
        } else {
          outrightSubProcessing = (200 - outright35dAmount);
          outrightSubBalance = outrightTotalPrice - (outright35dAmount + (200 - outright35dAmount));
        }
      }

      if (outrightTotalPrice > outright35dAmount) {
        isBillAvb = true;

        // PAY0039D - DIRECT DEBIT & AUTO DEBIT DEDUCTION WITH SCHEDULER SETTING
        Map<String, Object> accTRXMinus = new HashMap<String, Object>();

        accTRXMinus.put("TRXItemNo", 1);
        accTRXMinus.put("TRXGLAccID", 166);
        accTRXMinus.put("TRXGLDept", "0");
        accTRXMinus.put("TRXProject", "");
        accTRXMinus.put("TRXFinYear", 0);
        accTRXMinus.put("TRXPeriod", 0);
        accTRXMinus.put("TRXSourceTypeID", 389);
        accTRXMinus.put("TRXDocTypeID", 409);
        accTRXMinus.put("TRXNo", CommonUtils.nvl(params.get("hidEntryId")).toString());
        accTRXMinus.put("TRXDocNo", params.get("hidTradeLedger_InstallNo"));
        accTRXMinus.put("TRXCustBillID", CommonUtils.nvl(params.get("hidSalesOrderId")));
        accTRXMinus.put("TRXChequeNo", "");
        accTRXMinus.put("TRXCRCardSlip", "");
        accTRXMinus.put("TRXBisNo", "");
        accTRXMinus.put("TRXReconDate", new Date());
        accTRXMinus.put("TRXRemark", CommonUtils.nvl(params.get("msgRemark")));
        accTRXMinus.put("TRXCurrID", "RM");
        accTRXMinus.put("TRXCurrRate", 1);
        accTRXMinus.put("TRXAmount", -outrightBalance);
        accTRXMinus.put("TRXAmountRM", -outrightBalance);
        accTRXMinus.put("TRXIsSynch", 0);

        // INSERT PAY0036D - PAYMENT COLLECTION TRANSACTION (-).
        installationReversalMapper.addAccTRXes(accTRXMinus);

        Map<String, Object> accTRXPlus = new HashMap<String, Object>();

        accTRXPlus.put("TRXItemNo", 2);
        accTRXPlus.put("TRXGLAccID", 38);
        accTRXPlus.put("TRXGLDept", "0");
        accTRXPlus.put("TRXProject", "");
        accTRXPlus.put("TRXFinYear", 0);
        accTRXPlus.put("TRXPeriod", 0);
        accTRXPlus.put("TRXSourceTypeID", 389);
        accTRXPlus.put("TRXDocTypeID", 409);
        accTRXPlus.put("TRXNo", CommonUtils.nvl(params.get("hidEntryId")).toString());
        accTRXPlus.put("TRXDocNo", params.get("hidTradeLedger_InstallNo"));
        accTRXPlus.put("TRXCustBillID", CommonUtils.nvl(params.get("hidSalesOrderId")));
        accTRXPlus.put("TRXChequeNo", "");
        accTRXPlus.put("TRXCRCardSlip", "");
        accTRXPlus.put("TRXBisNo", "");
        accTRXPlus.put("TRXReconDate", new Date());
        accTRXPlus.put("TRXRemark", CommonUtils.nvl(params.get("msgRemark")));
        accTRXPlus.put("TRXCurrID", "RM");
        accTRXPlus.put("TRXCurrRate", 1);
        accTRXPlus.put("TRXAmount", outrightBalance);
        accTRXPlus.put("TRXAmountRM", outrightBalance);
        accTRXPlus.put("TRXIsSynch", 0);

        // INSERT PAY0036D - PAYMENT COLLECTION TRANSACTION. (+)
        installationReversalMapper.addAccTRXes(accTRXPlus);

        // PAY0033D - OUTRIGHT SALES INVOICE
        String TAX_INVC_ID = installationResultListMapper.getPAY0033D_SEQ(invoiceNum); // GET
                                                                                       // NEXT
                                                                                       // SEQUENCE
                                                                                       // NUMBER

        // INSERT TAX INVOICE OUTRIGHT
        taxInvoiceOutright.put("hidSalesOrderId", CommonUtils.nvl(params.get("hidSalesOrderId")));
        taxInvoiceOutright.put("TAX_INVC_ID", TAX_INVC_ID);
        taxInvoiceOutright.put("TAX_INVC_REF_NO", invoiceNo);
        taxInvoiceOutright.put("TAX_INVC_REF_DT", CommonUtils.getNowDate());
        taxInvoiceOutright.put("TAX_INVC_CUST_NAME", CommonUtils.nvl(custInfoMap.get("customer")));
        taxInvoiceOutright.put("TAX_INVC_CNTC_PERSON", CommonUtils.nvl(custInfoMap.get("contact")));

        // SET ADDRESS
        taxInvoiceOutright.put("TAX_INVC_ADDR1", CommonUtils.nvl(addrM.get("taxInvcAddr1")));
        taxInvoiceOutright.put("TAX_INVC_ADDR2", CommonUtils.nvl(addrM.get("taxInvcAddr2")));
        taxInvoiceOutright.put("TAX_INVC_ADDR3", "");
        taxInvoiceOutright.put("TAX_INVC_ADDR4", "");
        taxInvoiceOutright.put("TAX_INVC_POST_CODE", CommonUtils.nvl(addrM.get("taxInvcPostCode")));
        taxInvoiceOutright.put("TAX_INVC_STATE_NAME", CommonUtils.nvl(addrM.get("taxInvcStateName")));
        taxInvoiceOutright.put("TAX_INVC_CNTY", CommonUtils.nvl(addrM.get("taxInvcCnty")));
        taxInvoiceOutright.put("TAX_INVC_TASK_ID", 0);
        taxInvoiceOutright.put("TAX_INVC_CRT_DT", CommonUtils.getNowDate());
        taxInvoiceOutright.put("TAX_INVC_REM", params.get("hidTradeLedger_InstallNo"));

        if (filter_TAXRATE > 0) {
          taxInvoiceOutright.put("TAX_INVC_CHRG", outrightBalance * 100 / 106);
        } else {
          taxInvoiceOutright.put("TAX_INVC_CHRG", outrightBalance);
        }

        taxInvoiceOutright.put("TAX_INVC_OVERDU", 0);
        taxInvoiceOutright.put("TAX_INVC_AMT_DUE", outrightBalance);
        taxInvoiceOutright.put("TAX_INVC_PO_NO", "");
        taxInvoiceOutright.put("AREA_ID", CommonUtils.nvl(params.get("hidInstallation_AreaID")));
        taxInvoiceOutright.put("ADDR_DTL", CommonUtils.nvl(params.get("hidInstallation_AddDtl")));
        taxInvoiceOutright.put("STREET", "");

        logger.debug("===============================TAX INVOICE OUTRIGHT========================================");
        logger.debug("TAX INVOICE OUTRIGHT PRM :{} ", taxInvoiceOutright);
        logger.debug("===============================TAX INVOICE OUTRIGHT========================================");

        ///////////////////////////// PAY0034D////////////////////////////////////////////
        if (ApptypeID.equals("1412")) { // OUTRIGHT PLUS
          taxInvoiceOutrightSub.put("TAX_INVC_ID", TAX_INVC_ID);
          taxInvoiceOutrightSub.put("INVC_ITM_ORD_NO", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
          taxInvoiceOutrightSub.put("INVC_ITM_PO_NO", "");
          taxInvoiceOutrightSub.put("INVC_ITM_GST_RATE", filter_TAXRATE);

          if (filter_TAXRATE > 0) {
            taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS",
                Double.toString(outrightBalance - (outrightBalance * 100 / 106)));
            taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE", Double.toString(outrightBalance * 100 / 106));
            taxInvoiceOutrightSub.put("INVC_ITM_FEES_GST_TXS",
                outrightSubProcessing - (outrightSubProcessing * 100 / 106));
            taxInvoiceOutrightSub.put("INVC_ITM_FEES_CHRG", Double.toString(outrightSubProcessing * 100 / 106));
          } else {
            taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", "0");
            // taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE",
            // outrightSubBalance);
            taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE", outrightBalance);
            taxInvoiceOutrightSub.put("INVC_ITM_FEES_GST_TXS", "0");
            taxInvoiceOutrightSub.put("INVC_ITM_FEES_CHRG", outrightSubProcessing);
          }

          double a = (outrightBalance - (outrightBalance * 100 / 106));
          double b = (outrightBalance * 100 / 106);

          taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE", Double.toString(a + b));
          taxInvoiceOutrightSub.put("INVC_ITM_FEES_AMT_DUE", outrightSubProcessing);
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_CTGRY", CommonUtils.nvl(params.get("hidCategoryId")));
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_MODEL", "");
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_SERIAL_NO", CommonUtils.nvl((params.get("hidSerialNo"))));

          // SET ADDRESS
          taxInvoiceOutrightSub.put("INVC_ITM_ADD1", CommonUtils.nvl(addrD.get("invcItmAdd1")));
          taxInvoiceOutrightSub.put("INVC_ITM_ADD2", CommonUtils.nvl(addrD.get("invcItmAdd2")));
          taxInvoiceOutrightSub.put("INVC_ITM_ADD3", "");
          taxInvoiceOutrightSub.put("INVC_ITM_POST_CODE", CommonUtils.nvl(addrD.get("invcItmPostCode")));
          taxInvoiceOutrightSub.put("INVC_ITM_STATE_NAME", CommonUtils.nvl(addrD.get("invcItmStateName")));
          taxInvoiceOutrightSub.put("INVC_ITM_CNTY", CommonUtils.nvl(addrD.get("invcItmCnty")));
          taxInvoiceOutrightSub.put("AREA_ID", CommonUtils.nvl(params.get("hidInstallation_AreaID")));
          taxInvoiceOutrightSub.put("ADDR_DTL", CommonUtils.nvl(params.get("hidInstallation_AddDtl")));
          taxInvoiceOutrightSub.put("STREET", "");

          logger.debug("===============================TAX INVOICE OUTRIGHT SUB - 1412========================================");
          logger.debug("Prepared taxInvoiceOutrightSub: ", taxInvoiceOutrightSub);
          logger.debug("===============================TAX INVOICE OUTRIGHT SUB - 1412========================================");

        } else {
          taxInvoiceOutrightSub.put("TAX_INVC_ID", TAX_INVC_ID);
          taxInvoiceOutrightSub.put("INVC_ITM_ORD_NO", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
          taxInvoiceOutrightSub.put("INVC_ITM_PO_NO", "");
          taxInvoiceOutrightSub.put("INVC_ITM_GST_RATE", filter_TAXRATE);

          if (filter_TAXRATE > 0) {
            taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", Double.toString(outrightBalance - (outrightBalance * 100 / 106)));
            taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE", outrightBalance * 100 / 106);
          } else {
            taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", "0");
            // taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE",
            // outrightSubBalance);
            taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE", outrightBalance);
          }

          double a = (outrightBalance - (outrightBalance * 100 / 106));
          double b = (outrightBalance * 100 / 106);
          taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE", Double.toString(a + b));

          // taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE",outrightSubBalance);
          taxInvoiceOutrightSub.put("INVC_ITM_FEES_AMT_DUE", "0");
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_CTGRY", CommonUtils.nvl(custInfoMap.get("codeDesc")));
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_MODEL", CommonUtils.nvl(custInfoMap.get("stkDesc")));
          taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_SERIAL_NO", CommonUtils.nvl((params.get("hidSerialNo"))));

          // SET ADDRESS
          taxInvoiceOutrightSub.put("INVC_ITM_ADD1", CommonUtils.nvl(addrD.get("invcItmAdd1")));
          taxInvoiceOutrightSub.put("INVC_ITM_ADD2", CommonUtils.nvl(addrD.get("invcItmAdd2")));
          taxInvoiceOutrightSub.put("INVC_ITM_ADD3", "");
          taxInvoiceOutrightSub.put("INVC_ITM_POST_CODE", CommonUtils.nvl(addrD.get("invcItmPostCode")));
          taxInvoiceOutrightSub.put("INVC_ITM_STATE_NAME", CommonUtils.nvl(addrD.get("invcItmStateName")));
          taxInvoiceOutrightSub.put("INVC_ITM_CNTY", CommonUtils.nvl(addrD.get("invcItmCnty")));
          taxInvoiceOutrightSub.put("AREA_ID", CommonUtils.nvl(params.get("hidInstallation_AreaID")));
          taxInvoiceOutrightSub.put("ADDR_DTL", CommonUtils.nvl(params.get("hidInstallation_AddDtl")));
          taxInvoiceOutrightSub.put("STREET", "");

          logger.debug("===============================TAX INVOICE OUTRIGHT SUB - 67/68========================================");
          logger.debug("Prepared taxInvoiceOutrightSub: ", taxInvoiceOutrightSub);
          logger.debug("===============================TAX INVOICE OUTRIGHT SUB - 67/68========================================");
        }

        AccTradeLedger.put("TRADE_RUN_ID", 0);
        AccTradeLedger.put("TRADE_ID", 0);
        AccTradeLedger.put("TRADE_SO_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
        AccTradeLedger.put("TRADE_DOC_NO", invoiceNo); // params.get("hidTradeLedger_InstallNo"));
        AccTradeLedger.put("TRADE_DOC_TYPE_ID", 164);
        AccTradeLedger.put("TRADE_DT_TM", CommonUtils.getNowDate());
        AccTradeLedger.put("TRADE_AMT", outrightBalance);
        AccTradeLedger.put("TRADE_BATCH_NO", "");
        AccTradeLedger.put("TRADE_INST_NO", 0);
        AccTradeLedger.put("TRADE_UPD_USER_ID", sessionVO.getUserId());
        AccTradeLedger.put("TRADE_UPD_DT", CommonUtils.getNowDate());
        AccTradeLedger.put("TRADE_IS_SYNC", 0);
        AccTradeLedger.put("R01", 0);

        logger.debug("===============================TAX INVOICE OUTRIGHT SUB - 67/68========================================");
        logger.debug("AccTradeLedger: ", AccTradeLedger);
        logger.debug("===============================TAX INVOICE OUTRIGHT SUB - 67/68========================================");

        AccOrderBill.put("ACC_BILL_ID", 0);
        AccOrderBill.put("ACC_BILL_TASK_ID", 0);
        AccOrderBill.put("ACC_BILL_REF_DT", CommonUtils.getNowDate());
        AccOrderBill.put("ACC_BILL_REF_NO", "1000");
        AccOrderBill.put("ACC_BILL_ORD_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
        AccOrderBill.put("ACC_BILL_ORD_NO", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")).toString());
        AccOrderBill.put("ACC_BILL_TYPE_ID", 1159);
        AccOrderBill.put("ACC_BILL_MODE_ID", 1164);
        AccOrderBill.put("ACC_BILL_SCHDUL_ID", 0);
        AccOrderBill.put("ACC_BILL_SCHDUL_PRIOD", 0);
        AccOrderBill.put("ACC_BILL_ADJ_ID", 0);
        AccOrderBill.put("ACC_BILL_SCHDUL_AMT", outrightBalance);
        AccOrderBill.put("ACC_BILL_ADJ_AMT", 0);
        AccOrderBill.put("ACC_BILL_NET_AMT", outrightBalance);
        AccOrderBill.put("ACC_BILL_STUS", 1);

        if (null != params.get("hidTradeLedger_InstallNo")) {
          AccOrderBill.put("ACC_BILL_REM", invoiceNo);
        } else {
          AccOrderBill.put("ACC_BILL_REM", " ");
        }

        AccOrderBill.put("ACC_BILL_CRT_DT", CommonUtils.getNowDate());
        AccOrderBill.put("ACC_BILL_CRT_USER_ID", sessionVO.getUserId());
        AccOrderBill.put("ACC_BILL_GRP_ID", 0);
        AccOrderBill.put("ACC_BILL_TAX_CODE_ID", filter_TAXCODE);
        AccOrderBill.put("ACC_BILL_TAX_RATE", filter_TAXRATE);

        if (filter_TAXRATE == 6) {
          AccOrderBill.put("ACC_BILL_TXS_AMT", Double.toString(outrightBalance - (outrightBalance * 100 / 106)));
        } else {
          AccOrderBill.put("ACC_BILL_TXS_AMT", 0);
        }

        AccOrderBill.put("ACC_BILL_ACCT_CNVR", 0);
        AccOrderBill.put("ACC_BILL_CNTRCT_ID", 0);

        logger.debug("===============================PAY0016D - OVERALL FINANCE BILLING TRANSACTION RECORDS.========================================");
        logger.debug("AccOrderBill: ", AccOrderBill);
        logger.debug("===============================PAY0016D - OVERALL FINANCE BILLING TRANSACTION RECORDS.========================================");
      }
    }

    if (params.get("installStatus").toString().equals("21")) { // STATUS FAIL
      callEntry.put("callEntryId", 0);
      callEntry.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
      callEntry.put("typeId", Integer.parseInt(params.get("hidCallType").toString()));
      callEntry.put("statusCodeId", 19);
      callEntry.put("resultId", 0);
      callEntry.put("docId", CommonUtils.nvl(params.get("hidDocId")));
      callEntry.put("creator", sessionVO.getUserId());
      callEntry.put("created", new Date());
      callEntry.put("callDate", nextDateCall);
      callEntry.put("isWaitForCancel", false);
      callEntry.put("happyCallerId", 0);
      callEntry.put("updated", new Date());
      callEntry.put("updator", sessionVO.getUserId());
      callEntry.put("oriCallDate", nextDateCall);

      logger.debug("===============================CCR0006D - CALL ENTRY MASTER.========================================");
      logger.debug("callEntry : {}", callEntry);
      logger.debug("===============================CCR0006D - CALL ENTRY MASTER.========================================");
      // installationResultListMapper.insertCallEntry(callEntry);

      callResult.put("callResultId", 0);
      callResult.put("callEntryId", 0);
      callResult.put("callStatusId", 19);
      callResult.put("callCallDate", nextDateCall);
      callResult.put("callActionDate", "01/01/1900");
      callResult.put("callFeedBackId", 0);
      callResult.put("callCTID", 0);
      callResult.put("callRemark", installResult.get("remark"));
      callResult.put("callCreateBy", sessionVO.getUserId());
      callResult.put("callCreateAt", new Date());
      callResult.put("callCreateByDept", 0);
      callResult.put("callHCID", 0);
      callResult.put("callROSAmt", 0);
      callResult.put("callSMS", false);
      callResult.put("callSMSRemark", "");

      logger.debug("===============================CCR0007D - CALL ENTRY RESULT.========================================");
      logger.debug("callResultJInmu : {}", callResult);
      logger.debug("===============================CCR0007D - CALL ENTRY RESULT.========================================");
      // installationResultListMapper.insertCallResult(callResult);
      // callEntry.put("resultId", "위에 쿼리 시퀀스");
      // installationResultListMapper.updateCallEntry(callEntry);

      orderLog.put("LogID", 0);
      orderLog.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
      orderLog.put("progressId", Integer.parseInt(params.get("hidCallType").toString()) == 257 ? 2 : 3);
      orderLog.put("logDate", new Date());
      orderLog.put("refId", 0);
      orderLog.put("isLock", 0);
      orderLog.put("logCreator", sessionVO.getUserId());
      orderLog.put("logCreated", new Date());

      logger.debug("===============================ORDER LOG.========================================");
      logger.debug("orderLog : {}", orderLog);
      logger.debug("===============================ORDER LOG.========================================");
      // installationResultListMapper.insertOrderLog(orderLog);

      resultValue.put("value", "Fail");
    } else if (Integer.parseInt(CommonUtils.nvl(params.get("installStatus")).toString()) == 4) {
      resultValue.put("value", "Completed");

      orderLog.put("LogID", 0);
      orderLog.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
      orderLog.put("progressId", 5);
      orderLog.put("logDate", new Date());
      orderLog.put("refId", 0);
      orderLog.put("isLock", 0);
      orderLog.put("logCreator", sessionVO.getUserId());
      orderLog.put("logCreated", new Date());

      if (!CommonUtils.nvl(params.get("beforeProductSerialNo")).equals("")) { // TEMPORARY USING THIS COLUMN
        // INSERT FREE TRIAL MATTRESS CARE SERVICE - SVC0113D
        installationResultListMapper.insertSVC0113D(params);
      }
    }

    resultValue.put("installEntryNo", CommonUtils.nvl(params.get("hiddeninstallEntryNo")));

   /* logger.debug("========================INSTALLATION RESULT PARAM===========================");
    logger.debug("INSTALLATION PARAM1 : {}", params);
    logger.debug("INSTALLATION PARAM2 : {}", installResult);
    logger.debug("========================INSTALLATION RESULT PRM===========================");*/

    // START INSERT
    insertInstallation_2(statusId, ApptypeID, installResult, callEntry, callResult, orderLog, TaxinvoiceCompany,
        AccTradeLedger, AccOrderBill, taxInvoiceOutright, taxInvoiceOutrightSub, salesOrderM, isBillAvb);

    return resultValue;
  }

  @SuppressWarnings("unchecked")
private boolean insertInstallation(int statusId, String ApptypeID, Map<String, Object> installResult,
      Map<String, Object> callEntry, Map<String, Object> callResult, Map<String, Object> orderLog,
      Map<String, Object> TaxinvoiceCompany, Map<String, Object> AccTradeLedger, Map<String, Object> AccOrderBill,
      Map<String, Object> taxInvoiceOutright, Map<String, Object> taxInvoiceOutrightSub,
      Map<String, Object> salesOrderM, boolean isBillAvb) throws ParseException {

    // installEntry status가 1,21 이면 그 밑에 있는걸 ㅌ야된다(컴플릿이 되어도 다시 상태값 변경 가능하게 해야된다
    String maxId = ""; // 각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
    EgovMap maxIdValue = new EgovMap();
    installationResultListMapper.insertInstallResult(installResult);
    EgovMap entry = installationResultListMapper.selectEntry(installResult);
    logger.debug("entry : {}", entry);
    maxIdValue.put("value", "resultId");
    maxId = installationResultListMapper.selectMaxId(maxIdValue);
    logger.debug("maxId : {}", maxId);
    EgovMap maxtaxInvoiceID = new EgovMap();
    maxtaxInvoiceID.put("value", "taxInvoiceId");
    String maxTaxInvoiceID = installationResultListMapper.selectMaxId(maxtaxInvoiceID);
    // String ApptypeID = (String) TaxinvoiceCompany.get("ApptypeID");

    // update SalesM Status
    installationResultListMapper.updateSalesOrderMStatus(salesOrderM);

    if ("66".equals(ApptypeID) || "142".equals(ApptypeID) || "144".equals(ApptypeID)) {
      // Rental || Sponsor || Education

      if (installResult.get("statusCodeId").toString().equals("4")) {
        EgovMap s46dup = new EgovMap();
        s46dup.put("installResultId", maxId);
        s46dup.put("stusCodeId", installResult.get("statusCodeId"));
        s46dup.put("updated", installResult.get("created"));
        s46dup.put("updator", installResult.get("creator"));
        s46dup.put("installEntryId", installResult.get("entryId"));
        s46dup.put("installDate", installResult.get("installDate"));

        installationResultListMapper.updateInstallEntry(s46dup);

      }
    } else if ("67".equals(ApptypeID) || "68".equals(ApptypeID) || "1412".equals(ApptypeID)) { // api
                                                                                               // 추가
      // Outright || Instalment || Outright Plus

      if (isBillAvb) {
        if ("4".equals(installResult.get("statusCodeId").toString())) { // 2018-06-07
                                                                        // -
                                                                        // LaiKW
                                                                        // - Add
                                                                        // checking
                                                                        // to
                                                                        // bill
                                                                        // only
                                                                        // when
                                                                        // installation
                                                                        // status
                                                                        // is
                                                                        // complete
          // insert taxinvoiceRental
          // installationResultListMapper.insertTaxInvoiceCompany(TaxinvoiceCompany);

          // insert taxinvoiceOutright
          installationResultListMapper.insertTaxInvoiceOutright(taxInvoiceOutright);
          // insert taxinvoiceOutright_Sub
          installationResultListMapper.insertTaxInvoiceOutrightSub(taxInvoiceOutrightSub);
          // insert tradeLedger
          installationResultListMapper.insertAccTradeLedger(AccTradeLedger);
          // insert Accorderbill
          installationResultListMapper.insertAccorderBill(AccOrderBill);
        }
      }

      entry.put("installResultId", maxId);
      entry.put("stusCodeId", installResult.get("statusCodeId"));
      entry.put("updated", installResult.get("created"));
      entry.put("updator", installResult.get("creator"));
      entry.put("installDate", installResult.get("installDate"));
      installationResultListMapper.updateInstallEntry(entry);
    }

    // Complete
    if (installResult.get("statusCodeId").toString().equals("4")) {
      installationResultListMapper.insertOrderLog(orderLog);
      Map<String, Object> isExchange = new HashMap<>();
      isExchange = installationResultListMapper.checkExchangeCollLog(orderLog);
      if (isExchange != null) {
        installationResultListMapper.updateSal0004d(orderLog);
      }
      if ("66".equals(ApptypeID)) {
        installationResultListMapper.updateRentalStatus(orderLog);
      }
    }

    // Fail
    if (installResult.get("statusCodeId").toString().equals("21")) {
      if (callEntry != null) {
        installationResultListMapper.insertCallEntry(callEntry);
        // callEntry에 max 값 구해서 CallResult에 저장
        maxIdValue.put("value", "callEntryId");
        maxId = installationResultListMapper.selectMaxId(maxIdValue);
        callResult.put("callEntryId", maxId);
        installationResultListMapper.insertCallResult(callResult);
        // callresult에 max값 구해서 callEntry에 업데이트
        maxIdValue.put("value", "callResultId");
        maxId = installationResultListMapper.selectMaxId(maxIdValue);
        callEntry.put("resultId", maxId);
        maxIdValue.put("value", "resultId");
        maxId = installationResultListMapper.selectMaxId(maxIdValue);
        callEntry.put("callEntryId", maxId);
        installationResultListMapper.updateCallEntry(callEntry);

        Map<String, Object> m = new HashMap<String, Object>();
        m.put("installEntryId", CommonUtils.nvl(installResult.get("entryId")));
        m.put("stusCodeId", "21");
        m.put("creator", installResult.get("creator"));
        m.put("installResultId", maxId);
        installationResultListMapper.updateInstallEntry(m);

      }

      installationResultListMapper.insertOrderLog(orderLog);
    }

    ///////////////////////////////// happyCall////////////////////////////
    Map<String, Object> happyCall = new HashMap<String, Object>();
    // happyCall.put("HCID", 0);
    happyCall.put("HCSOID", salesOrderM.get("salesOrdId"));
    happyCall.put("HCCallEntryId", 0);
    happyCall.put("HCTypeNo", entry.get("installEntryNo"));
    happyCall.put("HCTypeId", 508);
    happyCall.put("HCStatusId", 33);
    happyCall.put("HCRemark", "");
    happyCall.put("HCCommentTypeId", 0);

    happyCall.put("HCCommentGId", 0);
    happyCall.put("HCCommentSId", 0);
    happyCall.put("HCCommentDId", 0);
    happyCall.put("creator", installResult.get("creator"));
    happyCall.put("created", new Date());
    happyCall.put("updator", installResult.get("creator"));
    happyCall.put("updated", new Date());
    happyCall.put("HCNoService", false);
    happyCall.put("HCLock", false);
    happyCall.put("HCCloseId", 0);
    logger.debug("happyCall : {}", happyCall);
    installationResultListMapper.insertHappyCall(happyCall);
    ///////////////////////////////// happyCall////////////////////////////

    return true;
  }

  private boolean insertInstallation_2(int statusId, String ApptypeID, Map<String, Object> installResult,
      Map<String, Object> callEntry, Map<String, Object> callResult, Map<String, Object> orderLog,
      Map<String, Object> TaxinvoiceCompany, Map<String, Object> AccTradeLedger, Map<String, Object> AccOrderBill,
      Map<String, Object> taxInvoiceOutright, Map<String, Object> taxInvoiceOutrightSub,
      Map<String, Object> salesOrderM, boolean isBillAvb) throws ParseException {

    String maxId = "";
    EgovMap maxIdValue = new EgovMap();
    logger.debug("===========================CHKSMS111================================");
    // INSERT SAL0047D RESULT
    installationResultListMapper.insertInstallResult(installResult);

    logger.debug("===========================CHKSMS222================================");
    EgovMap entry = installationResultListMapper.selectEntry_2(installResult);
    logger.debug("===========================INSTALLATION ENTRY================================");
    logger.debug("INSTALLATION ENTRY : {}", entry);
    logger.debug("INSTALLATION RESULT111 : {}", installResult);
    logger.debug("===========================INSTALLATION ENTRY================================");

    maxIdValue.put("value", "resultId");
    maxIdValue.put("salesOrderId", installResult.get("salesOrdId"));
    maxId = installationResultListMapper.selectMaxId_2(maxIdValue);

    logger.debug("maxId : {}", maxId);

    EgovMap maxtaxInvoiceID = new EgovMap();
    maxtaxInvoiceID.put("value", "taxInvoiceId");
    String maxTaxInvoiceID = installationResultListMapper.selectMaxId_2(maxtaxInvoiceID);
    // String ApptypeID = (String) TaxinvoiceCompany.get("ApptypeID");
//    String chkSMS = "";
//    String checkSend = "";
//
//    if(installResult.get("chkSMS").equals("on") || installResult.get("chkSMS").equals("Y")){
//    	chkSMS = "Y";
//    }
//    else{
//    	chkSMS = "N";
//    }
//
//    if(installResult.get("checkSend").equals("on") || installResult.get("checkSend").equals("Y")){
//    	checkSend = "Y";
//    }
//    else{
//    	checkSend = "N";
//    }
//    installResult.put("chkSMS", chkSMS);
//    installResult.put("checkSend", checkSend);

    // Rental || Sponsor || Education || AUX
    if ("66".equals(ApptypeID) || "142".equals(ApptypeID) || "144".equals(ApptypeID) || "5764".equals(ApptypeID) || "145".equals(ApptypeID)) { //add on Free Trial
      if (installResult.get("statusCodeId").toString().equals("4")) {
        EgovMap s46dup = new EgovMap();
        s46dup.put("installResultId", maxId);
        s46dup.put("stusCodeId", installResult.get("statusCodeId"));
        s46dup.put("updated", installResult.get("created"));
        s46dup.put("updator", installResult.get("creator"));
        s46dup.put("installEntryId", installResult.get("entryId"));
        s46dup.put("installDate", installResult.get("installDate"));
        s46dup.put("salesOrdId", installResult.get("salesOrdId"));
        s46dup.put("creator", installResult.get("creator"));

        s46dup.put("ownerCode", installResult.get("ownerCode"));
        s46dup.put("resultCustName", installResult.get("resultCustName"));
        s46dup.put("resultIcMobileNo", installResult.get("resultIcMobileNo"));
        s46dup.put("resultReportEmailNo", installResult.get("resultReportEmailNo"));
        s46dup.put("resultAcceptanceName", installResult.get("resultAcceptanceName"));
//        s46dup.put("chkSMS", chkSMS);
//        s46dup.put("custMobileNo", installResult.get("custMobileNo"));
//        s46dup.put("checkSend", checkSend);
        // UPDATE SAL0046D
        installationResultListMapper.updateInstallEntry_2(s46dup);
      }
    } else if ("67".equals(ApptypeID) || "68".equals(ApptypeID) || "1412".equals(ApptypeID)) { // Outright
                                                                                               // ||
                                                                                               // Instalment
                                                                                               // ||
                                                                                               // Outright
                                                                                               // Plus
      if (isBillAvb) {
        if ("4".equals(installResult.get("statusCodeId").toString())) {
          // 2018-06-07 - LaiKW - ADD CHECKING TO BILL ONLY WHEN INSTALLATION
          // STATUS IS COMPLETE
          // INSERT taxinvoiceRental
          // installationResultListMapper.insertTaxInvoiceCompany(TaxinvoiceCompany);

          // INSERT taxinvoiceOutright - PAY0033D
          installationResultListMapper.insertTaxInvoiceOutright(taxInvoiceOutright);
          // INSERT taxinvoiceOutright_Sub - PAY0034D
          installationResultListMapper.insertTaxInvoiceOutrightSub(taxInvoiceOutrightSub);
          // INSERT tradeLedger - PAY0035D
          installationResultListMapper.insertAccTradeLedger(AccTradeLedger);
          // INSERT Accorderbill - PAY0016D
          installationResultListMapper.insertAccorderBill(AccOrderBill);
        }
      }

      entry.put("installResultId", maxId);
      entry.put("stusCodeId", installResult.get("statusCodeId"));
      entry.put("updated", installResult.get("created"));
      entry.put("updator", installResult.get("creator"));
      entry.put("installDate", installResult.get("installDate"));
      entry.put("salesOrdId", installResult.get("salesOrdId"));
      entry.put("creator", installResult.get("creator"));

      entry.put("ownerCode", installResult.get("ownerCode"));
      entry.put("resultCustName", installResult.get("resultCustName"));
      entry.put("resultIcMobileNo", installResult.get("resultIcMobileNo"));
      entry.put("resultReportEmailNo", installResult.get("resultReportEmailNo"));
      entry.put("resultAcceptanceName", installResult.get("resultAcceptanceName"));

//      entry.put("chkSMS", chkSMS);
//      entry.put("custMobileNo", installResult.get("custMobileNo"));
//      entry.put("checkSend", checkSend);
      // UPDATE SAL0046D
      installationResultListMapper.updateInstallEntry_2(entry);
    }

    if (installResult.get("statusCodeId").toString().equals("4")) { // COMPLETE
      // UPDTE SALES MASTER STATUS - STATUS CODE
      installationResultListMapper.updateSalesOrderMStatus(salesOrderM);

      // INSERT SAL0009D
      installationResultListMapper.insertOrderLog(orderLog);

      Map<String, Object> isExchange = new HashMap<>();
      isExchange = installationResultListMapper.checkExchangeCollLog_2(orderLog);
      if (isExchange != null) {
        // UPDATE EXCHANGE STATUS
        isExchange.put("logCreator", orderLog.get("logCreator"));
        isExchange.put("salesOrderId", orderLog.get("salesOrderId"));
        installationResultListMapper.updateSal0004d_2(isExchange);
        // installationResultListMapper.updateLog0038d_2(isExchange);

        //UPDATE SVC0125D IF INSTALLATION COMPLETE
        EgovMap svc0125DStus = new EgovMap();
        svc0125DStus.put("installEntryId", installResult.get("entryId"));
        svc0125DStus.put("testResultStus", SalesConstants.STATUS_ACTIVE);
        svc0125DStus.put("updator", installResult.get("creator"));
        //Object so_id = orderLog.get("salesOrderId");
        svc0125DStus.put("salesOrderId", orderLog.get("salesOrderId"));//installationResultListMapper.checkOrderID(orderLog));
        installationResultListMapper.updatePEXTestResultStatus(svc0125DStus);
        logger.debug("updateSVC0125DStatus : /////", svc0125DStus);

        // INSERT LOG0038D RESULT
        installResult.put("salesOrderId", orderLog.get("salesOrderId"));
        installationResultListMapper.insertExchangeResult(installResult);

        EgovMap l38dup = new EgovMap();
        l38dup.put("stusCodeId", installResult.get("statusCodeId"));
        l38dup.put("callEntryId", entry.get("callEntryId"));
        l38dup.put("ctId", entry.get("ctId"));
        l38dup.put("updated", installResult.get("created"));
        l38dup.put("updator", installResult.get("creator"));
        l38dup.put("installEntryId", installResult.get("entryId"));
        l38dup.put("installDate", installResult.get("installDate"));
        l38dup.put("salesOrdId", installResult.get("salesOrdId"));
        l38dup.put("creator", installResult.get("creator"));
        installationResultListMapper.updateExchangeEntry_2(l38dup);

        Map<String, Object> exchgInfo = new HashMap<>();
        exchgInfo = installationResultListMapper.getExchangeInfo(isExchange);

        if (exchgInfo != null) {
          logger.debug("===========================EXCHANGE INFO================================");
          logger.debug("EXCHANGE INFO : {}", exchgInfo);
          logger.debug("===========================EXCHANGE INFO================================");
          installationResultListMapper.updateOrderInfoExchgM(exchgInfo);
          installationResultListMapper.updateOrderInfoExchgS(exchgInfo);
        }
      }

      if ("66".equals(ApptypeID)) { // RENTAL
        installationResultListMapper.updateRentalStatus(orderLog); // IT WILL
                                                                   // UPDATE ALL
      }

    }

    if (installResult.get("statusCodeId").toString().equals("21")) { // FAIL
      if (callEntry != null) {
        // INSERT A NEW CALL LOG ENTRY CCR0006D
        installationResultListMapper.insertCallEntry(callEntry);

        maxIdValue.put("value", "callEntryId");
        maxIdValue.put("salesOrderId", callEntry.get("salesOrderId"));
        maxId = installationResultListMapper.selectMaxId_2(maxIdValue);
        callResult.put("callEntryId", maxId);
        // INSERT CALL RESULT CCR0007D
        installationResultListMapper.insertCallResult(callResult);

        maxIdValue.put("value", "callResultId");
        maxIdValue.put("salesOrderId", callEntry.get("salesOrderId"));
        maxId = installationResultListMapper.selectMaxId_2(maxIdValue);
        callEntry.put("resultId", maxId);

        maxIdValue.put("value", "resultId");
        maxIdValue.put("salesOrderId", callEntry.get("salesOrderId"));
        maxId = installationResultListMapper.selectMaxId_2(maxIdValue);
        callEntry.put("callEntryId", maxId);
        callEntry.put("salesOrderId", callEntry.get("salesOrderId"));

        // UPDATE CCR0006D RESULT ID
        installationResultListMapper.updateCallEntry(callEntry);

        Map<String, Object> m = new HashMap<String, Object>();
        m.put("installEntryId", CommonUtils.nvl(installResult.get("entryId")));
        m.put("stusCodeId", "21");
        m.put("creator", installResult.get("creator"));
        m.put("installResultId", maxId);
        m.put("salesOrdId", installResult.get("salesOrdId"));
        m.put("installDate", installResult.get("installDate"));
//        m.put("chkSMS", chkSMS);
//        m.put("custMobileNo", installResult.get("custMobileNo"));
//        m.put("checkSend", checkSend);

        // UPDATE SAL0046D
        installationResultListMapper.updateInstallEntry_2(m);
      }

      // INSERT ORDER LOG SAL0009D
      installationResultListMapper.insertOrderLog(orderLog);
    }

    // START INSERT HAPPY CALL DATA
    Map<String, Object> happyCall = new HashMap<String, Object>();
    // happyCall.put("HCID", 0);
    happyCall.put("HCSOID", salesOrderM.get("salesOrdId"));
    happyCall.put("HCCallEntryId", 0);
    happyCall.put("HCTypeNo", entry.get("installEntryNo"));
    happyCall.put("HCTypeId", 508);
    happyCall.put("HCStatusId", 33);
    happyCall.put("HCRemark", "");
    happyCall.put("HCCommentTypeId", 0);

    happyCall.put("HCCommentGId", 0);
    happyCall.put("HCCommentSId", 0);
    happyCall.put("HCCommentDId", 0);
    happyCall.put("creator", installResult.get("creator"));
    happyCall.put("created", new Date());
    happyCall.put("updator", installResult.get("creator"));
    happyCall.put("updated", new Date());
    happyCall.put("HCNoService", false);
    happyCall.put("HCLock", false);
    happyCall.put("HCCloseId", 0);

    logger.debug("===========================HAPPY CALL PRM===============================");
    logger.debug("happyCall : {}", happyCall);
    logger.debug("===========================HAPPY CALL PRM===============================");

    // INSERT HAPPY CALL CCR0001D
    installationResultListMapper.insertHappyCall(happyCall);


    if (String.valueOf(installResult.get("smsMobileNo")).equals("") || String.valueOf(installResult.get("smsMobileNo")) == null || String.valueOf(installResult.get("smsMobileNo")).equals("null")) { // This is to capture resultIcMobileNo from Apps
    	installResult.put("smsMobileNo", String.valueOf(installResult.get("resultIcMobileNo")));
    }

    if (String.valueOf(installResult.get("ctCode")).equals("") || String.valueOf(installResult.get("ctCode")) == null || String.valueOf(installResult.get("ctCode")).equals("null")) { // This is to capture resultIcMobileNo from Apps
    	installResult.put("ctCode", String.valueOf(installResult.get("userId")));
    }

    logger.debug("================TEMP ALEX FOR DEV/LOCAL DEBUG - START ================");
    logger.debug("PARAMS111 :" + installResult.toString());
    //logger.debug("================chkSMS================" + chkSMS);
    logger.debug("================ApptypeID================" + ApptypeID);
    //logger.debug("================checkSend================" + checkSend);
    logger.debug("CHECKPOINT  - get resultIcMobileNo:" + installResult.get("resultIcMobileNo").toString());
    logger.debug("================TEMP YONG FOR DEV/LOCAL DEBUG - END ================");

    // IMPLEMENT SEND EMAIL FOR INST NOTE 31/12/2021
    //this.sendEmail();

    return true;
  }

  @Override
  public List<EgovMap> assignCtList(Map<String, Object> params) {
    return installationResultListMapper.assignCtList(params);
  }

  @Override
  public List<EgovMap> assignCtOrderList(Map<String, Object> params) {
    return installationResultListMapper.assignCtOrderList(params);
  }

  @Override
  public Map<String, Object> updateAssignCT(Map<String, Object> params) {
    List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
    List<String> successList = new ArrayList<String>();
    List<String> failList = new ArrayList<String>();

    Map<String, Object> resultValue = new HashMap<String, Object>();

    int rtnValue = 0;
    int successCnt = 0;
    int failCnt = 0;

    if (updateItemList.size() > 0) {
      logger.debug("=======================updateAssignCT - START===========================");
      for (int i = 0; i < updateItemList.size(); i++) {
        Map<String, Object> updateMap = updateItemList.get(i);

        logger.debug(" ITEM (" + i + ")" + updateMap.toString());

        String prevCt_db = installationResultListMapper.selectPrevAssignCt(updateMap);
        String prevCt_view = String.valueOf(updateMap.get("ctId"));
        String newCt = String.valueOf(updateMap.get("insstallCtId"));

        updateMap.put("updator", params.get("updator"));
        updateMap.put("newCt", newCt);
        updateMap.put("prevCt_view", prevCt_view);

        if (prevCt_db.equals(prevCt_view)) {
          if (newCt.equals(prevCt_view)) {
            failCnt++;
            failList.add(updateMap.get("installEntryNo").toString());
            logger.debug("FAIL TO TRANSFER DUE TO TRANSFER TO SAME PERSON  : " + newCt + " / " + prevCt_view);

            // INSERT INSTALLATION TRANSFER LOG
            updateMap.put("msg", "FAIL TO TRANSFER DUE TO TRANSFER TO SAME PERSON");
            servicesLogisticsPFCService.insertTransLog(updateMap);
          } else {
            // CHECK RCD_TMS
            int count = installationResultListMapper.checkRcdTms(updateMap);

            if (count == 1) { // MATCHED RECORD TIMESTAMP
              // UPDATE RCD_TMS
              servicesLogisticsPFCService.updRcdTms(updateMap);
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
              transProc.put("P_USER", updateMap.get("updator"));

              logger.debug("Transfer 물류 호출 PRAM ===> " + transProc.toString());
              servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_TRANS(transProc);
              procResult = transProc.get("p1").toString().substring(0, 3);
              logger.debug("Transfer 물류 호출 결과 ===> " + procResult);
              ///////////////////////// 물류 호출 END //////////////////////

              if (procResult.equals("000")) {
                rtnValue = installationResultListMapper.updateAssignCT(updateMap);
                successCnt += rtnValue;
                successList.add(updateMap.get("installEntryNo").toString());
              } else {
                failCnt++;
                failList.add(updateMap.get("installEntryNo").toString());

                updateMap.put("msg", "FAIL TO TRANSFER. PLEASE CHECK STOCK RELATED INFORMATION [" + procResult + "]");
                servicesLogisticsPFCService.insertTransLog(updateMap);
              }
            } else {
              failCnt++;
              failList.add(updateMap.get("installEntryNo").toString());
              logger.debug("FAIL TO TRANSFER DUE TO SELECTED ORDER TRANSFER BEFORE : ");

              // INSERT INSTALLATION TRANSFER LOG
              updateMap.put("msg", "FAIL TO TRANSFER DUE TO INSTALLATION HAD BEEN UPDATED BY OTHER USER");
              servicesLogisticsPFCService.insertTransLog(updateMap);
            }
          }
        } else {
          failCnt++;
          failList.add(updateMap.get("installEntryNo").toString());
          logger.debug("Fail Reason >> View & DB CT info not matching : " + prevCt_db + " / " + prevCt_view);

          updateMap.put("newCt", prevCt_view);
          updateMap.put("prevCt_view", prevCt_db);
          updateMap.put("msg", "FAIL TO TRANSFER DUE TO SELECTED JOB CT NOT SAME WITH ACTUAL JOB CT");
          servicesLogisticsPFCService.insertTransLog(updateMap);
        }
      }
      logger.debug("=======================updateAssignCT - END===========================");
    }
    resultValue.put("successCnt", successCnt);
    resultValue.put("successList", successList);
    resultValue.put("failCnt", failCnt);
    resultValue.put("failList", failList);

    logger.debug("resultValue : {}", resultValue);
    return resultValue;
  }

  // @Override
  public List<EgovMap> selectInstallationNoteListing(Map<String, Object> params) throws ParseException {

    return installationResultListMapper.selectInstallationNoteListing(params);
  }

  @Override
  public EgovMap selectInstallInfo(Map<String, Object> params) {
    return installationResultListMapper.selectInstallInfo(params);
  }

  @Override
  public int editInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
    String allowCom = String.valueOf(params.get("allwcom"));
    String istrade = String.valueOf(params.get("trade"));
    String isreqsms = String.valueOf(params.get("reqsms"));
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

    int resultValue = installationResultListMapper.updateInstallResultEdit(params);
    installationResultListMapper.updateInstallEntryEdit(params);

    List<String> installAccList = (List<String>) params.get("installAccList");
    params.put("installEntryId", params.get("entryId"));
    EgovMap installResult = getInstallResultByInstallEntryID(params);
    // disable old installation accessories
    installationResultListMapper.disbleInstallAccWithInstallEntryId(params);

    if (params.get("chkInstallAcc") != null && (params.get("chkInstallAcc").toString().equals("on") || params.get("chkInstallAcc").toString().equals("Y"))){
      try {
        insertInstallationAccessories(installAccList,installResult,sessionVO.getUserId());
      } catch (Exception e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }

    return resultValue;
  }

  public int updateInstallFileKey(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
	    String allowCom = String.valueOf(params.get("allwcom"));
	    String istrade = String.valueOf(params.get("trade"));
	    String isreqsms = String.valueOf(params.get("reqsms"));
	    String resultId = String.valueOf(params.get("resultId"));
	    String fileGroupKey = String.valueOf(params.get("fileGroupKey"));
	    String StkId = String.valueOf(params.get("StkId"));
	    String SalesOrderId = String.valueOf(params.get("SalesOrderId"));

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
  	 //   installationResultListMapper.updateInstallEntryEdit(params);

  	    return resultValue;
	  }

  @Override
  public int failInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
    String allowCom = String.valueOf(params.get("allwcom"));
    String istrade = String.valueOf(params.get("trade"));
    String isreqsms = String.valueOf(params.get("reqsms"));
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

    int resultValue = installationResultListMapper.updateInstallResultFail(params);
    installationResultListMapper.updateInstallEntryEdit(params);

    return resultValue;
  }

  @Override
  public int isInstallAlreadyResult(Map<String, Object> params) {
    return installationResultListMapper.isInstallAlreadyResult(params);
  }

  @Override
  public EgovMap validationInstallationResult(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return installationResultListMapper.validationInstallationResult(params);
  }

  @Override
  public EgovMap getLocInfo(Map<String, Object> params) {
    return installationResultListMapper.getLocInfo(params);
  }

  @Override
  public EgovMap getInstallationResultInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return installationResultListMapper.getInstallationResultInfo(params);
  }

  @Override
  public List<EgovMap> viewInstallationResult(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return installationResultListMapper.viewInstallationResult(params);
  }

  @Override
  public EgovMap checkMonthInstallDate(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return installationResultListMapper.getCheckMonthInstallDt(params);
  }

  @Override
  public List<EgovMap> getProductList(Map<String, Object> params) {
    // TODO ProductCodeList 호출시 error남
    return installationResultListMapper.getProductList(params);
  }

  @Override
  public List<EgovMap> getProductList2(Map<String, Object> params) {
    // TODO ProductCodeList 호출시 error남
    return installationResultListMapper.getProductList2(params);
  }

  @Override
  public int chkRcdTms(Map<String, Object> params) {
    return installationResultListMapper.chkRcdTms(params);
  }

  @Override
  public int selRcdTms(Map<String, Object> params) {
    return installationResultListMapper.selRcdTms(params);
  }

  @Override
  public String getSalStat(Map<String, Object> params) {
    return installationResultListMapper.getSalStat(params);
  }

  @Override
  public int chkExgRsnCde(Map<String, Object> params) {
    return installationResultListMapper.chkExgRsnCde(params);
  }

  @Override
  public List<EgovMap> selectCtSerialNoList(Map<String, Object> params) {
    return installationResultListMapper.selectCtSerialNoList(params);
  }

  public List<EgovMap> selectFailChild(Map<String, Object> params) {
    return installationResultListMapper.selectFailChild(params);
  }

  @Override
  public ReturnMessage insertInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO)
      throws ParseException {
    Map<String, Object> resultValue = new HashMap<String, Object>();
    ReturnMessage message = new ReturnMessage();

    if (sessionVO != null) {

    	List<Map<String, Object>> addList = (List<Map<String, Object>>) params.get("add");
    	List<String> installAccList = (List<String>) params.get("installAccList");
    	Map<String, Object> param = (Map<String, Object>)params.get("installForm");

      int noRcd = chkRcdTms(param);

      if (noRcd == 1) {
        EgovMap installResult = getInstallResultByInstallEntryID(param);
        logger.debug("INSTALLATION RESULT : {}" + installResult);

        param.put("EXC_CT_ID", installResult.get("ctId"));

        Map<String, Object> locInfoEntry = new HashMap<String, Object>();
        locInfoEntry.put("CT_CODE", installResult.get("ctMemCode"));
        locInfoEntry.put("STK_CODE", installResult.get("installStkId"));

        logger.debug("LOC. INFO. ENTRY : {}" + locInfoEntry);

        EgovMap locInfo = (EgovMap) servicesLogisticsPFCService.getFN_GET_SVC_AVAILABLE_INVENTORY(locInfoEntry);

        logger.debug("LOC. INFO. : {}" + locInfo);

        if (locInfo == null) {
          message.setCode("99");
          message.setMessage("Fail to update result. [lack of stock]");
        } else {
          if (Integer.parseInt(locInfo.get("availQty").toString()) < 1) {
            message.setCode("99");
            message.setMessage("Fail to update result. [lack of stock]");
          } else {
            EgovMap validMap = validationInstallationResult(param);
            int resultCnt = ((BigDecimal) validMap.get("resultCnt")).intValue();

            if (resultCnt > 0) {
              message.setMessage("Record already exist. Please refer ResultID : " + validMap.get("resultId") + ".");
            } else {
              // RUN SP AND WAIT FOR RESULT BEFORE INSERT AND UPDATE
              resultValue = runInstSp(param, sessionVO, "1");
            }

            if (null != resultValue) {
              HashMap<String, Object> spMap = (HashMap<String, Object>) resultValue.get("spMap");
              logger.debug("spMap :" + spMap.toString());
              if (!"000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))
                  && !"741".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) { // FAIL
                resultValue.put("logerr", "Y");
                message.setCode("99");
                message.setMessage("Error Encounter. Please Contact Administrator. Error Code(INS1): "
                    + spMap.get("P_RESULT_MSG").toString());
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
                String ordStat = getSalStat(param);

                if (!"1".equals(ordStat)) {
                  if (param.get("hidCallType").equals("258")) {
                    int exgCode = chkExgRsnCde(param);
                    // SKIP SOEXC009 - EXCHANGE (WITHOUT RETURN)
                    if (exgCode == 0) { // PEX EXCHANGE CODE NOT IN THE LIST
                      if (Integer.parseInt(param.get("installStatus").toString()) == 4) {
                        // RUN SP AND WAIT FOR RESULT BEFORE INSERT AND UPDATE
                        resultValue = runInstSp(param, sessionVO, "2");

                        if (null != resultValue) {
                          spMap = (HashMap<String, Object>) resultValue.get("spMap");
                          logger.debug("spMap :" + spMap.toString());
                          if (!"000".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))
                              && !"".equals(CommonUtils.nvl(spMap.get("P_RESULT_MSG")))) { // FAIL
                            resultValue.put("logerr", "Y");
                            message.setCode("99");
                            message.setMessage("Error Encounter. Please Contact Administrator. Error Code(INS2): "
                                + spMap.get("P_RESULT_MSG").toString());
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
                param.put("fileGroupKey", params.get("fileGroupKey"));

                resultValue = Save_2(true, param, sessionVO);

                // Added for inserting charge out filters and spare parts at AS. By Hui Ding, 06-04-2021
                if (resultValue.get("value") != null && resultValue.get("value").equals("Completed")){

              	  if (param.get("chkCrtAS") != null && (param.get("chkCrtAS").toString().equals("on") || param.get("chkCrtAS").toString().equals("Y"))){
              		  saveInsAsEntry(addList, param, installResult, sessionVO.getUserId());
              	  }

              	  if (param.get("chkInstallAcc") != null && (param.get("chkInstallAcc").toString().equals("on") || param.get("chkInstallAcc").toString().equals("Y"))){
              	    try {
                      insertInstallationAccessories(installAccList,installResult,sessionVO.getUserId());
                    } catch (Exception e) {
                      // TODO Auto-generated catch block
                      e.printStackTrace();
                    }
              	  }

                }

                message.setCode("1");
                message.setData("Y");
                if (Integer.parseInt(param.get("installStatus").toString()) == 21) {
                  message.setMessage(
                      "Installation No. (" + resultValue.get("installEntryNo") + ") successfully updated to "
                          + resultValue.get("value") + ". Please proceed to Calllog function.");
                } else {
                  message.setMessage(resultValue.get("value") + " to " + resultValue.get("installEntryNo"));
                  message.setMessage("Installation No. (" + resultValue.get("installEntryNo")
                      + ") successfully updated to " + resultValue.get("value") + ".");
                }

                // KR-OHK Barcode Save Start
                if ("Y".equals(param.get("hidSerialRequireChkYn"))) {
                  Map<String, Object> setmap = new HashMap<String, Object>();
                  setmap.put("serialNo", param.get("serialNo"));
                  setmap.put("salesOrdId", param.get("hidSalesOrderId"));
                  setmap.put("reqstNo", param.get("hiddeninstallEntryNo"));
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
                }
                // KR-OHK Barcode Save Start
              }
            }
          }
        }
      } else {
        message.setMessage(
            "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
        message.setCode("99");
      }
    }
    return message;
  }

  @Override
  public int editInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
    String allowCom = String.valueOf(params.get("allwcom"));
    String istrade = String.valueOf(params.get("trade"));
    String isreqsms = String.valueOf(params.get("reqsms"));
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

    int resultValue = installationResultListMapper.updateInstallResultEdit(params);
    installationResultListMapper.updateInstallEntryEdit(params);

    // KR-OHK Barcode Save Start(serial change)
    if ("Y".equals(params.get("hidSerialRequireChkYn")) && !params.get("hidSerialNo").equals(params.get("serialNo"))) {
      Map<String, Object> setmap = new HashMap<String, Object>();
      setmap.put("serialNo", params.get("serialNo"));
      setmap.put("beforeSerialNo", params.get("hidSerialNo"));
      setmap.put("salesOrdId", params.get("hidSalesOrderId"));
      setmap.put("reqstNo", params.get("hidInstallEntryNo"));
      setmap.put("callGbn", "INSTALL_EDIT");
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
    }
    // KR-OHK Barcode Save Start

    return resultValue;
  }

  @Override
  public Map<String, Object> updateAssignCTSerial(Map<String, Object> params) {
    List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
    List<String> successList = new ArrayList<String>();
    List<String> failList = new ArrayList<String>();

    Map<String, Object> resultValue = new HashMap<String, Object>();

    int rtnValue = 0;
    int successCnt = 0;
    int failCnt = 0;

    if (updateItemList.size() > 0) {
      logger.debug("=======================updateAssignCTSerial - START===========================");
      for (int i = 0; i < updateItemList.size(); i++) {
        Map<String, Object> updateMap = updateItemList.get(i);

        logger.debug(" ITEM (" + i + ")" + updateMap.toString());

        String prevCt_db = installationResultListMapper.selectPrevAssignCt(updateMap);
        String prevCt_view = String.valueOf(updateMap.get("ctId"));
        String newCt = String.valueOf(updateMap.get("insstallCtId"));

        updateMap.put("updator", params.get("updator"));
        updateMap.put("newCt", newCt);
        updateMap.put("prevCt_view", prevCt_view);

        if (prevCt_db.equals(prevCt_view)) { // ACTUAL CT IS MATCHED WITH SELECTED JOB CT
          if (newCt.equals(prevCt_view)) {
            failCnt++;
            failList.add(updateMap.get("installEntryNo").toString());
            logger.debug("FAIL TO TRANSFER DUE TO TRANSFER TO SAME PERSON  : " + newCt + " / " + prevCt_view);

            // INSERT INSTALLATION TRANSFER LOG
            updateMap.put("msg", "FAIL TO TRANSFER DUE TO TRANSFER TO SAME PERSON");
            servicesLogisticsPFCService.insertTransLog(updateMap);
          } else {
            // CHECK RCD_TMS
            int count = installationResultListMapper.checkRcdTms(updateMap);

            if (count == 1) { // MATCHED RECORD TIMESTAMP
              // UPDATE RCD_TMS
              servicesLogisticsPFCService.updRcdTms(updateMap);

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
              transProc.put("P_USER", updateMap.get("updator")); //

              logger.debug("Transfer 물류 호출 PRAM ===> " + transProc.toString());

              if ("Y".equals(updateMap.get("serialChk")) && "Y".equals(updateMap.get("serialRequireChkYn"))) {

                String delvryGrCmpltYn = installationResultListMapper.selectDelvryGrCmpltYn(updateMap);

                if ("N".equals(delvryGrCmpltYn)) {
                  throw new ApplicationException(AppConstants.FAIL,
                      "NOT RECEIPT DATA [ INS Number ::" + updateMap.get("installEntryNo") + " ]");
                }

                servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_TRANS_SERIAL(transProc);
              } else {
                servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_TRANS(transProc);
              }

              logger.debug("Transfer 물류 호출 PRAM ===> " + transProc.toString());

              procResult = transProc.get("p1").toString().substring(0, 3);
              String procResultMsg = transProc.get("p1").toString().substring(4);

              logger.debug("Transfer 물류 호출 결과 ===> " + procResult + ":" + procResultMsg);
              ///////////////////////// 물류 호출 END //////////////////////

              if (!procResult.equals("000")) {
                throw new ApplicationException(AppConstants.FAIL, "ERROR Code::" + procResult + "<br />ERROR Msg::"
                    + procResultMsg + "<br />INS Number :: " + updateMap.get("installEntryNo"));
              }

              if (procResult.equals("000")) {
                updateMap.put("updator", params.get("updator"));
                rtnValue = installationResultListMapper.updateAssignCT(updateMap);
                successCnt += rtnValue;
                successList.add(updateMap.get("installEntryNo").toString());
              } else {
                failCnt++;
                failList.add(updateMap.get("installEntryNo").toString());
              }
            } else {
              failCnt++;
              failList.add(updateMap.get("installEntryNo").toString());
              logger.debug("FAIL TO TRANSFER DUE TO SELECTED ORDER TRANSFER BEFORE : ");

              // INSERT INSTALLATION TRANSFER LOG
              updateMap.put("msg", "FAIL TO TRANSFER DUE TO INSTALLATION HAD BEEN UPDATED BY OTHER USER");
              servicesLogisticsPFCService.insertTransLog(updateMap);
            }
          }
        } else {
          failCnt++;
          failList.add(updateMap.get("installEntryNo").toString());
          logger.debug("Fail Reason >> View & DB CT info not matching : " + prevCt_db + " / " + prevCt_view);

          updateMap.put("newCt", prevCt_view);
          updateMap.put("prevCt_view", prevCt_db);
          updateMap.put("msg", "FAIL TO TRANSFER DUE TO SELECTED JOB CT NOT SAME WITH ACTUAL JOB CT");
          servicesLogisticsPFCService.insertTransLog(updateMap);
        }
      }
      logger.debug("=======================updateAssignCTSerial===========================");
    }
    resultValue.put("successCnt", successCnt);
    resultValue.put("successList", successList);
    resultValue.put("failCnt", failCnt);
    resultValue.put("failList", failList);

    logger.debug("resultValue : {}", resultValue);
    return resultValue;
  }

  @Override
  public List<EgovMap> waterEnvironmentList(Map<String, Object> params) {
    List<EgovMap> waterEnvironmentList = null;
    logger.debug("params : {}", params);

    waterEnvironmentList = installationResultListMapper.waterEnvironmentList(params);

    return waterEnvironmentList;
  }

  @Override
  public List<EgovMap> getProductListwithCategory(Map<String, Object> params) {
    // TODO ProductCodeList 호출시 error남
    return installationResultListMapper.getProductListwithCategory(params);
  }


  /**
   * to create AS record for charge out filters and spare parts
   *
   * @Date Apr 7, 2021
   * @Author HQIT-HUIDING
   * @param params
   * @return
   */
  @Override
  public EgovMap saveInsAsEntry(List<Map<String, Object>> add, Map<String, Object> params, EgovMap installResult, int userId) {

	 logger.info("########## add : " + add.toString());

    Map<String, Object> svc0004dmap = new HashMap<String, Object>();

    String AS_NO = "";

    String defaultErrCode = "9001700"; // default as "General Request"
	String defaultErrDesc = "1"; // default as 'Add Pump During Installation"
	String defaultDefTypeId = "";
	String defaultDefId = "";
	String defaultDefDtlResnId = "";
	String defaultDefPrtId = "";
	String defaultSlutnResnId = "";

	Map<String, Object> defectParam = new HashMap<String, Object>();
	defectParam.put("errCd", defaultErrCode);
	defectParam.put("errDesc", defaultErrDesc);

	// get default defect code list for installation AS
	List<EgovMap> getAsDefectEntryList = asMgmtListService.getAsDefectEntry(defectParam);

	if (getAsDefectEntryList != null && getAsDefectEntryList.size() > 0){
		if (getAsDefectEntryList.get(0)  != null){
			defaultDefPrtId = getAsDefectEntryList.get(0).get("defectId").toString();
		}
		if (getAsDefectEntryList.get(1)  != null){
			defaultDefDtlResnId = getAsDefectEntryList.get(1).get("defectId").toString();
		}
		if (getAsDefectEntryList.get(2)  != null){
			defaultDefId = getAsDefectEntryList.get(2).get("defectId").toString();
		}
		if (getAsDefectEntryList.get(3)  != null){
			defaultDefTypeId = getAsDefectEntryList.get(3).get("defectId").toString();
		}
		if (getAsDefectEntryList.get(4)  != null){
			defaultSlutnResnId = getAsDefectEntryList.get(4).get("defectId").toString();
		}
	}

	svc0004dmap.put("AS_SO_ID", CommonUtils.nvl(installResult.get("salesOrdId")).toString());
	svc0004dmap.put("REF_REQUEST", CommonUtils.nvl(installResult.get("installEntryNo")).toString());
	svc0004dmap.put("AS_CT_ID", CommonUtils.nvl(installResult.get("ctId")).toString());
	svc0004dmap.put("AS_SETL_DT", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
	svc0004dmap.put("AS_SETL_TM", CommonUtils.getNowTime());
	svc0004dmap.put("AS_RESULT_STUS_ID", "4");
	svc0004dmap.put("AS_REN_COLCT_ID", 0);
	svc0004dmap.put("AS_CMMS", 0);
	svc0004dmap.put("AS_BRNCH_ID", CommonUtils.nvl(installResult.get("brnchId")).toString());
	svc0004dmap.put("AS_WH_ID", CommonUtils.nvl(installResult.get("whLocId")).toString());
	svc0004dmap.put("AS_RESULT_REM", CommonUtils.nvl(params.get("txtFilterRemark")).toString());

	svc0004dmap.put("AS_MALFUNC_ID", defaultErrCode);
	svc0004dmap.put("AS_MALFUNC_RESN_ID", defaultErrDesc);

	svc0004dmap.put("AS_DEFECT_TYPE_ID", defaultDefTypeId);
	svc0004dmap.put("AS_DEFECT_GRP_ID", 0);
	svc0004dmap.put("AS_DEFECT_ID", defaultDefId);
	svc0004dmap.put("AS_DEFECT_PART_GRP_ID", 0);
	svc0004dmap.put("AS_DEFECT_PART_ID", defaultDefPrtId);
	svc0004dmap.put("AS_DEFECT_DTL_RESN_ID", defaultDefDtlResnId);
	svc0004dmap.put("AS_SLUTN_RESN_ID", defaultSlutnResnId);

	svc0004dmap.put("AS_WORKMNSH", CommonUtils.nvl(params.get("txtLabourCharge")).toString());
	svc0004dmap.put("AS_FILTER_AMT", CommonUtils.nvl(params.get("txtFilterCharge")).toString());
	svc0004dmap.put("AS_ACSRS_AMT", 0);
	svc0004dmap.put("AS_TOT_AMT", CommonUtils.nvl(params.get("txtTotalCharge")).toString());
	svc0004dmap.put("AS_RESULT_IS_SYNCH", 0);
	svc0004dmap.put("AS_RCALL", 0);
	svc0004dmap.put("AS_RESULT_STOCK_USE", 0);
	svc0004dmap.put("AS_RESULT_TYPE_ID", 457); // default as AS result type
	svc0004dmap.put("AS_RESULT_IS_CURR", 1);

	svc0004dmap.put("AS_RESULT_MTCH_ID", 0);
	svc0004dmap.put("AS_ENTRY_POINT", 0);
	svc0004dmap.put("AS_WORKMNSH_TAX_CODE_ID", 0);
	svc0004dmap.put("AS_WORKMNSH_TXS", 0);
	svc0004dmap.put("AS_RESULT_MOBILE_ID", 0);

	svc0004dmap.put("APPNT_DT", CommonUtils.nvl(installResult.get("appntDt")).toString());
	svc0004dmap.put("APPNT_TM", CommonUtils.nvl(installResult.get("appntTm")).toString());
	svc0004dmap.put("AS_REQST_DT", CommonUtils.getFormattedString("dd/MM/yyyy"));
	svc0004dmap.put("AS_APPNT_DT", CommonUtils.nvl(installResult.get("appntDt")).toString());

	svc0004dmap.put("AS_MEM_ID", CommonUtils.nvl(installResult.get("ctId")).toString());
	svc0004dmap.put("AS_STUS_ID", 4); // default set to COMPLETE
	svc0004dmap.put("AS_TYPE_ID", 6302); // default set to INS AS type

	svc0004dmap.put("AS_RESULT_REM", "[AUTO] Add installation parts during installation");

    params.put("DOCNO", "17");
    EgovMap eMap = ASManagementListMapper.getASEntryDocNo(params);
    EgovMap seqMap = ASManagementListMapper.getASEntryId(params);

    AS_NO = String.valueOf(eMap.get("asno")).trim();

    params.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    params.put("AS_NO", String.valueOf(eMap.get("asno")).trim());
    svc0004dmap.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    svc0004dmap.put("AS_NO", String.valueOf(eMap.get("asno")).trim());

    // insert call log record
    /*EgovMap ccrSeqMap = ASManagementListMapper.getCCR0006D_CALL_ENTRY_ID_SEQ(params);
    params.put("AS_CALLLOG_ID", String.valueOf(ccrSeqMap.get("seq")).trim());
    svc0004dmap.put("AS_CALLLOG_ID", String.valueOf(ccrSeqMap.get("seq")).trim());

    int c6d = ASManagementListMapper.insertCCR0006D(asMgmtListService.setCCR000Data(svc0004dmap));
    int c7d = ASManagementListMapper.insertCCR0007D(asMgmtListService.setCCR000Data(svc0004dmap));*/

    //params.put("DOCNO", "21");
    //EgovMap eMap_result = ASManagementListMapper.getASEntryDocNo(params);
    //EgovMap seqMap_result = ASManagementListMapper.getResultASEntryId(params);
    //String AS_RESULT_ID = String.valueOf(seqMap_result.get("seq"));
    //String AS_RESULT_NO = String.valueOf(eMap_result.get("asno"));

    // 서비스 마스터
    int a = ASManagementListMapper.insertSVC0001D(svc0004dmap);

    //svc0004dmap.put("AS_RESULT_ID", AS_RESULT_ID);
    //svc0004dmap.put("AS_RESULT_NO", AS_RESULT_NO);
    svc0004dmap.put("AS_ENTRY_ID", String.valueOf(seqMap.get("seq")).trim());
    svc0004dmap.put("updator", userId);

    /// insert svc0004d
    //int c = asMgmtListService.insertInHouseSVC0004D(svc0004dmap);

    //List<EgovMap> addItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_ADD);
    //asMgmtListService.insertSVC0005D(add, AS_RESULT_ID, String.valueOf(sessionVO.getUserId()));

    ///////////////////////// 물류 호출//////////////////////
    /*Map<String, Object> logPram = new HashMap<String, Object>();
    logPram.put("ORD_ID", String.valueOf(eMap.get("asno")).trim());
    logPram.put("RETYPE", "COMPLET");
    logPram.put("P_TYPE", "OD03");
    logPram.put("P_PRGNM", "INSCOM_AS");
    logPram.put("USERID", String.valueOf(sessionVO.getUserId()));

    Map SRMap = new HashMap();
    logger.debug("InstallationResultListServiceImpl.as_insert  물류 차감  PRAM ===>" + logPram.toString());
    servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
    logger.debug("InstallationResultListServiceImpl.as_insert  물류 차감   결과 ===>" + logPram.toString());
    logPram.put("P_RESULT_TYPE", "AS");
    logPram.put("P_RESULT_MSG", logPram.get("p1"));
    ///////////////////////// 물류 호출 END //////////////////////

    EgovMap em = new EgovMap();
    em.put("AS_NO", String.valueOf(eMap.get("asno")).trim());
    em.put("AS_RESULT_NO", AS_RESULT_NO);
    em.put("SP_MAP", logPram);*/

    // call to insert AS_RESULT and charges
    params.put("asResultM", svc0004dmap);
    params.put("updator", userId);
    params.put("add", add);

    EgovMap em = asMgmtListService.asResult_insert(params);

    // insert Charge out filters only to SAL0289D -- Installation charge out filters
    try{
    	insertChgOutFilters(add, installResult, userId);
    } catch (Exception e){
    	e.printStackTrace();
    }


    return em;
  }

  /**
   * to retrieve INS AS exchangeable filter & spare part list
   *
   * @Date Apr 7, 2021
   * @Author HQIT-HUIDING
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> selectFilterSparePartList (Map<String, Object> params){
	  return installationResultListMapper.selectFilterSparePartList(params);
  }

  public void insertChgOutFilters (List<Map<String, Object>> addItemList, EgovMap installResult, int userId) throws Exception{

	  if (!addItemList.isEmpty()){
		  EgovMap param = null;
		  int seq = 1;

		  logger.info("### charge out filters: " + addItemList.toString());

		  installResult.put("entryId", installResult.get("installEntryId"));

		  EgovMap entry = installationResultListMapper.selectEntry_2(installResult);
		  logger.debug("###===========================INSTALLATION ENTRY================================");
	      logger.debug(" ### INSTALLATION ENTRY : {}", entry);
	      logger.debug("###===========================INSTALLATION ENTRY================================");

		//  if (!filterList.isEmpty()){
    	  for (int i = 0; i < addItemList.size(); i++){
    		  Map<String, Object> addItem = addItemList.get(i);
    		  logger.info("addItem.get(stockTypeId) : " + addItem.get("stockTypeId"));
    		  if (addItem.get("stockTypeId").toString().equals("62")){
    			  logger.info("### is filter ###");
    			  // insert into SAL0292D - INS Filter charge out list
    			  param = new EgovMap();
    			  param.put("insEntryId", entry.get("installEntryId"));
    			  param.put("insResultId", entry.get("installResultId"));
    			  param.put("seq", seq);
    			  param.put("type", 62); // default filter
    			  param.put("stkId", addItem.get("filterID"));
    			  param.put("qty", addItem.get("filterQty"));
    			  param.put("payMode", addItem.get("filterType"));
    			  param.put("crtUserId", userId);

    			  installationResultListMapper.insertFilterChargeOut(param);
    			  seq++;
    		  }
    		  else if(addItem.get("filterStockCode").toString().equals("113794") && addItem.get("stockTypeId").toString().equals("63")){
    			  logger.info("### is pre-filter's filter ###");
    			// insert into new table -  INS filter charge out filter
    			  param = new EgovMap();
    			  param.put("insEntryId", entry.get("installEntryId"));
    			  param.put("insResultId", entry.get("installResultId"));
    			  param.put("salesOrdId", entry.get("salesOrdId"));
    			  param.put("insNo", entry.get("installEntryNo"));
    			  param.put("seq", seq);
    			  param.put("type", 62); // default filter
    			  param.put("stkCode", "3118441");
    			  param.put("itmcode", "3118441");
    			  param.put("qty", addItem.get("filterQty"));
    			  param.put("payMode", addItem.get("filterType"));
    			  param.put("crtUserId", userId);

    			  EgovMap entry2 = stockMapper.selectStkCatType(param);

    			  param.put("stkId", entry2.get("stkid"));

    			  installationResultListMapper.insertPreFilterChargeOut(param);
    			  seq++;
    		  }
    	  }
	  }
  }

  public EgovMap selectStkCatType (Map<String, Object> params){
	  return stockMapper.selectStkCatType(params);
  }

  @Override
  public void sendSms(Map<String, Object> smsList){
	  logger.debug("====inSendSMS111=====" + smsList.toString());
	  logger.debug("====inSendSMS111=====" + smsList.get("userId"));
	  logger.debug("====inSendSMS111=====" + Integer.parseInt(smsList.get("userId").toString()));
    int userId = Integer.parseInt(smsList.get("userId").toString());
    SmsVO sms = new SmsVO(userId, 975);

    logger.debug("====inSendSMS111=====");

    sms.setMessage(smsList.get("smsMessage").toString());
    sms.setMobiles(smsList.get("smsMobileNo").toString());
    //send SMS
    logger.debug("smsmsg111===" + smsList.toString());

    SmsResult smsResult = adaptorService.sendSMS(sms);
  }


  /*@SuppressWarnings("unchecked")
  @Override
  public void sendEmail() {
    EmailVO email = new EmailVO();
    String emailTitle = paymentApiMapper.getEmailTitle(params);
    Map<String, Object> params = new HashMap<>();
    String emailTitle = "Hello World";

    Map<String, Object> additionalParams = (Map<String, Object>) paymentApiMapper.getEmailDetails(params);
    params.putAll(additionalParams);

 //   List<String> emailNo = new ArrayList<String>();

    List<String> emailNo = Arrays.asList("alex.lau@coway.com.my","jiahua.yong@coway.com.my","keyi.por@coway.com.my");

 if (!"".equals(CommonUtils.nvl(params.get("email1")))) {
      emailNo.add(CommonUtils.nvl(params.get("email1")));
    }

    if (!"".equals(CommonUtils.nvl(params.get("email2")))) {
      emailNo.add(CommonUtils.nvl(params.get("email2")));
    }

    String text = "";
    text += "Dear All,\r\n\r\n";
    text += "Hereby is Hello World";
    text +=  "Sincere Regards,\r\n";
    text +=  "IT Department";

    params.put(REPORT_FILE_NAME, "/services/mibile_email_test.rpt");// visualcut
    params.put(EMAIL_SUBJECT, "Daily Accumulated Key-In Sales Analysis Report (HP)");
    params.put(EMAIL_TO, emailNo);
    params.put(EMAIL_TEXT, email);
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    //params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
    //params.put("v_Param", " ");// parameter
    params.put(AppConstants.REPORT_DOWN_FILE_NAME,
        "HelloWorld" + CommonUtils.getNowDate() + ".pdf");

    try {
		this.view(null, null, params);
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

    logger.info("[END] HelloWorld...");


    email.setTo(emailNo);
    email.setHtml(false);
    email.setSubject(emailTitle);
    email.setHasInlineImage(false);
    email.setText(text);

    boolean isResult = false;

    isResult = adaptorService.sendEmail(email, false);
  }*/
  //////////////////////////////EMAIL TESTING FROM MOBILE API

  private void viewHandle(HttpServletRequest request, HttpServletResponse response, ViewType viewType,
	      ReportClientDocument clientDoc, CrystalReportViewer crystalReportViewer, Map<String, Object> params)
	      throws ReportSDKExceptionBase, IOException {

	    //Tested with switch case, apparently switch case unable to handle viewtype and return error 505 so use if/else
		if(viewType == ViewType.MAIL_PDF){
			  ReportUtils.sendMailMultiple(clientDoc, viewType, params);
		}
		else{
			throw new ApplicationException(AppConstants.FAIL, "wrong viewType....");
		}
	  }


  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private ReportBatchService reportBatchService;

  @Value("${report.datasource.driver-class-name}")
  private String reportDriverClass;

  @Value("${report.datasource.url}")
  private String reportUrl;

  @Value("${report.datasource.username}")
  private String reportUserName;

  @Value("${report.datasource.password}")
  private String reportPassword;

  @Value("${report.file.path}")
  private String reportFilePath;

  private void viewProcedure(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params) {
	  	Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_FILE_NAME)), messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_FILE_NAME }));
		Precondition.checkArgument(CommonUtils.isNotEmpty(params.get(REPORT_VIEW_TYPE)), messageAccessor.getMessage(MSG_NECESSARY, new Object[] { REPORT_VIEW_TYPE }));

	    SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.SSS", Locale.getDefault(Locale.Category.FORMAT));
	    String succYn = "E";
	    Calendar startTime = Calendar.getInstance();
	    Calendar endTime = null;

	    String prodName;
	    int maxLength = 0;
	    String msg = "Completed";

		String reportFile = (String) params.get(REPORT_FILE_NAME);
	    String reportName = reportFilePath + reportFile;
	    ViewType viewType = ViewType.valueOf((String) params.get(REPORT_VIEW_TYPE));

	    try {
	      ReportAppSession ra = new ReportAppSession();
	      ra.createService(REPORT_CLIENT_DOCUMENT);

	      ra.setReportAppServer(ReportClientDocument.inprocConnectionString);
	      ra.initialize();
	      ReportClientDocument clientDoc = new ReportClientDocument();
	      clientDoc.setReportAppServer(ra.getReportAppServer());
	      clientDoc.open(reportName, OpenReportOptions._openAsReadOnly);

	      clientDoc.getDatabaseController().logon(reportUserName, reportPassword);

	      prodName = clientDoc.getDatabaseController().getDatabase().getTables().size() > 0 ? clientDoc.getDatabaseController().getDatabase().getTables().get(0).getName() : null;

	      params.put("repProdName", prodName);

	      ParameterFieldController paramController = clientDoc.getDataDefController().getParameterFieldController();
	      Fields fields = clientDoc.getDataDefinition().getParameterFields();
	      ReportUtils.setReportParameter(params, paramController, fields);
	      {
	        this.viewHandle(request, response, viewType, clientDoc, ReportUtils.getCrystalReportViewer(clientDoc.getReportSource()), params);
	      }
	    } catch (Exception ex) {
	      logger.error(CommonUtils.printStackTraceToString(ex));
	      throw new ApplicationException(ex);
	    } finally {
	      endTime = Calendar.getInstance();
	      long tot = endTime.getTimeInMillis() - startTime.getTimeInMillis();
	      logger.info("resultInfo : succYn={}, {}={}, {}={}, time={}~{}, total={}"
	              , succYn
	              , REPORT_FILE_NAME, params.get(REPORT_FILE_NAME)
	              , REPORT_VIEW_TYPE, params.get(REPORT_VIEW_TYPE)
	              , fmt.format(startTime.getTime()), fmt.format(endTime.getTime())
	              , tot
	      );

	    }
	  }


  	@Override
	public Map<String, Object> installationSendSMS(String ApptypeID, Map<String, Object> installResult) {
  		Map<String, Object> smsResultValue = new HashMap<String, Object>();
		String smsMessage = "";
		smsResultValue.put("smsLogStat", "0");//if success

		logger.debug("================INSMS111================");
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
			 if((ApptypeID.equals("66") || ApptypeID.equals("67") || ApptypeID.equals("68")) //APPY_TYPE = RENTAL/OUTRIGHT/INSTALLMENT
			    		&& (CommonUtils.nvl(installResult.get("custType")).equals("Individual") || CommonUtils.nvl(installResult.get("customerType")).equals("964")))  //IF CUST_TYPE = INDIVIDUAL(WEB) || CUST_TYPE = 964 (MOBILE)
			    {
				 logger.debug("================INSMS================");

			    	if(installResult.get("installStatus").toString().equals("4")){ //COMPLETE

				        smsMessage = "COWAY: Order " + installResult.get("salesOrderNo").toString() + " , Pemasangan telah diselesaikan oleh " + installResult.get("ctCode").toString()
			    	    		  + " pada " + installResult.get("installDate").toString() + " . Sila nilaikan kualiti perkhidmatan di http://forms.gle/XfFjgNqk27hU9Zj56" ;
			    	}else{ //FAIL
			    	      smsMessage = "COWAY: Order " + installResult.get("salesOrderNo").toString() +" , Janji temu anda utk Pemasangan Produk TIDAK BERJAYA. Sebarang pertanyaan, sila hubungi 1800-888-111.";
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

  	@SuppressWarnings("unchecked")
	@Override
	public ReturnMessage installationSendEmail(Map<String, Object> params) {

  		ReturnMessage message = new ReturnMessage();

  		List<Integer> installEntryIdArr = new ArrayList<Integer>();
  		List<String> insNoSendArr = new ArrayList<String>();
  		List<String> sentArr = new ArrayList<String>();
  		List<String> notSentArr = new ArrayList<String>();
  		List<String> emailArr = new ArrayList<String>();

  		installEntryIdArr = (List<Integer>) params.get("installEntryIdArr");
  		insNoSendArr = (List<String>) params.get("insNoSendArr");
  		emailArr = (List<String>) params.get("emailArr");

	    String emailSubject = "COWAY: New Installation";
	    String content = "";
	    content += "Dear Customer,\n\n";
	    content += "Thank you for choosing Coway \n\n";
	    content += "Kindly refer an attachment for your Installation Notes.\n";
	    content += "If you need assistance may contact our Coway Careline \n\n";
	    content += "1-800-88-8111\n";
	    content += "9am - 8pm (Mon-Fri)\n";
	    content += "9am - 4pm (Weekends & Public Holidays)\n\n";
	    content += "Thank You.\n\n\n";
	    content += "Regards,\n\n";
	    content += "Coway (Malaysia) Sdn Bhd\n\n";
	    content += "This is system generated email, please do not reply to this email.\n\n";

	    params.put(EMAIL_SUBJECT, emailSubject);
	    params.put(EMAIL_TEXT, content);

	    params.put(REPORT_FILE_NAME, "/services/InstallationNoteDigitalization.rpt");// visualcut
	    params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
	    params.put(REPORT_DOWN_FILE_NAME,  "InstallationNoteDigitalization_" + CommonUtils.getNowDate());

  		for (int i = 0; i < installEntryIdArr.size(); i++) {
  		    List<String> emailNo = new ArrayList<String>();

  			int installEntryId = installEntryIdArr.get(i);
  			String insNumSent = insNoSendArr.get(i);

  			if (!"".equals(CommonUtils.nvl(emailArr.get(i)))) {
		        emailNo.add(CommonUtils.nvl(emailArr.get(i)));
		    }
		    //emailNo.add("keyi.por@coway.com.my"); //for self test only

  			params.put("V_WHERE", installEntryId);// parameter
  			params.put("installEntryId", installEntryId);

  			/*EgovMap mailInfo = installationResultListMapper.getEmailInfo(params);
  			emailNo.add(mailInfo.get("resultRepEmailNo").toString());*/
  			params.put(EMAIL_TO, emailNo);

  			try{
  				this.viewProcedure(null, null, params); //Included sending email
  				sentArr.add(insNumSent);
  				installationResultListMapper.updateEmailSentCount(params);
  			}catch(Exception e){
  				notSentArr.add(insNumSent);
  			}

  			if(sentArr.size() > 0){
  				message.setCode(AppConstants.SUCCESS);
  			    message.setData(String.join(",",sentArr));
  			    message.setMessage("Email sent for " + String.join(",",sentArr));
  			}

  			if(notSentArr.size() > 0){
  				message.setCode("98");
  		        message.setData(String.join(",",notSentArr));
  		        message.setMessage("Email send failed for " + String.join(",",notSentArr));
  			}
  		}

		return message;
	}

  	@Override
    public List<EgovMap> selectWaterSrcType() {
      return installationResultListMapper.selectWaterSrcType();
    }

  	@Override
  	public List<EgovMap> getInstallDtPairByCtCode(Map<String, Object> params) {
  		return installationResultListMapper.getInstallDtPairByCtCode(params);
  	}

    public void insertInstallationAccessories (List<String> installAccList , EgovMap installResult, int userId){
    try {
    	// Remove any "0" entries from the list
  	  	installAccList.removeIf("0"::equals);

        logger.info("### addInstallAccList : " + installAccList.toString());

      if (!installAccList.isEmpty()){

        if (CommonUtils.nvl(installResult.get("mobileYn")).toString() == "Y") {
        	installResult.put("insAccRemark", "Mobile Entry");
        } else {
        	installResult.put("insAccRemark", "Add installation accessories through eTrust - INS");
        }

        installResult.put("entryId", installResult.get("installEntryId"));
        EgovMap entry = installationResultListMapper.selectEntry_2(installResult);

        for (String installAcc : installAccList) {
              // insert into SVC0140D - Installation Accessories Listing table
              EgovMap param = new EgovMap();
              param.put("resultNo", entry.get("installEntryNo"));
              param.put("resultSoId", entry.get("salesOrdId"));
              param.put("insAccPartId", installAcc);
              param.put("remark", installResult.get("insAccRemark"));
              param.put("crtUserId", userId);

              installationResultListMapper.insertInstallationAccessories(param);
          }

        }
    } catch (Exception e) {
      logger.error("An error occurred during insertion of installation accessories.", e);
        }
    }

    @Override
    public List<EgovMap> selectInstallAccWithInstallEntryId(Map<String, Object> params) {
      return installationResultListMapper.selectInstallAccWithInstallEntryId(params);
    }

    @Override
    public List<EgovMap> selectCompetitorBrand() {
      return installationResultListMapper.selectCompetitorBrand();
    }
}
