package com.coway.trust.biz.services.as.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiForm;
import com.coway.trust.api.mobile.services.as.SyncIhrApiForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.services.as.IhrApiService;
import com.coway.trust.biz.services.as.ServiceApiASDetailService;
import com.coway.trust.biz.services.as.ServiceApiASService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ServiceApiASServiceImpl.java
 * @Description : Mobile After Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 20.   Jun             First creation
 */
@Service("ihrApiService")
public class IhrApiServiceImpl extends EgovAbstractServiceImpl implements IhrApiService {
	private static final Logger logger = LoggerFactory.getLogger(IhrApiServiceImpl.class);

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "IhrApiServiceMapper")
	private IhrApiServiceMapper ihrApiServiceMapper;

    @Autowired
    private LoginMapper loginMapper;

	@Override
	public List<EgovMap> selectSyncIhr(SyncIhrApiForm param) {

   	 Map<String, Object> loginInfoMap = new HashMap<String, Object>();
     loginInfoMap.put("_USER_ID", param.getRegId());
     /*LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
     if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
         throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
     }*/
     //param.setWhLocId(loginVO.getUserId());

	//return royaltyCustomerListApiMapper.selectWsLoyaltyList();
	return ihrApiServiceMapper.selectSyncIhr(SyncIhrApiForm.createMap(param));

	}


}
