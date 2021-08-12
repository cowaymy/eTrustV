package com.coway.trust.biz.payment.requestRefundApi.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.payment.requestRefundApi.RequestRefundApiDto;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.requestRefundApi.RequestRefundApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestRefundApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 21.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("RequestRefundApiService")
public class RequestRefundApiServiceImpl extends EgovAbstractServiceImpl implements RequestRefundApiService{



	@Resource(name = "RequestRefundApiMapper")
	private RequestRefundApiMapper requestRefundApiMapper;



    @Autowired
    private LoginMapper loginMapper;



    @Resource(name = "mobileAppTicketApiCommonService")
    private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;



    @Override
    public Map<String, List<EgovMap>> selectCodeList() throws Exception {
        Map<String, List<EgovMap>> selectCodeListMap = new HashMap<String, List<EgovMap>>();
        selectCodeListMap.put("CANCEL_REASON", requestRefundApiMapper.selectCancelReasonList());
        selectCodeListMap.put("CUSTOMER_ISSUE_BANK", requestRefundApiMapper.selectCustomerIssueBankList());
        return selectCodeListMap;
    }



    @Override
    public RequestRefundApiDto saveRequestRefund(RequestRefundApiDto param) throws Exception {
        if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( param.getRefReqId() < 1 || CommonUtils.isEmpty(param.getRefReqId()) ){
            throw new ApplicationException(AppConstants.FAIL, "Ref req ID value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getOrdNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "Customer order number value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getCustName()) ){
            throw new ApplicationException(AppConstants.FAIL, "Order customer name value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getWorNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "WOR number value does not exist.");
        }
        if( param.getAmt() < 1 || CommonUtils.isEmpty(param.getAmt()) ){
            throw new ApplicationException(AppConstants.FAIL, "Amount value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getRefResn()) ){
            throw new ApplicationException(AppConstants.FAIL, "Refund reason value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getRefAttchImg()) ){
            throw new ApplicationException(AppConstants.FAIL, "Refund attch img  value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getIssuBankId()) ){
            throw new ApplicationException(AppConstants.FAIL, "Customer issue Bank ID value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getCustAccNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "Customer bank Account Number value does not exist.");
        }
        try {
            Integer.parseInt(String.valueOf(param.getCustAccNo()));
        } catch(NumberFormatException e) {
            throw new ApplicationException(AppConstants.FAIL, "Only Customer bank account number is available.");
        }
        if( param.getPayId() < 1 || CommonUtils.isEmpty(param.getPayId()) ){
            throw new ApplicationException(AppConstants.FAIL, "Pay ID value does not exist.");
        }



        Map<String, Object> loginInfoMap = new HashMap<String, Object>();
        loginInfoMap.put("_USER_ID", param.getRegId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }



        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("salesOrdNo", param.getOrdNo());
        sParams.put("ticketTypeId", "5676");
        sParams.put("ticketStusId", "1");
        sParams.put("userId", param.getRegId());
        arrParams.add(sParams);
        int mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);
        if( CommonUtils.isEmpty(mobTicketNo) || mobTicketNo == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "The Mobile Ticket Number value does not exist.");
        }



        Map<String, Object> pay0298d = new HashMap<String, Object>();
        pay0298d.put("refReqId", param.getRefReqId());
        pay0298d.put("ordNo", param.getOrdNo());
        pay0298d.put("custName", param.getCustName());
        pay0298d.put("worNo", param.getWorNo());
        pay0298d.put("amt", param.getAmt());
        pay0298d.put("refResn", param.getRefResn());
        pay0298d.put("refAttchImg", param.getRefAttchImg());
        pay0298d.put("issuBankId", param.getIssuBankId());
        pay0298d.put("custAccNo", param.getCustAccNo());
        pay0298d.put("mobTicketNo", mobTicketNo);
        pay0298d.put("crtUserId", loginVO.getUserId());
        pay0298d.put("updUserId", loginVO.getUserId());
        int saveCnt = requestRefundApiMapper.insertPAY0298D(pay0298d);
        if( saveCnt != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
        }
        return param;
    }
}
