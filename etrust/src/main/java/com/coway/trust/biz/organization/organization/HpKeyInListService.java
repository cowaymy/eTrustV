package com.coway.trust.biz.organization.organization;

import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface HpKeyInListService {

	List<EgovMap> reqPersonComboList();
	List<EgovMap> branchComboList();
	
}
