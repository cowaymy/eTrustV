package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.pos.PosService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("posService")
public class PosServiceImpl implements PosService {

	private static final Logger logger = LoggerFactory.getLogger(PosServiceImpl.class);
	
	@Resource(name = "posMapper")
	private PosMapper posMapper;
	
	@Override
	public List<EgovMap> selectWhList() {
		
		return posMapper.selectWhList();
	}

	@Override
	public List<EgovMap> selectPosJsonList(Map<String, Object> params) {
		
		return posMapper.selectPosJsonList(params);
	}

	@Override
	public EgovMap selectPosViewPurchaseInfo(Map<String, Object> params) {
		
		return posMapper.selectPosViewPurchaseInfo(params);
	}

	@Override
	public List<EgovMap> selectPosDetailJsonList(Map<String, Object> params) {
		
		return posMapper.selectPosDetailJsonList(params);
	}

	@Override
	public EgovMap selectPosViewPayInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return posMapper.selectPosViewPayInfo(params);
	}

	@Override
	public List<EgovMap> selectPosPaymentJsonList(Map<String, Object> params) {
		
		return posMapper.selectPosPaymentJsonList(params);
	}
	
	
}
