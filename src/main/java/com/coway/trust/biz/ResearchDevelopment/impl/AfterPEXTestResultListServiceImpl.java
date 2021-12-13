package com.coway.trust.biz.ResearchDevelopment.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.ResearchDevelopment.AfterPEXTestResultListService;
import com.coway.trust.biz.sales.mambership.impl.MembershipRentalQuotationMapper;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.biz.services.as.impl.ASManagementListMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("AfterPEXTestResultListService")
public class AfterPEXTestResultListServiceImpl extends EgovAbstractServiceImpl implements AfterPEXTestResultListService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AfterPEXTestResultListServiceImpl.class);

	@Resource(name = "AfterPEXTestResultListMapper")
	  private AfterPEXTestResultListMapper AfterPEXTestResultListMapper;

	 @Resource(name = "ASManagementListMapper")
	  private ASManagementListMapper ASManagementListMapper;

	  @Resource(name = "servicesLogisticsPFCMapper")
	  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

	  @Resource(name = "membershipRentalQuotationMapper")
	  private MembershipRentalQuotationMapper membershipRentalQuotationMapper;

	  @Resource(name = "posMapper")
	  private PosMapper posMapper;

	  @Override
	  public List<EgovMap> searchPEXTestResultList(Map<String, Object> params) {
	    return AfterPEXTestResultListMapper.searchPEXTestResultList(params);
	  }

	  @Override
	  public int selRcdTms(Map<String, Object> params) {
	    return AfterPEXTestResultListMapper.selRcdTms(params);
	  }

	  @Override
	  public int chkRcdTms(Map<String, Object> params) {
	    return AfterPEXTestResultListMapper.chkRcdTms(params);
	  }

	  @Override
	  public String getSearchDtRange() {
	    return AfterPEXTestResultListMapper.getSearchDtRange();
	  }

	  @Override
	  public List<EgovMap> getPEXTestResultInfo(Map<String, Object> params) {
	    return AfterPEXTestResultListMapper.getPEXTestResultInfo(params);
	  }

	  @Override
	  public List<EgovMap> getPEXReasonCode2(Map<String, Object> params) {
	    return AfterPEXTestResultListMapper.getPEXReasonCode2(params);
	  }

	  @Override
	  public int isPEXAlreadyResult(Map<String, Object> params) {
	    return AfterPEXTestResultListMapper.isPEXAlreadyResult(params);
	  }

	  @Override
	  public EgovMap PEXResult_Update(Map<String, Object> params) {
	    LOGGER.debug("================PEXResult_Update - START ================");

	    Map<String, Object> svc0125map = (Map<String, Object>) params.get("PEXResultM");
	    svc0125map.put("updator", params.get("updator"));

	    svc0125map.put("TEST_RESULT_ID", svc0125map.get("TEST_RESULT_ID"));
	    //svc0125map.put("UPD_USER_ID", String.valueOf(svc0125map.get("UPD_USER_ID")));

	    LOGGER.debug("====TEST_RESULT_STUS======" + svc0125map.get("TEST_RESULT_STUS"));
	    if (String.valueOf(svc0125map.get("TEST_RESULT_STUS")).equals("4")) {

	    	AfterPEXTestResultListMapper.updatePEXTestResult(svc0125map);
	    	LOGGER.debug("================updatePEXTestResult================" + svc0125map);
	      }

	    EgovMap em = new EgovMap();
	    em.put("TEST_RESULT_NO", svc0125map.get("TEST_RESULT_NO"));

	    LOGGER.debug("================PEXResult_Update - END ================");

	    return em;
	  }

	  @Override
	  public List<EgovMap> selectAsCrtStat() {
	    return ASManagementListMapper.selectAsCrtStat();
	  }

	  @Override
	  public List<EgovMap> selectTimePick() {
	    return ASManagementListMapper.selectTimePick();
	  }

	  @Override
	  public List<EgovMap> selectAsStat() {
	    return ASManagementListMapper.selectAsStat();
	  }

	  @Override
	  public List<EgovMap> asProd() {
	    return ASManagementListMapper.asProd();
	  }

	  @Override
	  public List<EgovMap> getDTAIL_DEFECT_List(Map<String, Object> params) {
	    return ASManagementListMapper.getDTAIL_DEFECT_List(params);
	  }

	  @Override
	  public List<EgovMap> getDEFECT_PART_List(Map<String, Object> params) {
	    return ASManagementListMapper.getDEFECT_PART_List(params);
	  }

	  @Override
	  public List<EgovMap> getDEFECT_CODE_List(Map<String, Object> params) {
	    return ASManagementListMapper.getDEFECT_CODE_List(params);
	  }
}
