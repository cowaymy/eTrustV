package com.coway.trust.biz.logistics.itembt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("trBookMapper")
public interface TRBookMapper {

	List<EgovMap> selectTrBookManagement(Map<String, Object> params);

}
