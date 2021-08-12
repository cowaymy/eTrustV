/**
 *
 */
package com.coway.trust.biz.homecare.po.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.po.HcDeliveryGrSearchPopService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcDeliveryGrSearchPopService")
public class HcDeliveryGrSearchPopServiceImpl extends EgovAbstractServiceImpl implements HcDeliveryGrSearchPopService {

	@Resource(name = "hcDeliveryGrSearchPopMapper")
	private HcDeliveryGrSearchPopMapper hcDeliveryGrSearchPopMapper;


	@Override
	public List<EgovMap> selectDeliveryGrSearchPop(Map<String, Object> params) throws Exception{
		return hcDeliveryGrSearchPopMapper.selectDeliveryGrSearchPop(params);
	}
}