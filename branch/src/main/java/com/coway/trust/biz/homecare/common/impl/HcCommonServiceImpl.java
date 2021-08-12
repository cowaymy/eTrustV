/**
 *
 */
package com.coway.trust.biz.homecare.common.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.common.HcCommonService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcCommonService")
public class HcCommonServiceImpl extends EgovAbstractServiceImpl implements HcCommonService {

	//private static Logger logger = LoggerFactory.getLogger(HcCommonServiceImpl.class);

	@Resource(name = "hcCommonMapper")
	private HcCommonMapper hcCommonMapper;

	@Override
	public List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception {

		return hcCommonMapper.selectSearchOrderNo(params);
	}



}
