package com.coway.trust.biz.services.as;

import java.util.List;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 *********************************************************************************************/
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InHouseRepairService {

  List<EgovMap> selInhouseList(Map<String, Object> params);

  List<EgovMap> selInhouseDetailList(Map<String, Object> params);

  List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params);

  List<EgovMap> getCallLog(Map<String, Object> params);

  List<EgovMap> getProductMasters(Map<String, Object> params);

  List<EgovMap> getProductDetails(Map<String, Object> params);

  EgovMap isAbStck(Map<String, Object> params);

}
