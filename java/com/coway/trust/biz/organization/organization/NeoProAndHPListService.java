package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface NeoProAndHPListService {


	List<EgovMap> selectNeoProAndHPList(Map<String, Object> params);

	EgovMap checkHpType(Map<String, Object> params);

}
