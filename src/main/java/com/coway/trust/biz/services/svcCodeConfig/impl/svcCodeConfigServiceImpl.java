package com.coway.trust.biz.services.svcCodeConfig.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.svcCodeConfig.svcCodeConfigService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("svcCodeConfigService")
public class svcCodeConfigServiceImpl
  implements svcCodeConfigService {
  private static final Logger logger = LoggerFactory.getLogger( svcCodeConfigServiceImpl.class );

  @Resource(name = "svcCodeConfigMapper")
  private svcCodeConfigMapper svcCodeConfigMapper;

  @Override
  public EgovMap selectCodeConfigList( Map<String, Object> params ) {
    return svcCodeConfigMapper.selectCodeConfigList( params );
  }

  @Override
  public List<EgovMap> selectSvcCodeConfigList( Map<String, Object> params ) {
    return svcCodeConfigMapper.selectSvcCodeConfigList( params );
  }

  @Override
  public List<EgovMap> selectProductCategoryList() {
    return svcCodeConfigMapper.selectProductCategoryList();
  }

  @Override
  public List<EgovMap> selectStatusCategoryCodeList() {
    return svcCodeConfigMapper.selectStatusCategoryCodeList();
  }

  @Override
  public void saveNewCode( Map<String, Object> params, SessionVO sessionVO ) {
    EgovMap defectId;
    defectId = svcCodeConfigMapper.getDefectId();
    params.put( "defectId", defectId.get( "defectId" ).toString() );
    params.put( "defectGrp", defectId.get( "defectId" ).toString() );
    svcCodeConfigMapper.addDefectCodes( params );
  }

  @Override
  public void updateSvcCode( Map<String, Object> params, SessionVO sessionVO ) {
    svcCodeConfigMapper.updateDefectCodes( params );
  }
}
