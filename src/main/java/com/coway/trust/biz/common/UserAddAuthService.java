package com.coway.trust.biz.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface UserAddAuthService {

	List<EgovMap> selectUserAddAuthList(Map<String, Object> params, SessionVO sessionVO);

	void saveUserAddAuthList(Map<String, ArrayList<Object>> params, SessionVO sessionVO);

	List<EgovMap> selectCommonCodeList(Map<String, Object> params);

}
