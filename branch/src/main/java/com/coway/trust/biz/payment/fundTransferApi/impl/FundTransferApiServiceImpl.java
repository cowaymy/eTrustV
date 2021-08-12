package com.coway.trust.biz.payment.fundTransferApi.impl;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.payment.fundTransferApi.FundTransferApiDto;
import com.coway.trust.api.mobile.payment.fundTransferApi.FundTransferApiForm;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.fundTransferApi.FundTransferApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : FundTransferApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 21.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("FundTransferApiService")
public class FundTransferApiServiceImpl extends EgovAbstractServiceImpl implements FundTransferApiService{



	@Resource(name = "FundTransferApiMapper")
	private FundTransferApiMapper fundTransferApiMapper;



    @Autowired
    private LoginMapper loginMapper;



    @Resource(name = "mobileAppTicketApiCommonService")
    private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;



	@Override
    public List<EgovMap> selectReasonList() throws Exception {
	    return fundTransferApiMapper.selectReasonList();
	}



    @Override
    public FundTransferApiDto selectFundTransfer(FundTransferApiForm param) throws Exception {
        if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getSalesOrdNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "Sales Order No value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getAppTypeId()) ){
            throw new ApplicationException(AppConstants.FAIL, "App Type ID value does not exist.");
        }
        Map<String, Object> createParam = FundTransferApiForm.createMap(param);
        EgovMap selectData = fundTransferApiMapper.selectFundTransfer(createParam);
        if( empty(selectData) == false && String.valueOf(selectData.get("ftAppTypeId")).equals(String.valueOf(param.getAppTypeId())) == false ){
            throw new ApplicationException(AppConstants.FAIL, "Please check your App Type ID.");
        }
        FundTransferApiDto result = new FundTransferApiDto();
        if( empty(selectData) == false ){
            result = FundTransferApiDto.create(selectData);
        }
        return result;
    }



    @SuppressWarnings("rawtypes")
    public Boolean empty(Object obj) {
        if (obj instanceof String) return obj == null || "".equals(obj.toString().trim());
        else if (obj instanceof List) return obj == null || ((List) obj).isEmpty();
        else if (obj instanceof Map) return obj == null || ((Map) obj).isEmpty();
        else if (obj instanceof Object[]) return obj == null || Array.getLength(obj) == 0;
        else return obj == null;
    }



    @Override
    public FundTransferApiForm saveFundTransfer(FundTransferApiForm param) throws Exception {
        if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( param.getSrcGrpSeq() < 1 || CommonUtils.isEmpty(param.getSrcGrpSeq()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(Current)) Sales order no value does not exist.");
        }
        if( param.getSrcAmt() < 1 || CommonUtils.isEmpty(param.getSrcAmt()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(Current)) Amt value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getSrcOrdNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(Current)) Sales order no value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getSrcCustName()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(Current)) Cust name value does not exist.");
        }
        if( param.getSrcPayId() < 1 || CommonUtils.isEmpty(param.getSrcPayId()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(Current)) Pay ID value does not exist.");
        }
        if( param.getFtAmt() < 1 || CommonUtils.isEmpty(param.getFtAmt()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(New)) Amt value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getFtOrdNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(New)) Sales order no value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getFtCustName()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(New)) Cust name value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getFtResn()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(New)) Reason value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getFtStusId()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(New)) Stus ID value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getOrNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "Current wor number value does not exist.");
        }
        if( param.getSrcOrdNo().equals(param.getFtOrdNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "Duplicate order number.");
        }
        if( CommonUtils.isEmpty(param.getCurPayTypeId()) ){
            throw new ApplicationException(AppConstants.FAIL, "(Order(New)) Current WOR Payment Type ID value does not exist.");
        }



        Map<String, Object> loginInfoMap = new HashMap<String, Object>();
        loginInfoMap.put("_USER_ID", param.getRegId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }



        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("salesOrdNo", param.getSrcOrdNo());
        sParams.put("ticketTypeId", "5675");
        sParams.put("ticketStusId", "1");
        sParams.put("userId", param.getRegId());
        arrParams.add(sParams);
        int mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);
        if( CommonUtils.isEmpty(mobTicketNo) || mobTicketNo == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "The Mobile Ticket Number value does not exist.");
        }



        Map<String, Object> pay0296d = new HashMap<String, Object>();
//        pay0296d.put("ftReqId", );
        pay0296d.put("curOrdNo", param.getSrcOrdNo());
        pay0296d.put("curCustName", param.getSrcCustName());
        pay0296d.put("curWorNo", param.getOrNo());
        pay0296d.put("curAmt", param.getSrcAmt());
        pay0296d.put("newOrdNo", param.getFtOrdNo());
        pay0296d.put("newCustName", param.getFtCustName());
        pay0296d.put("newAmt", param.getFtAmt());
        pay0296d.put("ftResn", param.getFtResn());
        pay0296d.put("ftAttchImg", param.getFtAttchImg());
        pay0296d.put("mobTicketNo", mobTicketNo);
        pay0296d.put("crtUserId", loginVO.getUserId());
        pay0296d.put("updUserId", loginVO.getUserId());
        pay0296d.put("curPayTypeId", param.getCurPayTypeId());
        int saveCnt = fundTransferApiMapper.insertPAY0296D(pay0296d);
        if( saveCnt != 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
        }
        return param;
    }
}
