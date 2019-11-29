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
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("InvoiceApiService")
public class InvoiceApiServiceImpl extends EgovAbstractServiceImpl implements InvoiceApiService{



	@Resource(name = "InvoiceApiMapper")
	private InvoiceApiMapper invoiceApiMapper;



	@Resource(name = "mobileAppTicketApiCommonService")
	private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;



    @Autowired
    private LoginMapper loginMapper;



	@Override
	public List<EgovMap> selectInvoiceList(InvoiceApiForm param) throws Exception {
	    if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
	    if( CommonUtils.isEmpty(param.getSelectInvoiceType()) ){
            throw new ApplicationException(AppConstants.FAIL, "Invoice Type value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getSelectType()) ){
            throw new ApplicationException(AppConstants.FAIL, "There is no Select Type value.");
        }
        if( param.getSelectInvoiceType().equals("1") && CommonUtils.isEmpty(param.getSalesDt()) ){
            throw new ApplicationException(AppConstants.FAIL, "No Sales Date value found.");
        }
        if( param.getSelectInvoiceType().equals("2") && CommonUtils.isEmpty(param.getSelectKeyword()) ){
            throw new ApplicationException(AppConstants.FAIL, "Please key in select Keyword.");
        }
        if( ("2").equals(param.getSelectType()) && param.getSelectKeyword().toString().length() < 5){
            throw new ApplicationException(AppConstants.FAIL, "Please enter at least 5 characters.");
        }

        List<EgovMap> rtnMap = new ArrayList<EgovMap>();
        if( param.getSelectInvoiceType().equals("1") ){
            rtnMap = invoiceApiMapper.selectInvoiceList(InvoiceApiForm.createMap(param));
        }else if( param.getSelectInvoiceType().equals("2") ){
            rtnMap = invoiceApiMapper.selectAdvanceInvoiceList(InvoiceApiForm.createMap(param));
        }else{
            throw new ApplicationException(AppConstants.FAIL, "Select Type Check.");
        }
		return rtnMap;
	}



	@Override
    public List<EgovMap> selectRequestInvoiceList(InvoiceApiForm param) throws Exception {
	    if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
	    if( CommonUtils.isEmpty(param.getCustId()) ){
            throw new ApplicationException(AppConstants.FAIL, "Cust ID value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getTaxInvcRefDt()) ){
            throw new ApplicationException(AppConstants.FAIL, "Tax Invoice Ref Date value does not exist.");
        }
	    return invoiceApiMapper.selectRequestInvoiceList(InvoiceApiForm.createMap(param));
	}



    @Override
    public List<InvoiceApiDto> saveRequestInvoice(List<InvoiceApiDto> param) throws Exception {
        if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        Map<String, Object> loginInfoMap = new HashMap<String, Object>();
        loginInfoMap.put("_USER_ID", param.get(0).getRegId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }

        HashSet<Object> distinctSh = new HashSet<Object>();
        for(InvoiceApiDto data : param){
            Map<String, Object> createData = InvoiceApiDto.createMap(data);
            if( CommonUtils.isEmpty(createData.get("invcType")) ){
                throw new ApplicationException(AppConstants.FAIL, "There is no invcType value.");
            }
            if( CommonUtils.isEmpty(createData.get("taxInvcId")) ){
                throw new ApplicationException(AppConstants.FAIL, "The Invoice Id value does not exist.");
            }
            if( CommonUtils.isEmpty(createData.get("invcItmId")) ){
                throw new ApplicationException(AppConstants.FAIL, "The Invoice Itim Id value does not exist.");
            }
            if( CommonUtils.isEmpty(createData.get("invcItmOrdNo")) ){
                throw new ApplicationException(AppConstants.FAIL, "The Invoice Itim Order No value does not exist.");
            }
            if( CommonUtils.isEmpty(createData.get("email")) ){
                throw new ApplicationException(AppConstants.FAIL, "Email value does not exist.");
            }
            distinctSh.add(createData.get("invcItmOrdNo"));
        }

        ArrayList<Object> distinctArr = new ArrayList<Object>(distinctSh);
        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();

        for(Object data : distinctArr){
            Map<String, Object> sParams = new HashMap<String, Object>();
            sParams.put("salesOrdNo", data);
            sParams.put("ticketTypeId", "5673");
            sParams.put("ticketStusId", "1");
            sParams.put("userId", param.get(0).getRegId());
            arrParams.add(sParams);
        }
        int mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);
        if( CommonUtils.isEmpty(String.valueOf(mobTicketNo)) || mobTicketNo == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "The Mobile Ticket Number value does not exist.");
        }

        int saveCnt = 0 ;
        int reqInvcNo = 0;
        for(InvoiceApiDto data : param){
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
            createData.put("reqInvcYear", null);
            createData.put("reqInvcMonth", null);
            createData.put("email", createData.get("email"));
            createData.put("email2", createData.get("email2"));

            if( reqInvcNo == 0 ){
                int chkCnt = invoiceApiMapper.selectRequestInvoiceStusCheck(createData);
                if( chkCnt != 0 ){
                    throw new ApplicationException(AppConstants.FAIL, "Request Status Check.");
                }

                saveCnt = invoiceApiMapper.insertPay0294D(createData);
                if( saveCnt == 0 ){
                    throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
                }else{
                    reqInvcNo = (int) createData.get("reqInvcNo");
                }
            }

            createData.put("reqInvcNo", reqInvcNo);
            saveCnt = invoiceApiMapper.insertPay0295D(createData);
            if( saveCnt == 0 ){
                throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
            }
        }
        return param;
    }



    @Override
    public InvoiceApiDto saveRequestAdvanceInvoice(InvoiceApiDto param) throws Exception {
        if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        Map<String, Object> loginInfoMap = new HashMap<String, Object>();
        loginInfoMap.put("_USER_ID", param.getRegId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
        }

        if( CommonUtils.isEmpty(param.getInvcType()) ){
            throw new ApplicationException(AppConstants.FAIL, "There is no invcType value.");
        }
        if( CommonUtils.isEmpty(param.getInvcItmOrdNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "The Invoice Itim Order No value does not exist.");
        }
        if( param.getInvcType()!= 964 && (CommonUtils.isEmpty(param.getInvcItmPoNo()) && CommonUtils.isEmpty(param.getInvcItmPoImg())) ){
            throw new ApplicationException(AppConstants.FAIL, "invcItmPoNo, invcItmPoImg null.");
        }
        if( CommonUtils.isEmpty(param.getInvcItmDiscRate()) ){
            throw new ApplicationException(AppConstants.FAIL, "The Discount Rate value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getInvcItmExgAmt()) ){
            throw new ApplicationException(AppConstants.FAIL, "The Existing Amount value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getInvcItmTotAmt()) ){
            throw new ApplicationException(AppConstants.FAIL, "The  Total Amount value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getReqInvcYearMonth()) ){
            throw new ApplicationException(AppConstants.FAIL, "There is no period form value.");
        }
        if( CommonUtils.isEmpty(param.getTypeId()) ){
            throw new ApplicationException(AppConstants.FAIL, "Type Id value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getEmail()) ){
            throw new ApplicationException(AppConstants.FAIL, "Email value does not exist.");
        }

        Map<String, Object> createData = InvoiceApiDto.createMap(param);

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("salesOrdNo", createData.get("invcItmOrdNo"));
        sParams.put("ticketTypeId", "5673");
        sParams.put("ticketStusId", "1");
        sParams.put("userId", param.getRegId());
        arrParams.add(sParams);
        int mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);
        if( CommonUtils.isEmpty(String.valueOf(mobTicketNo)) || mobTicketNo == 0){
            throw new ApplicationException(AppConstants.FAIL, "The Mobile Ticket Number value does not exist.");
        }

        createData.put("crtUserId", loginVO.getUserId());
        createData.put("updUserId", loginVO.getUserId());
        createData.put("taxInvcId", null);
        createData.put("invcItmId", null);
        createData.put("invcItmRentalFee", null);
        createData.put("mobTicketNo", mobTicketNo);
        if( param.getInvcItmPoImg() == 0 ){
            createData.put("invcItmPoImg", null);
        }

        int chkCnt = invoiceApiMapper.selectRequestAdvanceInvoiceCheck(createData);
        if( chkCnt != 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Request Status Check.");
        }

        int saveCnt = invoiceApiMapper.insertPay0294D(createData);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
        }

        saveCnt = invoiceApiMapper.insertPay0295D(createData);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
        }
        return param;
    }
}
