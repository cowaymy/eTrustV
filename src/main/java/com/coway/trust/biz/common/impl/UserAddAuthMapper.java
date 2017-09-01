package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("userAddAuthMapper")
public interface UserAddAuthMapper {
	List<EgovMap> selectUserAddAuthList(Map<String, Object> params);

	void insertUserAddAuthList(Map<String, Object> params);

	void updateUserAddAuthList(Map<String, Object> params);

	void deleteUserAddAuthList(Map<String, Object> params);

	List<EgovMap> selectCommonCodeList(Map<String, Object> params);
}
