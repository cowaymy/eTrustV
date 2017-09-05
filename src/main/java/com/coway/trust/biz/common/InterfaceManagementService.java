package com.coway.trust.biz.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InterfaceManagementService {

	List<EgovMap> selectInterfaceManagementList(Map<String, Object> params, SessionVO sessionVO);

	void saveInterfaceManagementList(Map<String, ArrayList<Object>> params, SessionVO sessionVO);
}
