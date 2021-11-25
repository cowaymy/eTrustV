package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LoyaltyHPStatusReportService {

	List<EgovMap> selectOrgCode(Map<String, Object> params);

}
