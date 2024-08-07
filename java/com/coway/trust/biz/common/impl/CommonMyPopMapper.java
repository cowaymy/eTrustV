package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("commonMyPopMapper")
public interface CommonMyPopMapper {
	List<EgovMap> selectDefaultList(Map<String, Object> params);	
}
