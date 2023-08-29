package com.coway.trust.biz.services.as.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiDto;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiForm;
import com.coway.trust.api.mobile.payment.payment.PaymentForm;
import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiForm;
import com.coway.trust.api.mobile.services.as.SyncIhrApiForm;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyDto;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.payment.service.impl.PaymentApiMapper;
import com.coway.trust.biz.services.as.AsFromCodyApiService;
import com.coway.trust.biz.services.as.IhrApiService;
import com.coway.trust.biz.services.as.ServiceApiASDetailService;
import com.coway.trust.biz.services.as.ServiceApiASService;
import com.coway.trust.biz.services.as.ServiceMileageApiService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("serviceMileageApiService")
public class ServiceMileageApiServiceImpl extends EgovAbstractServiceImpl implements ServiceMileageApiService {

  @Resource(name = "serviceMileageApiServiceMapper")
  private ServiceMileageApiServiceMapper serviceMileageApiServiceMapper;

  @Autowired
  private LoginMapper loginMapper;

  private static final Logger logger = LoggerFactory.getLogger(AsFromCodyApiServiceImpl.class);

  @SuppressWarnings("unchecked")
  @Override
  public List<EgovMap> checkInMileage(Map<String, Object> params) {
    // STEP 1 : VERIFY MASTER TABLE TO GET MASTER MILEAGE CLAIM NO
    EgovMap mileageClaimNo = serviceMileageApiServiceMapper.getMileageClaimNo(params);

    EgovMap userID_SYS47 = loginMapper.selectUserByUserName(params.get("userName").toString());
    EgovMap userID_ORG01 =loginMapper.selectOrgUserByUserName(params.get("userName").toString());

    params.put("userID_SYS47", userID_SYS47.get("userId"));
    params.put("userID_ORG01", userID_ORG01.get("memId"));

    if (mileageClaimNo == null) {
      String masterMileageClaimNo = CommonUtils.nvl(serviceMileageApiServiceMapper.getMasterMileageClaimNo());
      params.put("MIL_CLM_NO", masterMileageClaimNo);

      // CREATE MASTER RECORD
      int insertMasterClaimRecord = serviceMileageApiServiceMapper.insertMasterClaimRecord(params);
      logger.debug(" = checkInMileage = MASTER RECORD INSERTED : " + insertMasterClaimRecord);

      // CREATE STARTING POINT
      // 1. GET MEMBER BRANCH > LONGTITUDE & LATITUDE
      EgovMap branchLocation = serviceMileageApiServiceMapper.getBranchLocation(params);
      params.put("branchID", branchLocation.get("brnchId"));
      params.put("branchCode", branchLocation.get("code"));
      params.put("dscLongtitude", branchLocation.get("longtitude"));
      params.put("dscLatitude", branchLocation.get("latitude"));

      int insertSubDSCMileageClaim = serviceMileageApiServiceMapper.insertSubDSCMileageClaim(params);
      logger.debug(" = checkInMileage = SUB RECORD DSC INSERTED : " + insertSubDSCMileageClaim);
    } else {
      params.put("MIL_CLM_NO", CommonUtils.nvl(mileageClaimNo.get("milClmNo")));
    }

    // STEP 2 : INSERT SUB TABLE
    int updateExistingSubMileageClaim = serviceMileageApiServiceMapper.updateExistingSubMileageClaim(params);
    logger.debug(" = checkInMileage = SUB RECORD UPDATED : " + updateExistingSubMileageClaim);

    int insertSubMileageClaim = serviceMileageApiServiceMapper.insertSubMileageClaim(params);
    logger.debug(" = checkInMileage = SUB RECORD INSERTED : " + insertSubMileageClaim);

    EgovMap returnParam = new EgovMap();
    if (insertSubMileageClaim > 0) {
      returnParam.put("status", true);
      logger.debug(" = returnParam  : " + returnParam.toString());
    } else {
      returnParam.put("status", false);
      logger.debug(" = returnParam  : " + returnParam.toString());
    }

    List<EgovMap> returnPrm = new ArrayList<>();
    returnPrm.add(returnParam);

    return returnPrm;
  }

}
