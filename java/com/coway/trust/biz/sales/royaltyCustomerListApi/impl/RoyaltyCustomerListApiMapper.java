package com.coway.trust.biz.sales.royaltyCustomerListApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ProductInfoListApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("RoyaltyCustomerListApiMapper")
public interface RoyaltyCustomerListApiMapper {


//	List<EgovMap> selectWsLoyaltyList();

	List<EgovMap> selectWsLoyaltyList(Map<String, Object> params);

/*	List<EgovMap> updateWsLoyaltyList();*/

	/*int updateWsLoyaltyList(Map<String, Object> param);*/

	int updateWsLoyaltyList(Map<String, Object> params);

	//List<EgovMap> selectWaterPurifierResultDetailList(Map<String, Object> params);

	List<EgovMap> waterPurifierResult(Map<String, Object> createMap);
}
