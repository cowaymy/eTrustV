package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("serviceMileageApiServiceMapper")
public interface ServiceMileageApiServiceMapper {

  EgovMap getMileageClaimNo(Map<String, Object> params);

  int getMasterMileageClaimNo();

  int insertMasterClaimRecord(Map<String, Object> params);

  int updateExistingSubMileageClaim(Map<String, Object> params);

  int insertSubMileageClaim(Map<String, Object> params);

  List<EgovMap> checkInMileage(Map<String, Object> params);

  EgovMap getBranchLocation(Map<String, Object> params);

  int insertSubDSCMileageClaim(Map<String, Object> params);

}
