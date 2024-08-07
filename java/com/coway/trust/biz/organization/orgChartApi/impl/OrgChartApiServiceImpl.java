package com.coway.trust.biz.organization.orgChartApi.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
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
        if( CommonUtils.isEmpty(param.getLoginMemId()) ){
            throw new ApplicationException(AppConstants.FAIL, "Login MemId value does not exist.");
        }
        //1(HP), 2(CD), 3(CT), 7(HT), 5758(HDT)
        if( param.getMemType() !=  1 && param.getMemType() != 2 && param.getMemType() !=  3 && param.getMemType() != 7 && param.getMemType() != 5758){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Member Type.");
        }

        EgovMap selectOrg = orgChartApiMapper.selectOrg(OrgChartApiForm.createMap(param));
        if (MapUtils.isEmpty(selectOrg)) {
            throw new ApplicationException(AppConstants.FAIL, "Member value does not exist.");
        }
        if( CommonUtils.isEmpty(selectOrg.get("selectMemId")) || Integer.parseInt(selectOrg.get("selectMemId").toString()) == 0){
            throw new ApplicationException(AppConstants.FAIL, "selectMemId value does not exist.");
        }
        if( CommonUtils.isEmpty(selectOrg.get("selectMemUpId")) || Integer.parseInt(selectOrg.get("selectMemUpId").toString()) == 0){
            throw new ApplicationException(AppConstants.FAIL, "selectMemUpId value does not exist.");
        }
        if( CommonUtils.isEmpty(selectOrg.get("selectMemLvl")) || Integer.parseInt(selectOrg.get("selectMemLvl").toString()) == 0){
            throw new ApplicationException(AppConstants.FAIL, "selectMemLvl value does not exist.");
        }

        param.setSelectMemId( Integer.parseInt(selectOrg.get("selectMemId").toString()) );
        param.setSelectMemUpId( Integer.parseInt(selectOrg.get("selectMemUpId").toString()) );
        param.setSelectMemLvl( Integer.parseInt(selectOrg.get("selectMemLvl").toString()) );

        System.out.println("setSelectMemId : " + param.getSelectMemId());
        System.out.println("setSelectMemUpId : " + param.getSelectMemUpId());
        System.out.println("setSelectMemLvl : " + param.getSelectMemLvl());
		return orgChartApiMapper.selectOrgChart(OrgChartApiForm.createMap(param));
	}
}
