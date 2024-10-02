package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AreaManagementService {

	List<EgovMap> selectAreaManagement(Map<String, Object> params) throws Exception;

	int udtAreaManagement(List<Object> udtList, String loginId);

	int addCopyAddressMaster(List<Map<String, Object>> updateList , String loginId);

	int addCopyOtherAddressMaster(List<Map<String, Object>> updateList , String loginId);

	int addOtherAddressMaster(List<Object> updateList , String loginId);

	int addMyAddressMaster(List<Object> updateList , String loginId);

	List<EgovMap> selectMyPostcode(Map<String, Object> params) throws Exception;

	List<EgovMap> selectBlackArea(Map<String, Object> params)throws Exception;

	List<EgovMap> selectProductCategory(Map<String, Object> params)throws Exception;

	List<EgovMap> selectBlacklistedArea(Map<String, Object> params)throws Exception;

	String insertBlacklistedArea(Map<String, Object> param);

	/**
	 * 동일한 Area 건수 조회.
	 * @Author KR-SH
	 * @Date 2019. 11. 18.
	 * @param paramList
	 * @return
	 */
	public boolean isRedupAddCopyAddressMaster(List<Map<String, Object>> paramList);

}
