package com.coway.trust.biz.organization.memberApi;

import java.util.List;

import com.coway.trust.api.mobile.organization.memberApi.MemberApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MemberApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 09.    KR-JAEMJAEM:)   First creation
 * 2020. 04. 09.    MY-ONGHC         Restructure Messy Code
 *          </pre>
 */
public interface MemberApiService {

  List<EgovMap> selectMemberList(MemberApiForm param) throws Exception;
}
