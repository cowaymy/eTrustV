package com.coway.trust.biz.cmm.dashboard.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.cmm.dashboard.CommissionApiForm;
import com.coway.trust.biz.cmm.dashboard.CommissionApiService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CommissionApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 *  * 2019. 11. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("CommissionApiService")
public class CommissionApiServiceImpl extends EgovAbstractServiceImpl implements CommissionApiService{



	@Resource(name = "CommissionApiMapper")
	private CommissionApiMapper commissionApiMapper;



    @Autowired
    private LoginMapper loginMapper;



    @Override
    public List<EgovMap> selectCommissionDashboard(CommissionApiForm param) throws Exception {
        if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getRegId()) ){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getUserTypeId()) || param.getUserTypeId() < 1 ){
            throw new ApplicationException(AppConstants.FAIL, "Member Type value does not exist.");
        }

        Map<String, Object> loginInfoMap = new HashMap<String, Object>();
        loginInfoMap.put("_USER_ID", param.getRegId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }

        Map<String, Object> createParam = CommissionApiForm.createMap(param);
        createParam.put("userId", loginVO.getUserId());
        List<EgovMap> selectData = null;
        if( param.getUserTypeId() == 1 ){
            selectData = commissionApiMapper.selectCommissionDashbordHP(createParam);//Health Planner
        }else if( param.getUserTypeId() == 2 ){
            selectData = commissionApiMapper.selectCommissionDashbordCD(createParam);//Coway Lady
        }else if( param.getUserTypeId() == 3 ){
            selectData = commissionApiMapper.selectCommissionDashbordCT(createParam);//Coway Technician
        }else{
            throw new ApplicationException(AppConstants.FAIL, "Please check the Member Type.");
        }
        return selectData;
    }
}
