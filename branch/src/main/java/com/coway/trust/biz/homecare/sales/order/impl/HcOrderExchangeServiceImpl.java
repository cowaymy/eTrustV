package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.sales.order.HcOrderExchangeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderExchangeServiceImpl.java
 * @Description : Homecare Order Exchange ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 31.   KR-SH        First creation
 * </pre>
 */
@Service("hcOrderExchangeService")
public class HcOrderExchangeServiceImpl extends EgovAbstractServiceImpl implements HcOrderExchangeService {

  	@Resource(name = "hcOrderExchangeMapper")
  	private HcOrderExchangeMapper hcOrderExchangeMapper;

	/**
	 * Homecare Order Exchange List 데이터조회
	 * @Author KR-SH
	 * @Date 2019. 10. 31.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderExchangeService#hcOrderExchangeList(java.util.Map)
	 */
	@Override
	public List<EgovMap> hcOrderExchangeList(Map<String, Object> params) {
		return hcOrderExchangeMapper.hcOrderExchangeList(params);
	}

}
