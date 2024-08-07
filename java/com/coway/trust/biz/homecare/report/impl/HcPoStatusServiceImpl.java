/**
 *
 */
package com.coway.trust.biz.homecare.report.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.report.HcPoStatusService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcPoStatusService")
public class HcPoStatusServiceImpl extends EgovAbstractServiceImpl implements HcPoStatusService {

	//private static Logger logger = LoggerFactory.getLogger(HcPoStatusServiceImpl.class);

	@Resource(name = "hcPoStatusMapper")
	private HcPoStatusMapper hcPoStatusMapper;

	@Override
	public int selectHcPoStatusMainListCnt(Map<String, Object> params) throws Exception{
		return hcPoStatusMapper.selectHcPoStatusMainListCnt(params);
	}
	@Override
	public List<EgovMap> selectHcPoStatusMainList(Map<String, Object> params) throws Exception{
		return hcPoStatusMapper.selectHcPoStatusMainList(params);
	}
}