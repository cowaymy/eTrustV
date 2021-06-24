package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("membershipColorGridMapper")
public interface MembershipColorGridMapper {

	List<EgovMap> membershipColorGridList(Map<String, Object> params);

}
