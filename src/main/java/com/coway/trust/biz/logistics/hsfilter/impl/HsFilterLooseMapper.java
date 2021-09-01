
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.util.List;


import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HsFilterLooseMapper")
public interface HsFilterLooseMapper{

	List<EgovMap> selectHSFilterLooseList(Map<String, Object> params);

	List<EgovMap> selectHSFilterLooseMiscList(Map<String, Object> params);

	List<EgovMap> selectMiscBranchList(Map<String, Object> params);

	List<EgovMap> selectMappingLocationType(Map<String, Object> params);
	List<EgovMap> selectMappingCdbLocationList(Map<String, Object> params);

	List<EgovMap> selectHSFilterMappingList(Map<String, Object> params);









	void  updateMergeLOG0107M(Map<String, Object> params);


	void  updateMergeLOG0109M(Map<String, Object> params);



}
