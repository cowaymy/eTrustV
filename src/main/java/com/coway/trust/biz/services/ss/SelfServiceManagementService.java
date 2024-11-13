package com.coway.trust.biz.services.ss;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SelfServiceManagementService {

  List<EgovMap> selectSelfServiceJsonList(Map<String, Object> params) throws Exception;

  List<EgovMap> selectSelfServiceFilterItmList(Map<String, Object> params) throws Exception;

  Map<String, Object> saveSelfServiceResult(Map<String, Object> params) throws Exception;

  Map<String, Object> updateSelfServiceResultStatus(Map<String, Object> params) throws Exception;

  EgovMap selectSelfServiceResultInfo(Map<String, Object> params);

  List<EgovMap> getSelfServiceFilterList(Map<String, Object> params) throws Exception;

  List<EgovMap> getSelfServiceDelivryList(Map<String, Object> params) throws Exception;

  List<EgovMap> getSelfServiceRtnItmDetailList(Map<String, Object> params) throws Exception;

  Map<String, Object> updateReturnGoodsQty( Map<String, Object> params ) throws Exception;

  List<EgovMap> getSelfServiceRtnItmList(Map<String, Object> params) throws Exception;

  int saveValidation(Map<String, Object> params);

  List<EgovMap> ssFailReasonList(Map<String, Object> params);

}