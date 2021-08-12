package com.coway.trust.biz.sales.mambership;

import java.util.List;

import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MembershipRejoinService {

  List<EgovMap> selectRejoinList(Map<String, Object> params);

  List<EgovMap> selectExpiredMembershipList(Map<String, Object> params);

}
