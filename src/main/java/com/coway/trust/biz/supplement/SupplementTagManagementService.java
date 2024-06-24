package com.coway.trust.biz.supplement;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementTagManagementService {

	List<EgovMap> selectTagManagementList( Map<String, Object> params ) throws Exception;

	List<EgovMap> selectTagStus();

	List<EgovMap> getMainTopicList();

	List<EgovMap> getInchgDeptList();

	List<EgovMap> getSubTopicList(Map<String, Object> params);

	List<EgovMap> getSubDeptList(Map<String, Object> params);

	EgovMap selectOrderBasicInfo( Map<String, Object> params ) throws Exception;

	EgovMap searchOrderBasicInfo(Map<String, Object> params);

	EgovMap selectViewBasicInfo( Map<String, Object> params ) throws Exception;

}
