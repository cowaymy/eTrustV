package com.coway.trust.biz.payment.mobilePayment.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.util.StringUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.payment.mobilePayment.RequestFundTransferService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestFundTransferServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("RequestFundTransferService")
public class RequestFundTransferServiceImpl extends EgovAbstractServiceImpl implements RequestFundTransferService{



	@Resource(name = "RequestFundTransferMapper")
	private RequestFundTransferMapper requestFundTransferMapper;



    @Resource(name = "mobileAppTicketApiCommonService")
    private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;



	@Value("${com.file.mobile.upload.path}")
	private String uploadDir;



	@Override
	public List<EgovMap> selectTicketStatusCode() throws Exception{
	    return requestFundTransferMapper.selectTicketStatusCode();
	}



    @Override
    public ReturnMessage selectRequestFundTransferList(Map<String, Object> param) throws Exception{
        ReturnMessage result = new ReturnMessage();
        int total = requestFundTransferMapper.selectRequestFundTransferCount(param);
        result.setTotal(total);
        result.setDataList(requestFundTransferMapper.selectRequestFundTransferList(param));
        return result;
    }



    @Override
    public int saveRequestFundTransferArrpove(Map<String, Object> param) throws Exception{
        if( CommonUtils.isEmpty( param.get("ftReqId") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile Request Fund Transfer Number value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("curWorNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Current WOR Number value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("mobTicketNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile Ticket Number value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("curAmt") )){
            throw new ApplicationException(AppConstants.FAIL, "Current Amount value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("curOrdNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Current Order Number value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("curCustName") )){
            throw new ApplicationException(AppConstants.FAIL, "Current Order Customer Name value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("newAmt") )){
            throw new ApplicationException(AppConstants.FAIL, "New Amount value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("newOrdNo") )){
            throw new ApplicationException(AppConstants.FAIL, "New Order Number value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("newCustName") )){
            throw new ApplicationException(AppConstants.FAIL, "New Order Customer Name value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("ftResn") )){
            throw new ApplicationException(AppConstants.FAIL, "Fund Tranfer Reason value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("ftStusId") ) || Integer.parseInt(String.valueOf(param.get("ftStusId"))) != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Fund Tranfer Status value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("ticketStusId") ) || Integer.parseInt(String.valueOf(param.get("ticketStusId"))) != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Fund Tranfer Status value does not exist.");
        }

        Map<String, Object> selectPAY02052T = new HashMap<String, Object>();
        selectPAY02052T.put("orNo", param.get("curWorNo"));
        EgovMap selectDataPAY02052T = requestFundTransferMapper.selectInfoPAY02052T(selectPAY02052T);

        if( CommonUtils.isEmpty( selectDataPAY02052T.get("groupSeq") )){
            throw new ApplicationException(AppConstants.FAIL, " Group Sequence  value does not exist.");
        }
        if( CommonUtils.isEmpty( selectDataPAY02052T.get("payId") )){
            throw new ApplicationException(AppConstants.FAIL, " Payment ID value does not exist.");
        }

        int ftStusIdActive = 1;                                                 //SYS0038M - 1(Active)
        int ftStusIdApproved = 5;                                               //SYS0038M - 5(Approved)

        Map<String, Object> pay0260d = new HashMap<String, Object>();
        pay0260d.put("ftReqId", param.get("ftReqId"));
        pay0260d.put("srcGrpSeq", selectDataPAY02052T.get("groupSeq"));         //requestFundTransferMapper.selectInfoPAY02052T(param);
        pay0260d.put("srcAmt", param.get("curAmt"));
        pay0260d.put("srcOrdNo", param.get("curOrdNo"));
        pay0260d.put("srcCustName", param.get("curCustName"));
        pay0260d.put("srcPayId", selectDataPAY02052T.get("payId"));             //requestFundTransferMapper.selectInfoPAY02052T(param);
        pay0260d.put("ftGrpSeq", null);
        pay0260d.put("ftAmt", param.get("newAmt"));
        pay0260d.put("ftOrdNo", param.get("newOrdNo"));
        pay0260d.put("ftCustName", param.get("newCustName"));
        pay0260d.put("ftResn", param.get("ftResn"));
        pay0260d.put("ftRem", param.get("ftRem"));
        pay0260d.put("ftStusId", ftStusIdActive);                               //SYS0038M - 1(Active)
        pay0260d.put("ftCrtUserId", param.get("userId"));
        int saveCnt = requestFundTransferMapper.insertApprovedPAY0260D(pay0260d);
        if( saveCnt != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to SAVE.");
        }

        Map<String, Object> pay0252t = new HashMap<String, Object>();
        pay0252t.put("ftStusId", ftStusIdActive);                               //SYS0038M - 1(Active)
        pay0252t.put("groupSeq", selectDataPAY02052T.get("groupSeq"));          //requestFundTransferMapper.selectInfoPAY02052T(param);
        pay0252t.put("payId", selectDataPAY02052T.get("payId"));                //requestFundTransferMapper.selectInfoPAY02052T(param);
        saveCnt = requestFundTransferMapper.updateFtStusIdPAY0252T(pay0252t);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }

        Map<String, Object> pay0296d = new HashMap<String, Object>();
        pay0296d.put("ftStusId", ftStusIdApproved);                             //SYS0038M - 5(Approved)
        pay0296d.put("updUserId", param.get("userId"));
        pay0296d.put("ftReqId", param.get("ftReqId"));
        saveCnt = requestFundTransferMapper.updateApprovedPAY0296D(pay0296d);
        if( saveCnt != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("mobTicketNo", param.get("mobTicketNo"));
        sParams.put("ticketStusId", ftStusIdApproved);
        sParams.put("userId", param.get("userId"));
        arrParams.add(sParams);
        saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }
        return saveCnt;
    }



    @Override
    public int saveRequestFundTransferReject(Map<String, Object> param) throws Exception{
        if( CommonUtils.isEmpty( param.get("ftReqId") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile Request Fund Transfer Number value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("ftRem") )){
            throw new ApplicationException(AppConstants.FAIL, "Reasons for rejection value does not exist.");
        }
        if( StringUtil.getEncodedSize(String.valueOf(param.get("ftRem"))) >= 4000 ){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason is too long.");
        }
        if( CommonUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("mobTicketNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile Ticket Number value does not exist.");
        }

        int ftStusIdRejected = 6;                                               //SYS0038M - 6(Rejected)

        Map<String, Object> pay0296d = new HashMap<String, Object>();
        pay0296d.put("ftStusId", ftStusIdRejected);                             //SYS0038M - 6(Rejected)
        pay0296d.put("ftRem", param.get("ftRem"));
        pay0296d.put("updUserId", param.get("updUserId"));
        pay0296d.put("ftReqId", param.get("ftReqId"));
        int saveCnt = requestFundTransferMapper.updateRejectedPAY0296D(pay0296d);
        if( saveCnt != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("mobTicketNo", param.get("mobTicketNo"));
        sParams.put("ticketStusId", ftStusIdRejected);
        sParams.put("userId", param.get("userId"));
        arrParams.add(sParams);
        saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }
        return saveCnt;
    }
}
