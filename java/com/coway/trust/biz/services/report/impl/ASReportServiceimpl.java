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
  public List<EgovMap> selectMemberCodeList2(Map<String, Object> params) {
    return ASReportMapper.selectMemberCodeList2(params);
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

  @Override
  public List<EgovMap> selectProductList() {
    return ASReportMapper.selectProductList();
  }

  @Override
  public List<EgovMap> selectDefectTypeList() {
    return ASReportMapper.selectDefectTypeList();
  }

  @Override
  public List<EgovMap> selectDefectRmkList() {
    return ASReportMapper.selectDefectRmkList();
  }

  @Override
  public List<EgovMap> selectDefectDescList() {
    return ASReportMapper.selectDefectDescList();
  }

  @Override
  public List<EgovMap> selectDefectDescSymptomList() {
    return ASReportMapper.selectDefectDescSymptomList();
  }

  @Override
  public List<EgovMap> selectProductTypeList() {
    return ASReportMapper.selectProductTypeList();
  }

  @Override
  public List<EgovMap> selectHCDefectDescSymptomList() {
    return ASReportMapper.selectHCDefectDescSymptomList();
  }

  @Override
  public List<EgovMap> selectHCProductList() {
    return ASReportMapper.selectHCProductList();
  }

  @Override
  public List<EgovMap> selectHCProductCategory() {
    return ASReportMapper.selectHCProductCategory();
  }

  @Override
  public List<EgovMap> selectHCDefectTypeList() {
    // TODO Auto-generated method stub
    return ASReportMapper.selectHCDefectTypeList();
  }

  @Override
  public List<EgovMap> selectHCDefectRmkList() {
    // TODO Auto-generated method stub
    return ASReportMapper.selectHCDefectRmkList();
  }

  @Override
  public List<EgovMap> selectHCDefectDescList() {
    // TODO Auto-generated method stub
    return ASReportMapper.selectHCDefectDescList();
  }
}
