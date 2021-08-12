package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.PageAuthVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MenuService {
  List<EgovMap> getMenuList(SessionVO sessionVO);
  
  List<EgovMap> getFavoritesList(SessionVO sessionVO);
  
  PageAuthVO getPageAuth(Map<String, Object> params);
  
  EgovMap getMenuAuthByPgmPath(Map<String, Object> params);
  
  int getCountCommAuth(Map<String, Object> params);
}
