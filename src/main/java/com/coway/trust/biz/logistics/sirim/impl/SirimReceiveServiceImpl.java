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

import com.coway.trust.biz.logistics.sirim.SirimReceiveService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SirimReceiveService")
public class SirimReceiveServiceImpl extends EgovAbstractServiceImpl implements SirimReceiveService {

	private static final Logger Logger = LoggerFactory.getLogger(SirimReceiveServiceImpl.class);

	@Resource(name = "SirimReceiveMapper")
	private SirimReceiveMapper SirimReceiveMapper;

	@Override
	public List<EgovMap> receiveWarehouseList(Map<String, Object> params) {
		return SirimReceiveMapper.receiveWarehouseList(params);
	}

	@Override
	public List<EgovMap> selectReceiveList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimReceiveMapper.selectReceiveList(params);
	}
	
	@Override
	public List<EgovMap> detailReceiveList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimReceiveMapper.detailReceiveList(params);
	}
	
	
	@Override
	public List<EgovMap> getSirimReceiveInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimReceiveMapper.getSirimReceiveInfo(params);
	}
	
	

}
