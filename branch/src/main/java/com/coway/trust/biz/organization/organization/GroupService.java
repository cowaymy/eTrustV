package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GroupService {

	int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList);

	List<EgovMap> selectGroupMstList(Map<String, Object> params);

	EgovMap selectGroupInfo(Map<String, Object> params);

	void callGroupConfirm(Map<String, Object> params);

	int updGroupReject(Map<String, Object> params);
}
