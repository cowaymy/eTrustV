package com.coway.trust.biz.services.report.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.report.IHReportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 23/08/2019    ONGHC      1.0.0       - CREATE FOR IN HOUSE REPAIR
 *********************************************************************************************/

@Service("IHReportService")
public class IHReportServiceimpl extends EgovAbstractServiceImpl implements IHReportService {

  @Resource(name = "IHReportMapper")
  private IHReportMapper IHReportMapper;

  @Override
  public List<EgovMap> selectMemberCodeList(Map<String, Object> params) {
    return IHReportMapper.selectMemberCodeList(params);
  }

  @Override
  public EgovMap selectOrderNum() {
    return IHReportMapper.selectOrderNum();
  }

  @Override
  public List<EgovMap> selectViewLedger(Map<String, Object> params) {
    return IHReportMapper.selectViewLedger(params);
  }

  @Override
  public List<EgovMap> selectMemCodeList() {
    return IHReportMapper.selectMemCodeList();
  }

  @Override
  public List<EgovMap> selectAsLogBookTyp() {
    return IHReportMapper.selectAsLogBookTyp();
  }

  @Override
  public List<EgovMap> selectAsLogBookGrp() {
    return IHReportMapper.selectAsLogBookGrp();
  }

  @Override
  public List<EgovMap> selectAsSumTyp() {
    return IHReportMapper.selectAsSumTyp();
  }

  @Override
  public List<EgovMap> selectAsSumStat() {
    return IHReportMapper.selectAsSumStat();
  }

  @Override
  public List<EgovMap> selectAsYsTyp() {
    return IHReportMapper.selectAsYsTyp();
  }

  @Override
  public List<EgovMap> selectAsYsAge() {
    return IHReportMapper.selectAsYsAge();
  }
}
