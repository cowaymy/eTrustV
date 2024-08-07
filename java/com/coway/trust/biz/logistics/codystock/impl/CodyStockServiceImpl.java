package com.coway.trust.biz.logistics.codystock.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.biz.logistics.codystock.CodyStockService;
import com.coway.trust.biz.logistics.totalstock.impl.TotalStockMapper;

@Service("CodyStockService")
public class CodyStockServiceImpl extends EgovAbstractServiceImpl implements CodyStockService {
  
  private final Logger logger = LoggerFactory.getLogger(this.getClass());
  @Resource(name = "CodyStockMapper")
  private CodyStockMapper CodyStockMapper;
  
  @Override
  public List<EgovMap> selectBranchList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return CodyStockMapper.selectBranchList(params);
  }
  
  @Override
  public List<EgovMap> getDeptCodeList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return CodyStockMapper.getDeptCodeList(params);
  }
  
  @Override
  public List<EgovMap> getCodyCodeList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return CodyStockMapper.getCodyCodeList(params);
  }

  @Override
  public List<EgovMap> selectCMGroupList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return CodyStockMapper.selectCMGroupList(params);
  }
  
}
