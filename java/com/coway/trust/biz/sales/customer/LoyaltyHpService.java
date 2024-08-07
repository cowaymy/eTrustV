package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LoyaltyHpService {

	int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList );

	List<EgovMap> selectLoyaltyHpMstList(Map<String, Object> params);

	EgovMap selectLoyaltyHpInfo(Map<String, Object> params);

	void callLoyaltyHpConfirm(Map<String, Object> params);

	int updLoyaltyHpReject(Map<String, Object> params);
}
