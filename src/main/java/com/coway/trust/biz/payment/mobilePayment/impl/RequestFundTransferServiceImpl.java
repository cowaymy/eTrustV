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
    public ReturnMessage selectOutstandingAmount(Map<String, Object> param) throws Exception{
        if( CommonUtils.isEmpty( param.get("ftReqId") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile Request Fund Transfer Number value does not exist.");
        }
        requestFundTransferMapper.selectOutstandingAmount(param);
        @SuppressWarnings("unchecked")
        List<EgovMap> selectData = (List<EgovMap>) param.get("selectData");
        ReturnMessage result = new ReturnMessage();
        result.setData(selectData);
        return result;
    }



    @Override
    public int saveRequestFundTransferArrpove(Map<String, Object> param) throws Exception{
        if( CommonUtils.isEmpty( param.get("ftReqId") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile Request Fund Transfer Number value does not exist.");
        }
        if( CommonUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }
        requestFundTransferMapper.callSpInstReqFundTrnsfr(param);
        if( param.get("errcode").toString().equals("000") == false){
            throw new ApplicationException(AppConstants.FAIL, (String)param.get("errmsg").toString());
        }
        return 0;
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
        pay0296d.put("updUserId", param.get("userId"));
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
