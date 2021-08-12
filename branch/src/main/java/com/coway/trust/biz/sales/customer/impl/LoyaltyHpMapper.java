package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("loyaltyHpMapper")
public interface LoyaltyHpMapper {

	int selectNextBatchId();

	int selectNextDetId();

	int insertLoyaltyHpMst(Map<String, Object> params);

	int insertLoyaltyHpDtl(Map<String, Object> params);

	void callBatchLoyaltyHpUpd(Map<String, Object> params);

	List<EgovMap> selectLoyaltyHpMstList(Map<String, Object> params);

	EgovMap selectLoyaltyHpMasterInfo(Map<String, Object> params);

	List<EgovMap> selectLoyaltyHpDetailInfo(Map<String, Object> params);

	int updateLoyaltyHpMasterStus(Map<String, Object> params);

}
