package com.coway.trust.biz.payment.invoiceApi.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.payment.invoiceApi.InvoiceApiDto;
import com.coway.trust.api.mobile.payment.invoiceApi.InvoiceApiForm;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.invoiceApi.InvoiceApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : InvoiceApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * 2020. 04. 03.    MY-ONGCH         Amend Error Message
 *          </pre>
 */
@Service("InvoiceApiService")
public class InvoiceApiServiceImpl extends EgovAbstractServiceImpl implements InvoiceApiService {

  @Resource(name = "InvoiceApiMapper")
  private InvoiceApiMapper invoiceApiMapper;

  @Resource(name = "mobileAppTicketApiCommonService")
  private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;

  @Autowired
  private LoginMapper loginMapper;

  private String errMsg = "Error Encounter. Please Contact System Administrator.";

  @Override
  public List<EgovMap> selectInvoiceList(InvoiceApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[selectInvoiceList:Param is empty]");
    }
    if (CommonUtils.isEmpty(param.getSelectInvoiceType())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg+ "[selectInvoiceList:Invoice Type is empty]");
    }
    if (CommonUtils.isEmpty(param.getSelectType())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[selectInvoiceList:Search Option is empty]");
    }
    if (param.getSelectInvoiceType().equals("1") && CommonUtils.isEmpty(param.getSalesDt())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[selectInvoiceList:Sales Date is empty]");
    }
    if (param.getSelectInvoiceType().equals("2") && CommonUtils.isEmpty(param.getSelectKeyword())) {
      throw new ApplicationException(AppConstants.FAIL, "Selected keyword is required. ");
    }
    if (("2").equals(param.getSelectType()) && param.getSelectKeyword().toString().length() < 5) {
      throw new ApplicationException(AppConstants.FAIL, "Please enter at least 5 characters for selected keyword.");
    }

    List<EgovMap> rtnMap = new ArrayList<EgovMap>();
    if (param.getSelectInvoiceType().equals("1")) {
      rtnMap = invoiceApiMapper.selectInvoiceList(InvoiceApiForm.createMap(param));
    } else if (param.getSelectInvoiceType().equals("2")) {
      rtnMap = invoiceApiMapper.selectAdvanceInvoiceList(InvoiceApiForm.createMap(param));
    } else {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[selectInvoiceList:Invalid search option (" + param.getSelectInvoiceType() +")]");
    }
    return rtnMap;
  }

  @Override
  public List<EgovMap> selectRequestInvoiceList(InvoiceApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[selectRequestInvoiceList: Param is empty]");
    }
    if (CommonUtils.isEmpty(param.getCustId())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[selectRequestInvoiceList: Customer ID is empty]");
    }
    if (CommonUtils.isEmpty(param.getTaxInvcRefDt())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[selectRequestInvoiceList: Tax Invoice Ref. Dt. is empty]");
    }
    return invoiceApiMapper.selectRequestInvoiceList(InvoiceApiForm.createMap(param));
  }

  @Override
  public List<InvoiceApiDto> saveRequestInvoice(List<InvoiceApiDto> param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Param is empty]");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.get(0).getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: User Name is empty]");
    }

    HashSet<Object> distinctSh = new HashSet<Object>();
    for (InvoiceApiDto data : param) {
      Map<String, Object> createData = InvoiceApiDto.createMap(data);
      if (CommonUtils.isEmpty(createData.get("invcType"))) {
        throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Invoice Type is empty]");
      }
      if (CommonUtils.isEmpty(createData.get("taxInvcId"))) {
        throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Invoice ID is empty]");
      }
      if (CommonUtils.isEmpty(createData.get("invcItmId"))) {
        throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Invoice Itm. ID is empty]");
      }
      if (CommonUtils.isEmpty(createData.get("invcItmOrdNo"))) {
        throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Invoice Itm Ord. No. is empty]");
      }
      if (CommonUtils.isEmpty(createData.get("email"))) {
        throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Email is empty]");
      }
      distinctSh.add(createData.get("invcItmOrdNo"));
    }

    ArrayList<Object> distinctArr = new ArrayList<Object>(distinctSh);
    List<Map<String, Object>> arrParams = new ArrayList<Map<String, Object>>();

    for (Object data : distinctArr) {
      Map<String, Object> sParams = new HashMap<String, Object>();
      sParams.put("salesOrdNo", data);
      sParams.put("ticketTypeId", "5673");
      sParams.put("ticketStusId", "1");
      sParams.put("userId", param.get(0).getRegId());
      arrParams.add(sParams);
    }
    int mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);
    if (CommonUtils.isEmpty(mobTicketNo) || mobTicketNo == 0) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Fail to generate mobile ticket ID]");
    }

    int saveCnt = 0;
    int reqInvcNo = 0;
    for (InvoiceApiDto data : param) {
      Map<String, Object> createData = InvoiceApiDto.createMap(data);

      createData.put("crtUserId", loginVO.getUserId());
      createData.put("updUserId", loginVO.getUserId());
      createData.put("mobTicketNo", mobTicketNo);
      createData.put("invcItmPoNo", null);
      createData.put("invcItmPoImg", null);
      createData.put("invcAdvPrd", null);
      createData.put("invcItmRentalFee", null);
      createData.put("invcItmDiscRate", null);
      createData.put("invcItmExgAmt", null);
      createData.put("invcItmTotAmt", null);
      createData.put("reqInvcYearMonth()", null);

      if (reqInvcNo == 0) {
        int chkCnt = invoiceApiMapper.selectRequestInvoiceStusCheck(createData);
        if (chkCnt != 0) {
          throw new ApplicationException(AppConstants.FAIL, "Request for this order no. already exist. Please check request status.");
        }

        saveCnt = invoiceApiMapper.insertPay0300D(createData);
        if (saveCnt == 0) {
          throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Fail to create mobile ticket(300D)]");
        } else {
          reqInvcNo = (int) createData.get("reqInvcNo");
        }
      }

      createData.put("reqInvcNo", reqInvcNo);
      saveCnt = invoiceApiMapper.insertPay0301D(createData);
      if (saveCnt == 0) {
        throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestInvoice: Fail to create mobile ticket(301D)]");
      }
    }
    return param;
  }

  @Override
  public InvoiceApiDto saveRequestAdvanceInvoice(InvoiceApiDto param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Param is empty]");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", param.getRegId());
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: User ID is empty]");
    }

    if (CommonUtils.isEmpty(param.getInvcType())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Invoice Type is empty]");
    }
    if (CommonUtils.isEmpty(param.getInvcItmOrdNo())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Invoice Itm. Order no. is empty]");
    }
    if (param.getInvcType() != 964
        && (CommonUtils.isEmpty(param.getInvcItmPoNo()) && CommonUtils.isEmpty(param.getInvcItmPoImg()))) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Invoice Itm. PO no./Image is empty]");
    }
    if (CommonUtils.isNotEmpty(param.getInvcItmPoNo()) && param.getInvcItmPoNo().length() > 20) {
      throw new ApplicationException(AppConstants.FAIL, "Maximun length for purchase order no. is up to 20 digits only.");
    }
    if (CommonUtils.isEmpty(param.getInvcItmDiscRate())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Discount Rate is empty]");
    }
    if (CommonUtils.isEmpty(param.getInvcItmExgAmt())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Existing Amount is empty]");
    }
    if (CommonUtils.isEmpty(param.getInvcItmTotAmt())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Total Amount is empty]");
    }
    if (CommonUtils.isEmpty(param.getReqInvcYearMonth())) {
      throw new ApplicationException(AppConstants.FAIL, "Request Period is required.");
    }
    if (CommonUtils.isEmpty(param.getTypeId())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Type ID is empty]");
    }
    if (CommonUtils.isEmpty(param.getEmail())) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Email is empty]");
    }

    Map<String, Object> createData = InvoiceApiDto.createMap(param);

    List<Map<String, Object>> arrParams = new ArrayList<Map<String, Object>>();
    Map<String, Object> sParams = new HashMap<String, Object>();
    sParams.put("salesOrdNo", createData.get("invcItmOrdNo"));
    sParams.put("ticketTypeId", "5673");
    sParams.put("ticketStusId", "1");
    sParams.put("userId", param.getRegId());
    arrParams.add(sParams);
    int mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);
    if (CommonUtils.isEmpty(mobTicketNo) || mobTicketNo == 0) {
      throw new ApplicationException(AppConstants.FAIL, this.errMsg + "[saveRequestAdvanceInvoice: Fail to generate mobile ticket ID]");
    }

    createData.put("crtUserId", loginVO.getUserId());
    createData.put("updUserId", loginVO.getUserId());
    createData.put("taxInvcId", null);
    createData.put("invcItmId", null);
    createData.put("invcItmRentalFee", null);
    createData.put("taxInvcRefNo", null);
    createData.put("mobTicketNo", mobTicketNo);
    if (param.getInvcItmPoImg() == 0) {
      createData.put("invcItmPoImg", null);
    }

    int chkCnt = invoiceApiMapper.selectRequestAdvanceInvoiceCheck(createData);
    if (chkCnt != 0) {
      throw new ApplicationException(AppConstants.FAIL, "Request for this order no. already exist. Please check request status.");
    }

    int saveCnt = invoiceApiMapper.insertPay0300D(createData);
    if (saveCnt == 0) {
      throw new ApplicationException(AppConstants.FAIL,  this.errMsg + "[saveRequestInvoice: Fail to create mobile ticket(300D)]");
    }

    saveCnt = invoiceApiMapper.insertPay0301D(createData);
    if (saveCnt == 0) {
      throw new ApplicationException(AppConstants.FAIL,  this.errMsg + "[saveRequestInvoice: Fail to create mobile ticket(301D)]");
    }
    return param;
  }
}
