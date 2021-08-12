package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.pos.PosOthService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("posOthService")
public class PosOthServiceImpl extends EgovAbstractServiceImpl implements PosOthService {

	
	@Resource(name = "posOthMapper")
	private PosOthMapper posOthMapper;
	
	
	@Override
	public List<EgovMap> selectPOthItmTypeList() throws Exception {
		
		return posOthMapper.selectPOthItmTypeList();
	}


/*	@Override
	public List<EgovMap> selectPOthItmList(Map<String, Object> params) throws Exception {
		
		return posOthMapper.selectPOthItmList(params);	
	}*/


	@Override
	public Boolean chkAllowSalesKeyInPrc(Map<String, Object> params) throws Exception {
		
		int rtnVal = 0;
		
		rtnVal = posOthMapper.chkAllowSalesKeyInPrc(params);
		
		if(rtnVal > 0){
			return true;
		}else{
			return false;
		}
	}


	@Override
	public EgovMap posReversalOthDetail(Map<String, Object> params) throws Exception {
		
		return posOthMapper.posReversalOthDetail(params);
	}


	@Override
	public EgovMap getAddressDetails(Map<String, Object> params) throws Exception {
		
		return posOthMapper.getAddressDetails(params);
	}
}
