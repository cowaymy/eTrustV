/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.sirim.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.sirim.SirimService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SirimService")
public class SirimServiceImpl extends EgovAbstractServiceImpl implements SirimService {

	private static final Logger Logger = LoggerFactory.getLogger(SirimServiceImpl.class);

	@Resource(name = "SirimMapper")
	private SirimMapper SirimMapper;
	
	@Override
	public List<EgovMap> selectWarehouseList(Map<String, Object> params) {
		return SirimMapper.selectWarehouseList(params);
	}
	
	@Override
	public List<EgovMap> selectSirimList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimMapper.selectSirimList(params);
	}

	
}
