package com.coway.trust.biz.services.tagMgmt;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/12/2019    ONGHC      1.0.1       - RE-STRUCTURE TagMgmtService
 *                                      - ADD FILE UPLOAD FUNCTION
 *********************************************************************************************/

public interface TagMgmtService {

  List<EgovMap> getTagStatus(Map<String, Object> params);

  EgovMap getDetailTagStatus(Map<String, Object> params);

  List<EgovMap> getTagMgntStat(Map<String, Object> params);

  int addRemarkResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  List<EgovMap> getTagRemark(Map<String, Object> params);

  List<EgovMap> getMainDeptList();

  List<EgovMap> getSubDeptList(Map<String, Object> params);

  List<EgovMap> getSubDeptListCodySupport(Map<String, Object> params, SessionVO sessionVO);

  List<EgovMap> getMainInquiryList();

  List<EgovMap> getSubInquiryList(Map<String, Object> params);

  EgovMap getOrderInfo(Map<String, Object> params);

  EgovMap getCallerInfo(Map<String, Object> params);

  EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params);

  EgovMap selectOrderServiceMemberViewByOrderID(Map<String, Object> params);

  List<EgovMap> getAttachList(Map<String, Object> params);

  List<EgovMap> getAttachList2(Map<String, Object> params);

  List<EgovMap> selectCmGroup(Map<String, Object> params);

  EgovMap selectCmGroupByUsername(Map<String, Object> params);

  List<EgovMap> getUpdInstllationStat(Map<String, Object> params);

  List<EgovMap> selectUpdateInstallationAddressRequest(Map<String, Object> params);

  int insertInstallAddress(Map<String, Object> params);

  int updateInstallInfo(Map<String, Object> params);

  int updateRequestStatus(Map<String, Object> params);

  EgovMap getEmailDetails(Map<String, Object> params);
}
