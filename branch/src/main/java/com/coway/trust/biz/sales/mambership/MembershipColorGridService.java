package com.coway.trust.biz.sales.mambership;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MembershipColorGridService {

	List<EgovMap> membershipColorGridList(Map<String, Object> params);

}
