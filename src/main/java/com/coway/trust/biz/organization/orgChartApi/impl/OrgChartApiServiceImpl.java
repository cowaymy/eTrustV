package com.coway.trust.biz.organization.orgChartApi.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.organization.orgChartApi.OrgChartApiForm;
import com.coway.trust.biz.organization.orgChartApi.OrgChartApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : OrgChartApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("OrgChartApiService")
public class OrgChartApiServiceImpl extends EgovAbstractServiceImpl implements OrgChartApiService{



	@Resource(name = "OrgChartApiMapper")
	private OrgChartApiMapper orgChartApiMapper;



	@Override
	public List<EgovMap> selectOrgChart(OrgChartApiForm param) throws Exception {
		if( null == param ){
			throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
		}
		if( CommonUtils.isEmpty(param.getMemType()) ){
		    throw new ApplicationException(AppConstants.FAIL, "Member Type value does not exist.");
		}
        if( CommonUtils.isEmpty(param.getMemLvl()) ){
            throw new ApplicationException(AppConstants.FAIL, "Member Level value does not exist.");
        }
		return orgChartApiMapper.selectOrgChart(OrgChartApiForm.createMap(param));
	}
}
