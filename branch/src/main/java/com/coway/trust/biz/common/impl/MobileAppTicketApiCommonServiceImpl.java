/*
\ * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.common.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;

import opennlp.tools.util.StringUtil;

/**
 * @ClassName : MobileAppTicketApiCommonServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 10.   KR-HAN        First creation
 * 2020. 04. 09.   MY-ONGHC    Add getCustNm
 *          </pre>
 */
@Service("mobileAppTicketApiCommonService")
public class MobileAppTicketApiCommonServiceImpl implements MobileAppTicketApiCommonService {

  private static final Logger LOGGER = LoggerFactory.getLogger(MobileAppTicketApiCommonServiceImpl.class);

  @Resource(name = "mobileAppTicketApiCommonMapper")
  private MobileAppTicketApiCommonMapper mobileAppTicketApiCommonMapper;

  @Autowired
  private LoginMapper loginMapper;

  /**
   * saveMobileAppTicket
   *
   * @Author KR-HAN
   * @Date 2019. 10. 11.
   * @param params
   * @return
   * @throws Exception
   * @see com.coway.trust.biz.common.MobileAppTicketApiCommonService#saveMobileAppTicket(java.util.Map)
   *      Mobile
   */
  @Override
  public int saveMobileAppTicket(List<Map<String, Object>> arrParams) {
    if (LOGGER.isInfoEnabled()) {
      LOGGER.info("++++ saveMobileAppTicket params.toString() ::" + arrParams.toString());
    }

    int mobTicketNo = 0;

    if (StringUtil.isEmpty(String.valueOf(arrParams.get(0).get("userId")))) {
      throw new ApplicationException(AppConstants.FAIL, "User Id value does not exist.");
    }

    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put("_USER_ID", String.valueOf(arrParams.get(0).get("userId")));
    LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);

    for (int i = 0; i < arrParams.size(); i++) {
      Map<String, Object> params = arrParams.get(i);
      String salesOrdNo = String.valueOf(params.get("salesOrdNo"));
      String ticketTypeId = String.valueOf(params.get("ticketTypeId"));
      String ticketStusId = String.valueOf(params.get("ticketStusId"));

      params.put("crtUserBrnch", loginVO.getUserBranchId());
      params.put("crtUserId", loginVO.getUserId());
      params.put("updUserId", loginVO.getUserId());

      if (StringUtil.isEmpty(salesOrdNo)) {
        throw new ApplicationException(AppConstants.FAIL, "Order Number value does not exist.");
      }

      if (StringUtil.isEmpty(ticketTypeId)) {
        throw new ApplicationException(AppConstants.FAIL, "The Mobile Ticket Type value does not exist.");
      }

      if (StringUtil.isEmpty(ticketStusId)) {
        ticketStusId = "1"; // SYS0038M / 1 : Active
      }

      if (i == 0 || mobTicketNo == 0) { // 값이 없을 경우 저장
        mobTicketNo = mobileAppTicketApiCommonMapper.selectMobTicketNo();
        params.put("mobTicketNo", mobTicketNo);
      } else {
        params.put("mobTicketNo", mobTicketNo);
      }

      mobileAppTicketApiCommonMapper.insert(params);
    }
    return mobTicketNo;
  }

  /**
   * updateMobileAppTicket
   *
   * @Author KR-JAEMJAEM:)
   * @Date 2019. 10. 28.
   * @param List<Map<String,
   *          Object>>
   * @return int
   * @throws Exception
   * @see com.coway.trust.biz.common.MobileAppTicketApiCommonService#updateMobileAppTicket(java.util.Map)
   *      eTRUST System
   */
  @Override
  public int updateMobileAppTicket(List<Map<String, Object>> arrParams) {
    int updateCnt = 0;

    if (StringUtil.isEmpty(String.valueOf(arrParams.get(0).get("userId")))) {
      throw new ApplicationException(AppConstants.FAIL, "User Id value does not exist.");
    }
    for (int i = 0; i < arrParams.size(); i++) {
      Map<String, Object> params = arrParams.get(i);
      if (StringUtil.isEmpty(String.valueOf(params.get("mobTicketNo")))) {
        throw new ApplicationException(AppConstants.FAIL, "Mobile Ticket Number value does not exist.");
      }
      if (StringUtil.isEmpty(String.valueOf(params.get("ticketStusId")))) {
        throw new ApplicationException(AppConstants.FAIL, "Ticket Status value does not exist.");
      }
      params.put("updUserId", arrParams.get(0).get("userId"));
      updateCnt = mobileAppTicketApiCommonMapper.update(params);
    }

    return updateCnt;
  }

  @Override
  public String getCustNm(Map<String, Object> params) {
    return mobileAppTicketApiCommonMapper.getCustNm(params);
  }
}
