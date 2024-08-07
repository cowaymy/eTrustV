package com.coway.trust.biz.homecare.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 11/12/2019    KR-JIN      1.0.0       - Restructure File
 *********************************************************************************************/

@Mapper("hcASManagementListMapper")
public interface HcASManagementListMapper {
	public String getSearchDtRange() throws Exception;
	public List<EgovMap> selectAsTyp() throws Exception;
	public List<EgovMap> selectAsStat() throws Exception;
	public List<EgovMap> selectHomeCareBranchWithNm() throws Exception;
	public List<EgovMap> selectCTByDSC(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectCTByDSCSearch(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectCTByDSCSearch2(Map<String, Object> params) throws Exception;
	public List<EgovMap> getErrMstList(Map<String, Object> params) throws Exception;

	List<EgovMap> getErrDetilList(Map<String, Object> params);

	public List<EgovMap> selectASManagementList(Map<String, Object> params) throws Exception;

	public EgovMap selectOrderBasicInfo(Map<String, Object> params) throws Exception;

	public List<EgovMap> getASHistoryList(Map<String, Object> params) throws Exception;
	public List<EgovMap> getBSHistoryList(Map<String, Object> params) throws Exception;

	public List<EgovMap> getBrnchId(Map<String, Object> params) throws Exception;

	public List<EgovMap> assignCtList(Map<String, Object> params) throws Exception;
	public List<EgovMap> assignCtOrderList(Map<String, Object> params) throws Exception;

	public List<EgovMap> getASFilterInfo(Map<String, Object> params) throws Exception;
	public List<EgovMap> getASFilterInfoOld(Map<String, Object> params) throws Exception;

	public List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params) throws Exception;

	public List<EgovMap> getASRulstEditFilterInfo(Map<String, Object> params) throws Exception;

	public int updateAssignCT(Map<String, Object> params) throws Exception;

	public List<EgovMap> selectLbrFeeChr(Map<String, Object> params) throws Exception;

	// serial Y/N check
	public String selectSerialYnSearch(Map<String, Object> params) throws Exception;

	/*public List<EgovMap> selectHTAndDTCode() throws Exception;

  //HomeCare-As Entry
  public int hcChkRcdTms(Map<String, Object> params) throws Exception;*/

	public EgovMap selectBrnchType(Map<String, Object> params) throws Exception;

	List<EgovMap> getAsDefectEntry(Map<String, Object> params);

	public List<EgovMap> getPartnerMemInfo(Map<String, Object> params);


}