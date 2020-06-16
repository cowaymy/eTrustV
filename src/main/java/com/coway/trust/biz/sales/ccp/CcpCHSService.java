package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface  CcpCHSService {

  int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList );

  List<EgovMap> selectCcpCHSMstList(Map<String, Object> params);

  EgovMap selectCHSInfo(Map<String, Object> params);


}
