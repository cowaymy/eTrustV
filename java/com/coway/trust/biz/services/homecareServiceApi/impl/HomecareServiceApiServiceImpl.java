package com.coway.trust.biz.services.homecareServiceApi.impl;

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
import com.coway.trust.api.mobile.services.as.HomecareAfterServiceApiForm;
import com.coway.trust.api.mobile.services.installation.HomecareServiceApiForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.royaltyCustomerListApi.RoyaltyCustomerListApiService;
import com.coway.trust.biz.services.homecareServiceApi.HomecareServiceApiService;
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
@Service("HomecareServiceApiService")
public class HomecareServiceApiServiceImpl extends EgovAbstractServiceImpl implements HomecareServiceApiService{

     @Autowired
     private LoginMapper loginMapper;

	@Resource(name = "HomecareServiceApiMapper")
	private HomecareServiceApiMapper homecareServiceApiMapper;

    @Override
    public List<EgovMap> selectPartnerCode( HomecareServiceApiForm param) {

    	 Map<String, Object> loginInfoMap = new HashMap<String, Object>();
         loginInfoMap.put("_USER_ID", param.getRegId());
         LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
         if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
             throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
         }

		return homecareServiceApiMapper.selectPartnerCode(HomecareServiceApiForm.createMap(param));
	}

    @Override
    public List<EgovMap> selectAsPartnerCode( HomecareAfterServiceApiForm param) {

    	 Map<String, Object> loginInfoMap = new HashMap<String, Object>();
         loginInfoMap.put("_USER_ID", param.getRegId());
         LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
         if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
             throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
         }

		return homecareServiceApiMapper.selectAsPartnerCode(HomecareAfterServiceApiForm.createMap(param));
	}


}
