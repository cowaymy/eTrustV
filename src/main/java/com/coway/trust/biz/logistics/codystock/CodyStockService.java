package com.coway.trust.biz.logistics.codystock;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CodyStockService {
  
  List<EgovMap> selectBranchList(Map<String, Object> params);
  
  List<EgovMap> getDeptCodeList(Map<String, Object> params);

  List<EgovMap> getCodyCodeList(Map<String, Object> params);

  List<EgovMap> selectCMGroupList(Map<String, Object> params);
  
}
