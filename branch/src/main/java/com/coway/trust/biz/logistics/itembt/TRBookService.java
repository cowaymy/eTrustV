package com.coway.trust.biz.logistics.itembt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TRBookService {

	List<EgovMap> selectTrBookManagement(Map<String, Object> params);

}
