package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MemberHospitalizeService {

	List<EgovMap> selectHospitalizeUploadList(Map<String, Object> params);

	List<EgovMap> selectHospitalizeDetails(Map<String, Object> params);

	int cntUploadBatch(Map<String, Object> params);

	int insertHospitalizeMaster(Map<String, Object> params);

  void insertHospitalizeDetails(Map<String, Object> params);

  void callCnfmHsptalize(Map<String, Object> params);

  void deactivateHspitalize(Map<String, Object> params);



}
