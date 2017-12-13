package com.coway.trust.biz.services.tagMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("tagMgmtMapper")
public interface TagMgmtMapper {

	public List<EgovMap> selectTagStatus(Map<String, Object> params);

	public EgovMap selectDetailTagStatus(Map<String, Object> params);

	public int insertCcr0006d(Map<String, Object> params);

	public EgovMap selectCallEntryId(Map<String, Object> params);

	public int insertCcr0007d(Map<String, Object> params);

	public int updateCcr0006d(Map<String, Object> params);

}
