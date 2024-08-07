package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Mapper("hpKeyInListMapper")
public interface HpKeyInListMapper {
	List<EgovMap> reqPersonComboList();
	
	List<EgovMap> branchComboList();
	
	
}
