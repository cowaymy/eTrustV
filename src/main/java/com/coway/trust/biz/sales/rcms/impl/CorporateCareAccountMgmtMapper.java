package com.coway.trust.biz.sales.rcms.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileGroupVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("corporateCareAccountMgmtMapper")
public interface CorporateCareAccountMgmtMapper {

	List<EgovMap> selectPortalList(Map<String, Object> params);

	List<EgovMap> selectPortalNameList(Map<String, Object> params);

	List<EgovMap> selectPortalStusList();

	List<EgovMap> selectPICList();

	List<EgovMap> selectCareAccMgmtList(Map<String, Object> params);

	EgovMap selectPortalDetails(Map<String, Object> params);

	void insertFileDetail(Map<String, Object> flInfo);

	void insertFileGroup(FileGroupVO fileGroupVO);

	int selectNextFileId();

	void addPortal(Map<String, Object> params);

	void updatePortal(Map<String, Object> params);

	EgovMap selectDocNo(String code);

	void updateDocNo(Map<String, Object> params);

	void updatePortalStatus(Map<String, Object> params);


}
