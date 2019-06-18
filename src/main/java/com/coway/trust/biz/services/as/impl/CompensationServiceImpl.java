package com.coway.trust.biz.services.as.impl;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.services.as.CompensationService;
import com.coway.trust.biz.services.servicePlanning.impl.HolidayMapper;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 * 18/06/2019    ONGHC      1.0.2       - Amend based on user request
 *********************************************************************************************/

@Service("CompensationService")
public class CompensationServiceImpl extends EgovAbstractServiceImpl implements CompensationService {

  private static final Logger LOGGER = LoggerFactory.getLogger(CompensationServiceImpl.class);

  @Resource(name = "CompensationMapper")
  private CompensationMapper compensationMapper;

  @Resource(name = "holidayMapper")
  private HolidayMapper holidayMapper;

  @Autowired
  private FileService fileService;

  @Autowired
  private MessageSourceAccessor messageSourceAccessor;

  @Override
  public List<EgovMap> selCompensationList(Map<String, Object> params) {
    return compensationMapper.selCompensationList(params);
  }

  @Override
  public EgovMap selectCompenSationView(Map<String, Object> params) {
    return compensationMapper.selectCompenSationView(params);
  }

  @Override
  public EgovMap selectOrdInfo(Map<String, Object> params) {
    return compensationMapper.selectOrdInfo(params);
  }

/*  @Override
  public EgovMap selectOrderBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception {
      EgovMap orderDetail = new EgovMap();

      EgovMap basicInfo        = compensationMapper.selectBasicInfo(params);
      EgovMap logView          = compensationMapper.selectLatestOrderLogByOrderID(params);
      EgovMap agreementView    = compensationMapper.selectOrderAgreementByOrderID(params);
      EgovMap installationInfo = compensationMapper.selectOrderInstallationInfoByOrderID(params);
      EgovMap ccpFeedbackCode  = compensationMapper.selectOrderCCPFeedbackCodeByOrderID(params);
      EgovMap ccpInfo          = compensationMapper.selectOrderCCPInfoByOrderID(params);
      EgovMap salesmanInfo     = compensationMapper.selectOrderSalesmanViewByOrderID(params);
      EgovMap codyInfo         = compensationMapper.selectOrderServiceMemberViewByOrderID(params);
      EgovMap mailingInfo      = compensationMapper.selectOrderMailingInfoByOrderID(params);
      EgovMap rentPaySetInf    = null;
      EgovMap thirdPartyInfo   = null;
      EgovMap grntnfo          = null;
      EgovMap orderCfgInfo     = compensationMapper.selectOrderConfigInfo(params);
      EgovMap gstCertInfo      = compensationMapper.selectGSTCertInfo(params);

      String memInfo           = compensationMapper.selectMemberInfo((String) basicInfo.get("custNric"));

      if(CommonUtils.isNotEmpty(memInfo)) {
          basicInfo.put("memInfo", "("+memInfo+")");
      }

      if(SalesConstants.APP_TYPE_CODE_RENTAL.equals(basicInfo.get("appTypeCode").toString()) || SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS.equals(basicInfo.get("appTypeCode").toString())) {

          rentPaySetInf = orderDetailMapper.selectOrderRentPaySetInfoByOrderID(params);

          if(rentPaySetInf != null) {

              this.loadRentPaySetInf(rentPaySetInf, sessionVO);

              if(((BigDecimal)rentPaySetInf.get("is3party")).compareTo(BigDecimal.ONE) == 0) {
                  rentPaySetInf.put("is3party", "Yes");

                  params.put("testparam", rentPaySetInf.get("payerCustId"));

                  thirdPartyInfo = customerMapper.selectCustomerViewBasicInfo(params);
              }
              else {
                  rentPaySetInf.put("is3Party", "No");
              }

              if("01/01/1900".equals(rentPaySetInf.get("rentPayApplyDt"))) {
                  rentPaySetInf.put("rentPayApplyDt", "-");
              }
              if("01/01/1900".equals(rentPaySetInf.get("rentPaySubmitDt"))) {
                  rentPaySetInf.put("rentPaySubmitDt", "-");
              }
              if("01/01/1900".equals(rentPaySetInf.get("rentPayStartDt"))) {
                  rentPaySetInf.put("rentPayStartDt", "-");
              }
              if("01/01/1900".equals(rentPaySetInf.get("rentPayRejctDt"))) {
                  rentPaySetInf.put("rentPayRejctDt", "-");
              }
          }

          if (Integer.toString(SalesConstants.SALES_CCP_CODEID).equals(((BigDecimal)basicInfo.get("rentChkId")).toString())) {
              grntnfo = orderDetailMapper.selectGuaranteeInfo(params);
              this.loadOrderGuaranteeInfo(grntnfo, installationInfo);
          }
      }

      this.loadBasicInfo(basicInfo);
      this.loadCustInfo(basicInfo);
      if(installationInfo != null) this.loadInstallationInfo(installationInfo);
      if(mailingInfo != null) this.loadMailingInfo(mailingInfo, basicInfo);
      if(orderCfgInfo != null) this.loadConfigInfo(orderCfgInfo);
//    if(gstCertInfo != null) this.loadGstCertInfo(gstCertInfo);

      orderDetail.put("basicInfo",        basicInfo);
      orderDetail.put("logView",          logView);
      orderDetail.put("agreementView",    agreementView);
      orderDetail.put("installationInfo", installationInfo);
      orderDetail.put("ccpFeedbackCode",  ccpFeedbackCode);
      orderDetail.put("ccpInfo",          ccpInfo);
      orderDetail.put("salesmanInfo",     salesmanInfo);
      orderDetail.put("codyInfo",         codyInfo);
      orderDetail.put("mailingInfo",      mailingInfo);
      orderDetail.put("rentPaySetInf",    rentPaySetInf);
      orderDetail.put("thirdPartyInfo",   thirdPartyInfo);
      orderDetail.put("orderCfgInfo",     orderCfgInfo);
      orderDetail.put("gstCertInfo",      gstCertInfo);

      Date salesDt = (Date) basicInfo.get("ordDt");

      DateFormat formatter = new SimpleDateFormat("yyyyMMdd");

      Date dt = formatter.parse("20180101");

      logger.debug("@#### salesDt:"+salesDt);
      logger.debug("@#### dt:"+dt);

      boolean isNew = salesDt.after(dt);

      logger.debug("@#### isBefore:"+isNew);

      orderDetail.put("isNewVer", isNew ? "Y" : "N");

      return orderDetail;
  };*/


  @Override
  public EgovMap insertCompensation(Map<String, Object> params) {
    EgovMap saveView = new EgovMap();
    compensationMapper.insertCompensation(params);

    saveView.put("success", true);
    saveView.put("code", "00");
    saveView.put("message", "Compensation successfully created.");

    return saveView;
  }

  @Override
  public List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params) {
    return compensationMapper.selectSalesOrdNoInfo(params);
  }

  @Override
  public EgovMap updateCompensation(Map<String, Object> params) {

    EgovMap saveView = new EgovMap();
    compensationMapper.updateCompensation(params);

    saveView.put("success", true);
    saveView.put("massage", "Compensation successfully updated.");

    return saveView;
  }

  @Override
  public List<EgovMap> selectBranchWithNM() {
    return compensationMapper.selectBranchWithNM();
  }

  @Override
  public List<EgovMap> selectCpsStatus() {
    return compensationMapper.selectCpsStatus();
  }

  @Override
  public List<EgovMap> selectCpsTyp() {
    return compensationMapper.selectCpsTyp();
  }

  @Override
  public List<EgovMap> selectCpsRespTyp() {
    return compensationMapper.selectCpsRespTyp();
  }

  @Override
  public List<EgovMap> selectCpsCocTyp() {
    return compensationMapper.selectCpsCocTyp();
  }

  @Override
  public List<EgovMap> selectCpsEvtTyp() {
    return compensationMapper.selectCpsEvtTyp();
  }

  @Override
  public List<EgovMap> selectCpsDftTyp(String stkCode) {
    return compensationMapper.selectCpsDftTyp(stkCode);
  }

  @Override
  public List<EgovMap> getMainDeptList() {
    return compensationMapper.selectMainDept();
  }

  @Override
  public List<EgovMap> getAttachmentFileInfo(Map<String, Object> params) {
    return compensationMapper.selectAttachmentFileInfo(params);
  }

  @Override
  public EgovMap selectOrderBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception {
    return null;
  }

  @Override
  public int chkCpsRcd(Map<String, Object> params) {
    return compensationMapper.chkCpsRcd(params);
  }

}
