/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.homecare.sales.order.impl.HcOrderRegisterMapper;
import com.coway.trust.biz.sales.mambership.KeyinConfigService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("keyinConfigService")
public class KeyinConfigServiceImpl extends EgovAbstractServiceImpl implements KeyinConfigService {

	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "keyinConfigMapper")
	private KeyinConfigMapper stockMapper;

  	@Resource(name = "hcOrderRegisterMapper")
  	private HcOrderRegisterMapper hcOrderRegisterMapper;

	@Override
	public List<EgovMap> selectkeyinConfigList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectkeyinConfigList(params);
	}

	@Override
	public int updateAllowSalesStatus(Map<String, Object> params,  SessionVO sessionVO) throws Exception {
		int rtnCnt = 0;

		try {
		params.put("updUserId", sessionVO.getUserId());
		stockMapper.updateAllowSalesStatus(params);

	}catch (Exception e) {
		throw new ApplicationException(AppConstants.FAIL,  "Status updated Failed.");
	}
		return rtnCnt;
	}

}
