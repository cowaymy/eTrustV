package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("neoProAndHPListMapper")
public interface NeoProAndHPListMapper {

	List<EgovMap> selectNeoProAndHPList(Map<String, Object> params);

	EgovMap checkHpType(Map<String, Object> params);

}
