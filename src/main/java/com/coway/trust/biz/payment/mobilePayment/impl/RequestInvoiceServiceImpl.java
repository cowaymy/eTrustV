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
import com.coway.trust.biz.payment.mobilePayment.RequestInvoiceService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : InvoiceApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("RequestInvoiceService")
public class RequestInvoiceServiceImpl extends EgovAbstractServiceImpl implements RequestInvoiceService{



	@Resource(name = "RequestInvoiceMapper")
	private RequestInvoiceMapper requestInvoiceMapper;



    @Resource(name = "mobileAppTicketApiCommonService")
    private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;



	@Value("${com.file.mobile.upload.path}")
	private String uploadDir;



	@Override
	public List<EgovMap> selectTicketStatusCode() throws Exception{
	    return requestInvoiceMapper.selectTicketStatusCode();
	}



	@Override
	public List<EgovMap> selectInvoiceType() throws Exception{
	    return requestInvoiceMapper.selectInvoiceType();
	}



    @Override
    public ReturnMessage selectRequestInvoiceList(Map<String, Object> param) throws Exception{
        ReturnMessage result = new ReturnMessage();
        int total = requestInvoiceMapper.selectRequestInvoiceCount(param);
        result.setTotal(total);
        param.put("uploadDir", uploadDir);
        result.setDataList(requestInvoiceMapper.selectRequestInvoiceList(param));
        return result;
    }



    @Override
    public int saveRequestInvoiceArrpove(Map<String, Object> param, int userId) throws Exception{
        param.put("userId", userId);
        if( StringUtils.isEmpty( param.get("reqInvcNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
        }
        if( StringUtils.isEmpty( param.get("reqStusId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Status value.");
        }
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
        }
        if( StringUtils.isEmpty( param.get("mobTicketNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
        }

        int saveCnt = requestInvoiceMapper.saveRequestInvoiceArrpove(param);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
        }

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("mobTicketNo", param.get("mobTicketNo"));
        sParams.put("ticketStusId", "5");
        sParams.put("userId", userId);
        arrParams.add(sParams);
        saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }
        return saveCnt;
    }



    @Override
    public int saveRequestInvoiceReject(Map<String, Object> param, int userId) throws Exception{
        param.put("userId", userId);
        if( StringUtils.isEmpty( param.get("reqInvcNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
        }
        if( StringUtils.isEmpty( param.get("reqStusId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Status value.");
        }
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
        }
        if( StringUtils.isEmpty( param.get("rem") )){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
        }
        if( StringUtil.getEncodedSize(String.valueOf(param.get("rem"))) > 4000 ){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason is too long.");
        }

        int saveCnt = requestInvoiceMapper.saveRequestInvoiceReject(param);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
        }

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("mobTicketNo", param.get("mobTicketNo"));
        sParams.put("ticketStusId", "6");
        sParams.put("userId", userId);
        arrParams.add(sParams);
        saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }
        return saveCnt;
    }
}
