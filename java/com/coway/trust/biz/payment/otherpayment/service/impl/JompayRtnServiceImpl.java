package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.otherpayment.service.JompayRtnService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("jompayRtnService")
public class JompayRtnServiceImpl extends EgovAbstractServiceImpl implements JompayRtnService {

	@Resource(name = "jompayRtnMapper")
	private JompayRtnMapper jompayRtnMapper;

	private static final Logger LOGGER = LoggerFactory.getLogger(JompayRtnServiceImpl.class);

  @Override
  public List<EgovMap> selectJompayRtnList(Map<String, Object> params) {
    return jompayRtnMapper.selectJompayRtnList(params);
  }

  @Override
  public List<EgovMap> selectJompayRtnDetailsList(Map<String, Object> params) {
    return jompayRtnMapper.selectJompayRtnDetailsList(params);
  }

}
