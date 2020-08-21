package com.coway.trust.biz.payment.payment.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.payment.cashMatching.CashMatchingForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.payment.service.CashMatchingApiService;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CashMatchingApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 19.   KR-HAN        First creation
 * </pre>
 */
@Service("cashMatchingApiService")
public class CashMatchingApiServiceImpl extends EgovAbstractServiceImpl implements CashMatchingApiService {

  @Resource(name = "cashMatchingMapper")
  private CashMatchingMapper cashMatchingMapper;

  @Autowired
  private LoginMapper loginMapper;

  private static final Logger logger = LoggerFactory.getLogger(CashMatchingApiServiceImpl.class);

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 10. 19.
   * @param params
   * @return
   * @see com.coway.trust.biz.payment.payment.service.CashMatchingApiService#selectCashMatching(java.util.Map)
   */
  public List<EgovMap> selectCashMatching(Map<String, Object> params) {

    params.put("_USER_ID", params.get("userId"));
    LoginVO loginVO = loginMapper.selectLoginInfoById(params);
    params.put("userId", loginVO.getUserId());

    return cashMatchingMapper.selectCashMatching(params);
  }

  /**
   * TO-DO Description
   *
   * @Author KR-HAN
   * @Date 2019. 10. 19.
   * @param cashMatchingForm
   * @return
   * @throws Exception
   * @see com.coway.trust.biz.payment.payment.service.CashMatchingApiService#saveCashMatching(java.util.List)
   */
  @Override
  public int saveCashMatching(List<CashMatchingForm> cashMatchingForm) throws Exception {

    int rtn = 0;
    CashMatchingForm cashMatching = new CashMatchingForm();

    for (CashMatchingForm cashMatchingSer : cashMatchingForm) {

      Map<String, Object> params = cashMatching.createMap(cashMatchingSer);

      params.put("_USER_ID", params.get("userId"));

      LoginVO loginVO = loginMapper.selectLoginInfoById(params);

      params.put("updUserId", loginVO.getUserId());
      cashMatchingMapper.updateCashMatching(params);
    }

    return rtn;
  }
}
