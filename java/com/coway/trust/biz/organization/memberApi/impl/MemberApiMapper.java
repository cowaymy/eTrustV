package com.coway.trust.biz.organization.memberApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MemberApiMapper.java
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
@Mapper("MemberApiMapper")
public interface MemberApiMapper {

  List<EgovMap> selectMemberList(Map<String, Object> params);
}
