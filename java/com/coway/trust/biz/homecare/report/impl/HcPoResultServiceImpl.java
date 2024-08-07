/**
 *
 */
package com.coway.trust.biz.homecare.report.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.report.HcPoResultService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcPoResultService")
public class HcPoResultServiceImpl extends EgovAbstractServiceImpl implements HcPoResultService {

	//private static Logger logger = LoggerFactory.getLogger(HcPoResultServiceImpl.class);

	@Resource(name = "hcPoResultMapper")
	private HcPoResultMapper hcPoResultMapper;

	@Override
	public int selecthcPoResultGropListCnt(Map<String, Object> params) throws Exception{
		return hcPoResultMapper.selecthcPoResultGropListCnt(params);
	}
	@Override
	public List<EgovMap> selecthcPoResultGropList(Map<String, Object> params) throws Exception{
		return hcPoResultMapper.selecthcPoResultGropList(params);
	}

	@Override
	public int selecthcPoResultMainListCnt(Map<String, Object> params) throws Exception{
		return hcPoResultMapper.selecthcPoResultMainListCnt(params);
	}
	@Override
	public List<EgovMap> selecthcPoResultMainList(Map<String, Object> params) throws Exception{
		return hcPoResultMapper.selecthcPoResultMainList(params);
	}

	@Override
	public List<EgovMap> selecthcPoResultSubList(Map<String, Object> params) throws Exception{
		return hcPoResultMapper.selecthcPoResultSubList(params);
	}


}