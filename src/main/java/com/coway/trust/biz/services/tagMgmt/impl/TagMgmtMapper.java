package com.coway.trust.biz.services.tagMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/12/2019    ONGHC      1.0.1       - RE-STRUCTURE TagMgmtMapper
 *                                      - ADD FILE UPLOAD FUNCTION
 *********************************************************************************************/

@Mapper("tagMgmtMapper")
public interface TagMgmtMapper {

  public List<EgovMap> selectTagStatus(Map<String, Object> params);

  public List<EgovMap> getTagMgntStat(Map<String, Object> params);

  public EgovMap selectDetailTagStatus(Map<String, Object> params);

  public int insertCcr0006d(Map<String, Object> params);

  public int insertCcr0015d(Map<String, Object> params);

  public EgovMap selectCallEntryId(Map<String, Object> params);

  public int insertCcr0007d(Map<String, Object> params);

  public int updateCcr0006d(Map<String, Object> params);

  public List<EgovMap> selectTagRemarks(Map<String, Object> params);

  public List<EgovMap> selectMainDept();

  public List<EgovMap> selectSubDept(Map<String, Object> params);

  public List<EgovMap> selectSubDeptCodySupport(Map<String, Object> params);

  public List<EgovMap> selectMainInquiryList();

  public List<EgovMap> selectSubInquiryList(Map<String, Object> params);

  public EgovMap getOrderInfo(Map<String, Object> params);

  public EgovMap getCallerInfo(Map<String, Object> params);

  public EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params);

  public EgovMap selectOrderServiceMemberViewByOrderID(Map<String, Object> params);

  public List<EgovMap> selectAttachList(Map<String, Object> params);

  public List<EgovMap> selectAttachList2(Map<String, Object> params);

  public List<EgovMap> selectCmGroup(Map<String, Object> params);

  public EgovMap selectCmGroupByUsername(Map<String, Object> params);

  public List<EgovMap> getUpdInstllationStat(Map<String, Object> params);

  public List<EgovMap> selectUpdateInstallationAddressRequest(Map<String, Object> params);

  public int insertInstallAddress(Map<String, Object> params);

  public int updateInstallInfo(Map<String, Object> params);

  public int updateRequestStatus(Map<String, Object> params);

  EgovMap getEmailDetails(Map<String, Object> params);

}
