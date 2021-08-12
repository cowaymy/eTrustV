package com.coway.trust.biz.sales.royaltyCustomerListApi.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiFormDto;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiDto;
import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.royaltyCustomerListApi.RoyaltyCustomerListApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ProductInfoListApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("RoyaltyCustomerListApiService")
public class RoyaltyCustomerListApiServiceImpl extends EgovAbstractServiceImpl implements RoyaltyCustomerListApiService{

     @Autowired
     private LoginMapper loginMapper;

	@Resource(name = "RoyaltyCustomerListApiMapper")
	private RoyaltyCustomerListApiMapper royaltyCustomerListApiMapper;

    @Override
    public List<EgovMap> selectWsLoyaltyList( RoyaltyCustomerListApiForm param) {
	//public List<EgovMap> selectWsLoyaltyList( RoyaltyCustomerListApiDto param) throws Exception {
		// TODO Auto-generated method stub
      //  param.setWhLocId(loginVO.getUserId());

    /*	 if( CommonUtils.isEmpty(param.getRegId()) ){
             throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
         }*/

    	 Map<String, Object> loginInfoMap = new HashMap<String, Object>();
         loginInfoMap.put("_USER_ID", param.getRegId());
         LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
         if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
             throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
         }
         param.setWhLocId(loginVO.getUserId());

		//return royaltyCustomerListApiMapper.selectWsLoyaltyList();
		return royaltyCustomerListApiMapper.selectWsLoyaltyList(RoyaltyCustomerListApiForm.createMap(param));
	}

	@Override
//	public RoyaltyCustomerListApiForm updateWsLoyaltyList(RoyaltyCustomerListApiForm param) throws Exception { //666

		public RoyaltyCustomerListApiDto updateWsLoyaltyList(RoyaltyCustomerListApiDto param) throws Exception {
		// TODO Auto-generated method stub


		 	if (null == param) {
		      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
		    }
		 	 if (CommonUtils.isEmpty(param.getHpCallReasonCode())) {
		 	      throw new ApplicationException(AppConstants.FAIL, "Reason Code does not exist.");
		 	    }

		    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
		    loginInfoMap.put("_USER_ID", param.getRegId()); //666
		    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
		    if (null == loginVO || CommonUtils.isEmpty(loginVO.getUserId())) {
		      throw new ApplicationException(AppConstants.FAIL, "UserID is null.");
		    }

		   /* List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
	        Map<String, Object> sParams = new HashMap<String, Object>();
	        sParams.put("salesOrdNo", param.getSrcOrdNo());
	        sParams.put("ticketTypeId", "5675");
	        sParams.put("ticketStusId", "1");
	        sParams.put("userId", param.getRegId());
	        arrParams.add(sParams);

	        param.getBasic().setCrtUserId(loginVO.getUserId());
	        param.getBasic().setUpdUserId(loginVO.getUserId());

	        int mobTicketNo = mobileAppTicketApiCommonService.updateWsLoyaltyList(arrParams);*/


	     /*   Map<String, Object> loginInfoMap = new HashMap<String, Object>();
	        loginInfoMap.put("_USER_ID", param.getRegId());
	        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
	        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
	            throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
	        }
	        param.setWhLocId(loginVO.getUserId());
	        return stockAuditApiMapper.selectStockAuditList(StockAuditApiFormDto.createMap(param));

	            customerMap.put("updUserId", loginVO.getUserId());

    customerMap.put("crtUserId", loginVO.getUserId());
	    }*/

		Map<String, Object> sal0271d = new HashMap<String, Object>();
		sal0271d.put("loyaltyId", param.getLoyaltyId());
	//	sal0271d.put("salesOrdId", param.getSalesOrdId());
		sal0271d.put("salesOrdNo", param.getSalesOrdNo());
		sal0271d.put("stus", param.getStus());
	//	sal0271d.put("custID", param.getCustID());
		sal0271d.put("hpCallReasonCode", param.getHpCallReasonCode());
		sal0271d.put("hpCallRemark", param.getHpCallRemark());
		sal0271d.put("updUserId", loginVO.getUserId());

	   int saveCnt = royaltyCustomerListApiMapper.updateWsLoyaltyList(sal0271d);
	   if( saveCnt != 1 ){
           throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
       }


		return param;
	}


	 @Override
	    public List<EgovMap> waterPurifierResult( RoyaltyCustomerListApiForm param) {
		//public List<EgovMap> selectWsLoyaltyList( RoyaltyCustomerListApiDto param) throws Exception {
			// TODO Auto-generated method stub
	      //  param.setWhLocId(loginVO.getUserId());

	    /*	 if( CommonUtils.isEmpty(param.getRegId()) ){
	             throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
	         }*/

	    	 Map<String, Object> loginInfoMap = new HashMap<String, Object>();
	         loginInfoMap.put("_USER_ID", param.getRegId());
	         LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
	         if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
	             throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
	         }
	         loginInfoMap.put("loyaltyId", param.getLoyaltyId());
	         //param.put("loyaltyId", param.getLoyaltyId());
	         param.setWhLocId(loginVO.getUserId());
	         param.setLoyaltyId(param.getLoyaltyId());


			return royaltyCustomerListApiMapper.waterPurifierResult(RoyaltyCustomerListApiForm.createMap(param));
		}

}
