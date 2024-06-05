package com.coway.trust.biz.supplement.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("supplementUpdateMapper")
public interface SupplementUpdateMapper {


	List<EgovMap> selectSupplementList(Map<String, Object> params);

	List<EgovMap> selectPosJsonList(Map<String, Object> params);

	List<EgovMap> selectSupRefStus();

	List<EgovMap> selectSupRefStg();

	List<EgovMap> selectSubmBrch();

	List<EgovMap> selectWhBrnchList();

	List<EgovMap> getSupplementDetailList(Map<String, Object> params);

	EgovMap selectOrderBasicInfo(Map<String, Object> params);

	List<EgovMap> checkDuplicatedTrackNo(Map<String, Object> params);

	//void updateRefStgStatus(Map<String, Object> transactionId);

	int updateRefStgStatus(Map<String, Object> params);

}
