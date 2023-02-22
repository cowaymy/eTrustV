package com.coway.trust.biz.services.tagMgmt.impl;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.servicePlanning.HolidayService;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/12/2019    ONGHC      1.0.1       - RE-STRUCTURE TagMgmtServiceImpl
 *                                      - ADD FILE UPLOAD FUNCTION
 *********************************************************************************************/

@Service("tagMgmtService")
public class TagMgmtServiceImpl implements TagMgmtService {

  private static final Logger logger = LoggerFactory.getLogger(HolidayService.class);

  @Resource(name = "tagMgmtMapper")
  private TagMgmtMapper tagMgmtMapper;

  @Override
  public List<EgovMap> getTagStatus(Map<String, Object> params) {
    return tagMgmtMapper.selectTagStatus(params);
  }

  @Override
  public List<EgovMap> getTagMgntStat(Map<String, Object> params) {
    return tagMgmtMapper.getTagMgntStat(params);
  }

  @Override
  public EgovMap getDetailTagStatus(Map<String, Object> params) {
    return tagMgmtMapper.selectDetailTagStatus(params);
  }

  @Override
  public int addRemarkResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
    int cnt = 0;

    params.put("userId", sessionVO.getUserId());

    if (params.get("atchFileGrpId") != null) {
      tagMgmtMapper.insertCcr0015d(params);
    }

    EgovMap mapCheckCallEntryId = tagMgmtMapper.selectCallEntryId(params);
    if (mapCheckCallEntryId == null) {
      cnt = tagMgmtMapper.insertCcr0006d(params);
    } else {
      cnt = tagMgmtMapper.updateCcr0006d(params);
    }

    EgovMap mapCallEntryId = tagMgmtMapper.selectCallEntryId(params);
    params.put("callEntryId", mapCallEntryId.get("callEntryId"));

    cnt += tagMgmtMapper.insertCcr0007d(params);

    return cnt;
  }

  @Override
  public List<EgovMap> getTagRemark(Map<String, Object> params) {
    EgovMap mapCallEntryId = tagMgmtMapper.selectCallEntryId(params);
    if (mapCallEntryId != null) {
      params.put("callEntryId", mapCallEntryId.get("callEntryId"));
    }
    return tagMgmtMapper.selectTagRemarks(params);
  }

  @Override
  public List<EgovMap> getMainDeptList() {
    return tagMgmtMapper.selectMainDept();
  }

  @Override
  public List<EgovMap> getSubDeptList(Map<String, Object> params) {
    return tagMgmtMapper.selectSubDept(params);
  }

  @Override
  public List<EgovMap> getSubDeptListCodySupport(Map<String, Object> params, SessionVO sessionVO) {
    return tagMgmtMapper.selectSubDeptCodySupport(params);
  }

  @Override
  public List<EgovMap> getMainInquiryList() {
    return tagMgmtMapper.selectMainInquiryList();
  }

  @Override
  public List<EgovMap> getSubInquiryList(Map<String, Object> params) {
    return tagMgmtMapper.selectSubInquiryList(params);
  }

  @Override
  public EgovMap getOrderInfo(Map<String, Object> params) {
    return tagMgmtMapper.getOrderInfo(params);
  }

  @Override
  public EgovMap getCallerInfo(Map<String, Object> params) {
    return tagMgmtMapper.getCallerInfo(params);
  }

  @Override
  public EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params) {
    return tagMgmtMapper.selectOrderSalesmanViewByOrderID(params);
  }

  @Override
  public EgovMap selectOrderServiceMemberViewByOrderID(Map<String, Object> params) {
    return tagMgmtMapper.selectOrderServiceMemberViewByOrderID(params);
  }

  @Override
  public List<EgovMap> getAttachList(Map<String, Object> params) {
    return tagMgmtMapper.selectAttachList(params);
  }

  @Override
  public List<EgovMap> getAttachList2(Map<String, Object> params) {
    return tagMgmtMapper.selectAttachList2(params);
  }

  @Override
  public List<EgovMap> selectCmGroup(Map<String, Object> params) {
	  return tagMgmtMapper.selectCmGroup(params);
  }

  @Override
  public EgovMap selectCmGroupByUsername(Map<String, Object> params) {
	  return tagMgmtMapper.selectCmGroupByUsername(params);
  }

  @Override
  public List<EgovMap> getUpdInstllationStat(Map<String, Object> params) {
    return tagMgmtMapper.getUpdInstllationStat(params);
  }

  @Override
  public List<EgovMap> selectUpdateInstallationAddressRequest(Map<String, Object> params) {
    return tagMgmtMapper.selectUpdateInstallationAddressRequest(params);
  }

  @Override
  public int insertInstallAddress(Map<String, Object> params) {
		int result =tagMgmtMapper.insertInstallAddress(params);
		return result;
  }

  @Override
  public int updateInstallInfo(Map<String, Object> params) {
		int result =tagMgmtMapper.updateInstallInfo(params);
		return result;
  }

  @Override
  public int updateRequestStatus(Map<String, Object> params) {
		int result =tagMgmtMapper.updateRequestStatus(params);
		return result;
  }

  @Override
  public EgovMap getEmailDetails(Map<String, Object> params){
        return tagMgmtMapper.getEmailDetails(params);
  }

}
