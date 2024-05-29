package com.coway.trust.biz.supplement;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 14/05/2024    TOMMY      1.0.1       - RE-STRUCTURE SupplementSubmissionService
 *
 *********************************************************************************************/

public interface SupplementSubmissionService {

  List<EgovMap> selectSupplementSubmissionJsonList(Map<String, Object> params) throws Exception;

  List<EgovMap> selectSupplementSubmissionItmList(Map<String, Object> params)throws Exception;

  int selectExistSupplementSubmissionSofNo(Map<String, Object> params);

  List<EgovMap> selectSupplementItmList(Map<String, Object> params) throws Exception;

  List<EgovMap> chkSupplementStockList(Map<String, Object> params) throws Exception;

  EgovMap selectMemBrnchByMemberCode(Map<String, Object> params);

  EgovMap selectMemberByMemberIDCode(Map<String, Object> params);

  Map<String, Object> supplementSubmissionRegister(Map<String, Object> params) throws Exception;

  List<EgovMap> getAttachList(Map<String, Object> params);

  EgovMap selectSupplementSubmissionView(Map<String, Object> params)throws Exception;

  List<EgovMap> selectSupplementSubmissionItmView(Map<String, Object> params)throws Exception;

  Map<String, Object> updateSubmissionApprovalStatus(Map<String, Object> params) throws Exception;

  Map<String, Object> SP_LOGISTIC_REQUEST_SUPP(Map<String, Object> param);
}