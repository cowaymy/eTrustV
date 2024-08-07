package com.coway.trust.biz.logistics.useFilterBlock;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface useFilterBlockService
{
  List<EgovMap> searchUseFilterBlockList(Map<String, Object> params);

  EgovMap selectUseFilterBlockInfo(Map<String, Object> params);

  void saveUseFilterBlock(Map<String, Object> params, SessionVO sessionVO);
}