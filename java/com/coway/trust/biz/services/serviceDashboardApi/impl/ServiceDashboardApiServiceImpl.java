package com.coway.trust.biz.services.serviceDashboardApi.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.services.serviceDashboardApi.ServiceDashboardApiForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.services.serviceDashboardApi.ServiceDashboardApiService;
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
@Service("ServiceDashboardApiService")
public class ServiceDashboardApiServiceImpl extends EgovAbstractServiceImpl implements ServiceDashboardApiService{

     @Autowired
     private LoginMapper loginMapper;

	@Resource(name = "ServiceDashboardApiMapper")
	private ServiceDashboardApiMapper serviceDashboardApiMapper;



	 @Override
	    public List<EgovMap> selectCsStatusDashboard( ServiceDashboardApiForm param) {

			return serviceDashboardApiMapper.selectCsStatusDashboard(ServiceDashboardApiForm.createMap(param));
		}

}
