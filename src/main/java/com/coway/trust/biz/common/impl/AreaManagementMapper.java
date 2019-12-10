package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("areaManagementMapper")
public interface AreaManagementMapper {

	List<EgovMap> selectAreaManagement(Map<String, Object> params) throws Exception;

	int udtAreaManagement(Map<String, Object> params);

	int addCopyAddressMaster(Map<String, Object> params);

	int addCopyOtherAddressMaster(Map<String, Object> params);

	int addOtherAddressMaster(Map<String, Object> params);

	int addMyAddressMaster(Map<String, Object> params);

	List<EgovMap> selectMyPostcode(Map<String, Object> params) throws Exception;

	/**
	 * 동일한 Area 건수 조회.
	 * @Author KR-SH
	 * @Date 2019. 11. 18.
	 * @param params
	 * @return
	 */
	int isRedupAddCopyAddressMaster(Map<String, Object> params);

}
