package com.coway.trust.biz.logistics.pointofsales.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.pointofsales.PointOfSalesService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("PointOfSalesService")
public class PointOfSalesServiceImpl extends EgovAbstractServiceImpl implements PointOfSalesService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "PointOfSalesMapper")
	private PointOfSalesMapper PointOfSalesMapper;

	@Override
	public List<EgovMap> PosSearchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return PointOfSalesMapper.PosSearchList(params);
	}
	
	@Override
	public List<EgovMap> PosItemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return PointOfSalesMapper.PosItemList(params);
	}
	
	@Override
	public List<EgovMap>  selectPointOfSalesSerial(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return PointOfSalesMapper.selectPointOfSalesSerial(params);
	}

	@Override
	public String insertPosInfo(Map<String, Object> params) {
		logger.debug("    에이작스 전!!!!!!!!! : {}");
		String seq = PointOfSalesMapper.selectPosSeq();
		
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);	
		
		formMap.put("reqno", formMap.get("headtitle") + seq);
		formMap.put("userId", params.get("userId"));
		String posSeq=formMap.get("headtitle") + seq;
		
		logger.debug("시리얼 입력전!!!!!!     ::::: : {}", posSeq);
		
		
		//PointOfSalesMapper.insOtherReceiptHead(formMap);

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
				insMap.put("reqno", formMap.get("headtitle") + seq);
				insMap.put("userId", params.get("userId"));
			//	PointOfSalesMapper.insRequestItem(insMap);
			}
		}
		
		logger.debug("    에이작스 후!!!!!!!!!!!!! : {}");
		return posSeq;

	}
	
	
	@Override
	public void insertSerial(Map<String, Object> params) {
		logger.debug("    에이작스 전!!!!!!!!! : {}");	
		
		Map<String, Object> form1Map = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);	
		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

		if (serialList.size() > 0) {
			for (int i = 0; i < serialList.size(); i++) {
				Map<String, Object> serialMap = (Map<String, Object>) serialList.get(i);
				//serialMap.put("reqno", posSeq);
				serialMap.put("userId", params.get("userId"));
				
				//logger.debug("posSeq 시리얼 입력후!!!     ::::: : {}", posSeq);
			//	PointOfSalesMapper.insRequestItem(insMap);
			}
		}

	}
	
	
	
	
	
	
	
	
	
}
