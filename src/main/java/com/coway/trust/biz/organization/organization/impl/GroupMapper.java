package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("groupMapper")
public interface GroupMapper {

	int selectNextBatchId();

	int selectNextDetId();

	int insertGroupMst(Map<String, Object> params);

	int insertGroupDtl(Map<String, Object> params);

	void callBatchGroupUpd(Map<String, Object> params);

	List<EgovMap> selectGroupMstList(Map<String, Object> params);

	EgovMap selectGroupMasterInfo(Map<String, Object> params);

	List<EgovMap> selectGroupDetailInfo(Map<String, Object> params);

	int updateGroupMasterStus(Map<String, Object> params);

}
