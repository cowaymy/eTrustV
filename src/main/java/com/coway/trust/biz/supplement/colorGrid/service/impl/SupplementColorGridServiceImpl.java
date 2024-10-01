package com.coway.trust.biz.supplement.colorGrid.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.supplement.colorGrid.service.SupplementColorGridService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplementColorGridService")
public class SupplementColorGridServiceImpl
  extends EgovAbstractServiceImpl
  implements SupplementColorGridService {
  private static final Logger logger = LoggerFactory.getLogger( SupplementColorGridServiceImpl.class );

  @Resource(name = "supplementColorGridMapper")
  private SupplementColorGridMapper supplementColorGridMapper;

  public List<EgovMap> colorGridList( Map<String, Object> params ) {
    return supplementColorGridMapper.colorGridList( params );
  }

  public List<EgovMap> selectProductCategoryList() {
    return supplementColorGridMapper.selectProductCategoryList();
  }

  public List<EgovMap> colorGridCmbProduct() {
    return supplementColorGridMapper.colorGridCmbProduct();
  }

  public List<EgovMap> selectSupRefStus() {
    return supplementColorGridMapper.selectSupRefStus();
  }

  public String getMemID( Map<String, Object> params ) {
    return supplementColorGridMapper.getMemID( params );
  }

  @Override
  public List<EgovMap> selectCodeList() {
    return supplementColorGridMapper.selectCodeList();
  }

  @Override
  public List<EgovMap> getSupplementDetailList( Map<String, Object> params ) throws Exception {
    return supplementColorGridMapper.getSupplementDetailList( params );
  }
}
