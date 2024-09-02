package com.coway.trust.biz.services.miles.impl;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.miles.MilesMeasService;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 15/08/2023    ONGHC      1.0.1          - INITIAL MilesMeasServiceImpl
 *********************************************************************************************/

@Service("milesMeasService")
public class MilesMeasServiceImpl implements MilesMeasService {

  private static final Logger logger = LoggerFactory.getLogger(MilesMeasService.class);

  @Resource(name = "milesMeasMapper")
  private MilesMeasMapper milesMeasMapper;

  @Override
  public List<EgovMap> getMilesMeasMasterList(Map<String, Object> params) {
    return milesMeasMapper.getMilesMeasMasterList(params);
  }

  @Override
  public List<EgovMap> getMilesMeasList(Map<String, Object> params) {
    return milesMeasMapper.getMilesMeasList(params);
  }

  @Override
  public List<EgovMap> getMilesMeasDetailList(Map<String, Object> params) {
    return milesMeasMapper.getMilesMeasDetailList(params);
  }

  @Override
  public List<EgovMap> getMilesMeasRaw(Map<String, Object> params) {
    return milesMeasMapper.getMilesMeasRaw(params);
  }

  @Override
  public List<EgovMap> selectSrvStat() {
    return milesMeasMapper.selectSrvStat();
  }

  @Override
  public List<EgovMap> selectSrvFailInst() {
    return milesMeasMapper.selectSrvFailInst();
  }

}
