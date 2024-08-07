package com.coway.trust.biz.organization.memberApi.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.organization.memberApi.MemberApiForm;
import com.coway.trust.biz.organization.memberApi.MemberApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MemberApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 09.    KR-JAEMJAEM:)   First creation
 * 2020. 04. 09.    MY-ONGHC         Add User Name Verification
 *          </pre>
 */
@Service("MemberApiService")
public class MemberApiServiceImpl extends EgovAbstractServiceImpl implements MemberApiService {

  @Resource(name = "MemberApiMapper")
  private MemberApiMapper memberApiMapper;

  @Override
  public List<EgovMap> selectMemberList(MemberApiForm param) throws Exception {
    if (null == param) {
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getMemType())) {
      throw new ApplicationException(AppConstants.FAIL, "Member type value does not exist.");
    }
    if (CommonUtils.isEmpty(param.getSelectDivision())) {
      if (CommonUtils.isEmpty(param.getSelectType())) {
        throw new ApplicationException(AppConstants.FAIL, "Select type value does not exist.");
      }
      if (CommonUtils.isEmpty(param.getSelectKeyword())) {
        throw new ApplicationException(AppConstants.FAIL, "Select keyword value does not exist.");
      }
      if (CommonUtils.isEmpty(param.getUserName())) {
        throw new ApplicationException(AppConstants.FAIL, "User Name value does not exist.");
      }
      if (param.getSelectKeyword().length() < 5) {
        throw new ApplicationException(AppConstants.FAIL, "Please fill out at least five characters.");
      }
    }
    return memberApiMapper.selectMemberList(MemberApiForm.createMap(param));
  }
}
