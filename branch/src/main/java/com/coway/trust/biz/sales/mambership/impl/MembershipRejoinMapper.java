package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("membershipRejoinMapper")
public interface MembershipRejoinMapper {

  List<EgovMap> selectRejoinList(Map<String, Object> params);

  List<EgovMap> selectExpiredMembershipList(Map<String, Object> params);

}
