package com.coway.trust.biz.payment.mobilePayment.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.util.StringUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.payment.mobilePayment.RequestRefundService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestRefundServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("RequestRefundService")
public class RequestRefundServiceImpl extends EgovAbstractServiceImpl implements RequestRefundService{



	@Resource(name = "RequestRefundMapper")
	private RequestRefundMapper requestRefundMapper;



    @Resource(name = "mobileAppTicketApiCommonService")
    private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;



	@Value("${com.file.mobile.upload.path}")
	private String uploadDir;



	@Override
	public List<EgovMap> selectTicketStatusCode() throws Exception{
	    return requestRefundMapper.selectTicketStatusCode();
	}



    @Override
    public ReturnMessage selectRequestRefundList(Map<String, Object> param) throws Exception{
        ReturnMessage result = new ReturnMessage();
        int total = requestRefundMapper.selectRequestFundTransferCount(param);
        result.setTotal(total);
        result.setDataList(requestRefundMapper.selectRequestRefundList(param));
        return result;
    }



    @Override
    public int saveRequestRefundArrpove(Map<String, Object> param) throws Exception{
        if( StringUtils.isEmpty( param.get("refReqId") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile request refund Number value does not exist.");
        }
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }
        if( StringUtils.isEmpty( param.get("mobTicketNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile Ticket Number value does not exist.");
        }

        int saveCnt = requestRefundMapper.updateApprovedPAY0298D(param);
        if( saveCnt != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("mobTicketNo", param.get("mobTicketNo"));
        sParams.put("ticketStusId", "5");
        sParams.put("userId", param.get("userId"));
        arrParams.add(sParams);
        saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }
        return saveCnt;
    }



    @Override
    public int saveRequestRefundReject(Map<String, Object> param) throws Exception{
        if( StringUtils.isEmpty( param.get("refReqId") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile request refund Number value does not exist.");
        }
        if( StringUtils.isEmpty( param.get("rem") )){
            throw new ApplicationException(AppConstants.FAIL, "Reasons for rejection value does not exist.");
        }
        if( StringUtil.getEncodedSize(String.valueOf(param.get("rem"))) >= 4000 ){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason is too long.");
        }
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }
        if( StringUtils.isEmpty( param.get("mobTicketNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Mobile Ticket Number value does not exist.");
        }

        int saveCnt = requestRefundMapper.updateRejectedPAY0298D(param);
        if( saveCnt != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("mobTicketNo", param.get("mobTicketNo"));
        sParams.put("ticketStusId", "6");
        sParams.put("userId", param.get("userId"));
        arrParams.add(sParams);
        saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }
        return saveCnt;
    }
}
