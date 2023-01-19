package com.coway.trust.biz.common.userProfileApi.impl;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiDto;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiForm;
import com.coway.trust.biz.common.userProfileApi.UserProfileApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : UserProfileApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 11. 01.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("UserProfileApiService")
public class UserProfileApiServiceImpl extends EgovAbstractServiceImpl implements UserProfileApiService{



    @Resource(name = "UserProfileApiMapper")
	private UserProfileApiMapper userProfileApiMapper;



    @Override
    public UserProfileApiDto selectUserProfile(UserProfileApiForm param) throws Exception {
        if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getUserName()) ){
            throw new ApplicationException(AppConstants.FAIL, "User name value does not exist.");
        }
        EgovMap selectUserProfile = userProfileApiMapper.selectUserProfile(UserProfileApiForm.createMap(param));
        UserProfileApiDto rtn = new UserProfileApiDto();
        if( MapUtils.isNotEmpty(selectUserProfile) ){
            return rtn.create(selectUserProfile);
        }
        return rtn;
    }

    @Override
    public UserProfileApiDto selectUserRole(UserProfileApiForm param) throws Exception {
        if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getUserName()) ){
            throw new ApplicationException(AppConstants.FAIL, "User name value does not exist.");
        }
        EgovMap selectUserProfile = userProfileApiMapper.selectUserRole(UserProfileApiForm.createMap(param));
        UserProfileApiDto rtn = new UserProfileApiDto();
        if( MapUtils.isNotEmpty(selectUserProfile) ){
            return rtn.create(selectUserProfile);
        }
        return rtn;
    }
}
