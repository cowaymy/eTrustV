package com.coway.trust.biz.api.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CMSApiMapper")
public interface CMSApiMapper {

    int getRowCount(Map<String, Object> params);

    List<EgovMap> selectCmsCntcByPaging(Map<String, Object> params);

}
