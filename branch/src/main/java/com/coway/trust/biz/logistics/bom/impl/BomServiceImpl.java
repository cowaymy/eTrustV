package com.coway.trust.biz.logistics.bom.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.bom.BomService;
import com.coway.trust.biz.logistics.courier.impl.CourierServiceImpl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("bomService")
public class BomServiceImpl extends EgovAbstractServiceImpl implements BomService {
	private static final Logger logger = LoggerFactory.getLogger(CourierServiceImpl.class);

	@Resource(name = "bomMapper")
	private BomMapper bomMapper;

	@Override
	public List<EgovMap> selectCdcList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bomMapper.selectCdcList(params);
	}

	@Override
	public List<EgovMap> selectBomList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bomMapper.selectBomList(params);
	}

	@Override
	public List<EgovMap> materialInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bomMapper.materialInfo(params);
	}

	@Override
	public List<EgovMap> filterInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bomMapper.selectBomList(params);
	}

	@Override
	public List<EgovMap> spareInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bomMapper.selectBomList(params);
	}

	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return bomMapper.selectCodeList(params);
	}

	@Override
	public void modifyLeadTmOffset(Map<String, Object> params) {
		List<Object> updList = (List)params.get("upd");
		
		if (updList.size() > 0){
			for (int i = 0 ; i < updList.size() ; i++){
	    		Map<String, Object> updMap = (Map<String, Object>) updList.get(i);
	    		bomMapper.modifyLeadTmOffset(updMap);
			}
		}
	}

}
