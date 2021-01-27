package com.coway.trust.biz.services.report.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.report.ASReportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 26/07/2019    ONGHC      1.0.1       - Add Recall Status
 *********************************************************************************************/

@Service("ASReportService")
public class ASReportServiceimpl extends EgovAbstractServiceImpl implements ASReportService {

  @Resource(name = "ASReportMapper")
  private ASReportMapper ASReportMapper;

  @Override
  public List<EgovMap> selectMemberCodeList(Map<String, Object> params) {
    return ASReportMapper.selectMemberCodeList(params);
  }

  @Override
  public EgovMap selectOrderNum() {
    return ASReportMapper.selectOrderNum();
  }

  @Override
  public List<EgovMap> selectViewLedger(Map<String, Object> params) {
    return ASReportMapper.selectViewLedger(params);
  }

  @Override
  public List<EgovMap> selectMemCodeList() {
    return ASReportMapper.selectMemCodeList();
  }

  @Override
  public List<EgovMap> selectAsLogBookTyp() {
    return ASReportMapper.selectAsLogBookTyp();
  }

  @Override
  public List<EgovMap> selectAsLogBookGrp() {
    return ASReportMapper.selectAsLogBookGrp();
  }

  @Override
  public List<EgovMap> selectAsSumTyp() {
    return ASReportMapper.selectAsSumTyp();
  }

  @Override
  public List<EgovMap> selectAsSumStat() {
    return ASReportMapper.selectAsSumStat();
  }

  @Override
  public List<EgovMap> selectAsYsTyp() {
    return ASReportMapper.selectAsYsTyp();
  }

  @Override
  public List<EgovMap> selectAsYsAge() {
    return ASReportMapper.selectAsYsAge();
  }

  @Override
  public List<EgovMap> selectBranchList(Map<String, Object> params) {
    return ASReportMapper.selectBranchList(params);
  }
}
