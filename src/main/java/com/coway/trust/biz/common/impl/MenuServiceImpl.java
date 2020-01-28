package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MenuService;
import com.coway.trust.cmmn.model.PageAuthVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("menuService")
public class MenuServiceImpl implements MenuService {
  
  @Autowired
  private MenuMapper menuMapper;
  
  @Override
  @Cacheable(value = AppConstants.LEFT_MENU_CACHE, key = "#sessionVO.getUserId()")
  public List<EgovMap> getMenuList(SessionVO sessionVO) {
    return menuMapper.selectMenuList(sessionVO);
  }
  
  @Override
  @Cacheable(value = AppConstants.LEFT_MY_MENU_CACHE, key = "#sessionVO.getUserId()")
  public List<EgovMap> getFavoritesList(SessionVO sessionVO) {
    return menuMapper.getFavoritesList(sessionVO);
  }
  
  @Override
  public PageAuthVO getPageAuth(Map<String, Object> params) {
    
    /* 2017.12.24 Mundohyun Temporary Setting */
    // PageAuthVO tempVO = new PageAuthVO();
    // tempVO.setFuncView("Y");
    // tempVO.setFuncChange("Y");
    // tempVO.setFuncPrint("Y");
    // tempVO.setFuncUserDefine1("Y");
    // tempVO.setFuncUserDefine2("Y");
    // tempVO.setFuncUserDefine3("Y");
    // tempVO.setFuncUserDefine4("Y");
    // tempVO.setFuncUserDefine5("Y");
    // tempVO.setFuncUserDefine6("Y");
    // tempVO.setFuncUserDefine7("Y");
    // tempVO.setFuncUserDefine8("Y");
    // tempVO.setFuncUserDefine9("Y");
    // tempVO.setFuncUserDefine10("Y");
    // tempVO.setFuncUserDefine11("Y");
    // tempVO.setFuncUserDefine12("Y");
    // tempVO.setFuncUserDefine13("Y");
    // tempVO.setFuncUserDefine14("Y");
    // tempVO.setFuncUserDefine15("Y");
    // tempVO.setFuncUserDefine16("Y");
    // tempVO.setFuncUserDefine17("Y");
    // tempVO.setFuncUserDefine18("Y");
    // tempVO.setFuncUserDefine19("Y");
    // tempVO.setFuncUserDefine20("Y");
    // tempVO.setFuncUserDefine21("Y");
    // tempVO.setFuncUserDefine22("Y");
    // tempVO.setFuncUserDefine23("Y");
    // tempVO.setFuncUserDefine24("Y");
    // tempVO.setFuncUserDefine25("Y");
    
    // return tempVO;
    return menuMapper.selectPageAuth(params);
  }
  
  @Override
  public EgovMap getMenuAuthByPgmPath(Map<String, Object> params) {
    return menuMapper.selectMenuAuthByPgmPath(params);
  }
  
  @Override
  public int getCountCommAuth(Map<String, Object> params) {
    return menuMapper.getCountCommAuth(params);
  }
}
