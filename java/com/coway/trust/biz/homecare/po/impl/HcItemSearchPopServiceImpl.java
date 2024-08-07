/**
 *
 */
package com.coway.trust.biz.homecare.po.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.po.HcItemSearchPopService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcItemSearchPopService")
public class HcItemSearchPopServiceImpl extends EgovAbstractServiceImpl implements HcItemSearchPopService {

	//private static Logger logger = LoggerFactory.getLogger(HcItemSearchPopServiceImpl.class);

	@Resource(name = "hcItemSearchPopMapper")
	private HcItemSearchPopMapper hcItemSearchPopMapper;

	@Override
	public List<EgovMap> selectHcItemSearch(Map<String, Object> params) throws Exception{
		return hcItemSearchPopMapper.selectHcItemSearch(params);
	}

}
